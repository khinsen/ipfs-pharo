Extension { #name : #IpfsPharoObjectTest }

{ #category : #'*IPFS-GToolkit' }
IpfsPharoObjectTest >> testStoreAndLoadIpfsDocument [
	| document |
	document := IpfsDocument name: #Test text: 'This is a test document'.
	self storeLoadCheck: document.
]

{ #category : #'*IPFS-GToolkit' }
IpfsPharoObjectTest >> testStoreAndLoadIpfsWiki [
	| wiki |
	wiki := IpfsWiki new.
	(wiki createOrRetrievePageNamed: #Page1)
		text: 'Text of page 1'. 
	(wiki createOrRetrievePageNamed: #Page2)
		text: 'Text of page 2'. 
	self storeLoadCheck: wiki.
]
