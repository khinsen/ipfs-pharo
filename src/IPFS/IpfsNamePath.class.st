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
	#category : #'IPFS-4 - Names'
}

{ #category : #converting }
IpfsNamePath >> asString [
	| elements |
	elements :=  OrderedCollection with: '' with: #ipns with: name.
	elements addAll: linkSequence.
	^ '/' join: elements
]

{ #category : #testing }
IpfsNamePath >> isFullyResolvedPath [
	^ false
]

{ #category : #accessing }
IpfsNamePath >> name [
	^ name
]

{ #category : #accessing }
IpfsNamePath >> name: aString [
	name := aString
]

{ #category : #resolving }
IpfsNamePath >> resolve [
	^ self resolveWithDefault: nil
]

{ #category : #resolving }
IpfsNamePath >> resolveWithDefault: anObject [
	| path |
	path := Ipfs resolvePath: self asString.
	path ifNil: [ ^ anObject ].
	^ IpfsPath fromString: path
]

{ #category : #resolving }
IpfsNamePath >> resolveWithTimeout: aDuration [
	^ self resolveWithTimeout: aDuration default: nil
]

{ #category : #resolving }
IpfsNamePath >> resolveWithTimeout: aDuration default: anObject [
	| pathString |
	pathString := Ipfs resolvePath: self asString timeout: aDuration.
	pathString
		ifNotNil: [ :s | ^ IpfsPath fromString: s ]
		ifNil: [ ^ anObject ]
	
]
