"
!Parser for varints as used in Multiformats

Varint is a variable-length encoding of arbitrary-size unsigned integers.
For the details, see the *specification>https://github.com/multiformats/unsigned-varint*.

"
Class {
	#name : #MultiformatsVarIntParser,
	#superclass : #Object,
	#instVars : [
		'maxNumberOfBytes'
	],
	#category : #'Multiformats-Core'
}

{ #category : #parsing }
MultiformatsVarIntParser >> fromByteStream: aStream [
	| value shift byte count |
	value := 0.
	shift := 0.
	count := 0.
	[	byte := aStream next.
		count := count + 1.
		self assert: count <= maxNumberOfBytes description: 'Maximum VarInt size exceeded'.
		value := value + ((byte bitAnd: 16r7f) bitShift: shift).
		shift := shift + 7.
		byte allMask: 16r80 ] whileTrue.
	^ value
]

{ #category : #initialization }
MultiformatsVarIntParser >> initialize [
	maxNumberOfBytes := 9
]

{ #category : #accessing }
MultiformatsVarIntParser >> maxNumberOfBytes: anInteger [
	maxNumberOfBytes := anInteger min: 9
]
