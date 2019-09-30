"
!Mapper between Pharo objects and NeoJSONObjects

An IpfsMapper is required for storing arbitrary Pharo objects in IPFS (${method:name=Object>>#storeInIpfsUsing:}$), and for reconstructing these objects when loading data (${method:name=IpfsCid>>#loadObjectUsing:}$ and ${method:name=IpfsCid>>#loadLinkedObjectsUsing:}$)

The basic JSON data types (numbers, strings, null) are not always are not handled by the mapper. They always map to Pharo numbers, strings, and nil (${class:name=UndefinedObject}$).

Encoding is class-based. The encoder for a class returns a ${class:name=NeoJSONObject}$ with a single entry whose key is a class-specific tag (a ${class:name=Symbol}$) that identifies the decoder to be used upon loading. The value can be any JSON data.

Decoding is tag-based. NeoJSONObjects retrieved from IPFS are decoded only if they have exactly one entry, whose key must be a ${class:name=Symbol}$ used as a tag. The decoder for a tag receives the value (arbitrary JSON data) as its argument and constructs the decoded Pharo object from it.

The class ${class:name=IpfsDefaultMapper}$ defines a set of default mappings for frequently used Pharo objects. It can be extended by subclassing. Directly subclassing ${class:name=IpfsMapper}$ permits the definition of alternate encodings for the classes handled by the default mapper.

"
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
