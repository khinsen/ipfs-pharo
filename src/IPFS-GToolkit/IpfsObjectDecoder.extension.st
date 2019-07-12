Extension { #name : #IpfsObjectDecoder }

{ #category : #'*IPFS-GToolkit' }
IpfsObjectDecoder class >> decodePillarDocument: aDictionary [
	^ IpfsDocument name: (aDictionary at: #name) text: (aDictionary at: #text)
]
