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

{ #category : #UnixfsV1 }
Ipfs class >> cat: aCid [
	^ self uniqueInstance cat: aCid
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

{ #category : #IPLD }
Ipfs class >> dagResolve: aString [
	^ self uniqueInstance dagResolve: aString
]

{ #category : #IPFS }
Ipfs class >> filesStat: aCidOrPath [
	^ self uniqueInstance filesStat: aCidOrPath
]

{ #category : #settings }
Ipfs class >> ipfsFallbackPort [
	^ self uniqueInstance fallbackPort
]

{ #category : #settings }
Ipfs class >> ipfsFallbackPort: anInteger [
	^ self uniqueInstance fallbackPort: anInteger
]

{ #category : #settings }
Ipfs class >> ipfsFallbackServer [
	^ self uniqueInstance fallbackHost
]

{ #category : #settings }
Ipfs class >> ipfsFallbackServer: aString [
	^ self uniqueInstance fallbackHost: aString
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
			(aBuilder setting: #ipfsFallbackPort)
				label: 'Fallback IPFS Port' ;
				description: 'The port of the public IPFS server (e.g. 443)';
				order: 4;
				target: Ipfs.
			(aBuilder setting: #ipfsFallbackServer)
				label: 'Fallback IPFS Server' ;
				description: 'A public IPFS server (e.g ipfs.io) to use as a fallback if no local Ipfs daemon is available.';
				order: 3;
				target: Ipfs.
			(aBuilder setting: #ipfsPort)
				label: 'IPFS Port' ;
				description: 'The IPFS port (e.g. 5001)';
				order: 2;
				target: Ipfs.
			(aBuilder setting: #ipfsServer)
				label: 'IPFS Server' ;
				description: 'The IPFS server (e.g 127.0.0.1)';
				order: 1;
				target: Ipfs ].
]

{ #category : #IPNS }
Ipfs class >> nameResolve: aString [
	^ self uniqueInstance nameResolve: aString
]

{ #category : #IPNS }
Ipfs class >> nameResolve: aString timeout: aDuration [
	^ self uniqueInstance nameResolve: aString timeout: aDuration
	
]

{ #category : #IPFS }
Ipfs class >> objectGet: aCID [
	^ self uniqueInstance objectGet: aCID
]

{ #category : #IPFS }
Ipfs class >> objectStat: aCID [
	^ self uniqueInstance objectStat: aCID
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

{ #category : #IPFS }
Ipfs >> blockGet: aCid [
	"This method cannot use getRequest:parameters: because it has to switch the ZnClient
	 to binary mode."

	[ ^ self znClient
		beBinary;
		timeout: self dataRequestTimeout asSeconds;
		accept: 'text/plain';
		path: 'api/v0/block/get';
		queryAt: #arg add: aCid asString;
		post ]
	on: ConnectionTimedOut
		do: [ ^ self znFallbackClient
		beBinary;
		timeout: self dataRequestTimeout asSeconds;
		accept: 'text/plain';
		path: 'api/v0/block/get';
		queryAt: #arg add: aCid asString;
		get ]
]

{ #category : #IPFS }
Ipfs >> blockSize: aCid [
	| result |
	result := self getRequest: 'block/stat'
						parameters: (Dictionary with: #arg -> aCid asString)
						timeout: self dataRequestTimeout.
	^ result at: 'Size'.
]

{ #category : #UnixfsV1 }
Ipfs >> cat: aCid [
	"This method cannot use getRequest:parameters: because it has to switch the ZnClient
	 to binary mode."
	((Ipfs objectStat: aCid) at: #NumLinks) = 0
		ifFalse: [ IpfsError new
					messageText: aCid asString, ' is a directory node';
					signal ].
	[ ^ self znClient
		beBinary;
		timeout: self dataRequestTimeout asSeconds;
		streaming: true;
		accept: 'text/plain';
		path: 'api/v0/cat';
		queryAt: #arg add: aCid asString;
		post ]
	on: ConnectionTimedOut
		do: [ ^ self znFallbackClient
		beBinary;
		timeout: self dataRequestTimeout asSeconds;
		streaming: true;
		accept: 'text/plain';
		path: 'api/v0/cat';
		queryAt: #arg add: aCid asString;
		post ]
]

{ #category : #IPLD }
Ipfs >> dagGet: anIpfsCidOrPath [
	| node |
	node := self getRequest: 'dag/get'
					 parameters: (Dictionary with: #arg -> anIpfsCidOrPath asString)
					 timeout: self dataRequestTimeout.
	anIpfsCidOrPath asIpfsPath isRaw
		ifTrue: [ ^ node asByteArray ]
		ifFalse: [ ^ node convertIpfsCids ]
]

{ #category : #IPLD }
Ipfs >> dagPut: anObject [
	| result |
	result := self
		postRequest: 'dag/put'
		contents: (NeoJSONWriter toString: anObject)
		parameters: (Dictionary with: #arg -> '').
	^ IpfsCid fromJSON: (result at: 'Cid')
]

{ #category : #IPLD }
Ipfs >> dagPutRaw: anObject [
	| result |
	result := self
		postRequest: 'dag/put'
		contents: anObject asByteArray
		parameters:
			(Dictionary
				with: #arg -> ''
				with: #f -> 'raw'
				with: #'input-enc' -> 'raw').
	^ IpfsCid fromJSON: (result at: 'Cid')
]

{ #category : #IPLD }
Ipfs >> dagResolve: aString [
	| result path remPath |
	[ result := self
		getRequest: 'dag/resolve'
		parameters: {(#arg -> aString)} asDictionary
		timeout: self dataRequestTimeout.
	path := IpfsCidPath new
		cid: (IpfsCid fromString: ((result at: #Cid) at: #/)).
	remPath := result at: #RemPath.
	remPath
		ifNotEmpty: [ (remPath splitOn: $/) do: [ :each | path := path / each ] ].
	^ path ]
		on: IpfsError
		do: [ ^ nil ]
]

{ #category : #accessing }
Ipfs >> fallbackHost [
	^ fallbackHost
]

{ #category : #accessing }
Ipfs >> fallbackHost: anObject [
	fallbackHost := anObject
]

{ #category : #accessing }
Ipfs >> fallbackPort [
	^ fallbackPort
]

{ #category : #accessing }
Ipfs >> fallbackPort: anObject [
	fallbackPort := anObject
]

{ #category : #IPFS }
Ipfs >> filesStat: aCidOrPath [
	^ self
		getRequest: 'files/stat'
		parameters: (Dictionary with: #arg -> aCidOrPath asIpfsPath asString)
		timeout: self dataRequestTimeout
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
	super initialize.
	host := '127.0.0.1'.
	port := 5001.
	fallbackHost := 'ipfs.io'.
	fallbackPort := 443.
]

{ #category : #IPNS }
Ipfs >> nameResolve: aString [
	| result |
	[	result := self getRequest: 'name/resolve'
							parameters: { #arg -> aString } asDictionary
							timeout: self dataRequestTimeout.
		^ result at: #Path ]
	on: IpfsError do: [ ^ nil ]
]

{ #category : #IPNS }
Ipfs >> nameResolve: aString timeout: aDuration [
	| result |
	[ result := self getRequest: 'name/resolve'
						  parameters: { #arg -> aString.
											 #'dht-timeout' -> (aDuration asSeconds printString, 's') }
											asDictionary
						  timeout: aDuration.
	  ^ result at: #Path ]
	on: IpfsError do: [ ^ nil ].

]

{ #category : #IPFS }
Ipfs >> objectGet: aCid [
	| result data links |
	result := self
		getRequest: 'object/get'
		parameters: (Dictionary with: #arg -> aCid asString)
		timeout: self dataRequestTimeout.
	data := (result at: 'Data') asByteArray.
	links := Dictionary new.
	(result at: 'Links')
		do: [ :link | 
			links
				at: (link at: 'Name')
				put:
					(IpfsProtoBufLink
						cid: (IpfsCid fromString: (link at: 'Hash'))
						size: (link at: 'Size') asNumber) ].
	^ IpfsObject data: data links: links
]

{ #category : #IPFS }
Ipfs >> objectStat: aCid [
	^ self
		getRequest: 'object/stat'
		parameters: (Dictionary with: #arg -> aCid asString)
		timeout: self dataRequestTimeout
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
	"We can't use getRequest:parmeters: here because the return value is parsed as a stream."
	[ result := self znClient
		path: 'api/v0/refs';
		queryAt: #arg add: anIpfsCid asString;
		queryAt: #recursive add: aBoolean asString;
		timeout: self dataRequestTimeout asSeconds;
		post ]
		on: ConnectionTimedOut
		do: [ result := self znFallbackClient
				path: 'api/v0/refs';
				queryAt: #arg add: anIpfsCid asString;
				queryAt: #recursive add: aBoolean asString;
				timeout: self dataRequestTimeout asSeconds;
				get ].
	^ result
		ifNil: [ Array new ]
		ifNotNil: [ self parseReferenceList: result ]
]
