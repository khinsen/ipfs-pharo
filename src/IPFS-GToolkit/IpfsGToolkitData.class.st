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
   data at: #Tutorial put: (IpfsCid fromString: 'bafyreiebazgzsqera2fnsvmwfgv4saklaznrgutnawtxpae63b33o7ww54') loadObject
]
