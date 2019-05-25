Extension { #name : #Object }

{ #category : #'*IPFSExploration' }
Object >> asIpldData [
	^ self
]

{ #category : #'*IPFSExploration' }
Object >> storeAsIpdlNode [
	^ IpfsClient putIpldNode: self
]
