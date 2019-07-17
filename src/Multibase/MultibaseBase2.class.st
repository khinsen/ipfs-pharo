Class {
	#name : #MultibaseBase2,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase2 >> alphabet [
	^ '01'
]

{ #category : #definition }
MultibaseBase2 >> bitsPerDigit [
	^ 1
]

{ #category : #definition }
MultibaseBase2 >> code [
	^ $0
]

{ #category : #decoding }
MultibaseBase2 >> decode: aString [
	^ self decode: aString bitsPerDigit: self bitsPerDigit
]

{ #category : #encoding }
MultibaseBase2 >> encode: aByteArray [
	^ self encode: aByteArray bitsPerDigit: self bitsPerDigit
]

{ #category : #definition }
MultibaseBase2 >> name [
	^ #base2
]
