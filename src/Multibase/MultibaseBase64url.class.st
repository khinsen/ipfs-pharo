Class {
	#name : #MultibaseBase64url,
	#superclass : #MultibaseBase64,
	#category : #'Multibase-Codecs'
}

{ #category : #definition }
MultibaseBase64url >> alphabet [
	^ 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
]

{ #category : #definition }
MultibaseBase64url >> code [
	^ $u
]

{ #category : #definition }
MultibaseBase64url >> name [
	^ #base64url
]
