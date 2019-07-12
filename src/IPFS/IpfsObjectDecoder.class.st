"
!A class whose class-side methods decode JSON maps into Pharo objects
"
Class {
	#name : #IpfsObjectDecoder,
	#superclass : #Object,
	#category : #'IPFS-2 - Linked data'
}

{ #category : #decoding }
IpfsObjectDecoder class >> decodeDictionary: aListOfPairs [
	| decodedDictionary |
	decodedDictionary := Dictionary new.
	aListOfPairs do:
		[ :each | decodedDictionary at: each first
											put: each second ].
	^ decodedDictionary

]

{ #category : #decoding }
IpfsObjectDecoder class >> decodePillarDocument: aDictionary [
	^ IpfsDocument name: (aDictionary at: #name) text: (aDictionary at: #text)
]
