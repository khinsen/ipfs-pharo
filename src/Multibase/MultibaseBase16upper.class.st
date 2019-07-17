Class {
	#name : #MultibaseBase16upper,
	#superclass : #MultibaseBase16,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase16upper >> alphabet [
	^ '0123456789ABCDEF'
]

{ #category : #definition }
MultibaseBase16upper >> code [
	^ $F
]

{ #category : #definition }
MultibaseBase16upper >> name [
	^ #base16upper
]
