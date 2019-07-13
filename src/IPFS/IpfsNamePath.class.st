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

{ #category : #accessing }
IpfsNamePath >> cid [
	^ nil
]

{ #category : #'data access' }
IpfsNamePath >> loadObjectInBackground [
	^ IpfsCache resolveAndloadObjectFromPath: self

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
	self resolveNames
		ifNil: [ ^ nil ]
		ifNotNil: [ :path | ^ path resolve ]
]

{ #category : #resolving }
IpfsNamePath >> resolveNames [
	^ self resolveNamesWithDefault: nil
]

{ #category : #resolving }
IpfsNamePath >> resolveNamesWithDefault: anObject [
	| path |
	path := Ipfs nameResolve: self asString.
	path ifNil: [ ^ anObject ].
	^ IpfsPath fromString: path
]

{ #category : #resolving }
IpfsNamePath >> resolveNamesWithTimeout: aDuration [
	^ self resolveNamesWithTimeout: aDuration default: nil
]

{ #category : #resolving }
IpfsNamePath >> resolveNamesWithTimeout: aDuration default: anObject [
	| pathString |
	pathString := Ipfs nameResolve: self asString timeout: aDuration.
	pathString
		ifNotNil: [ :s | ^ IpfsPath fromString: s ]
		ifNil: [ ^ anObject ]
	
]

{ #category : #resolving }
IpfsNamePath >> substituteNameBy: anIpfsPath [
	^ anIpfsPath / self relativePath
]
