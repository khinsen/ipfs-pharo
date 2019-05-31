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
		'prefix'
	],
	#category : #'IPFS-Linked data'
}

{ #category : #'instance creation' }
IpldCid class >> codec [
	self subclassResponsibility
]

{ #category : #'instance creation' }
IpldCid class >> fromBase32: aString [
	| prefix codec |
	self assert: aString size = 59.
	self assert: aString first = $b.
	prefix := Ipfs uniqueInstance cidPrefix: aString.
	codec := prefix second asSymbol.
	self subclasses do:
		[ :class | class codec = codec
						ifTrue: [ ^ class new initializeFromBase32: aString prefix: prefix ] ].
	self error: 'No IpldCid subclass for codec ', codec
]

{ #category : #'instance creation' }
IpldCid class >> fromDictionary: aDictionary [
	| cidString |
	self assert: aDictionary size = 1.
	cidString := aDictionary at: '/'.
	^ self fromString: cidString.

]

{ #category : #'instance creation' }
IpldCid class >> fromString: aString [
	^ self fromBase32: (Ipfs cidBase32: aString).

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

{ #category : #accessing }
IpldCid >> codec [
	^ self class codec
]

{ #category : #comparing }
IpldCid >> hash [
	^ cidBase32 hash
]

{ #category : #accessing }
IpldCid >> hashFunction [
	^ prefix third asSymbol
]

{ #category : #accessing }
IpldCid >> hashLength [
	^ prefix fourth asNumber
]

{ #category : #initialization }
IpldCid >> initializeFromBase32: aBase32Cid prefix: aPrefix [
	cidBase32 := aBase32Cid.
	prefix := aPrefix

]

{ #category : #testing }
IpldCid >> isRaw [
	^ self codec = #raw
]

{ #category : #'data access' }
IpldCid >> load [
	^ Ipfs dagGet: self
]

{ #category : #'data access' }
IpldCid >> loadObject [
	^ Ipfs objectGet: self
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
			  nextPutAll: cidBase32;
			  nextPut: $).

]

{ #category : #'data access' }
IpldCid >> recursiveReferences [
	^ Ipfs refs: self recursive: true
]

{ #category : #'data access' }
IpldCid >> references [
	^ Ipfs refs: self recursive: false
]

{ #category : #'data access' }
IpldCid >> sizeOfRawData [
	^ Ipfs blockSize: cidBase32

]

{ #category : #accessing }
IpldCid >> version [
	^ prefix first asSymbol
]
