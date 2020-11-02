Extension { #name : #FileSystem }

{ #category : #'*IPFS' }
FileSystem class >> ipfs: anIpfsPath [
	^ self store: (IpfsStore rootPath: anIpfsPath)
]
