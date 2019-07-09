"
!A proxy for requesting IPFS data asynchronously

This is a singleton that accepts requests for IPFS name resolution or for IPFS data objects, executes them asynchronously, and caches the results. Until the requested data is available, the return value will be an ${class:name=IpfsRequest}$.
"
Class {
	#name : #IpfsRequester,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'names',
		'objects'
	],
	#category : #'IPFS-5 - Asynchronous requests'
}

{ #category : #'data access' }
IpfsRequester class >> loadObjectFromPath: anIpfsCidPath [
	^ self uniqueInstance loadObjectFromPath: anIpfsCidPath
]

{ #category : #'data access' }
IpfsRequester class >> resolveAndloadObjectFromPath: anIpfsPath [
	^ self uniqueInstance resolveAndloadObjectFromPath: anIpfsPath
]

{ #category : #'data access' }
IpfsRequester class >> resolveName: aString [
	^ self uniqueInstance resolveName: aString
]

{ #category : #'data access' }
IpfsRequester class >> resolveName: aString continuation: aBlock [
	^ self uniqueInstance resolveName: aString continuation: aBlock
]

{ #category : #'data access' }
IpfsRequester class >> resolveNamePath: anIpfsNamePath [
	^ self uniqueInstance resolveNamePath: anIpfsNamePath

]

{ #category : #initialization }
IpfsRequester >> initialize [
	names := Dictionary new.
	objects := Dictionary new.

]

{ #category : #'data access' }
IpfsRequester >> loadObjectFromPath: anIpfsPath [
	| pathString |
	pathString := anIpfsPath asString.
	(objects includesKey: pathString)
		ifFalse:
			[	objects at: pathString put: (IpfsDataRequest new path: anIpfsPath).
				[ objects at: pathString put: anIpfsPath loadObject ]
				newProcess resume ].
	^ objects at: pathString
]

{ #category : #'data access' }
IpfsRequester >> resolveAndloadObjectFromPath: anIpfsPath [
	| pathString |
	pathString := anIpfsPath asString.
	(objects includesKey: pathString)
		ifFalse:
			[	| resolvedPath loadedObject |
				objects at: pathString put: (IpfsDataRequest new path: anIpfsPath).
				[	resolvedPath := anIpfsPath name
						ifNil: [ anIpfsPath ]
						ifNotNil: [ anIpfsPath substituteNameBy:
										(self resolveName: anIpfsPath name) resultOfIpfsRequest ].
					loadedObject := (self loadObjectFromPath: resolvedPath) resultOfIpfsRequest.
					objects at: pathString put: loadedObject ]
				newProcess resume ].
	^ objects at: pathString
]

{ #category : #'data access' }
IpfsRequester >> resolveName: aString [
	(names includesKey: aString)
		ifFalse:
			[	names at: aString put:
					(IpfsNameRequest new name: aString).
				[ | path |
					path := Ipfs nameResolve: aString.
					names at: aString put:
						(path ifNotNil: [ :p | IpfsPath fromString: p ]) ]
				newProcess resume ].
	^ names at: aString

]
