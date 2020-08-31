"
!Data for the IPFS-GToolkit package
"
Class {
	#name : #IpfsGToolkitData,
	#superclass : #IpfsWorkspace,
	#category : #'IPFS-GToolkit'
}

{ #category : #data }
IpfsGToolkitData >> loadDocumentation [
   data at: #Documentation put: (IpfsCid fromString: 'bafyreicmlmxbjjbd2oj2hdnl4wfbu6tz7eghithszvpquxjfmgkubrw2ke') loadObject
]
