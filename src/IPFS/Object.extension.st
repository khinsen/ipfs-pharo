Extension { #name : #Object }

{ #category : #'*IPFS' }
Object >> convertIpfsCids [
	^ self
]

{ #category : #'*IPFS' }
Object >> decodeFromIpfsUsing: anIpfsMapper [
	self subclassResponsibility
]

{ #category : #'*IPFS' }
Object >> decodeLinkedObjectsFromIpfsUsing: anIpfsMapper [
	^ self decodeFromIpfsUsing: anIpfsMapper
]

{ #category : #'*IPFS' }
Object >> encodeForIpfsUsing: anIpfsMapper [
	^ anIpfsMapper encode: self
]

{ #category : #'*IPFS' }
Object >> resultOfIpfsRequest [
	^ self
]

{ #category : #'*IPFS' }
Object >> storeInIpfs [
	^ Ipfs dagPut: (self encodeForIpfsUsing: IpfsDefaultMapper default)
]

{ #category : #'*IPFS' }
Object >> storeInIpfsUsing: anIpfsMapper [
	^ Ipfs dagPut: (self encodeForIpfsUsing: anIpfsMapper)
]

{ #category : #'*IPFS' }
Object >> updateIpfsRequest [
	^ self
]

{ #category : #'*IPFS' }
Object >> waitForIpfsRequest [
	^ self
]
