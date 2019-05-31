Class {
	#name : #IpfsObject,
	#superclass : #Object,
	#instVars : [
		'data',
		'links'
	],
	#category : #'IPFS-Files'
}

{ #category : #'instance creation' }
IpfsObject class >> data: aByteArray [
	^ self 
		data: aByteArray
		links: Dictionary new
]

{ #category : #'instance creation' }
IpfsObject class >> data: aByteArray links: aDictionary [
	^ self basicNew
		initializeWithData: aByteArray	links: aDictionary;
		yourself
]

{ #category : #'instance creation' }
IpfsObject class >> links: aDictionary [
	^ self
		data: (ByteArray new: 0)
		links: aDictionary
]

{ #category : #accessing }
IpfsObject >> at: aString [
	^ self links at: aString
]

{ #category : #accessing }
IpfsObject >> data [
	^ data
]

{ #category : #initialization }
IpfsObject >> initializeWithData: aByteArray links: aDictionary [
	data := aByteArray.
	links := aDictionary
]

{ #category : #accessing }
IpfsObject >> links [
	^ links
]

{ #category : #accessing }
IpfsObject >> objectAt: aString [
	^ (self at: aString) getObject
]
