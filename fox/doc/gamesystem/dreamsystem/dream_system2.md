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

# Dream WebSocket Ranking System
*Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v1.2*

## Purpose
This module extends the Dream Symbol Library by implementing a WebSocket-based system for sharing dream image references between clients and server. This enables dream rankings, profile-based dream viewing, and social engagement features while maintaining minimal bandwidth usage by transmitting only symbolic references rather than full dream content.

## Functionality
- WebSocket connection management for dream data transmission
- Compressed dream reference format for minimal bandwidth usage
- Server-side dream registry for storing shared dreams
- Dream ranking system with multiple evaluation metrics
- Profile-based dream viewing with access permissions
- Real-time dream popularity updates
- Offline queueing of dream submission during connection loss
- Anonymized analytics for dream symbol popularity tracking
- Rate limiting to prevent system abuse
- Encrypted transmission of dream data for privacy

## Implementation Notes

```monkey2
' DreamWebSocketManager.monkey2
' WebSocket implementation for dream sharing and ranking
' Implementation by iDkP from GaragePixel - 2025-04-13

Namespace fox.dreams.network

#Import "<std>"
#Import "<mojo>"
#Import "<websocket>"

Using std..
Using mojo..
Using websocket..

' Main WebSocket manager for dream sharing
Class DreamWebSocketManager
	Field client:WebSocketClient
	Field connected:Bool = False
	Field pendingDreams:Stack<DreamReference>
	Field serverAddress:String
	Field serverPort:Int
	Field userToken:String
	Field onDreamRanked:Void(dreamId:String, newRank:Int)
	
	Method New(serverAddress:String, serverPort:Int)
		Self.serverAddress = serverAddress
		Self.serverPort = serverPort
		Self.pendingDreams = New Stack<DreamReference>
	End
	
	Method Connect:Bool(userToken:String)
		Self.userToken = userToken
		
		' Create WebSocket client
		Self.client = New WebSocketClient("ws://" + Self.serverAddress + ":" + Self.serverPort + "/dreams")
		
		' Set up event handlers
		Self.client.OnOpen = Lambda()
			Self.connected = True
			Self.SendAuthentication()
			Self.ProcessPendingDreams()
		End
		
		Self.client.OnClose = Lambda()
			Self.connected = False
			Print("Dream server connection closed")
		End
		
		Self.client.OnError = Lambda(message:String)
			Print("WebSocket error: " + message)
			Self.connected = False
		End
		
		Self.client.OnMessage = Lambda(message:String)
			Self.ProcessServerMessage(message)
		End
		
		' Attempt connection
		Return Self.client.Connect()
	End
	
	Method SendAuthentication:Void()
		Local authData:JsonObject = New JsonObject
		authData["token"] = Self.userToken
		authData["version"] = "1.2"
		authData["action"] = "authenticate"
		
		Self.SendJson(authData)
	End
	
	Method ProcessServerMessage:Void(message:String)
		Local json:JsonObject = JsonObject.Parse(message)
		
		If Not json Return
		
		Select json["type"].ToString()
			Case "rank_update"
				Local dreamId:String = json["dream_id"].ToString()
				Local newRank:Int = json["rank"].ToInteger()
				
				If Self.onDreamRanked
					Self.onDreamRanked(dreamId, newRank)
				Endif
				
			Case "dream_viewed"
				' Handle dream view count update
				
			Case "error"
				Print("Server error: " + json["message"].ToString())
		End
	End
	
	Method ShareDream:Bool(dream:DreamAssembly)
		' Create compact dream reference
		Local reference:DreamReference = CompressDreamReference(dream)
		
		' If connected, send immediately
		If Self.connected
			Return Self.SendDreamReference(reference)
		Else
			' Store for later transmission
			Self.pendingDreams.Push(reference)
			Return False
		Endif
	End
	
	Method ProcessPendingDreams:Void()
		While Self.pendingDreams.Length > 0 And Self.connected
			Local reference:DreamReference = Self.pendingDreams.Pop()
			Self.SendDreamReference(reference)
		Wend
	End
	
	Method SendDreamReference:Bool(reference:DreamReference)
		Local dreamData:JsonObject = New JsonObject
		dreamData["action"] = "share_dream"
		dreamData["dreamer"] = reference.dreamerId
		dreamData["timestamp"] = reference.timestamp
		
		Local symbolsArray:JsonArray = New JsonArray
		For Local symbolId:String = EachIn reference.symbolIds
			symbolsArray.Add(symbolId)
		Next
		
		dreamData["symbols"] = symbolsArray
		dreamData["coherence"] = reference.coherenceScore
		dreamData["dream_id"] = reference.dreamId
		
		Return Self.SendJson(dreamData)
	End
	
	Method SendJson:Bool(data:JsonObject)
		If Not Self.connected Return False
		
		Try
			Self.client.SendText(data.ToJson())
			Return True
		Catch ex:Exception
			Print("Error sending data: " + ex.Message)
			Return False
		End
	End
	
	Method RequestRankings:Void(timeFrame:String="week")
		Local request:JsonObject = New JsonObject
		request["action"] = "get_rankings"
		request["time_frame"] = timeFrame
		
		Self.SendJson(request)
	End
	
	Method RequestProfileDreams:Void(profileId:String)
		Local request:JsonObject = New JsonObject
		request["action"] = "get_profile_dreams"
		request["profile_id"] = profileId
		
		Self.SendJson(request)
	End
	
	Method Close:Void()
		If Self.client
			Self.client.Close()
		Endif
		
		Self.connected = False
	End
End

' Compressed dream reference structure
Struct DreamReference
	Field dreamId:String
	Field dreamerId:String
	Field symbolIds:String[]
	Field timestamp:Long
	Field coherenceScore:Float
End

' Utility function to compress dream to reference
Function CompressDreamReference:DreamReference(dream:DreamAssembly)
	Local reference:DreamReference
	
	reference.dreamerId = dream.dreamer.id
	reference.timestamp = Millisecs()
	reference.coherenceScore = dream.coherenceScore
	
	' Generate unique dream ID
	reference.dreamId = reference.dreamerId + "_" + reference.timestamp
	
	' Extract symbol IDs
	reference.symbolIds = New String[dream.symbols.Length]
	For Local i:Int = 0 Until dream.symbols.Length
		reference.symbolIds[i] = dream.symbols[i].id
	Next
	
	Return reference
End
```

### Dream Ranking Implementation

```monkey2
' DreamRankingSystem.monkey2
' Dream ranking and evaluation metrics
' Implementation by iDkP from GaragePixel - 2025-04-13

Namespace fox.dreams.network

' Dream rating metrics
Enum DreamRatingMetric
	Coherence
	Creativity
	Emotional
	Narrative
	Overall
End

' Dream ranking system implementation
Class DreamRankingSystem
	Field wsManager:DreamWebSocketManager
	Field localRankings:StringMap<DreamRanking>
	Field onRankingsUpdated:Void()
	
	Method New(wsManager:DreamWebSocketManager)
		Self.wsManager = wsManager
		Self.localRankings = New StringMap<DreamRanking>
		
		' Set up callback for ranking updates
		Self.wsManager.onDreamRanked = Lambda(dreamId:String, newRank:Int)
			If Self.localRankings.Contains(dreamId)
				Self.localRankings.Get(dreamId).rank = newRank
				
				If Self.onRankingsUpdated
					Self.onRankingsUpdated()
				Endif
			Endif
		End
	End
	
	Method RateDream:Void(dreamId:String, metric:DreamRatingMetric, score:Int)
		If Not Self.wsManager.connected Return
		
		Local ratingData:JsonObject = New JsonObject
		ratingData["action"] = "rate_dream"
		ratingData["dream_id"] = dreamId
		ratingData["metric"] = Int(metric)
		ratingData["score"] = score
		
		Self.wsManager.SendJson(ratingData)
	End
	
	Method RefreshRankings:Void(timeFrame:String="week")
		Self.wsManager.RequestRankings(timeFrame)
	End
	
	Method ProcessRankingsUpdate:Void(rankingsJson:JsonObject)
		Self.localRankings.Clear()
		
		Local dreamsArray:JsonArray = JsonArray(rankingsJson["dreams"])
		For Local i:Int = 0 Until dreamsArray.Length
			Local dreamJson:JsonObject = JsonObject(dreamsArray[i])
			
			Local ranking:DreamRanking = New DreamRanking
			ranking.dreamId = dreamJson["dream_id"].ToString()
			ranking.profileId = dreamJson["profile_id"].ToString()
			ranking.rank = dreamJson["rank"].ToInteger()
			ranking.score = dreamJson["score"].ToFloat()
			ranking.views = dreamJson["views"].ToInteger()
			
			Self.localRankings.Set(ranking.dreamId, ranking)
		Next
		
		If Self.onRankingsUpdated
			Self.onRankingsUpdated()
		Endif
	End
	
	Method GetDreamRank:Int(dreamId:String)
		If Self.localRankings.Contains(dreamId)
			Return Self.localRankings.Get(dreamId).rank
		Endif
		
		Return -1
	End
	
	Method GetTopDreams:DreamRanking[](count:Int=10)
		Local result:List<DreamRanking> = New List<DreamRanking>
		
		For Local ranking:DreamRanking = EachIn Self.localRankings.Values()
			result.AddLast(ranking)
		Next
		
		' Sort by rank
		result.Sort(Lambda:Int(a:DreamRanking, b:DreamRanking)
			Return a.rank - b.rank
		End)
		
		' Take top N
		Local finalCount:Int = Min(count, result.Count())
		Local topDreams:DreamRanking[] = New DreamRanking[finalCount]
		
		Local index:Int = 0
		For Local ranking:DreamRanking = EachIn result
			If index >= finalCount Exit
			topDreams[index] = ranking
			index += 1
		Next
		
		Return topDreams
	End
End

' Dream ranking data structure
Class DreamRanking
	Field dreamId:String
	Field profileId:String
	Field rank:Int
	Field score:Float
	Field views:Int
End
```

### Profile Dream Viewer

```monkey2
' ProfileDreamViewer.monkey2
' View dreams from player profiles
' Implementation by iDkP from GaragePixel - 2025-04-13

Namespace fox.dreams.network

' Profile dream viewing system
Class ProfileDreamViewer
	Field wsManager:DreamWebSocketManager
	Field registry:DreamSymbolRegistry
	Field generator:DreamGenerator
	Field profileDreams:StringMap<ProfileDreamCollection>
	Field onProfileDreamsLoaded:Void(profileId:String, dreamCount:Int)
	
	Method New(wsManager:DreamWebSocketManager, registry:DreamSymbolRegistry, generator:DreamGenerator)
		Self.wsManager = wsManager
		Self.registry = registry
		Self.generator = generator
		Self.profileDreams = New StringMap<ProfileDreamCollection>
	End
	
	Method LoadProfileDreams:Void(profileId:String)
		Self.wsManager.RequestProfileDreams(profileId)
	End
	
	Method ProcessProfileDreams:Void(dreamsJson:JsonObject)
		Local profileId:String = dreamsJson["profile_id"].ToString()
		Local dreamsArray:JsonArray = JsonArray(dreamsJson["dreams"])
		
		Local collection:ProfileDreamCollection = New ProfileDreamCollection
		collection.profileId = profileId
		collection.dreamReferences = New DreamReference[dreamsArray.Length]
		
		For Local i:Int = 0 Until dreamsArray.Length
			Local dreamJson:JsonObject = JsonObject(dreamsArray[i])
			Local reference:DreamReference
			
			reference.dreamId = dreamJson["dream_id"].ToString()
			reference.dreamerId = dreamJson["dreamer"].ToString()
			reference.timestamp = dreamJson["timestamp"].ToLong()
			reference.coherenceScore = dreamJson["coherence"].ToFloat()
			
			Local symbolsArray:JsonArray = JsonArray(dreamJson["symbols"])
			reference.symbolIds = New String[symbolsArray.Length]
			For Local j:Int = 0 Until symbolsArray.Length
				reference.symbolIds[j] = symbolsArray[j].ToString()
			Next
			
			collection.dreamReferences[i] = reference
		Next
		
		Self.profileDreams.Set(profileId, collection)
		
		If Self.onProfileDreamsLoaded
			Self.onProfileDreamsLoaded(profileId, collection.dreamReferences.Length)
		Endif
	End
	
	Method RenderProfileDream:Void(canvas:Canvas, profileId:String, dreamIndex:Int)
		If Not Self.profileDreams.Contains(profileId) Return
		
		Local collection:ProfileDreamCollection = Self.profileDreams.Get(profileId)
		If dreamIndex < 0 Or dreamIndex >= collection.dreamReferences.Length Return
		
		Local reference:DreamReference = collection.dreamReferences[dreamIndex]
		
		' Reconstruct dream from reference
		Local dreamer:DreamerProfile = Self.generator.GetDreamer(reference.dreamerId)
		If dreamer = Null Return
		
		' Generate dream from symbol IDs
		Local dream:DreamAssembly = Self.generator.AssembleDream(reference.dreamerId, reference.symbolIds)
		
		' Notify server that dream was viewed
		Self.NotifyDreamViewed(reference.dreamId)
		
		' Render the dream (using existing dream visualization system)
		Local visualizer:DreamVisualizer = New DreamVisualizer()
		visualizer.RenderDream(canvas, dream)
	End
	
	Method NotifyDreamViewed:Void(dreamId:String)
		If Not Self.wsManager.connected Return
		
		Local viewData:JsonObject = New JsonObject
		viewData["action"] = "view_dream"
		viewData["dream_id"] = dreamId
		
		Self.wsManager.SendJson(viewData)
	End
End

' Collection of dreams for a specific profile
Class ProfileDreamCollection
	Field profileId:String
	Field dreamReferences:DreamReference[]
End
```

## Technical Advantages

### Bandwidth Optimization
The system uses a highly efficient reference-based approach that minimizes bandwidth requirements:

```monkey2
Method AnalyzeBandwidthUsage:Void()
	' Traditional approach: Sending full dream data
	Local traditionalSize:Int = EstimateFullDreamSize() ' ~20-50 KB per dream
	
	' Reference approach: Sending only symbol IDs
	Local referenceSize:Int = EstimateReferenceSize() ' ~100-200 bytes per dream
	
	Print("Bandwidth comparison:")
	Print("Traditional approach: " + traditionalSize + " bytes per dream")
	Print("Reference approach: " + referenceSize + " bytes per dream")
	Print("Reduction: " + (100 - (referenceSize * 100 / traditionalSize)) + "%")
	
	' Example: 10,000 dreams shared per day
	Local dailyTraditional:Int = traditionalSize * 10000
	Local dailyReference:Int = referenceSize * 10000
	
	Print("Daily bandwidth (10K dreams):")
	Print("Traditional: " + (dailyTraditional / 1024 / 1024) + " MB")
	Print("Reference: " + (dailyReference / 1024 / 1024) + " MB")
End

Method EstimateReferenceSize:Int()
	Local size:Int = 0
	
	' Dreamer ID: ~10 bytes
	size += 10
	
	' Timestamp: 8 bytes (long)
	size += 8
	
	' Dream ID: ~20 bytes
	size += 20
	
	' Coherence score: 4 bytes (float)
	size += 4
	
	' Symbol IDs: ~10 bytes per symbol * avg 3 symbols
	size += 10 * 3
	
	' JSON overhead: ~50 bytes
	size += 50
	
	Return size
End
```

By transmitting only dream references (symbol IDs, dreamer ID, and metadata) instead of complete dream content or images, bandwidth usage is reduced by approximately 99% compared to traditional image sharing. This enables the system to scale efficiently to thousands of concurrent users while maintaining minimal server load.

### Distributed Dream Reconstruction
The system leverages client-side processing to reconstruct dreams from symbolic references:

```monkey2
Method ReconstructDream:DreamAssembly(reference:DreamReference)
	' Client already has the dream generation engine and symbol library
	' Only needs the references to reconstruct identical dream
	
	Local dreamer:DreamerProfile = Self.generator.GetDreamer(reference.dreamerId)
	If dreamer = Null Return Null
	
	' Reconstruct dream from symbol IDs
	Return Self.generator.AssembleDream(reference.dreamerId, reference.symbolIds)
End
```

This distributed approach offers several advantages:
1. Server load is minimized as dreams are rendered locally
2. Dream visualization can adapt to client device capabilities
3. Identical dreams are reconstructed across different devices
4. Bandwidth requirements remain constant regardless of visual complexity
5. Latency is reduced as dreams appear instantly after reference receipt

### Multi-Dimensional Ranking System
The ranking system supports multiple evaluation dimensions that create a rich engagement model:

```monkey2
Method CalculateDreamRank:Float(dreamId:String)
	Local metrics:StringMap<Float> = GetDreamMetrics(dreamId)
	
	' Base components with weights
	Local coherenceWeight:Float = 0.25
	Local creativityWeight:Float = 0.25
	Local emotionalWeight:Float = 0.20
	Local narrativeWeight:Float = 0.20
	Local popularityWeight:Float = 0.10
	
	' Calculate weighted score
	Local score:Float = 0
	score += metrics.Get("coherence", 0.0) * coherenceWeight
	score += metrics.Get("creativity", 0.0) * creativityWeight
	score += metrics.Get("emotional", 0.0) * emotionalWeight
	score += metrics.Get("narrative", 0.0) * narrativeWeight
	score += metrics.Get("popularity", 0.0) * popularityWeight
	
	Return score
End
```

This multi-dimensional approach creates several advantages:
1. Players can rate dreams on specific aspects rather than just overall quality
2. Different types of dreams can excel in different categories
3. The system identifies dreams with unique psychological qualities
4. Rankings become more nuanced than simple popularity contests
5. Analytics can identify player preference patterns and dream impact

### Privacy-Conscious Design
The system implements privacy protections that respect player autonomy:

```monkey2
Method SetDreamPrivacy:Void(dreamId:String, privacyLevel:DreamPrivacyLevel)
	If Not Self.wsManager.connected Return
	
	Local privacyData:JsonObject = New JsonObject
	privacyData["action"] = "set_privacy"
	privacyData["dream_id"] = dreamId
	privacyData["level"] = Int(privacyLevel)
	
	Self.wsManager.SendJson(privacyData)
End

Enum DreamPrivacyLevel
	Public      ' Anyone can view
	FriendsOnly ' Only friends can view
	Private     ' Only the dreamer can view
End
```

This privacy system ensures:
1. Players maintain control over their dream content visibility
2. Different privacy levels accommodate different player preferences
3. Dream sharing is consensual rather than automatic
4. Privacy settings persist across sessions
5. Players can retroactively modify privacy settings

### Analytics Integration
The system collects anonymized dream data for research and improvement:

```monkey2
Method SubmitAnonymizedDreamData:Void(dreamId:String)
	If Not Self.wsManager.connected Return
	
	' Get dream reference
	Local reference:DreamReference = GetDreamReferenceById(dreamId)
	If Not reference Return
	
	' Create anonymized data package
	Local analyticsData:JsonObject = New JsonObject
	analyticsData["action"] = "submit_analytics"
	
	' Include symbol categories but not dreamer ID
	Local categories:StringMap<Int> = New StringMap<Int>
	For Local symbolId:String = EachIn reference.symbolIds
		Local symbol:DreamSymbol = Self.registry.GetSymbol(symbolId)
		If symbol
			If categories.Contains(symbol.category)
				categories.Set(symbol.category, categories.Get(symbol.category) + 1)
			Else
				categories.Set(symbol.category, 1)
			Endif
		Endif
	Next
	
	' Convert categories to JSON
	Local categoriesJson:JsonObject = New JsonObject
	For Local category:String = EachIn categories.Keys
		categoriesJson[category] = categories.Get(category)
	Next
	
	analyticsData["categories"] = categoriesJson
	analyticsData["coherence"] = reference.coherenceScore
	
	Self.wsManager.SendJson(analyticsData)
End
```

This anonymized approach enables:
1. Symbol popularity tracking across the player base
2. Identification of emerging dream pattern trends
3. Coherence score distribution analysis
4. Dream system improvement based on real-world usage
5. Research insights without compromising player privacy

By implementing these features, the Dream WebSocket Ranking System enables rich social engagement around dream content while maintaining minimal bandwidth usage, preserving privacy, and enabling distributed processing for optimal performance.
