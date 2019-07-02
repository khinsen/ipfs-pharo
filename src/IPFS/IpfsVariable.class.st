"
!A (global) variable in IPFS

This class associates an ${class:name=IpfsKey}$ with a Pharo object. The method ${method:name=IpfsVariable>>#store}$ stores the current value in IPFS, pins it, and publishes it as the new value of the key. Prior values are unpinned.
"
Class {
	#name : #IpfsVariable,
	#superclass : #Object,
	#instVars : [
		'key',
		'value'
	],
	#category : #'IPFS-4 - Names'
}

{ #category : #'instance creation' }
IpfsVariable class >> key: anIpfsKey [
	^ self basicNew
		initializeWithKey: anIpfsKey;
		yourself
]

{ #category : #'instance creation' }
IpfsVariable class >> key: anIpfsKey value: anObject [
	^ self basicNew
		initializeWithKey: anIpfsKey value: anObject;
		yourself
]

{ #category : #initialization }
IpfsVariable >> initializeWithKey: anIpfsKey [
	key := anIpfsKey.
	self load.
]

{ #category : #initialization }
IpfsVariable >> initializeWithKey: anIpfsKey value: anObject [
	key := anIpfsKey.
	value := anObject.

]

{ #category : #accessing }
IpfsVariable >> load [
	value := key load.
]

{ #category : #accessing }
IpfsVariable >> store [
	| oldPath oldCid newCid |
	oldPath := key resolveNamesWithTimeout: 1 second.
	self assert: oldPath relativePath isEmpty.
	oldCid := oldPath cid.
	newCid := value storeInIpfs.
	newCid = oldCid ifTrue: [ ^ self ].
	key publish: newCid.
	key peer pinRecursively: newCid.
	oldCid ifNotNil: [ key peer unpinRecursively: oldCid ].

]

{ #category : #accessing }
IpfsVariable >> value [
	^ value
]

{ #category : #accessing }
IpfsVariable >> value: anObject [
	value := anObject
]
