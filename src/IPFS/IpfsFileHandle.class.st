Class {
	#name : #IpfsFileHandle,
	#superclass : #FileSystemHandle,
	#instVars : [
		'stream'
	],
	#category : #'IPFS-3 - Files'
}

{ #category : #accessing }
IpfsFileHandle >> binaryReadStream [
	^ stream
]

{ #category : #testing }
IpfsFileHandle >> isWritable [
	^ false
]

{ #category : #public }
IpfsFileHandle >> open [
	stream := self basicOpen.
	^ self
]
