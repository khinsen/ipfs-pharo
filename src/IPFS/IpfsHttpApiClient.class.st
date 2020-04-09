"
!Client connecting to an IPFS server

"
Class {
	#name : #IpfsHttpApiClient,
	#superclass : #Object,
	#instVars : [
		'host',
		'port',
		'fallbackHost',
		'fallbackPort',
		'dataRequestTimeout'
	],
	#category : #'IPFS-0 - Server access'
}

{ #category : #accessing }
IpfsHttpApiClient >> dataRequestTimeout [
	^ dataRequestTimeout
]

{ #category : #accessing }
IpfsHttpApiClient >> dataRequestTimeout: aDuration [
	dataRequestTimeout := aDuration
]

{ #category : #'http requests' }
IpfsHttpApiClient >> getRequest: aString parameters: aDictionary [
	| result |
	[ result := self znClientForJsonResult
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		post. ]
	on: ConnectionTimedOut do:
	[ result := self znFallbackClientForJsonResult
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		get. ].
	^ result
]

{ #category : #'http requests' }
IpfsHttpApiClient >> getRequest: aString parameters: aDictionary timeout: aDuration [
	| result |
	[ result := self znClientForJsonResult
		timeout: aDuration asSeconds;
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		post ]
	on: ConnectionTimedOut do:
	[ result := self znFallbackClientForJsonResult
		timeout: aDuration asSeconds;
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		get ].
	^ result
]

{ #category : #'http requests' }
IpfsHttpApiClient >> handleFailure: anException [
	| message ipfsError |
	"IPFS errors are ZnHttpUnsuccessful with a message in the response"
	(anException isKindOf: ZnHttpUnsuccessful)
		ifFalse: [ anException pass ].
	message := (NeoJSONReader
						on: anException response contents readStream)
						next.
	ipfsError := IpfsError new.
	ipfsError messageText: (message at: #Message).
	ipfsError signal.

]

{ #category : #initialization }
IpfsHttpApiClient >> initialize [
	super initialize.
	self dataRequestTimeout: 1 hour.
]

{ #category : #'http requests' }
IpfsHttpApiClient >> parseReferenceList: aString [
	| parser references |
	parser := NeoJSONReader on: aString contents readStream.
	references := OrderedCollection new.
	[ | refAndErr |
		refAndErr := [ parser next ]
							on: NeoJSONParseError do: [ ^ references ].
		self assert: (refAndErr at: 'Err') = ''.
		references add: (refAndErr at: 'Ref') asIpfsCid ]
		repeat.
	^ references
]

{ #category : #'http requests' }
IpfsHttpApiClient >> postRequest: aString contents: data parameters: aDictionary [
	| result |
	result := self znClientForJsonResult
		path: 'api/v0/', aString;
		queryAddAll: aDictionary;
		addPart: (ZnMimePart fieldName: 'file' value: data);
		post.
	^ result
]

{ #category : #'http requests' }
IpfsHttpApiClient >> znClient [
	^ ZnClient new
		systemPolicy;
		beOneShot;
		http;
		host: host;
		port: port;
		ifFail: [ :exception | self handleFailure: exception ];
		yourself.

]

{ #category : #'http requests' }
IpfsHttpApiClient >> znClientForJsonResult [
	^ self znClient
		accept: 'application/json';
		contentReader: [ :entity |
								entity ifNil: [ nil ]
										 ifNotNil: [ (NeoJSONReader on: entity contents readStream)
															mapClass: NeoJSONObject;
															next ] ];
		yourself.

]

{ #category : #'http requests' }
IpfsHttpApiClient >> znFallbackClient [
	^ ZnClient new
		systemPolicy;
		beOneShot;
		https;
		host: fallbackHost;
		port: fallbackPort;
		ifFail: [ :exception | self handleFailure: exception ];
		yourself.

]

{ #category : #'http requests' }
IpfsHttpApiClient >> znFallbackClientForJsonResult [
	^ self znFallbackClient
		accept: 'application/json';
		contentReader: [ :entity |
								entity ifNil: [ nil ]
										 ifNotNil: [ (NeoJSONReader on: entity contents readStream)
															mapClass: NeoJSONObject;
															next ] ];
		yourself.

]
