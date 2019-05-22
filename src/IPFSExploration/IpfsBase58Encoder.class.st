Class {
	#name : #IpfsBase58Encoder,
	#superclass : #Object,
	#instVars : [
		'alphabet',
		'inverseAlphabet'
	],
	#category : #'IPFSExploration-Support'
}

{ #category : #private }
IpfsBase58Encoder >> byteCountFor: string [	
	| n byteCount |
	"This assumes there are no line breaks in string"
	n := string size.
	byteCount := n // 4 * 3.
	(n > 1 and: [ (string at: n) = $= ])
		ifTrue: [ 
			(n > 2 and: [ (string at: n - 1) = $= ])
				ifTrue: [ byteCount := byteCount - 2 ]
				ifFalse: [ byteCount := byteCount - 1 ] ].
	^ byteCount
]

{ #category : #converting }
IpfsBase58Encoder >> decode: string [
	^ ByteArray 
		new: (self byteCountFor: string)
		streamContents: [ :byteStream | 
			self decode: string readStream to: byteStream ]
]

{ #category : #initialization }
IpfsBase58Encoder >> initialize [
	alphabet := '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'.
	self assert: alphabet size equals: 58.
	inverseAlphabet := Array new: 128.
	0 to: 127 do: [ :each | 
		| offset |
		offset := alphabet indexOf: each asCharacter ifAbsent: [ nil ].
		inverseAlphabet at: each + 1 put: (offset ifNotNil: [ offset - 1 ]) ].
]
