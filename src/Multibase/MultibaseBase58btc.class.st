Class {
	#name : #MultibaseBase58btc,
	#superclass : #MultibaseCodec,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase58btc >> alphabet [
	^ '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
]

{ #category : #definition }
MultibaseBase58btc >> bitsPerDigit [
	^ nil
]

{ #category : #definition }
MultibaseBase58btc >> code [
	^ $z
]

{ #category : #decoding }
MultibaseBase58btc >> decode: aString [
	^ self decodeWithLeadingZeros: aString
]

{ #category : #encoding }
MultibaseBase58btc >> encode: aByteArray [
	^ self encodeWithLeadingZeros: aByteArray
]

{ #category : #definition }
MultibaseBase58btc >> name [
	^ #base58btc
]
