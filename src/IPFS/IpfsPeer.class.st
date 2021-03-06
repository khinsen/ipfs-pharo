"
!IPFS peer

A specific node in the IPFS network.

Both this class and ${class:name=Ipfs}$ access the HTTP API of an IPFS daemon. ${class:name=IpfsPeer}$ implements the operations that are specific to one peer, in particular pinning, whereas ${class:name=Ipfs}$ implements the operations that conceptually address IPFS as a whole, in particular get and put operations. Put differently, the operations handled by ${class:name=Ipfs}$ could use any IPFS server around the world without changing anything else than performance.


"
Class {
	#name : #IpfsPeer,
	#superclass : #IpfsHttpApiClient,
	#instVars : [
		'publishingTimeout'
	],
	#category : #'IPFS-0 - Server access'
}

{ #category : #'instance creation' }
IpfsPeer class >> host: aString port: anInteger [
	^ self basicNew
		initializeWithHost: aString port: anInteger;
		yourself
]

{ #category : #'instance creation' }
IpfsPeer class >> local [
	^ self host: Ipfs uniqueInstance host port: Ipfs uniqueInstance port
]

{ #category : #references }
IpfsPeer >> allCids [
	"Returns the CIDs of all objects stored by the peer, whether they are pinned or not."
	| result |
	result := self znClient
		path: 'api/v0/refs/local';
		post.
	^ self parseReferenceList: result.

]

{ #category : #repository }
IpfsPeer >> collectGarbage [
	^ self znClientForJsonResult
		path: 'api/v0/repo/gc';
		post
]

{ #category : #keys }
IpfsPeer >> deleteKeyNamed: aSymbol [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/key/rm';
		queryAt: #arg add: aSymbol;
		post.
	^ result
]

{ #category : #keys }
IpfsPeer >> generateKeyNamed: aSymbol [
	| result |
	^ self keyNamed: aSymbol
		ifAbsent:
			[	result := self znClientForJsonResult
					path: 'api/v0/key/gen';
					queryAt: #arg add: aSymbol;
					queryAt: #type add: #rsa;
					post.
				self assert: (result at: #Name) = aSymbol.
				^ IpfsKey peer: self name: aSymbol id: (result at: #Id) ]

]

{ #category : #initialization }
IpfsPeer >> initializeWithHost: aString port: anInteger [
	super initialize.
	host := aString.
	port := anInteger.
	publishingTimeout := 10 minutes.
]

{ #category : #keys }
IpfsPeer >> keyNamed: aSymbol [
	^ self keys detect: [ :each | each name = aSymbol ]
]

{ #category : #keys }
IpfsPeer >> keyNamed: aSymbol ifAbsent: aBlock [
	[ ^ self keyNamed: aSymbol ]
	on: NotFound do: [ ^ aBlock value ]. 

]

{ #category : #keys }
IpfsPeer >> keys [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/key/list';
		post.
	^ (result at: #Keys)
		collect: [ :each |  IpfsKey peer: self name: (each at: #Name) id: (each at: #Id) ]

]

{ #category : #pinning }
IpfsPeer >> pin: aCid [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/pin/add';
		queryAt: #arg add: aCid;
		queryAt: #recursive add: 'false';
		queryAt: #progress add: 'false';
		post.
	^ (result at: 'Pins')
		collect: [ :aString | aString asIpfsCid ]

]

{ #category : #pinning }
IpfsPeer >> pinRecursively: aCid [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/pin/add';
		queryAt: #arg add: aCid;
		queryAt: #recursive add: 'true';
		queryAt: #progress add: 'false';
		post.
	^ (result at: 'Pins')
		collect: [ :aString | aString asIpfsCid ]
]

{ #category : #pinning }
IpfsPeer >> pinnedCids [
	| pinned |
	pinned := Dictionary new.
	#(direct indirect recursive) do:
		[ :type | pinned at: type put: (self pinnedCidsOfType: type) ].
	^ pinned
]

{ #category : #pinning }
IpfsPeer >> pinnedCidsOfType: aCidType [
	| result |
	self assert: (#(direct indirect recursive all) includes: aCidType).
	result := self znClientForJsonResult
		path: 'api/v0/pin/ls';
		queryAt: #type add: aCidType;
		post.
	^ (result at: 'Keys') keys collect: #asIpfsCid
]

{ #category : #publishing }
IpfsPeer >> publish: ipfsPath key: ipnsKey [
	| result |
	result := self getRequest: 'name/publish'
						parameters: { #arg -> ipfsPath asString.
										  #key -> ipnsKey name.
										  #'allow-offline' -> true }
										asDictionary
						timeout: publishingTimeout.
	self assert: (result at: #Name) = ipnsKey id.

]

{ #category : #publishing }
IpfsPeer >> publish: ipfsPath key: ipnsKey lifetime: aDuration [
	| result |
	result := self getRequest: 'name/publish'
						parameters: { #arg -> ipfsPath asString.
										  #key -> ipnsKey name.
										  #lifetime -> (aDuration asSeconds printString, 's').
										  #'allow-offline' -> true }
										asDictionary
						timeout: publishingTimeout.
	self assert: (result at: #Name) = ipnsKey id.

]

{ #category : #publishing }
IpfsPeer >> publishingTimeout [
	^ publishingTimeout
]

{ #category : #publishing }
IpfsPeer >> publishingTimeout: anObject [
	publishingTimeout := anObject
]

{ #category : #keys }
IpfsPeer >> renameKeyNamed: aSymbol to: anotherSymbol [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/key/rename';
		queryAt: #arg add: aSymbol;
		queryAt: #arg add: anotherSymbol;
		post.
	self assert: (result at: #Was) = aSymbol.
	self assert: (result at: #Now) = anotherSymbol.
]

{ #category : #repository }
IpfsPeer >> storageStatistics [
	^ self znClientForJsonResult
		path: 'api/v0/repo/stat';
		post
]

{ #category : #pinning }
IpfsPeer >> unpin: aCid [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/pin/rm';
		queryAt: #arg add: aCid;
		queryAt: #recursive add: 'false';
		post.
	^ (result at: 'Pins')
		collect: [ :aString | aString asIpfsCid ]

]

{ #category : #pinning }
IpfsPeer >> unpinRecursively: aCid [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/pin/rm';
		queryAt: #arg add: aCid;
		queryAt: #recursive add: 'true';
		post.
	^ (result at: 'Pins')
		collect: [ :aString | aString asIpfsCid ]
]

{ #category : #publishing }
IpfsPeer >> variable: aSymbol [
	^ IpfsVariable key: (self keyNamed: aSymbol)
]

{ #category : #publishing }
IpfsPeer >> variable: aSymbol value: anObject [
	^ IpfsVariable key: (self generateKeyNamed: aSymbol) value: anObject
]
