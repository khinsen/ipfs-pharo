Extension { #name : #Dictionary }

{ #category : #'*IPFS' }
Dictionary >> encodeForIpfs [
	^ NeoJSONObject with: #Dictionary ->
		(self associations collect:
			[ :each | { each key encodeForIpfs. each value encodeForIpfs } ])
]
