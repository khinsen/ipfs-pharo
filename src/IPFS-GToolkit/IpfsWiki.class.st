Class {
	#name : #IpfsWiki,
	#superclass : #WkAbstractWiki,
	#instVars : [
		'pages',
		'description',
		'title'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #'instance creation' }
IpfsWiki class >> title: aShortString description: aLongerString [
	^ self new
		title: aShortString;
		description: aLongerString;
		yourself
]

{ #category : #comparing }
IpfsWiki >> = other [
	| pages1 pages2 |
	self class = other class ifTrue: [ ^ true ].
	pages1 := self pageNames.
	pages2 := other pageNames.
	pages1 = pages2 ifFalse: [ ^ false ].
	pages1 do: [ :each |
		(self page: each) = (other page: each) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
IpfsWiki >> description [
	^ description
]

{ #category : #accessing }
IpfsWiki >> description: aString [
	description := aString
]

{ #category : #initialization }
IpfsWiki >> initialize [
	super initialize.
	title := ''.
	description := ''.
	pages := NeoJSONObject new.
	self createOrRetrievePage: #Main
]

{ #category : #'api - accessing' }
IpfsWiki >> page: aSymbol [
	^ pages at: aSymbol
		ifPresent: [ :page | page text ]
		ifAbsent: [ nil ]
]

{ #category : #'api - accessing' }
IpfsWiki >> pageNames [
	| pageNames |
	pageNames := pages keys sorted asOrderedCollection.
	pageNames remove: #Main.
	pageNames addFirst: #Main.
	^ pageNames
]

{ #category : #'api - accessing' }
IpfsWiki >> removePage: aSymbol [
	pages removeKey: aSymbol
]

{ #category : #'api - accessing' }
IpfsWiki >> title [
	^ title
]

{ #category : #'api - accessing' }
IpfsWiki >> title: aString [
	title := aString
]

{ #category : #accessing }
IpfsWiki >> updatePage: aSymbol to: aString [
	pages at: aSymbol
		ifPresent: [ :page | page text: aString ]
		ifAbsent: [ pages at: aSymbol
						  put: (IpfsWikiPage new
						  		name: aSymbol;
						  		wiki: self;
						  		text: aString)]
]
