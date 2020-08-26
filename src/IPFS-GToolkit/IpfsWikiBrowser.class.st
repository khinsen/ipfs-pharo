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
IpfsWikiBrowser >> buildHeader [
	| header titlebar separator |
	header := BrVerticalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	titlebar := BlElement new
		labeled: 'Titlebar';
		layout: BlGridLayout new.
		"layout: BlLinearLayout horizontal alignCenterLeft"
	titlebar constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	titlebar addChild:
		(self buildPageSelectorButton
			constraintsDo: [ :c |
				c grid horizontal alignLeft.
				c grid vertical alignBottom ]
			yourself).
	titlebar addChild: pageNameEditorElement.
	pageNameEditorElement constraintsDo: [ :c |
		c grid horizontal alignLeft ].
	titlebar addChild: titleEditorElement.
	titleEditorElement constraintsDo: [ :c |
		c grid horizontal alignRight ].
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
	^ header
]

{ #category : #initialization }
IpfsWikiBrowser >> buildPageList [
	^ BrSimpleList new
		itemStencil: [
			BrLabel new
				hMatchParent;
				look: BrGlamorousLabelLook new;
				padding: (BlInsets all: 5);
				addEventHandler: (BlEventHandler on: BlClickEvent do: [ :anEvent | self page: anEvent target text asString ]) ];
		itemDataBinder: [ :eachElement :eachPageName :eachIndex | eachElement text: eachPageName ];
		items: (self wiki pageNames);
		lookDo: [ :aLook | aLook listElement constraintsDo: [ :c | c maxHeight: 200 ] ];
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: 5);
		vFitContent;
		hExact: 200
]

{ #category : #initialization }
IpfsWikiBrowser >> buildPageSelectorButton [
	^ BrButton new
		label: 'Wiki Pages';
		look: BrGlamorousButtonWithIconLook + (BrGlamorousWithDropdownLook
			handle: [
				BrButton new
					look: BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook - BrGlamorousButtonExteriorLook;
					icon: BrGlamorousIcons hamburger;
					yourself ]
			content: [ self buildPageList ]);
		icon: BrGlamorousIcons hamburger asElement;
		beLarge;
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
	self initializePageNameEditorElement.
	self initializeTitleEditorElement.
	self initializeDocumenter.
	self addChild: (self buildHeader) as: #header.
	self addChild: documenter as: #documenter.
]

{ #category : #initialization }
IpfsWikiBrowser >> initializeDocumenter [
	documenter := GtDocumenter forText: 'Empty page'.
]

{ #category : #initialization }
IpfsWikiBrowser >> initializePageNameEditorElement [
	pageNameEditorElement := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousRegularFont;
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

{ #category : #accessing }
IpfsWikiBrowser >> page: aSymbol [
	pageName := aSymbol.
	pageNameEditorElement text: pageName asString.
	documenter ipfsDocument: (wiki pageNamed: pageName); read
]

{ #category : #accessing }
IpfsWikiBrowser >> wiki [
	^ wiki
]

{ #category : #accessing }
IpfsWikiBrowser >> wiki: anIpfsWiki [
	self wiki: anIpfsWiki page: #Main
]

{ #category : #accessing }
IpfsWikiBrowser >> wiki: anIpfsWiki page: aSymbol [
	wiki := anIpfsWiki.
	pageName := aSymbol.
	titleEditorElement text: wiki title.
	pageNameEditorElement text: pageName asString.
	documenter ipfsDocument: (wiki pageNamed: pageName); read
]
