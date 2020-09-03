Extension { #name : #IpfsDefaultMapper }

{ #category : #'*IPFS-GToolkit' }
IpfsDefaultMapper >> mappingForIpfsDocument [
	self encodeClass: IpfsDocument as:
		[ :aDocument |
			NeoJSONObject with: aDocument class ipfsTag ->
				(NeoJSONObject 
					with: #name -> aDocument name
					with: #text -> aDocument text) ].
	self decodeTag: #PillarDocument as:
		[ :aDictionary | IpfsDocument name: (aDictionary at: #name) text: (aDictionary at: #text) ].
	self decodeTag: #WikiPage as:
		[ :aDictionary | IpfsWikiPage name: (aDictionary at: #name) text: (aDictionary at: #text) ].

]

{ #category : #'*IPFS-GToolkit' }
IpfsDefaultMapper >> mappingForIpfsWiki [
	self encodeClass: IpfsWiki as:
		[ :aWiki |
			| pages |
			pages := NeoJSONObject
				newFromKeys: aWiki pageNames
				andValues: (aWiki pageNames collect: [ :each |
								(IpfsDocument new
									name: each;
									text: (aWiki page: each)) storeInIpfsUsing: self ]).
			NeoJSONObject with: #IpfsWiki ->
				(NeoJSONObject
					with: #title -> aWiki title
					with: #description -> aWiki description
					with: #pages -> pages) ].
	self decodeTag: #IpfsWiki as:
		[ :aDictionary |
			| wiki |
			wiki := IpfsWiki
						title: (aDictionary at: #title)
						description: (aDictionary at: #description).
			(aDictionary at: #pages) do:
				[ :pageCid |
					| page |
					page := pageCid loadObjectUsing: self.
					wiki updatePage: page name asSymbol to: page text ].
			wiki ].
]
