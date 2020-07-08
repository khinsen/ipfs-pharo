"
!Storage of a Pillar document in IPFS
"
Class {
	#name : #IpfsDocument,
	#superclass : #Object,
	#instVars : [
		'name',
		'text'
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
	^ aView explicit
		title: 'Document';
		priority: 1;
		disableAsync;
		stencil: [ GtDocumenter forIpfsDocument: self ];
		actionButtonIcon: BrGlamorousVectorIcons accept 
			tooltip: 'Save document' 
			action: [ :aToggle :aTab | aTab viewContentElement save ];
		actionToggleIcon: BrGlamorousIcons edit 
			tooltip: 'Show/Hide Markups'
			activated: [ :aToggle :aTab | aTab viewContentElement showMarkup ] 
			deactivated: [ :aToggle :aTab | aTab viewContentElement hideMarkup ];
		actionButtonIcon: BrGlamorousVectorIcons remove
			tooltip: 'Decrease font size'
			action: [ :aToggle :aTab | aTab viewContentElement decreaseNormalFontSize ];
		actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Increase font size'
			action: [ :aToggle :aTab | aTab viewContentElement increaseNormalFontSize ]
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
IpfsDocument >> store: aGtDocumenter [
	self text: aGtDocumenter text asString	
]

{ #category : #accessing }
IpfsDocument >> text [
	^ text
]

{ #category : #accessing }
IpfsDocument >> text: anObject [
	text := anObject
]
