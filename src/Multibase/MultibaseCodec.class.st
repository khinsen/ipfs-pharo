"
!Encoding and decoding between byte arrays and encoded strings

The multibase convention defines how arbitrary byte sequences can be encoded as self-documenting strings using a variety of alphabets depending on specific requirements. The first letter of an encoded string defines the base of the encoding, the remaining character encode the contents. See *this table>https://github.com/multiformats/multibase/blob/master/multibase.csv* for the list of defined encodings. Note however that most implementations provide only a subset. This implementation supports the following encodings:
[[[
self allBases
]]]

The general principle of the encodings is to consider the byte sequence as a big-endian unsigned integer. This integer is represented in a specific base, using a specific alphabet (i.e. set of digits). This leaves two details to be specified, on which the available documentation is not very clear:
# Leading zeros. The byte sequences [ 1 2 3 ] and [ 0 0 1 2 3 ] are obviously different, but describe the same integer value. The specific descriptions for *base2>https://github.com/multiformats/multibase/blob/master/rfcs/Base2.md* and *base10>https://github.com/multiformats/multibase/blob/master/rfcs/Base10.md* explain how to deal with this. From the examples, it seems that the principle of leading zeros explained for base10 is more generally used for bases that are not a power of 2 (e.g. base58). It is implemented in ${method:name=MultibaseCodec>>#decodeWithLeadingZeros:}$. The approach explained for base2 can be generalized to bases that are a power of 2 and is implemented in ${method:name=MultibaseCodec>>#decode:bitsPerDigit:}$.
# Extraneous bits. The byte sequence [ 1 2 3 ] requires 24 bits and thus, for example, 5 characters in base32 (where each character represents 5 bits). But those 5 characters stand for 25 bits. From the provided *test cases>https://github.com/multiformats/multibase/tree/master/tests*, it looks like the integer value of the byte sequence is shifted to the left (adding zero bits at the right) to make it occupy the required number of bits. This is implemented in ${method:name=MultibaseCodec>>#decode:bitsPerDigit:}$.
 

"
Class {
	#name : #MultibaseCodec,
	#superclass : #Object,
	#instVars : [
		'base'
	],
	#category : #'Multibase-Codecs'
}

{ #category : #accessing }
MultibaseCodec class >> allBases [
	^ self allSubclasses
		collect: [ :codec | codec new name ]
]

{ #category : #accessing }
MultibaseCodec class >> forBase: aSymbol [
	^ (self allSubclasses
		detect: [ :codec | codec new name = aSymbol ]
		ifNone: [ MultibaseEncodingError signal: 'No codec for base $', aSymbol ])
		new.
]

{ #category : #accessing }
MultibaseCodec class >> forCode: aCharacter [
	^ (self allSubclasses
		detect: [ :codec | codec new code = aCharacter ]
		ifNone: [ MultibaseEncodingError signal: 'No codec for code $', aCharacter ])
		new.
]

{ #category : #definition }
MultibaseCodec >> alphabet [
	self subclassResponsibility
]

{ #category : #definition }
MultibaseCodec >> bitsPerDigit [
	self subclassResponsibility
]

{ #category : #definition }
MultibaseCodec >> code [
	"The code of the base as defined by the multibase standard.
	It is prefixed to every encoded value to make it self-describing."
	self subclassResponsibility
]

{ #category : #encoding }
MultibaseCodec >> decode: aString [
	self subclassResponsibility
]

{ #category : #decoding }
MultibaseCodec >> decode: aString bitsPerDigit: bpd [
	| intValue numberOfBytes bytes |
	numberOfBytes := aString size * bpd // 8.
	intValue :=
		(self decodeToInteger: aString)
			bitShift: ((aString size * bpd) \\ 8) negated.
	bytes := intValue asByteArray.
	^ (ByteArray new: numberOfBytes - bytes size), bytes
]

{ #category : #decoding }
MultibaseCodec >> decodeToInteger: aString [
	| integerValue |
	integerValue := aString inject: 0 into:
		[ :int :digit |
			| digitAsInt |
			digitAsInt := self alphabet indexOf: digit.
			digitAsInt = 0 ifTrue:
				[ MultibaseEncodingError signal:
					'invalid digit ', digit asString, ' in base ', base asString ].
			base * int + (digitAsInt-1) ].
	^ integerValue
]

{ #category : #decoding }
MultibaseCodec >> decodeWithBitsPerDigit: aString [
	| intValue numberOfBytes bytes |
	self bitsPerDigit ifNil:
		[ self error: 'Codec should define a specific decoder' ].
	numberOfBytes := aString size * self bitsPerDigit // 8.
	intValue :=
		(self decodeToInteger: aString)
			bitShift: ((aString size * self bitsPerDigit) \\ 8) negated.
	bytes := intValue asByteArray.
	^ (ByteArray new: numberOfBytes - bytes size), bytes
]

{ #category : #decoding }
MultibaseCodec >> decodeWithLeadingZeros: aString [
	| withoutLeadingZeros numberOfLeadingZeros intValue bytes |
	withoutLeadingZeros := aString trimLeft: [ :char | char = self alphabet first ].
	numberOfLeadingZeros := aString size - withoutLeadingZeros size.
	intValue := self decodeToInteger: withoutLeadingZeros.
	bytes := intValue asByteArray.
	^ (ByteArray new: numberOfLeadingZeros), bytes
]

{ #category : #encoding }
MultibaseCodec >> encode: aByteArray [
	self subclassResponsibility
]

{ #category : #encoding }
MultibaseCodec >> encode: aByteArray bitsPerDigit: bpd [
	| numberOfDigits intValue shift reversedEncoding leadingZeros |
	self assert: aByteArray isNotEmpty.
	numberOfDigits := ((aByteArray size * 8) + (bpd-1)) // bpd.
	shift := (numberOfDigits * bpd) - (aByteArray size * 8).
	self assert: shift >= 0.
	intValue := aByteArray asInteger bitShift: shift.
	reversedEncoding := String streamContents: [ :stream |
		self printReversed: intValue on: stream ].
	leadingZeros := self alphabet first asString
							repeat: (numberOfDigits - reversedEncoding size).
	^ leadingZeros, reversedEncoding reversed
]

{ #category : #encoding }
MultibaseCodec >> encodeWithLeadingZeros: aByteArray [
	| intValue reversedEncoding |
	self assert: aByteArray isNotEmpty.
	intValue := aByteArray asInteger.
	reversedEncoding := String streamContents: [ :stream |
		| index |
		self printReversed: intValue on: stream.
		index := 1.
		[ index < aByteArray size
				and: [ (aByteArray at: index) isZero ] ]
			whileTrue: [
				stream nextPut: self alphabet first.
				index := index + 1 ] ].
	^ reversedEncoding reversed
]

{ #category : #initialization }
MultibaseCodec >> initialize [
	super initialize.
	base := self alphabet size.
]

{ #category : #definition }
MultibaseCodec >> name [
	"The name of the base as defined by the multibase standard"
	self subclassResponsibility
]

{ #category : #encoding }
MultibaseCodec >> printReversed: anInteger on: aStream [
	| intValue quotient remainder |
	intValue := anInteger.
	[ intValue > 0 ] whileTrue: [
		quotient := intValue // base.
		remainder := intValue - (quotient * base).
		intValue := quotient.
		aStream nextPut: (self alphabet at: remainder + 1) ]

]
