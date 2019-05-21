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

{ #category : #IPFS }
IpfsClient class >> getIpfsObject: aCID [
	^ self uniqueInstance getIpfsObject: aCID
]

{ #category : #IPLD }
IpfsClient class >> getIpldNode: aCID [
	^ self uniqueInstance getIpldNode: aCID
]

{ #category : #IPFS }
IpfsClient class >> ipfsObjectAt: aCID [
	^ self uniqueInstance ipfsObjectAt: aCID
]

{ #category : #IPLD }
IpfsClient class >> ipldNodeAt: aCID [
	^ self uniqueInstance ipldNodeAt: aCID
]

{ #category : #IPLD }
IpfsClient class >> putIpldNode: anObject [
	^ self uniqueInstance putIpldNode: anObject
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
					put: (IpfsLink cid: (link at: 'Hash')
									  size: ((link at: 'Size') asNumber) )].
	^ IpfsObject
		data: data
		links: links.
]

{ #category : #IPLD }
IpfsClient >> getIpldNode: aCID [
	^ self getRequest: 'dag/get' parameters:
		(Dictionary with: #arg -> aCID asString).

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

{ #category : #IPFS }
IpfsClient >> ipfsObjectAt: aCID [
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
IpfsClient >> ipldNodeAt: aCID [
	| result data links |
	result := self getRequest: 'dag/get' parameters:
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
IpfsClient >> znClient [
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
