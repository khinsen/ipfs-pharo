"
!IPFS Content Identifier (CID)

A content identifier is a reference to a block stored in IPFS. A block is simply a sequence of bytes. A CID contains the following information:
1. A hash computed from the block.
2. A code specifying the hash function (default is sha2-256 today).
3. The length of the hash (number of bytes).
4. A code specifying the codec that defines how the block is interpreted.

The layout of a CID is defined as a bit sequence, which is then encoded as a text string for practical use. The current default encoding is base32, but most documentation and examples still use the earlier default, which was base58btc. IPFS software is expected to handle all encodings, which this class does via ${class:name=MultibaseEncoder}$.

Another transition that is currently going on is from first-generation (""v0"") CIDs to second-generation (""v1"") CIDs, which can refer not only to IPFS objects but also to git commits, ethereum ledger entries, and more. First-generation CIDs will remain valid forever, but at some point all newly created CIDs will be second-generation. This class converts all incoming CIDs to second-generation format, so users should never see first-generation CIDs.
"
Class {
	#name : #IpfsCid,
	#superclass : #ByteArray,
	#type : #bytes,
	#category : #'IPFS-1 - CIDs and paths'
}

{ #category : #private }
IpfsCid class >> fromCidV0: aString [
	"Take a CIDv0 encoded in base58btc (the only possible one) and convert to to a CIDv1."
	| bytes cid |
	bytes := MultibaseBase58btc new decode: aString.
	cid := self new: bytes size + 2.
	cid replaceFrom: 3 to: bytes size +2 with: bytes.
	"Set CID version number to 1"
	cid at: 1 put: 1.
	"Set multicodec to 0x70 (dag-pb) which is the only possible one for a v0 CID."
	cid at: 2 put: 16r70.	
	^ cid
]

{ #category : #'instance creation' }
IpfsCid class >> fromJSON: aDictionary [
	| cidString |
	self assert: aDictionary size = 1.
	cidString := aDictionary at: '/'.
	^ self fromString: cidString
]

{ #category : #'instance creation' }
IpfsCid class >> fromString: aString [
	| trimmedString bytes |
	trimmedString := aString trimBoth.
	"Deal with v0 CIDs by converting them to v1 CIDs"
	(trimmedString size = 46 and: [ trimmedString beginsWith: 'Qm' ])
		ifTrue: [ ^ self fromCidV0: trimmedString ].
	"Handle v1 CIDs"
	bytes := MultibaseEncoder new decode: trimmedString.
	bytes first = 18
		ifTrue: [ self error: 'Incorrectly encoded CIDv0' ].
	^ (self new: bytes size) replaceFrom: 1 to: bytes size with: bytes
]

{ #category : #converting }
IpfsCid >> asIpfsCid [
	^ self
]

{ #category : #converting }
IpfsCid >> asIpfsPath [
	^ IpfsCidPath new cid: self
]

{ #category : #converting }
IpfsCid >> asString [
	^ self encodeInBase: #base32
]

{ #category : #converting }
IpfsCid >> decodeFromIpfsUsing: anIpfsMapper [
	^ self
]

{ #category : #'data access' }
IpfsCid >> decodeLinkedObjectsFromIpfsUsing: anIpfsMapper [
	^ IpfsLink to: (self loadLinkedObjectsUsing: anIpfsMapper)
]

{ #category : #converting }
IpfsCid >> encodeInBase: aSymbol [
	^ MultibaseEncoder new encode: self base: aSymbol
]

{ #category : #testing }
IpfsCid >> isRaw [
	^ (self parse at: #codec) = 'raw'
]

{ #category : #'data access' }
IpfsCid >> loadJson [
	^ Ipfs dagGet: self
]

{ #category : #'data access' }
IpfsCid >> loadLinkedObjects [
	^ self loadLinkedObjectsUsing: IpfsDefaultMapper default
]

{ #category : #'data access' }
IpfsCid >> loadLinkedObjectsUsing: anIpfsMapper [
	^ self loadJson decodeLinkedObjectsFromIpfsUsing: anIpfsMapper
]

{ #category : #'data access' }
IpfsCid >> loadObject [
	^ self loadObjectUsing: IpfsDefaultMapper default
]

{ #category : #'data access' }
IpfsCid >> loadObjectUsing: anIpfsMapper [
	^ self loadJson decodeFromIpfsUsing: anIpfsMapper
]

{ #category : #'data access' }
IpfsCid >> loadRaw [
	^ Ipfs blockGet: self asString

]

{ #category : #converting }
IpfsCid >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMap: { '/' -> self asString } asDictionary
]

{ #category : #parsing }
IpfsCid >> parse [
	"Parses the byte sequence according to the CID specification.
	 May raise an error for future CID formats.
	 Answers a dictionary with the parsed fields."
	| bytes fields |
	bytes := self readStream.
	fields := OrderedDictionary new.
	"The version number is a varint."
	fields at: #version put: (MultiformatsVarIntParser new fromByteStream: bytes).
	"The codec is specified by one byte whose meaning is defined by convention.
	 Full table: https://github.com/multiformats/multicodec/blob/master/table.csv."
	fields at: #codec put: (MultiformatsCodeTable codecForCode: bytes next).
	"The hash function is specified by a code (from the same table as the codec). That code is a    	varint, but out of laziness we accept only one-byte codes for now."
	fields at: #hashFunction put: (MultiformatsCodeTable hashFunctionForCode: bytes next).
	"The hash length is a varint"
	fields at: #hashLength put: (MultiformatsVarIntParser new fromByteStream: bytes).
	"Check that the following bytes are no more nor less than the hash"
	self
		assert: (self size - bytes position ) = (fields at: #hashLength)
		description: 'wrong size of CID data'.
	^ fields
]

{ #category : #printing }
IpfsCid >> printOn: aStream [
	aStream nextPutAll: self class name;
			  nextPut: $(;
			  nextPutAll: self asString;
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

{ #category : #resolving }
IpfsCid >> resolveLink: aString [
	self assert: self isRaw not description: 'Raw data contains no links'.
	^ self loadJson at: aString
]

{ #category : #resolving }
IpfsCid >> resolveLinks: aLinkSequence [
	| nextInChain |
	aLinkSequence ifEmpty: [ ^ self ].
	nextInChain := self resolveLink: aLinkSequence first.
	aLinkSequence size = 1 ifTrue: [ ^ nextInChain ].
	^ nextInChain resolveLinks: aLinkSequence allButFirst.
]

{ #category : #'data access' }
IpfsCid >> sizeOfRawData [
	^ Ipfs blockSize: self asString

]

{ #category : #printing }
IpfsCid >> storeOn: aStream [
	aStream nextPutAll: '(IpfsCid fromString: '.
	self asString storeOn: aStream.
	aStream nextPut: $).

]
