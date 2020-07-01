"
!Wiki links

This class represents annotations in parsed Pillar documents whose tag is ==ipfsWikiPage==. They are useful only in the pages of an ${class:name=IpfsWiki}$.
"
Class {
	#name : #IpfsWikiLinkAnnotation,
	#superclass : #GtAnnotation,
	#instVars : [
		'referencedPage'
	],
	#category : #'IPFS-GToolkit'
}

{ #category : #accessing }
IpfsWikiLinkAnnotation class >> possibleParameters [
	^ {
		self constants nameParameterName.
		self constants previewExpandedParameterName.
		self constants previewHeightParameterName.
		}
]

{ #category : #rendering }
IpfsWikiLinkAnnotation class >> tag [
	^ #ipfsWikiPage
]

{ #category : #visitor }
IpfsWikiLinkAnnotation >> accept: aVisitor [
	^ aVisitor visitIpfsWikiLinkAnnotation: self
]

{ #category : #'private - actions' }
IpfsWikiLinkAnnotation >> browseReferenceFrom: anEvent [
	anEvent modifiers isShift ifTrue: [ ^ self ].
	self isInWiki ifFalse: [ self inform: 'Wiki link not in a Wiki' ].
	self isPageDefined ifFalse: [ self createReferencedPage ].
	anEvent target fireEvent: (GtPhlowObjectToSpawn new 
		object: self referencedPage;
		sourceElement: anEvent target)
]

{ #category : #'accessing - parameter values' }
IpfsWikiLinkAnnotation >> createReferencedPage [
	^ referencedPage ifNil: [ referencedPage := self utility 
		valueOf: self constants nameParameterName
		in: self parameters
		value: [ :aValue |
					self isInWiki
						ifTrue: [ self gtDocument storage document wiki
											createOrRetrievePageNamed: aValue asSymbol ]
						ifFalse: [ nil ] ]
		emptyValue: [ nil ] 
		defaultValue: [ nil ] ]
]

{ #category : #'api - style' }
IpfsWikiLinkAnnotation >> cursorLeftInText: aBlRope [
	"This is called when the cursor moves into the markup, but it's not clear what good it does.
	 Leaving it out doesn't seem to make any difference."
	self utility hideAllButLinkInText: aBlRope forAnnotation: self
]

{ #category : #'accessing - parameter values' }
IpfsWikiLinkAnnotation >> defaultShowSelector [
	^ #gtDocumentFor:
]

{ #category : #testing }
IpfsWikiLinkAnnotation >> doesReferenceExist [
	"If the annotation is on a Wiki page, the reference is always considered existing,
	 since missing pages are created automatically when the link is followed."
	^ self isInWiki
]

{ #category : #testing }
IpfsWikiLinkAnnotation >> isInWiki [
	"The annotation can be used in any Pillar document, but is effective only in a Wiki."
	| storage |
	storage := self gtDocument storage.
	[ ^ storage isWikiPage ]
	on: MessageNotUnderstood do: [ ^ false ]
]

{ #category : #testing }
IpfsWikiLinkAnnotation >> isPageDefined [
	"Check if the page already exists in the Wiki."
	^ self referencedPage notNil
]

{ #category : #testing }
IpfsWikiLinkAnnotation >> isPreviewDefined [
	"Return true if a preview object is defined"
	^ self isPageDefined
]

{ #category : #accessing }
IpfsWikiLinkAnnotation >> objectToPreview [
	"Subclasses should define what object to preview"
	^ self referencedPage
]

{ #category : #accessing }
IpfsWikiLinkAnnotation >> referenceParameterName [
	"Return an annotation parameter name that holds a referenced object"
	^ self constants nameParameterName
]

{ #category : #'accessing - parameter values' }
IpfsWikiLinkAnnotation >> referencedPage [
	^ referencedPage ifNil: [ referencedPage := self utility 
		valueOf: self constants nameParameterName
		in: self parameters 
		value: [ :aValue |
					self isInWiki
						ifTrue: [ self gtDocument storage document wiki pageNamed: aValue asSymbol ]
						ifFalse: [ nil ] ] 
		emptyValue: [ nil ] 
		defaultValue: [ nil ] ]
]

{ #category : #'private - styling' }
IpfsWikiLinkAnnotation >> styleLinkInText: aBlRope [
	| aNodeToStyle linkColor attributes |
	linkColor := self utility linkColor: self isPageDefined.
	attributes := Array
						"Change the color of the link text"
						with: (BlTextForegroundAttribute new paint: linkColor)
						"Underline it in the same color when the cursor hovers over it"
						with: (BrTextHoverStylableAttribute new
									attribute: (BlTextUnderlineAttribute new paint: linkColor))
						"Define the click action"
						with: (BrTextClickAttribute new
									beNotOverwritableByStyler;
									action: [ :text :target :editor :event | 
												self browseReferenceFrom: event ]).

	aNodeToStyle := self utility linkNodeForAnnotation: self.
	(aBlRope  
		from: aNodeToStyle start 
		to: (aNodeToStyle start max: aNodeToStyle stop))
			attributes: attributes.

]

{ #category : #'api - style' }
IpfsWikiLinkAnnotation >> styleTextWithMarkup: aBlRope [
	"First render the annotation without any particularities."
	super styleTextWithMarkup: aBlRope.
	"Then add styling to the page name, turning it into a link."
	self styleLinkInText: aBlRope.
	"Add the button representing the link."
	(self nodeStyler: aBlRope)
		name: (self parameters at: self constants nameParameterName);
		spawnObject: [ self createReferencedPage ];
		linkButton.
	"Next, add the small triangle that opens the preview."
	self styleExpandingPreviewInText: aBlRope.
]

{ #category : #'api - style' }
IpfsWikiLinkAnnotation >> styleTextWithoutMarkup: aBlRope [
	"First render the full text with markup."
	self styleTextWithMarkup: aBlRope.
	"Then hide the markup."
	super styleTextWithoutMarkup: aBlRope.
	"Make the whole annotation disappear if the cursor is far away."
	(self nodeStyler: aBlRope) autoHideNode.

]
