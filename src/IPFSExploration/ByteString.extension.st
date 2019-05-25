Extension { #name : #ByteString }

{ #category : #'*IPFSExploration' }
ByteString >> asIpldData [
	^ self asByteArray
]
