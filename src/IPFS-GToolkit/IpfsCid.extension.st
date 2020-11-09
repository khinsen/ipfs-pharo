Extension { #name : #IpfsCid }

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> embeddedViewShowing: aBlock For: aView [
	^ aView explicit
		stencil: [ | aContainer dataView |
			aContainer := BlElement new
				margin: (BlInsets all: 20);
				background: Color white;
				look: BrShadowLook;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			dataView := aBlock value gtViewsFor: aView.
			dataView
				asElementDo: [ :aNewElement | aContainer addChild: aNewElement ].
			aContainer ]
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtActionInspectObjectFor: anAction [
	<gtAction>
	self isInLocalStorage ifFalse: [ ^ anAction noAction ].
	^ anAction button
		icon: BrGlamorousIcons spawn;
		tooltip: 'Inspect data object';
		priority: 30;
		action: [ :aButton | 
			aButton
				fireEvent:
					(GtPhlowObjectToSpawn new
						object: self loadObject;
						sourceElement: aButton) ]
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtActionLoadObjectFor: anAction [
	<gtAction>
	self isInLocalStorage ifTrue: [ ^ anAction noAction ].
	^ anAction button
		icon: BrGlamorousIcons fromcloud;
		tooltip: 'Load data';
		priority: 30;
		action: [ :aButton |
			self loadRaw.
			"Update all inspector views."
			aButton withAllParentsDo: [ :aParent | 
      		aParent class = GtInspector
      			ifTrue: [ aParent object: aParent object ] ] ]
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtCidDataFor: aView [
	<gtView>
	| cidData |
	cidData := self parse.
	^ aView columnedList
		title: 'CID';
		priority: -10;
		items: [ {(#Base32 -> (self encodeInBase: #base32)).
			(#Version -> (cidData at: #version)).
			(#Codec -> (cidData at: #codec)).
			(#'Hash function' -> (cidData at: #hashFunction)).
			(#'Hash length' -> (cidData at: #hashLength)).
			} ];
		column: 'Key' item: [ :aField | aField key ];
		column: 'Value' item: [ :aField | aField value ];
		send: [ :aField | aField value ]
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtDataFor: aView [
	<gtView>
	self isInLocalStorage ifFalse: [ ^ aView empty ].
	^ (self embeddedViewShowing: [ self loadJson ] For: aView)
		title: 'Data';
		priority: -6
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtDisplayOn: stream [
	"Override the implementation in class Collection that shows all elements"
	stream nextPutAll: self asString
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtFileSystemFor: aView [
	<gtView>
	self isInLocalStorage ifFalse: [ ^ aView empty ].
	self isUnixfsDirectory ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'File system';
		priority: -8;
		object: [ self asIpfsPath asFileReference ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtFilesFor: aView [
	<gtView>
	self isInLocalStorage ifFalse: [ ^ aView empty ].
	self isUnixfsDirectory ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Files';
		priority: -9;
		items: [ self unixfsDirectoryEntries ];
		send: [ :each | each at: #Cid ];
		column: 'Name' text: [ :each | each at: #Name ];
		column: 'Size' text: [ :each | each at: #Size ];
		column: 'Cid' text: [ :each | each at: #Cid ];
		yourself
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtRawBlockFor: aView [
	<gtView>
	self isInLocalStorage ifFalse: [ ^ aView empty ].
	^ (self embeddedViewShowing: [ self loadRaw ] For: aView)
		title: 'Raw block';
		priority: -5
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtReferencesFor: aView [
	<gtView>
	self isInLocalStorage ifFalse: [ ^ aView empty ].
	^ aView list
		title: 'References';
		priority: -4;
		items: [ self references ];
		itemText: [ :aCid | aCid asString ]
]
