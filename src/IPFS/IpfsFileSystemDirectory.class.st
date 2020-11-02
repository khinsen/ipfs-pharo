Class {
	#name : #IpfsFileSystemDirectory,
	#superclass : #IpfsFileSystemEntry,
	#instVars : [
		'entries'
	],
	#category : #'IPFS-3 - Files'
}

{ #category : #enumeration }
IpfsFileSystemDirectory >> fileEntriesDo: aBlock [
	entries do: [ :each | aBlock value: each ]
]

{ #category : #accessing }
IpfsFileSystemDirectory >> fileEntryAt: aString ifAbsent: aBlock [
	^ entries at: aString ifAbsent: [ aBlock value ]
]

{ #category : #initialization }
IpfsFileSystemDirectory >> initialize [
	entries := Dictionary new
]

{ #category : #accessing }
IpfsFileSystemDirectory >> ipfsPath: anIpfsPath [
	super ipfsPath: anIpfsPath.
	entries := Dictionary new.
	anIpfsPath unixfsDirectoryEntries do: [ :each |
		| name |
		name := each at: #Name.
		entries at: name put: (IpfsFileSystemEntry forIpfsPath: anIpfsPath / name) ]
]

{ #category : #testing }
IpfsFileSystemDirectory >> isDirectory [
	^ true
]

{ #category : #testing }
IpfsFileSystemDirectory >> isFile [
	^ false
]
