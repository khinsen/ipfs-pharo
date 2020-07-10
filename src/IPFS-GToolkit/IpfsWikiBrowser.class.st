Class {
	#name : #IpfsWikiBrowser,
	#superclass : #BlElement,
	#instVars : [
		'wiki',
		'documenter',
		'titleElement',
		'pageName'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #'instance creation' }
IpfsWikiBrowser class >> forWiki: anIpfsWiki [
	^ self new
		wiki: anIpfsWiki;
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
IpfsWikiBrowser >> initializeTitlebar [
	| titlebar |
	titleElement := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousRegularFont;
				bold;
				fontSize: 18);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent];
		text: 'Untitled'.
	titlebar := BrHorizontalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	titlebar addChild: titleElement.
	self addChild: titlebar as: #titlebar
]

{ #category : #accessing }
IpfsWikiBrowser >> wiki [
	^ wiki
]

{ #category : #accessing }
IpfsWikiBrowser >> wiki: anIpfsWiki [
	wiki := anIpfsWiki.
	pageName := #Main.
	titleElement text: wiki title.
	documenter ipfsDocument: (wiki pageNamed: pageName); read
]
