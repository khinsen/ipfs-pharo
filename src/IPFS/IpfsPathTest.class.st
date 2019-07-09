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
	| cid path1 path2 |
	cid := 'foo' storeInIpfs.
	path1 := cid asIpfsPath / 'link1' / 'link2'.
	path2 := cid asIpfsPath / 'link1/link2'.
	self assert: (path1 isKindOf: IpfsCidPath).
	self assert: path1 cid equals: cid.
	self assert: (path1 asString count: [ :c | c = $/ ]) equals: 4.
	self assert: path2 equals: path1.
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

{ #category : #testing }
IpfsPathTest >> testResolveDagPath [
	| cid path linkPath resolvedPath |
	cid := (NeoJSONObject with: #foo -> #bar) storeInIpfs.
	path := cid asIpfsPath.
	linkPath := path / #foo.
	resolvedPath := linkPath resolve.
	self assert: resolvedPath equals: linkPath.
]

{ #category : #testing }
IpfsPathTest >> testResolveDagPathThroughLink [
	| cid1 cid2 path resolvedPath |
	cid1 := (NeoJSONObject with: #foo -> #bar) storeInIpfs.
	cid2 := (NeoJSONObject with: #data -> cid1) storeInIpfs.
	path := cid2 asIpfsPath / #data / #foo.
	resolvedPath := path resolve.
	self assert: resolvedPath equals: cid1 asIpfsPath / #foo.
]
