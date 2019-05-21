Class {
	#name : #IpldNode,
	#superclass : #Object,
	#instVars : [
		'data',
		'links'
	],
	#category : #'IPFSExploration-IPLD'
}

{ #category : #'instance creation' }
IpldNode class >> data: aByteArray [
	^ self 
		data: aByteArray
		links: Dictionary new
]

{ #category : #'instance creation' }
IpldNode class >> data: aByteArray links: aDictionary [
	^ self basicNew
		initializeWithData: aByteArray	links: aDictionary;
		yourself
]

{ #category : #'instance creation' }
IpldNode class >> links: aDictionary [
	^ self
		data: (ByteArray new: 0)
		links: aDictionary
]

{ #category : #accessing }
IpldNode >> at: aString [
	^ self links at: aString
]

{ #category : #accessing }
IpldNode >> data [
	^ data
]

{ #category : #initialization }
IpldNode >> initializeWithData: aByteArray links: aDictionary [
	data := aByteArray.
	links := aDictionary
]

{ #category : #accessing }
IpldNode >> links [
	^ links
]

{ #category : #accessing }
IpldNode >> nodeAt: aString [
	^ (self at: aString) getNode
]
