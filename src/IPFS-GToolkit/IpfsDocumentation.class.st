Class {
	#name : #IpfsDocumentation,
	#superclass : #Object,
	#category : #'IPFS-GToolkit'
}

{ #category : #accessing }
IpfsDocumentation >> database [
	| logicalDB db |
	logicalDB := LeDatabasesRegistry uniqueInstance currentLoadedDefaultLogicalDatabase.
	db := logicalDB databases
		detect: [ :each | each databaseName = self databaseName ]
		ifNone: [
			| newDB |
			newDB := LeLocalStoreLoad current loadAndMonitorFrom: self databaseLocation.
			newDB databaseName: self databaseName.
			logicalDB addDB: newDB.
			newDB ].
	^ db
]

{ #category : #accessing }
IpfsDocumentation >> databaseLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'ipfs-pharo' / 'documentation'
]

{ #category : #accessing }
IpfsDocumentation >> databaseName [
	^ 'IPFS Documentation'
]
