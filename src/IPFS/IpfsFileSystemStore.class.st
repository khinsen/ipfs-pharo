Class {
	#name : #IpfsFileSystemStore,
	#superclass : #FileSystemStore,
	#instVars : [
		'root',
		'rootPath'
	],
	#category : #'IPFS-3 - Files'
}

{ #category : #public }
IpfsFileSystemStore class >> delimiter [
	^ $/
]

{ #category : #public }
IpfsFileSystemStore class >> isCaseSensitive [
	^ true
]

{ #category : #'instance creation' }
IpfsFileSystemStore class >> rootPath: anIpfsPath [
	^ self new rootPath: anIpfsPath
]

{ #category : #acccessing }
IpfsFileSystemStore >> basenameFromEntry: anEntry [
	^ anEntry basename
]

{ #category : #private }
IpfsFileSystemStore >> basicCreationTimeOf: aNode [
	FileAttributeNotSupported signal
]

{ #category : #private }
IpfsFileSystemStore >> basicEntry: directoryEntry path: aPath nodesDo: aBlock [
	directoryEntry fileEntriesDo: aBlock
]

{ #category : #private }
IpfsFileSystemStore >> basicIsDirectory: aNode [
	^ aNode isDirectory
]

{ #category : #private }
IpfsFileSystemStore >> basicIsFile: aNode [
	^ aNode isFile
]

{ #category : #private }
IpfsFileSystemStore >> basicIsSymlink: aNode [
	^ false
]

{ #category : #private }
IpfsFileSystemStore >> basicIsWritable: aNode [
	^ false
]

{ #category : #private }
IpfsFileSystemStore >> basicOpen: aPath writable: aBoolean [
	aBoolean ifTrue: [ ReadOnlyFileException signal ].
	self nodeAt: aPath
		ifPresent: [ :anEntry | ^ anEntry ipfsPath unixfsBinaryReadStream ]
		ifAbsent: [ FileDoesNotExistException signal ]
]

{ #category : #private }
IpfsFileSystemStore >> basicPosixPermissions: aNode [
	FileAttributeNotSupported signal
]

{ #category : #private }
IpfsFileSystemStore >> basicSizeOf: anIpfsFileSystemEntry [
	^ anIpfsFileSystemEntry fileSize
]

{ #category : #printing }
IpfsFileSystemStore >> forReferencePrintOn: aStream [
	aStream nextPutAll: rootPath asString
]

{ #category : #accessing }
IpfsFileSystemStore >> handleClass [
	^ IpfsFileHandle
]

{ #category : #private }
IpfsFileSystemStore >> nodeAt: aPath ifPresent: presentBlock ifAbsent: absentBlock [
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
IpfsFileSystemStore >> root [
	^ root
]

{ #category : #accessing }
IpfsFileSystemStore >> rootPath: anIpfsPath [
	self assert: anIpfsPath isUnixfsDirectory.
	rootPath := anIpfsPath.
	root := IpfsFileSystemEntry forIpfsPath: anIpfsPath.
]
