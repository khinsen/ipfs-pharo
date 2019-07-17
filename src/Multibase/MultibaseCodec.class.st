"
!Encoding and decoding between byte arrays and encoded strings

The multibase convention defines how arbitrary byte sequences can be encoded as self-documenting strings using a variety of alphabets depending on specific requirements. The first letter of an encoded string defines the base of the encoding, the remaining character encode the contents. See *this table>https://github.com/multiformats/multibase/blob/master/multibase.csv* for the list of defined encodings. Note however that most implementations provide only a subset.

The general principle of the encodings is to consider the byte sequence as a big-endian unsigned integer. This integer is represented in a specific base, using a specific alphabet (i.e. set of digits). This leaves two details to be specified, on which the available documentation is not very clear:
# Leading zeros. The byte sequences [ 1 2 3 ] and [ 0 0 1 2 3 ] are obviously different, but describe the same integer value. The specific descriptions for *base2>https://github.com/multiformats/multibase/blob/master/rfcs/Base2.md* and *base10>https://github.com/multiformats/multibase/blob/master/rfcs/Base10.md* explain how to deal with this, but these rules are not generalizable to other bases.
# Extraneous bits. The byte sequence [ 1 2 3 ] requires 24 bits and thus, for example, 5 characters in base32 (where each character represents 5 bits). But those 5 characters stand for 25 bits. From the provided *test cases>https://github.com/multiformats/multibase/tree/master/tests*, it looks like the integer value of the byte sequence is shifted to the left (adding zero bits at the right) to make it occupy the required number of bits.
 

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
MultibaseCodec class >> forCode: aCharacter [
	^ (self subclasses
		detect: [ :codec | codec new code = aCharacter ]
		ifNone: [ MultibaseEncodingError signal: 'No codec for code $', aCharacter ])
		new.
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

{ #category : #decoding }
MultibaseCodec >> decode: aString [
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
MultibaseCodec >> decodeBitwise: aString [
	| accumulator digitAsInt |
	self flag: #broken.
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
