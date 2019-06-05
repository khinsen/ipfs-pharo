"
!Content identifier for raw blocks 

A raw block stores a byte sequence that is not interpreted by IPFS software in any way.
"
Class {
	#name : #IpfsRawCid,
	#superclass : #IpfsCid,
	#category : #'IPFS-1 - Blocks'
}

{ #category : #'instance creation' }
IpfsRawCid class >> codec [
	^ #raw
]

{ #category : #'data access' }
IpfsRawCid >> loadObject [
	^ self loadRawBlock
]
