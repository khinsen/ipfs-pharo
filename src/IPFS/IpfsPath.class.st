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
	elements size = 1
		ifTrue: [ ^ elements first asIpfsCid asIpfsPath ].
	self assert: elements size >= 3.
	self assert: elements first = ''.
	self assert: (#('ipfs' 'ipns') includes: elements second).
	path := elements second = #ipfs
		ifTrue: [ IpfsCidPath new cid: (IpfsCid fromString: elements third) ]
		ifFalse: [ IpfsNamePath new name: elements third ].
	4 to: elements size do: [ :i | path := path / (elements at: i) ].
	^ path
]

{ #category : #adding }
IpfsPath >> / aString [
	^ self deepCopy addLinks: (aString splitOn: $/)
]

{ #category : #comparing }
IpfsPath >> = anIpfsPath [
	^ self asString = anIpfsPath asString

]

{ #category : #private }
IpfsPath >> addLinks: aLinkSequence [
	linkSequence := linkSequence, aLinkSequence
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
	linkSequence := Array new.
]

{ #category : #testing }
IpfsPath >> isRaw [
	^ false
]

{ #category : #'data access' }
IpfsPath >> loadJson [
	^ Ipfs dagGet: self
]

{ #category : #'data access' }
IpfsPath >> loadObject [
	^ self loadJson decodeFromIpfs
]

{ #category : #'data access' }
IpfsPath >> loadObjectInBackground [
	self subclassResponsibility
]

{ #category : #printing }
IpfsPath >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(;
			  nextPutAll: self asString;
			  nextPut: $).

]

{ #category : #accessing }
IpfsPath >> relativePath [
	^ $/ join: linkSequence
]

{ #category : #resolving }
IpfsPath >> resolve [
	"Resolve paths as much as possible, until remaining links stay inside the node."
	self subclassResponsibility
]

{ #category : #resolving }
IpfsPath >> resolveNames [
	"Resolve /ipns paths recursively until an /ipfs path is obtained."
	self subclassResponsibility
]

{ #category : #printing }
IpfsPath >> storeOn: aStream [
	aStream nextPutAll: '(IpfsPath fromString: '.
	self asString storeOn: aStream.
	aStream nextPut: $).

]
