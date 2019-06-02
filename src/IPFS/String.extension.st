Extension { #name : #String }

{ #category : #'*IPFS' }
String >> asIpfsCid [
	^ IpfsCid fromString: self
]
