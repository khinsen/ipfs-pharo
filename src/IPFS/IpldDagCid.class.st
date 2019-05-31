"
!Content identifier for IPLD DAG nodes

These nodes form the IPD DAG. Their data is a byte sequence encoding the data using the *Concise Binary Object Representation (CBOR)>https://en.wikipedia.org/wiki/CBOR*.
"
Class {
	#name : #IpldDagCid,
	#superclass : #IpldCid,
	#category : #'IPFS-Linked data'
}

{ #category : #'instance creation' }
IpldDagCid class >> codec [
	^ #cbor
]
