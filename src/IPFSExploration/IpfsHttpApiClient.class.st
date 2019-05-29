Class {
	#name : #IpfsHttpApiClient,
	#superclass : #Object,
	#instVars : [
		'host',
		'port'
	],
	#category : #'IPFSExploration-IPFS'
}

{ #category : #'http requests' }
IpfsHttpApiClient >> parseReferenceList: aString [
	| parser references |
	parser := NeoJSONReader on: aString contents readStream.
	references := OrderedCollection new.
	[ | refAndErr |
		refAndErr := [ parser next ]
							on: NeoJSONParseError do: [ ^ references ].
		self assert: (refAndErr at: 'Err') equals: ''.
		references add: (refAndErr at: 'Ref') asIpldCid ]
		repeat.
	^ references
]

{ #category : #'http requests' }
IpfsHttpApiClient >> znClient [
	^ ZnClient new
		systemPolicy;
		beOneShot;
		http;
		host: host;
		port: port;
		yourself.

]

{ #category : #'http requests' }
IpfsHttpApiClient >> znClientForJsonResult [
	^ self znClient
		accept: 'application/json';
		contentReader: [ :entity |
								entity ifNil: [ nil ]
										 ifNotNil: [ NeoJSONReader fromString: entity contents ] ];
		yourself.

]
