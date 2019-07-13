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
   data at: #Tutorial put: (IpfsCid fromString: 'bafyreihgkmbe7jlaxoo4yd7ivvk3jk7wokaambrvrxdfrssjagmc6eytq4') loadObject
]
