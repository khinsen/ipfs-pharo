Extension { #name : #IpfsPeer }

{ #category : #'*IPFS-GToolkit' }
IpfsPeer >> gtIndirectlyPinnedCidsFor: aView [
	<gtView>
	^ aView list
		title: 'Indirectly pinned CIDs';
		priority: -8;
		items: [ self pinnedCidsOfType: #indirect ];
		itemFormat: [ :aCid | aCid asString ].

]

{ #category : #'*IPFS-GToolkit' }
IpfsPeer >> gtPinnedCidsFor: aView [
	<gtView>
	^ aView list
		title: 'Pinned CIDs';
		priority: -10;
		items: [ self pinnedCidsOfType: #direct ];
		itemFormat: [ :aCid | aCid asString ].

]

{ #category : #'*IPFS-GToolkit' }
IpfsPeer >> gtRecursivelyPinnedCidsFor: aView [
	<gtView>
	^ aView list
		title: 'Recursively pinned CIDs';
		priority: -9;
		items: [ self pinnedCidsOfType: #recursive ];
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