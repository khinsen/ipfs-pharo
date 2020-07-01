Class {
	#name : #IpfsWikiLinkRenamer,
	#superclass : #PRNodeTransformer,
	#instVars : [
		'nameTransformation',
		'hasModifiedDoc'
	],
	#category : #'IPFS-GToolkit-Visitor'
}

{ #category : #accessing }
IpfsWikiLinkRenamer >> hasModifiedDoc [
	^ hasModifiedDoc
]

{ #category : #initialization }
IpfsWikiLinkRenamer >> initialize [
	super initialize.
	hasModifiedDoc := false.
]

{ #category : #accessing }
IpfsWikiLinkRenamer >> nameTransformation: aDictionary [
	nameTransformation := aDictionary
]

{ #category : #'visiting-annotations' }
IpfsWikiLinkRenamer >> visitIpfsWikiLinkAnnotation: anIpfsWikiLinkAnnotation [
	| name newName |
	name := anIpfsWikiLinkAnnotation parameters at: #name.
	newName := nameTransformation at: name ifAbsent: [ name ].
	newName = name ifFalse: [ anIpfsWikiLinkAnnotation parameterAt: #name put: newName ].
]
