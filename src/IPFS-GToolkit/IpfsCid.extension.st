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
	^ (self embeddedViewShowing: [ self loadAndDecode ] For: aView)
		title: 'Data';
		priority: -6
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtDisplayOn: stream [
	"Override the implementation in class Collection that shows all elements"
	stream nextPutAll: self asString
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtRawBlockFor: aView [
	<gtView>
	^ (self embeddedViewShowing: [ self loadRawBlock ] For: aView)
		title: 'Raw block';
		priority: -5
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtReferencesFor: aView [
	<gtView>
	^ aView list
		title: 'References';
		priority: -4;
		items: [ self references ];
		itemFormat: [ :aCid | aCid asString ]

]
