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

{ #category : #'self-update' }
IpfsCid class >> updateCodecTable [
	| url table map |
	url := 'https://raw.githubusercontent.com/multiformats/multicodec/master/table.csv'.
	table :=
		(ZnClient new
			beOneShot;
			get: url;
			entity) contents.
	map := (((table allButFirst lines
		collect: [ :each | (each splitOn: $,) collect: #trimBoth ])
		select: [ :each | each second = 'ipld' ])
		collect: [ :each | (each third copyReplaceAll: '0x' with: '16r') asNumber
									-> each first ])
		asDictionary.
	self compile:
			'codecForCode: anInteger', Character cr asString,
			'"Automatically generated method, do not edit!"', Character cr asString,
			'   ^ ', map storeString, ' at: anInteger'
		  classified: 'parsing'
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

{ #category : #parsing }
IpfsCid >> codecForCode: anInteger [
"Automatically generated method, do not edit!"
   ^ ((Dictionary new) add: (144->'eth-block'); add: (145->'eth-block-list'); add: (146->'eth-tx-trie'); add: (147->'eth-tx'); add: (148->'eth-tx-receipt-trie'); add: (149->'eth-tx-receipt'); add: (150->'eth-state-trie'); add: (151->'eth-account-snapshot'); add: (152->'eth-storage-trie'); add: (192->'zcash-block'); add: (193->'zcash-tx'); add: (240->'dash-block'); add: (241->'dash-tx'); add: (250->'swarm-manifest'); add: (251->'swarm-feed'); add: (112->'dag-pb'); add: (113->'dag-cbor'); add: (114->'libp2p-key'); add: (208->'stellar-block'); add: (209->'stellar-tx'); add: (297->'dag-json'); add: (120->'git-raw'); add: (123->'torrent-info'); add: (124->'torrent-file'); add: (129->'leofcoin-block'); add: (130->'leofcoin-tx'); add: (131->'leofcoin-pr'); add: (85->'raw'); add: (176->'bitcoin-block'); add: (177->'bitcoin-tx'); add: (224->'decred-block'); add: (225->'decred-tx'); yourself) at: anInteger
]

{ #category : #converting }
IpfsCid >> decodeFromIpfs [
	^ self
]

{ #category : #'data access' }
IpfsCid >> decodeLinkedObjectsFromIpfs [
	^ IpfsLink to: self loadLinkedObjects
]

{ #category : #storing }
IpfsCid >> encodeForIpfs [
	^ NeoJSONObject with: '/' -> self asString
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
IpfsCid >> loadAndDecode [
	^ Ipfs dagGet: self
]

{ #category : #'data access' }
IpfsCid >> loadLinkedObjects [
	^ self loadAndDecode decodeLinkedObjectsFromIpfs
]

{ #category : #'data access' }
IpfsCid >> loadObject [
	^ self loadAndDecode decodeFromIpfs
]

{ #category : #'data access' }
IpfsCid >> loadRawBlock [
	^ Ipfs blockGet: self asString

]

{ #category : #converting }
IpfsCid >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMap: { '/' -> self asString } asDictionary
]

{ #category : #parsing }
IpfsCid >> parse [
	"Parses the byte sequence according to the CID specification, taking some shortcuts
	 but checking if they are applicable. May raise an error for future CID formats.
	 Answers a dictionary with the parsed fields."
	| fields |
	fields := OrderedDictionary new.
	"The version is a varint, but that will matter only when the version number
	 reaches 128. Today (2019) it's always 1"
	fields at: #version put: self first.
	(fields at: #version) > 127 ifTrue: [ self error: 'Unsupported CID version' ].
	"The codec is specified by one byte whose meaning is defined by convention.
	 Full table: https://github.com/multiformats/multicodec/blob/master/table.csv."
	fields at: #codec put: (self codecForCode: self second).

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
	^ self loadAndDecode at: aString
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
