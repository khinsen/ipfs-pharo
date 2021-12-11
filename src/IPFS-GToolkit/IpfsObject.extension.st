Extension { #name : #IpfsObject }

{ #category : #'*IPFS-GToolkit' }
IpfsObject >> gtDataFor: aView [
	<gtView>
	| view |
	view := self data ipfsDataViewFor: aView.
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
		  column: 'Name' text: [ :link | link key ];
		  column: 'Size' text: [ :link | link value dataSize ];
		  column: 'CID' text: [ :link | link value cid asString ];
		  send: [ :link | link value cid ]
]
