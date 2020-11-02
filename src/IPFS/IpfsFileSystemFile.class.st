Class {
	#name : #IpfsFileSystemFile,
	#superclass : #IpfsFileSystemEntry,
	#category : #'IPFS-3 - Files'
}

{ #category : #testing }
IpfsFileSystemFile >> isDirectory [
	^ false
]

{ #category : #testing }
IpfsFileSystemFile >> isFile [
	^ true
]
