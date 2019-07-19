Extension { #name : #IpfsByteLevelCid }

{ #category : #'*IPFS-GToolkit' }
IpfsByteLevelCid >> gtCidDataFor: aView [
	<gtView>
	^ aView columnedList
		title: 'CID';
		priority: -10;
		items: [ {	#Base32 -> (self encodeInBase: #base32).
						#Base64 -> (self encodeInBase: #base64).
						#Version -> (self at: 1).
						#Codec -> (self at: 2).
"						#'Hash function' -> self hashFunction.
						#'Hash length' -> self hashLength.
"						 } ];
		column: 'Key' item: [ :aField | aField key ];
		column: 'Value' item: [ :aField | aField value ];
		send: [ :aField | aField value ].
]

{ #category : #'*IPFS-GToolkit' }
IpfsByteLevelCid >> gtDisplayOn: stream [
	"Override the implementation in class Collection that shows all elements"
	stream nextPutAll: self asString
]
