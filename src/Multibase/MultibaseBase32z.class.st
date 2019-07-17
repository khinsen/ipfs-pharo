Class {
	#name : #MultibaseBase32z,
	#superclass : #MultibaseBase32,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase32z >> alphabet [
	^ 'ybndrfg8ejkmcpqxot1uwisza345h769'
]

{ #category : #definition }
MultibaseBase32z >> code [
	^ $h
]

{ #category : #definition }
MultibaseBase32z >> name [
	^ #base32z
]
