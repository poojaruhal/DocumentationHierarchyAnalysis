Class {
	#name : #ChaPackage,
	#superclass : #Object,
	#instVars : [
		'name',
		'classes',
		'organization'
	],
	#category : #'CommentHierarchyAnalysis-External'
}

{ #category : #adding }
ChaPackage >> addClass: aClass [
	classes add: aClass
]

{ #category : #accessing }
ChaPackage >> classes [
	^ classes
]

{ #category : #accessing }
ChaPackage >> classes: anObject [
	classes := anObject
]

{ #category : #accessing }
ChaPackage >> classesWithHierarchy [
	^ self classes
		reject: [ :eachClass | 
			(eachClass superclass isNil 
				or: 
					[ eachClass superclass isChaObject
						or: [
							"superclass is from the other project"
							(self classes includes: eachClass superclass) not ] ])
			and: [
				"we don't have subclasses in the same project"
				(eachClass subclasses select: [ :eachSubclass | self classes includes: eachSubclass ]) isEmpty ] ]
]

{ #category : #'gt-extension' }
ChaPackage >> gtClassesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Classes';
		priority: 2;
		items: [ self classes sorted: [ :a :b | a name < b name ] ]
]

{ #category : #'gt-extension' }
ChaPackage >> gtHierarchyFor: aView [
	<gtView>

	^ aView mondrian
		title: 'Hierarchy';
		priority: 1;
		painting: [ :m | self paintHierarchy: self classes with: m ]
]

{ #category : #'gt-extension' }
ChaPackage >> gtHierarchyTreesFor: aView [
	<gtView>

	^ aView mondrian
		title: 'Hierarchy trees';
		priority: 1;
		painting: [ :m | self paintHierarchy: self classesWithHierarchy with: m ]
]

{ #category : #initialization }
ChaPackage >> initialize [
	super initialize.
	
	classes := OrderedCollection new
]

{ #category : #accessing }
ChaPackage >> name [
	^ name
]

{ #category : #accessing }
ChaPackage >> name: anObject [
	name := anObject
]

{ #category : #accessing }
ChaPackage >> organization [
	^ organization
]

{ #category : #accessing }
ChaPackage >> organization: anObject [
	organization := anObject
]

{ #category : #'gt-extension' }
ChaPackage >> paintHierarchy: aCollectionOfClasses with: mondrian [
	mondrian nodes 
		stencil: [ :c | 
			BlElement new 
				when: BlClickEvent do: [:event | event target fireEvent: (GtPhlowObjectToSpawn new object: c; sourceElement: event target)];
				zIndex: 10;
				geometry: BlEllipse new;
				border: (BlBorder paint: Color black width: 1);
				background: Color orange;
				size: c comment size sqrt asPoint;
				look: ((BrWithTooltipLook content: [ BrLabel new look: BrGlamorousLabelLook; text: c name ])
					showDelay: 0;
					hideDelay: 0) ];
		with: aCollectionOfClasses.
	mondrian edges
		shape: [ :each | BlLineElement new border: (BlBorder paint: (Color gray alpha: 0.5) width: 1 ) ];
		connectToAll: [ :each | each subclasses ].
	mondrian layout tree
]

{ #category : #printing }
ChaPackage >> printOn: aStream [
	aStream nextPutAll: self name
]
