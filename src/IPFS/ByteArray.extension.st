Extension { #name : #ByteArray }

{ #category : #'*IPFS' }
ByteArray >> decodeFromIpfs [
	^ self
]

{ #category : #'*IPFS' }
ByteArray >> storeInIpfs [
	^ Ipfs dagPutRaw: self
]
