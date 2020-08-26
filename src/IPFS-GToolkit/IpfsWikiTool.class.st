Class {
	#name : #IpfsWikiTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'wiki',
		'pageName'
	],
	#category : #'IPFS-GToolkit-Tool - Core'
}

{ #category : #'api - converting' }
IpfsWikiTool >> asElementDo: aOneArgBlock [
	| anElement |
	anElement := IpfsWikiBrowser forWiki:wiki page: pageName.
	^ aOneArgBlock cull: anElement
]

{ #category : #'api - converting' }
IpfsWikiTool >> asTabDo: aBlock [
	| aTab |
	aTab := BrTab new
		look: BrGlamorousTabSwitcherWithIconLook;
		label: self name;
		icon: (BrGlamorousVectorIcons largebranching asElement asScalableElement size: 16@16);
		stencil: [ self asElementDo: [ :anElement | anElement ] ].
	aBlock cull: aTab.
]

{ #category : #'api - accessing' }
IpfsWikiTool >> name [
	^ 'wiki'
]

{ #category : #'api - accessing' }
IpfsWikiTool >> wiki [
	^ wiki
]

{ #category : #'api - accessing' }
IpfsWikiTool >> wiki: anIpfsWiki [
	self wiki: anIpfsWiki page: #Main
]

{ #category : #'api - accessing' }
IpfsWikiTool >> wiki: anIpfsWiki page: aSymbol [
	wiki := anIpfsWiki.
	pageName := aSymbol
]
