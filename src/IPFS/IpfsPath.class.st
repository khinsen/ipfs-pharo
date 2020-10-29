"
!Path to a block stored in IPFS
"
Class {
	#name : #IpfsPath,
	#superclass : #Object,
	#instVars : [
		'linkSequence'
	],
	#category : #'IPFS-1 - CIDs and paths'
}

{ #category : #accessing }
IpfsPath class >> fromString: aString [
	| elements path |
	elements := aString splitOn: $/.
	elements size = 1
		ifTrue: [ ^ elements first asIpfsCid asIpfsPath ].
	self assert: elements size >= 3.
	self assert: elements first = ''.
	self assert: (#('ipfs' 'ipns') includes: elements second).
	path := elements second = #ipfs
		ifTrue: [ IpfsCidPath new cid: (IpfsCid fromString: elements third) ]
		ifFalse: [ IpfsNamePath new name: elements third ].
	4 to: elements size do: [ :i | path := path / (elements at: i) ].
	^ path
]

{ #category : #adding }
IpfsPath >> / aString [
	^ self deepCopy addLinks: (aString splitOn: $/)
]

{ #category : #comparing }
IpfsPath >> = anIpfsPath [
	^ self asString = anIpfsPath asString

]

{ #category : #private }
IpfsPath >> addLinks: aLinkSequence [
	linkSequence := linkSequence, aLinkSequence
]

{ #category : #converting }
IpfsPath >> asFileReference [
	^ IpfsFileReference fromIpfsPath: self
]

{ #category : #accessing }
IpfsPath >> asIpfsPath [
	^ self
]

{ #category : #accessing }
IpfsPath >> extension [
	linkSequence ifEmpty: [ ^ '' ].
	^ linkSequence last copyAfterLast: $.
]

{ #category : #comparing }
IpfsPath >> hash [
	^ self asString hash
]

{ #category : #initialization }
IpfsPath >> initialize [
	linkSequence := Array new.
]

{ #category : #testing }
IpfsPath >> isRaw [
	^ false
]

{ #category : #testing }
IpfsPath >> isUnixfsDirectory [
	^ self isUnixfsPath and: [ (self unixfsNodeInfo at: #Type) = 'directory' ]
]

{ #category : #testing }
IpfsPath >> isUnixfsFile [
	^ self isUnixfsPath and: [ (self unixfsNodeInfo at: #Type) = 'file' ]
]

{ #category : #testing }
IpfsPath >> isUnixfsPath [
	self subclassResponsibility
]

{ #category : #'data access' }
IpfsPath >> loadJson [
	^ Ipfs dagGet: self
]

{ #category : #'data access' }
IpfsPath >> loadObject [
	^ self loadObjectUsing: IpfsDefaultMapper default
]

{ #category : #'data access' }
IpfsPath >> loadObjectInBackground [
	self subclassResponsibility
]

{ #category : #'data access' }
IpfsPath >> loadObjectUsing: anIpfsMapper [
	^ self loadJson decodeFromIpfsUsing: anIpfsMapper
]

{ #category : #printing }
IpfsPath >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(;
			  nextPutAll: self asString;
			  nextPut: $).

]

{ #category : #'data access' }
IpfsPath >> references [
	^ Ipfs refs: self recursive: false
]

{ #category : #accessing }
IpfsPath >> relativePath [
	^ $/ join: linkSequence
]

{ #category : #resolving }
IpfsPath >> resolve [
	"Resolve paths as much as possible, until remaining links stay inside the node."
	self subclassResponsibility
]

{ #category : #resolving }
IpfsPath >> resolveNames [
	"Resolve /ipns paths recursively until an /ipfs path is obtained."
	self subclassResponsibility
]

{ #category : #printing }
IpfsPath >> storeOn: aStream [
	aStream nextPutAll: '(IpfsPath fromString: '.
	self asString storeOn: aStream.
	aStream nextPut: $).

]

{ #category : #'data access' }
IpfsPath >> unixfsBinaryReadStream [
	self assert: self isUnixfsPath description: 'Not a Unixfs path'.
	^ Ipfs cat: self
]

{ #category : #accessing }
IpfsPath >> unixfsDirectoryEntries [
	| data |
	self isUnixfsDirectory ifFalse: [ ^ Array new ].
	data := self loadJson.
	(data at: #data) = 'CAE=' ifFalse: [ ^ Array new ].
	^ data at: #links
]

{ #category : #'data access' }
IpfsPath >> unixfsNodeInfo [
	self isUnixfsPath ifFalse: [ ^ nil ].
	^ Ipfs filesStat: self
]
