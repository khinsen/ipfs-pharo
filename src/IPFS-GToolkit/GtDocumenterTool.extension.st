Extension { #name : #GtDocumenterTool }

{ #category : #'*IPFS-GToolkit' }
GtDocumenterTool class >> forIpfsDocument: anIpfsDocument [
	^ self new valuable: [ (GtDocumenter forIpfsDocument: anIpfsDocument) 
		withDefaultToolbar;
		asPagerPageElement ]
]
