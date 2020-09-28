Extension { #name : #RPackage }

{ #category : #'*CommentHierarchyAnalysis' }
RPackage >> asChaPackage [
	ChaPackage asChaPackage: self.
]

{ #category : #'*CommentHierarchyAnalysis' }
RPackage >> chaPackageGroup [
	^ (self name splitOn: '-') first
]

{ #category : #'*CommentHierarchyAnalysis' }
RPackage >> classesWithHierarchy [
	^ self classes
		reject: [ :eachClass | (eachClass superclass isNil or: [ eachClass superclass isChaObject
				or: [
					"superclass is from the other project"
					(self classes includes: eachClass superclass) not
				] ])
			and: [
				"we don't have subclasses in the same project"
				(eachClass subclasses select: [ :eachSubclass | self classes includes: eachSubclass ]) isEmpty ] ]
]
