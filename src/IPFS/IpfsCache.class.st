"
!A cache for results of data requests processed asynchronously

This is a singleton that accepts requests for IPFS name resolution or for IPFS data objects, executes them asynchronously, and caches the results. Until the requested data is available, the return value will be an ${class:name=IpfsRequest}$.

Note that there is no technical reason for this to be singleton. There could well be multiple coexisting caches. Making this a singleton was the quickest solution for making asynchronous requests from ${class:name=IpfsAnnotation}$. This will probably change in the future.
"
Class {
	#name : #IpfsCache,
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
IpfsCache class >> loadObjectFromPath: anIpfsCidPath [
	^ self uniqueInstance loadObjectFromPath: anIpfsCidPath
]

{ #category : #'data access' }
IpfsCache class >> resolveAndloadObjectFromPath: anIpfsPath [
	^ self uniqueInstance resolveAndloadObjectFromPath: anIpfsPath
]

{ #category : #'data access' }
IpfsCache class >> resolveName: aString [
	^ self uniqueInstance resolveName: aString
]

{ #category : #'data access' }
IpfsCache class >> resolveName: aString continuation: aBlock [
	^ self uniqueInstance resolveName: aString continuation: aBlock
]

{ #category : #'data access' }
IpfsCache class >> resolveNamePath: anIpfsNamePath [
	^ self uniqueInstance resolveNamePath: anIpfsNamePath

]

{ #category : #initialization }
IpfsCache >> initialize [
	names := Dictionary new.
	objects := Dictionary new.

]

{ #category : #'data access' }
IpfsCache >> loadObjectFromPath: anIpfsPath [
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
IpfsCache >> resolveAndloadObjectFromPath: anIpfsPath [
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
IpfsCache >> resolveName: aString [
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
