# Dream Symbol Library & Dreamer Profile Generator
*Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v1.2*

## Purpose
This module provides a comprehensive dream symbol library and dreamer profile generation system for the Fox narrative universe. It extracts symbolic elements (qualia) from character dreams and creates a structured framework for procedurally generating psychologically consistent dream content that aligns with character archetypes and narrative progression.

## Functionality
- 130 categorized dream symbols with metadata structure
- Hierarchical organization of dream symbol categories
- Character-specific dreamer profiles with psychological trait mappings
- Dynamic compatibility matrices for symbol interactions
- Symbol affinity scoring based on character psychology
- Dream coherence calculation framework
- Extensible rule-based interpretation system
- Support for dream pattern recognition across character dreams
- Runtime registration of new symbol categories and instances
- Data-driven architecture for modular extension

## Dream Symbol Library Implementation

```monkey2
' DreamSymbolLibrary.monkey2
' Dream Symbol Library & Dreamer Profile Generator
' Implementation by iDkP from GaragePixel - 2025-04-13

Namespace fox.dreams

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

' ===================================================
' DREAM SYMBOL BASE STRUCTURES
' ===================================================

' Base class for dream symbols
Class DreamSymbol
	Field id:String
	Field category:String
	Field subcategory:String
	Field name:String
	Field description:String
	Field intensity:Float       ' 0.0 to 1.0
	Field emotionalTone:String
	Field psychologicalAssociations:String[]
	Field narrativePhases:String[]
	Field visualTraits:String[]
	
	Method New(id:String, category:String, name:String)
		Self.id = id
		Self.category = category
		Self.subcategory = ""
		Self.name = name
		Self.description = ""
		Self.intensity = 0.5
		Self.emotionalTone = ""
		Self.psychologicalAssociations = New String[0]
		Self.narrativePhases = New String[0] 
		Self.visualTraits = New String[0]
	End
	
	Method WithSubcategory:DreamSymbol(subcategory:String)
		Self.subcategory = subcategory
		Return Self
	End
	
	Method WithDescription:DreamSymbol(desc:String)
		Self.description = desc
		Return Self
	End
	
	Method WithEmotionalTone:DreamSymbol(tone:String)
		Self.emotionalTone = tone
		Return Self
	End
	
	Method WithIntensity:DreamSymbol(intensity:Float)
		Self.intensity = Max(0.0, Min(1.0, intensity))
		Return Self
	End
	
	Method AddPsychologicalAssociation:DreamSymbol(association:String)
		Self.psychologicalAssociations = Self.psychologicalAssociations.Resize(Self.psychologicalAssociations.Length + 1)
		Self.psychologicalAssociations[Self.psychologicalAssociations.Length - 1] = association
		Return Self
	End
	
	Method AddNarrativePhase:DreamSymbol(phase:String)
		Self.narrativePhases = Self.narrativePhases.Resize(Self.narrativePhases.Length + 1)
		Self.narrativePhases[Self.narrativePhases.Length - 1] = phase
		Return Self
	End
	
	Method AddVisualTrait:DreamSymbol(trait:String)
		Self.visualTraits = Self.visualTraits.Resize(Self.visualTraits.Length + 1)
		Self.visualTraits[Self.visualTraits.Length - 1] = trait
		Return Self
	End
End

' Symbol category definition
Class SymbolCategory
	Field id:String
	Field name:String
	Field description:String
	Field parentCategory:String
	Field psychologicalAssociations:String[]
	Field commonEmotions:String[]
	
	Method New(id:String, name:String, description:String)
		Self.id = id
		Self.name = name
		Self.description = description
		Self.parentCategory = ""
		Self.psychologicalAssociations = New String[0]
		Self.commonEmotions = New String[0]
	End
	
	Method WithParentCategory:SymbolCategory(parentId:String)
		Self.parentCategory = parentId
		Return Self
	End
	
	Method AddPsychologicalAssociation:SymbolCategory(association:String)
		Self.psychologicalAssociations = Self.psychologicalAssociations.Resize(Self.psychologicalAssociations.Length + 1)
		Self.psychologicalAssociations[Self.psychologicalAssociations.Length - 1] = association
		Return Self
	End
	
	Method AddCommonEmotion:SymbolCategory(emotion:String)
		Self.commonEmotions = Self.commonEmotions.Resize(Self.commonEmotions.Length + 1)
		Self.commonEmotions[Self.commonEmotions.Length - 1] = emotion
		Return Self
	End
End

' Symbol compatibility matrix
Class CompatibilityMatrix
	Field compatibilities:StringMap<StringMap<Float>>
	
	Method New()
		Self.compatibilities = New StringMap<StringMap<Float>>
	End
	
	Method SetCompatibility:Void(category1:String, category2:String, score:Float)
		' Ensure maps exist
		If Not Self.compatibilities.Contains(category1)
			Self.compatibilities.Set(category1, New StringMap<Float>)
		Endif
		
		' Set compatibility both ways for symmetrical lookup
		Self.compatibilities.Get(category1).Set(category2, score)
		
		' Mirror for reverse lookup
		If Not Self.compatibilities.Contains(category2)
			Self.compatibilities.Set(category2, New StringMap<Float>)
		Endif
		Self.compatibilities.Get(category2).Set(category1, score)
	End
	
	Method GetCompatibility:Float(category1:String, category2:String)
		If Self.compatibilities.Contains(category1)
			Local innerMap:StringMap<Float> = Self.compatibilities.Get(category1)
			If innerMap.Contains(category2)
				Return innerMap.Get(category2)
			Endif
		Endif
		
		Return 0.5  ' Default medium compatibility
	End
End

' ===================================================
' DREAMER PROFILE SYSTEM
' ===================================================

' Dreamer profile for character-specific dream interpretation
Class DreamerProfile
	Field id:String
	Field name:String
	Field description:String
	Field symbolAffinities:StringMap<Float>
	Field psychologicalTraits:StringMap<Float>
	Field dominantCategories:String[]
	Field interpretationRules:InterpretationRuleSet
	
	Method New(id:String, name:String, description:String)
		Self.id = id
		Self.name = name
		Self.description = description
		Self.symbolAffinities = New StringMap<Float>
		Self.psychologicalTraits = New StringMap<Float>
		Self.dominantCategories = New String[0]
		Self.interpretationRules = New InterpretationRuleSet()
	End
	
	Method SetSymbolAffinity:Void(symbolType:String, affinity:Float)
		Self.symbolAffinities.Set(symbolType, Max(0.0, Min(1.0, affinity)))
	End
	
	Method GetSymbolAffinity:Float(symbolType:String)
		If Self.symbolAffinities.Contains(symbolType)
			Return Self.symbolAffinities.Get(symbolType)
		Endif
		Return 0.2  ' Default minimal affinity
	End
	
	Method SetTrait:Void(trait:String, value:Float)
		Self.psychologicalTraits.Set(trait, Max(0.0, Min(1.0, value)))
	End
	
	Method GetTraitValue:Float(trait:String, defaultValue:Float = 0.0)
		If Self.psychologicalTraits.Contains(trait)
			Return Self.psychologicalTraits.Get(trait)
		Endif
		
		Return defaultValue
	End
	
	Method AddDominantCategory:Void(category:String)
		Self.dominantCategories = Self.dominantCategories.Resize(Self.dominantCategories.Length + 1)
		Self.dominantCategories[Self.dominantCategories.Length - 1] = category
	End
	
	Method AddInterpretationRule:Void(rule:InterpretationRule)
		Self.interpretationRules.AddRule(rule)
	End
	
	Method GetInterpretation:String(symbol:DreamSymbol)
		Return Self.interpretationRules.Apply(symbol, Self)
	End
End

' ===================================================
' INTERPRETATION RULE SYSTEM
' ===================================================

' Rule set container for dream interpretation
Class InterpretationRuleSet
	Field rules:List<InterpretationRule>
	
	Method New()
		Self.rules = New List<InterpretationRule>
	End
	
	Method AddRule:Void(rule:InterpretationRule)
		Self.rules.AddLast(rule)
	End
	
	Method Apply:String(symbol:DreamSymbol, dreamer:DreamerProfile)
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
		Return "a " + symbol.name
	End
End

' Abstract interpretation rule
Class InterpretationRule
	Field id:String
	Field priority:Int
	
	Method New(id:String, priority:Int)
		Self.id = id
		Self.priority = priority
	End
	
	Method Matches:Bool(symbol:DreamSymbol, dreamer:DreamerProfile) Abstract
	
	Method Apply:String(symbol:DreamSymbol, dreamer:DreamerProfile) Abstract
End

' Category-based interpretation rule
Class CategoryRule Extends InterpretationRule
	Field category:String
	Field interpretationTemplate:String
	
	Method New(id:String, priority:Int, category:String, template:String)
		Super.New(id, priority)
		Self.category = category
		Self.interpretationTemplate = template
	End
	
	Method Matches:Bool(symbol:DreamSymbol, dreamer:DreamerProfile) Override
		Return symbol.category = Self.category
	End
	
	Method Apply:String(symbol:DreamSymbol, dreamer:DreamerProfile) Override
		Local result:String = Self.interpretationTemplate
		result = result.Replace("{symbol}", symbol.name)
		result = result.Replace("{dreamer}", dreamer.name)
		Return result
	End
End

' Character-specific interpretation rule
Class CharacterSpecificRule Extends InterpretationRule
	Field category:String
	Field dreamerID:String
	Field interpretationTemplate:String
	
	Method New(id:String, priority:Int, category:String, dreamerID:String, template:String)
		Super.New(id, priority)
		Self.category = category
		Self.dreamerID = dreamerID
		Self.interpretationTemplate = template
	End
	
	Method Matches:Bool(symbol:DreamSymbol, dreamer:DreamerProfile) Override
		Return symbol.category = Self.category And dreamer.id = Self.dreamerID
	End
	
	Method Apply:String(symbol:DreamSymbol, dreamer:DreamerProfile) Override
		Local result:String = Self.interpretationTemplate
		result = result.Replace("{symbol}", symbol.name)
		result = result.Replace("{dreamer}", dreamer.name)
		Return result
	End
End

' Combined symbol rule for emergent interpretations
Class CombinedSymbolRule Extends InterpretationRule
	Field primaryCategory:String
	Field secondaryCategory:String
	Field interpretationTemplate:String
	
	Method New(id:String, priority:Int, primary:String, secondary:String, template:String)
		Super.New(id, priority)
		Self.primaryCategory = primary
		Self.secondaryCategory = secondary
		Self.interpretationTemplate = template
	End
	
	Method Matches:Bool(symbol:DreamSymbol, dreamer:DreamerProfile) Override
		' This rule is applied differently - in a dream combination context
		' For individual symbol matching:
		Return symbol.category = Self.primaryCategory
	End
	
	Method Apply:String(symbol:DreamSymbol, dreamer:DreamerProfile) Override
		Local result:String = Self.interpretationTemplate
		result = result.Replace("{symbol}", symbol.name)
		result = result.Replace("{dreamer}", dreamer.name)
		Return result
	End
End

' ===================================================
' DREAM SYMBOL REGISTRY
' ===================================================

' Main registry for dream symbols and categories
Class DreamSymbolRegistry
	Field symbols:StringMap<DreamSymbol>
	Field categories:StringMap<SymbolCategory>
	Field compatibility:CompatibilityMatrix
	
	Method New()
		Self.symbols = New StringMap<DreamSymbol>
		Self.categories = New StringMap<SymbolCategory>
		Self.compatibility = New CompatibilityMatrix()
	End
	
	Method AddSymbol:Void(symbol:DreamSymbol)
		Self.symbols.Set(symbol.id, symbol)
	End
	
	Method AddCategory:Void(category:SymbolCategory)
		Self.categories.Set(category.id, category)
	End
	
	Method GetSymbol:DreamSymbol(id:String)
		If Self.symbols.Contains(id)
			Return Self.symbols.Get(id)
		Endif
		Return Null
	End
	
	Method GetCategory:SymbolCategory(id:String)
		If Self.categories.Contains(id)
			Return Self.categories.Get(id)
		Endif
		Return Null
	End
	
	Method GetSymbolsByCategory:DreamSymbol[](categoryID:String)
		Local matches:List<DreamSymbol> = New List<DreamSymbol>
		
		For Local symbol:DreamSymbol = EachIn Self.symbols.Values()
			If symbol.category = categoryID
				matches.AddLast(symbol)
			Endif
		Next
		
		Local result:DreamSymbol[] = New DreamSymbol[matches.Count()]
		Local index:Int = 0
		
		For Local symbol:DreamSymbol = EachIn matches
			result[index] = symbol
			index += 1
		Next
		
		Return result
	End
	
	Method SetCompatibility:Void(category1:String, category2:String, score:Float)
		Self.compatibility.SetCompatibility(category1, category2, score)
	End
	
	Method GetCompatibility:Float(category1:String, category2:String)
		Return Self.compatibility.GetCompatibility(category1, category2)
	End
End

' ===================================================
' DREAM GENERATOR SYSTEM
' ===================================================

' Dream assembly result
Class DreamAssembly
	Field dreamer:DreamerProfile
	Field symbols:DreamSymbol[]
	Field narrative:String
	Field coherenceScore:Float
	
	Method New(dreamer:DreamerProfile, symbols:DreamSymbol[])
		Self.dreamer = dreamer
		Self.symbols = symbols
		Self.narrative = ""
		Self.coherenceScore = 0.0
	End
End

' Dream generator using combinatorial rules
Class DreamGenerator
	Field registry:DreamSymbolRegistry
	Field dreamers:StringMap<DreamerProfile>
	
	Method New(registry:DreamSymbolRegistry)
		Self.registry = registry
		Self.dreamers = New StringMap<DreamerProfile>
	End
	
	Method AddDreamerProfile:Void(dreamer:DreamerProfile)
		Self.dreamers.Set(dreamer.id, dreamer)
	End
	
	Method GetDreamer:DreamerProfile(id:String)
		If Self.dreamers.Contains(id)
			Return Self.dreamers.Get(id)
		Endif
		Return Null
	End
	
	Method AssembleDream:DreamAssembly(dreamerID:String, symbolIDs:String[])
		Local dreamer:DreamerProfile = Self.GetDreamer(dreamerID)
		
		If dreamer = Null Return Null
		
		' Convert IDs to symbols
		Local symbols:DreamSymbol[] = New DreamSymbol[symbolIDs.Length]
		For Local i:Int = 0 Until symbolIDs.Length
			symbols[i] = Self.registry.GetSymbol(symbolIDs[i])
		Next
		
		' Create assembly
		Local assembly:DreamAssembly = New DreamAssembly(dreamer, symbols)
		
		' Calculate coherence
		assembly.coherenceScore = Self.CalculateCoherence(symbols, dreamer)
		
		' Generate narrative
		assembly.narrative = Self.GenerateNarrative(symbols, dreamer)
		
		Return assembly
	End
	
	Method CalculateCoherence:Float(symbols:DreamSymbol[], dreamer:DreamerProfile)
		' Component scores
		Local affinityScore:Float = 0.0
		Local compatibilityScore:Float = 0.0
		Local emotionalScore:Float = 0.0
		Local psychologicalScore:Float = 0.0
		
		' Calculate character affinity (40% weight)
		For Local i:Int = 0 Until symbols.Length
			affinityScore += dreamer.GetSymbolAffinity(symbols[i].category)
		Next
		affinityScore = affinityScore / symbols.Length
		
		' Calculate symbol compatibility (30% weight)
		If symbols.Length > 1
			Local pairsCount:Int = 0
			For Local i:Int = 0 Until symbols.Length
				For Local j:Int = i + 1 Until symbols.Length
					compatibilityScore += Self.registry.GetCompatibility(
						symbols[i].category, 
						symbols[j].category
					)
					pairsCount += 1
				Next
			Next
			If pairsCount > 0
				compatibilityScore /= pairsCount
			Endif
		Else
			compatibilityScore = 1.0  ' Single symbol is always compatible with itself
		Endif
		
		' Calculate emotional consistency (15% weight)
		Local emotionCounts:StringMap<Int> = New StringMap<Int>
		Local totalEmotions:Int = 0
		
		For Local i:Int = 0 Until symbols.Length
			Local emotion:String = symbols[i].emotionalTone
			If emotion <> ""
				totalEmotions += 1
				If emotionCounts.Contains(emotion)
					emotionCounts.Set(emotion, emotionCounts.Get(emotion) + 1)
				Else
					emotionCounts.Set(emotion, 1)
				Endif
			Endif
		Next
		
		If totalEmotions > 0
			Local dominantCount:Int = 0
			For Local count:Int = EachIn emotionCounts.Values()
				If count > dominantCount
					dominantCount = count
				Endif
			Next
			emotionalScore = Float(dominantCount) / totalEmotions
		Else
			emotionalScore = 1.0  ' No emotions specified, assume consistent
		Endif
		
		' Calculate psychological relevance (15% weight)
		Local relevantAssociations:Int = 0
		Local totalAssociations:Int = 0
		
		For Local i:Int = 0 Until symbols.Length
			For Local assoc:String = EachIn symbols[i].psychologicalAssociations
				totalAssociations += 1
				If dreamer.GetTraitValue(assoc) > 0.5
					relevantAssociations += 1
				Endif
			Next
		Next
		
		If totalAssociations > 0
			psychologicalScore = Float(relevantAssociations) / totalAssociations
		Else
			psychologicalScore = 0.5  ' No associations specified, assume medium relevance
		Endif
		
		' Calculate weighted total
		Return (affinityScore * 0.4) + (compatibilityScore * 0.3) + 
			   (emotionalScore * 0.15) + (psychologicalScore * 0.15)
	End
	
	Method GenerateNarrative:String(symbols:DreamSymbol[], dreamer:DreamerProfile)
		' Base narrative structure
		Local narrative:String = dreamer.name + " dreams of "
		
		' Add individual symbol interpretations
		For Local i:Int = 0 Until symbols.Length
			If i > 0 And i < symbols.Length - 1
				narrative += ", "
			Elseif i > 0
				narrative += " and "
			Endif
			
			narrative += dreamer.GetInterpretation(symbols[i])
		Next
		
		narrative += "."
		
		' Add emotional context
		Local emotions:StringSet = New StringSet
		For Local symbol:DreamSymbol = EachIn symbols
			If symbol.emotionalTone <> ""
				emotions.Insert(symbol.emotionalTone.ToLower())
			Endif
		Next
		
		If emotions.Count() > 0
			narrative += " The dream evokes feelings of "
			
			Local index:Int = 0
			For Local emotion:String = EachIn emotions
				If index > 0 And index < emotions.Count() - 1
					narrative += ", "
				Elseif index > 0
					narrative += " and "
				Endif
				
				narrative += emotion
				index += 1
			Next
			
			narrative += "."
		Endif
		
		' Add character-specific psychological context
		Select dreamer.id
			Case "hikari"
				narrative += " The images reflect her evolving dual nature between human and yokai."
			Case "katsuo"
				narrative += " The dream connects his ancient memories with present experiences."
			Case "megumi"
				narrative += " The symbols reveal her struggle between social control and genuine connection."
			Case "akane"
				narrative += " The dream highlights her role as observer and protector at the boundary of worlds."
		End
		
		Return narrative
	End
End

' ===================================================
' POPULATE SYMBOL REGISTRY
' ===================================================

' Initialize dream symbol library
Function InitDreamSymbolLibrary:DreamSymbolRegistry()
	Local registry:DreamSymbolRegistry = New DreamSymbolRegistry()
	
	' Register categories
	RegisterBaseCategories(registry)
	
	' Register symbols
	RegisterTransformationSymbols(registry)
	RegisterReflectionSymbols(registry)
	RegisterShadowSymbols(registry)
	RegisterArchitecturalSymbols(registry)
	RegisterNaturalElementSymbols(registry)
	RegisterTemporalSymbols(registry)
	RegisterSocialSymbols(registry)
	RegisterBodySymbols(registry)
	RegisterPursuitSymbols(registry)
	RegisterVerticalSymbols(registry)
	RegisterAnimalSymbols(registry)
	RegisterYokaiSpecificSymbols(registry)
	RegisterObjectSymbols(registry)
	
	' Register compatibilities
	RegisterCompatibilityMatrix(registry)
	
	Return registry
End

' Register base symbol categories
Function RegisterBaseCategories:Void(registry:DreamSymbolRegistry)
	' Main categories
	registry.AddCategory(New SymbolCategory("transformation", "Transformation", "Symbols of change and evolution")
		.AddPsychologicalAssociation("Change")
		.AddPsychologicalAssociation("Identity")
		.AddCommonEmotion("Anxiety")
		.AddCommonEmotion("Wonder"))
	
	registry.AddCategory(New SymbolCategory("reflection", "Reflective Surfaces", "Mirrors and reflective elements")
		.AddPsychologicalAssociation("Self-awareness")
		.AddPsychologicalAssociation("Identity")
		.AddCommonEmotion("Revelation")
		.AddCommonEmotion("Uncertainty"))
	
	registry.AddCategory(New SymbolCategory("shadow", "Shadow Manifestations", "Shadow-based symbols")
		.AddPsychologicalAssociation("Hidden self")
		.AddPsychologicalAssociation("Unconscious")
		.AddCommonEmotion("Fear")
		.AddCommonEmotion("Mystery"))
	
	registry.AddCategory(New SymbolCategory("architectural", "Architectural Spaces", "Buildings and constructed environments")
		.AddPsychologicalAssociation("Social structures")
		.AddPsychologicalAssociation("Personal boundaries")
		.AddCommonEmotion("Confinement")
		.AddCommonEmotion("Security"))
	
	registry.AddCategory(New SymbolCategory("natural", "Natural Elements", "Nature and elemental symbols")
		.AddPsychologicalAssociation("Primal forces")
		.AddPsychologicalAssociation("Authentic self")
		.AddCommonEmotion("Freedom")
		.AddCommonEmotion("Connection"))
	
	registry.AddCategory(New SymbolCategory("temporal", "Temporal Distortions", "Time-related symbols")
		.AddPsychologicalAssociation("Memory")
		.AddPsychologicalAssociation("Aging")
		.AddCommonEmotion("Nostalgia")
		.AddCommonEmotion("Anticipation"))
	
	registry.AddCategory(New SymbolCategory("social", "Social Interactions", "Relationships and social dynamics")
		.AddPsychologicalAssociation("Connection")
		.AddPsychologicalAssociation("Status")
		.AddCommonEmotion("Belonging")
		.AddCommonEmotion("Isolation"))
	
	registry.AddCategory(New SymbolCategory("body", "Body Transformations", "Physical body changes")
		.AddPsychologicalAssociation("Self-image")
		.AddPsychologicalAssociation("Vulnerability")
		.AddCommonEmotion("Discomfort")
		.AddCommonEmotion("Liberation"))
	
	registry.AddCategory(New SymbolCategory("pursuit", "Pursuit & Chase", "Being chased or pursuing")
		.AddPsychologicalAssociation("Avoidance")
		.AddPsychologicalAssociation("Desire")
		.AddCommonEmotion("Fear")
		.AddCommonEmotion("Urgency"))
	
	registry.AddCategory(New SymbolCategory("vertical", "Vertical Movement", "Rising, falling, flying")
		.AddPsychologicalAssociation("Status")
		.AddPsychologicalAssociation("Control")
		.AddCommonEmotion("Exhilaration")
		.AddCommonEmotion("Fear"))
	
	registry.AddCategory(New SymbolCategory("animal", "Animal Symbols", "Animal representations")
		.AddPsychologicalAssociation("Instinct")
		.AddPsychologicalAssociation("Character traits")
		.AddCommonEmotion("Connection")
		.AddCommonEmotion("Wildness"))
	
	registry.AddCategory(New SymbolCategory("yokai", "Yokai Specific", "Supernatural Japanese elements")
		.AddPsychologicalAssociation("Spirituality")
		.AddPsychologicalAssociation("Mystery")
		.AddCommonEmotion("Awe")
		.AddCommonEmotion("Unease"))
	
	registry.AddCategory(New SymbolCategory("object", "Symbolic Objects", "Items with symbolic meaning")
		.AddPsychologicalAssociation("Tools")
		.AddPsychologicalAssociation("Resources")
		.AddCommonEmotion("Utility")
		.AddCommonEmotion("Value"))
	
	' Add subcategories
	registry.AddCategory(New SymbolCategory("partial_transform", "Partial Transformation", "Incomplete metamorphosis")
		.WithParentCategory("transformation")
		.AddPsychologicalAssociation("Transition")
		.AddCommonEmotion("Confusion"))
	
	registry.AddCategory(New SymbolCategory("elemental_transform", "Elemental Transformation", "Changing physical state")
		.WithParentCategory("transformation")
		.AddPsychologicalAssociation("Fundamental change")
		.AddCommonEmotion("Awe"))
	
	registry.AddCategory(New SymbolCategory("true_mirror", "Truth Mirrors", "Mirrors showing true nature")
		.WithParentCategory("reflection")
		.AddPsychologicalAssociation("Authenticity")
		.AddCommonEmotion("Recognition"))
	
	registry.AddCategory(New SymbolCategory("distortion_mirror", "Distortion Mirrors", "Mirrors showing distorted self")
		.WithParentCategory("reflection")
		.AddPsychologicalAssociation("Self-deception")
		.AddCommonEmotion("Disorientation"))
	
	registry.AddCategory(New SymbolCategory("split_shadow", "Split Shadows", "Shadows dividing or multiplying")
		.WithParentCategory("shadow")
		.AddPsychologicalAssociation("Duality")
		.AddCommonEmotion("Fragmentation"))
	
	registry.AddCategory(New SymbolCategory("animated_shadow", "Animated Shadows", "Shadows with independent movement")
		.WithParentCategory("shadow")
		.AddPsychologicalAssociation("Autonomy")
		.AddCommonEmotion("Unease"))
	
	' And so on for other subcategories... (abbreviated for clarity)
End

' Register transformation symbols
Function RegisterTransformationSymbols:Void(registry:DreamSymbolRegistry)
	' Partial transformations
	registry.AddSymbol(New DreamSymbol("fox_ears", "partial_transform", "fox ears")
		.WithDescription("Human with fox ears appearing")
		.WithEmotionalTone("Surprise")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Duality")
		.AddPsychologicalAssociation("Animal nature")
		.AddNarrativePhase("EARLY_TRANSFORMATION")
		.AddVisualTrait("Fuzzy white ears")
		.AddVisualTrait("Twitching movement"))
	
	registry.AddSymbol(New DreamSymbol("fox_tail", "partial_transform", "fox tail")
		.WithDescription("Single fox tail manifesting")
		.WithEmotionalTone("Wonder")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Hidden power")
		.AddPsychologicalAssociation("True nature")
		.AddNarrativePhase("MID_TRANSFORMATION")
		.AddVisualTrait("Fluffy white tail")
		.AddVisualTrait("Swaying movement"))
	
	registry.AddSymbol(New DreamSymbol("glowing_eyes", "partial_transform", "glowing eyes")
		.WithDescription("Eyes transforming to glow with yokai energy")
		.WithEmotionalTone("Power")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Inner sight")
		.AddPsychologicalAssociation("Supernatural awareness")
		.AddNarrativePhase("ADVANCED_TRANSFORMATION")
		.AddVisualTrait("Blue-gold glow")
		.AddVisualTrait("Vertical pupils"))
	
	registry.AddSymbol(New DreamSymbol("flickering_form", "partial_transform", "flickering form")
		.WithDescription("Body flickering between human and yokai forms")
		.WithEmotionalTone("Confusion")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Unstable identity")
		.AddPsychologicalAssociation("Transition state")
		.AddNarrativePhase("MID_TRANSFORMATION")
		.AddVisualTrait("Transparent overlay")
		.AddVisualTrait("Rapid shifting"))
	
	' Complete transformations
	registry.AddSymbol(New DreamSymbol("full_kitsune", "transformation", "complete fox form")
		.WithDescription("Full transformation into nine-tailed fox")
		.WithEmotionalTone("Revelation")
		.WithIntensity(1.0)
		.AddPsychologicalAssociation("True self")
		.AddPsychologicalAssociation("Spiritual power")
		.AddNarrativePhase("COMPLETE_TRANSFORMATION")
		.AddVisualTrait("Radiant white fur")
		.AddVisualTrait("Multiple flowing tails"))
	
	registry.AddSymbol(New DreamSymbol("human_kitsune_hybrid", "transformation", "human-fox hybrid")
		.WithDescription("Balanced form with aspects of both human and kitsune")
		.WithEmotionalTone("Harmony")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Integration")
		.AddPsychologicalAssociation("Balance")
		.AddNarrativePhase("CLIMAX")
		.AddVisualTrait("Human form with multiple tails")
		.AddVisualTrait("Fox features on human face"))
	
	' Elemental transformations
	registry.AddSymbol(New DreamSymbol("foxfire_aura", "elemental_transform", "blue foxfire aura")
		.WithDescription("Body surrounded by spiritual blue flame")
		.WithEmotionalTone("Power")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Spiritual energy")
		.AddPsychologicalAssociation("Otherworldly power")
		.AddNarrativePhase("POWER_MANIFESTATION")
		.AddVisualTrait("Ethereal blue flames")
		.AddVisualTrait("Dancing light patterns"))
	
	registry.AddSymbol(New DreamSymbol("dissolving_into_petals", "elemental_transform", "dissolving into cherry blossoms")
		.WithDescription("Body dispersing into swirling cherry petals")
		.WithEmotionalTone("Transcendence")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Impermanence")
		.AddPsychologicalAssociation("Spiritual transition")
		.AddNarrativePhase("TRANSFORMATION")
		.AddVisualTrait("Pink petal swirl")
		.AddVisualTrait("Partial transparency"))
	
	' And more transformation symbols...
End

' Register shadow symbols
Function RegisterShadowSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("split_human_fox_shadow", "split_shadow", "split human-fox shadow")
		.WithDescription("Shadow dividing into human and fox forms")
		.WithEmotionalTone("Confusion")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Duality")
		.AddPsychologicalAssociation("Hidden nature")
		.AddNarrativePhase("EARLY_STORY")
		.AddVisualTrait("Diverging shadows")
		.AddVisualTrait("Different movement patterns"))
	
	registry.AddSymbol(New DreamSymbol("shadow_with_tails", "split_shadow", "shadow with multiple tails")
		.WithDescription("Human shadow revealing multiple fox tails")
		.WithEmotionalTone("Revelation")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Hidden power")
		.AddPsychologicalAssociation("True identity")
		.AddNarrativePhase("MID_STORY")
		.AddVisualTrait("Fanlike shadow tails")
		.AddVisualTrait("Independent tail movement"))
	
	registry.AddSymbol(New DreamSymbol("pursuing_shadow", "animated_shadow", "pursuing shadow")
		.WithDescription("Shadow chasing the dreamer independently")
		.WithEmotionalTone("Fear")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Rejected aspects")
		.AddPsychologicalAssociation("Unconscious pursuit")
		.AddNarrativePhase("CONFLICT")
		.AddVisualTrait("Elongated dark form")
		.AddVisualTrait("Reaching shadow hands"))
	
	registry.AddSymbol(New DreamSymbol("shadow_guide", "animated_shadow", "guiding shadow")
		.WithDescription("Shadow moving ahead to show the way")
		.WithEmotionalTone("Guidance")
		.WithIntensity(0.6)
		.AddPsychologicalAssociation("Intuition")
		.AddPsychologicalAssociation("Inner wisdom")
		.AddNarrativePhase("REVELATION")
		.AddVisualTrait("Beckoning shadow form")
		.AddVisualTrait("Path illumination"))
	
	' And more shadow symbols...
End

' Register reflection symbols
Function RegisterReflectionSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("truth_mirror", "true_mirror", "truth-revealing mirror")
		.WithDescription("Mirror showing true yokai nature")
		.WithEmotionalTone("Revelation")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Self-discovery")
		.AddPsychologicalAssociation("Hidden truth")
		.AddNarrativePhase("REVELATION")
		.AddVisualTrait("Ornate ancient frame")
		.AddVisualTrait("Glowing surface"))
	
	registry.AddSymbol(New DreamSymbol("empty_mirror", "true_mirror", "mirror without reflection")
		.WithDescription("Mirror showing empty space where reflection should be")
		.WithEmotionalTone("Existential")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Identity crisis")
		.AddPsychologicalAssociation("Transitional state")
		.AddNarrativePhase("TRANSFORMATION")
		.AddVisualTrait("Void within frame")
		.AddVisualTrait("Rippling surface"))
	
	registry.AddSymbol(New DreamSymbol("multiplying_reflections", "distortion_mirror", "multiplying reflections")
		.WithDescription("Mirror showing many versions of self simultaneously")
		.WithEmotionalTone("Fragmentation")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Multiple selves")
		.AddPsychologicalAssociation("Identity confusion")
		.AddNarrativePhase("IDENTITY_CRISIS")
		.AddVisualTrait("Fractured mirror surface")
		.AddVisualTrait("Slightly different expressions"))
	
	registry.AddSymbol(New DreamSymbol("historical_reflections", "distortion_mirror", "historical reflections")
		.WithDescription("Mirror showing self across different time periods")
		.WithEmotionalTone("Nostalgia")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Past lives")
		.AddPsychologicalAssociation("Continuity of self")
		.AddNarrativePhase("MEMORY")
		.AddVisualTrait("Aging/changing clothing")
		.AddVisualTrait("Period-appropriate contexts"))
	
	registry.AddSymbol(New DreamSymbol("rippling_water_reflection", "reflection", "rippling water reflection")
		.WithDescription("Distorted self-image in moving water")
		.WithEmotionalTone("Uncertainty")
		.WithIntensity(0.6)
		.AddPsychologicalAssociation("Emotional turbulence")
		.AddPsychologicalAssociation("Shifting perception")
		.AddNarrativePhase("CONFUSION")
		.AddVisualTrait("Water ripple effects")
		.AddVisualTrait("Moonlight illumination"))
	
	' And more reflection symbols...
End

' Register architectural symbols
Function RegisterArchitecturalSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("endless_school_hallway", "architectural", "endless school hallway")
		.WithDescription("School corridor that stretches impossibly long")
		.WithEmotionalTone("Anxiety")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Educational pressure")
		.AddPsychologicalAssociation("Social navigation")
		.AddNarrativePhase("SCHOOL_LIFE")
		.AddVisualTrait("Vanishing point perspective")
		.AddVisualTrait("Flickering fluorescent lights"))
	
	registry.AddSymbol(New DreamSymbol("ancient_shrine", "architectural", "ancient shrine")
		.WithDescription("Traditional Japanese shrine with spiritual significance")
		.WithEmotionalTone("Reverence")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Spiritual heritage")
		.AddPsychologicalAssociation("Sacred boundaries")
		.AddNarrativePhase("SPIRITUAL_CONNECTION")
		.AddVisualTrait("Red torii gates")
		.AddVisualTrait("Stone fox guardians"))
	
	registry.AddSymbol(New DreamSymbol("transforming_room", "architectural", "transforming room")
		.WithDescription("Room that shifts between modern and traditional styles")
		.WithEmotionalTone("Disorientation")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Cultural duality")
		.AddPsychologicalAssociation("Temporal shift")
		.AddNarrativePhase("TRANSITION")
		.AddVisualTrait("Morphing architectural elements")
		.AddVisualTrait("Blending decor styles"))
	
	registry.AddSymbol(New DreamSymbol("hidden_door", "architectural", "hidden door")
		.WithDescription("Door appearing where none existed before")
		.WithEmotionalTone("Discovery")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("New opportunities")
		.AddPsychologicalAssociation("Unconscious access")
		.AddNarrativePhase("REVELATION")
		.AddVisualTrait("Glowing outline")
		.AddVisualTrait("Ancient wood and metal"))
	
	registry.AddSymbol(New DreamSymbol("spirit_bridge", "architectural", "spirit bridge")
		.WithDescription("Bridge connecting human and yokai worlds")
		.WithEmotionalTone("Transition")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Crossing boundaries")
		.AddPsychologicalAssociation("Connection between realms")
		.AddNarrativePhase("BRIDGING_WORLDS")
		.AddVisualTrait("Partially transparent structure")
		.AddVisualTrait("Otherworldly glow"))
	
	' And more architectural symbols...
End

' Register natural element symbols
Function RegisterNaturalElementSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("cherry_blossom_storm", "natural", "cherry blossom storm")
		.WithDescription("Swirling tornado of pink cherry petals")
		.WithEmotionalTone("Transformation")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Impermanence")
		.AddPsychologicalAssociation("Beauty in transition")
		.AddNarrativePhase("TRANSFORMATION")
		.AddVisualTrait("Swirling pink petals")
		.AddVisualTrait("Surrounding the dreamer"))
	
	registry.AddSymbol(New DreamSymbol("ancient_forest", "natural", "ancient forest")
		.WithDescription("Primeval Japanese forest with massive trees")
		.WithEmotionalTone("Mystery")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Deep past")
		.AddPsychologicalAssociation("Spiritual roots")
		.AddNarrativePhase("ANCIENT_MEMORY")
		.AddVisualTrait("Moss-covered trees")
		.AddVisualTrait("Filtered spiritual light"))
	
	registry.AddSymbol(New DreamSymbol("red_moon", "natural", "blood-red moon")
		.WithDescription("Unnaturally large crimson moon")
		.WithEmotionalTone("Foreboding")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Impending transformation")
		.AddPsychologicalAssociation("Supernatural influence")
		.AddNarrativePhase("CLIMAX")
		.AddVisualTrait("Enormous size in sky")
		.AddVisualTrait("Blood-red illumination"))
	
	registry.AddSymbol(New DreamSymbol("memory_garden", "natural", "memory garden")
		.WithDescription("Garden with plants representing different life periods")
		.WithEmotionalTone("Nostalgia")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Life timeline")
		.AddPsychologicalAssociation("Growth and change")
		.AddNarrativePhase("REFLECTION")
		.AddVisualTrait("Progressive growth patterns")
		.AddVisualTrait("Time-specific flowers"))
	
	' And more natural element symbols...
End

' Register temporal symbols
Function RegisterTemporalSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("century_desk", "temporal", "century-spanning desk")
		.WithDescription("Desk transforming across historical eras")
		.WithEmotionalTone("Continuity")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Historical perspective")
		.AddPsychologicalAssociation("Immortal witnessing")
		.AddNarrativePhase("KATSUO_REFLECTION")
		.AddVisualTrait("Material evolution")
		.AddVisualTrait("Era-appropriate items"))
	
	registry.AddSymbol(New DreamSymbol("aging_students", "temporal", "rapidly aging students")
		.WithDescription("Classmates aging rapidly while dreamer remains unchanged")
		.WithEmotionalTone("Isolation")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Immortality burden")
		.AddPsychologicalAssociation("Outliving connections")
		.AddNarrativePhase("IMMORTALITY_REFLECTION")
		.AddVisualTrait("Time-lapse aging")
		.AddVisualTrait("Unchanging observer"))
	
	registry.AddSymbol(New DreamSymbol("reverse_time", "temporal", "reverse-flowing time")
		.WithDescription("Events occurring backward, including speech and movement")
		.WithEmotionalTone("Disorientation")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Regret")
		.AddPsychologicalAssociation("Desire to change past")
		.AddNarrativePhase("REGRET")
		.AddVisualTrait("Backward movement")
		.AddVisualTrait("Reversed causality"))
	
	registry.AddSymbol(New DreamSymbol("time_windows", "temporal", "windows into different eras")
		.WithDescription("Portals showing different historical periods simultaneously")
		.WithEmotionalTone("Wonder")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Multiple timeframes")
		.AddPsychologicalAssociation("Historical context")
		.AddNarrativePhase("HISTORICAL_CONNECTION")
		.AddVisualTrait("Floating window frames")
		.AddVisualTrait("Period-accurate scenes"))
	
	' And more temporal symbols...
End

' Register social symbols
Function RegisterSocialSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("status_ledger", "social", "social status ledger")
		.WithDescription("Book recording complex social relationships and standings")
		.WithEmotionalTone("Control")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Social calculation")
		.AddPsychologicalAssociation("Status anxiety")
		.AddNarrativePhase("MEGUMI_CHARACTER")
		.AddVisualTrait("Mathematical formulas")
		.AddVisualTrait("Social network diagrams"))
	
	registry.AddSymbol(New DreamSymbol("invisible_competition", "social", "invisible competition")
		.WithDescription("Contest where participants are judged by unseen criteria")
		.WithEmotionalTone("Inadequacy")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Social comparison")
		.AddPsychologicalAssociation("Hidden judgment")
		.AddNarrativePhase("SOCIAL_ANXIETY")
		.AddVisualTrait("Invisible scorecards")
		.AddVisualTrait("Confused competitors"))
	
	registry.AddSymbol(New DreamSymbol("expectation_crowd", "social", "crowd of expectations")
		.WithDescription("People with speech bubbles showing contradictory demands")
		.WithEmotionalTone("Pressure")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Social expectations")
		.AddPsychologicalAssociation("People pleasing")
		.AddNarrativePhase("SOCIAL_PRESSURE")
		.AddVisualTrait("Overlapping demand bubbles")
		.AddVisualTrait("Pressing inward formation"))
	
	registry.AddSymbol(New DreamSymbol("friend_collection", "social", "friend figurine collection")
		.WithDescription("Relationships represented as collectible figurines")
		.WithEmotionalTone("Control")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Relationship objectification")
		.AddPsychologicalAssociation("Emotional distance")
		.AddNarrativePhase("MEGUMI_CHARACTER")
		.AddVisualTrait("Perfect miniature figures")
		.AddVisualTrait("Display case arrangement"))
	
	' And more social symbols...
End

' Register body symbols
Function RegisterBodySymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("losing_teeth", "body", "losing teeth")
		.WithDescription("Teeth falling out or crumbling")
		.WithEmotionalTone("Vulnerability")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Loss of power")
		.AddPsychologicalAssociation("Communication anxiety")
		.AddNarrativePhase("VULNERABILITY")
		.AddVisualTrait("Teeth falling into hand")
		.AddVisualTrait("Mirror reflection horror"))
	
	registry.AddSymbol(New DreamSymbol("growing_claws", "body", "growing claws")
		.WithDescription("Fingernails transforming into sharp animal claws")
		.WithEmotionalTone("Power")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Aggression potential")
		.AddPsychologicalAssociation("Natural weapons")
		.AddNarrativePhase("TRANSFORMATION")
		.AddVisualTrait("Elongating nails")
		.AddVisualTrait("Hands becoming paw-like"))
	
	registry.AddSymbol(New DreamSymbol("chimeric_integration", "body", "chimeric integration")
		.WithDescription("Human and yokai physical aspects integrating harmoniously")
		.WithEmotionalTone("Harmony")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Identity integration")
		.AddPsychologicalAssociation("Self-acceptance")
		.AddNarrativePhase("RESOLUTION")
		.AddVisualTrait("Glowing integration points")
		.AddVisualTrait("Harmonious hybrid features"))
	
	' And more body symbols...
End

' Register pursuit symbols
Function RegisterPursuitSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("shadow_chase", "pursuit", "shadow pursuit")
		.WithDescription("Being pursued by a dark shadowy entity")
		.WithEmotionalTone("Fear")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Avoidance")
		.AddPsychologicalAssociation("Denied aspects")
		.AddNarrativePhase("DENIAL")
		.AddVisualTrait("Amorphous dark pursuer")
		.AddVisualTrait("Stretching shadow hands"))
	
	registry.AddSymbol(New DreamSymbol("yokai_hunters", "pursuit", "yokai hunters")
		.WithDescription("Being pursued by humans seeking to capture yokai")
		.WithEmotionalTone("Danger")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Exposure fear")
		.AddPsychologicalAssociation("Being hunted for identity")
		.AddNarrativePhase("THREAT")
		.AddVisualTrait("Traditional hunting tools")
		.AddVisualTrait("Paper seals and talismans"))
	
	registry.AddSymbol(New DreamSymbol("pursuing_truth", "pursuit", "pursuing truth")
		.WithDescription("Chasing after an elusive truth or revelation")
		.WithEmotionalTone("Determination")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Knowledge seeking")
		.AddPsychologicalAssociation("Self-discovery journey")
		.AddNarrativePhase("QUEST")
		.AddVisualTrait("Glowing trail to follow")
		.AddVisualTrait("Just-out-of-reach target"))
	
	' And more pursuit symbols...
End

' Register vertical movement symbols
Function RegisterVerticalSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("falling_endlessly", "vertical", "endless falling")
		.WithDescription("Falling through space with no landing in sight")
		.WithEmotionalTone("Helplessness")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Loss of control")
		.AddPsychologicalAssociation("Life upheaval")
		.AddNarrativePhase("CRISIS")
		.AddVisualTrait("Wind-rushing effect")
		.AddVisualTrait("Distant ground never approaching"))
	
	registry.AddSymbol(New DreamSymbol("spiritual_flight", "vertical", "spiritual flight")
		.WithDescription("Flying with spiritual energy rather than wings")
		.WithEmotionalTone("Freedom")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Spiritual elevation")
		.AddPsychologicalAssociation("Transcending limitations")
		.AddNarrativePhase("EMPOWERMENT")
		.AddVisualTrait("Trailing spirit energy")
		.AddVisualTrait("Supernatural perspective"))
	
	registry.AddSymbol(New DreamSymbol("floating_between_worlds", "vertical", "floating between worlds")
		.WithDescription("Suspended between human and yokai realms")
		.WithEmotionalTone("Liminality")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Between states")
		.AddPsychologicalAssociation("Transition")
		.AddNarrativePhase("TRANSFORMATION")
		.AddVisualTrait("Transparent overlapping realms")
		.AddVisualTrait("Gravity-free movement"))
	
	' And more vertical movement symbols...
End

' Register animal symbols
Function RegisterAnimalSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("fox_guide", "animal", "guiding fox")
		.WithDescription("White fox that leads the dreamer")
		.WithEmotionalTone("Guidance")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Spiritual guide")
		.AddPsychologicalAssociation("Intuition")
		.AddNarrativePhase("GUIDANCE")
		.AddVisualTrait("Glowing white fur")
		.AddVisualTrait("Knowing amber eyes"))
	
	registry.AddSymbol(New DreamSymbol("fox_kit", "animal", "fox kit")
		.WithDescription("Small fox cub needing protection")
		.WithEmotionalTone("Nurturing")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Vulnerable aspects")
		.AddPsychologicalAssociation("New potential")
		.AddNarrativePhase("BEGINNING")
		.AddVisualTrait("Small fluffy form")
		.AddVisualTrait("Large questioning eyes"))
	
	registry.AddSymbol(New DreamSymbol("nine_tailed_fox", "animal", "nine-tailed fox")
		.WithDescription("Majestic nine-tailed kitsune in full spiritual power")
		.WithEmotionalTone("Awe")
		.WithIntensity(1.0)
		.AddPsychologicalAssociation("Ultimate potential")
		.AddPsychologicalAssociation("Spiritual completion")
		.AddNarrativePhase("FULFILLMENT")
		.AddVisualTrait("Nine flowing tails")
		.AddVisualTrait("Divine white glow"))
	
	' And more animal symbols...
End

' Register yokai-specific symbols
Function RegisterYokaiSpecificSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("foxfire", "yokai", "fox fire")
		.WithDescription("Mysterious blue flames associated with kitsune")
		.WithEmotionalTone("Mystery")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Spiritual energy")
		.AddPsychologicalAssociation("Illusion power")
		.AddNarrativePhase("POWER_MANIFESTATION")
		.AddVisualTrait("Hovering blue flames")
		.AddVisualTrait("Casting unnatural light"))
	
	registry.AddSymbol(New DreamSymbol("inari_meeting", "yokai", "meeting with Inari")
		.WithDescription("Encounter with the deity of kitsune")
		.WithEmotionalTone("Reverence")
		.WithIntensity(1.0)
		.AddPsychologicalAssociation("Divine guidance")
		.AddPsychologicalAssociation("Spiritual authority")
		.AddNarrativePhase("DIVINE_INTERVENTION")
		.AddVisualTrait("Cosmic vastness")
		.AddVisualTrait("Divine fox form"))
	
	registry.AddSymbol(New DreamSymbol("spirit_world_overlay", "yokai", "spirit world overlay")
		.WithDescription("Spirit world visible overlapping the human world")
		.WithEmotionalTone("Wonder")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Dual perception")
		.AddPsychologicalAssociation("Hidden reality")
		.AddNarrativePhase("AWAKENED_SIGHT")
		.AddVisualTrait("Transparent overlay")
		.AddVisualTrait("Glowing spirit traces"))
	
	' And more yokai symbols...
End

' Register object symbols
Function RegisterObjectSymbols:Void(registry:DreamSymbolRegistry)
	registry.AddSymbol(New DreamSymbol("fox_mask", "object", "fox mask")
		.WithDescription("Traditional Japanese fox mask")
		.WithEmotionalTone("Disguise")
		.WithIntensity(0.7)
		.AddPsychologicalAssociation("Hidden identity")
		.AddPsychologicalAssociation("Public persona")
		.AddNarrativePhase("CONCEALMENT")
		.AddVisualTrait("Painted ceramic")
		.AddVisualTrait("Red markings"))
	
	registry.AddSymbol(New DreamSymbol("spiritual_loom", "object", "spiritual loom")
		.WithDescription("Loom weaving together human and yokai essence")
		.WithEmotionalTone("Integration")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Fate weaving")
		.AddPsychologicalAssociation("Identity creation")
		.AddNarrativePhase("INTEGRATION")
		.AddVisualTrait("Red and blue threads")
		.AddVisualTrait("Moving shuttle"))
	
	registry.AddSymbol(New DreamSymbol("identity_forge", "object", "identity forge")
		.WithDescription("Mystical forge merging different aspects of self")
		.WithEmotionalTone("Transformation")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Self-creation")
		.AddPsychologicalAssociation("Reforging identity")
		.AddNarrativePhase("TRANSFORMATION")
		.AddVisualTrait("Blue-white flames")
		.AddVisualTrait("Merging metals"))
	
	' And more object symbols...
End

' Register compatibility relationships between symbol categories
Function RegisterCompatibilityMatrix:Void(registry:DreamSymbolRegistry)
	' Transformation compatibilities
	registry.SetCompatibility("transformation", "reflection", 0.9)  ' High compatibility
	registry.SetCompatibility("transformation", "shadow", 0.8)
	registry.SetCompatibility("transformation", "body", 0.9)
	registry.SetCompatibility("transformation", "yokai", 0.9)
	
	' Reflection compatibilities
	registry.SetCompatibility("reflection", "shadow", 0.9)
	registry.SetCompatibility("reflection", "social", 0.7)
	registry.SetCompatibility("reflection", "temporal", 0.8)
	
	```monkey2
	' Shadow compatibilities
	registry.SetCompatibility("shadow", "architectural", 0.7)
	registry.SetCompatibility("shadow", "pursuit", 0.9)
	registry.SetCompatibility("shadow", "yokai", 0.8)
	
	' Architectural compatibilities
	registry.SetCompatibility("architectural", "natural", 0.7)
	registry.SetCompatibility("architectural", "social", 0.8)
	registry.SetCompatibility("architectural", "vertical", 0.7)
	
	' Natural element compatibilities
	registry.SetCompatibility("natural", "yokai", 0.9)
	registry.SetCompatibility("natural", "animal", 0.9)
	registry.SetCompatibility("natural", "vertical", 0.8)
	
	' Temporal compatibilities
	registry.SetCompatibility("temporal", "transformation", 0.8)
	registry.SetCompatibility("temporal", "architectural", 0.6)
	registry.SetCompatibility("temporal", "reflection", 0.8)
	
	' Social compatibilities
	registry.SetCompatibility("social", "reflection", 0.7)
	registry.SetCompatibility("social", "object", 0.7)
	registry.SetCompatibility("social", "body", 0.6)
	
	' Body compatibilities
	registry.SetCompatibility("body", "transformation", 0.9)
	registry.SetCompatibility("body", "animal", 0.8)
	registry.SetCompatibility("body", "yokai", 0.9)
	
	' Pursuit compatibilities
	registry.SetCompatibility("pursuit", "shadow", 0.9)
	registry.SetCompatibility("pursuit", "architectural", 0.8)
	registry.SetCompatibility("pursuit", "animal", 0.8)
	
	' Vertical movement compatibilities
	registry.SetCompatibility("vertical", "natural", 0.8)
	registry.SetCompatibility("vertical", "yokai", 0.7)
	registry.SetCompatibility("vertical", "transformation", 0.7)
	
	' Animal compatibilities
	registry.SetCompatibility("animal", "yokai", 0.9)
	registry.SetCompatibility("animal", "natural", 0.9)
	registry.SetCompatibility("animal", "body", 0.8)
	
	' Yokai specific compatibilities
	registry.SetCompatibility("yokai", "transformation", 0.9)
	registry.SetCompatibility("yokai", "object", 0.8)
	registry.SetCompatibility("yokai", "natural", 0.9)
	
	' Object compatibilities
	registry.SetCompatibility("object", "transformation", 0.7)
	registry.SetCompatibility("object", "reflection", 0.7)
	registry.SetCompatibility("object", "social", 0.7)
	
	' Subcategory specific compatibilities
	registry.SetCompatibility("split_shadow", "partial_transform", 0.9)
	registry.SetCompatibility("true_mirror", "yokai", 0.9)
	registry.SetCompatibility("distortion_mirror", "social", 0.8)
End

' ===================================================
' DREAMER PROFILE INITIALIZATION
' ===================================================

' Initialize dreamer profiles
Function InitDreamerProfiles:Void(registry:DreamSymbolRegistry, generator:DreamGenerator)
	' Initialize dreamer profiles
	CreateHikariProfile(registry, generator)
	CreateKatsuoProfile(registry, generator)
	CreateMegumiProfile(registry, generator)
	CreateAkaneProfile(registry, generator)
End

' Create Hikari's dreamer profile
Function CreateHikariProfile:Void(registry:DreamSymbolRegistry, generator:DreamGenerator)
	Local hikari:DreamerProfile = New DreamerProfile("hikari", "Hikari", "High school girl experiencing yokai transformation")
	
	' Set symbol affinities - Hikari has strong affinity with transformation, shadow, and yokai symbols
	hikari.SetSymbolAffinity("transformation", 0.9)
	hikari.SetSymbolAffinity("shadow", 0.9)
	hikari.SetSymbolAffinity("reflection", 0.8)
	hikari.SetSymbolAffinity("yokai", 0.9)
	hikari.SetSymbolAffinity("body", 0.8)
	hikari.SetSymbolAffinity("natural", 0.7)
	hikari.SetSymbolAffinity("partial_transform", 0.9)
	hikari.SetSymbolAffinity("split_shadow", 0.9)
	hikari.SetSymbolAffinity("true_mirror", 0.8)
	
	' Set psychological traits
	hikari.SetTrait("Duality", 0.9)
	hikari.SetTrait("Change", 0.9)
	hikari.SetTrait("Identity", 0.8)
	hikari.SetTrait("Confusion", 0.7)
	hikari.SetTrait("Wonder", 0.8)
	hikari.SetTrait("Self-discovery", 0.9)
	hikari.SetTrait("Spirituality", 0.8)
	hikari.SetTrait("Anxiety", 0.6)
	
	' Add dominant categories
	hikari.AddDominantCategory("transformation")
	hikari.AddDominantCategory("shadow")
	hikari.AddDominantCategory("yokai")
	
	' Add interpretation rules
	hikari.AddInterpretationRule(New CharacterSpecificRule(
		"hikari_shadow",
		10,
		"shadow",
		"hikari",
		"a shadow that splits into human and fox forms, revealing {dreamer}'s dual nature"
	))
	
	hikari.AddInterpretationRule(New CharacterSpecificRule(
		"hikari_transform",
		10,
		"transformation",
		"hikari",
		"a {symbol} as {dreamer}'s body shifts between human and yokai states"
	))
	
	hikari.AddInterpretationRule(New CharacterSpecificRule(
		"hikari_reflection",
		10,
		"reflection",
		"hikari",
		"a mirror showing {dreamer}'s true spiritual form beneath her human appearance"
	))
	
	hikari.AddInterpretationRule(New CharacterSpecificRule(
		"hikari_natural",
		10,
		"natural",
		"hikari",
		"a {symbol} that responds to {dreamer}'s emerging spiritual energy"
	))
	
	' Add combined symbol rules
	Local combinedRule:CombinedSymbolRule = New CombinedSymbolRule(
		"hikari_shadow_transform",
		15,
		"shadow",
		"transformation",
		"shadows that transform with {dreamer} as she struggles to control her changing form"
	)
	hikari.AddInterpretationRule(combinedRule)
	
	' Register with generator
	generator.AddDreamerProfile(hikari)
End

' Create Katsuo's dreamer profile
Function CreateKatsuoProfile:Void(registry:DreamSymbolRegistry, generator:DreamGenerator)
	Local katsuo:DreamerProfile = New DreamerProfile("katsuo", "Katsuo", "Ancient kitsune living in human form")
	
	' Set symbol affinities - Katsuo has strong affinity with temporal, animal, and yokai symbols
	katsuo.SetSymbolAffinity("temporal", 0.9)
	katsuo.SetSymbolAffinity("animal", 0.9)
	katsuo.SetSymbolAffinity("yokai", 0.9)
	katsuo.SetSymbolAffinity("transformation", 0.8)
	katsuo.SetSymbolAffinity("reflection", 0.8)
	katsuo.SetSymbolAffinity("natural", 0.8)
	katsuo.SetSymbolAffinity("historical_reflections", 0.9)
	katsuo.SetSymbolAffinity("nine_tailed_fox", 0.9)
	katsuo.SetSymbolAffinity("ancient_forest", 0.8)
	
	' Set psychological traits
	katsuo.SetTrait("Longevity", 0.9)
	katsuo.SetTrait("Duality", 0.8)
	katsuo.SetTrait("Duty", 0.9)
	katsuo.SetTrait("Identity", 0.8)
	katsuo.SetTrait("Nostalgia", 0.7)
	katsuo.SetTrait("Isolation", 0.7)
	katsuo.SetTrait("Spirituality", 0.9)
	katsuo.SetTrait("Responsibility", 0.9)
	
	' Add dominant categories
	katsuo.AddDominantCategory("temporal")
	katsuo.AddDominantCategory("yokai")
	katsuo.AddDominantCategory("animal")
	
	' Add interpretation rules
	katsuo.AddInterpretationRule(New CharacterSpecificRule(
		"katsuo_temporal",
		10,
		"temporal",
		"katsuo",
		"a {symbol} that spans centuries of {dreamer}'s existence"
	))
	
	katsuo.AddInterpretationRule(New CharacterSpecificRule(
		"katsuo_animal",
		10,
		"animal",
		"katsuo",
		"a {symbol} representing {dreamer}'s true kitsune nature"
	))
	
	katsuo.AddInterpretationRule(New CharacterSpecificRule(
		"katsuo_yokai",
		10,
		"yokai",
		"katsuo",
		"a manifestation of {dreamer}'s yokai power and heritage"
	))
	
	katsuo.AddInterpretationRule(New CharacterSpecificRule(
		"katsuo_reflection",
		10,
		"reflection",
		"katsuo",
		"reflections showing {dreamer}'s many identities across centuries"
	))
	
	' Add combined symbol rules
	Local combinedRule:CombinedSymbolRule = New CombinedSymbolRule(
		"katsuo_temporal_yokai",
		15,
		"temporal",
		"yokai",
		"a vision spanning centuries of {dreamer}'s existence as a kitsune guardian"
	)
	katsuo.AddInterpretationRule(combinedRule)
	
	' Register with generator
	generator.AddDreamerProfile(katsuo)
End

' Create Megumi's dreamer profile
Function CreateMegumiProfile:Void(registry:DreamSymbolRegistry, generator:DreamGenerator)
	Local megumi:DreamerProfile = New DreamerProfile("megumi", "Megumi", "Popular girl focused on social status and control")
	
	' Set symbol affinities - Megumi has strong affinity with social, reflection, and object symbols
	megumi.SetSymbolAffinity("social", 0.9)
	megumi.SetSymbolAffinity("reflection", 0.9)
	megumi.SetSymbolAffinity("object", 0.8)
	megumi.SetSymbolAffinity("architectural", 0.7)
	megumi.SetSymbolAffinity("status_ledger", 0.9)
	megumi.SetSymbolAffinity("multiplying_reflections", 0.8)
	megumi.SetSymbolAffinity("friend_collection", 0.9)
	megumi.SetSymbolAffinity("expectation_crowd", 0.8)
	megumi.SetSymbolAffinity("invisible_competition", 0.9)
	
	' Set psychological traits
	megumi.SetTrait("Control", 0.9)
	megumi.SetTrait("Social status", 0.9)
	megumi.SetTrait("Perfectionism", 0.8)
	megumi.SetTrait("Insecurity", 0.7)
	megumi.SetTrait("Jealousy", 0.7)
	megumi.SetTrait("Self-image", 0.9)
	megumi.SetTrait("Competition", 0.8)
	megumi.SetTrait("Manipulation", 0.8)
	
	' Add dominant categories
	megumi.AddDominantCategory("social")
	megumi.AddDominantCategory("reflection")
	megumi.AddDominantCategory("object")
	
	' Add interpretation rules
	megumi.AddInterpretationRule(New CharacterSpecificRule(
		"megumi_social",
		10,
		"social",
		"megumi",
		"a {symbol} where {dreamer} carefully manages her social connections"
	))
	
	megumi.AddInterpretationRule(New CharacterSpecificRule(
		"megumi_reflection",
		10,
		"reflection",
		"megumi",
		"reflections showing {dreamer}'s carefully crafted social personas"
	))
	
	megumi.AddInterpretationRule(New CharacterSpecificRule(
		"megumi_object",
		10,
		"object",
		"megumi",
		"a {symbol} that {dreamer} uses to measure and manage her social standing"
	))
	
	megumi.AddInterpretationRule(New CharacterSpecificRule(
		"megumi_architectural",
		10,
		"architectural",
		"megumi",
		"a space where {dreamer} navigates complex social hierarchies"
	))
	
	' Add combined symbol rules
	Local combinedRule:CombinedSymbolRule = New CombinedSymbolRule(
		"megumi_social_reflection",
		15,
		"social",
		"reflection",
		"a gathering where {dreamer} sees how others perceive her various social masks"
	)
	megumi.AddInterpretationRule(combinedRule)
	
	' Register with generator
	generator.AddDreamerProfile(megumi)
End

' Create Akane's dreamer profile
Function CreateAkaneProfile:Void(registry:DreamSymbolRegistry, generator:DreamGenerator)
	Local akane:DreamerProfile = New DreamerProfile("akane", "Akane", "Teacher with awareness of supernatural elements")
	
	' Set symbol affinities - Akane has strong affinity with knowledge, observation, and boundary symbols
	akane.SetSymbolAffinity("object", 0.8)
	akane.SetSymbolAffinity("architectural", 0.8)
	akane.SetSymbolAffinity("yokai", 0.7)
	akane.SetSymbolAffinity("reflection", 0.7)
	akane.SetSymbolAffinity("temporal", 0.7)
	akane.SetSymbolAffinity("social", 0.8)
	
	' Set psychological traits
	akane.SetTrait("Observation", 0.9)
	akane.SetTrait("Protection", 0.8)
	akane.SetTrait("Knowledge", 0.9)
	akane.SetTrait("Responsibility", 0.9)
	akane.SetTrait("Boundaries", 0.8)
	akane.SetTrait("Wisdom", 0.8)
	akane.SetTrait("Caution", 0.7)
	akane.SetTrait("Guidance", 0.8)
	
	' Add dominant categories
	akane.AddDominantCategory("object")
	akane.AddDominantCategory("architectural")
	akane.AddDominantCategory("social")
	
	' Add special symbols for Akane
	Local knowledgeBook:DreamSymbol = New DreamSymbol("knowledge_book", "object", "book of student lives")
		.WithDescription("Book containing the complete stories of students")
		.WithEmotionalTone("Responsibility")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Knowledge")
		.AddPsychologicalAssociation("Guardian role")
		.AddNarrativePhase("AKANE_CHARACTER")
		.AddVisualTrait("Glowing pages")
		.AddVisualTrait("Writing that appears as needed")
	registry.AddSymbol(knowledgeBook)
	
	Local infiniteLibrary:DreamSymbol = New DreamSymbol("infinite_library", "architectural", "infinite library")
		.WithDescription("Endless library containing all knowledge")
		.WithEmotionalTone("Wonder")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Knowledge seeking")
		.AddPsychologicalAssociation("Archive")
		.AddNarrativePhase("AKANE_CHARACTER")
		.AddVisualTrait("Impossible architecture")
		.AddVisualTrait("Books organized by life impact")
	registry.AddSymbol(infiniteLibrary)
	
	Local boundaryGuardian:DreamSymbol = New DreamSymbol("boundary_guardian", "social", "boundary guardian")
		.WithDescription("Standing at the threshold between worlds")
		.WithEmotionalTone("Duty")
		.WithIntensity(0.9)
		.AddPsychologicalAssociation("Protection")
		.AddPsychologicalAssociation("Mediator")
		.AddNarrativePhase("AKANE_CHARACTER")
		.AddVisualTrait("Standing between realms")
		.AddVisualTrait("Protective stance")
	registry.AddSymbol(boundaryGuardian)
	
	' Set special affinities for Akane's unique symbols
	akane.SetSymbolAffinity("knowledge_book", 0.9)
	akane.SetSymbolAffinity("infinite_library", 0.9)
	akane.SetSymbolAffinity("boundary_guardian", 0.9)
	
	' Add interpretation rules
	akane.AddInterpretationRule(New CharacterSpecificRule(
		"akane_object",
		10,
		"object",
		"akane",
		"a {symbol} containing knowledge {dreamer} uses to protect her students"
	))
	
	akane.AddInterpretationRule(New CharacterSpecificRule(
		"akane_architectural",
		10,
		"architectural",
		"akane",
		"a space where {dreamer} observes the interaction of human and yokai worlds"
	))
	
	akane.AddInterpretationRule(New CharacterSpecificRule(
		"akane_yokai",
		10,
		"yokai",
		"akane",
		"supernatural phenomena that {dreamer} observes but rarely interferes with"
	))
	
	akane.AddInterpretationRule(New CharacterSpecificRule(
		"akane_social",
		10,
		"social",
		"akane",
		"interactions where {dreamer} guides without directly intervening"
	))
	
	' Add combined symbol rules
	Local combinedRule:CombinedSymbolRule = New CombinedSymbolRule(
		"akane_object_yokai",
		15,
		"object",
		"yokai",
		"sacred knowledge that {dreamer} protects about the boundary between worlds"
	)
	akane.AddInterpretationRule(combinedRule)
	
	' Register with generator
	generator.AddDreamerProfile(akane)
End

' ===================================================
' UTILITY FUNCTIONS
' ===================================================

' Utility function to demonstrate the dream system
Function DemonstrateDreamSystem:Void()
	Print("Initializing Dream Symbol Library...")
	Local registry:DreamSymbolRegistry = InitDreamSymbolLibrary()
	
	Print("Creating Dream Generator...")
	Local generator:DreamGenerator = New DreamGenerator(registry)
	
	Print("Initializing Dreamer Profiles...")
	InitDreamerProfiles(registry, generator)
	
	Print("Dream System Ready!")
	Print("")
	
	' Example: Generate dreams using the system
	DemonstrateDreamGeneration(generator)
End

' Generate example dreams
Function DemonstrateDreamGeneration:Void(generator:DreamGenerator)
	' Example 1: Hikari's transformation dream
	Local hikariSymbols:String[] = ["split_human_fox_shadow", "truth_mirror", "fox_ears"]
	Local hikariDream:DreamAssembly = generator.AssembleDream("hikari", hikariSymbols)
	
	Print("Dream for Hikari:")
	Print("Coherence Score: " + hikariDream.coherenceScore)
	Print("Narrative: " + hikariDream.narrative)
	Print("")
	
	' Example 2: Katsuo's memory dream
	Local katsuoSymbols:String[] = ["century_desk", "memory_garden", "historical_reflections"]
	Local katsuoDream:DreamAssembly = generator.AssembleDream("katsuo", katsuoSymbols)
	
	Print("Dream for Katsuo:")
	Print("Coherence Score: " + katsuoDream.coherenceScore)
	Print("Narrative: " + katsuoDream.narrative)
	Print("")
	
	' Example 3: Megumi's social dream
	Local megumiSymbols:String[] = ["status_ledger", "multiplying_reflections", "friend_collection"]
	Local megumiDream:DreamAssembly = generator.AssembleDream("megumi", megumiSymbols)
	
	Print("Dream for Megumi:")
	Print("Coherence Score: " + megumiDream.coherenceScore)
	Print("Narrative: " + megumiDream.narrative)
	Print("")
	
	' Example 4: Akane's guardian dream
	Local akaneSymbols:String[] = ["knowledge_book", "infinite_library", "boundary_guardian"]
	Local akaneDream:DreamAssembly = generator.AssembleDream("akane", akaneSymbols)
	
	Print("Dream for Akane:")
	Print("Coherence Score: " + akaneDream.coherenceScore)
	Print("Narrative: " + akaneDream.narrative)
	Print("")
End

' ===================================================
' MAIN ENTRY POINT
' ===================================================

Function Main:Int()
	Print("Dream Symbol Library & Dreamer Profile Generator")
	Print("Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v1.2")
	Print("")
	
	DemonstrateDreamSystem()
	
	Return 0
End
```

## Notes on Implementation

### Symbol Organization Strategy
The dream symbol library uses a hierarchical categorization system to enable both broad and specific symbol matching. Primary categories represent major symbolic themes (transformation, reflection, shadow, etc.) while subcategories allow for more nuanced symbolic interpretation.

Each symbol carries rich metadata including:
- Emotional tone to represent the feeling evoked
- Intensity value to indicate how strongly the symbol manifests
- Psychological associations to connect with character traits
- Narrative phase tags to align symbols with story progression
- Visual traits to guide visual representation

This comprehensive tagging system enables both narrative alignment and character-specific interpretation of identical symbolic elements.

### Character-Specific Symbol Affinity
Each character's profile contains affinity scores for different symbol categories, representing how strongly that character relates to those symbolic elements. This creates a psychological fingerprint that:

1. Guides symbol selection for procedurally generated dreams
2. Weights interpretation to favor character-relevant meanings
3. Calculates coherence scores for symbol combinations
4. Enables character growth through changing affinities

The system can represent character development by modifying these affinities as characters progress through the narrative.

### Interpretation Rule System
The rule-based interpretation system allows for:
1. Character-specific interpretations of common symbols
2. Priority-based rule selection when multiple interpretations apply
3. Context-sensitive interpretations based on symbol combinations
4. Default fallback interpretations when no specific rules match

This multi-tiered approach ensures that dream narratives remain psychologically consistent with character profiles while allowing for creative emergence from symbol combinations.

### Dynamic Compatibility Matrix
The compatibility matrix defines how well different symbol categories work together conceptually. High compatibility scores (0.8-1.0) indicate symbols that create meaningful emergent themes when combined, while lower scores (0.3-0.5) suggest less coherent combinations.

This matrix enables the system to:
1. Calculate overall dream coherence
2. Suggest complementary symbols for dream creation
3. Identify thematically strong symbol combinations
4. Guide procedural dream generation

## Technical Advantages

### Extensibility
The system is designed for easy extension through:

```monkey2
' Example of adding a new symbol category at runtime
Function ExtendWithNewSymbolType:Void(registry:DreamSymbolRegistry)
	' Create and register new category
	Local examCategory:SymbolCategory = New SymbolCategory("academic_anxiety", "Academic Anxiety", "School performance fears")
		.AddPsychologicalAssociation("Performance")
		.AddPsychologicalAssociation("Evaluation")
		.AddCommonEmotion("Anxiety")
		.AddCommonEmotion("Inadequacy")
	
	registry.AddCategory(examCategory)
	
	' Add new symbols in this category
	registry.AddSymbol(New DreamSymbol("blank_test", "academic_anxiety", "blank test paper")
		.WithDescription("Exam with questions that disappear or become unreadable")
		.WithEmotionalTone("Anxiety")
		.WithIntensity(0.8)
		.AddPsychologicalAssociation("Preparation")
		.AddPsychologicalAssociation("Evaluation")
		.AddNarrativePhase("STRESS")
		.AddVisualTrait("Fading text")
		.AddVisualTrait("Blank spaces"))
	
	' Update compatibility matrix
	registry.SetCompatibility("academic_anxiety", "social", 0.8)
	registry.SetCompatibility("academic_anxiety", "architectural", 0.7)
End
```

This extensibility allows new dream content to be added as the narrative evolves or as new character insights develop.

### Procedural Content Generation
The system supports procedurally generated dreams with psychological authenticity:

```monkey2
' Generate procedural dreams based on character state
Function GenerateProceduralDream:DreamAssembly(generator:DreamGenerator, dreamerID:String, narrativePhase:String)
	Local dreamer:DreamerProfile = generator.GetDreamer(dreamerID)
	If dreamer = Null Return Null
	
	' Select symbols based on character affinity and narrative phase
	Local selectedSymbols:String[] = SelectAppropriateSymbols(generator.registry, dreamer, narrativePhase)
	
	' Generate dream
	Return generator.AssembleDream(dreamerID, selectedSymbols)
End

' Select symbols appropriate for character and narrative phase
Function SelectAppropriateSymbols:String[](registry:DreamSymbolRegistry, dreamer:DreamerProfile, phase:String)
	Local symbolPool:List<DreamSymbol> = New List<DreamSymbol>
	Local selectedIDs:String[] = New String[3]  ' Default to 3 symbols
	
	' Find symbols matching phase and with high character affinity
	For Local symbol:DreamSymbol = EachIn registry.symbols.Values()
		Local phaseMatch:Bool = False
		
		For Local i:Int = 0 Until symbol.narrativePhases.Length
			If symbol.narrativePhases[i] = phase
				phaseMatch = True
				Exit
			Endif
		Next
		
		If phaseMatch And dreamer.GetSymbolAffinity(symbol.category) > 0.6
			symbolPool.AddLast(symbol)
		Endif
	Next
	
	' Select symbols with high mutual compatibility
	If symbolPool.Count() >= 3
		' Sort by affinity
		Local affinitySorted:DreamSymbol[] = SortSymbolsByAffinity(symbolPool, dreamer)
		
		' Take top 3 ensuring compatibility
		selectedIDs[0] = affinitySorted[0].id
		
		' Find compatible symbols for positions 2 and 3
		' [Complex selection algorithm simplified]
		
		' For demonstration, just take next 2 highest affinity
		selectedIDs[1] = affinitySorted[1].id
		selectedIDs[2] = affinitySorted[2].id
	Else
		' Not enough matching symbols, fill with any high-affinity symbols
		' [Fallback selection algorithm simplified]
	Endif
	
	Return selectedIDs
End
```

This enables both curated dream experiences tied to narrative progression and emergent dream content based on character psychology.

### Multiple Interpretative Frameworks
The system supports different psychological models of dream interpretation:

```monkey2
' Example adding Jungian interpretation framework
Function AddJungianInterpretation:Void(registry:DreamSymbolRegistry)
	' Add archetype categories
	registry.AddCategory(New SymbolCategory("jungian_shadow", "Shadow Archetype", "The repressed or unknown aspects of self")
		.AddPsychologicalAssociation("Repression")
		.AddPsychologicalAssociation("Hidden self")
		.AddCommonEmotion("Fear")
		.AddCommonEmotion("Fascination"))
	
	registry.AddCategory(New SymbolCategory("jungian_anima", "Anima Archetype", "Feminine inner personality in men")
		.AddPsychologicalAssociation("Feminine aspects")
		.AddPsychologicalAssociation("Emotional depth")
		.AddCommonEmotion("Attraction")
		.AddCommonEmotion("Mystery"))
	
	registry.AddCategory(New SymbolCategory("jungian_animus", "Animus Archetype", "Masculine inner personality in women")
		.AddPsychologicalAssociation("Masculine aspects")
		.AddPsychologicalAssociation("Assertion")
		.AddCommonEmotion("Strength")
		.AddCommonEmotion("Challenge"))
	
	' Add symbol mappings to connect existing symbols to Jungian categories
	MapSymbolToJungian(registry, "pursuing_shadow", "jungian_shadow")
	MapSymbolToJungian(registry, "fox_guide", "jungian_animus", "hikari")
	MapSymbolToJungian(registry, "truth_mirror", "jungian_shadow")
End

Function MapSymbolToJungian:Void(registry:DreamSymbolRegistry, symbolID:String, jungianCategory:String, specificDreamer:String = "")
	' Implementation would connect existing symbols to Jungian interpretative framework
End
```

This modularity allows dream interpretation to leverage multiple psychological frameworks simultaneously, creating richer narrative possibilities.

### Research-Based Dream Patterns
The system incorporates findings from dream research to create authentic dreaming experiences:

```monkey2
' Examples of research-based dream patterns
Function ImplementResearchBasedPatterns:Void(generator:DreamGenerator)
	' Dream incorporation of recent experiences
	generator.AddDreamFormationRule(New RecencyIncorporationRule())
	
	' Emotional processing through symbolism
	generator.AddDreamFormationRule(New EmotionalProcessingRule())
	
	' Memory consolidation patterns
	generator.AddDreamFormationRule(New MemoryConsolidationRule())
	
	' Most common dream themes based on research
	AddResearchBasedCommonPatterns(generator.registry)
End

Function AddResearchBasedCommonPatterns:Void(registry:DreamSymbolRegistry)
	' Based on dream frequency research (simplified)
	registry.SetFrequencyFactor("falling_endlessly", 3.0)  ' 3x more common
	registry.SetFrequencyFactor("pursuit", 2.5)
	registry.SetFrequencyFactor("losing_teeth", 1.8)
	registry.SetFrequencyFactor("unprepared_test", 1.7)
End
```

This research-based approach ensures dream content feels authentic while supporting narrative and character development.

### Character Profile Evolution
The system can track and evolve character dream patterns over time:

```monkey2
' Track character development through changing dream patterns
Function UpdateCharacterDreamProfile:Void(dreamer:DreamerProfile, narrativePhase:String)
	Select narrativePhase
		Case "EARLY_STORY"
			' Early phase: confusion, denial
			dreamer.SetTrait("Confusion", 0.8)
			dreamer.SetTrait("Denial", 0.7)
			dreamer.SetSymbolAffinity("shadow", 0.9)  ' Strong shadow elements early
			dreamer.SetSymbolAffinity("transformation", 0.5)  ' Limited transformation
			
		Case "MID_STORY" 
			' Mid phase: awareness, struggle
			dreamer.SetTrait("Confusion", 0.6)  ' Decreasing confusion
			dreamer.SetTrait("Awareness", 0.7)  ' Increasing awareness
			dreamer.SetSymbolAffinity("shadow", 0.7)  ' Decreasing shadow elements
			dreamer.SetSymbolAffinity("transformation", 0.8)  ' Increasing transformation
			
		Case "LATE_STORY"
			' Late phase: integration, resolution
			dreamer.SetTrait("Integration", 0.8)
			dreamer.SetTrait("Acceptance", 0.7)
			dreamer.SetSymbolAffinity("shadow", 0.5)  ' Reduced shadow presence
			dreamer.SetSymbolAffinity("transformation", 0.9)  ' Strong transformation
	End
End
```

This evolution creates a dream narrative arc that parallels and reinforces the main story progression.

The dream symbol library and dreamer profile generator system provides a powerful framework for procedurally generating psychologically authentic dreams that align with character development and narrative progression. By combining structured symbolic elements with character-specific interpretation rules, the system creates meaningful dream experiences that enhance the storytelling experience.

# Dream Image Combination Engine
*Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v1.2*

## Purpose
This document clarifies the core functionality of the Dream Image Combination Engine, which can operate independently of its interpretation module. The system's primary function is to combine dream image assets with metadata according to coherence rules, creating visually meaningful dream sequences that maintain psychological consistency without requiring explicit textual interpretation.

## Functionality
- Combine dream images based on symbol compatibility rules
- Calculate coherence scores for image combinations
- Apply character-specific visual affinities
- Generate emergent visual symbolism through combinations
- Support both narrative-aligned and free-form dream creation
- Maintain psychological consistency with character profiles
- Operate without requiring explicit textual interpretation

## Implementation Notes

The Dream Image Combination Engine can function independently from the interpretation system. The core functionality centers around the coherence calculation and image selection/combination:

```monkey2
' Core dream image combination without interpretation
Function CombineDreamImages:DreamImageSet(character:String, imageAssets:DreamImageAsset[])
	Local registry:DreamSymbolRegistry = GetRegistry()
	Local dreamer:DreamerProfile = registry.GetDreamer(character)
	
	If dreamer = Null
		Print("Error: Unknown dreamer profile '" + character + "'")
		Return Null
	Endif
	
	' Create result container
	Local dreamSet:DreamImageSet = New DreamImageSet
	dreamSet.images = imageAssets
	dreamSet.dreamerID = character
	
	' Calculate core coherence metrics
	dreamSet.coherenceScore = CalculateCoherence(imageAssets, dreamer)
	dreamSet.compatibilityMatrix = CalculateCompatibilityMatrix(imageAssets)
	dreamSet.emergentPatterns = IdentifyEmergentPatterns(imageAssets, dreamer)
	
	' Optional: Generate interpretation (can be skipped)
	' dreamSet.interpretation = GenerateInterpretation(imageAssets, dreamer)
	
	Return dreamSet
End

' Calculate coherence between images for a character
Function CalculateCoherence:Float(images:DreamImageAsset[], dreamer:DreamerProfile)
	Local affinityScore:Float = 0.0
	Local compatibilityScore:Float = 0.0
	Local emotionalScore:Float = 0.0
	
	' Calculate character affinity (50% weight)
	For Local i:Int = 0 Until images.Length
		If images[i].metadata.characterAffinity.Contains(dreamer.id)
			affinityScore += images[i].metadata.characterAffinity.Get(dreamer.id)
		Endif
	Next
	affinityScore /= images.Length
	
	' Calculate symbol compatibility (30% weight)
	Local registry:DreamSymbolRegistry = GetRegistry()
	Local pairCount:Int = 0
	
	For Local i:Int = 0 Until images.Length
		For Local j:Int = i + 1 Until images.Length
			compatibilityScore += registry.GetCompatibility(
				images[i].metadata.category,
				images[j].metadata.category
			)
			pairCount += 1
		Next
	Next
	
	If pairCount > 0
		compatibilityScore /= pairCount
	Endif
	
	' Calculate emotional consistency (20% weight)
	Local emotionCount:StringMap<Int> = New StringMap<Int>
	Local totalEmotions:Int = 0
	
	For Local i:Int = 0 Until images.Length
		Local emotion:String = images[i].metadata.emotionalTone
		totalEmotions += 1
		
		If emotionCount.Contains(emotion)
			emotionCount.Set(emotion, emotionCount.Get(emotion) + 1)
		Else
			emotionCount.Set(emotion, 1)
		Endif
	Next
	
	Local dominantCount:Int = 0
	For Local count:Int = EachIn emotionCount.Values()
		If count > dominantCount
			dominantCount = count
		Endif
	Next
	
	If totalEmotions > 0
		emotionalScore = Float(dominantCount) / totalEmotions
	Endif
	
	' Calculate weighted total
	Return (affinityScore * 0.5) + (compatibilityScore * 0.3) + (emotionalScore * 0.2)
End
```

The key insight is that the image metadata itself contains the interpretative information. By carefully tagging each dream image with:

1. Symbol category and subcategory
2. Emotional tone
3. Character affinities
4. Psychological associations
5. Visual traits

...you effectively "pre-interpret" the images. The combination engine then ensures these pre-interpreted elements come together in psychologically coherent ways.

## Technical Advantages

### Pre-Interpreted Visual Language

The system leverages pre-interpreted visual elements rather than generating explicit textual interpretations:

```monkey2
' Creating a pre-interpreted dream image asset
Function CreatePreInterpretedImage:DreamImageAsset(id:String, path:String, category:String, name:String)
	Local metadata:SymbolMetadata = New SymbolMetadata()
	
	' Basic metadata including implicit meaning
	metadata.id = id
	metadata.category = category
	metadata.name = name
	
	' Character affinities determine relevance to each character
	metadata.characterAffinity = New StringMap<Float>
	metadata.characterAffinity.Set("hikari", 0.9)  ' Highly relevant to Hikari
	metadata.characterAffinity.Set("katsuo", 0.6)  ' Moderately relevant to Katsuo
	metadata.characterAffinity.Set("megumi", 0.4)  ' Less relevant to Megumi
	
	Return New DreamImageAsset(path, metadata)
End
```

By setting appropriate metadata, the image itself carries its symbolic meaning. The combination engine ensures compatibility between these meanings without requiring explicit interpretation text.

### Visual Emergence Through Combination

The engine's real power comes from emergent visual symbolism that arises when compatible images are combined:

```monkey2
' Identify emergent visual patterns from image combinations
Function IdentifyEmergentPatterns:EmergentPatterns(images:DreamImageAsset[], dreamer:DreamerProfile)
	Local patterns:EmergentPatterns = New EmergentPatterns()
	Local categories:StringSet = New StringSet()
	
	' Collect categories
	For Local image:DreamImageAsset = EachIn images
		categories.Insert(image.metadata.category)
		If image.metadata.subcategory <> ""
			categories.Insert(image.metadata.subcategory)
		Endif
	Next
	
	' Check for known emergent combinations
	If categories.Contains("shadow") And categories.Contains("transformation")
		patterns.AddPattern("shadow_transformation", "Identity emergence", 0.8)
	Endif
	
	If categories.Contains("reflection") And categories.Contains("temporal")
		patterns.AddPattern("temporal_reflection", "Self across time", 0.7)
	Endif
	
	If categories.Contains("architectural") And categories.Contains("natural")
		patterns.AddPattern("nature_structure", "Order vs. chaos", 0.7)
	Endif
	
	Return patterns
End
```

This means that when certain images are combined, new visual meanings emerge that weren't present in any individual image—creating a "dream narrative" through visual language alone.

### Character-Authentic Visuality

The system ensures that dream image combinations feel authentic to specific characters:

```monkey2
' Select character-authentic images
Function SelectImagesForCharacter:DreamImageAsset[](character:String, availableImages:DreamImageAsset[], count:Int = 3)
	Local dreamer:DreamerProfile = GetRegistry().GetDreamer(character)
	If dreamer = Null Return Null
	
	' Sort available images by character affinity
	Local sortedImages:List<DreamImageAsset> = New List<DreamImageAsset>
	For Local image:DreamImageAsset = EachIn availableImages
		sortedImages.AddLast(image)
	Next
	
	sortedImages.Sort(Lambda:Int(a:DreamImageAsset, b:DreamImageAsset)
		Local affinityA:Float = a.metadata.characterAffinity.Get(character, 0.1)
		Local affinityB:Float = b.metadata.characterAffinity.Get(character, 0.1)
		If affinityA > affinityB Return -1
		If affinityA < affinityB Return 1
		Return 0
	End)
	
	' Select top N images with category diversity
	Local selectedImages:DreamImageAsset[] = New DreamImageAsset[count]
	Local usedCategories:StringSet = New StringSet()
	Local index:Int = 0
	
	For Local image:DreamImageAsset = EachIn sortedImages
		' Prefer category diversity
		If Not usedCategories.Contains(image.metadata.category) Or usedCategories.Count() >= count
			selectedImages[index] = image
			usedCategories.Insert(image.metadata.category)
			index += 1
			
			If index >= count Exit
		Endif
	Next
	
	Return selectedImages
End
```

This approach ensures that even without explicit textual interpretation, the visual dream sequence will feel authentic to the character experiencing it.

### Open-Ended Visual Experience

By focusing on image combination without explicit interpretation, the system allows viewers to form their own conclusions:

```monkey2
' Display combined dream without interpretation
Function PresentDreamSequence:Void(dreamSet:DreamImageSet)
	Print("Dream sequence for " + dreamSet.dreamerID)
	Print("Coherence score: " + dreamSet.coherenceScore)
	Print("Images:")
	
	For Local i:Int = 0 Until dreamSet.images.Length
		Print("  " + (i+1) + ". " + dreamSet.images[i].metadata.name)
	Next
	
	Print("Emergent patterns:")
	For Local pattern:String = EachIn dreamSet.emergentPatterns.patterns.Keys()
		Print("  - " + pattern + ": " + dreamSet.emergentPatterns.patterns.Get(pattern))
	Next
	
	' No explicit interpretation provided - viewer interprets visuals
End
```

This approach makes the dream experience more interactive, allowing viewers to apply their own understanding to the pre-interpreted visual elements.

In summary, yes - you can absolutely use the dream engine to combine images based on their metadata without generating explicit interpretations. The system is designed to create visually coherent dream sequences that maintain character authenticity through the image combinations themselves. The metadata and combination rules effectively "pre-interpret" the content, allowing viewers to experience the dream's meaning visually without requiring explanatory text.
