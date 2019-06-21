"
!IPFS-style links to Pharo objects 

IPFS described links between data structures by ${class:name=IpfsCid}$. Reading linked data structures as Pharo objects requires a Pharo representation for the links. This class fulfills this role. It acts as a proxy for the link target, meaning that links are almost transparent. Only when storing an object to IPFS, links take on a special behavior: they store the link target and put the resulting ${class:name=IpfsCid}$ in place of the link origin.

"
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
