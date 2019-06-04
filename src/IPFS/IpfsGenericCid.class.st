"
!Content identifier for generic DAG nodes

This class covers all codecs for which there is no specific subclass of ${class:name=IpfsCid}$.
"
Class {
	#name : #IpfsGenericCid,
	#superclass : #IpfsCid,
	#category : #'IPFS-2 - Linked data'
}

{ #category : #'instance creation' }
IpfsGenericCid class >> codec [
	^ nil
]
