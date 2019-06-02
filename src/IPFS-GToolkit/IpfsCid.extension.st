Extension { #name : #IpfsCid }

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> defaultDataViewFor: aView [
	| view |
	view := self load ipfsDataViewFor: aView.
	^ view
		title: 'Data';
		priority: -6;
		yourself.

]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> defaultReferencesFor: aView [
	^ aView list
		title: 'References';
		priority: -5;
		items: [ self references ];
		itemFormat: [ :aCid | aCid asString ].
]

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtCidDataFor: aView [
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

{ #category : #'*IPFS-GToolkit' }
IpfsCid >> gtRawDataFor: aView [
	<gtView>
	| view |
	view := self loadRawData ipfsDataViewFor: aView.
	^ view
		title: 'Raw data';
		priority: -4;
		yourself.

]