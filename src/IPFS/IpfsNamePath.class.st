"
!Path starting from a name

These paths take the form ==/ipns/<name>/<link1>/<link2>/...==.

"
Class {
	#name : #IpfsNamePath,
	#superclass : #IpfsPath,
	#instVars : [
		'name'
	],
	#category : #'IPFS-1 - Paths'
}

{ #category : #converting }
IpfsNamePath >> asString [
	| elements |
	elements :=  OrderedCollection with: '' with: #ipns with: name.
	elements addAll: linkSequence.
	^ '/' join: elements
]

{ #category : #accessing }
IpfsNamePath >> name [
	^ name
]

{ #category : #accessing }
IpfsNamePath >> name: aString [
	name := aString
]
