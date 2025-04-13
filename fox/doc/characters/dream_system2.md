# Dream System Flexibility Strategy
*Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v1.2*

## Purpose
This document outlines a strategic approach for extending the dream combination system to support flexible character integration, expandable symbol categories, and customizable interpretation frameworks without substantial code refactoring.

## Flexibility Requirements

- Character-agnostic dream processing architecture
- Extensible symbol categorization system
- Dynamic registration of new dream patterns
- Data-driven interpretation rules
- Runtime-expandable compatibility matrices
- Support for psychological archetypes beyond current implementation

## Strategy Overview

### 1. Dreamer Framework Abstraction

The current implementation tightly couples character identities with dream interpretation logic. A more flexible approach requires separation:

```wonkey
' Abstract dreamer profile framework
Class DreamerProfile
	Field name:String
	Field symbolAffinities:StringMap<Float>
	Field psychologicalTraits:StringMap<Float>
	Field interpretationRules:InterpretationRuleSet
	
	Method New(name:String)
		Self.name = name
		Self.symbolAffinities = New StringMap<Float>
		Self.psychologicalTraits = New StringMap<Float>
		Self.interpretationRules = New InterpretationRuleSet()
	End
	
	' Methods for dream interpretation based on properties
	Method GetSymbolAffinity:Float(symbolType:String)
		If symbolAffinities.Contains(symbolType)
			Return symbolAffinities.Get(symbolType)
		Endif
		Return 0.2  ' Default minimal affinity
	End
	
	Method SetSymbolAffinity:Void(symbolType:String, affinity:Float)
		symbolAffinities.Set(symbolType, affinity)
	End
	
	Method GetInterpretation:String(symbol:SymbolMetadata)
		Return interpretationRules.Apply(symbol, Self)
	End
End
```

This approach allows new dreamer profiles to be created without modifying the core system.

### 2. Dynamic Symbol Registry

Instead of hardcoded symbol types, implement a registry system:

```wonkey
' Symbol category registry
Class SymbolRegistry
	Field categories:StringMap<SymbolCategory>
	Field compatibilityMatrix:CompatibilityMatrix
	
	Method New()
		Self.categories = New StringMap<SymbolCategory>
		Self.compatibilityMatrix = New CompatibilityMatrix()
	End
	
	Method RegisterCategory:Void(category:SymbolCategory)
		Self.categories.Set(category.name, category)
	End
	
	Method RegisterCompatibility:Void(category1:String, category2:String, score:Float)
		Self.compatibilityMatrix.Set(category1, category2, score)
	End
End

' Symbol category definition
Class SymbolCategory
	Field name:String
	Field parentCategory:String  ' For hierarchical categorization 
	Field psychologicalAssociations:String[]
	Field commonEmotions:String[]
	
	Method New(name:String, parent:String="")
		Self.name = name
		Self.parentCategory = parent
		Self.psychologicalAssociations = New String[0]
		Self.commonEmotions = New String[0]
	End
	
	Method AddPsychologicalAssociation:Void(association:String)
		Self.psychologicalAssociations = Self.psychologicalAssociations.Resize(Self.psychologicalAssociations.Length + 1)
		Self.psychologicalAssociations[Self.psychologicalAssociations.Length - 1] = association
	End
	
	Method AddCommonEmotion:Void(emotion:String)
		Self.commonEmotions = Self.commonEmotions.Resize(Self.commonEmotions.Length + 1)
		Self.commonEmotions[Self.commonEmotions.Length - 1] = emotion
	End
End
```

This registry allows new symbol categories to be added at runtime, including specialized dream patterns like pursuit dreams or tooth loss dreams.

### 3. Rule-Based Interpretation System

Replace hardcoded interpretation logic with a rule system:

```wonkey
' Interpretation rule set
Class InterpretationRuleSet
	Field rules:List<InterpretationRule>
	
	Method New()
		Self.rules = New List<InterpretationRule>
	End
	
	Method AddRule:Void(rule:InterpretationRule)
		Self.rules.AddLast(rule)
	End
	
	Method Apply:String(symbol:SymbolMetadata, dreamer:DreamerProfile)
		' Find highest priority matching rule
		Local bestRule:InterpretationRule = Null
		Local bestPriority:Int = -1
		
		For Local rule:InterpretationRule = EachIn Self.rules
			If rule.Matches(symbol, dreamer)
				If rule.priority > bestPriority
					bestRule = rule
					bestPriority = rule.priority
				Endif
			Endif
		Next
		
		If bestRule <> Null
			Return bestRule.Apply(symbol, dreamer)
		Endif
		
		' Default interpretation if no rules match
		Return "a " + symbol.symbolInstance
	End
End

' Abstract interpretation rule
Class InterpretationRule
	Field symbolType:String
	Field priority:Int
	
	Method New(symbolType:String, priority:Int)
		Self.symbolType = symbolType
		Self.priority = priority
	End
	
	Method Matches:Bool(symbol:SymbolMetadata, dreamer:DreamerProfile) Abstract
	
	Method Apply:String(symbol:SymbolMetadata, dreamer:DreamerProfile) Abstract
End
```

This allows custom interpretation rules to be defined for specific dreamers or dreamer types.

### 4. Extensible Compatibility Framework

Create a dynamic compatibility matrix:

```wonkey
' Dynamic compatibility matrix
Class CompatibilityMatrix
	Field compatibilities:StringMap<StringMap<Float>>
	
	Method New()
		Self.compatibilities = New StringMap<StringMap<Float>>
	End
	
	Method Set:Void(category1:String, category2:String, compatibility:Float)
		' Ensure maps exist
		If Not Self.compatibilities.Contains(category1)
			Self.compatibilities.Set(category1, New StringMap<Float>)
		Endif
		
		' Set compatibility both ways for symmetrical lookup
		Self.compatibilities.Get(category1).Set(category2, compatibility)
		
		' Mirror for reverse lookup
		If Not Self.compatibilities.Contains(category2)
			Self.compatibilities.Set(category2, New StringMap<Float>)
		Endif
		Self.compatibilities.Get(category2).Set(category1, compatibility)
	End
	
	Method Get:Float(category1:String, category2:String)
		If Self.compatibilities.Contains(category1)
			Local innerMap:StringMap<Float> = Self.compatibilities.Get(category1)
			If innerMap.Contains(category2)
				Return innerMap.Get(category2)
			Endif
		Endif
		
		Return 0.5  ' Default medium compatibility
	End
End
```

This allows new symbol compatibility relationships to be defined without modifying existing code.

## Implementation Strategies for Common Dream Types

### 1. Pursuit Dreams (e.g., Shadow/Chase Dreams)

Create a PursuitSymbol category with subcategories:

```wonkey
' Example of adding pursuit dreams to the system
Function RegisterPursuitDreams:Void(registry:SymbolRegistry)
	Local pursuitCategory:SymbolCategory = New SymbolCategory("PursuitDreams")
	pursuitCategory.AddPsychologicalAssociation("Anxiety")
	pursuitCategory.AddPsychologicalAssociation("Avoidance")
	pursuitCategory.AddCommonEmotion("Fear")
	pursuitCategory.AddCommonEmotion("Helplessness")
	
	registry.RegisterCategory(pursuitCategory)
	
	' Add subcategories
	registry.RegisterCategory(New SymbolCategory("ShadowPursuit", "PursuitDreams"))
	registry.RegisterCategory(New SymbolCategory("AnimalPursuit", "PursuitDreams"))
	registry.RegisterCategory(New SymbolCategory("MonsterPursuit", "PursuitDreams"))
	
	' Register compatibilities with existing categories
	registry.RegisterCompatibility("PursuitDreams", "ArchitecturalSpaces", 0.8)  ' Chases through buildings
	registry.RegisterCompatibility("PursuitDreams", "ShadowManifestations", 0.9)  ' Shadow chases
	registry.RegisterCompatibility("PursuitDreams", "TemporalDistortions", 0.7)  ' Slow-motion chase
End
```

### 2. Sexual Dream Symbolism

Implement as a new symbol category with appropriate subcategories:

```wonkey
Function RegisterSexualSymbolism:Void(registry:SymbolRegistry)
	Local sexualCategory:SymbolCategory = New SymbolCategory("SexualSymbolism")
	sexualCategory.AddPsychologicalAssociation("Desire")
	sexualCategory.AddPsychologicalAssociation("Intimacy")
	sexualCategory.AddPsychologicalAssociation("Power")
	sexualCategory.AddCommonEmotion("Excitement")
	sexualCategory.AddCommonEmotion("Vulnerability")
	
	registry.RegisterCategory(sexualCategory)
	
	' Add subcategories following Freudian symbolism
	registry.RegisterCategory(New SymbolCategory("PenetrativeSymbols", "SexualSymbolism"))
	registry.RegisterCategory(New SymbolCategory("ContainmentSymbols", "SexualSymbolism"))
	registry.RegisterCategory(New SymbolCategory("IntimacyScenarios", "SexualSymbolism"))
	
	' Register compatibilities
	registry.RegisterCompatibility("SexualSymbolism", "NaturalElements", 0.7)
	registry.RegisterCompatibility("SexualSymbolism", "ReflectiveSurfaces", 0.6)
	registry.RegisterCompatibility("SexualSymbolism", "ArchitecturalSpaces", 0.8)
End
```

### 3. Falling/Flying Dreams

Add as vertical movement categories:

```wonkey
Function RegisterVerticalMovementDreams:Void(registry:SymbolRegistry)
	Local verticalCategory:SymbolCategory = New SymbolCategory("VerticalMovement")
	verticalCategory.AddPsychologicalAssociation("Control")
	verticalCategory.AddPsychologicalAssociation("Status")
	
	registry.RegisterCategory(verticalCategory)
	
	' Add specialized subcategories
	Local fallingCategory:SymbolCategory = New SymbolCategory("FallingDreams", "VerticalMovement")
	fallingCategory.AddPsychologicalAssociation("Insecurity")
	fallingCategory.AddPsychologicalAssociation("Failure")
	fallingCategory.AddCommonEmotion("Fear")
	registry.RegisterCategory(fallingCategory)
	
	Local flyingCategory:SymbolCategory = New SymbolCategory("FlyingDreams", "VerticalMovement")
	flyingCategory.AddPsychologicalAssociation("Freedom")
	flyingCategory.AddPsychologicalAssociation("Achievement")
	flyingCategory.AddCommonEmotion("Exhilaration")
	registry.RegisterCategory(flyingCategory)
	
	' Register compatibilities
	registry.RegisterCompatibility("FallingDreams", "ArchitecturalSpaces", 0.8)
	registry.RegisterCompatibility("FlyingDreams", "NaturalElements", 0.9)
End
```

### 4. Tooth Loss Dreams

Register as a body transformation category:

```wonkey
Function RegisterBodyTransformationDreams:Void(registry:SymbolRegistry)
	Local bodyCategory:SymbolCategory = New SymbolCategory("BodyTransformation")
	bodyCategory.AddPsychologicalAssociation("Identity")
	bodyCategory.AddPsychologicalAssociation("Control")
	registry.RegisterCategory(bodyCategory)
	
	Local toothLossCategory:SymbolCategory = New SymbolCategory("ToothLossDreams", "BodyTransformation")
	toothLossCategory.AddPsychologicalAssociation("Vulnerability")
	toothLossCategory.AddPsychologicalAssociation("Appearance")
	toothLossCategory.AddPsychologicalAssociation("Communication")
	toothLossCategory.AddCommonEmotion("Embarrassment")
	toothLossCategory.AddCommonEmotion("Helplessness")
	registry.RegisterCategory(toothLossCategory)
	
	' Register compatibilities
	registry.RegisterCompatibility("ToothLossDreams", "SocialSpaces", 0.9)
	registry.RegisterCompatibility("ToothLossDreams", "ReflectiveSurfaces", 0.8)
End
```

## Notes on Implementation

### Separation of Concerns

The proposed strategy strictly separates:

1. **Dream Symbol Definition** - What the symbol is and means psychologically
2. **Character-Specific Interpretation** - How a specific dreamer interprets symbols
3. **Compatibility Logic** - How symbols interact with each other
4. **Rule Application** - How interpretations are selected and applied

This separation allows each aspect to evolve independently.

### Data-Driven Architecture

By moving from hardcoded switch statements to data structures:

- New symbol types can be added without code changes
- New dreamers can be created through data definition
- Compatibility relationships can be modified at runtime
- Interpretation rules can be loaded from external sources

### Hierarchical Symbol Categories

The parent-child relationship in symbol categories enables:

- Common processing rules for related symbols
- Inheritance of compatibility scores
- Specialization of general dream patterns
- Organization of the growing symbol library

### Weighted Rule Evaluation

The priority-based rule system supports:

1. Default interpretations that apply broadly
2. Character-specific overrides for personalization
3. Context-sensitive rules based on symbol combinations
4. Psychological state modifications to interpretation

## Technical Advantages

### 1. Runtime Extensibility

The proposed framework allows adding new dream elements at runtime:

```wonkey
' Example of runtime extension
Function ExtendDreamSystem:Void(dreamSystem:DreamSystem)
	' Register new symbol category
	Local newCategory:SymbolCategory = New SymbolCategory("ExamDreams")
	newCategory.AddPsychologicalAssociation("Evaluation")
	newCategory.AddPsychologicalAssociation("Preparedness")
	newCategory.AddCommonEmotion("Anxiety")
	
	dreamSystem.symbolRegistry.RegisterCategory(newCategory)
	
	' Create new dream image with the new category
	Local metadata:SymbolMetadata = New SymbolMetadata(
		"ExamDreams", 
		"unprepared test", 
		0.8, 
		"Anxiety"
	)
	
	' Register new dreamer profile
	Local newDreamer:DreamerProfile = New DreamerProfile("Akane")
	newDreamer.SetSymbolAffinity("ExamDreams", 0.9)  ' Akane strongly relates to exam anxiety
	
	' Add interpretation rule for the new dreamer
	Local examRule:CustomInterpretationRule = New CustomInterpretationRule(
		"ExamDreams", 
		10,
		lambda:Bool(symbol:SymbolMetadata, dreamer:DreamerProfile)
			Return symbol.symbolType = "ExamDreams" And dreamer.name = "Akane"
		End,
		lambda:String(symbol:SymbolMetadata, dreamer:DreamerProfile)
			Return "a test where she must evaluate students but cannot remember the subject matter"
		End
	)
	
	newDreamer.interpretationRules.AddRule(examRule)
	dreamSystem.AddDreamerProfile(newDreamer)
End
```

This allows both modders and in-game unlockable content to extend the dream system.

### 2. Psychological Depth Through Composition

The framework supports combining psychological insights across dream elements:

```wonkey
' Compound dream interpretation example
Function GenerateCompoundInterpretation:String(dreamer:DreamerProfile, symbols:SymbolMetadata[])
	' Base interpretations
	Local interpretations:String[] = New String[symbols.Length]
	For Local i:Int = 0 Until symbols.Length
		interpretations[i] = dreamer.GetInterpretation(symbols[i])
	Next
	
	' Check for special combinations
	If HasSymbols(symbols, ["PursuitDreams", "ArchitecturalSpaces"]) And dreamer.GetTraitValue("Anxiety") > 0.7
		Return "a frantic chase through " + GetSymbolInstance(symbols, "ArchitecturalSpaces") + 
			" where " + dreamer.name + " desperately tries to escape but finds paths constantly blocked"
	EndIf
	
	' Default combined narrative
	Local narrative:String = dreamer.name + " dreams of "
	For Local i:Int = 0 Until interpretations.Length
		If i > 0 And i < interpretations.Length - 1
			narrative += ", "
		ElseIf i > 0
			narrative += " and "
		EndIf
		narrative += interpretations[i]
	Next
	
	Return narrative
End

Function HasSymbols:Bool(symbols:SymbolMetadata[], types:String[])
	For Local type:String = EachIn types
		Local found:Bool = False
		For Local symbol:SymbolMetadata = EachIn symbols
			If symbol.symbolType = type
				found = True
				Exit
			EndIf
		Next
		If Not found Return False
	Next
	Return True
End

Function GetSymbolInstance:String(symbols:SymbolMetadata[], type:String)
	For Local symbol:SymbolMetadata = EachIn symbols
		If symbol.symbolType = type
			Return symbol.symbolInstance
		EndIf
	Next
	Return ""
End
```

This enables emergent dream narratives that consider both symbol combinations and dreamer psychology.

### 3. Character Development Integration

The system can reflect character growth through evolving dream interpretations:

```wonkey
' Update dreamer profile based on narrative progression
Function UpdateDreamerFromNarrative:Void(dreamer:DreamerProfile, narrativePhase:String, events:StoryEvent[])
	Select narrativePhase
		Case "EARLY_STORY"
			' Early story adjustments
			dreamer.SetSymbolAffinity("ShadowManifestations", 0.5)  ' Limited awareness
			dreamer.SetSymbolAffinity("TransformationMarkers", 0.3)  ' Beginning transformation
			
		Case "MID_STORY"
			' Mid-story adjustments after key events
			dreamer.SetSymbolAffinity("ShadowManifestations", 0.7)  ' Increased awareness
			dreamer.SetSymbolAffinity("TransformationMarkers", 0.6)  ' Ongoing transformation
			
		Case "LATE_STORY"
			' Late-story adjustments
			dreamer.SetSymbolAffinity("ShadowManifestations", 0.9)  ' Full awareness
			dreamer.SetSymbolAffinity("TransformationMarkers", 0.9)  ' Advanced transformation
	End
	
	' Process specific story events that affect dream interpretation
	For Local event:StoryEvent = EachIn events
		ProcessEventEffect(dreamer, event)
	Next
End

Function ProcessEventEffect:Void(dreamer:DreamerProfile, event:StoryEvent)
	' Example: If character experienced a betrayal
	If event.type = "Betrayal"
		dreamer.SetSymbolAffinity("ReflectiveSurfaces", 0.9)  ' Increased reflection
		dreamer.psychologicalTraits.Set("Trust", Max(0.0, dreamer.GetTraitValue("Trust") - 0.2))  ' Decreased trust
		
		' Add new rule for mirror interpretation reflecting betrayal
		Local betrayalRule:CustomInterpretationRule = New CustomInterpretationRule(
			"ReflectiveSurfaces",
			20,  ' High priority to override default
			lambda:Bool(symbol:SymbolMetadata, profile:DreamerProfile)
				Return symbol.symbolType = "ReflectiveSurfaces" And profile = dreamer
			End,
			lambda:String(symbol:SymbolMetadata, profile:DreamerProfile)
				Return "a mirror showing both true and false reflections, making it difficult to discern reality from deception"
			End
		)
		
		dreamer.interpretationRules.AddRule(betrayalRule)
	EndIf
End
```

This allows dream content to evolve as characters experience significant narrative events.

### 4. Gameplay Integration Possibilities

The framework supports diverse gameplay implementations:

```wonkey
' Dream crafting gameplay example
Function DreamCraftingGameplay:Void(player:Player, dreamer:DreamerProfile, availableSymbols:DreamImageAsset[])
	' Player selects symbols to combine
	Local selectedSymbols:DreamImageAsset[] = PlayerSelectSymbols(player, availableSymbols, 3)
	
	' Calculate coherence
	Local coherenceScore:Float = CalculateDreamCoherence(selectedSymbols, dreamer)
	
	' Generate dream narrative
	Local dreamNarrative:String = GenerateDreamNarrative(selectedSymbols, dreamer)
	
	' Apply gameplay effects based on coherence
	If coherenceScore >= 0.8
		' High coherence: Strong positive effects
		ApplyDreamEffect(dreamer, "DeepInsight", 0.3)
		DisplayFeedback("This dream resonates deeply with " + dreamer.name)
	ElseIf coherenceScore >= 0.5
		' Medium coherence: Moderate effects
		ApplyDreamEffect(dreamer, "MildInsight", 0.1)
		DisplayFeedback("This dream somewhat connects with " + dreamer.name)
	Else
		' Low coherence: Minimal or negative effects
		ApplyDreamEffect(dreamer, "Confusion", 0.1)
		DisplayFeedback("This dream feels disconnected from " + dreamer.name + "'s experiences")
	EndIf
	
	' Display the dream to the player
	DisplayDreamSequence(dreamNarrative, selectedSymbols)
End

' Apply gameplay effects from dreams
Function ApplyDreamEffect:Void(dreamer:DreamerProfile, effectType:String, magnitude:Float)
	Select effectType
		Case "DeepInsight"
			' Gameplay effect: Character gains understanding about their situation
			IncreaseStat(dreamer, "Self-awareness", magnitude)
			UnlockNewDialogueOptions(dreamer)
			
		Case "MildInsight"
			' Smaller positive effect
			IncreaseStat(dreamer, "Self-awareness", magnitude * 0.5)
			
		Case "Confusion"
			' Negative effect: Character becomes somewhat disoriented
			DecreaseStat(dreamer, "Focus", magnitude)
	End
End
```

This enables dreams to function as both narrative devices and gameplay mechanics that affect character development.
