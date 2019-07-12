Extension { #name : #IpfsObjectDecoder }

{ #category : #'*IPFS-GToolkit' }
IpfsObjectDecoder class >> decodeIpfsWiki: aDictionary [
	| wiki |
	wiki := IpfsWiki new.
	aDictionary do: [ :pageCid | wiki addPage: pageCid loadObject ].
	^ wiki
]

{ #category : #'*IPFS-GToolkit' }
IpfsObjectDecoder class >> decodeIpfsWikiPage: aDictionary [
	^ IpfsWikiPage new
		name: (aDictionary at: #name);
		text: (aDictionary at: #text);
		yourself
]

{ #category : #'*IPFS-GToolkit' }
IpfsObjectDecoder class >> decodePillarDocument: aDictionary [
	^ IpfsDocument name: (aDictionary at: #name) text: (aDictionary at: #text)
]
