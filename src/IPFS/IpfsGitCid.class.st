"
!Content identifier for Git objects


"
Class {
	#name : #IpfsGitCid,
	#superclass : #IpfsCidOldImplementation,
	#category : #'IPFS-2 - Linked data'
}

{ #category : #'instance creation' }
IpfsGitCid class >> codec [
	^ #'git-raw'
]
