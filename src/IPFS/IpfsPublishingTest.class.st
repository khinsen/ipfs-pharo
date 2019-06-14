"
!Tests for publishing (IPNS)
"
Class {
	#name : #IpfsPublishingTest,
	#superclass : #TestCase,
	#instVars : [
		'key'
	],
	#category : #'IPFS-Tests '
}

{ #category : #running }
IpfsPublishingTest >> defaultTimeLimit [
	^ 10 minutes.
]

{ #category : #running }
IpfsPublishingTest >> setUp [
	key := IpfsPeer local generateKeyNamed: #PharoIPFSTest.
]

{ #category : #running }
IpfsPublishingTest >> tearDown [
	key delete.
]

{ #category : #testing }
IpfsPublishingTest >> testPublishThenResolve [
	| cid |
	cid := 'foo' storeInIpfs.
	key publish: cid.
	self assert: key resolve equals: cid asIpfsPath.

]
