"
!IPFS peer

A specific node in the IPFS network.

Both this class and ${class:name=Ipfs}$ access the HTTP API of an IPFS daemon. ${class:name=IpfsPeer}$ implements the operations that are specific to one peer, in particular pinning, whereas ${class:name=Ipfs}$ implements the operations that conceptually address IPFS as a whole, in particular get and put operations. Put differently, the operations handled by ${class:name=Ipfs}$ could use any IPFS server around the world without changing anything else than performance.


"
Class {
	#name : #IpfsPeer,
	#superclass : #IpfsHttpApiClient,
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
		get.
	^ self parseReferenceList: result.

]

{ #category : #repository }
IpfsPeer >> collectGarbage [
	^ self znClientForJsonResult
		path: 'api/v0/repo/gc';
		get
]

{ #category : #keys }
IpfsPeer >> deleteKeyNamed: aSymbol [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/key/rm';
		queryAt: #arg add: aSymbol;
		get.
	self assert: (result at: #Name) = aSymbol.

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
					get.
				self assert: (result at: #Name) = aSymbol.
				^ IpfsKey peer: self name: aSymbol id: (result at: #Id) ]

]

{ #category : #initialization }
IpfsPeer >> initializeWithHost: aString port: anInteger [
	host := aString.
	port := anInteger.
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
		get.
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
		get.
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
		get.
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
		get.
	^ (result at: 'Keys') keys collect: #asIpfsCid
]

{ #category : #keys }
IpfsPeer >> renameKeyNamed: aSymbol to: anotherSymbol [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/key/rename';
		queryAt: #arg add: aSymbol;
		queryAt: #arg add: anotherSymbol;
		get.
	self assert: (result at: #Was) = aSymbol.
	self assert: (result at: #Now) = anotherSymbol.
]

{ #category : #repository }
IpfsPeer >> storageStatistics [
	^ self znClientForJsonResult
		path: 'api/v0/repo/stat';
		get
]

{ #category : #pinning }
IpfsPeer >> unpin: aCid [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/pin/rm';
		queryAt: #arg add: aCid;
		queryAt: #recursive add: 'false';
		get.
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
		get.
	^ (result at: 'Pins')
		collect: [ :aString | aString asIpfsCid ]
]
