Class {
	#name : #IpfsMapper,
	#superclass : #Object,
	#instVars : [
		'encoders',
		'decoders'
	],
	#category : #'IPFS-2 - Linked data'
}

{ #category : #decoding }
IpfsMapper >> decode: jsonObject [
	"Pharo objects are encoded as JSON maps with a single entry. The key of that entry determines
	the decoder method that is used."
	jsonObject size = 1
		ifTrue: [ | tag |
					tag := jsonObject associations first key.
					decoders at: tag ifPresent: [ :aBlock | ^ aBlock value: (jsonObject at: tag) ] ].
	"Any JSON object with more than one entry becomes a dictionary-like object."
	^ jsonObject collect: [ :each | each decodeFromIpfsUsing: self ]
]

{ #category : #mapping }
IpfsMapper >> decodeTag: aSymbol as: aBlock [
	decoders at: aSymbol put: aBlock
]

{ #category : #encoding }
IpfsMapper >> encode: anObject [
	| class |
	class := anObject class.
	[ class ] whileNotNil:
		[	encoders at: class ifPresent: [ :aBlock | ^ aBlock value: anObject ].
			class := class superclass ].
	self error: 'No mapping for class ', anObject className
]

{ #category : #mapping }
IpfsMapper >> encodeClass: aClass as: aBlock [
	encoders at: aClass put: aBlock
]

{ #category : #initialization }
IpfsMapper >> initialize [
	encoders := Dictionary new.
	decoders := Dictionary new.
	self mappingForSequenceableCollection.
	self mappingForNeoJSONObject.
]

{ #category : #mapping }
IpfsMapper >> mappingForNeoJSONObject [
	self encodeClass: NeoJSONObject as:
		[ :aJsonObject | aJsonObject collect: [ :each | each encodeForIpfsUsing: self ] ]
]

{ #category : #mapping }
IpfsMapper >> mappingForSequenceableCollection [
	self encodeClass: SequenceableCollection as:
		[ :aCollection | aCollection collect: [ :each | each encodeForIpfsUsing: self ] ]
]
