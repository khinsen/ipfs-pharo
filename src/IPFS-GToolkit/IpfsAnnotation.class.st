"
!Link to an object retrieved from IPFS
"
Class {
	#name : #IpfsAnnotation,
	#superclass : #GtAnnotation,
	#instVars : [
		'displayedName',
		'referencedPath',
		'objectToPreview'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #accessing }
IpfsAnnotation class >> possibleParameters [
	^ {
		self constants ipfsPathParameterName.
		self constants nameParameterName.
		self constants expandedParameterName.
		self constants showParameterName.
		self constants heightParameterName.
		}
]

{ #category : #rendering }
IpfsAnnotation class >> tag [
	^ self constants ipfsAnnotationName
]

{ #category : #'private - actions' }
IpfsAnnotation >> browseReferenceFrom: anEvent [
	anEvent modifiers isShift ifTrue: [ ^ self ].
	anEvent target fireEvent: (GtPhlowObjectToSpawn new 
		object: self referencedPath loadObject;
		sourceElement: anEvent target)
]

{ #category : #accessing }
IpfsAnnotation >> displayedName [
	^ displayedName ifNil: [ displayedName := 
		self utility 
			valueOf: self constants nameParameterName
			in: self parameters 
			value: [ :aValue | aValue ] 
			emptyValue: [ self referencedPath asString ] 
			defaultValue: [ self referencedPath asString ] ]
]

{ #category : #testing }
IpfsAnnotation >> doesReferenceExist [
	^ true
]

{ #category : #testing }
IpfsAnnotation >> isPreviewDefined [
	^ true
]

{ #category : #accessing }
IpfsAnnotation >> objectToPreview [
	^ objectToPreview ifNil:
	 	[	objectToPreview := self referencedPath loadObjectInBackground ].

]

{ #category : #accessing }
IpfsAnnotation >> referencedPath [
	^ referencedPath ifNil: [ referencedPath := 
		self utility 
			valueOf: self constants ipfsPathParameterName
			in: self parameters 
			value: [ :aValue | IpfsPath fromString: aValue ] 
			emptyValue: [ nil ] 
			defaultValue: [ nil ] ]
]

{ #category : #'api - style' }
IpfsAnnotation >> styleTextWithMarkup: aBlRope [
	super styleTextWithMarkup: aBlRope.
	self styleLinkInText: aBlRope.
	(self nodeStyler: aBlRope)
		name: self displayedName;
		spawnObject: self objectToPreview;
		linkButton.
	self styleExpandingPreviewInText: aBlRope
]

{ #category : #'api - style' }
IpfsAnnotation >> styleTextWithoutMarkup: aBlRope [
	self styleTextWithMarkup: aBlRope.
	super styleTextWithoutMarkup: aBlRope.
	(self nodeStyler: aBlRope) autoHideNode.
]
