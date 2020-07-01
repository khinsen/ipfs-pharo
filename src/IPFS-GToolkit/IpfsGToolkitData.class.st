"
!Data for the IPFS-GToolkit package
"
Class {
	#name : #IpfsGToolkitData,
	#superclass : #IpfsWorkspace,
	#category : #'IPFS-GToolkit'
}

{ #category : #data }
IpfsGToolkitData >> loadTutorial [
   data at: #Tutorial put: (IpfsCid fromString: 'bafyreia3crlpfkb7s6czd3aiwji4letnzp3patfthv6h26vaxkuasogaey') loadObject
]
