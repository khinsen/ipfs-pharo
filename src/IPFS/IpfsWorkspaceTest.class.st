"
!Tests for ${class:name=IpfsWorkspace}$
"
Class {
	#name : #IpfsWorkspaceTest,
	#superclass : #TestCase,
	#instVars : [
		'workspace'
	],
	#category : #'IPFS-Tests '
}

{ #category : #running }
IpfsWorkspaceTest >> setUp [
	workspace := IpfsWorkspace subclass: #AnIpfsWorkspaceForTesting
]

{ #category : #running }
IpfsWorkspaceTest >> tearDown [
	workspace removeFromSystem
]

{ #category : #testing }
IpfsWorkspaceTest >> testStoreAndLoad [
	self assert: workspace dataMethods isEmpty.
	workspace at: #foo put: #bar.
	self assert: workspace dataMethods isEmpty.
	workspace update.
	self assert: (workspace dataMethods collect: #selector) equals: #(loadfoo).
	workspace reset.
	self assert: (workspace at: #foo) equals: #bar.

]
