Extension { #name : #String }

{ #category : #'*IPFS' }
String >> asIpldCid [
	^ IpldCid fromString: self
]
