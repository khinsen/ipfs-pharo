"
!Content identifier for protobuf nodes 

These nodes are used for the first-generation IPFS file layer. The next-generation file layer will use IPD DAG nodes (see ${class:name=IpldDagCid}$).
"
Class {
	#name : #IpfsObjectCid,
	#superclass : #IpldCid,
	#category : #'IPFS-Linked data'
}

{ #category : #'instance creation' }
IpfsObjectCid class >> codec [
	^ #protobuf
]
