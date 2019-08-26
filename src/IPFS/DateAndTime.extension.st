Extension { #name : #DateAndTime }

{ #category : #'*IPFS' }
DateAndTime >> encodeForIpfs [
	^ NeoJSONObject
		with:
			#DateAndTime
				-> self asString
]
