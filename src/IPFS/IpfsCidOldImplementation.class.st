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
	#name : #IpfsCidOldImplementation,
	#superclass : #Object,
	#instVars : [
		'cidBase32',
		'prefix'
	],
	#category : #'IPFS-1 - CIDs and paths'
}

{ #category : #'instance creation' }
IpfsCidOldImplementation class >> codec [
	self subclassResponsibility
]

{ #category : #'instance creation' }
IpfsCidOldImplementation class >> fromBase32: aString [
	| prefix codec subclass |
	"The first letter of a valid base32-encoded CID must be 'b'."
	self assert: aString first = $b.
	prefix := Ipfs uniqueInstance cidPrefix: aString.
	codec := prefix second asSymbol.
	subclass := IpfsGenericCid.
	self subclasses do:
		[ :class | class codec = codec
						ifTrue: [ subclass := class  ] ].
	^ subclass new initializeFromBase32: aString prefix: prefix
]

{ #category : #'instance creation' }
IpfsCidOldImplementation class >> fromJSON: aDictionary [
	| cidString |
	self assert: aDictionary size = 1.
	cidString := aDictionary at: '/'.
	^ self fromString: cidString.

]

{ #category : #'instance creation' }
IpfsCidOldImplementation class >> fromString: aString [
	^ IpfsCid fromString: aString
"	| trimmedString base32 |
	trimmedString := aString trimBoth.
	base32 := (trimmedString beginsWith: 'b')
		ifTrue: [ trimmedString ]
		ifFalse: [ Ipfs cidBase32: trimmedString ].
	^ self fromBase32: base32"
]

{ #category : #comparing }
IpfsCidOldImplementation >> = anIpfsCid [
	^ self asString = anIpfsCid asString

]

{ #category : #converting }
IpfsCidOldImplementation >> asIpfsCid [
	^ self

]

{ #category : #converting }
IpfsCidOldImplementation >> asIpfsPath [
	^ IpfsCidPath new cid: self

]

{ #category : #converting }
IpfsCidOldImplementation >> asString [
	^ cidBase32
]

{ #category : #accessing }
IpfsCidOldImplementation >> codec [
	^ self class codec
]

{ #category : #converting }
IpfsCidOldImplementation >> decodeFromIpfs [
	^ self
]

{ #category : #storing }
IpfsCidOldImplementation >> encodeForIpfs [
	^ NeoJSONObject with: '/' -> cidBase32
]

{ #category : #comparing }
IpfsCidOldImplementation >> hash [
	^ cidBase32 hash
]

{ #category : #accessing }
IpfsCidOldImplementation >> hashFunction [
	^ prefix third asSymbol
]

{ #category : #accessing }
IpfsCidOldImplementation >> hashLength [
	^ prefix fourth asNumber
]

{ #category : #initialization }
IpfsCidOldImplementation >> initializeFromBase32: aBase32Cid prefix: aPrefix [
	cidBase32 := aBase32Cid.
	prefix := aPrefix

]

{ #category : #testing }
IpfsCidOldImplementation >> isRaw [
	^ self codec = #raw
]

{ #category : #'data access' }
IpfsCidOldImplementation >> loadAndDecode [
	^ Ipfs dagGet: self
]

{ #category : #'data access' }
IpfsCidOldImplementation >> loadRawBlock [
	^ Ipfs blockGet: cidBase32

]

{ #category : #converting }
IpfsCidOldImplementation >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMap: { '/' -> cidBase32 } asDictionary
]

{ #category : #printing }
IpfsCidOldImplementation >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(;
			  nextPutAll: cidBase32;
			  nextPut: $).

]

{ #category : #'data access' }
IpfsCidOldImplementation >> recursiveReferences [
	^ Ipfs refs: self recursive: true
]

{ #category : #'data access' }
IpfsCidOldImplementation >> references [
	^ Ipfs refs: self recursive: false
]

{ #category : #resolving }
IpfsCidOldImplementation >> resolveLink: aString [
	self subclassResponsibility
]

{ #category : #resolving }
IpfsCidOldImplementation >> resolveLinks: aLinkSequence [
	| nextInChain |
	aLinkSequence ifEmpty: [ ^ self ].
	nextInChain := self resolveLink: aLinkSequence first.
	aLinkSequence size = 1 ifTrue: [ ^ nextInChain ].
	^ nextInChain resolveLinks: aLinkSequence allButFirst.
]

{ #category : #'data access' }
IpfsCidOldImplementation >> sizeOfRawData [
	^ Ipfs blockSize: cidBase32

]

{ #category : #printing }
IpfsCidOldImplementation >> storeOn: aStream [
	aStream nextPutAll: '(IpfsCid fromString: '.
	cidBase32 storeOn: aStream.
	aStream nextPut: $).

]

{ #category : #accessing }
IpfsCidOldImplementation >> version [
	^ prefix first asSymbol
]
