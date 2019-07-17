Class {
	#name : #MultibaseBase16,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase16 >> alphabet [
	^ '0123456789abcdef'
]

{ #category : #definition }
MultibaseBase16 >> bitsPerDigit [
	^ 4
]

{ #category : #definition }
MultibaseBase16 >> code [
	^ $f
]

{ #category : #decoding }
MultibaseBase16 >> decode: aString [
	^ self decode: aString bitsPerDigit: self bitsPerDigit
]

{ #category : #encoding }
MultibaseBase16 >> encode: aByteArray [
	^ self encode: aByteArray bitsPerDigit: self bitsPerDigit
]

{ #category : #definition }
MultibaseBase16 >> name [
	^ #base16
]
