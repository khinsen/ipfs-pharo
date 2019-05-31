"
!Content identifier for raw nodes 

A raw node stores a byte sequence that is not interpreted by IPFS at all.
"
Class {
	#name : #IpldRawCid,
	#superclass : #IpldCid,
	#category : #'IPFS-Linked data'
}

{ #category : #'instance creation' }
IpldRawCid class >> codec [
	^ #raw
]
