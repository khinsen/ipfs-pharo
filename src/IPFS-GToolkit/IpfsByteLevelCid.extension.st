Extension { #name : #IpfsByteLevelCid }

{ #category : #'*IPFS-GToolkit' }
IpfsByteLevelCid >> gtActionInspectObjectFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousIcons fromhere;
		priority: 30;
		action: [ :aButton | 
			aButton
				fireEvent:
					(GtPhlowObjectToSpawn new
						object: self loadObject;
						sourceElement: aButton) ]
]

{ #category : #'*IPFS-GToolkit' }
IpfsByteLevelCid >> gtCidDataFor: aView [
	<gtView>
	| cidData |
	cidData := self parse.
	^ aView columnedList
		title: 'CID';
		priority: -10;
		items: [ {	#Base32 -> (self encodeInBase: #base32).
						#Version -> (cidData at: #version).
						#Codec -> (cidData at: #codec).
"						#'Hash function' -> self hashFunction.
						#'Hash length' -> self hashLength.
"						 } ];
		column: 'Key' item: [ :aField | aField key ];
		column: 'Value' item: [ :aField | aField value ];
		send: [ :aField | aField value ].
]

{ #category : #'*IPFS-GToolkit' }
IpfsByteLevelCid >> gtDataFor: aView [
	<gtView>	| view |
	view := self loadAndDecode ipfsDataViewFor: aView.
	^ view
		title: 'Data';
		priority: -6;
		yourself
]

{ #category : #'*IPFS-GToolkit' }
IpfsByteLevelCid >> gtDisplayOn: stream [
	"Override the implementation in class Collection that shows all elements"
	stream nextPutAll: self asString
]

{ #category : #'*IPFS-GToolkit' }
IpfsByteLevelCid >> gtReferencesFor: aView [
	<gtView>
	^ aView list
		title: 'References';
		priority: -5;
		items: [ self references ];
		itemFormat: [ :aCid | aCid asString ]

]
