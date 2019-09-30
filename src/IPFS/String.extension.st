Extension { #name : #String }

{ #category : #'*IPFS' }
String >> asIpfsCid [
	^ IpfsCid fromString: self
]

{ #category : #'*IPFS' }
String >> asIpfsPath [
	^ IpfsPath fromString: self
]

{ #category : #'*IPFS' }
String >> decodeFromIpfsUsing: anIpfsMapper [
	^ self
]

{ #category : #'*IPFS' }
String >> encodeForIpfsUsing: anIpfsMapper [
	^ self
]
