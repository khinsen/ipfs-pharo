Class {
	#name : #MultibaseBase10,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase10 >> bitsPerDigit [
	^ nil
]

{ #category : #definition }
MultibaseBase10 >> code [
	^ $9
]

{ #category : #decoding }
MultibaseBase10 >> decode: aString [
	| withoutLeadingZeros numberOfLeadingZeros intValue numberOfBytes bytes |
	withoutLeadingZeros := aString trimLeft: [ :char | char = $0 ].
	numberOfLeadingZeros := aString size - withoutLeadingZeros size.
	intValue := self decodeToInteger: withoutLeadingZeros.
	numberOfBytes := numberOfLeadingZeros + intValue numberOfDigits.
	bytes := intValue asByteArray.
	^ (ByteArray new: numberOfLeadingZeros), bytes
]

{ #category : #definition }
MultibaseBase10 >> digits [
	^ '0123456789'
]

{ #category : #definition }
MultibaseBase10 >> name [
	^ #base10
]
