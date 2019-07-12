Extension { #name : #NeoJSONObject }

{ #category : #'*IPFS' }
NeoJSONObject >> asPharoObject [
	"Pharo objects are encoded as JSON maps with a single entry. The key of that entry determines
	the decoder method that is used."
	| objectType methodSelector |
	self size = 1 ifFalse: [ ^ self ].
	objectType := self associations first key.
	methodSelector := ('decode', objectType, ':') asSymbol.
	^ IpfsObjectDecoder perform: methodSelector with: (self at: objectType)
]

{ #category : #'*IPFS' }
NeoJSONObject >> convertIpfsCids [
	(self size = 1
		and: [ self keys first = '/' ])
		ifTrue: [ ^ IpfsCid fromDictionary: self ].
	^ self collect: [ :each | each convertIpfsCids ]
]

{ #category : #'*IPFS' }
NeoJSONObject >> decodeFromIpfs [
	^ (self collect: [ :each | each decodeFromIpfs ])
		asPharoObject.
]

{ #category : #'*IPFS' }
NeoJSONObject >> decodeLinkedObjectsFromIpfs [
	^ (self collect: [ :each | each decodeLinkedObjectsFromIpfs ])
		asPharoObject.
]

{ #category : #'*IPFS' }
NeoJSONObject >> encodeForIpfs [
	^ self collect: [ :each | each encodeForIpfs ]
]
