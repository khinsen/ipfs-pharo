Extension { #name : #GtDocumenter }

{ #category : #'*IPFS-GToolkit' }
GtDocumenter class >> forIpfsDocument: anIpfsDocument [
	^ self new ipfsDocument: anIpfsDocument; read
]

{ #category : #'*IPFS-GToolkit' }
GtDocumenter >> ipfsDocument: anIpfsDocument [
	self editorElement ipfsDocument: anIpfsDocument
]
