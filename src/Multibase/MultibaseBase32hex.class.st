Class {
	#name : #MultibaseBase32hex,
	#superclass : #MultibaseBase32,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase32hex >> alphabet [
	^ '0123456789abcdefghijklmnopqrstuv'
]

{ #category : #definition }
MultibaseBase32hex >> code [
	^ $v
]

{ #category : #definition }
MultibaseBase32hex >> name [
	^ #base32hex
]
