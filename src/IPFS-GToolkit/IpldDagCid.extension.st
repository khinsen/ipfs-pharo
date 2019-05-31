Extension { #name : #IpldDagCid }

{ #category : #'*IPFS-GToolkit' }
IpldDagCid >> gtDataFor: aView [
	<gtView>
	| view |
	view := self load ipldDataViewFor: aView.
	^ view
		title: 'Data';
		priority: -6;
		yourself.

]

{ #category : #'*IPFS-GToolkit' }
IpldDagCid >> gtRawDataFor: aView [
	<gtView>
	| view |
	view := self loadRawData ipldDataViewFor: aView.
	^ view
		title: 'Raw data';
		priority: -4;
		yourself.

]

{ #category : #'*IPFS-GToolkit' }
IpldDagCid >> gtReferencesFor: aView [
	<gtView>
	^ aView list
		title: 'References';
		priority: -5;
		items: [ self references ];
		itemFormat: [ :aCid | aCid asString ].
]
