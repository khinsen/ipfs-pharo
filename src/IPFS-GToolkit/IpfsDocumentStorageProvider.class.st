Class {
	#name : #IpfsDocumentStorageProvider,
	#superclass : #GtStorageStrategy,
	#instVars : [
		'document'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #accessing }
IpfsDocumentStorageProvider >> basename [
	<return: #String>
	^ self name
]

{ #category : #accessing }
IpfsDocumentStorageProvider >> document [
	^ document
]

{ #category : #initialization }
IpfsDocumentStorageProvider >> document: anIpfsDocument [
	document := anIpfsDocument
]

{ #category : #accessing }
IpfsDocumentStorageProvider >> evaluationReceiver [
	<return: #Object>
	^ nil
]

{ #category : #testing }
IpfsDocumentStorageProvider >> exists [
	<return: #Boolean>
	^ true
]

{ #category : #testing }
IpfsDocumentStorageProvider >> isWikiPage [
	^ document isWikiPage
]

{ #category : #accessing }
IpfsDocumentStorageProvider >> name [
	"Return a string representing the stored document"
	<return: #String>
	^ document name
]

{ #category : #actions }
IpfsDocumentStorageProvider >> read: aGtDocument [ 
	aGtDocument text: document text
]

{ #category : #accessing }
IpfsDocumentStorageProvider >> rootDirectory [
	<return: #FileReference>
	^ FileSystem workingDirectory

]

{ #category : #actions }
IpfsDocumentStorageProvider >> store: aGtDocument [
	document text: aGtDocument text asString	
]
