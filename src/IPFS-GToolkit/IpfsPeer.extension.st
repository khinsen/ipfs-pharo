Extension { #name : #IpfsPeer }

{ #category : #'*IPFS-GToolkit' }
IpfsPeer >> gtPinnedCidsFor: aView [
	<gtView>
	^ aView tree
		title: 'Pinned CIDs';
		priority: -4;
		items: [ self pinnedCidsOfType: #direct ];
		itemFormat: [ :aCid | aCid asString ].
]

{ #category : #'*IPFS-GToolkit' }
IpfsPeer >> gtStoredCidsFor: aView [
	<gtView>
	^ aView list
		title: 'Stored CIDs';
		priority: -5;
		items: [ self allCids ];
		itemFormat: [ :aCid | aCid asString ].
]
