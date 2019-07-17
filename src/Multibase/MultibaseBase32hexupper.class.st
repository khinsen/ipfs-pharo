Class {
	#name : #MultibaseBase32hexupper,
	#superclass : #MultibaseBase32,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase32hexupper >> alphabet [
	^ '0123456789ABCDEFGHIJKLMNOPQRSTUV'
]

{ #category : #definition }
MultibaseBase32hexupper >> code [
	^ $V
]

{ #category : #definition }
MultibaseBase32hexupper >> name [
	^ #base32hexupper
]
