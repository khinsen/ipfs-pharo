Class {
	#name : #IpfsFileReference,
	#superclass : #AbstractFileReference,
	#instVars : [
		'path'
	],
	#category : #'IPFS-3 - Files'
}

{ #category : #'instance creation' }
IpfsFileReference class >> fromIpfsPath: anIpfsPath [
	^ self new
		path: anIpfsPath;
		yourself
]

{ #category : #accessing }
IpfsFileReference >> absolutePath [
	^ path
]

{ #category : #converting }
IpfsFileReference >> asAbsolute [
	^ self
]

{ #category : #converting }
IpfsFileReference >> asFileReference [
	^ self
]

{ #category : #converting }
IpfsFileReference >> asPath [
	^ path
]

{ #category : #streams }
IpfsFileReference >> binaryReadStream [
	^ Ipfs cat: path
]

{ #category : #streams }
IpfsFileReference >> binaryWriteStream [
	self errorImmutableFilesystem
]

{ #category : #accessing }
IpfsFileReference >> changeTime [ 
	"IPFS files have no timestamps, so use a fictitious one."
	^ (Year year: 2000) start
]

{ #category : #copying }
IpfsFileReference >> copyTo: aFileReference [
	"Copying to other filesystems should be supported!"
	self flag: #todo.
	self errorImmutableFilesystem
]

{ #category : #copying }
IpfsFileReference >> copyWithPath: newPath [
	"No idea what this does."
	self errorImmutableFilesystem
]

{ #category : #accessing }
IpfsFileReference >> creationTime [
	"IPFS files have no timestamps, so use a fictitious one."
	^ (Year year: 2000) start
]

{ #category : #operations }
IpfsFileReference >> delete [
	self errorImmutableFilesystem
]

{ #category : #operations }
IpfsFileReference >> deleteIfAbsent: aBlock [
	self errorImmutableFilesystem
]

{ #category : #accessing }
IpfsFileReference >> directories [
	self assert: self isDirectory description: 'Not a directory'.
	^ (path unixfsDirectoryEntries collect: [ :each |
		(IpfsFileReference fromIpfsPath: (path / (each at: #Name))) ])
		select: [ :each | each isDirectory ]
]

{ #category : #operations }
IpfsFileReference >> ensureCreateDirectory [
	"Do nothing: the directory already exists"
]

{ #category : #navigating }
IpfsFileReference >> entries [
	self assert: self isDirectory description: 'Not a directory'.
	^ path unixfsDirectoryEntries collect: [ :each |
		(IpfsFileReference fromIpfsPath: (path / (each at: #Name))) entry ]
]

{ #category : #accessing }
IpfsFileReference >> entry [
	^ FileSystemDirectoryEntry reference: self
]

{ #category : #private }
IpfsFileReference >> errorImmutableFilesystem [
	self error: 'Immutable IPFS filesystem'
]

{ #category : #testing }
IpfsFileReference >> exists [
	^ true
]

{ #category : #accessing }
IpfsFileReference >> files [
	self assert: self isDirectory description: 'Not a directory'.
	^ (path unixfsDirectoryEntries collect: [ :each |
		(IpfsFileReference fromIpfsPath: (path / (each at: #Name))) ])
		select: [ :each | each isFile ]
]

{ #category : #accessing }
IpfsFileReference >> fullName [
	^ path asString
]

{ #category : #accessing }
IpfsFileReference >> fullPath [
	^ self absolutePath
]

{ #category : #testing }
IpfsFileReference >> isAbsolute [
	^ true
]

{ #category : #testing }
IpfsFileReference >> isDirectory [
	^ path isUnixfsDirectory
]

{ #category : #testing }
IpfsFileReference >> isFile [
	^ path isUnixfsFile
]

{ #category : #testing }
IpfsFileReference >> isRelative [
	^ false
]

{ #category : #testing }
IpfsFileReference >> isRoot [
	^ path isUnixfsRoot
]

{ #category : #accessing }
IpfsFileReference >> path: anIpfsPath [
	self assert: anIpfsPath isUnixfsPath description: 'Not a file path: ', anIpfsPath asString.
	path := anIpfsPath
]

{ #category : #streams }
IpfsFileReference >> readStream [
	^ self readStreamEncoded: 'utf8'
]

{ #category : #operations }
IpfsFileReference >> renameTo: newBasename [
	self errorImmutableFilesystem
]

{ #category : #navigating }
IpfsFileReference >> resolve [
	self halt.
	^ self
]

{ #category : #navigating }
IpfsFileReference >> resolveString: aString [
	"Non idea how this is used..."
	self halt
]

{ #category : #streams }
IpfsFileReference >> writeStream [
	self error: 'Write-only file'
]
