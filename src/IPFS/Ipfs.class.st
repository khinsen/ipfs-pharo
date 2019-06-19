"
!IPFS client

This IPFS client uses the HTTP API of an IPFS server to provide access to IPFS from Pharo.


"
Class {
	#name : #Ipfs,
	#superclass : #IpfsHttpApiClient,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#category : #'IPFS-0 - Server access'
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

{ #category : #IPNS }
Ipfs class >> publish: ipfsPath key: ipnsKey [
	^ self uniqueInstance publish: ipfsPath key: ipnsKey
]

{ #category : #IPNS }
Ipfs class >> publish: ipfsPath key: ipnsKey lifetime: aDuration [
	^ self uniqueInstance publish: ipfsPath key: ipnsKey lifetime: aDuration

]

{ #category : #IPLD }
Ipfs class >> refs: aCID recursive: aBoolean [
	^ self uniqueInstance refs: aCID recursive: aBoolean
]

{ #category : #IPNS }
Ipfs class >> resolvePath: aString [
	^ self uniqueInstance resolvePath: aString
]

{ #category : #IPNS }
Ipfs class >> resolvePath: aString timeout: aDuration [
	^ self uniqueInstance resolvePath: aString timeout: aDuration
	
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
						parameters: { #f -> ' %v/%c/%h/%L'. #arg -> aCid asString } asDictionary.
	^ (result at: 'Formatted') splitOn: $/
]

{ #category : #IPLD }
Ipfs >> dagGet: anIpfsCid [
	| node |
	node := self getRequest: 'dag/get' parameters:
		(Dictionary with: #arg -> anIpfsCid asString).
	anIpfsCid asIpfsCid isRaw
		ifTrue: [ ^ node asByteArray ]
		ifFalse: [ ^ node convertIpfsCids ]
]

{ #category : #IPLD }
Ipfs >> dagPut: anObject [
	| result |
	result := self postRequest: 'dag/put'
		contents: (NeoJSONWriter toString: anObject)
		parameters: (Dictionary with: #arg ->  '').
	^ IpfsCid fromDictionary: (result at: 'Cid').

]

{ #category : #IPLD }
Ipfs >> dagPutRaw: anObject [
	| result |
	result := self postRequest: 'dag/put'
		contents: anObject asByteArray
		parameters: (Dictionary with: #arg ->  ''
									  with: #f -> 'raw'
									  with: #'input-enc' -> 'raw').
	^ IpfsCid fromDictionary: (result at: 'Cid').

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
					put: (IpfsProtoBufLink cid: (IpfsCid fromString: (link at: 'Hash'))
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

{ #category : #IPLD }
Ipfs >> refs: anIpfsCid recursive: aBoolean [
	| result |
	result := self znClient
		path: 'api/v0/refs';
		queryAt: #arg add: anIpfsCid asString;
		queryAt: #recursive add: aBoolean asString;
		get.
	^ result
		ifNil: [ Array new ]
		ifNotNil: [ self parseReferenceList: result ]
]

{ #category : #IPNS }
Ipfs >> resolvePath: aString [
	| result |
	result := self getRequest: 'name/resolve' parameters: { #arg -> aString } asDictionary.
	^ result at: #Path
]

{ #category : #IPNS }
Ipfs >> resolvePath: aString timeout: aDuration [
	| result |
	ZnConnectionTimeout
		value: aDuration asSeconds + 10 "10 extra seconds as an error margin"
		during:
			[	result := self getRequest: 'name/resolve'
									parameters: { #arg -> aString.
													  #'dht-timeout' -> (aDuration asSeconds printString, 's') }
													asDictionary ].
	^ result at: #Path
]
