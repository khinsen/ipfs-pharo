"
!The default mapper for storing Pharo objects in IPFS

See ${class:name=IpfsMapper}$ for documentation.
"
Class {
	#name : #IpfsDefaultMapper,
	#superclass : #IpfsMapper,
	#classInstVars : [
		'defaultInstance'
	],
	#category : #'IPFS-2 - Linked data'
}

{ #category : #default }
IpfsDefaultMapper class >> default [
	^ defaultInstance ifNil: [ defaultInstance := self new ]
]

{ #category : #default }
IpfsDefaultMapper class >> reset [
	<script>
	defaultInstance := nil.
]

{ #category : #initialization }
IpfsDefaultMapper >> initialize [
	super initialize.
	self class methods select: [ :each | each selector beginsWith: 'mappingFor' ] thenDo:
		[ :each | each valueWithReceiver: self arguments: Array new ].
]

{ #category : #mapping }
IpfsDefaultMapper >> mappingForDate [
	self encodeClass: Date as:
		[ :aDate | NeoJSONObject with: #Date -> aDate yyyymmdd ].
	self decodeTag: #Date as:
		[ :aString | Date fromString: aString ].
]

{ #category : #mapping }
IpfsDefaultMapper >> mappingForDateAndTime [
	self encodeClass: DateAndTime as:
		[ :aDateAndTime | NeoJSONObject with: #DateAndTime -> aDateAndTime asString ].
	self decodeTag: #DateAndTime as:
		[ :aString | DateAndTime fromString: aString ].
]

{ #category : #mapping }
IpfsDefaultMapper >> mappingForDictionary [
	self encodeClass: Dictionary as:
		[ :dictionary |
			NeoJSONObject with: #Dictionary ->
				(dictionary associations collect:
					[ :each | { each key encodeForIpfsUsing: self.
									each value encodeForIpfsUsing: self } ]) ].

	self decodeTag: #Dictionary as:
		[ :aListOfPairs |
			| decodedDictionary |
			decodedDictionary := Dictionary new.
			aListOfPairs do:
				[ :each | decodedDictionary at: ((each first decodeFromIpfsUsing: self))
													put: (each second decodeFromIpfsUsing: self) ].
			decodedDictionary ].
]

{ #category : #mapping }
IpfsDefaultMapper >> mappingForTime [
	self encodeClass: Time as:
		[ :aTime |
			NeoJSONObject with:
				#Time -> (String new: 15 streamContents:
					[ :aStream | (aTime print24: true showSeconds: true on: aStream)]) ].
	self decodeTag: #Time as:
		[ :aString | Time fromString: aString ].
]

{ #category : #mapping }
IpfsDefaultMapper >> mappingForWeek [
	self encodeClass: Week as:
		[ :aWeek |
			| thursday year weekNumber |
			self assert: aWeek start dayOfWeekName equals: #Monday.
			"The year is the Gregorian year of the Thursday."
			thursday := aWeek start + 3 days.
			year := thursday year.
			weekNumber := (thursday - (Year year: year) correctFirstThursday) asDays // 7 + 1.
			NeoJSONObject with:
				#Week -> ((year printPaddedWith: $0 to: 4),
							'-W', (weekNumber printPaddedWith: $0 to: 2)) ].
	self decodeTag: #Week as:
		[ :aString |
			| parts year weekNumber |
			parts := $- split: aString.
			year := parts first asNumber.
			weekNumber := parts second allButFirst asNumber.
			Week year: year isoWeek: weekNumber ].
]

{ #category : #mapping }
IpfsDefaultMapper >> mappingForYear [
	self encodeClass: Year as: [ :aYear | NeoJSONObject with: #Year -> aYear year ].
	self decodeTag: #Year as: [ :anInteger | Year year: anInteger ].
]
