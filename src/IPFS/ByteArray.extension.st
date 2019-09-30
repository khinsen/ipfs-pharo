Extension { #name : #ByteArray }

{ #category : #'*IPFS' }
ByteArray >> decodeFromIpfsUsing: anIpfsMapper [
	^ self
]

{ #category : #'*IPFS' }
ByteArray >> storeInIpfs [
	^ Ipfs dagPutRaw: self
]

{ #category : #'*IPFS' }
ByteArray >> storeInIpfsUsing: anIpfsMapper [
	^ Ipfs dagPutRaw: self
]
