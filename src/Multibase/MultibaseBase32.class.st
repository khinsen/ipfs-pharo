Class {
	#name : #MultibaseBase32,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase32 >> bitsPerDigit [
	^ 5
]

{ #category : #definition }
MultibaseBase32 >> code [
	^ $b
]

{ #category : #definition }
MultibaseBase32 >> digits [
	^ 'abcdefghijklmnopqrstuvwxyz234567'
]

{ #category : #definition }
MultibaseBase32 >> name [
	^ #base32
]
