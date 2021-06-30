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
	(aBuilder item: #IpfsLocalPeer)
		parent: #IPFS;
		order: 1;
		label: 'Local peer';
		action: [ GtInspector openOn: IpfsPeer local ]
]
