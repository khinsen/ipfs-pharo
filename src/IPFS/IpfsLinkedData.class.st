"
!A data item in the IPFS DAG

Represents the JSON-like data retrieved when loading a DAG node, and sent for storing a node.
"
Class {
	#name : #IpfsLinkedData,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #'IPFS-2 - Linked data'
}

{ #category : #'instance creation' }
IpfsLinkedData class >> value: anObject [
	^ self new
		value: anObject;
		yourself
]

{ #category : #comparing }
IpfsLinkedData >> = anObject [
	^ self class = anObject class
		and: [ self value = anObject value ]

]

{ #category : #codec }
IpfsLinkedData >> decodeFromIpfs [
	^ value decodeFromIpfs
]

{ #category : #codec }
IpfsLinkedData >> encodeForIpfs [
	^ value
]

{ #category : #comparing }
IpfsLinkedData >> hash [
	^ value hash

]

{ #category : #accessing }
IpfsLinkedData >> value [
	^ value
]

{ #category : #accessing }
IpfsLinkedData >> value: anObject [
	value := anObject
]
