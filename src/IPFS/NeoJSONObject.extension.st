Extension { #name : #NeoJSONObject }

{ #category : #'*IPFS' }
NeoJSONObject >> convertIpfsCids [
	(self size = 1
		and: [ self keys first = '/' ])
		ifTrue: [ ^ IpfsCid fromDictionary: self ].
	^ self collect: [ :each | each convertIpfsCids ]
]

{ #category : #'*IPFS' }
NeoJSONObject >> decodeFromIpfs [
	| objectType decoderPragmas decoderMethod |
	objectType := self at: #type
		ifAbsent: [ ^ self ].
	decoderPragmas :=
		(PragmaCollector filter:
			[ :p | p keyword = #ipfsDecoder:
						and: [ (p argumentAt: 1) = objectType ] ])
					reset collected.
	decoderPragmas ifEmpty: [ self error: 'no decoder method for type ', objectType ].
	decoderPragmas size = 1 ifFalse: [ self error: 'multiple decoder methods for type ', objectType ].
	decoderMethod := decoderPragmas first method.
	^ decoderMethod valueWithReceiver: decoderMethod methodClass arguments: { self }
]

{ #category : #'*IPFS' }
NeoJSONObject >> encodeForIpfs [
	^ self
]
