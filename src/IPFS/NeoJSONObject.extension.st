Extension { #name : #NeoJSONObject }

{ #category : #'*IPFS' }
NeoJSONObject >> convertIpfsCids [
	(self size = 1 and: [ self keys first = '/' ])
		ifTrue: [ ^ IpfsCid fromJSON: self ].
	^ self collect: [ :each | each convertIpfsCids ]
]

{ #category : #'*IPFS' }
NeoJSONObject >> decodeFromIpfsUsing: anIpfsMapper [
	^ anIpfsMapper decode: self
]

{ #category : #'*IPFS' }
NeoJSONObject >> decodeLinkedObjectsFromIpfsUsing: anIpfsMapper [
	^ anIpfsMapper decode:
		(self collect: [ :each | each decodeLinkedObjectsFromIpfsUsing: anIpfsMapper ]).
]
