Class {
	#name : #MultibaseBase16,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase16 >> code [
	^ $f
]

{ #category : #definition }
MultibaseBase16 >> digits [
	^ '0123456789abcdef'
]

{ #category : #definition }
MultibaseBase16 >> name [
	^ #base16
]
