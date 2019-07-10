"
!Asynchronous request for an IPFS name

See ${class:name=IpfsRequester}$
"
Class {
	#name : #IpfsNameRequest,
	#superclass : #IpfsRequest,
	#instVars : [
		'name'
	],
	#category : #'IPFS-5 - Asynchronous requests'
}

{ #category : #inspecting }
IpfsNameRequest >> gtStatusFor: aView [
	<gtView>
	^ aView textEditor 
		title: 'Status' translated;
		priority: -1;
		look: BrGlamorousCodeEditorLook new;
		text: [ ('Waiting for name resolution for ', name asString) asRopedText ]
]

{ #category : #accessing }
IpfsNameRequest >> name: aString [
	name := aString
]

{ #category : #printing }
IpfsNameRequest >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(;
			  nextPutAll: name;
			  nextPut: $).

]

{ #category : #'data access' }
IpfsNameRequest >> updateIpfsRequest [
	^ IpfsRequester resolveName: name
]
