Class {
	#name : #IpldLink,
	#superclass : #Object,
	#instVars : [
		'cid',
		'size'
	],
	#category : #'IPFSExploration-IPLD'
}

{ #category : #'instance creation' }
IpldLink class >> cid: aString [
	^ self basicNew
		initializeWithCid: aString size: nil;
		yourself
]

{ #category : #'instance creation' }
IpldLink class >> cid: aString size: anInteger [
	^ self basicNew
		initializeWithCid: aString size: anInteger;
		yourself
]

{ #category : #acccessing }
IpldLink >> getNode [
	^ IpfsClient getIpldNode: cid
]

{ #category : #initialization }
IpldLink >> initializeWithCid: aString size: anInteger [
	cid := aString.
	size := anInteger.
]
