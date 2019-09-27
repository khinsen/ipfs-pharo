"
! Parser for varints as used in Multiformats

https://github.com/multiformats/unsigned-varint

Practical maximum of 9 bytes (for security)

For security, to avoid memory attacks, we use a ""practical max"" of 9 bytes. Though there is no theoretical limit, and future specs can grow this number if it is truly necessary to have code or length values equal to or larger than 2^63.

For the forseeable future:

    Implementations MUST restrict the size of the varint to a max of 9 bytes (63 bits).
    A multiformat spec MAY explicitly declare a smaller maximum when using varints.
    A multiformat spec MAY NOT explicitly declare a larger maximum when using varints without first changing this spec.


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
