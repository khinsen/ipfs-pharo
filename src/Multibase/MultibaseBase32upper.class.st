Class {
	#name : #MultibaseBase32upper,
	#superclass : #MultibaseBase32,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase32upper >> alphabet [
	^ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'
]

{ #category : #definition }
MultibaseBase32upper >> code [
	^ $B
]

{ #category : #definition }
MultibaseBase32upper >> name [
	^ #base32upper
]
