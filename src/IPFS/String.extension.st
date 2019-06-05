Extension { #name : #String }

{ #category : #'*IPFS' }
String >> asIpfsCid [
	^ IpfsCid fromString: self
]

{ #category : #'*IPFS' }
String >> decodeFromIpfs [
	^ self
]

{ #category : #'*IPFS' }
String >> encodeForIpfs [
	^ self
]
