Class {
	#name : #IpfsDocumentStorageStrategy,
	#superclass : #GtStorageStrategy,
	#instVars : [
		'document'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #accessing }
IpfsDocumentStorageStrategy >> basename [
	<return: #String>
	^ self name
]

{ #category : #accessing }
IpfsDocumentStorageStrategy >> document [
	^ document
]

{ #category : #initialization }
IpfsDocumentStorageStrategy >> document: anIpfsDocument [
	document := anIpfsDocument
]

{ #category : #accessing }
IpfsDocumentStorageStrategy >> evaluationReceiver [
	<return: #Object>
	^ nil
]

{ #category : #testing }
IpfsDocumentStorageStrategy >> exists [
	<return: #Boolean>
	^ true
]

{ #category : #testing }
IpfsDocumentStorageStrategy >> isWikiPage [
	^ document isWikiPage
]

{ #category : #accessing }
IpfsDocumentStorageStrategy >> name [
	"Return a string representing the stored document"
	<return: #String>
	^ document name
]

{ #category : #actions }
IpfsDocumentStorageStrategy >> read: aGtDocumenter [
	aGtDocumenter text: document text
]

{ #category : #accessing }
IpfsDocumentStorageStrategy >> rootDirectory [
	<return: #FileReference>
	^ FileSystem workingDirectory

]

{ #category : #actions }
IpfsDocumentStorageStrategy >> save: aGtDocumenter [
	document text: aGtDocumenter text asString	
]
