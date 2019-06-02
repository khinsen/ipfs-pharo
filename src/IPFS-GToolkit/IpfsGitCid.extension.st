Extension { #name : #IpfsGitCid }

{ #category : #'*IPFS-GToolkit' }
IpfsGitCid >> gtDataFor: aView [
	<gtView>
	^ self defaultDataViewFor: aView.

]

{ #category : #'*IPFS-GToolkit' }
IpfsGitCid >> gtReferencesFor: aView [
	<gtView>
	^ self defaultReferencesFor: aView
]
