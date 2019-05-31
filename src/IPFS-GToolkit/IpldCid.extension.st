Extension { #name : #IpldCid }

{ #category : #'*IPFS-GToolkit' }
IpldCid >> gtCidDataFor: aView [
	<gtView>
	^ aView columnedList
		title: 'CID';
		priority: -10;
		items: [ {	#Base32 -> cidBase32.
						#Version -> self version.
						#Codec -> self codec.
						#'Hash function' -> self hashFunction.
						#'Hash length' -> self hashLength } ];
		column: 'Key' item: [ :aField | aField key ];
		column: 'Value' item: [ :aField | aField value ];
		send: [ :aField | aField value ].
]

{ #category : #'*IPFS-GToolkit' }
IpldCid >> gtDataFor: aView [
	<gtView>
	| view |
	view := self load ipldDataViewFor: aView.
	^ view
		title: 'Data';
		priority: -6;
		yourself.

]

{ #category : #'*IPFS-GToolkit' }
IpldCid >> gtDataTreeFor: aView [
	"<gtView>"
	^ aView tree
		title: 'Data';
		priority: -6;
		items: [ { self load } ];
		itemFormat: [ :item | item printString asRopedText ];
		children: [ :item |
						[ item associations ]
						on: MessageNotUnderstood
						do: [ (item isKindOf: Array) ifTrue: [ item ] ifFalse: [ Array new ] ] ];
		send: [ :item | (item isKindOf: Association) ifTrue: [ item value ] ifFalse: [ item ] ].
]

{ #category : #'*IPFS-GToolkit' }
IpldCid >> gtReferencesFor: aView [
	<gtView>
	^ aView list
		title: 'References';
		priority: -5;
		items: [ self references ];
		itemFormat: [ :aCid | aCid asString ].
]
