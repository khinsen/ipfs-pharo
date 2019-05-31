Extension { #name : #Object }

{ #category : #'*IPFS' }
Object >> asIpldData [
	^ self
]

{ #category : #'*IPFS' }
Object >> storeAsIpld [
	^ Ipfs dagPut: self
]
