Extension { #name : #IpldCid }

{ #category : #'*IPFS-GToolkit' }
IpldCid >> gtCidDataFor: aView [
	<gtView>
	^ aView columnedList
		title: 'CID';
		priority: -10;
		items: [ {	#Base32 -> cidBase32.
						#Version -> self version.
						#Codec -> self class codec.
						#'Hash function' -> self hashFunction.
						#'Hash length' -> self hashLength } ];
		column: 'Key' item: [ :aField | aField key ];
		column: 'Value' item: [ :aField | aField value ];
		send: [ :aField | aField value ].
]
