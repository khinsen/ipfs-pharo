"
!Tests for IpfsPath and conversions to/from it
"
Class {
	#name : #IpfsPathTest,
	#superclass : #TestCase,
	#category : #'IPFS-Tests '
}

{ #category : #testing }
IpfsPathTest >> testPathConstruction [
	| cid path |
	cid := 'foo' storeInIpfs.
	path := cid asIpfsPath / 'link1' / 'link2'.
	self assert: (path isKindOf: IpfsCidPath).
	self assert: path cid equals: cid.
	self assert: (path asString count: [ :c | c = $/ ]) equals: 4.

]

{ #category : #testing }
IpfsPathTest >> testPathFromCid [
	| cid path reconstructedPath |
	cid := 'foo' storeInIpfs.
	path := cid asIpfsPath.
	self assert: (path isKindOf: IpfsCidPath).
	self assert: (path asString beginsWith: '/ipfs/').
	reconstructedPath := IpfsPath fromString: path asString.
	self assert: (reconstructedPath isKindOf: IpfsCidPath).
	self assert: reconstructedPath cid equals: cid.

]

{ #category : #testing }
IpfsPathTest >> testPathFromKey [
	| key path reconstructedPath |
	key := IpfsPeer local keyNamed: #self.
	path := key asIpfsPath.
	self assert: (path isKindOf: IpfsNamePath).
	self assert: (path asString beginsWith: '/ipns/').
	reconstructedPath := IpfsPath fromString: path asString.
	self assert: (reconstructedPath isKindOf: IpfsNamePath).
	self assert: reconstructedPath name equals: key id.

]
