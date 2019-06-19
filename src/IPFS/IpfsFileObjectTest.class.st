"
!Tests for the IPFS layer

"
Class {
	#name : #IpfsFileObjectTest,
	#superclass : #TestCase,
	#category : #'IPFS-Tests '
}

{ #category : #testing }
IpfsFileObjectTest >> testIPFSCLIDocumentation [
	| ipfsObject |
	ipfsObject := Ipfs objectGet: 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'.
	self assert: ipfsObject data equals: #[8 1].
	self assert: ipfsObject links size equals: 6.
	self assert: ipfsObject links keys asSet
		  equals: #('about' 'contact' 'help' 'quick-start' 'readme' 'security-notes') asSet.
	ipfsObject links values
		do: [ :each | self assert: (each isKindOf: IpfsProtoBufLink) ].

]
