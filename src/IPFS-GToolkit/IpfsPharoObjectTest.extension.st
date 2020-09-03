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
	wiki createOrRetrievePage: #Page1.
	wiki updatePage: #Page1 to: 'Text of page 1'.
	wiki createOrRetrievePage: #Page2.
	wiki updatePage: #Page2 to: 'Text of page 2'.
	self storeLoadCheck: wiki.
]
