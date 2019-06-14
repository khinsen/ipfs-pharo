Extension { #name : #Dictionary }

{ #category : #'*IPFS' }
Dictionary class >> decodeIpfsObject: aDictionary [
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
	^ NeoJSONObject
		with: #type -> #dictionary
		with: #items ->
				(self associations collect:
					[ :each | { each key encodeForIpfs. each value encodeForIpfs } ])
]
