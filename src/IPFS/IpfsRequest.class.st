"
!Asynchronous IPFS request

See ${class:name=IpfsRequester}$
"
Class {
	#name : #IpfsRequest,
	#superclass : #Object,
	#category : #'IPFS-5 - Asynchronous requests'
}

{ #category : #'data access' }
IpfsRequest >> resultOfIpfsRequest [
	^ self updateIpfsRequest waitForIpfsRequest
]

{ #category : #'data access' }
IpfsRequest >> updateIpfsRequest [
	self subclassResponsibility

]

{ #category : #'data access' }
IpfsRequest >> waitForIpfsRequest [
	1 second asDelay wait.
	^ self updateIpfsRequest waitForIpfsRequest
]
