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
		(self newWikiCardFor: (IpfsGToolkitData at: #Tutorial)).
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

{ #category : #accessing }
IpfsGtHomeSection >> newWikiCardFor: anIpfsWiki [
	^ self
		newHeaderCardWithTitle: 'Wiki'
		description: anIpfsWiki description
		size: 120 @ 120
		content:
		((((anIpfsWiki createOrRetrievePageNamed: #Main) asGtDocument)
				gtTextFor: GtPhlowView empty)
				asElementDo: [ :e | 
					e
						exact: 300 @ 400;
						beInSingleCompositionLayer;
						asScalableElement ])
		action: [ :card | 
			self
				showSpaceWithTitle: 'Wiki'
				with: (GtInspector createOn: anIpfsWiki)
				from: card ].
]
