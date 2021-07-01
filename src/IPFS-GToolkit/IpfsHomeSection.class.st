Class {
	#name : #IpfsHomeSection,
	#superclass : #GtHomeSection,
	#category : #'IPFS-GToolkit'
}

{ #category : #initialization }
IpfsHomeSection >> create [
	| sectionContainer cardContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'IPFS').
	cardContainer := self newCardsContainer.
	cardContainer addChild: self localPeerCard.
	cardContainer addChild: self documentationCard.
	sectionContainer addChild: cardContainer.
	^ sectionContainer
]

{ #category : #initialization }
IpfsHomeSection >> documentationCard [
	^ self
		newToolCardWithTitle: 'IPFS Documentation'
		icon: (LeIcons lepiterDatabase create asScalableElement size: 64 @ 64)
		action: [ :card |
			self
				showSpaceWithTitle: 'IPFS Documentation'
				with: (GtInspector createOn: IpfsDocumentation new database)
				from: card ]
		description: 'Learning about IPFS'
]

{ #category : #accessing }
IpfsHomeSection >> localPeerCard [
	^ self
		newToolCardWithTitle: 'IPFS Peer'
		icon: IpfsIcons ipfsLogo asElement
		action: [ :card |
			self
				showSpaceWithTitle: 'IPFS Peer'
				with: (GtInspector createOn: IpfsPeer local)
				from: card ]
		description: 'Pinned data and IPNS keys on your device'
]
