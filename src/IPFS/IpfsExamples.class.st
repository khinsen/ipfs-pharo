"
!Examples for IPLD objects

"
Class {
	#name : #IpfsExamples,
	#superclass : #Object,
	#category : #'IPFS-Examples'
}

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
IpfsExamples >> gitObjectCid [
	<gtExample>
	"There is no support for creating git-raw objects from Pharo for now.
	Use a commit from an IPFS repository that is already stored in IPFS."
	^ 'z8mWaJHXieAVxxLagBpdaNWFEBKVWmMiE' asIpfsCid
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
