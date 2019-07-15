"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestMultibase,
	#superclass : #PackageManifest,
	#category : #'Multibase-Manifest'
}

{ #category : #'code-critics' }
ManifestMultibase class >> ruleRBStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGPackage #(#Multibase)) #'2019-07-15T20:56:13.531732+02:00') )
]
