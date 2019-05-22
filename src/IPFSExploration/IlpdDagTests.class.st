Class {
	#name : #IlpdDagTests,
	#superclass : #TestCase,
	#category : #'IPFSExploration-Tests '
}

{ #category : #testing }
IlpdDagTests >> testIPFSCLIDocumentation [
	| dagNode |
	dagNode := IpfsClient getIpldNode: 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'.
	self assert: (dagNode at: 'data') equals: 'CAE='.
	self assert: (dagNode at: 'links') size equals: 6.
	(dagNode at: 'links') do:
		[ :each | each includesKey: 'Cid'. each includesKey: 'Name'. each includesKey: 'Size' ].

]

{ #category : #testing }
IlpdDagTests >> testLinkedData [
	| data1 cid1 data2 cid2 retrieved |
	data1 := { 'foo' -> 'bar' } asDictionary.
	cid1 := IpfsClient putIpldNode: data1.
	data2 := { 'data' -> { '/' -> cid1 } asDictionary } asDictionary.
	cid2 := IpfsClient putIpldNode: data2.
	retrieved := IpfsClient getIpldNode: cid2.
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
			cid := IpfsClient putIpldNode: object.
			retrievedObject := IpfsClient getIpldNode: cid.
			self assert: object equals: retrievedObject ]

]
