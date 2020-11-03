Class {
	#name : #IpfsFileSystemDirectory,
	#superclass : #IpfsFileSystemEntry,
	#instVars : [
		'entries'
	],
	#category : #'IPFS-3 - Files'
}

{ #category : #private }
IpfsFileSystemDirectory >> ensureEntries [
	entries ifNil: [
		entries := Dictionary new.
		ipfsPath unixfsDirectoryEntries do: [ :each |
			| name |
			name := each at: #Name.
			entries at: name put: (IpfsFileSystemEntry forIpfsPath: ipfsPath / name) ] ].
	^ entries
]

{ #category : #enumeration }
IpfsFileSystemDirectory >> fileEntriesDo: aBlock [
	self ensureEntries do: [ :each | aBlock value: each ]
]

{ #category : #accessing }
IpfsFileSystemDirectory >> fileEntryAt: aString ifAbsent: aBlock [
	^ self ensureEntries at: aString ifAbsent: [ aBlock value ]
]

{ #category : #accessing }
IpfsFileSystemDirectory >> ipfsPath: anIpfsPath [
	super ipfsPath: anIpfsPath.
	entries := nil
]

{ #category : #testing }
IpfsFileSystemDirectory >> isDirectory [
	^ true
]

{ #category : #testing }
IpfsFileSystemDirectory >> isFile [
	^ false
]
