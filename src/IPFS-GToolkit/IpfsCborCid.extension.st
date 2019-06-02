Extension { #name : #IpfsCborCid }

{ #category : #'*IPFS-GToolkit' }
IpfsCborCid >> gtDataFor: aView [
	<gtView>
	^ self defaultDataViewFor: aView.

]

{ #category : #'*IPFS-GToolkit' }
IpfsCborCid >> gtReferencesFor: aView [
	<gtView>
	^ self defaultReferencesFor: aView
]
