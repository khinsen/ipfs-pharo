Class {
	#name : #MultibaseBase8,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase8 >> code [
	^ $7
]

{ #category : #definition }
MultibaseBase8 >> digits [
	^ '01234567'
]

{ #category : #definition }
MultibaseBase8 >> name [
	^ #base8
]
