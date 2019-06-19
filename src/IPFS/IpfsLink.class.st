Class {
	#name : #IpfsLink,
	#superclass : #ProtoObject,
	#instVars : [
		'target'
	],
	#category : #'IPFS-2 - Linked data'
}

{ #category : #'instance creation' }
IpfsLink class >> to: anObject [
	^ self new initializeWithTarget: anObject
]

{ #category : #'reflective operations' }
IpfsLink >> doesNotUnderstand: aMessage [
	^ target perform: aMessage selector withArguments: aMessage arguments

]

{ #category : #converting }
IpfsLink >> encodeForIpfs [
	^ target storeInIpfs
]

{ #category : #initialization }
IpfsLink >> initializeWithTarget: anObject [
	target := anObject
]
