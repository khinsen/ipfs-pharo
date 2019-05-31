Extension { #name : #IpfsObjectCid }

{ #category : #'*IPFS-GToolkit' }
IpfsObjectCid >> gtDataFor: aView [
	<gtView>
	^ (self loadObject gtDataFor: aView)
		priority: -6;
		yourself.

]

{ #category : #'*IPFS-GToolkit' }
IpfsObjectCid >> gtLinksFor: aView [
	<gtView>
	^ (self loadObject gtLinksFor: aView)
		priority: -5;
		yourself.

]
