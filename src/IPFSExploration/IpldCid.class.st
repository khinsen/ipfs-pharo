"
!IPLD Content Identifier (CID)

A content identifier is a reference to a node in the IPLD DAG.

A transition is currently going on from first-generation (""v0"") CIDs to second-generation (""v1"") CIDs, which can refer not only to nodes in IPFS but also to git commits, ethereum ledger entries, and more. There is also a transition going on from base58 encoding as the default string representation to base32 encoding. This class converts all incoming CIDs to second-generation CIDs with a base32 representation. The conversion is done using the IPFS server, see ${method:name=IpfsClient>>#convertToBase32:}$.

"
Class {
	#name : #IpldCid,
	#superclass : #Object,
	#instVars : [
		'cidBase32',
		'prefix',
		'codec'
	],
	#category : #'IPFSExploration-IPLD'
}

{ #category : #'instance creation' }
IpldCid class >> fromBase32: aString [
	^ self basicNew
		initializeFromBase32: aString;
		yourself
]

{ #category : #'instance creation' }
IpldCid class >> fromDictionary: aDictionary [
	^ self basicNew
		initializeFromDictionary: aDictionary;
		yourself
]

{ #category : #'instance creation' }
IpldCid class >> fromString: aString [
	^ self basicNew
		initializeFromString: aString;
		yourself
]

{ #category : #comparing }
IpldCid >> = anIpldCid [
	^ self asString = anIpldCid asString

]

{ #category : #converting }
IpldCid >> asIpldCid [
	^ self

]

{ #category : #converting }
IpldCid >> asString [
	^ cidBase32
]

{ #category : #'data access' }
IpldCid >> getRefs [
	^ Ipfs refs: self
]

{ #category : #comparing }
IpldCid >> hash [
	^ cidBase32 hash
]

{ #category : #initialization }
IpldCid >> initializeFromBase32: aString [
	self assert: aString size equals: 59.
	self assert: aString first equals: $b.
	cidBase32 := aString.
	prefix := Ipfs uniqueInstance cidPrefix: cidBase32.
	codec := (prefix splitOn: $-) second asSymbol.
]

{ #category : #initialization }
IpldCid >> initializeFromDictionary: aDictionary [
	| cidString |
	self assert: aDictionary size equals: 1.
	cidString := aDictionary at: '/'.
	self initializeFromString: cidString.
]

{ #category : #initialization }
IpldCid >> initializeFromString: aString [
	self initializeFromBase32: (Ipfs cidBase32: aString).
]

{ #category : #testing }
IpldCid >> isRaw [
	^ codec = #raw
]

{ #category : #'data access' }
IpldCid >> load [
	^ Ipfs dagGet: self
]

{ #category : #'data access' }
IpldCid >> loadRawData [
	^ Ipfs blockGet: cidBase32

]

{ #category : #converting }
IpldCid >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMap: { '/' -> cidBase32 } asDictionary
]

{ #category : #printing }
IpldCid >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(;
			  nextPutAll: prefix;
			  nextPutAll: ', ';
			  nextPutAll: cidBase32;
			  nextPut: $).

]
