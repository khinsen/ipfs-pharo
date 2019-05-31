"
!Content identifier for protobuf nodes 

These nodes are used for the first-generation IPFS file layer. The next-generation file layer will use IPD DAG nodes (see ${class:name=IpldDagCid}$).
"
Class {
	#name : #IpfsObjectCid,
	#superclass : #IpldCid,
	#category : #'IPFS-Files'
}

{ #category : #'instance creation' }
IpfsObjectCid class >> codec [
	^ #protobuf
]

{ #category : #'as yet unclassified' }
IpfsObjectCid >> gtDataFor: aView [
	<gtView>
	^ (self loadObject gtDataFor: aView)
		priority: -6;
		yourself.

]

{ #category : #'as yet unclassified' }
IpfsObjectCid >> gtLinksFor: aView [
	<gtView>
	^ (self loadObject gtLinksFor: aView)
		priority: -5;
		yourself.

]
