Extension { #name : #Array }

{ #category : #'*IPFS' }
Array >> convertIpfsCids [
	^ self collect: [ :each | each convertIpfsCids ]
]

{ #category : #'*IPFS' }
Array >> decodeFromIpfs [
	^ self collect: [ :each | each decodeFromIpfs ]
]

{ #category : #'*IPFS' }
Array >> decodeLinkedObjectsFromIpfs [
	^ self collect: [ :each | each decodeLinkedObjectsFromIpfs ]
]
