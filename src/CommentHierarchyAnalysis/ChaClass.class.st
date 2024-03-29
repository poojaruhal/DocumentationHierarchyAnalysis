"
I am the root class to determine where a particular class lies in the project hierarchy. 
The class can be as a root class, orphan class, intermediate class, or leaf class. 
- A root class is a class at the top of the hierarchy in the project. The class does not have a superclass in the current project.
- A orphan class does not have a superclass or a subclass in the current project.
- An intermediate class does have a superclass and a subclass as well.
- A leaf class does not have a subclass within the project.

I have various important key messages such as:
 !caclulateProjectLevel: determines where a class lies in the hierarchy according to the project scope.
!classDepth: determines where a class lies in the hierarchy according to whole Pharo image scope.
!statusRootOrIntermediateOrLeaf: determines if the class is a root, orphan, intermediate, or leaf class.


"
Class {
	#name : #ChaClass,
	#superclass : #Object,
	#instVars : [
		'name',
		'subclasses',
		'superclass',
		'package',
		'comment',
		'classDepth',
		'projectLevel',
		'organization'
	],
	#category : #'CommentHierarchyAnalysis-External'
}

{ #category : #converting }
ChaClass class >> asChaClass: aClass [
	"aClass"
	|aChaClass|
	aChaClass := self new.
	aChaClass name: aClass name.
	aChaClass subclasses: aClass subclasses.
	aChaClass superclass: aClass superclass.
	aChaClass package: aClass package name.
	aChaClass comment: aClass comment.
	aChaClass classDepth: aClass classDepth.
	aChaClass organization: aClass organization.
	aChaClass  projectLevel: 0.	
	^ aChaClass.
]

{ #category : #accessing }
ChaClass >> allSuperclasses [
	| aCurrentClass |
	
	aCurrentClass := self superclass.
	
	^ Array streamContents: [ :aStream |
		[ aCurrentClass isNotNil ]
			whileTrue: [
				aStream nextPut: aCurrentClass.
				aCurrentClass := aCurrentClass superclass ].
		aStream ]
]

{ #category : #accessing }
ChaClass >> calculateProjectLevel [
	self isSuperclassInAnotherProject 
		ifTrue: [ self projectLevel: 1 ]
		ifFalse: [ 
			self projectLevel: ((self superclass projectLevel)+1)].
		^ self projectLevel.
]

{ #category : #accessing }
ChaClass >> classDepth [
	^ classDepth
]

{ #category : #accessing }
ChaClass >> classDepth: anObject [
	classDepth := anObject
]

{ #category : #accessing }
ChaClass >> comment [
	^ comment
]

{ #category : #accessing }
ChaClass >> comment: anObject [
	comment := anObject
]

{ #category : #'gt-extension' }
ChaClass >> gtCommentFor: aView [
	<gtView>
	
	^ aView textEditor
		title: 'Comment';
		priority: 1;
		text: [ self comment ]
]

{ #category : #'gt-extension' }
ChaClass >> gtSubclassesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Subclasses';
		priority: 2;
		items: [ self subclasses sorted: [ :a :b | a name < b name ] ]
]

{ #category : #'gt-extension' }
ChaClass >> gtSuperclassesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Superclasses';
		priority: 3;
		items: [ self allSuperclasses ]
]

{ #category : #testing }
ChaClass >> hasSubclasses [
	^ subclasses isNotEmpty
]

{ #category : #testing }
ChaClass >> isChaObject [
	^ #(Object ProtoObject) includes: self name
]

{ #category : #testing }
ChaClass >> isLeafClassInProject [
	^ (self isSubclassInAnotherProject) and: [ self isSuperclassInAnotherProject not ]
]

{ #category : #testing }
ChaClass >> isOrphanClassInProject [
	^ (self isSuperclassInAnotherProject) and: [ self isSubclassInAnotherProject ]
]

{ #category : #testing }
ChaClass >> isRootClassInProject [
	^ (self isSuperclassInAnotherProject) and: [ self isSubclassInAnotherProject not ]
]

{ #category : #testing }
ChaClass >> isSubclassInAnotherProject [
"we don't have subclasses in the same project"
				^ (self subclasses isEmpty) or: [(self subclasses select: [ :eachSubclass | self package classes includes: eachSubclass ]) isEmpty] 
]

{ #category : #testing }
ChaClass >> isSuperclassInAnotherProject [
"superclass is from another project"
	^ ((self superclass isNil)
	or:
	[self superclass isChaObject 
			or: [(self package classes includes: self superclass) not]]).
]

{ #category : #accessing }
ChaClass >> name [
	^ name
]

{ #category : #accessing }
ChaClass >> name: anObject [
	name := anObject
]

{ #category : #accessing }
ChaClass >> organization [
	^ organization.

]

{ #category : #accessing }
ChaClass >> organization: anObject [.
	organization := anObject.
]

{ #category : #accessing }
ChaClass >> package [
	^ package
]

{ #category : #accessing }
ChaClass >> package: anObject [
	package := anObject
]

{ #category : #printing }
ChaClass >> printOn: aStream [
	aStream nextPutAll: self name
]

{ #category : #accessing }
ChaClass >> projectLevel [
	^ projectLevel
]

{ #category : #accessing }
ChaClass >> projectLevel: aNumber [ 
	projectLevel := aNumber.
]

{ #category : #accessing }
ChaClass >> statusRootOrIntermediateOrLeaf [
	|status|
	self isOrphanClassInProject 
	ifTrue: [ status := 'orphan' ]
	ifFalse: [  
	self isRootClassInProject 
		ifTrue: [  status := 'root' ]
		ifFalse: [ self isLeafClassInProject 
			ifTrue:[ status:= 'leaf' ]
			ifFalse: [ status := 'intermediate' ]
			]]. 
		^ status
]

{ #category : #accessing }
ChaClass >> subclasses [
	^ subclasses
]

{ #category : #accessing }
ChaClass >> subclasses: anObject [
	subclasses := anObject
]

{ #category : #accessing }
ChaClass >> superclass [
	^ superclass
]

{ #category : #accessing }
ChaClass >> superclass: anObject [
	superclass := anObject
]
