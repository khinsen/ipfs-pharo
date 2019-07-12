"
!A Wiki stored in IPFS

"
Class {
	#name : #IpfsWiki,
	#superclass : #Object,
	#instVars : [
		'pages'
	],
	#category : #'IPFS-GToolkit'
}

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

{ #category : #storing }
IpfsWiki >> encodeForIpfs [
	^ NeoJSONObject with: #IpfsWiki ->
		(pages collect: [ :each | each storeInIpfs ])
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
	^ aView list
		title: 'Pages' translated;
		priority: -9;
		items: [ pages values ];
		itemFormat: [ :page | page name ]
]

{ #category : #initialization }
IpfsWiki >> initalPageContents [
	^ '!New page'
]

{ #category : #initialization }
IpfsWiki >> initialize [
	pages := NeoJSONObject new.
]

{ #category : #accessing }
IpfsWiki >> pageNamed: aSymbol [
	^ pages at: aSymbol ifAbsent: [ nil ]
]
