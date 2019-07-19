"
!Workspace of data stored in IPFS

A workspace is a dictionary mapping symbols to values, which must be objects storable in IPFS. When the method ${method:name=IpfsWorkspace>>#update}$ is called, the CIDs of the values are stored in methods, one for each key-value pair. When the workspace is initialized, the data is loaded from IPFS via the CIDs.

Such workspaces are useful to add data to a version-controlled code repository. The typical use case is a Pharo package containing a subclass of ${class:name=IpfsWorkspace}$ in which it keeps data such as documentation, datasets for demos or tests, etc. Updating the workspace just before committing a new code version ensures that the repository references the current data values.

"
Class {
	#name : #IpfsWorkspace,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'data'
	],
	#category : #'IPFS-6 - Utilities'
}

{ #category : #accessing }
IpfsWorkspace class >> at: aSymbol [
	^ self uniqueInstance at: aSymbol
]

{ #category : #accessing }
IpfsWorkspace class >> at: aSymbol put: anObject [
	^ self uniqueInstance at: aSymbol put: anObject
]

{ #category : #accessing }
IpfsWorkspace class >> dataMethods [
	^ self methods select: [ :each | each protocol = 'data']
]

{ #category : #testing }
IpfsWorkspace class >> isAbstract [
	^ self name == #IpfsWorkspace
]

{ #category : #accessing }
IpfsWorkspace class >> update [
	self uniqueInstance update
]

{ #category : #accessing }
IpfsWorkspace >> at: aSymbol [
	^ data at: aSymbol
]

{ #category : #accessing }
IpfsWorkspace >> at: aSymbol put: aValue [
	^ data at: aSymbol put: aValue
]

{ #category : #updating }
IpfsWorkspace >> generateDataMethodFor: key cid: anIpfsCid [
	self class compile:
		'load', key asString, Character cr asString,
		'   data at: ', key storeString, ' put: ', anIpfsCid storeString, ' loadObject'
		classified: 'data'
]

{ #category : #initialization }
IpfsWorkspace >> initialize [
	super initialize.
	data := Dictionary new.
	self class dataMethods do:
		[ :each | each valueWithReceiver: self arguments: Array new ]
]

{ #category : #updating }
IpfsWorkspace >> update [
	| dataSelectors |
	dataSelectors := self class dataMethods collect: [ :each | each selector ].
	dataSelectors do: [ :each | self class removeSelector: each ].
	data keysAndValuesDo:
		[ :key :value |
			self generateDataMethodFor: key cid: value storeInIpfs  ]
]
