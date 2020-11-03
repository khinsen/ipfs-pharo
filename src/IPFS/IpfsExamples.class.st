"
!Examples for IPFS

"
Class {
	#name : #IpfsExamples,
	#superclass : #Object,
	#category : #'IPFS-Examples'
}

{ #category : #examples }
IpfsExamples >> allCidsOnlocalIpfsPeer [
	<gtExample>
	^ self localIpfsPeer allCids
]

{ #category : #examples }
IpfsExamples >> cborCidForArray [
	<gtExample>
	^ #(1 2 3) storeInIpfs
]

{ #category : #examples }
IpfsExamples >> cborCidForArrayWithReferences [
	<gtExample>
	^ { self cborCidForInteger. self cborCidForString } storeInIpfs
]

{ #category : #examples }
IpfsExamples >> cborCidForDictionary [
	<gtExample>
	^ (Dictionary with: 1 -> 2 with: 2 -> 3) storeInIpfs
]

{ #category : #examples }
IpfsExamples >> cborCidForFloat [
	<gtExample>
	^ 0.5 storeInIpfs
]

{ #category : #examples }
IpfsExamples >> cborCidForInteger [
	<gtExample>
	^ 42 storeInIpfs
]

{ #category : #examples }
IpfsExamples >> cborCidForJSONMap [
	<gtExample>
	^ (NeoJSONObject with: #a -> 1 with: #b -> 2) storeInIpfs
]

{ #category : #examples }
IpfsExamples >> cborCidForJSONMapWithReference [
	<gtExample>
	^ (NeoJSONObject with: #data -> self cborCidForJSONMap) storeInIpfs

]

{ #category : #examples }
IpfsExamples >> cborCidForString [
	<gtExample>
	^ 'foo' storeInIpfs
]

{ #category : #examples }
IpfsExamples >> deleteIpnsKey [
	self ipnsKey delete

]

{ #category : #example }
IpfsExamples >> fileReference [
	<gtExample>
	^ self ipfsPathToFile asFileReference
]

{ #category : #example }
IpfsExamples >> fileReferenceToDirectory [
	<gtExample>
	^ self ipfsPathToDirectory asFileReference
]

{ #category : #example }
IpfsExamples >> fileReferenceToFile [
	<gtExample>
	^ self ipfsPathToFile asFileReference
]

{ #category : #examples }
IpfsExamples >> fileSystem [
	<gtExample>
	^ FileSystem ipfs: ('/ipfs/bafybeibxm2nsadl3fnxv2sxcxmxaco2jl53wpeorjdzidjwf5aqdg7wa6u' asIpfsPath )
]

{ #category : #example }
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

{ #category : #example }
IpfsExamples >> fileSystemRoot [
	<gtExample>
	^ self fileSystem root
]

{ #category : #examples }
IpfsExamples >> genericCid [
	<gtExample>
	"This is a CID pointing to an Ethereum block, for which there is no support
	 in Pharo yet."
	^ 'z43AaGEvwdfzjrCZ3Sq7DKxdDHrwoaPQDtqF4jfdkNEVTiqGVFW' asIpfsCid
]

{ #category : #examples }
IpfsExamples >> gitObjectCid [
	<gtExample>
	"There is no support for creating git-raw objects from Pharo for now.
	Use a commit from an IPFS repository that is already stored in IPFS."
	^ 'z8mWaJHXieAVxxLagBpdaNWFEBKVWmMiE' asIpfsCid
]

{ #category : #example }
IpfsExamples >> ipfsPathToDirectory [
	<gtExample>
	| path |
	path := '/ipfs/bafybeibxm2nsadl3fnxv2sxcxmxaco2jl53wpeorjdzidjwf5aqdg7wa6u'
		asIpfsPath.
	self assert: path root equals: path.
	^ path
]

{ #category : #example }
IpfsExamples >> ipfsPathToFile [
	<gtExample>
	| path |
	path := self ipfsPathToDirectory / 'about'.
	self assert: (path root = path) not.
	^ path
]

{ #category : #examples }
IpfsExamples >> ipfsPathToWebExplorer [
	<gtExample>
	^ '/ipfs/QmfQkD8pBSBCBxWEwFSu4XaDVSWK6bjnNuaWZjMyQbyDub/#/explore/'
]

{ #category : #examples }
IpfsExamples >> ipnsKey [
	<gtExample>
	<after: #deleteIpnsKey>
	^ self localIpfsPeer generateKeyNamed: #PharoIPFSTest
]

{ #category : #examples }
IpfsExamples >> ipnsPath [
	<gtExample>
	^ self ipnsKey asIpfsPath / #a
]

{ #category : #examples }
IpfsExamples >> loadIpnsPath [
	<gtExample>
	^ self ipnsPath loadObject
]

{ #category : #examples }
IpfsExamples >> loadNonResolvablePath [
	<gtExample>
	^ self nonResolvablePathIntoNestedDataStructure loadJson
]

{ #category : #examples }
IpfsExamples >> loadRawBlock [
	<gtExample>
	| block |
	block := self rawBlockCid loadJson.
	self assert: block equals: #[1 2 3 2 1].
	^ block
]

{ #category : #examples }
IpfsExamples >> loadResolvedPath [
	<gtExample>
	^ self resolvedPathIntoNestedDataStructure loadJson
]

{ #category : #examples }
IpfsExamples >> localIpfsPeer [
	<gtExample>
	^ IpfsPeer local
]

{ #category : #examples }
IpfsExamples >> nonResolvablePathIntoNestedDataStructure [
	<gtExample>
	| path |
	path := self pathIntoNestedDataStructure / #a.
	path := path resolve.
	self assert: path relativePath equals: #a.
	^ path

]

{ #category : #examples }
IpfsExamples >> openRawBlockInLocalWebExplorer [
	<gtExample>
	WebBrowser openOn:
		'http://127.0.0.1:5001',
		self ipfsPathToWebExplorer,
		self rawBlockCid asString.

]

{ #category : #examples }
IpfsExamples >> pathIntoNestedDataStructure [
	<gtExample>
	^ self pathToNestedDataStructure / #data

]

{ #category : #examples }
IpfsExamples >> pathToNestedDataStructure [
	<gtExample>
	^ self cborCidForJSONMapWithReference asIpfsPath

]

{ #category : #examples }
IpfsExamples >> protobufCid [
	<gtExample>
	"There is no support for creating Protobuf objects from Pharo for now.
	Use a CID from the documentation for the IPFS CLI."
	^ 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG' asIpfsCid
]

{ #category : #examples }
IpfsExamples >> publishCid [
	<gtExample>
	| cid key |
	cid := self cborCidForJSONMap.
	key := self ipnsKey.
	key publish: cid.
]

{ #category : #examples }
IpfsExamples >> publishPath [
	<gtExample>
	| path key |
	path := self cborCidForJSONMap asIpfsPath / #a.
	key := self ipnsKey.
	key publish: path.
	^ { key. path }
]

{ #category : #examples }
IpfsExamples >> rawBlockCid [
	<gtExample>
	^ #[1 2 3 2 1] storeInIpfs
]

{ #category : #examples }
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

{ #category : #examples }
IpfsExamples >> resolveIpnsPath [
	<gtExample>
	^ self ipnsPath resolve
]

{ #category : #examples }
IpfsExamples >> resolvedPathIntoNestedDataStructure [
	<gtExample>
	| resolvedPath |
	resolvedPath := self pathIntoNestedDataStructure resolve.
	self assert: resolvedPath equals: self cborCidForJSONMap asIpfsPath.
	self assert: resolvedPath relativePath equals: ''.
	^ resolvedPath
]

{ #category : #examples }
IpfsExamples >> storeDataAndCheckItsAbsenceAfterGarbageCollection [
	<gtExample>
	| cid |
	cid := self storeDataAndCheckItsPresenceOnLocalPeer.
	self localIpfsPeer collectGarbage.
	self assert: (self allCidsOnlocalIpfsPeer includes: cid) not.
	^ cid
]

{ #category : #examples }
IpfsExamples >> storeDataAndCheckItsPresenceOnLocalPeer [
	<gtExample>
	| cid |
	cid := self rawBlockCid storeInIpfs.
	self assert: (self allCidsOnlocalIpfsPeer includes: cid).
	^ cid
]

{ #category : #examples }
IpfsExamples >> storeDataPinAndCheckItsPresenceAfterGarbageCollection [
	<gtExample>
	| cid |
	cid := self rawBlockCid storeInIpfs.
	self localIpfsPeer pin: cid.
	self localIpfsPeer collectGarbage.
	self assert: (self allCidsOnlocalIpfsPeer includes: cid).
	^ cid
]

{ #category : #examples }
IpfsExamples >> storeDataPinUnpinAndCheckItsAbsenceAfterGarbageCollection [
	<gtExample>
	| cid |
	cid := self storeDataPinAndCheckItsPresenceAfterGarbageCollection.
	self localIpfsPeer unpin: cid.
	self localIpfsPeer collectGarbage.
	self assert: (self allCidsOnlocalIpfsPeer includes: cid) not.
	^ cid
]

{ #category : #examples }
IpfsExamples >> urlForExploringRawBlockInRemoteWebExplorer [
	<gtExample>
	^ 'https://explore.ipld.io/#/explore/',
		self rawBlockCid asString.
]
