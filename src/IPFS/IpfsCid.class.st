"
!IPFS Content Identifier (CID)

A content identifier is a reference to a block stored in IPFS. A block is simply a sequence of bytes. A CID contains the following information:
1. A hash computed from the block.
2. A code specifying the hash function (default is sha2-256 today).
3. The length of the hash (number of bytes).
4. A code specifying the codec that defines how the block is interpreted. Each subclass of this class handles the CIDs for one such codec (see ${method:name=IpfsCid class>>#fromBase32:}$).

The layout of a CID is defined as a bit sequence, which is then encoded as a text string for practical use. The current default encoding is base32, but most documentation and examples still use the earlier default, which was base58btc. IPFS software is expected to handle all encodings. This class converts all incoming CIDs to a base32 representation. The actual conversion is done by the IPFS server, see ${method:name=Ipfs>>#cidBase32:}$.

Another transition that is currently going on is from first-generation (""v0"") CIDs to second-generation (""v1"") CIDs, which can refer not only to IPFS objects but also to git commits, ethereum ledger entries, and more. First-generation CIDs will remain valid forever, but at some point all newly created CIDs will be second-generation. This class converts all incoming CIDs to second-generation format at the same time as conversion to a base32 encoding.

"
Class {
	#name : #IpfsCid,
	#superclass : #Object,
	#instVars : [
		'cidBase32',
		'prefix'
	],
	#category : #'IPFS-1 - Blocks'
}

{ #category : #'instance creation' }
IpfsCid class >> codec [
	self subclassResponsibility
]

{ #category : #'instance creation' }
IpfsCid class >> fromBase32: aString [
	| prefix codec |
	"The first letter of a valid base32-encoded CID must be 'b'."
	self assert: aString first = $b.
	prefix := Ipfs uniqueInstance cidPrefix: aString.
	codec := prefix second asSymbol.
	self subclasses do:
		[ :class | class codec = codec
						ifTrue: [ ^ class new initializeFromBase32: aString prefix: prefix ] ].
	self error: 'No IpfsCid subclass for codec ', codec
]

{ #category : #'instance creation' }
IpfsCid class >> fromDictionary: aDictionary [
	| cidString |
	self assert: aDictionary size = 1.
	cidString := aDictionary at: '/'.
	^ self fromString: cidString.

]

{ #category : #'instance creation' }
IpfsCid class >> fromString: aString [
	^ self fromBase32: (Ipfs cidBase32: aString).

]

{ #category : #comparing }
IpfsCid >> = anIpfsCid [
	^ self asString = anIpfsCid asString

]

{ #category : #converting }
IpfsCid >> asIpfsCid [
	^ self

]

{ #category : #converting }
IpfsCid >> asString [
	^ cidBase32
]

{ #category : #accessing }
IpfsCid >> codec [
	^ self class codec
]

{ #category : #comparing }
IpfsCid >> hash [
	^ cidBase32 hash
]

{ #category : #accessing }
IpfsCid >> hashFunction [
	^ prefix third asSymbol
]

{ #category : #accessing }
IpfsCid >> hashLength [
	^ prefix fourth asNumber
]

{ #category : #initialization }
IpfsCid >> initializeFromBase32: aBase32Cid prefix: aPrefix [
	cidBase32 := aBase32Cid.
	prefix := aPrefix

]

{ #category : #testing }
IpfsCid >> isRaw [
	^ self codec = #raw
]

{ #category : #'data access' }
IpfsCid >> load [
	^ Ipfs dagGet: self
]

{ #category : #'data access' }
IpfsCid >> loadObject [
	^ Ipfs objectGet: self
]

{ #category : #'data access' }
IpfsCid >> loadRawData [
	^ Ipfs blockGet: cidBase32

]

{ #category : #converting }
IpfsCid >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMap: { '/' -> cidBase32 } asDictionary
]

{ #category : #printing }
IpfsCid >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(;
			  nextPutAll: cidBase32;
			  nextPut: $).

]

{ #category : #'data access' }
IpfsCid >> recursiveReferences [
	^ Ipfs refs: self recursive: true
]

{ #category : #'data access' }
IpfsCid >> references [
	^ Ipfs refs: self recursive: false
]

{ #category : #'data access' }
IpfsCid >> sizeOfRawData [
	^ Ipfs blockSize: cidBase32

]

{ #category : #accessing }
IpfsCid >> version [
	^ prefix first asSymbol
]
