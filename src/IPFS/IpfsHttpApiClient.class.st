"
!Client connecting to an IPFS server

"
Class {
	#name : #IpfsHttpApiClient,
	#superclass : #Object,
	#instVars : [
		'host',
		'port'
	],
	#category : #'IPFS-0 - Server access'
}

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
										 ifNotNil: [ (NeoJSONReader on: entity contents readStream)
															mapClass: NeoJSONObject;
															next ] ];
		yourself.

]
