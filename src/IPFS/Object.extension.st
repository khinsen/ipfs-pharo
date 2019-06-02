Extension { #name : #Object }

{ #category : #'*IPFS' }
Object >> asIpfsBlock [
	^ self
]

{ #category : #'*IPFS' }
Object >> storeInIpfs [
	^ Ipfs dagPut: self
]
