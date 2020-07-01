"
!A Wiki stored in IPFS

"
Class {
	#name : #IpfsWiki,
	#superclass : #Object,
	#instVars : [
		'pages',
		'description',
		'title'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #instance }
IpfsWiki class >> title: aShortString description: aLongerString [
	^ self new
		title: aShortString;
		description: aLongerString;
		yourself
]

{ #category : #comparing }
IpfsWiki >> = other [
	^ self class = other class
		and: [ pages = other pages ]
]

{ #category : #private }
IpfsWiki >> addPage: anIpfsWikiPage [
	"For use by IpfsObjectDecoder>>#decodeIpfsWiki:"
	anIpfsWikiPage wiki: self.
	pages at: anIpfsWikiPage name put: anIpfsWikiPage
]

{ #category : #accessing }
IpfsWiki >> createOrRetrievePageNamed: aSymbol [
	^ pages at: aSymbol
			  ifAbsentPut:
					[ IpfsWikiPage new
						wiki: self;
						name: aSymbol;
						text: self initalPageContents ]
]

{ #category : #accessing }
IpfsWiki >> description [
	^ description
]

{ #category : #accessing }
IpfsWiki >> description: aString [
	description := aString
]

{ #category : #inspecting }
IpfsWiki >> gtMainPageFor: aView [
	<gtView>
	^ ((self createOrRetrievePageNamed: #Main)
		gtDocumentFor: aView)
			title: 'Main Page' translated;
			priority: -10;
			yourself
]

{ #category : #inspecting }
IpfsWiki >> gtPagesFor: aView [
	<gtView>
	| pageNames |
	pageNames := pages keys.
	pageNames sort.
	^ aView list
		title: 'Pages' translated;
		priority: -9;
		items: [ pageNames collect: [ :name | pages at: name ] ];
		itemFormat: [ :page | page name ]
]

{ #category : #comparing }
IpfsWiki >> hash [
	^ pages inject: 0 into: [ :hash :page | hash xor: page hash ]
]

{ #category : #initialization }
IpfsWiki >> initalPageContents [
	^ '!New page'
]

{ #category : #initialization }
IpfsWiki >> initialize [
	pages := NeoJSONObject new.
	title := ''.
	description := ''
]

{ #category : #accessing }
IpfsWiki >> pageNamed: aSymbol [
	^ pages at: aSymbol ifAbsent: [ nil ]
]

{ #category : #accessing }
IpfsWiki >> pages [
	^ pages
]

{ #category : #private }
IpfsWiki >> removePage: aSymbol [
	pages removeKey: aSymbol.
]

{ #category : #accessing }
IpfsWiki >> renamePage: pageName to: newName [
	pages at: pageName ifAbsent: [ self error: 'No page named ', pageName ].
	pages at: newName ifPresent: [ self error: 'There is already a page named ', newName ].
	pages do: [ :each | each renameWikiLinksFrom: pageName to: newName ].
	pages at: newName put: (pages at: pageName).
	pages removeKey: pageName.
	(pages at: newName) name: newName
]

{ #category : #accessing }
IpfsWiki >> title [
	^ title
]

{ #category : #accessing }
IpfsWiki >> title: aString [
	title := aString
]
