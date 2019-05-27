Extension { #name : #Object }

{ #category : #'*IPFSExploration' }
Object >> asIpldData [
	^ self
]

{ #category : #'*IPFSExploration' }
Object >> storeAsIpld [
	^ Ipfs dagPut: self
]
