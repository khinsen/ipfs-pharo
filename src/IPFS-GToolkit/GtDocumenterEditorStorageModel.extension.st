Extension { #name : #GtDocumenterEditorStorageModel }

{ #category : #'*IPFS-GToolkit' }
GtDocumenterEditorStorageModel >> ipfsDocument: anIpfsDocument [
	self storage: (IpfsDocumentStorageStrategy new document: anIpfsDocument)
]
