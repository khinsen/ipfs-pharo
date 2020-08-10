Class {
	#name : #IpfsWikiBrowser,
	#superclass : #BlElement,
	#instVars : [
		'wiki',
		'documenter',
		'pageName',
		'titleEditorElement',
		'pageNameEditorElement'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #'instance creation' }
IpfsWikiBrowser class >> forWiki: anIpfsWiki [
	^ self new
		wiki: anIpfsWiki;
		yourself
]

{ #category : #'instance creation' }
IpfsWikiBrowser class >> forWiki: anIpfsWiki page: aSymbol [
	^ self new
		wiki: anIpfsWiki page: aSymbol;
		yourself
]

{ #category : #initialization }
IpfsWikiBrowser >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	self initializeTitlebar.
	self initializeDocumenter.
]

{ #category : #initialization }
IpfsWikiBrowser >> initializeDocumenter [
	documenter := GtDocumenter forText: 'Empty page'.
	self addChild: documenter as: #documenter
]

{ #category : #initialization }
IpfsWikiBrowser >> initializePageNameEditorElement [
	pageNameEditorElement := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousRegularFont;
				italic;
				fontSize: 18);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent];
		text: 'Untitled'.
	pageNameEditorElement editor
		when: BrTextEditorModifiedEvent 
		do: [ :anEvent |
			| newName |
			newName := anEvent text asString asSymbol.
			self wiki renamePage: pageName to: newName.
			pageName := newName ]
]

{ #category : #initialization }
IpfsWikiBrowser >> initializeTitleEditorElement [
	titleEditorElement := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousRegularFont;
				bold;
				fontSize: 18);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent];
		text: 'Untitled'.
	titleEditorElement editor
		when: BrTextEditorModifiedEvent 
		do: [ :anEvent |
			self wiki title: anEvent text asString ]
]

{ #category : #initialization }
IpfsWikiBrowser >> initializeTitlebar [
	| header titlebar separator |
	self initializeTitleEditorElement.
	self initializePageNameEditorElement.
	header := BrVerticalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	titlebar := BrHorizontalPane new
		hMatchParent;
		alignBottomCenter;
		vFitContent.
	titlebar addChild: titleEditorElement.
	titlebar addChild: pageNameEditorElement.
	header addChild: titlebar.

	separator := BlElement new labeled: 'Separator'.
	separator background: BrGlamorousColors lightBorderColor.
	separator elevation: (BlRelativeElevation elevation: -1).
	separator constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: 1.
		c ignoreByLayout.
		c ignored vertical alignBottom ].

	header addChild: separator.
	self addChild: header as: #header.
]

{ #category : #initialization }
IpfsWikiBrowser >> titleEditorElement [
	| editorElement |
	editorElement := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousRegularFont;
				bold;
				fontSize: 18);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent];
		text: 'Untitled'.
	editorElement editor
		when: BrTextEditorModifiedEvent 
		do: [ :anEvent |
			self wiki title: anEvent text asString ].
	^ editorElement
]

{ #category : #accessing }
IpfsWikiBrowser >> wiki [
	^ wiki
]

{ #category : #accessing }
IpfsWikiBrowser >> wiki: anIpfsWiki [
	self wiki: anIpfsWiki page: #Main
]

{ #category : #'instance creation' }
IpfsWikiBrowser >> wiki: anIpfsWiki page: aSymbol [
	wiki := anIpfsWiki.
	pageName := aSymbol.
	titleEditorElement text: wiki title.
	pageNameEditorElement text: pageName asString.
	documenter ipfsDocument: (wiki pageNamed: pageName); read
]
