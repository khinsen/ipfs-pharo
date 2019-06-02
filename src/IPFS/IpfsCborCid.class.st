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
