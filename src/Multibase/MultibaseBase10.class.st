Class {
	#name : #MultibaseBase10,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase10 >> alphabet [
	^ '0123456789'
]

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
	^ self decodeWithLeadingZeros: aString
]

{ #category : #definition }
MultibaseBase10 >> name [
	^ #base10
]
