"
!Code table for Multiformats

Algorithms such as hash functions or codecs are encoded as a small number of bytes assigned by convention. A single table, located at *https://raw.githubusercontent.com/multiformats/multicodec/master/table.csv*, contains all the bytes codes currently assigned. This class makes this table accessible to Pharo code. It has only class methods. ${method:name=MultiformatsCodeTable>>updateSelf}$ generates the methods of the lookup protocol based on the current state of the table referred to above.

"
Class {
	#name : #MultiformatsCodeTable,
	#superclass : #Object,
	#category : #'Multiformats-Core'
}

{ #category : #lookup }
MultiformatsCodeTable class >> codecForCode: anInteger [
"Automatically generated method, do not edit!"
   ^ ((Dictionary new) add: (144->'eth-block'); add: (145->'eth-block-list'); add: (146->'eth-tx-trie'); add: (147->'eth-tx'); add: (148->'eth-tx-receipt-trie'); add: (149->'eth-tx-receipt'); add: (150->'eth-state-trie'); add: (151->'eth-account-snapshot'); add: (152->'eth-storage-trie'); add: (192->'zcash-block'); add: (193->'zcash-tx'); add: (240->'dash-block'); add: (241->'dash-tx'); add: (250->'swarm-manifest'); add: (251->'swarm-feed'); add: (112->'dag-pb'); add: (113->'dag-cbor'); add: (114->'libp2p-key'); add: (208->'stellar-block'); add: (209->'stellar-tx'); add: (297->'dag-json'); add: (120->'git-raw'); add: (123->'torrent-info'); add: (124->'torrent-file'); add: (129->'leofcoin-block'); add: (130->'leofcoin-tx'); add: (131->'leofcoin-pr'); add: (85->'raw'); add: (176->'bitcoin-block'); add: (177->'bitcoin-tx'); add: (224->'decred-block'); add: (225->'decred-tx'); yourself) at: anInteger
]

{ #category : #lookup }
MultiformatsCodeTable class >> hashFunctionForCode: anInteger [
"Automatically generated method, do not edit!"
   ^ ((Dictionary new) add: (0->'identity'); add: (29->'keccak-512'); add: (86->'dbl-sha2-256'); add: (34->'murmur3-128'); add: (35->'murmur3-32'); add: (212->'md4'); add: (213->'md5'); add: (214->'bmt'); add: (17->'sha1'); add: (18->'sha2-256'); add: (19->'sha2-512'); add: (20->'sha3-512'); add: (21->'sha3-384'); add: (22->'sha3-256'); add: (23->'sha3-224'); add: (24->'shake-128'); add: (25->'shake-256'); add: (26->'keccak-224'); add: (27->'keccak-256'); add: (28->'keccak-384'); yourself) at: anInteger
]

{ #category : #'self-update' }
MultiformatsCodeTable class >> updateIpldCodecTable: multiformatTable [
	| map |
	map := ((multiformatTable
		select: [ :each | each second = 'ipld'])
		collect:
			[ :each | (each third copyReplaceAll: '0x' with: '16r') asNumber -> each first ])
		asDictionary.
	self class
		compile:
			'codecForCode: anInteger' , Character cr asString
				, '"Automatically generated method, do not edit!"'
				, Character cr asString , '   ^ ' , map storeString
				, ' at: anInteger'
		classified: 'lookup'
]

{ #category : #'self-update' }
MultiformatsCodeTable class >> updateMultihashTable: multiformatTable [
	| map |
	map := ((multiformatTable
		select: [ :each | each second = 'multihash' and: [each third size = 4]
								"take only the multihash records with a one-byte code" ])
		collect:
			[ :each | (each third copyReplaceAll: '0x' with: '16r') asNumber -> each first ])
		asDictionary.
	self class
		compile:
			'hashFunctionForCode: anInteger' , Character cr asString
				, '"Automatically generated method, do not edit!"'
				, Character cr asString , '   ^ ' , map storeString
				, ' at: anInteger'
		classified: 'lookup'
]

{ #category : #'self-update' }
MultiformatsCodeTable class >> updateSelf [
	| url table |
	url := 'https://raw.githubusercontent.com/multiformats/multicodec/master/table.csv'.
	table := (ZnClient new
			beOneShot;
			get: url;
			entity)
		contents.
	table := table allButFirst lines
		collect: [ :each | (each splitOn: $,) collect: #trimBoth ].
	self updateIpldCodecTable: table.
	self updateMultihashTable: table
]
