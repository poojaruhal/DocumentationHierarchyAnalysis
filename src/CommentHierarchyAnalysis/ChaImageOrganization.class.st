"
Get all classes, packages and package groups of Smalltalk image.
"
Class {
	#name : #ChaImageOrganization,
	#superclass : #ChaOrganization,
	#category : #'CommentHierarchyAnalysis-External'
}

{ #category : #'instance creation' }
ChaImageOrganization class >> fromEnvironment: smalltalkImage [
	"Smalltalk image environment"
	| anOrganization |
	
	anOrganization := self new.
	
		smalltalkImage allClasses do: [ :each |
		| aClass aPackage |
		
		aPackage := anOrganization packageNamed: (each package).
		
		aClass := anOrganization classNamed: (each).
		aClass classDepth: (each classDepth).
		aClass package: aPackage.
		aClass comment:  (each hasComment ifTrue: [each comment] ifFalse: ['']).
		
		(each superclass) ifNotNil: [ :aSuperclassName |
			aClass superclass: (anOrganization classNamed: (aSuperclassName name)) ].
		aClass subclasses: (each subclasses collect: [ :eachSubclass | anOrganization classNamed: eachSubclass name ]).
		
		aPackage addClass: aClass ].
	
	^ anOrganization
	
	
]

{ #category : #accessing }
ChaImageOrganization >> allClasses [
	^ Smalltalk image allClasses
]

{ #category : #accessing }
ChaImageOrganization >> allPackageGroups [
	^ (self allPackages groupedBy: [ :eachPackage | eachPackage chaPackageGroup])
		collect: [ :each |
			ChaPackage new
				name: each name;
				classes: (each classes flatCollect: #classes) ]
]

{ #category : #accessing }
ChaImageOrganization >> allPackages [
	^ self allClasses flatCollect: [ :e | e package  ]
]
