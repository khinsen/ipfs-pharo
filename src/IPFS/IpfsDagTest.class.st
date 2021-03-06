"
!Tests for the IPLD layer

"
Class {
	#name : #IpfsDagTest,
	#superclass : #TestCase,
	#category : #'IPFS-Tests '
}

{ #category : #testing }
IpfsDagTest >> testIPFSCLIDocumentation [
	| dagNode |
	dagNode := 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG' asIpfsCid loadJson.
	self assert: (dagNode at: 'data') equals: 'CAE='.
	self assert: (dagNode at: 'links') size equals: 6.
	(dagNode at: 'links') do:
		[ :each | each includesKey: 'Cid'. each includesKey: 'Name'. each includesKey: 'Size' ].

]

{ #category : #testing }
IpfsDagTest >> testLinkedData [
	| data1 cid1 data2 cid2 retrieved |
	data1 := NeoJSONObject with: 'foo' -> 'bar'.
	cid1 := data1 storeInIpfs.
	data2 := NeoJSONObject with: 'data' -> cid1.
	cid2 := data2 storeInIpfs.
	retrieved := cid2 loadJson.
	self assert: retrieved equals: data2.
]

{ #category : #testing }
IpfsDagTest >> testPinning [
	| localPeer cid1 cid2 |
	localPeer := IpfsPeer local.
	cid1 := (NeoJSONObject with: #foo -> #bar) storeInIpfs.
	cid2 := (NeoJSONObject with: #foobar -> cid1) storeInIpfs.
	[ localPeer unpin: cid1 ] on: Error do: [ ].
	[ localPeer unpin: cid2 ] on: Error do: [ ].
	self deny: (localPeer pinnedCids includes: cid1).
	self deny: (localPeer pinnedCids includes: cid2).

	localPeer pin: cid2.
	self assert: ((localPeer pinnedCidsOfType: #direct) includes: cid2).
	self deny: ((localPeer pinnedCids) includes: cid1).
	localPeer unpin: cid2.
	self deny: ((localPeer pinnedCids) includes: cid2).

	localPeer pinRecursively: cid2.
	self assert: ((localPeer pinnedCidsOfType: #recursive) includes: cid2).
	self assert: ((localPeer pinnedCidsOfType: #indirect) includes: cid1).
	localPeer unpinRecursively: cid2.
	self deny: ((localPeer pinnedCids) includes: cid1).
	self deny: ((localPeer pinnedCids) includes: cid2).

]

{ #category : #testing }
IpfsDagTest >> testRandomArrays [
	10 timesRepeat:
		[ | array cid retrievedArray |
			array := Array new: (1 to: 1000) atRandom.
			(1 to: array size) do: [ :each | array at: each put: (0 to: 100) atRandom ].
			cid := array storeInIpfs.
			retrievedArray := cid loadJson.
			self assert: retrievedArray equals: array ]

]

{ #category : #testing }
IpfsDagTest >> testRandomByteArrays [
	10 timesRepeat:
		[ | array cid retrievedObject |
			array := ByteArray new: (1 to: 1000) atRandom.
			(1 to: array size) do: [ :each | array at: each put: (0 to: 100) atRandom ].
			cid := array storeInIpfs.
			retrievedObject := cid loadJson.
			self assert: retrievedObject equals: array ]

]

{ #category : #testing }
IpfsDagTest >> testReferences [
	| data1 cid1 data2 cid2 data3 cid3 refs |
	data1 := NeoJSONObject with: 'foo' -> 'bar'.
	cid1 := data1 storeInIpfs.
	data2 := NeoJSONObject with: 'link' -> cid1.
	cid2 := data2 storeInIpfs.
	data3 := NeoJSONObject with: 'data' -> cid2.
	cid3 := data3 storeInIpfs.

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
IpfsDagTest >> testStoreAndLoad [
	| testValues |
	testValues := { 'aString'.
						 42.
						 -2.5.
						 NeoJSONObject with: 'foor' -> 'bar' }.
	testValues do:
		[ :object |
			| cid retrievedObject |
			cid := object storeInIpfs.
			retrievedObject := cid loadJson.
			self assert: retrievedObject equals: object ]

]

{ #category : #testing }
IpfsDagTest >> testStoreAndLoadAsRaw [
	| data cid retrievedData |
	data := NeoJSONObject with: 'foo' -> 'bar'.
	cid := data storeInIpfs.
	retrievedData := cid loadRaw.
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
IpfsDagTest >> testStoreAndLoadRawAndTestSize [
	| bytes cid retrievedBytes |
	bytes := #[1 2 3 4 3 2 1].
	cid := bytes storeInIpfs.
	retrievedBytes := cid loadJson.
	self assert: retrievedBytes equals: bytes.
	self assert: cid sizeOfRawData equals: bytes size.
]
