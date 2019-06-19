Extension { #name : #Object }

{ #category : #'*IPFS' }
Object >> convertIpfsCids [
	^ self
]

{ #category : #'*IPFS' }
Object >> decodeFromIpfs [
	self subclassResponsibility
]

{ #category : #'*IPFS' }
Object >> decodeLinkedObjectsFromIpfs [
	^ self decodeFromIpfs
]

{ #category : #'*IPFS' }
Object >> encodeForIpfs [
	self subclassResponsibility 
]

{ #category : #'*IPFS' }
Object >> storeInIpfs [
	^ Ipfs dagPut: self encodeForIpfs
]
