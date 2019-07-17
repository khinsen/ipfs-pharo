Class {
	#name : #MultibaseBase58flickr,
	#superclass : #MultibaseBase58btc,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase58flickr >> alphabet [
	^ '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ'
]

{ #category : #definition }
MultibaseBase58flickr >> code [
	^ $Z
]

{ #category : #definition }
MultibaseBase58flickr >> name [
	^ #base58flickr
]
