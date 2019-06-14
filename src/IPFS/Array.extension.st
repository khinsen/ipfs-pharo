Extension { #name : #Array }

{ #category : #'*IPFS' }
Array >> convertIpfsCids [
	^ self collect: [ :each | each convertIpfsCids ]
]

{ #category : #'*IPFS' }
Array >> decodeFromIpfs [
	^ self collect: [ :each | each decodeFromIpfs ]
]
