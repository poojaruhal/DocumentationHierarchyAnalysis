Class {
	#name : #ChaClass,
	#superclass : #Object,
	#instVars : [
		'name',
		'subclasses',
		'superclass',
		'package',
		'comment',
		'classDepth'
	],
	#category : #CommentHierarchyAnalysis
}

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
ChaClass >> isObject [
	^ #(Object ProtoObject) includes: self name
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
