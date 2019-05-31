Class {
	#name : #IpfsLink,
	#superclass : #Object,
	#instVars : [
		'cid',
		'size'
	],
	#category : #'IPFS-Files'
}

{ #category : #'instance creation' }
IpfsLink class >> cid: aString [
	^ self basicNew
		initializeWithCid: aString size: nil;
		yourself
]

{ #category : #'instance creation' }
IpfsLink class >> cid: aString size: anInteger [
	^ self basicNew
		initializeWithCid: aString size: anInteger;
		yourself
]

{ #category : #acccessing }
IpfsLink >> getObject [
	^ Ipfs objectGet: cid
]

{ #category : #initialization }
IpfsLink >> initializeWithCid: aString size: anInteger [
	cid := aString.
	size := anInteger.
]