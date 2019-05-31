Extension { #name : #Dictionary }

{ #category : #'*IPFS' }
Dictionary >> asIpldData [
	(self size = 1
		and: [ self keys first = '/' ])
		ifTrue: [ ^ IpldCid fromDictionary: self ].
	^ self collect: [ :each | each asIpldData ]
]
