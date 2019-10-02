Extension { #name : #Year }

{ #category : #'*IPFS' }
Year >> correctFirstThursday [
	"Return the year's first Thursday.
	This is a corrected version of Year>>#firstThursday in Pharo 7, which contains a bug
	(fixed in Pharo 8).
	According to the ISO 8601 definition, the first week starts with the year's first Thursday (week day number 5)"
	^ self start + ((5 - self start dayOfWeek + 7) rem: 7) days
]
