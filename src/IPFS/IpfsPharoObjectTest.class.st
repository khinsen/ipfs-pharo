"
!Tests for Pharo objects
"
Class {
	#name : #IpfsPharoObjectTest,
	#superclass : #TestCase,
	#category : #'IPFS-Tests '
}

{ #category : #'testing support' }
IpfsPharoObjectTest >> storeLoadCheck: anObject [
	| cid retrievedObject |
	cid := anObject storeInIpfs.
	retrievedObject := cid loadObject.
	self assert: retrievedObject value equals: anObject
]

{ #category : #testing }
IpfsPharoObjectTest >> testStoreAndLoadDictionary [
	| testValues |
	testValues :=
		{	Dictionary with: 1 -> 2 with: 2 -> 3.
			Dictionary with: #foo -> #(1 2 3).
			Dictionary with: true -> Dictionary new with: false -> { 1 -> 2 } asDictionary }.
	testValues do: [ :object | self storeLoadCheck: object ]
]

{ #category : #testing }
IpfsPharoObjectTest >> testStoreAndLoadLinkedObjects [
	| cid1 cid2 |
	cid1 := 'foo' storeInIpfs.
	cid2 := 'bar' storeInIpfs.
	self storeLoadCheck: { cid1. cid2 }.
	self storeLoadCheck: { cid1 -> cid2 } asDictionary.

]

{ #category : #testing }
IpfsPharoObjectTest >> testStoreAndLoadSimpleData [
	| testValues |
	"Samples for all the basic data types that do not need to be encoded."
	testValues := { 'aString'.
						 42.
						 -2.5.
						true.
						#(a 1 false).
						#[1 2 3] }.
	testValues do: [ :object | self storeLoadCheck: object ]
]