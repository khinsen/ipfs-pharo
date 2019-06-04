Extension { #name : #IpfsGenericCid }

{ #category : #'*IPFS-GToolkit' }
IpfsGenericCid >> gtDataFor: aView [
	<gtView>
	^ self defaultDataViewFor: aView.

]

{ #category : #'*IPFS-GToolkit' }
IpfsGenericCid >> gtReferencesFor: aView [
	<gtView>
	^ self defaultReferencesFor: aView
]
