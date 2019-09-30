Extension { #name : #Array }

{ #category : #'*IPFS' }
Array >> convertIpfsCids [
	^ self collect: [ :each | each convertIpfsCids ]
]

{ #category : #'*IPFS' }
Array >> decodeFromIpfsUsing: anIpfsMapper [
	^ self collect: [ :each | each decodeFromIpfsUsing: anIpfsMapper ]
]

{ #category : #'*IPFS' }
Array >> decodeLinkedObjectsFromIpfsUsing: anIpfsMapper [
	^ self collect: [ :each | each decodeLinkedObjectsFromIpfsUsing: anIpfsMapper ]
]
