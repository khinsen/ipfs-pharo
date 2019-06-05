"
!Link to an object retrieved from IPFS
"
Class {
	#name : #IpfsAnnotation,
	#superclass : #GtAnnotation,
	#instVars : [
		'referencedCid',
		'displayedName'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #accessing }
IpfsAnnotation class >> possibleParameters [
	^ {
		self constants ipfsCidParameterName.
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
		object: self referencedCid loadObject;
		sourceElement: anEvent target)
]

{ #category : #accessing }
IpfsAnnotation >> displayedName [
	^ displayedName ifNil: [ displayedName := 
		self utility 
			valueOf: self constants nameParameterName
			in: self parameters 
			value: [ :aValue | aValue ] 
			emptyValue: [ '/ipfs/', self referencedCid asString ] 
			defaultValue: [ '/ipfs/', self referencedCid asString ] ]
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
	^ self referencedCid loadObject
]

{ #category : #accessing }
IpfsAnnotation >> referencedCid [
	^ referencedCid ifNil: [ referencedCid := 
		self utility 
			valueOf: self constants ipfsCidParameterName
			in: self parameters 
			value: [ :aValue | IpfsCid fromString: aValue ] 
			emptyValue: [ nil ] 
			defaultValue: [ nil ] ]
]

{ #category : #'api - style' }
IpfsAnnotation >> styleTextWithMarkup: aBlRope [
	super styleTextWithMarkup: aBlRope.
	self styleLinkInText: aBlRope.
	(self nodeStyler: aBlRope)
		name: self displayedName;
		spawnObject: self referencedCid loadObject;
		linkButton.
	self styleExpandingPreviewInText: aBlRope
]

{ #category : #'api - style' }
IpfsAnnotation >> styleTextWithoutMarkup: aBlRope [
	self styleTextWithMarkup: aBlRope.
	super styleTextWithoutMarkup: aBlRope.
	(self nodeStyler: aBlRope) autoHideNode.
]
