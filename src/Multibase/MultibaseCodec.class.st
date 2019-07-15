Class {
	#name : #MultibaseCodec,
	#superclass : #Object,
	#instVars : [
		'base'
	],
	#category : #'Multibase-Codecs'
}

{ #category : #accessing }
MultibaseCodec class >> forCode: aCharacter [
	^ (self subclasses
		detect: [ :codec | codec new code = aCharacter ]
		ifNone: [ MultibaseEncodingError signal: 'No codec for code $', aCharacter ])
		new.
]

{ #category : #definition }
MultibaseCodec >> code [
	"The code of the base as defined by the multibase standard.
	It is prefixed to every encoded value to make it self-describing."
	self subclassResponsibility
]

{ #category : #decoding }
MultibaseCodec >> decode: aString [
	| intValue numberOfBytes bytes |
	intValue := self decodeToInteger: aString.
	numberOfBytes := intValue numberOfDigitsInBase: 256.
	bytes := ByteArray new: numberOfBytes.
	numberOfBytes to: 1 by: -1 do:
		[ :i |
			bytes at: i put: (intValue bitAnd: 255).
			intValue := intValue bitShift: -8 ].
	^ bytes
]

{ #category : #decoding }
MultibaseCodec >> decodeBitwise: aString [
	| accumulator digitAsInt |
	accumulator := 0.
	^ ByteArray << [ :stream |
		aString do: [ :digit |
			digitAsInt := self digits indexOf: digit.
			digitAsInt = 0 ifTrue:
				[ MultibaseEncodingError signal:
					'invalid digit ', digit asString, ' in base ', base asString ].
			accumulator := base * accumulator + (digitAsInt - 1).
			accumulator > 65535 "2**16 - 1"
				ifTrue: [ nil ]
			 ]
		 ]
]

{ #category : #decoding }
MultibaseCodec >> decodeToInteger: aString [
	| integerValue |
	integerValue := aString inject: 0 into:
		[ :int :digit |
			| digitAsInt |
			digitAsInt := self digits indexOf: digit.
			digitAsInt = 0 ifTrue:
				[ MultibaseEncodingError signal:
					'invalid digit ', digit asString, ' in base ', base asString ].
			base * int + (digitAsInt-1) ].
	^ integerValue
]

{ #category : #definition }
MultibaseCodec >> digits [
	self subclassResponsibility
]

{ #category : #encoding }
MultibaseCodec >> encode: aByteArray [
	self subclassResponsibility
]

{ #category : #initialization }
MultibaseCodec >> initialize [
	super initialize.
	base := self digits size.
]

{ #category : #definition }
MultibaseCodec >> name [
	"The name of the base as defined by the multibase standard"
	self subclassResponsibility
]
