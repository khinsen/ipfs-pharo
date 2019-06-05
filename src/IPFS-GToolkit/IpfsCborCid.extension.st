Extension { #name : #IpfsCborCid }

{ #category : #'*IPFS-GToolkit' }
IpfsCborCid >> gtActionInspectObjectFor: anAction [
	<gtAction>
	^ anAction button
			icon: BrGlamorousIcons fromhere;
			priority: 30;
			action:
				[ :aButton |
					aButton fireEvent: (GtPhlowObjectToSpawn new
					object: self loadObject;
					sourceElement: aButton) ].
]

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
