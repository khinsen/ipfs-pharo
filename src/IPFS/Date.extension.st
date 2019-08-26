Extension { #name : #Date }

{ #category : #'*IPFS' }
Date >> encodeForIpfs [
	^ NeoJSONObject with: #Date -> self yyyymmdd
]
