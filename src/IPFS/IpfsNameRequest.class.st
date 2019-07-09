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
