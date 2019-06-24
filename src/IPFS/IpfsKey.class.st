"
!A key used for naming (IPNS)

Keys are specific to an ${class:name=IpfsPeer}$, where each key has a unique name. The peer stores both the public and the private part. An ID derived from the public key serves as a name in IPNS.

"
Class {
	#name : #IpfsKey,
	#superclass : #Object,
	#instVars : [
		'peer',
		'name',
		'id',
		'waiting'
	],
	#category : #'IPFS-4 - Names'
}

{ #category : #'instance creation' }
IpfsKey class >> peer: anIpfsPeer name: aSymbolOrString id: aString [
	^ self basicNew
		initializeWithPeer: anIpfsPeer
			name: aSymbolOrString asSymbol
			id: aString;
		yourself
]

{ #category : #converting }
IpfsKey >> asIpfsPath [
	^ IpfsNamePath new name: self id

]

{ #category : #deleting }
IpfsKey >> delete [
	peer deleteKeyNamed: name
]

{ #category : #accessing }
IpfsKey >> id [
	^ id
]

{ #category : #initialization }
IpfsKey >> initializeWithPeer: anIpfsPeer name: aSymbol id: aString [
	peer := anIpfsPeer.
	name := aSymbol.
	id := aString.
	waiting := false.
]

{ #category : #accessing }
IpfsKey >> isWaiting [
	^ waiting
]

{ #category : #accessing }
IpfsKey >> load [
	| resolvedPath |
	resolvedPath := self resolveWithTimeout: 1 second.
	resolvedPath ifNil: [ self error: 'Path could not be resolved' ].
	resolvedPath isFullyResolvedPath ifFalse: [ self error: 'Path not resolvable to a CID' ].
	^ resolvedPath cid loadLinkedObjects
]

{ #category : #accessing }
IpfsKey >> name [
	^ name
]

{ #category : #accessing }
IpfsKey >> peer [
	^ peer
]

{ #category : #publishing }
IpfsKey >> publish: ipfsPath [
	self waitForLastRequest.
	waiting := true.
	[	peer publish: ipfsPath asIpfsPath key: self.
		waiting := false. ]
	newProcess resume.


]

{ #category : #publishing }
IpfsKey >> publish: ipfsPath lifetime: aDuration [
	self waitForLastRequest.
	waiting := true.
	[	peer publish: ipfsPath asIpfsPath key: self lifetime: aDuration.
		waiting := false. ]
	newProcess resume.

]

{ #category : #renaming }
IpfsKey >> rename: aSymbol [
	peer renameKeyNamed: name to: aSymbol.
	name := aSymbol 
]

{ #category : #resolving }
IpfsKey >> resolve [
	self waitForLastRequest.
	^ self asIpfsPath resolve
]

{ #category : #resolving }
IpfsKey >> resolveWithTimeout: aDuration [
	self waitForLastRequest.
	^ self asIpfsPath resolveWithTimeout: aDuration
]

{ #category : #publishing }
IpfsKey >> waitForLastRequest [
	[ waiting ] whileTrue: [ 1 second asDuration wait ]
]
