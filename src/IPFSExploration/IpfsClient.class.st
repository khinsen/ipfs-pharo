Class {
	#name : #IpfsClient,
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

{ #category : #IPLD }
IpfsClient class >> convertToBase32: aString [
	^ self uniqueInstance convertToBase32: aString
]

{ #category : #IPFS }
IpfsClient class >> getIpfsObject: aCID [
	^ self uniqueInstance getIpfsObject: aCID
]

{ #category : #IPLD }
IpfsClient class >> getIpldNode: aCID [
	^ self uniqueInstance getIpldNode: aCID
]

{ #category : #IPLD }
IpfsClient class >> getIpldNodeRefs: aCID [
	^ self uniqueInstance getIpldNodeRefs: aCID
]

{ #category : #IPLD }
IpfsClient class >> putIpldNode: anObject [
	^ self uniqueInstance putIpldNode: anObject
]

{ #category : #CIDs }
IpfsClient >> cidPrefix: aCid [
	| result |
	result := self getRequest: 'cid/format'
						parameters: { #f -> '%P'. #arg -> aCid asString } asDictionary.
	^ result at: 'Formatted'
]

{ #category : #CIDs }
IpfsClient >> convertToBase32: aString [
	| result |
	result := self getRequest: 'cid/base32' parameters: { #arg -> aString } asDictionary.
	^ result at: 'Formatted'
]

{ #category : #requesting }
IpfsClient >> getCommands [
	| result |
	"result := znClient path: 'api/v0/commands'; get."
	result := self getRequest: 'commands' parameters: Dictionary new.
	self assert: (result at: 'Name') = 'ipfs'.
	commands := result at: 'Subcommands'.
]

{ #category : #IPFS }
IpfsClient >> getIpfsObject: aCID [
	| result data links |
	result := self getRequest: 'object/get' parameters:
		(Dictionary with: #arg -> aCID asString).
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

{ #category : #IPLD }
IpfsClient >> getIpldNode: anIpldCid [
	| node |
	node := self getRequest: 'dag/get' parameters:
		(Dictionary with: #arg -> anIpldCid asString).
	^ node asIpldData
]

{ #category : #IPLD }
IpfsClient >> getIpldNodeRefs: anIpldCid [
	| refs |
	refs := self getRequest: 'refs' parameters:
		(Dictionary with: #arg -> anIpldCid asString).
	^ refs
]

{ #category : #requesting }
IpfsClient >> getRequest: aString parameters: aDictionary [
	| result |
	result := self znClient
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		get.
	^ result
]

{ #category : #initializing }
IpfsClient >> initialize [
	host := '127.0.0.1'.
	port := 5001.
	self getCommands.

]

{ #category : #requesting }
IpfsClient >> postRequest: aString contents: anObject parameters: aDictionary [
	| result |
	result := self znClient
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		addPart: (ZnMimePart fieldName: 'file' value: (NeoJSONWriter toString: anObject));
		post.
	^ result
]

{ #category : #IPLD }
IpfsClient >> putIpldNode: anObject [
	| result |
	result := self postRequest: 'dag/put'
		contents: anObject
		parameters: (Dictionary with: #arg ->  '').
	^ IpldCid fromDictionary: (result at: 'Cid').

]

{ #category : #initializing }
IpfsClient >> znClient [
	^ ZnClient new
		systemPolicy;
		beOneShot;
		http;
		host: host;
		port: port;
		accept: 'application/json';
		contentReader: [ :entity |
								entity ifNil: [ nil ]
										 ifNotNil: [ STONJSON fromString: entity contents ] ];
		yourself.

]
