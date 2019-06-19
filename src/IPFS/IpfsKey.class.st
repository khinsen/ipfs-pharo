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
		'id'
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
]

{ #category : #accessing }
IpfsKey >> name [
	^ name
]

{ #category : #publishing }
IpfsKey >> publish: ipfsPath [ 
	^ peer publish: ipfsPath asIpfsPath key: self

]

{ #category : #publishing }
IpfsKey >> publish: ipfsPath lifetime: aDuration [
	^ peer publish: ipfsPath asIpfsPath key: self lifetime: aDuration

]

{ #category : #renaming }
IpfsKey >> rename: aSymbol [
	peer renameKeyNamed: name to: aSymbol.
	name := aSymbol 
]

{ #category : #accessing }
IpfsKey >> resolve [
	^ self asIpfsPath resolve
]

{ #category : #accessing }
IpfsKey >> resolveWithTimeout: aDuration [
	^ self asIpfsPath resolveWithTimeout: aDuration
]
