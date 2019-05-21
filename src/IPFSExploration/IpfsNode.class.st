Class {
	#name : #IpfsNode,
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
IpfsNode class >> getIpfsObject: aCID [
	^ self uniqueInstance getIpfsObject: aCID
]

{ #category : #IPLD }
IpfsNode class >> getIpldNode: aCID [
	^ self uniqueInstance getIpldNode: aCID
]

{ #category : #IPFS }
IpfsNode class >> ipfsObjectAt: aCID [
	^ self uniqueInstance ipfsObjectAt: aCID
]

{ #category : #IPLD }
IpfsNode class >> ipldNodeAt: aCID [
	^ self uniqueInstance ipldNodeAt: aCID
]

{ #category : #IPLD }
IpfsNode class >> putIpldNode: anObject [
	^ self uniqueInstance putIpldNode: anObject
]

{ #category : #requesting }
IpfsNode >> command: aString withParameters: aDictionary [
	| result |
	result := znClient
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		get.
	^ result
]

{ #category : #requesting }
IpfsNode >> getCommands [
	| result |
	"result := znClient path: 'api/v0/commands'; get."
	result := self getRequest: 'commands' parameters: Dictionary new.
	self assert: (result at: 'Name') = 'ipfs'.
	commands := result at: 'Subcommands'.
]

{ #category : #IPFS }
IpfsNode >> getIpfsObject: aCID [
	| result data links |
	result := self getRequest: 'object/get' parameters:
		(Dictionary with: #arg -> aCID asString).
	data := (result at: 'Data') asByteArray.
	links := Dictionary new.
	(result at: 'Links') do:
		[ :link |
			links at: (link at: 'Name')
					put: (IpfsLink cid: (link at: 'Hash')
									  size: ((link at: 'Size') asNumber) )].
	^ IpfsObject
		data: data
		links: links.
]

{ #category : #IPLD }
IpfsNode >> getIpldNode: aCID [
	^ self getRequest: 'dag/get' parameters:
		(Dictionary with: #arg -> aCID asString).

]

{ #category : #requesting }
IpfsNode >> getRequest: aString parameters: aDictionary [
	| result |
	result := self znClient
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		get.
	^ result
]

{ #category : #initializing }
IpfsNode >> initialize [
	host := '127.0.0.1'.
	port := 5001.
	self getCommands.

]

{ #category : #IPFS }
IpfsNode >> ipfsObjectAt: aCID [
	| result data links |
	result := self command: 'object/get' withParameters:
		(Dictionary with: #arg -> aCID asString).
	data := (result at: 'Data') asByteArray.
	links := Dictionary new.
	(result at: 'Links') do:
		[ :link |
			links at: (link at: 'Name')
					put: (IpfsLink cid: (link at: 'Hash')
									  size: ((link at: 'Size') asNumber) )].
	^ IpfsObject
		data: data
		links: links.
]

{ #category : #IPLD }
IpfsNode >> ipldNodeAt: aCID [
	| result data links |
	result := self command: 'dag/get' withParameters:
		(Dictionary with: #arg -> aCID asString).
	data := (result at: 'data') asByteArray.
	links := Dictionary new.
	(result at: 'links') do:
		[ :link |
			| cid |
			cid := link at: 'Cid'.
			self assert: cid size = 1.
			self assert: cid keys first = '/'.
			links at: (link at: 'Name')
					put: (IpldLink cid: (cid at: '/')
									  size: ((link at: 'Size') asNumber) )].
	^ IpldNode
		data: data
		links: links.
]

{ #category : #requesting }
IpfsNode >> postRequest: aString contents: anObject parameters: aDictionary [
	| result |
	result := self znClient
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		addPart: (ZnMimePart fieldName: 'file' value: (NeoJSONWriter toString: anObject));
		post.
	^ result
]

{ #category : #IPLD }
IpfsNode >> putIpldNode: anObject [
	| result cid |
	result := self postRequest: 'dag/put'
		contents: anObject
		parameters: (Dictionary with: #arg ->  '').
	cid := result at: 'Cid'.
	self assert: cid size = 1.
	self assert: cid keys first = '/'.
	^ cid at: '/'
]

{ #category : #initializing }
IpfsNode >> znClient [
	^ ZnClient new
		systemPolicy;
		beOneShot;
		http;
		host: host;
		port: port;
		accept: 'application/json';
		contentReader: [ :entity | STONJSON fromString: entity contents ];
		yourself.

]
