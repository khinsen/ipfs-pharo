Class {
	#name : #MultibaseBase10,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase10 >> code [
	^ $9
]

{ #category : #definition }
MultibaseBase10 >> digits [
	^ '0123456789'
]

{ #category : #definition }
MultibaseBase10 >> name [
	^ #base10
]
