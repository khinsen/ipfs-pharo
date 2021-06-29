Class {
	#name : #BaselineOfIPFSForGToolkit,
	#superclass : #BaselineOf,
	#category : #BaselineOfIPFSForGToolkit
}

{ #category : #baseline }
BaselineOfIPFSForGToolkit >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
		spec
			baseline: 'SingletonTrait'
			with: [ spec repository: 'github://khinsen/SingletonTrait' ].
		spec
			baseline: 'WikiForGToolkit'
			with: [ spec repository: 'github://khinsen/WikiForGToolkit' ].

		spec
			package: 'Multiformats';
			package: 'Multibase';
			package: 'IPFS'
				with: [ spec requires: #('SingletonTrait' 'NeoJSON' 'Multibase' 'Multiformats') ];
			package: 'IPFS-GToolkit'
				with: [ spec requires: #('IPFS' 'WikiForGToolkit') ].

		spec
			group: 'default' with: #('IPFS-GToolkit').

]

]
