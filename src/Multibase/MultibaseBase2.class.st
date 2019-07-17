Class {
	#name : #MultibaseBase2,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase2 >> bitsPerDigit [
	^ 1
]

{ #category : #definition }
MultibaseBase2 >> code [
	^ $0
]

{ #category : #definition }
MultibaseBase2 >> digits [
	^ '01'
]

{ #category : #definition }
MultibaseBase2 >> name [
	^ #base2
]
