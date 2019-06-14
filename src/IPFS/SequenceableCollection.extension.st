Extension { #name : #SequenceableCollection }

{ #category : #'*IPFS' }
SequenceableCollection >> encodeForIpfs [
	^ self collect: [ :each | each encodeForIpfs ]
]
