Extension { #name : #Time }

{ #category : #'*IPFS' }
Time >> encodeForIpfs [
	^ NeoJSONObject with: #Time -> self asString
]
