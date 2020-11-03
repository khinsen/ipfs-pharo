Extension { #name : #FileSystem }

{ #category : #'*IPFS' }
FileSystem class >> ipfs: anIpfsPath [
	^ self store: (IpfsFileSystemStore rootPath: anIpfsPath)
]
