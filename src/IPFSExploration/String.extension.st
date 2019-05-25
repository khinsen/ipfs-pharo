Extension { #name : #String }

{ #category : #'*IPFSExploration' }
String >> asIpldCid [
	^ IpldCid fromString: self
]
