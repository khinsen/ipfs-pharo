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
			package: 'Multiformats';
			package: 'Multibase';
			package: 'IPFS'
				with: [ spec requires: #('SingletonTrait' 'NeoJSON' 'Multibase' 'Multiformats') ];
			package: 'IPFS-GToolkit'.

		spec
			group: 'default' with: #('IPFS');
			group: 'All' with: #('IPFS-GToolkit').

]

]
