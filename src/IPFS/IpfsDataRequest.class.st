"
!Asynchronous request for an IPFS data object

See ${class:name=IpfsRequester}$
"
Class {
	#name : #IpfsDataRequest,
	#superclass : #IpfsRequest,
	#instVars : [
		'path'
	],
	#category : #'IPFS-5 - Asynchronous requests'
}

{ #category : #inspecting }
IpfsDataRequest >> gtStatusFor: aView [
	<gtView>
	^ aView textEditor 
		title: 'Status' translated;
		priority: -1;
		look: BrGlamorousCodeEditorLook new;
		text: [ ('Waiting for data for ', path asString) asRopedText ]
]

{ #category : #accessing }
IpfsDataRequest >> path: anIpfsPath [
	path := anIpfsPath
]

{ #category : #printing }
IpfsDataRequest >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(;
			  nextPutAll: path asString;
			  nextPut: $).

]

{ #category : #'data access' }
IpfsDataRequest >> updateIpfsRequest [
	^ IpfsRequester loadObjectFromPath: path
]
