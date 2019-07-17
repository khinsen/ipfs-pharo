Class {
	#name : #MultibaseBase64,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase64 >> alphabet [
	^ 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
]

{ #category : #definition }
MultibaseBase64 >> bitsPerDigit [
	^ 6
]

{ #category : #definition }
MultibaseBase64 >> code [
	^ $m
]

{ #category : #decoding }
MultibaseBase64 >> decode: aString [
	^ self decode: aString bitsPerDigit: self bitsPerDigit
]

{ #category : #definition }
MultibaseBase64 >> name [
	^ #base64
]
