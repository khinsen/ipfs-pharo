Extension { #name : #ByteArray }

{ #category : #'*IPFS' }
ByteArray >> storeInIpfs [
	^ Ipfs dagPutRaw: self
]
