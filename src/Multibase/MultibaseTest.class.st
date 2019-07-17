"
!Tests for ${class:name=MultibaseEncoder}$
"
Class {
	#name : #MultibaseTest,
	#superclass : #TestCase,
	#category : #'Multibase-Tests '
}

{ #category : #running }
MultibaseTest >> readReferenceDatasetFrom: anUrl [
	| dataset encodings |
	dataset :=
		(ZnClient new
			beOneShot;
			get: anUrl;
			entity) contents.
	encodings := (dataset lines collect:
		[ :each |
			| record string |
			record := each splitOn: $,.
			string := record second trimBoth:
							[ :char | char isSeparator or: [ char = $" ] ].
			string := string copyReplaceAll: '\x00' with: Character null asString.
			record first asSymbol -> string ])
		asDictionary.
	^ encodings
]

{ #category : #running }
MultibaseTest >> runTestForReferenceDatasetFrom: anUrl [
	| encodings bytes |
	encodings := self readReferenceDatasetFrom: anUrl.
	bytes := (encodings at: #encoding) asByteArray.
	MultibaseCodec allSubclasses do:
		[ :codecClass |
			| codec encodedReferenceValue decoded encoded |
			codec := codecClass new.
			encodedReferenceValue := encodings at: codec name.
			self assert: encodedReferenceValue first equals: codec code.
			decoded := codec decode: encodedReferenceValue allButFirst.
			self assert: decoded equals: bytes.
			encoded := codec encode: bytes.
			self assert: encoded equals: encodedReferenceValue allButFirst ]
]

{ #category : #testing }
MultibaseTest >> testDecodeRandomBytes [
	|  randomBytes digitString decoded |
	1 to: 20 do: [ :numberOfBytes |
		randomBytes := ByteArray new: numberOfBytes.
		1 to: randomBytes size do: [ :i | randomBytes at: i put: 256 atRandom - 1 ].
		"Base 2"
		digitString := randomBytes inject: '' into:
			[ :total :each | total, (each bitString last: 8) ].
		decoded := MultibaseEncoder new decode: '0', digitString.
		self assert: decoded equals: randomBytes.
		"Base 16"
		digitString := randomBytes inject: '' into:
			[ :total :each | total, (each printStringBase: 16 length: 2 padded: true) ].
		digitString translateToLowercase.
		decoded := MultibaseEncoder new decode: 'f', digitString.
		self assert: decoded equals: randomBytes ]

]

{ #category : #testing }
MultibaseTest >> testDecodeToInteger [
	| randomInteger encoded |
	100 timesRepeat:
		[ randomInteger := 1000000000 atRandom.
		  encoded := '9', randomInteger printString.
		  self assert: (MultibaseEncoder new decodeToInteger: encoded)
				 equals: randomInteger.
		  encoded := 'f', (randomInteger radix: 16) translateToLowercase.
		  self assert: (MultibaseEncoder new decodeToInteger: encoded)
				 equals: randomInteger.
		  encoded := '0', (randomInteger radix: 2).
		  self assert: (MultibaseEncoder new decodeToInteger: encoded)
				 equals: randomInteger ]
]

{ #category : #testing }
MultibaseTest >> testReferenceDataset1 [
	| url |
	url := 'https://github.com/multiformats/multibase/raw/master/tests/test1.csv'.
	self runTestForReferenceDatasetFrom: url.

]

{ #category : #testing }
MultibaseTest >> testReferenceDataset2 [
	| url |
	url := 'https://github.com/multiformats/multibase/raw/master/tests/test2.csv'.
	self runTestForReferenceDatasetFrom: url.

]

{ #category : #testing }
MultibaseTest >> testReferenceDataset3 [
	| url |
	url := 'https://github.com/multiformats/multibase/raw/master/tests/test3.csv'.
	self runTestForReferenceDatasetFrom: url.

]

{ #category : #testing }
MultibaseTest >> testReferenceDataset4 [
	| url |
	url := 'https://github.com/multiformats/multibase/raw/master/tests/test4.csv'.
	self runTestForReferenceDatasetFrom: url.

]

{ #category : #testing }
MultibaseTest >> testReferenceDataset5 [
	| url |
	url := 'https://github.com/multiformats/multibase/raw/master/tests/test5.csv'.
	self runTestForReferenceDatasetFrom: url.

]
