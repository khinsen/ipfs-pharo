Extension { #name : #Object }

{ #category : #'*IPFS' }
Object >> asIpfsLinkedData [
	^ self
]

{ #category : #'*IPFS' }
Object >> storeInIpfs [
	^ Ipfs dagPut: self
]
