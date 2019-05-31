Extension { #name : #IpldRawCid }

{ #category : #'*IPFS-GToolkit' }
IpldRawCid >> gtDataFor: aView [
	<gtView>
	| view |
	view := self load ipldDataViewFor: aView.
	^ view
		title: 'Data';
		priority: -6;
		yourself.

]
