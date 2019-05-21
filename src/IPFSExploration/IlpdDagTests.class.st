Class {
	#name : #IlpdDagTests,
	#superclass : #TestCase,
	#category : #'IPFSExploration-Tests '
}

{ #category : #testing }
IlpdDagTests >> testIPFSCLIDocumentation [
	| dagNode |
	dagNode := IpfsNode ipldNodeAt: 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'.
	self assert: dagNode data equals: #[67 65 69 61].
	self assert: dagNode links size equals: 6.
	self assert: dagNode links keys asSet
		  equals: #('about' 'contact' 'help' 'quick-start' 'readme' 'security-notes') asSet.
	dagNode links values
		do: [ :each | self assert: (each isKindOf: IpldLink) ].

]
