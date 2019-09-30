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
IpfsWikiPage >> wiki [
	^ wiki
]

{ #category : #accessing }
IpfsWikiPage >> wiki: anObject [
	wiki := anObject
]
