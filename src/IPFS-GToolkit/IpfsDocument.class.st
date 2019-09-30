"
!Storage of a Pillar document in IPFS
"
Class {
	#name : #IpfsDocument,
	#superclass : #Object,
	#instVars : [
		'name',
		'text',
		'gtDocument'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #storing }
IpfsDocument class >> ipfsTag [
	^ #PillarDocument
]

{ #category : #'instance creation' }
IpfsDocument class >> name: aSymbol text: aString [
	^ self new
		name: aSymbol;
		text: aString;
		yourself
]

{ #category : #comparing }
IpfsDocument >> = other [
	^ self class = other class
		and: [ self name = other name
			and: [ self text = other text ] ]
]

{ #category : #accessing }
IpfsDocument >> basename [
	<return: #String>
	^ self name
]

{ #category : #accessing }
IpfsDocument >> evaluationReceiver [
	<return: #Object>
	^ nil
]

{ #category : #testing }
IpfsDocument >> exists [
	<return: #Boolean>
	^ true
]

{ #category : #inspecting }
IpfsDocument >> gtDocumentFor: aView [
	<gtView>
	^ (gtDocument gtTextFor: aView)
		title: name;
		priority: -1;
		action: [ :anAction | 
			gtDocument gtSaveActionFor: anAction ];
		action: [ :anAction | 
			gtDocument gtShowMarkupActionFor: anAction ]
]

{ #category : #comparing }
IpfsDocument >> hash [
	^ text hash xor: name hash
]

{ #category : #testing }
IpfsDocument >> isWikiPage [
	^ false
]

{ #category : #accessing }
IpfsDocument >> name [
	^ name
]

{ #category : #accessing }
IpfsDocument >> name: anObject [
	name := anObject
]

{ #category : #printing }
IpfsDocument >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(;
			  nextPutAll: self name;
			  nextPut: $).

]

{ #category : #actions }
IpfsDocument >> read: aGtDocument [ 
	aGtDocument text: self text
]

{ #category : #accessing }
IpfsDocument >> rootDirectory [
	<return: #FileReference>
	^ FileSystem workingDirectory

]

{ #category : #actions }
IpfsDocument >> store: aGtDocument [
	self text: aGtDocument text asString	
]

{ #category : #accessing }
IpfsDocument >> text [
	^ text
]

{ #category : #accessing }
IpfsDocument >> text: anObject [
	text := anObject.
	gtDocument :=
		GtDocument new
			 strategy:(IpfsDocumentStorageProvider new document: self);
			 read

]
