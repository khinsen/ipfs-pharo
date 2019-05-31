Class {
	#name : #BaselineOfIPFS,
	#superclass : #BaselineOf,
	#category : #BaselineOfIPFS
}

{ #category : #baseline }
BaselineOfIPFS >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
		spec
			baseline: 'SingletonTrait'
			with: [ spec repository: 'github://khinsen/SingletonTrait' ].
		spec
			baseline: 'GToolkit' 
			with: [ spec repository: 'github://feenkcom/gtoolkit/src' ].

		spec
			package: 'IPFS'
				with: [ spec requires: #('SingletonTrait' 'NeoJSON') ];
			package: 'IPFS-GToolkit'
				with: [ spec requires: #('IPFS' 'GToolkit') ];
			package: 'BaselineOfIPFS'.

		spec
			group: 'default' with: #('IPFS');
			group: 'All' with: #('IPFS-GToolkit').

]

]
