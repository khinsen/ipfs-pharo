"
!A page in an ${class:name=IpfsWiki}$

A Wiki page is an ${class:name=IpfsDocument}$ that keeps a reference to the Wiki of which it is a part.
"
Class {
	#name : #IpfsWikiPage,
	#superclass : #IpfsDocument,
	#instVars : [
		'wiki'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #storing }
IpfsWikiPage class >> ipfsTag [
	^ #WikiPage
]

{ #category : #testing }
IpfsWikiPage >> isWikiPage [
	^ true
]

{ #category : #accessing }
IpfsWikiPage >> renameWikiLinksFrom: pageName to: newName [
	| parser doc nameTransformation renamer changedDoc changedText |
	parser := PRPillarParser new optimize.
	doc := parser parse: self text.
	nameTransformation := Dictionary with: pageName -> newName.
	renamer := IpfsWikiLinkRenamer new
					nameTransformation: nameTransformation.
	changedDoc := (renamer executeOn:
							((PRCompilationContext
								withDocument: doc
								withConfiguration: nil)))
					input.
	renamer hasModifiedDoc ifTrue: [
		changedText := PRPillarWriter write: changedDoc.
		self text: changedText ]
]

{ #category : #accessing }
IpfsWikiPage >> wiki [
	^ wiki
]

{ #category : #accessing }
IpfsWikiPage >> wiki: anObject [
	wiki := anObject
]
