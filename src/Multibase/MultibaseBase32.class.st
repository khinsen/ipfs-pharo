Class {
	#name : #MultibaseBase32,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase32 >> alphabet [
	^ 'abcdefghijklmnopqrstuvwxyz234567'
]

{ #category : #definition }
MultibaseBase32 >> bitsPerDigit [
	^ 5
]

{ #category : #definition }
MultibaseBase32 >> code [
	^ $b
]

{ #category : #decoding }
MultibaseBase32 >> decode: aString [
	^ self decode: aString bitsPerDigit: self bitsPerDigit
]

{ #category : #definition }
MultibaseBase32 >> name [
	^ #base32
]
