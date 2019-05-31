"
!Tests for the IPLD layer

"
Class {
	#name : #IlpdDagTests,
	#superclass : #TestCase,
	#category : #'IPFS-Tests '
}

{ #category : #testing }
IlpdDagTests >> testIPFSCLIDocumentation [
	| dagNode |
	dagNode := 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG' asIpldCid load.
	self assert: (dagNode at: 'data') equals: 'CAE='.
	self assert: (dagNode at: 'links') size equals: 6.
	(dagNode at: 'links') do:
		[ :each | each includesKey: 'Cid'. each includesKey: 'Name'. each includesKey: 'Size' ].

]

{ #category : #testing }
IlpdDagTests >> testLinkedData [
	| data1 cid1 data2 cid2 retrieved |
	data1 := { 'foo' -> 'bar' } asDictionary.
	cid1 := data1 storeAsIpld.
	data2 := { 'data' -> cid1 } asDictionary.
	cid2 := data2 storeAsIpld.
	retrieved := cid2 load.
	self assert: retrieved equals: data2.
]

{ #category : #testing }
IlpdDagTests >> testRandomArrays [
	10 timesRepeat:
		[ | array cid retrievedArray |
			array := Array new: (1 to: 1000) atRandom.
			(1 to: array size) do: [ :each | array at: each put: (0 to: 100) atRandom ].
			cid := array storeAsIpld.
			retrievedArray := cid load.
			self assert: retrievedArray equals: array ]

]

{ #category : #testing }
IlpdDagTests >> testRandomByteArrays [
	10 timesRepeat:
		[ | array cid retrievedObject |
			array := ByteArray new: (1 to: 1000) atRandom.
			(1 to: array size) do: [ :each | array at: each put: (0 to: 100) atRandom ].
			cid := array storeAsIpld.
			retrievedObject := cid load.
			self assert: retrievedObject equals: array ]

]

{ #category : #testing }
IlpdDagTests >> testReferences [
	| data1 cid1 data2 cid2 data3 cid3 refs |
	data1 := { 'foo' -> 'bar' } asDictionary.
	cid1 := data1 storeAsIpld.
	data2 := { 'link' -> cid1 } asDictionary.
	cid2 := data2 storeAsIpld.
	data3 := { 'data' -> cid2 } asDictionary.
	cid3 := data3 storeAsIpld.

	refs := cid2 references.
	self assert: refs size equals: 1.
	self assert: refs first equals: cid1.

	refs := cid3 references.
	self assert: refs size equals: 1.
	self assert: refs first equals: cid2.

	refs := cid3 recursiveReferences.
	self assert: refs size equals: 2.
	self assert: refs first equals: cid2.
	self assert: refs second equals: cid1.

]

{ #category : #testing }
IlpdDagTests >> testStoreAndLoad [
	| testValues |
	testValues := { 'aString'.
						 42.
						 -2.5.
						 { 'foor' -> 'bar' } asDictionary }.
	testValues do:
		[ :object |
			| cid retrievedObject |
			cid := object storeAsIpld.
			retrievedObject := cid load.
			self assert: object equals: retrievedObject ]

]

{ #category : #testing }
IlpdDagTests >> testStoreAndLoadAsRaw [
	| data cid retrievedData |
	data := { 'foo' -> 'bar' } asDictionary.
	cid := data storeAsIpld.
	retrievedData := cid loadRawData.
	self assert: retrievedData
		  equals:
			#[16rA1 "Data item field:
				    	- 101: major type: map of pairs of data items
				    	- 00001: one pair
				   		The next two data items are key and value for this pair."
			  16r63 "Data item field:
				    	- 011: major type: text string
				 		- 00011: three bytes (UTF-8)"
			  16r66 16r6F 16r6F "foo"
			  16r63  "Data item field:
				     - 011: major type: text string
				     - 00011: three bytes (UTF-8)"
			  16r62 16r61 16r72 "bar"].

]

{ #category : #testing }
IlpdDagTests >> testStoreAndLoadRawAndTestSize [
	| bytes cid retrievedBytes |
	bytes := #[1 2 3 4 3 2 1].
	cid := bytes storeAsIpld.
	retrievedBytes := cid load.
	self assert: retrievedBytes equals: bytes.
	self assert: cid sizeOfRawData equals: bytes size.
]