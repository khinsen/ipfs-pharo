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
IpfsExamples >> cborCidForMap [
	<gtExample>
	^ { #a -> 1. #b -> 2 } asDictionary storeInIpfs
]

{ #category : #examples }
IpfsExamples >> cborCidForMapWithReference [
	<gtExample>
	^ { #data -> self cborCidForMap } asDictionary storeInIpfs

]

{ #category : #examples }
IpfsExamples >> cborCidForString [
	<gtExample>
	^ 'foo' storeInIpfs
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

{ #category : #examples }
IpfsExamples >> ipfsPathToWebExplorer [
	<gtExample>
	^ '/ipfs/QmfQkD8pBSBCBxWEwFSu4XaDVSWK6bjnNuaWZjMyQbyDub/#/explore/'
]

{ #category : #examples }
IpfsExamples >> loadRawBlock [
	<gtExample>
	| block |
	block := self rawBlockCid loadAndDecode.
	self assert: block equals: #[1 2 3 2 1].
	^ block
]

{ #category : #examples }
IpfsExamples >> localIpfsPeer [
	<gtExample>
	^ IpfsPeer local
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
IpfsExamples >> protobufCid [
	<gtExample>
	"There is no support for creating Protobuf objects from Pharo for now.
	Use a CID from the documentation for the IPFS CLI."
	^ 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG' asIpfsCid
]

{ #category : #examples }
IpfsExamples >> rawBlockCid [
	<gtExample>
	^ #[1 2 3 2 1] storeInIpfs
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
