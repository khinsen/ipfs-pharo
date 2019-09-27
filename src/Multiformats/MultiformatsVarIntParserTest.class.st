Class {
	#name : #MultiformatsVarIntParserTest,
	#superclass : #TestCase,
	#category : #'Multiformats-Tests'
}

{ #category : #testing }
MultiformatsVarIntParserTest >> testCustomLengthLimit [
	#(6 7 8 9 10 11) do:
	[ :each |
		| parser bytes |
		bytes := OrderedCollection new
			add: 16r80 withOccurrences: (each - 1);
			add: 1;
			yourself.
		parser := MultiformatsVarIntParser new maxNumberOfBytes: each.
		(each <= 9)
			ifTrue:
				[ self shouldnt: [parser fromByteStream: bytes readStream]
						 raise: Error ]
			ifFalse:
				[ self should: [parser fromByteStream: bytes readStream]
						 raise: Error ].
		parser := MultiformatsVarIntParser new maxNumberOfBytes: (each - 1).
		self should: [parser fromByteStream: bytes readStream]
			  raise: Error ]

]

{ #category : #testing }
MultiformatsVarIntParserTest >> testDefaultLengthLimit [
	| parser |
	parser := MultiformatsVarIntParser new.
	#(10 11 12) do:
	[ :each |
		| bytes |
		bytes := OrderedCollection new
			add: 16r80 withOccurrences: (each - 1);
			add: 1;
			yourself.
		self should: [parser fromByteStream: bytes readStream]
			  raise: Error ]

]

{ #category : #testing }
MultiformatsVarIntParserTest >> testParsing [
	| parser |
	parser := MultiformatsVarIntParser new.
	#(#(1      #[ 2r00000001 ])
	  #(127    #[ 2r01111111 ])
	  #(128    #[ 2r10000000 2r00000001 ])
	  #(255    #[ 2r11111111 2r00000001 ])
	  #(300    #[ 2r10101100 2r00000010 ])
	  #(16384  #[ 2r10000000 2r10000000 2r00000001 ])) do:
	[ :each |
		self assert: (parser fromByteStream: each second readStream)
			  equals: each first ]
]
