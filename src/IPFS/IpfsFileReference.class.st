Class {
	#name : #IpfsFileReference,
	#superclass : #AbstractFileReference,
	#instVars : [
		'path'
	],
	#category : #'IPFS-3 - Files'
}

{ #category : #'instance creation' }
IpfsFileReference class >> fromPath: anIpfsPath [
	^ self new
		path: anIpfsPath;
		yourself
]

{ #category : #accessing }
IpfsFileReference >> absolutePath [
	^ path asString
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
	self error: 'Write-only filesystem'
]

{ #category : #copying }
IpfsFileReference >> copyWithPath: newPath [
	self error: 'Write-only filesystem'
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
IpfsFileReference >> isRelative [
	^ false
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
	self error: 'Write-only filesystem'
]

{ #category : #navigating }
IpfsFileReference >> resolve [
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
