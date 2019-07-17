"
!A *multibase>https://github.com/multiformats/multibase* encoder and decoder

"
Class {
	#name : #MultibaseEncoder,
	#superclass : #Object,
	#category : #'Multibase-Base'
}

{ #category : #decoding }
MultibaseEncoder >> decode: aString [
	| codec |
	codec := MultibaseCodec forCode: aString first.
	^ codec decode: aString allButFirst
]

{ #category : #decoding }
MultibaseEncoder >> decodeToInteger: aString [
	| codec |
	codec := MultibaseCodec forCode: aString first.
	^ codec decodeToInteger: aString allButFirst
]

{ #category : #encoding }
MultibaseEncoder >> encode: aByteArray [

]

{ #category : #encoding }
MultibaseEncoder >> encode: aByteArray base: aSymbol [
	| codec |
	codec := MultibaseCodec forBase: aSymbol.
	^ codec code asString, (codec encode: aByteArray)
]
