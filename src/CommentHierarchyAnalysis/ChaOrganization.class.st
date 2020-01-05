"
I can be created from a json that contains data about class hierarchy.

The JSON must be an array of maps:

{ 
	#name -> 'Class Name'.
	#superclass -> 'Superclass name'.
	#subclasses -> 'An array of subclass names'.
	#comment -> 'Class comment'
	#package -> 'Package name'
	#depth -> 'Class depth'
}

For Pharo it can be generated using:
[[[
| allClasses data |
allClasses := Smalltalk allClasses.

data := allClasses collect: [ :eachClass |
	{ 
	#name -> eachClass name.
	#superclass -> (eachClass superclass ifNotNil: #name).
	#subclasses -> (eachClass subclasses collect: #name) asArray.
	#comment -> eachClass comment.
	#package -> eachClass package name.
	#depth -> eachClass classDepth
	 } asDictionary
] as: Array.

'classes.json' asFileReference writeStream nextPutAll: (STONJSON toString: data); flush.			
]]]

The organization can be instantiated from a JSON file:
[[[
| data organization |
data := STONJSON fromStream: 'classes.json' asFileReference readStream.
organization := ChaOrganization fromData: data.
organization
]]]
"
Class {
	#name : #ChaOrganization,
	#superclass : #Object,
	#instVars : [
		'classes',
		'packages'
	],
	#category : #CommentHierarchyAnalysis
}

{ #category : #'instance creation' }
ChaOrganization class >> fromData: aPharoData [
	"aPharoData a collection of dictionaries"
	| anOrganization |
	
	anOrganization := self new.
	
	aPharoData do: [ :each |
		| aClass aPackage |
		
		aPackage := anOrganization packageNamed: (each at: #package).
		
		aClass := anOrganization classNamed: (each at: #name).
		aClass classDepth: (each at: #depth).
		aClass package: aPackage.
		aClass comment:  (each at: #comment).
		
		(each at: #superclass) ifNotNil: [ :aSuperclassName |
			aClass superclass: (anOrganization classNamed: aSuperclassName) ].
		aClass subclasses: ((each at: #subclasses) collect: [ :eachName | anOrganization classNamed: eachName ]).
		
		aPackage addClass: aClass ].
	
	^ anOrganization
]

{ #category : #accessing }
ChaOrganization >> allClasses [
	^ classes values
]

{ #category : #accessing }
ChaOrganization >> allPackageGroups [
	^ (self allPackages groupedBy: [ :eachPackage | (eachPackage name splitOn: '-') first ]) associations
		collect: [ :each |
			ChaPackage new
				name: each key;
				classes: (each value flatCollect: #classes) ]
]

{ #category : #accessing }
ChaOrganization >> allPackages [
	^ packages values
]

{ #category : #accessing }
ChaOrganization >> classNamed: aChaClassName [
	^ classes
		at: aChaClassName
		ifAbsentPut: [ ChaClass new name: aChaClassName ]
]

{ #category : #'gt-extension' }
ChaOrganization >> gtClassesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Classes';
		priority: 4;
		items: [ self allClasses sorted: [ :a :b | a name < b name ] ]
]

{ #category : #'gt-extension' }
ChaOrganization >> gtGroupsPackagesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Groups';
		priority: 3;
		items: [ self allPackageGroups sorted: [ :a :b | a name < b name ] ]
]

{ #category : #'gt-extension' }
ChaOrganization >> gtPackagesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Packages';
		priority: 2;
		items: [ self allPackages sorted: [ :a :b | a name < b name ] ]
]

{ #category : #initialization }
ChaOrganization >> initialize [
	super initialize.
	
	classes := Dictionary new.
	packages := Dictionary new
]

{ #category : #accessing }
ChaOrganization >> packageNamed: aChaPackageName [
	^ packages
		at: aChaPackageName
		ifAbsentPut: [ ChaPackage new name: aChaPackageName; organization: self ]
]
