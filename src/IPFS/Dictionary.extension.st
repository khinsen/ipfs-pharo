Extension { #name : #Dictionary }

{ #category : #'*IPFS' }
Dictionary >> asIpfsLinkedData [
	(self size = 1
		and: [ self keys first = '/' ])
		ifTrue: [ ^ IpfsCid fromDictionary: self ].
	^ self collect: [ :each | each asIpfsLinkedData ]
]
