"
I generate mappings based on items in the configurationClass specified. 

	
ConfigurationBuilder new 
	configurationClass: ConfigurationForPillar;
	with: ConfigurationDescriptionForPillar new
	
ConfigurationBuilder new 
	defineConfigurationClassNamed: #ConfigurationForPillar packagedIn: 'Chrysal-ToBeMovedElsewhere'; 
	with: ConfigurationDescriptionForPillar new
	
ConfigurationBuilder new 
	defineConfigurationClassNamed: #ConfigurationForXX packagedIn: 'Chrysal'; 
	with: ConfigurationDescriptionForXX new
"
Class {
	#name : #ChrysalConfigurationBuilder,
	#superclass : #Object,
	#instVars : [
		'configurationClass'
	],
	#category : #Chrysal
}

{ #category : #configuration }
ChrysalConfigurationBuilder >> accessorGenerationForItem: anItem [
	"self new accessorGenerationForItem: BooleanConfigurationItem example"
	"self new accessorGenerationForItem: NewLineConfigurationItem example"
	"self new accessorGenerationForItem: FolderConfigurationItem example"
	"self new accessorGenerationForItem: FileConfigurationItem example"
	
	^ String
		streamContents: [ :str | 
			str nextPutAll: anItem propertyName.
			str cr; tab.
			str nextPutAll: '"generated code"'.
			str cr; tab.
			str nextPutAll:
					'^ self propertyAt: #' , anItem propertyName , ' ifAbsent: ['
						, anItem defaultDomainValueString , ']' ]
]

{ #category : #configuration }
ChrysalConfigurationBuilder >> configurationClass [
	^ configurationClass
]

{ #category : #configuration }
ChrysalConfigurationBuilder >> configurationClass: aClass [
	configurationClass := aClass
]

{ #category : #configuration }
ChrysalConfigurationBuilder >> conversionGenerationForItem: anItem [
	"self new accessorGenerationForItem: FileConfigurationItem example"

	^ String
		streamContents: [ :str | 
			str nextPutAll: 'convert', (anItem propertyName) capitalized, ': aValue'.
			"pay attention aValue is a special argument that domainValueString can use to manipulate the parameter 
			during conversion"
			str cr; tab.
			str nextPutAll: '"generated code"'.
			str cr; tab.
			str nextPutAll: ('^ ', anItem domainValueConversionString ) ]
]

{ #category : #configuration }
ChrysalConfigurationBuilder >> declaredItems: aDescription [

	
	^ String
		streamContents: [ :str | 
			str nextPutAll: 'declaredItems'.
			str cr; tab.
			str nextPutAll: '"generated code"'.
			str cr; tab.
			str nextPutAll: '^ #( '.
			aDescription items
				do: [:each | str nextPutAll: '#', each propertyName]
				separatedBy: [str space].
			str nextPutAll: ' )' ]
]

{ #category : #configuration }
ChrysalConfigurationBuilder >> defineConfigurationClassNamed: aString packagedIn: packageName [
	ChrysalConfiguration
		subclass: aString asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		package: packageName.
	self configurationClass: (self class environment at: aString asSymbol)
]

{ #category : #configuration }
ChrysalConfigurationBuilder >> setterGenerationForItem: anItem [
	
	^ String
		streamContents: [ :str | 
			str nextPutAll: anItem propertyName, ': aValue'.
			str cr; tab.
			str nextPutAll: '"generated code"'.
			str cr; tab.
			str nextPutAll:
					'^ self propertyAt: #' , anItem propertyName , ' put: aValue' ]
]

{ #category : #configuration }
ChrysalConfigurationBuilder >> with: aDescription [
	"self new with: ConfigurationDescriptionForXX new"
	aDescription items do: [ :each | 
		self configurationClass 
			compile: (self accessorGenerationForItem: each) 	
			classified: 'accessing'. 
		self configurationClass  
			compile: (self setterGenerationForItem: each) 
			classified: 'accessing'.
		self configurationClass  
			compile: (self conversionGenerationForItem: each) 
			classified: 'conversion'].
	self configurationClass 
		compile: (self declaredItems: aDescription)
		classified: 'declared items'
	
]