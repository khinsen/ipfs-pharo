Extension { #name : #ByteArray }

{ #category : #'*IPFSExploration' }
ByteArray >> storeAsIpld [
	^ Ipfs dagPutRaw: self
]
