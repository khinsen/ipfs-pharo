"
!IPFS peer

A specific node in the IPFS network.

Note that both this class and ${class:name=Ipfs}$ access the HTTP API of an IPFS daemon. ${class:name=IpfsPeer}$ implements the operations that are specific to one peer, in particular pinning, whereas ${class:name=Ipfs}$ implements the operations that conceptually address IPFS as a whole, in particular get and put operations, even though a specific peer is used as the access point.
"
Class {
	#name : #IpfsPeer,
	#superclass : #IpfsHttpApiClient,
	#category : #'IPFS-Access'
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

{ #category : #initialization }
IpfsPeer >> initializeWithHost: aString port: anInteger [
	host := aString.
	port := anInteger.
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
		collect: [ :aString | aString asIpldCid ]

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
		collect: [ :aString | aString asIpldCid ]
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
	^ (result at: 'Keys') keys collect: #asIpldCid
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
		collect: [ :aString | aString asIpldCid ]

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
		collect: [ :aString | aString asIpldCid ]
]
