"
!IPFS client

This IPFS client uses the HTTP API of an IPFS server to provide access to IPFS from Pharo.


"
Class {
	#name : #Ipfs,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'host',
		'port',
		'commands'
	],
	#category : #'IPFSExploration-IPFS'
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

{ #category : #IPFS }
Ipfs class >> objectGet: aCID [
	^ self uniqueInstance objectGet: aCID
]

{ #category : #IPLD }
Ipfs class >> refs: aCID [
	^ self uniqueInstance refs: aCID
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

{ #category : #requesting }
Ipfs >> getRequest: aString parameters: aDictionary [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		get.
	^ result
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

{ #category : #requesting }
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
Ipfs >> refs: anIpldCid [
	| refs |
	refs := self getRequest: 'refs' parameters:
		(Dictionary with: #arg -> anIpldCid asString).
	^ refs
]

{ #category : #initializing }
Ipfs >> znClient [
	^ ZnClient new
		systemPolicy;
		beOneShot;
		http;
		host: host;
		port: port;
		yourself.

]

{ #category : #initializing }
Ipfs >> znClientForJsonResult [
	^ self znClient
		accept: 'application/json';
		contentReader: [ :entity |
								entity ifNil: [ nil ]
										 ifNotNil: [ STONJSON fromString: entity contents ] ];
		yourself.

]
