"
!Tests involving ${class:name=IpfsLink}$
"
Class {
	#name : #IpfsLinkTest,
	#superclass : #TestCase,
	#category : #'IPFS-Tests '
}

{ #category : #testing }
IpfsLinkTest >> testLinkAsProxy [
	| object link |
	object := Dictionary with: #foo -> #bar.
	link := IpfsLink to: object.
	self assert: (link at: #foo) equals: (object at: #foo).
	self assert: link size equals: object size.
	link at: #bar put: #foo.
	self assert: (link at: #bar) equals: #foo.

]

{ #category : #testing }
IpfsLinkTest >> testLoadLinkedObjects [
	| leaf1 leaf2 tree cid retrievedTree |
	leaf1 := #leaf1.
	leaf2 := 42.
	tree := { IpfsLink to: leaf1. IpfsLink to: leaf2 }.
	cid := tree storeInIpfs.
	retrievedTree := cid loadLinkedObjects.
	self assert: retrievedTree
		  equals: tree.
	"The following assertion succeeds because IpfsLink passes = to its target."
	self assert: retrievedTree
		  equals: { leaf1. leaf2 }.
	self assert: (retrievedTree first class == IpfsLink).
	self assert: (retrievedTree second class == IpfsLink).

]

{ #category : #testing }
IpfsLinkTest >> testStoreLinkedObjects [
	| leaf1 leaf2 tree cid retrievedTree |
	leaf1 := #leaf1.
	leaf2 := 42.
	tree := { IpfsLink to: leaf1. IpfsLink to: leaf2 }.
	cid := tree storeInIpfs.
	retrievedTree := cid loadJson.
	self assert: retrievedTree
		  equals: { leaf1 storeInIpfs. leaf2 storeInIpfs }.

]
