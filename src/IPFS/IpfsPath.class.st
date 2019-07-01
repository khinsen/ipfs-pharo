"
!Path to a block stored in IPFS
"
Class {
	#name : #IpfsPath,
	#superclass : #Object,
	#instVars : [
		'linkSequence'
	],
	#category : #'IPFS-1 - CIDs and paths'
}

{ #category : #accessing }
IpfsPath class >> fromString: aString [
	| elements path |
	elements := aString splitOn: $/.
	self assert: elements size >= 3.
	self assert: elements first = ''.
	self assert: (#('ipfs' 'ipns') includes: elements second).
	path := (elements second = #ipfs)
			ifTrue: [ IpfsCidPath new cid: (IpfsCid fromString: elements third) ]
			ifFalse: [ IpfsNamePath new name: elements third ].
	4 to: elements size do:
		[ :i | path := path / (elements at: i) ].
	^ path
]

{ #category : #adding }
IpfsPath >> / aString [
	linkSequence add: aString
]

{ #category : #comparing }
IpfsPath >> = anIpfsPath [
	^ self asString = anIpfsPath asString

]

{ #category : #accessing }
IpfsPath >> asIpfsPath [
	^ self
]

{ #category : #comparing }
IpfsPath >> hash [
	^ self asString hash
]

{ #category : #initialization }
IpfsPath >> initialize [
	linkSequence := OrderedCollection new.
]

{ #category : #printing }
IpfsPath >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(;
			  nextPutAll: self asString;
			  nextPut: $).

]

{ #category : #resolving }
IpfsPath >> resolve [
	self subclassResponsibility
]

{ #category : #resolving }
IpfsPath >> resolveLinks [
	self subclassResponsibility
]
