"
!A byte-level CID implementation

Contrary to ${class:name=IpfsCid}$, this implementation uses the byte-level representation of a CID and does its own multibase encoding/decoding to/from string representations. When completed, it will replace ${class:name=IpfsCid}$ and its subclasses. 
"
Class {
	#name : #IpfsByteLevelCid,
	#superclass : #ByteArray,
	#type : #bytes,
	#category : #'IPFS-1 - CIDs and paths'
}

{ #category : #private }
IpfsByteLevelCid class >> fromCidV0: aString [
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
IpfsByteLevelCid class >> fromString: aString [
	| bytes |
	(aString size = 46 and: [ aString beginsWith: 'Qm' ])
		ifTrue: [ ^ self fromCidV0: aString ].
	bytes := MultibaseEncoder new decode: aString.
	bytes first = 18
		ifTrue: [ self error: 'Incorrectly encoded CIDv0' ].
	^ (self new: bytes size)
		replaceFrom: 1 to: bytes size with: bytes.
]

{ #category : #'self-update' }
IpfsByteLevelCid class >> updateCodecTable [
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
IpfsByteLevelCid >> asString [
	^ self encodeInBase: #base32
]

{ #category : #parsing }
IpfsByteLevelCid >> codecForCode: anInteger [
"Automatically generated method, do not edit!"
   ^ ((Dictionary new) add: (144->'eth-block'); add: (145->'eth-block-list'); add: (146->'eth-tx-trie'); add: (147->'eth-tx'); add: (148->'eth-tx-receipt-trie'); add: (149->'eth-tx-receipt'); add: (150->'eth-state-trie'); add: (151->'eth-account-snapshot'); add: (152->'eth-storage-trie'); add: (192->'zcash-block'); add: (193->'zcash-tx'); add: (240->'dash-block'); add: (241->'dash-tx'); add: (250->'swarm-manifest'); add: (251->'swarm-feed'); add: (112->'dag-pb'); add: (113->'dag-cbor'); add: (114->'libp2p-key'); add: (208->'stellar-block'); add: (209->'stellar-tx'); add: (297->'dag-json'); add: (120->'git-raw'); add: (123->'torrent-info'); add: (124->'torrent-file'); add: (129->'leofcoin-block'); add: (130->'leofcoin-tx'); add: (131->'leofcoin-pr'); add: (85->'raw'); add: (176->'bitcoin-block'); add: (177->'bitcoin-tx'); add: (224->'decred-block'); add: (225->'decred-tx'); yourself) at: anInteger
]

{ #category : #converting }
IpfsByteLevelCid >> encodeInBase: aSymbol [
	^ MultibaseEncoder new encode: self base: aSymbol
]

{ #category : #parsing }
IpfsByteLevelCid >> parse [
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
IpfsByteLevelCid >> printOn: aStream [
	aStream nextPutAll: self class name;
			  nextPut: $(;
			  nextPutAll: self asString;
			  nextPut: $).

]

{ #category : #printing }
IpfsByteLevelCid >> storeOn: aStream [
	aStream nextPutAll: '(IpfsCid fromString: '.
	self asString storeOn: aStream.
	aStream nextPut: $).

]
