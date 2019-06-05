Extension { #name : #Dictionary }

{ #category : #'*IPFS' }
Dictionary >> asIpfsLinkedData [
	(self size = 1
		and: [ self keys first = '/' ])
		ifTrue: [ ^ IpfsCid fromDictionary: self ].
	^ self collect: [ :each | each asIpfsLinkedData ]
]

{ #category : #'*IPFS' }
Dictionary >> decodeFromIpfs [
	| objectType decoderPragmas decoderMethod |
	objectType := self at: #type ifAbsent: [ self error: 'missing type field in JSON object' ].
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
Dictionary >> decodeIpfsDictionary: aDictionary [
	<ipfsDecoder: #dictionary>
	| decodedDictionary |
	decodedDictionary := Dictionary new.
	(aDictionary at: #items) do:
		[ :each | decodedDictionary at: each first decodeFromIpfs
											put: each second decodeFromIpfs ].
	^ decodedDictionary

]

{ #category : #'*IPFS' }
Dictionary >> encodeForIpfs [
	^ Dictionary
		with: #type -> #dictionary
		with: #items ->
				(self associations collect:
					[ :each | { each key encodeForIpfs. each value encodeForIpfs } ])
]
