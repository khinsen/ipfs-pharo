"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestIPFS,
	#superclass : #PackageManifest,
	#category : #'IPFS-Manifest'
}

{ #category : #'code-critics' }
ManifestIPFS class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#NeoJSONObject #asPharoObject #false)) #'2019-07-12T20:27:50.774051+02:00') )
]
