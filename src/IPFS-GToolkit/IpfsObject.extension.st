Extension { #name : #IpfsObject }

{ #category : #'*IPFS-GToolkit' }
IpfsObject >> gtDataFor: aView [
	<gtView>
	| view |
	view := self data ipldDataViewFor: aView.
	^ view
		title: 'Data';
		priority: -10;
		yourself.

]

{ #category : #'*IPFS-GToolkit' }
IpfsObject >> gtLinksFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Links';
		priority: -9;
		items: [ self links associations ];
		column: 'Name' item: [ :link | link key ];
		column: 'Size' item: [ :link | link value dataSize ];
		column: 'CID' item: [ :link | link value cid asString ];
		send: [ :link | link value cid ].
]
