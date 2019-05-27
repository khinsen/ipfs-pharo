"
!Raw HTTP API tests 

The main role of these tests is to detect changes in the IPFS API.

"
Class {
	#name : #IpfsHttpApiTests,
	#superclass : #TestCase,
	#category : #'IPFSExploration-Tests '
}

{ #category : #testing }
IpfsHttpApiTests >> testBlockStat [
	| cid result |
	cid := 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'.
	result := self znClient
		path: 'api/v0/block/stat';
		queryAt: #arg add: cid asString;
		get.
	self assert: result trim
		  equals: '{"Key":"QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG","Size":309}'
]

{ #category : #testing }
IpfsHttpApiTests >> testCidConversion [
	| cid result |
	cid := 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'.

	result := self znClient
		path: 'api/v0/cid/base32';
		queryAt: #arg add: cid asString;
		get.
	self assert: result trim equals: '{"CidStr":"QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG","Formatted":"bafybeie5nqv6kd3qnfjupgvz34woh3oksc3iau6abmyajn7qvtf6d2ho34","ErrorMsg":""}'.

	result := self znClient
		path: 'api/v0/cid/format';
		queryAt: #arg add: cid asString;
		queryAt: #f add: '%P';
		get.
	self assert: result trim equals:
'{"CidStr":"QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG","Formatted":"cidv0-protobuf-sha2-256-32","ErrorMsg":""}'.
]

{ #category : #testing }
IpfsHttpApiTests >> testGetIpfsObject [
	| cid result |
	cid := 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'.
	result := self znClient
		path: 'api/v0/object/get';
		queryAt: #arg add: cid asString;
		get.
	self assert: result trim equals:
'{"Links":[{"Name":"about","Hash":"QmZTR5bcpQD7cFgTorqxZDYaew1Wqgfbd2ud9QqGPAkK2V","Size":1688},{"Name":"contact","Hash":"QmYCvbfNbCwFR45HiNP45rwJgvatpiW38D961L5qAhUM5Y","Size":200},{"Name":"help","Hash":"QmY5heUM5qgRubMDD1og9fhCPA6QdkMp3QCwd4s7gJsyE7","Size":322},{"Name":"quick-start","Hash":"QmdncfsVm2h5Kqq9hPmU7oAVX2zTSVP3L869tgTbPYnsha","Size":1728},{"Name":"readme","Hash":"QmPZ9gcCEpqKTo6aq61g2nXGUhM4iCL3ewB6LDXZCtioEB","Size":1102},{"Name":"security-notes","Hash":"QmTumTjvcYCAvRRwQ8sDRxh8ezmrcr88YFU7iYNroGGTBZ","Size":1027}],"Data":"\u0008\u0001"}'.
]

{ #category : #testing }
IpfsHttpApiTests >> testGetRawBlock [
	| cid result |
	cid := 'QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG'.
	result := self znClient
		beBinary;
		path: 'api/v0/block/get';
		queryAt: #arg add: cid asString;
		get.
	self assert: result equals:
#[18 46 10 34 18 32 165 44 54 2 3 12 185 18 237 254 77 233 112 2 253 173 249 212 86 102 195 190 18 42 46 251 93 185 60 29 95 166 18 5 97 98 111 117 116 24 152 13 18 48 10 34 18 32 146 154 48 60 57 218 138 11 103 192 150 151 70 47 104 122 0 198 56 188 181 128 254 174 6 69 46 12 31 32 180 47 18 7 99 111 110 116 97 99 116 24 200 1 18 45 10 34 18 32 144 192 122 119 149 193 25 53 16 166 150 209 253 252 15 30 73 71 207 248 228 34 97 9 150 230 9 219 203 151 101 152 18 4 104 101 108 112 24 194 2 18 52 10 34 18 32 229 134 25 150 64 225 164 198 63 163 140 84 52 185 231 45 201 157 35 163 145 211 219 94 30 66 208 5 39 36 22 113 18 11 113 117 105 99 107 45 115 116 97 114 116 24 192 13 18 47 10 34 18 32 18 15 106 246 1 212 110 16 178 210 225 30 215 28 85 210 95 48 66 194 37 1 228 29 18 70 231 161 233 211 216 236 18 6 114 101 97 100 109 101 24 206 8 18 55 10 34 18 32 82 198 60 119 117 57 107 63 130 198 57 151 122 114 35 194 217 106 159 112 181 253 139 29 81 63 140 91 105 220 174 212 18 14 115 101 99 117 114 105 116 121 45 110 111 116 101 115 24 131 8 10 2 8 1].
]

{ #category : #testing }
IpfsHttpApiTests >> testPutGetRawByteArray [
	| data cid result |
	data := #[1 2 3 4 3 2 1].

	result := self znClient
		path: 'api/v0/dag/put';
		queryAt: #f add: 'raw';
		queryAt: #'input-enc' add: 'raw';
		addPart: (ZnMimePart fieldName: 'file'
									value: data);
		post.
	cid := ((STONJSON fromString: result) at: 'Cid') at: '/'.

	result := self znClient
		path: 'api/v0/cid/format';
		queryAt: #arg add: cid;
		queryAt: #f add: '%c';
		get.
	self assert: ((STONJSON fromString: result) at: 'Formatted') equals: 'raw'.

	result := self znClient
		path: 'api/v0/block/get';
		queryAt: #arg add: cid;
		get.
	self assert: result asByteArray equals: data.

]

{ #category : #testing }
IpfsHttpApiTests >> testPutGetSimpleDagNodes [
	| testData cid result |
	testData := { 'aString' -> '"aString"'.
					  42 -> '42'.
					  -2.5 -> '-2.5'.
					  { 'foo' -> 'bar' } asDictionary -> '{"foo":"bar"}'}
					asDictionary.
	testData keysAndValuesDo:
		[ :object :json |
			result := self znClient
				path: 'api/v0/dag/put';
				addPart: (ZnMimePart fieldName: 'file'
											value: (NeoJSONWriter toString: object));
				post.
			cid := ((STONJSON fromString: result) at: 'Cid') at: '/'.
			result := self znClient
				path: 'api/v0/dag/get';
				queryAt: #arg add: cid;
				get.
			self assert: result trim equals: json ]

]

{ #category : #running }
IpfsHttpApiTests >> znClient [
	^ ZnClient new
		beOneShot;
		http;
		host: Ipfs ipfsServer;
		port: Ipfs ipfsPort;
		yourself.

]
