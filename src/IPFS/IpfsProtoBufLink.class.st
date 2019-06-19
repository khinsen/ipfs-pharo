Class {
	#name : #IpfsProtoBufLink,
	#superclass : #Object,
	#instVars : [
		'cid',
		'size'
	],
	#category : #'IPFS-3 - Files'
}

{ #category : #'instance creation' }
IpfsProtoBufLink class >> cid: aString [
	^ self basicNew
		initializeWithCid: aString size: nil;
		yourself
]

{ #category : #'instance creation' }
IpfsProtoBufLink class >> cid: aString size: anInteger [
	^ self basicNew
		initializeWithCid: aString size: anInteger;
		yourself
]

{ #category : #accessing }
IpfsProtoBufLink >> cid [
	^ cid
]

{ #category : #accessing }
IpfsProtoBufLink >> dataSize [
	^ size
]

{ #category : #accessing }
IpfsProtoBufLink >> getObject [
	^ Ipfs objectGet: cid
]

{ #category : #initialization }
IpfsProtoBufLink >> initializeWithCid: aString size: anInteger [
	cid := aString.
	size := anInteger.
]
