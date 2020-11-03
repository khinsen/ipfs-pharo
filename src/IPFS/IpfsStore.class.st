Class {
	#name : #IpfsStore,
	#superclass : #FileSystemStore,
	#instVars : [
		'root',
		'rootPath'
	],
	#category : #'IPFS-3 - Files'
}

{ #category : #public }
IpfsStore class >> delimiter [
	^ $/
]

{ #category : #public }
IpfsStore class >> isCaseSensitive [
	^ true
]

{ #category : #'instance creation' }
IpfsStore class >> rootPath: anIpfsPath [
	^ self new rootPath: anIpfsPath
]

{ #category : #acccessing }
IpfsStore >> basenameFromEntry: anEntry [
	^ anEntry basename
]

{ #category : #private }
IpfsStore >> basicCreationTimeOf: aNode [
	FileAttributeNotSupported signal
]

{ #category : #private }
IpfsStore >> basicEntry: directoryEntry path: aPath nodesDo: aBlock [
	directoryEntry fileEntriesDo: aBlock
]

{ #category : #private }
IpfsStore >> basicIsDirectory: aNode [
	^ aNode isDirectory
]

{ #category : #private }
IpfsStore >> basicIsFile: aNode [
	^ aNode isFile
]

{ #category : #private }
IpfsStore >> basicIsSymlink: aNode [
	^ false
]

{ #category : #private }
IpfsStore >> basicIsWritable: aNode [
	^ false
]

{ #category : #private }
IpfsStore >> basicOpen: aPath writable: aBoolean [
	aBoolean ifTrue: [ ReadOnlyFileException signal ].
	self nodeAt: aPath
		ifPresent: [ :anEntry | ^ anEntry ipfsPath unixfsBinaryReadStream ]
		ifAbsent: [ FileDoesNotExistException signal ]
]

{ #category : #private }
IpfsStore >> basicPosixPermissions: aNode [
	FileAttributeNotSupported signal
]

{ #category : #private }
IpfsStore >> basicSizeOf: anIpfsFileSystemEntry [
	^ anIpfsFileSystemEntry fileSize
]

{ #category : #accessing }
IpfsStore >> handleClass [
	^ IpfsFileHandle
]

{ #category : #private }
IpfsStore >> nodeAt: aPath ifPresent: presentBlock ifAbsent: absentBlock [
	| current |
	aPath isRoot
		ifTrue: [ ^ presentBlock value: self root ].
	current := self root.
	aPath
		do: [ :segment | 
			current isDirectory
				ifTrue: [ current := current fileEntryAt: segment ifAbsent: [ ^ absentBlock value ] ]
				ifFalse: [ ^ absentBlock value ] ].
	^ presentBlock value: current
]

{ #category : #accessing }
IpfsStore >> root [
	^ root
]

{ #category : #accessing }
IpfsStore >> rootPath: anIpfsPath [
	self assert: anIpfsPath isUnixfsDirectory.
	rootPath := anIpfsPath.
	root := IpfsFileSystemEntry forIpfsPath: anIpfsPath.
]
