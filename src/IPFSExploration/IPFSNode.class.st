Class {
	#name : #IpfsNode,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'znClient',
		'commands'
	],
	#category : #'IPFSExploration-IPFS'
}

{ #category : #IPFS }
IpfsNode class >> ipfsObjectAt: aCID [
	^ self uniqueInstance ipfsObjectAt: aCID
]

{ #category : #IPLD }
IpfsNode class >> ipldNodeAt: aCID [
	^ self uniqueInstance ipldNodeAt: aCID
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
	result := self command: 'commands' withParameters: Dictionary new.
	self assert: (result at: 'Name') = 'ipfs'.
	commands := result at: 'Subcommands'.
]

{ #category : #initializing }
IpfsNode >> initialize [
	| host port |
	host := '127.0.0.1'.
	port := 5001.
	znClient := ZnClient new
		systemPolicy;
		http;
		host: host;
		port: port;
		accept: 'application/json';
		contentReader: [ :entity | STONJSON fromString: entity contents ];
		yourself.
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
