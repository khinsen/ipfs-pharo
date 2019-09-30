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
	data
		at: #Tutorial
		put:
			(IpfsCid
				fromString: 'bafyreicahbf33nelgm5fzyiffbdxd6z6vmi4btck5a335qwi3bwihefsni')
				loadObject
]
