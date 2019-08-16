Extension { #name : #Dictionary }

{ #category : #'*IPFS' }
Dictionary >> asPharoObject [
	| objectType methodSelector |
	self assert: self size = 1
		  description: 'Pharo objects are encoded as dictionaries with a single item'.
	objectType := self associations first key.
	methodSelector := ('decode' , objectType , ':') asSymbol.
	(IpfsObjectDecoder respondsTo: methodSelector)
		ifFalse: [ ^ nil ].
	^ IpfsObjectDecoder
		perform: methodSelector
		with: (self at: objectType)
]

{ #category : #'*IPFS' }
Dictionary >> encodeForIpfs [
	^ NeoJSONObject with: #Dictionary ->
		(self associations collect:
			[ :each | { each key encodeForIpfs. each value encodeForIpfs } ])
]
