"
!A world menu entry for IPFS
"
Class {
	#name : #IpfsWorldMenu,
	#superclass : #Object,
	#category : #'IPFS-GToolkit'
}

{ #category : #'world menu' }
IpfsWorldMenu class >> ipfsWorldMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #IPFS)
		label: 'IPFS';
		order: 10.
	(aBuilder item: #IpfsTutorial)
		parent: #IPFS;
		order: 0;
		withSeparatorAfter;
		label: 'Tutorial';
		action: [ GtInspector openOn: IpfsTutorial ].
	(aBuilder item: #IpfsLocalPeer)
		parent: #IPFS;
		order: 1;
		label: 'Local peer';
		action: [ GtInspector openOn: IpfsPeer local ]
]
