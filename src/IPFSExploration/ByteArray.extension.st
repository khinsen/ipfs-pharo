Extension { #name : #ByteArray }

{ #category : #'*IPFSExploration' }
ByteArray >> storeAsIpdlNode [
	^ IpfsClient putRawIpldNode: self
]
