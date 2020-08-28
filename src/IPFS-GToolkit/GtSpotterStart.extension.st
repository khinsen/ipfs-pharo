Extension { #name : #GtSpotterStart }

{ #category : #'*IPFS-GToolkit' }
GtSpotterStart >> gtSpotterForWikiPagesFor: aStep [
	<gtSearch>
	^ aStep listProcessor
		priority: 30;
		allCandidates: [ IpfsWiki allInstances];
		itemName: [ :each | each title ];
		title: 'Wikis';
		itemIcon: [ GLMUIThemeExtraIcons glamorousBookmark ];
		filter: GtFilterSubstring
]
