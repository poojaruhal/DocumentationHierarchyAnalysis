Extension { #name : #Class }

{ #category : #'*CommentHierarchyAnalysis' }
Class >> asChaClass [ 
	ChaClass asChaClass: self.
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> collectExampleMethods [
	
	|examples|
	
	examples := OrderedCollection new.
	self hasExampleMethods ifTrue: [ examples add: (self exampleMethods) ].
	self hasGtExamplePragmas ifTrue: [ examples add: (self gtExamplePragamsMethods) ].
	
	^ examples 

]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> exampleMethods [
	
	|exampleMethods|
	
	exampleMethods := OrderedCollection new.
	
	exampleMethods add: (self methods select: [ :m | 
		(m selector includesSubstring: 'example') or:[ m selector includesSubstring: 'Example']]).
	
	exampleMethods add: (self classSide methods select: [ :m | 
		(m selector includesSubstring: 'example') or:[ m selector includesSubstring: 'Example']]).
	
	
	^ exampleMethods flattened

]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> gtExamplePragamsMethods [
	|gtExamplePragmethods|
	gtExamplePragmethods := OrderedCollection new.
	gtExamplePragmethods add: (self methods select: [:aMethod |  aMethod hasPragmaNamed: #gtExample]).
	gtExamplePragmethods add: (self classSide methods select: [:aMethod |  aMethod hasPragmaNamed: #gtExample]).
	^ gtExamplePragmethods flattened.
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> hasExampleMethods [
	^ self exampleMethods isNotEmpty
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> hasExamples [
	^ ((self hasExampleMethods or: [ self hasGtExamplePragmas ]) or: [ self isExampleClass ])
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> hasGtExamplePragmas [
	^ self gtExamplePragamsMethods isNotEmpty
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> hasTestMethods [
	^ self testMethods isNotEmpty
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> hasTests [
	^ (self hasTestMethods or: [ self isTestClass ])
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> isChaObject [
	^ #(Object ProtoObject) includes: self name

]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> isExampleClass [
	^ ((self name includesSubstring: 'example') or:[ self name includesSubstring: 'Example'])
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> isTestClass [
	^ ((self name includesSubstring: 'test') or:[ self name includesSubstring: 'Test'])
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> sampleInstancePragamsMethods [
	|sampleInstancePragams|
	sampleInstancePragams := OrderedCollection new.
	sampleInstancePragams add: (self methods select: [:aMethod |  aMethod hasPragmaNamed: #sampleInstance ]).
	sampleInstancePragams add: (self classSide methods select: [:aMethod |  aMethod hasPragmaNamed: #sampleInstance]).
	^ sampleInstancePragams flattened.
]

{ #category : #'*CommentHierarchyAnalysis' }
Class >> testMethods [
	
	|testMethods|
	
	testMethods := OrderedCollection new.
	
	testMethods add: (self methods select: [ :m | 
		(m selector includesSubstring: 'test') or:[ m selector includesSubstring: 'Test']]).
	
	testMethods add: (self classSide methods select: [ :m | 
		(m selector includesSubstring: 'test') or:[ m selector includesSubstring: 'Test']]).
	
	
	^ testMethods flattened

]
