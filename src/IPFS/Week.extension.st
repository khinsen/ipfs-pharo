Extension { #name : #Week }

{ #category : #'*IPFS' }
Week class >> year: aYear isoWeek: weekNumber [
	"Return the ISO week for the given week number and the given year. Note that year:week: does not
	fully respect the ISO definition because it returns a week starting on a Sunday. ISO 8601
	specifies that weeks start on a Monday."
	"Note: we have to call starting:duration: from the superclass Timespan to make this work.
	 The Week class tries hard to enforce weeks starting on Sunday."
	^ super starting: aYear asYear correctFirstThursday + (weekNumber * 7 - 10) days duration: 1 week
]
