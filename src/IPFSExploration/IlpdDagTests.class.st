Class {
	#name : #IlpdDagTests,
	#superclass : #TestCase,
	#category : #'IPFSExploration-Tests '
}

{ #category : #testing }
IlpdDagTests >> testIPFSCLIDocumentation [
	| dagNode |
	dagNode := 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG' asIpldCid getNode.
	self assert: (dagNode at: 'data') equals: 'CAE='.
	self assert: (dagNode at: 'links') size equals: 6.
	(dagNode at: 'links') do:
		[ :each | each includesKey: 'Cid'. each includesKey: 'Name'. each includesKey: 'Size' ].

]

{ #category : #testing }
IlpdDagTests >> testLinkedData [
	| data1 cid1 data2 cid2 retrieved |
	data1 := { 'foo' -> 'bar' } asDictionary.
	cid1 := data1 storeAsIpdlNode.
	data2 := { 'data' -> cid1 } asDictionary.
	cid2 := data2 storeAsIpdlNode.
	retrieved := cid2 getNode.
	self assert: retrieved equals: data2.
]

{ #category : #testing }
IlpdDagTests >> testPutAndGet [
	| testValues |
	testValues := { 'aString'.
						 42.
						 -2.5.
						 { 'foor' -> 'bar' } asDictionary }.
	testValues do:
		[ :object |
			| cid retrievedObject |
			cid := object storeAsIpdlNode.
			retrievedObject := cid getNode.
			self assert: object equals: retrievedObject ]

]

{ #category : #testing }
IlpdDagTests >> testPutAndGetRaw [
	| bytes cid retrievedBytes |
	bytes := #[1 2 3 4 3 2 1].
	cid := bytes storeAsIpdlNode.
	retrievedBytes := cid getNode.
	self assert: retrievedBytes equals: bytes.
]

{ #category : #testing }
IlpdDagTests >> testRandomArrays [
	10 timesRepeat:
		[ | array cid retrievedArray |
			array := Array new: (1 to: 1000) atRandom.
			(1 to: array size) do: [ :each | array at: each put: (0 to: 100) atRandom ].
			cid := array storeAsIpdlNode.
			retrievedArray := cid getNode.
			self assert: retrievedArray equals: array ]

]

{ #category : #testing }
IlpdDagTests >> testRandomByteArrays [
	10 timesRepeat:
		[ | array cid retrievedObject |
			array := ByteArray new: (1 to: 1000) atRandom.
			(1 to: array size) do: [ :each | array at: each put: (0 to: 100) atRandom ].
			cid := array storeAsIpdlNode.
			retrievedObject := cid getNode.
			self assert: retrievedObject equals: array ]

]
