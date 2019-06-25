"
!Content identifier for standard IPLD DAG nodes

These are (or at least will be) the most common nodes in the IPLD DAG. They contain a data structure encoded using the *Concise Binary Object Representation (CBOR)>https://en.wikipedia.org/wiki/CBOR*, which is very similar to JSON but uses a more compact binary representation.
"
Class {
	#name : #IpfsCborCid,
	#superclass : #IpfsCid,
	#category : #'IPFS-2 - Linked data'
}

{ #category : #'instance creation' }
IpfsCborCid class >> codec [
	^ #cbor
]

{ #category : #'data access' }
IpfsCborCid >> decodeLinkedObjectsFromIpfs [
	^ IpfsLink to: self loadLinkedObjects

]

{ #category : #'data access' }
IpfsCborCid >> loadLinkedObjects [
	^ self loadAndDecode decodeLinkedObjectsFromIpfs
]

{ #category : #'data access' }
IpfsCborCid >> loadObject [
	^ self loadAndDecode decodeFromIpfs
]

{ #category : #resolving }
IpfsCborCid >> resolveLink: aString [
	^ self loadAndDecode at: aString
]
