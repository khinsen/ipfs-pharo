"
!Content identifier for protobuf DAG nodes 

These nodes are used in the first-generation IPFS file layer. The next-generation file layer will use CBOR DAG nodes (see ${class:name=IpfsCborCid}$).
"
Class {
	#name : #IpfsProtobufCid,
	#superclass : #IpfsCid,
	#category : #'IPFS-2 - Linked data'
}

{ #category : #'instance creation' }
IpfsProtobufCid class >> codec [
	^ #protobuf
]