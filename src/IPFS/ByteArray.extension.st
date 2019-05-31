Extension { #name : #ByteArray }

{ #category : #'*IPFS' }
ByteArray >> storeAsIpld [
	^ Ipfs dagPutRaw: self
]
