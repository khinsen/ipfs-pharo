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
			pages := aWiki pages collect: [ :each | each storeInIpfsUsing: self ].
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
						description: (aDictionary at: #title).
			(aDictionary at: #pages) do:
				[ :pageCid | wiki addPage: (pageCid loadObjectUsing: self) ].
			wiki ].
]
