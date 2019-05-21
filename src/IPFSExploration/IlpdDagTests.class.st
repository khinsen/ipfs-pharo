Class {
	#name : #IlpdDagTests,
	#superclass : #TestCase,
	#category : #'IPFSExploration-Tests '
}

{ #category : #testing }
IlpdDagTests >> testIPFSCLIDocumentation [
	| dagNode |
	dagNode := IpfsNode getIpldNode: 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'.
	self assert: (dagNode at: 'data') equals: 'CAE='.
	self assert: (dagNode at: 'links') size equals: 6.
	(dagNode at: 'links') do:
		[ :each | each includesKey: 'Cid'. each includesKey: 'Name'. each includesKey: 'Size' ].

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
			cid := IpfsNode putIpldNode: object.
			retrievedObject := IpfsNode getIpldNode: cid.
			self assert: object equals: retrievedObject ]

]
