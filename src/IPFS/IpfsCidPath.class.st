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
	#category : #'IPFS-1 - CIDs and paths'
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

{ #category : #testing }
IpfsCidPath >> isRaw [
	^ linkSequence isEmpty and: [ cid isRaw ]
]

{ #category : #testing }
IpfsCidPath >> isUnixfsPath [
	^ self cid isDagPbCid
]

{ #category : #'data access' }
IpfsCidPath >> loadObjectInBackground [
	^ IpfsCache loadObjectFromPath: self
]

{ #category : #accessing }
IpfsCidPath >> name [
	^ nil
]

{ #category : #resolving }
IpfsCidPath >> resolve [
	^ Ipfs dagResolve: self asString
]

{ #category : #resolving }
IpfsCidPath >> resolveNames [
	^ self
]
