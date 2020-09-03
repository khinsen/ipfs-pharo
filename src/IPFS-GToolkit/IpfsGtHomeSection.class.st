Class {
	#name : #IpfsGtHomeSection,
	#superclass : #GtHomeSection,
	#category : #'IPFS-GToolkit'
}

{ #category : #accessing }
IpfsGtHomeSection >> create [
	| sectionContainer cardContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'IPFS').
	cardContainer := self newCardsContainer.
	cardContainer addChild: self localPeerCard.
	cardContainer addChild:
		((self newWikiCardFor: (IpfsGToolkitData at: #Documentation))
			size: 120 @ 120 ;
			yourself).
	sectionContainer addChild: cardContainer.
	^ sectionContainer
]

{ #category : #accessing }
IpfsGtHomeSection >> localPeerCard [
	| stencil |
	stencil := GtToolButtonStencil new 
		title: 'IPFS Peer';
		icon: IpfsIcons ipfsLogo;
		action: [ :card | 
			self
				showSpaceWithTitle: 'IPFS Peer'
				with:
					(GtInspector createOn: IpfsPeer local)
				from: card ];
		description: 'Pinned data and IPNS keys on your device'.
	^ stencil create
]
