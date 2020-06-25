Class {
	#name : #IpfsGtHomeSection,
	#superclass : #GtHomeSection,
	#category : #'IPFS-GToolkit'
}

{ #category : #accessing }
IpfsGtHomeSection >> create [
	| sectionContainer cardsContainer tutorialCard |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'IPFS').
	cardsContainer := self newCardsContainer.
	tutorialCard := self newWikiCardFor: (IpfsGToolkitData at: #Tutorial) description: 'IPFS Tutorial'.
	cardsContainer addChild: tutorialCard.
	sectionContainer addChild: cardsContainer.
	^ sectionContainer
]

{ #category : #accessing }
IpfsGtHomeSection >> newWikiCardFor: anIpfsWiki description: aString [
	^ self
		newHeaderCardWithTitle: 'Wiki'
		description: aString
		size: 150 @ 200
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
