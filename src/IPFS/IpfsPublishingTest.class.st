"
!Tests for publishing (IPNS)

Warning: these tests take a long time because IPNS is slow.
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
IpfsPublishingTest >> testPublishThenLoadAsVariable [
	| cid variable |
	cid := 'foo' storeInIpfs.
	key publish: cid.
	variable := IpfsVariable key: key.
	self assert: variable value equals: 'foo'.
]

{ #category : #testing }
IpfsPublishingTest >> testPublishThenResolve [
	| cid |
	cid := 'foo' storeInIpfs.
	key publish: cid.
	self assert: key resolve equals: cid asIpfsPath.

]

{ #category : #testing }
IpfsPublishingTest >> testPublishWithLifetime [
"	| cid |
	cid := 'foo' storeInIpfs.
	key publish: cid lifetime: 5 minutes.
	self assert: (key resolveWithTimeout: 5 seconds) equals: cid asIpfsPath.
	1 minute asDelay wait.
	self assert: (key resolveWithTimeout: 5 seconds) equals: cid asIpfsPath.
	5 minutes asDelay wait.
	self should: [ key resolve ] raise: Exception."
]

{ #category : #testing }
IpfsPublishingTest >> testVariableStoreAndLoad [
	| variable |
	variable := IpfsVariable key: key value: 'foo'.
	variable store.
	variable := IpfsVariable key: key.
	self assert: variable value equals: 'foo'.

]
