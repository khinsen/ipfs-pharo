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
			package: 'IPFSExploration';
			package: 'BaselineOfIPFSExploration'.

]

]
