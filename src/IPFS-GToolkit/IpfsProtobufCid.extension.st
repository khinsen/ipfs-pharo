Extension { #name : #IpfsProtobufCid }

{ #category : #'*IPFS-GToolkit' }
IpfsProtobufCid >> gtDataFor: aView [
	<gtView>
	^ (self loadObject gtDataFor: aView)
		priority: -6;
		yourself.

]

{ #category : #'*IPFS-GToolkit' }
IpfsProtobufCid >> gtLinksFor: aView [
	<gtView>
	^ (self loadObject gtLinksFor: aView)
		priority: -5;
		yourself.

]
