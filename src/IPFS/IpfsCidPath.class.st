"
!Path starting from a CID

These paths take the form ==/ipfs/<cid>/<link1>/<link2>/...==.

"
Class {
	#name : #IpfsCidPath,
	#superclass : #IpfsPath,
	#instVars : [
		'cid'
	],
	#category : #'IPFS-1 - Paths'
}

{ #category : #converting }
IpfsCidPath >> asString [
	| elements |
	elements :=  OrderedCollection with: '' with: #ipfs with: cid asString.
	elements addAll: linkSequence.
	^ '/' join: elements
]

{ #category : #accessing }
IpfsCidPath >> cid [
	^ cid

]

{ #category : #accessing }
IpfsCidPath >> cid: anIpfsCid [
	cid := anIpfsCid.

]

{ #category : #resolving }
IpfsCidPath >> resolve [
	^ self
]
