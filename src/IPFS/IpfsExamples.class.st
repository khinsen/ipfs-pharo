"
! IPFS Examples
!!Storing and retrieving data
!!!JSON-style linked data
[[[
'IpfsExamples' gtClassMatches & 'examples - cbor' gtMethodCategories
]]]
!!!Files and directories
[[[
'IpfsExamples' gtClassMatches & 'examples - unixfs' gtMethodCategories
]]]
!!! Other data
[[[
'IpfsExamples' gtClassMatches & 'examples - raw-block' gtMethodCategories
]]]
[[[
'IpfsExamples' gtClassMatches & 'examples - unsupported CID' gtMethodCategories
]]]
!!Paths and IPNS
[[[
'IpfsExamples' gtClassMatches & 'examples - paths' gtMethodCategories
]]]
[[[
'IpfsExamples' gtClassMatches & 'examples - ipns' gtMethodCategories
]]]
!!Interacting with an IPFS peer
An IPFS peer is a node in the IPFS network. In addition to handling communication with other nodes in the network, it manages the storage of IPFS data on the computer it is running on (in particular pinning), and a set of keys used for IPNS.

[[[
'IpfsExamples' gtClassMatches & 'examples - peer' gtMethodCategories
]]]

[[[
'IpfsExamples' gtClassMatches & 'examples - pinning' gtMethodCategories
]]]
"
Class {
	#name : #IpfsExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'IPFS-Examples'
}

{ #category : #'examples - peer' }
IpfsExamples >> allCidsOnlocalIpfsPeer [
	<gtExample>
	^ self localIpfsPeer allCids
]

{ #category : #'examples - cbor' }
IpfsExamples >> cborCidForArray [
	<gtExample>
	^ #(1 2 3) storeInIpfs
]

{ #category : #'examples - cbor' }
IpfsExamples >> cborCidForArrayWithReferences [
	<gtExample>
	^ { self cborCidForInteger. self cborCidForString } storeInIpfs
]

{ #category : #'examples - cbor' }
IpfsExamples >> cborCidForDictionary [
	<gtExample>
	^ (Dictionary with: 1 -> 2 with: 2 -> 3) storeInIpfs
]

{ #category : #'examples - cbor' }
IpfsExamples >> cborCidForFloat [
	<gtExample>
	^ 0.5 storeInIpfs
]

{ #category : #'examples - cbor' }
IpfsExamples >> cborCidForInteger [
	<gtExample>
	^ 42 storeInIpfs
]

{ #category : #'examples - cbor' }
IpfsExamples >> cborCidForJSONMap [
	<gtExample>
	^ (NeoJSONObject with: #a -> 1 with: #b -> 2) storeInIpfs
]

{ #category : #'examples - cbor' }
IpfsExamples >> cborCidForJSONMapWithReference [
	<gtExample>
	^ (NeoJSONObject with: #data -> self cborCidForJSONMap) storeInIpfs
]

{ #category : #'examples - cbor' }
IpfsExamples >> cborCidForString [
	<gtExample>
	^ 'foo' storeInIpfs
]

{ #category : #'examples - peer' }
IpfsExamples >> deleteIpnsKey [
	self ipnsKey delete
]

{ #category : #'examples - unixfs' }
IpfsExamples >> fileReference [
	<gtExample>
	^ self ipfsPathToFile asFileReference
]

{ #category : #'examples - unixfs' }
IpfsExamples >> fileReferenceToDirectory [
	<gtExample>
	^ self ipfsPathToDirectory asFileReference
]

{ #category : #'examples - unixfs' }
IpfsExamples >> fileReferenceToFile [
	<gtExample>
	^ self ipfsPathToFile asFileReference
]

{ #category : #'examples - unixfs' }
IpfsExamples >> fileSystem [
	<gtExample>
	^ FileSystem ipfs: ('/ipfs/bafybeibxm2nsadl3fnxv2sxcxmxaco2jl53wpeorjdzidjwf5aqdg7wa6u' asIpfsPath )
]

{ #category : #'examples - unixfs' }
IpfsExamples >> fileSystemEntryAtPath [
	<gtExample>
	| entry |
	entry := self fileSystem entryAt: (Path / 'about').
	"Note: this is a bug. The result should be an
	IpfsFileSystemFile."
	self flag: #todo.
	self assert: (entry isKindOf: MemoryDirectoryEntry).
	^ entry
]

{ #category : #'examples - unixfs' }
IpfsExamples >> fileSystemRoot [
	<gtExample>
	^ self fileSystem root
]

{ #category : #'examples - unsupported CID' }
IpfsExamples >> genericCid [
	<gtExample>
	"This is a CID pointing to an Ethereum block, for which there is no support
	 in Pharo yet."
	^ 'z43AaGEvwdfzjrCZ3Sq7DKxdDHrwoaPQDtqF4jfdkNEVTiqGVFW' asIpfsCid
]

{ #category : #'examples - unsupported CID' }
IpfsExamples >> gitObjectCid [
	<gtExample>
	"There is no support for creating git-raw objects from Pharo for now.
	Use a commit from an IPFS repository that is already stored in IPFS."
	^ 'z8mWaJHXieAVxxLagBpdaNWFEBKVWmMiE' asIpfsCid
]

{ #category : #'examples - unixfs' }
IpfsExamples >> ipfsPathToDirectory [
	<gtExample>
	| path |
	path := '/ipfs/bafybeibxm2nsadl3fnxv2sxcxmxaco2jl53wpeorjdzidjwf5aqdg7wa6u'
		asIpfsPath.
	self assert: path root equals: path.
	^ path
]

{ #category : #'examples - unixfs' }
IpfsExamples >> ipfsPathToFile [
	<gtExample>
	| path |
	path := self ipfsPathToDirectory / 'about'.
	self assert: (path root = path) not.
	^ path
]

{ #category : #'examples - tools' }
IpfsExamples >> ipfsPathToWebExplorer [
	<gtExample>
	^ '/ipfs/QmfQkD8pBSBCBxWEwFSu4XaDVSWK6bjnNuaWZjMyQbyDub/#/explore/'
]

{ #category : #'examples - peer' }
IpfsExamples >> ipnsKey [
	<gtExample>
	<after: #deleteIpnsKey>
	^ self localIpfsPeer generateKeyNamed: #PharoIPFSTest
]

{ #category : #'examples - ipns' }
IpfsExamples >> ipnsPath [
	<gtExample>
	^ self ipnsKey asIpfsPath / #a
]

{ #category : #'examples - ipns' }
IpfsExamples >> loadIpnsPath [
	<gtExample>
	self publishCid.
	^ self ipnsPath loadJson
]

{ #category : #'examples - paths' }
IpfsExamples >> loadNonResolvablePath [
	<gtExample>
	^ self nonResolvablePathIntoNestedDataStructure loadJson
]

{ #category : #'examples - raw-block' }
IpfsExamples >> loadRawBlock [
	<gtExample>
	| block |
	block := self rawBlockCid loadJson.
	self assert: block equals: #[1 2 3 2 1].
	^ block
]

{ #category : #'examples - paths' }
IpfsExamples >> loadResolvedPath [
	<gtExample>
	^ self resolvedPathIntoNestedDataStructure loadJson
]

{ #category : #'examples - peer' }
IpfsExamples >> localIpfsPeer [
	<gtExample>
	^ IpfsPeer local
]

{ #category : #'examples - paths' }
IpfsExamples >> nonResolvablePathIntoNestedDataStructure [
	<gtExample>
	| path |
	path := self pathIntoNestedDataStructure / #a.
	path := path resolve.
	self assert: path relativePath equals: #a.
	^ path
]

{ #category : #'examples - tools' }
IpfsExamples >> openRawBlockInLocalWebExplorer [
	<gtExample>
	WebBrowser openOn:
		'http://127.0.0.1:5001',
		self ipfsPathToWebExplorer,
		self rawBlockCid asString.
]

{ #category : #'examples - paths' }
IpfsExamples >> pathIntoNestedDataStructure [
	<gtExample>
	^ self pathToNestedDataStructure / #data
]

{ #category : #'examples - paths' }
IpfsExamples >> pathToNestedDataStructure [
	<gtExample>
	^ self cborCidForJSONMapWithReference asIpfsPath
]

{ #category : #'examples - unixfs' }
IpfsExamples >> protobufCid [
	<gtExample>
	"There is no support for creating Protobuf objects from Pharo for now.
	Use a CID from the documentation for the IPFS CLI."
	^ 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG' asIpfsCid
]

{ #category : #'examples - ipns' }
IpfsExamples >> publishCid [
	<gtExample>
	| cid key |
	cid := self cborCidForJSONMap.
	key := self ipnsKey.
	key publish: cid
]

{ #category : #'examples - ipns' }
IpfsExamples >> publishPath [
	<gtExample>
	| path key |
	path := self cborCidForJSONMap asIpfsPath / #a.
	key := self ipnsKey.
	key publish: path.
	^ { key. path }
]

{ #category : #'examples - raw-block' }
IpfsExamples >> rawBlockCid [
	<gtExample>
	^ #[1 2 3 2 1] storeInIpfs
]

{ #category : #'examples - ipns' }
IpfsExamples >> resolveIpnsKey [
	<gtExample>
	| pathAndKey path key resolvedPath |
	pathAndKey := self publishPath.
	path := pathAndKey second.
	key := pathAndKey first.
	resolvedPath := key resolve.
	self assert: resolvedPath equals: path.
	^ path
]

{ #category : #'examples - ipns' }
IpfsExamples >> resolveIpnsPath [
	<gtExample>
	^ self ipnsPath resolve
]

{ #category : #'examples - paths' }
IpfsExamples >> resolvedPathIntoNestedDataStructure [
	<gtExample>
	| resolvedPath |
	resolvedPath := self pathIntoNestedDataStructure resolve.
	self assert: resolvedPath equals: self cborCidForJSONMap asIpfsPath.
	self assert: resolvedPath relativePath equals: ''.
	^ resolvedPath
]

{ #category : #'examples - pinning' }
IpfsExamples >> storeDataAndCheckItsAbsenceAfterGarbageCollection [
	<gtExample>
	| cid |
	cid := self storeDataAndCheckItsPresenceOnLocalPeer.
	self localIpfsPeer collectGarbage.
	self assert: (self allCidsOnlocalIpfsPeer includes: cid) not.
	^ cid
]

{ #category : #'examples - pinning' }
IpfsExamples >> storeDataAndCheckItsPresenceOnLocalPeer [
	<gtExample>
	| cid |
	cid := self rawBlockCid storeInIpfs.
	self assert: (self allCidsOnlocalIpfsPeer includes: cid).
	^ cid
]

{ #category : #'examples - pinning' }
IpfsExamples >> storeDataPinAndCheckItsPresenceAfterGarbageCollection [
	<gtExample>
	| cid |
	cid := self rawBlockCid storeInIpfs.
	self localIpfsPeer pin: cid.
	self localIpfsPeer collectGarbage.
	self assert: (self allCidsOnlocalIpfsPeer includes: cid).
	^ cid
]

{ #category : #'examples - pinning' }
IpfsExamples >> storeDataPinUnpinAndCheckItsAbsenceAfterGarbageCollection [
	<gtExample>
	| cid |
	cid := self storeDataPinAndCheckItsPresenceAfterGarbageCollection.
	self localIpfsPeer unpin: cid.
	self localIpfsPeer collectGarbage.
	self assert: (self allCidsOnlocalIpfsPeer includes: cid) not.
	^ cid
]

{ #category : #'examples - tools' }
IpfsExamples >> urlForExploringRawBlockInRemoteWebExplorer [
	<gtExample>
	^ 'https://explore.ipld.io/#/explore/',
		self rawBlockCid asString.
]
