Class {
	#name : #IpfsFileSystemEntry,
	#superclass : #Object,
	#instVars : [
		'ipfsPath'
	],
	#category : #'IPFS-3 - Files'
}

{ #category : #'instance creation' }
IpfsFileSystemEntry class >> forIpfsPath: anIpfsPath [
	self assert: anIpfsPath isUnixfsPath.
	^ anIpfsPath isUnixfsDirectory
		ifTrue: [ IpfsFileSystemDirectory new ipfsPath: anIpfsPath ]
		ifFalse: [ IpfsFileSystemFile new ipfsPath: anIpfsPath ]
]

{ #category : #accessing }
IpfsFileSystemEntry >> basename [
	^ ipfsPath basename
]

{ #category : #accessing }
IpfsFileSystemEntry >> fileSize [
	^ ipfsPath unixfsNodeInfo at: #Size
]

{ #category : #acccessing }
IpfsFileSystemEntry >> forIpfsPath: anIpfsPath [
	ipfsPath := anIpfsPath
]

{ #category : #accessing }
IpfsFileSystemEntry >> ipfsPath: anIpfsPath [ 
	ipfsPath := anIpfsPath
]

{ #category : #testing }
IpfsFileSystemEntry >> isDirectory [
	self subclassResponsibility
]

{ #category : #testing }
IpfsFileSystemEntry >> isFile [
	self subclassResponsibility
]
