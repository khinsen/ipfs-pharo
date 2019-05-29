Class {
	#name : #BaselineOfIPFSExploration,
	#superclass : #BaselineOf,
	#category : #BaselineOfIPFSExploration
}

{ #category : #baseline }
BaselineOfIPFSExploration >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
		spec
			baseline: 'SingletonTrait'
			with: [ spec repository: 'github://khinsen/SingletonTrait' ].

		spec
			package: 'IPFSExploration'
				with: [ spec requires: #('NeoJSON') ];
			package: 'BaselineOfIPFSExploration'.

]

]
