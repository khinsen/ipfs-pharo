Class {
	#name : #IpfsWorldMenu,
	#superclass : #Object,
	#category : #'IPFS-GToolkit'
}

{ #category : #'world menu' }
IpfsWorldMenu class >> activePapersCatalogWorldMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #IPFS)
		label: 'IPFS';
		order: 10.
	(aBuilder item: #IpfsTutorial)
		parent: #IPFS;
		order: 0;
		label: 'Tutorial';
		action: [ GtInspector openOn: IpfsTutorial ].

]
