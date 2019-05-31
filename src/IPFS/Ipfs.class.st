"
!IPFS client

This IPFS client uses the HTTP API of an IPFS server to provide access to IPFS from Pharo.


"
Class {
	#name : #Ipfs,
	#superclass : #IpfsHttpApiClient,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#category : #'IPFS-Access'
}

{ #category : #IPFS }
Ipfs class >> blockGet: aCid [
	^ self uniqueInstance blockGet: aCid
]

{ #category : #IPFS }
Ipfs class >> blockSize: aCid [
	^ self uniqueInstance blockSize: aCid

]

{ #category : #IPLD }
Ipfs class >> cidBase32: aString [
	^ self uniqueInstance cidBase32: aString
]

{ #category : #IPLD }
Ipfs class >> dagGet: aCID [
	^ self uniqueInstance dagGet: aCID
]

{ #category : #IPLD }
Ipfs class >> dagPut: anObject [
	^ self uniqueInstance dagPut: anObject
]

{ #category : #IPLD }
Ipfs class >> dagPutRaw: anObject [
	^ self uniqueInstance dagPutRaw: anObject
]

{ #category : #settings }
Ipfs class >> ipfsPort [
	^ self uniqueInstance port
]

{ #category : #settings }
Ipfs class >> ipfsPort: anInteger [
	^ self uniqueInstance port: anInteger
]

{ #category : #settings }
Ipfs class >> ipfsServer [
	^ self uniqueInstance host
]

{ #category : #settings }
Ipfs class >> ipfsServer: aString [
	^ self uniqueInstance host: aString
]

{ #category : #settings }
Ipfs class >> ipfsSettingsOn: aBuilder [ 
	<systemsettings> 
	(aBuilder group: #ipfs)
		label: 'IPFS server';
		description: 'The IPFS server used to access IPFS';
		parent: #network;
		with: [ 
			(aBuilder setting: #ipfsServer)
				label: 'IPFS Server' ;
				description: 'The IPFS server (e.g 127.0.0.1)';
				target: Ipfs.
			(aBuilder setting: #ipfsPort)
				label: 'IPFS Port' ;
				description: 'The IPFS port (e.g. 5001)';
				target: Ipfs ].
]

{ #category : #IPFS }
Ipfs class >> objectGet: aCID [
	^ self uniqueInstance objectGet: aCID
]

{ #category : #IPLD }
Ipfs class >> refs: aCID recursive: aBoolean [
	^ self uniqueInstance refs: aCID recursive: aBoolean
]

{ #category : #IPFS }
Ipfs >> blockGet: aCid [
	"This method cannot use getRequest:parameters: because it has to switch the ZnClient
	 to binary mode."
	^ self znClient
		beBinary;
		accept: 'text/plain';
		path: 'api/v0/block/get';
		queryAt: #arg add: aCid asString;
		get.

]

{ #category : #IPFS }
Ipfs >> blockSize: aCid [
	| result |
	result := self getRequest: 'block/stat' parameters:
		(Dictionary with: #arg -> aCid asString).
	^ result at: 'Size'.
]

{ #category : #CIDs }
Ipfs >> cidBase32: aString [
	| result |
	result := self getRequest: 'cid/base32' parameters: { #arg -> aString } asDictionary.
	^ result at: 'Formatted'
]

{ #category : #CIDs }
Ipfs >> cidPrefix: aCid [
	| result |
	result := self getRequest: 'cid/format'
						parameters: { #f -> '%P'. #arg -> aCid asString } asDictionary.
	^ result at: 'Formatted'
]

{ #category : #IPLD }
Ipfs >> dagGet: anIpldCid [
	| node |
	node := self getRequest: 'dag/get' parameters:
		(Dictionary with: #arg -> anIpldCid asString).
	anIpldCid asIpldCid isRaw
		ifTrue: [ ^ node asByteArray ]
		ifFalse: [ ^ node asIpldData ]
]

{ #category : #IPLD }
Ipfs >> dagPut: anObject [
	| result |
	result := self postRequest: 'dag/put'
		contents: (NeoJSONWriter toString: anObject)
		parameters: (Dictionary with: #arg ->  '').
	^ IpldCid fromDictionary: (result at: 'Cid').

]

{ #category : #IPLD }
Ipfs >> dagPutRaw: anObject [
	| result |
	result := self postRequest: 'dag/put'
		contents: anObject asByteArray
		parameters: (Dictionary with: #arg ->  ''
									  with: #f -> 'raw'
									  with: #'input-enc' -> 'raw').
	^ IpldCid fromDictionary: (result at: 'Cid').

]

{ #category : #'http requests' }
Ipfs >> getRequest: aString parameters: aDictionary [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		get.
	^ result
]

{ #category : #accessing }
Ipfs >> host [
	^ host
]

{ #category : #accessing }
Ipfs >> host: anObject [
	host := anObject
]

{ #category : #initializing }
Ipfs >> initialize [
	host := '127.0.0.1'.
	port := 5001.

]

{ #category : #IPFS }
Ipfs >> objectGet: aCid [
	| result data links |
	result := self getRequest: 'object/get' parameters:
		(Dictionary with: #arg -> aCid asString).
	data := (result at: 'Data') asByteArray.
	links := Dictionary new.
	(result at: 'Links') do:
		[ :link |
			links at: (link at: 'Name')
					put: (IpfsLink cid: (IpldCid fromString: (link at: 'Hash'))
									   size: ((link at: 'Size') asNumber) )].
	^ IpfsObject
		data: data
		links: links.
]

{ #category : #accessing }
Ipfs >> port [
	^ port
]

{ #category : #accessing }
Ipfs >> port: anObject [
	port := anObject
]

{ #category : #'http requests' }
Ipfs >> postRequest: aString contents: data parameters: aDictionary [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		addPart: (ZnMimePart fieldName: 'file' value: data);
		post.
	^ result
]

{ #category : #IPLD }
Ipfs >> refs: anIpldCid recursive: aBoolean [
	| result |
	result := self znClient
		path: 'api/v0/refs';
		queryAt: #arg add: anIpldCid asString;
		queryAt: #recursive add: aBoolean asString;
		get.
	^ result
		ifNil: [ Array new ]
		ifNotNil: [ self parseReferenceList: result ]
]
