# Dream Symbolic Elements & Combinatorial Rules
*Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v4*

## Purpose
This document provides a comprehensive framework for extracting, categorizing, and recombining symbolic dream elements from character dream sequences. By deconstructing dreams into core qualia components and establishing combinatorial rules, we create a system that can reconstruct original dreams or generate new ones while maintaining psychological consistency and narrative alignment.

## Functionality
- Extraction of core symbolic elements from character dreams
- Classification of dream elements into qualia categories
- Character-specific symbol affinity mapping
- Combinatorial rules for dream element recombination
- Narrative phase alignment guidelines
- Psychological state correlation metrics
- Symbol dominance hierarchies
- Visual coherence maintenance protocols

## Symbol Extraction & Classification

### Core Symbolic Categories

1. **Shadow Manifestations**
   - Split shadows (human/yokai duality)
   - Absent shadows (identity loss)
   - Animated shadows (independent agency)
   - Shadow stretching (influence expansion)
   - Shadow merging (integration of selves)

2. **Reflective Surfaces**
   - Truth mirrors (showing actual nature)
   - Distortion mirrors (showing fear/desire)
   - Empty mirrors (transition states)
   - Mirror circles (facets of self)
   - Water reflections (subconscious elements)

3. **Transformation Markers**
   - Partial forms (fox ears, tails appearing)
   - Superposition states (flickering between forms)
   - Energy emanations (blue foxfire, auras)
   - Physical impossibilities (multiple tails, vertical pupils)
   - Integration indicators (new combined forms)

4. **Natural Elements**
   - Cherry blossoms (transience, transformation)
   - Ancient trees (history, wisdom, time)
   - Gardens (cultivated vs. wild aspects)
   - Water (emotional states, cleansing)
   - Fire (passion, destruction, renewal)

5. **Architectural Spaces**
   - Endless hallways (transitions, liminality)
   - Shrines (sacred boundaries, tradition)
   - Hidden rooms (subconscious areas, secrets)
   - Schools (learning, social hierarchy)
   - Bridges (connections between states)

6. **Quantification Systems**
   - Ledgers (social calculation, control)
   - Scales (judgment, balance)
   - Measurement tools (self-evaluation)
   - Mathematics (attempted rationalization)
   - Records (memory, history)

7. **Temporal Distortions**
   - Accelerated aging (immortal/mortal contrast)
   - Historical shifting (past lives, memories)
   - Time reversal (regret, reconsideration)
   - Time loops (patterns, repetition)
   - Stopped time (realization, epiphany)

8. **Color Symbolism**
   - Blue (yokai essence, spirituality)
   - Red (human vitality, emotion)
   - Purple (integration, transformation)
   - White (purity, divinity)
   - Gold (value, importance)

## Character-Element Affinity Mapping

```wonkey
Function MapCharacterSymbolAffinities:SymbolAffinityMap(character:Character)
	Local affinityMap:SymbolAffinityMap = New SymbolAffinityMap
	
	Select character.name
		Case "Hikari"
			' Primary symbols: transformation, duality
			affinityMap.AddAffinity("ShadowManifestations", 0.9)
			affinityMap.AddAffinity("ReflectiveSurfaces", 0.7)
			affinityMap.AddAffinity("TransformationMarkers", 1.0)
			affinityMap.AddAffinity("NaturalElements", 0.5)
			affinityMap.AddAffinity("ArchitecturalSpaces", 0.6)
			affinityMap.AddAffinity("QuantificationSystems", 0.2)
			affinityMap.AddAffinity("TemporalDistortions", 0.5)
			affinityMap.AddAffinity("ColorSymbolism", 0.8)
			
		Case "Katsuo"
			' Primary symbols: time, identity
			affinityMap.AddAffinity("ShadowManifestations", 0.6)
			affinityMap.AddAffinity("ReflectiveSurfaces", 0.8)
			affinityMap.AddAffinity("TransformationMarkers", 0.8)
			affinityMap.AddAffinity("NaturalElements", 0.9)
			affinityMap.AddAffinity("ArchitecturalSpaces", 0.7)
			affinityMap.AddAffinity("QuantificationSystems", 0.3)
			affinityMap.AddAffinity("TemporalDistortions", 1.0)
			affinityMap.AddAffinity("ColorSymbolism", 0.6)
			
		Case "Megumi"
			' Primary symbols: evaluation, reflection
			affinityMap.AddAffinity("ShadowManifestations", 0.4)
			affinityMap.AddAffinity("ReflectiveSurfaces", 1.0)
			affinityMap.AddAffinity("TransformationMarkers", 0.5)
			affinityMap.AddAffinity("NaturalElements", 0.6)
			affinityMap.AddAffinity("ArchitecturalSpaces", 0.5)
			affinityMap.AddAffinity("QuantificationSystems", 0.9)
			affinityMap.AddAffinity("TemporalDistortions", 0.4)
			affinityMap.AddAffinity("ColorSymbolism", 0.7)
	End
	
	Return affinityMap
End
```

## Narrative Phase Symbol Correlation

```wonkey
Function GetNarrativePhaseSymbols:String[](phase:NarrativePhase)
	Local dominantSymbols:String[] = New String[3]
	
	Select phase
		Case NarrativePhase.EARLY
			dominantSymbols[0] = "ShadowManifestations"
			dominantSymbols[1] = "ArchitecturalSpaces"
			dominantSymbols[2] = "ReflectiveSurfaces"
			
		Case NarrativePhase.MID
			dominantSymbols[0] = "TransformationMarkers"
			dominantSymbols[1] = "NaturalElements"
			dominantSymbols[2] = "TemporalDistortions"
			
		Case NarrativePhase.LATE
			dominantSymbols[0] = "ColorSymbolism"
			dominantSymbols[1] = "QuantificationSystems"
			dominantSymbols[2] = "ArchitecturalSpaces"
			
		Case NarrativePhase.CLIMAX
			dominantSymbols[0] = "TransformationMarkers"
			dominantSymbols[1] = "ColorSymbolism"
			dominantSymbols[2] = "ReflectiveSurfaces"
			
		Case NarrativePhase.RESOLUTION
			dominantSymbols[0] = "NaturalElements"
			dominantSymbols[1] = "ArchitecturalSpaces"
			dominantSymbols[2] = "TemporalDistortions"
	End
	
	Return dominantSymbols
End
```

## Symbolic Element Extraction Table

| Dream | Primary Symbol | Secondary Symbol | Tertiary Symbol | Emotional Tone | Transformation State |
|-------|----------------|------------------|-----------------|----------------|----------------------|
| Hikari's Split Shadow | Split Shadow | School Hallway | Endless Space | Confusion | Awakening |
| Hikari's Festival Mirrors | Multiple Reflections | Festival Setting | Masks | Wonder/Fear | Awareness |
| Hikari's Inner Room | Hidden Door | Temporal Artifacts | Breathing Synchronicity | Discovery | Connection |
| Hikari's Chimeric Integration | Colored Threads | Loom/Weaving | Pain/Beauty | Determination | Active Integration |
| Katsuo's Century Classroom | Temporal Desk | Aging Students | Dual Voice | Isolation | Concealment |
| Katsuo's Memory Garden | Historical Plants | Uncultivated Edge | Unknown Seed | Uncertainty | Possibility |
| Katsuo's Identity Forge | Incompatible Metals | Blood Catalyst | New Alloy | Revelation | Transformation |
| Megumi's Status Ledger | Mathematical Formulas | Unstable Values | Autonomous Growth | Control/Fear | Resistance |
| Megumi's Invisible Competition | Victory Disconnect | Alternative Metrics | Authentic Testing | Confusion/Inadequacy | Forced Awareness |
| Megumi's Transformation Witness | Glass Barrier | Empathic Transfer | Mirror Revelation | Fear/Acceptance | Beginning Change |

## Combinatorial Rules

### 1. Symbol Dominance Hierarchy

```wonkey
Function DetermineDominantSymbol:String(dreamElements:DreamElements, character:Character, phase:NarrativePhase)
	Local characterAffinities:SymbolAffinityMap = MapCharacterSymbolAffinities(character)
	Local phaseSymbols:String[] = GetNarrativePhaseSymbols(phase)
	
	Local highestScore:Float = 0
	Local dominantSymbol:String = ""
	
	For Each symbolType:String = EachIn dreamElements.GetTypes()
		Local symbolInstance:Symbol = dreamElements.GetSymbol(symbolType)
		
		' Calculate dominance score based on character affinity and narrative phase relevance
		Local affinityScore:Float = characterAffinities.GetAffinity(symbolType)
		Local phaseRelevance:Float = 0.2  ' Base relevance
		
		' Check if symbol is particularly relevant to current narrative phase
		For i:Int = 0 Until phaseSymbols.Length
			If symbolType = phaseSymbols[i]
				phaseRelevance = 1.0 - (i * 0.2)  ' Higher relevance for primary phase symbols
				Exit
			EndIf
		Next
		
		Local instanceStrength:Float = symbolInstance.intensity
		Local totalScore:Float = affinityScore * phaseRelevance * instanceStrength
		
		If totalScore > highestScore
			highestScore = totalScore
			dominantSymbol = symbolType
		EndIf
	Next
	
	Return dominantSymbol
End
```

### 2. Element Compatibility Matrix

Symbolic elements have varying levels of compatibility when combined:

| Element A | Element B | Compatibility | Result |
|-----------|-----------|---------------|--------|
| Split Shadow | Mirror | High (0.9) | Self-realization dream |
| Split Shadow | Temporal Distortion | Medium (0.6) | Identity crisis dream |
| Mirror | Transformation Marker | High (0.9) | Self-evolution dream |
| Mirror | Quantification | Low (0.3) | Self-worth evaluation dream |
| Natural Elements | Architectural Spaces | Medium (0.7) | Inner/outer world dream |
| Natural Elements | Color Symbolism | High (0.8) | Emotional transformation dream |
| Temporal Distortion | Transformation | High (0.9) | Evolution across time dream |
| Architectural Spaces | Quantification | Medium (0.5) | Social position dream |

```wonkey
Function GetElementCompatibility:Float(elementA:String, elementB:String)
	Local compatibilityMatrix:StringMap<Float> = New StringMap<Float>
	
	compatibilityMatrix.Add(elementA+"-"+elementB, 0.0)  ' Default incompatibility
	
	' Shadow combinations
	compatibilityMatrix.Add("ShadowManifestations-ReflectiveSurfaces", 0.9)
	compatibilityMatrix.Add("ShadowManifestations-TransformationMarkers", 0.8)
	compatibilityMatrix.Add("ShadowManifestations-TemporalDistortions", 0.6)
	compatibilityMatrix.Add("ShadowManifestations-ArchitecturalSpaces", 0.7)
	compatibilityMatrix.Add("ShadowManifestations-NaturalElements", 0.5)
	compatibilityMatrix.Add("ShadowManifestations-QuantificationSystems", 0.3)
	compatibilityMatrix.Add("ShadowManifestations-ColorSymbolism", 0.7)
	
	' Reflection combinations
	compatibilityMatrix.Add("ReflectiveSurfaces-TransformationMarkers", 0.9)
	compatibilityMatrix.Add("ReflectiveSurfaces-TemporalDistortions", 0.7)
	compatibilityMatrix.Add("ReflectiveSurfaces-ArchitecturalSpaces", 0.6)
	compatibilityMatrix.Add("ReflectiveSurfaces-NaturalElements", 0.5)
	compatibilityMatrix.Add("ReflectiveSurfaces-QuantificationSystems", 0.3)
	compatibilityMatrix.Add("ReflectiveSurfaces-ColorSymbolism", 0.8)
	
	' Add remaining combinations...
	
	' Try both orderings as the map may have only one combination
	If compatibilityMatrix.Contains(elementA+"-"+elementB)
		Return compatibilityMatrix.Get(elementA+"-"+elementB)
	ElseIf compatibilityMatrix.Contains(elementB+"-"+elementA)
		Return compatibilityMatrix.Get(elementB+"-"+elementA)
	EndIf
	
	Return 0.4  ' Default medium-low compatibility for undefined combinations
End
```

### 3. Emotional Tone Modulation

```wonkey
Function ModulateEmotionalTone:EmotionalTone(baseEmotion:EmotionalTone, dreamElements:DreamElements)
	Local output:EmotionalTone = baseEmotion.Clone()
	
	' Each symbol type can shift emotional tone
	If dreamElements.Contains("ShadowManifestations")
		output.uncertainty += 0.2
		output.fear += 0.1
	EndIf
	
	If dreamElements.Contains("ReflectiveSurfaces")
		output.selfAwareness += 0.3
		output.vulnerability += 0.2
	EndIf
	
	If dreamElements.Contains("TransformationMarkers")
		output.wonder += 0.3
		output.fear += 0.2
		output.excitement += 0.2
	EndIf
	
	If dreamElements.Contains("NaturalElements")
		output.peace += 0.2
		output.connection += 0.3
		output.cyclical += 0.2
	EndIf
	
	' Add remaining element effects...
	
	' Normalize values to prevent exceeding bounds
	output.Normalize()
	
	Return output
End
```

### 4. Transformation State Progression Rules

```wonkey
Function ProgressTransformationState:TransformationState(currentState:TransformationState, elements:DreamElements, character:Character)
	Local progression:Float = 0
	
	' Each element can advance or retard transformation
	If elements.Contains("TransformationMarkers")
		progression += 0.3
	EndIf
	
	If elements.Contains("ReflectiveSurfaces")
		progression += 0.2
	EndIf
	
	If elements.Contains("ShadowManifestations")
		progression += 0.2
	EndIf
	
	If elements.Contains("QuantificationSystems")
		progression -= 0.1  ' Resistance through rationalization
	EndIf
	
	' Character-specific modifiers
	Select character.name
		Case "Hikari"
			progression *= 1.2  ' Accelerated transformation
		Case "Katsuo"
			progression *= 0.8  ' Controlled transformation
		Case "Megumi"
			progression *= 0.6  ' Resistant transformation
	End
	
	Return currentState.Advance(progression)
End
```

## Dream Reconstruction Algorithm

```wonkey
Function ReconstructDream:Dream(symbolSet:SymbolSet, character:Character, phase:NarrativePhase)
	Local dream:Dream = New Dream()
	
	' Step 1: Determine dominant symbol based on character and phase
	Local dominantSymbolType:String = DetermineDominantSymbol(symbolSet, character, phase)
	Local dominantSymbol:Symbol = symbolSet.GetSymbol(dominantSymbolType)
	dream.primaryElement = dominantSymbol
	
	' Step 2: Select compatible secondary elements based on compatibility
	Local secondaryElements:Symbol[] = New Symbol[2]
	Local compatibilityScores:Float[] = New Float[symbolSet.Count()]
	
	Local i:Int = 0
	For Each symbolType:String = EachIn symbolSet.GetTypes()
		If symbolType <> dominantSymbolType
			compatibilityScores[i] = GetElementCompatibility(dominantSymbolType, symbolType)
			i += 1
		EndIf
	Next
	
	' Get top two most compatible symbols
	For j:Int = 0 Until 2
		Local highestIndex:Int = GetMaxIndex(compatibilityScores)
		If highestIndex >= 0
			Local compatibleType:String = symbolSet.GetTypes()[highestIndex]
			secondaryElements[j] = symbolSet.GetSymbol(compatibleType)
			compatibilityScores[highestIndex] = -1  ' Mark as used
		EndIf
	Next
	
	dream.secondaryElements = secondaryElements
	
	' Step 3: Establish emotional tone based on elements and character
	dream.emotionalTone = ModulateEmotionalTone(character.baseEmotionalState, symbolSet)
	
	' Step 4: Determine transformation state based on character progression
	dream.transformationState = ProgressTransformationState(
		character.currentTransformationState, 
		symbolSet, 
		character
	)
	
	' Step 5: Construct setting based on architectural and natural elements
	If symbolSet.Contains("ArchitecturalSpaces")
		dream.setting = symbolSet.GetSymbol("ArchitecturalSpaces")
	ElseIf symbolSet.Contains("NaturalElements")
		dream.setting = symbolSet.GetSymbol("NaturalElements")
	Else
		dream.setting = New Symbol("ArchitecturalSpaces", "School", 0.5)  ' Default
	EndIf
	
	' Step 6: Apply color symbolism based on transformation state
	If symbolSet.Contains("ColorSymbolism")
		dream.colorPalette = symbolSet.GetSymbol("ColorSymbolism")
	Else
		' Default color palette based on character
		Select character.name
			Case "Hikari"
				dream.colorPalette = New Symbol("ColorSymbolism", "Blue", 0.7)
			Case "Katsuo"
				dream.colorPalette = New Symbol("ColorSymbolism", "Amber", 0.7)
			Case "Megumi"
				dream.colorPalette = New Symbol("ColorSymbolism", "Purple", 0.7)
		End
	EndIf
	
	Return dream
End

Function GetMaxIndex:Int(values:Float[])
	Local maxIndex:Int = -1
	Local maxValue:Float = -1
	
	For i:Int = 0 Until values.Length
		If values[i] > maxValue
			maxValue = values[i]
			maxIndex = i
		EndIf
	Next
	
	Return maxIndex
End
```

## Symbol Extraction Examples

### Hikari's Split Shadow Dream
```wonkey
Function ExtractSymbols:SymbolSet(dream:String)
	Local symbolSet:SymbolSet = New SymbolSet()
	
	' Example extraction for Hikari's Split Shadow Dream
	If dream.Contains("split shadow") And dream.Contains("school hallway")
		symbolSet.Add(New Symbol("ShadowManifestations", "Split", 0.9))
		symbolSet.Add(New Symbol("ArchitecturalSpaces", "School", 0.7))
		symbolSet.Add(New Symbol("TemporalDistortions", "EndlessSpace", 0.6))
		symbolSet.Add(New Symbol("EmotionalTone", "Confusion", 0.8))
		symbolSet.Add(New Symbol("TransformationState", "Awakening", 0.5))
	EndIf
	
	Return symbolSet
End
```

### Katsuo's Identity Forge Dream
```wonkey
Function ExtractSymbols:SymbolSet(dream:String)
	Local symbolSet:SymbolSet = New SymbolSet()
	
	' Example extraction for Katsuo's Identity Forge Dream
	If dream.Contains("forge") And dream.Contains("metals") And dream.Contains("alloy")
		symbolSet.Add(New Symbol("ArchitecturalSpaces", "Forge", 0.9))
		symbolSet.Add(New Symbol("TransformationMarkers", "Alloy", 0.9))
		symbolSet.Add(New Symbol("NaturalElements", "Blood", 0.7))
		symbolSet.Add(New Symbol("ColorSymbolism", "MetalTransformation", 0.8))
		symbolSet.Add(New Symbol("EmotionalTone", "Revelation", 0.9))
		symbolSet.Add(New Symbol("TransformationState", "Integration", 0.8))
	EndIf
	
	Return symbolSet
End
```

### Megumi's Status Ledger Dream
```wonkey
Function ExtractSymbols:SymbolSet(dream:String)
	Local symbolSet:SymbolSet = New SymbolSet()
	
	' Example extraction for Megumi's Status Ledger Dream
	If dream.Contains("ledger") And dream.Contains("social") And dream.Contains("calculation")
		symbolSet.Add(New Symbol("QuantificationSystems", "Ledger", 0.9))
		symbolSet.Add(New Symbol("EmotionalTone", "Control", 0.8))
		symbolSet.Add(New Symbol("TransformationState", "Resistance", 0.7))
		symbolSet.Add(New Symbol("ColorSymbolism", "OrderedSystem", 0.6))
		symbolSet.Add(New Symbol("TemporalDistortions", "VariableValues", 0.5))
	EndIf
	
	Return symbolSet
End
```

## Notes on Implementation

### Symbol Extraction Methodology
The extraction process identifies both explicit and implicit symbolic elements through contextual analysis:

1. **Explicit Symbols** - Directly mentioned elements like mirrors, shadows, or temporal devices
2. **Implicit Symbols** - Thematic elements suggesting psychological states:
   - Endless hallways → transition anxiety
   - Empty mirrors → identity uncertainty
   - Autonomous growth → loss of control

### Combinatorial Balance Considerations
When recombining elements, three factors must be balanced:

1. **Psychological Coherence** - Elements must align with the character's psychological state
2. **Narrative Alignment** - Symbols should match the story phase appropriately
3. **Symbol Compatibility** - Not all symbolic elements work well together

Balance is maintained through weighted probabilities rather than rigid rules, allowing for creative emergence while maintaining dream coherence.

### Character-Specific Considerations

```wonkey
Function ApplyCharacterFilter:SymbolSet(symbolSet:SymbolSet, character:Character)
	' Character-specific symbol processing
	Select character.name
		Case "Hikari"
			' Hikari dreams emphasize transformation and duality
			For Each symbol:Symbol = EachIn symbolSet.symbols
				If symbol.type = "TransformationMarkers"
					symbol.intensity *= 1.3  ' Amplify transformation symbols
				ElseIf symbol.type = "ShadowManifestations"
					symbol.intensity *= 1.2  ' Amplify duality symbols
				EndIf
			Next
			
		Case "Katsuo"
			' Katsuo dreams emphasize time and identity
			For Each symbol:Symbol = EachIn symbolSet.symbols
				If symbol.type = "TemporalDistortions"
					symbol.intensity *= 1.3  ' Amplify time symbols
				ElseIf symbol.type = "ReflectiveSurfaces"
					symbol.intensity *= 1.2  ' Amplify identity symbols
				EndIf
			Next
			
		Case "Megumi"
			' Megumi dreams emphasize evaluation and control
			For Each symbol:Symbol = EachIn symbolSet.symbols
				If symbol.type = "QuantificationSystems"
					symbol.intensity *= 1.3  ' Amplify evaluation symbols
				ElseIf symbol.type = "ReflectiveSurfaces"
					symbol.intensity *= 1.2  ' Amplify reflection symbols
				EndIf
			Next
	End
	
	Return symbolSet
End
```

### Narrative Phase Alignment
Dreams must align with character progression through the story:

```wonkey
Function AlignWithNarrativeCycle:SymbolSet(symbolSet:SymbolSet, phase:NarrativePhase)
	' Adjust symbol set to align with narrative phase
	Local phaseSymbols:String[] = GetNarrativePhaseSymbols(phase)
	
	' Emphasize phase-appropriate symbols
	For Each symbol:Symbol = EachIn symbolSet.symbols
		For i:Int = 0 Until phaseSymbols.Length
			If symbol.type = phaseSymbols[i]
				symbol.intensity *= (1.0 + (0.3 * (3 - i)))  ' Higher boost for primary symbols
				Exit
			EndIf
		Next
	Next
	
	Return symbolSet
End
```

## Technical Advantages

### Emergent Symbolism
The combinatorial system enables emergence—where simple symbol combinations create complex meaning:

```wonkey
Function CalculateEmergentProperties:EmergentProperties(symbolSet:SymbolSet)
	Local emergent:EmergentProperties = New EmergentProperties()
	
	' Example: Mirror + Shadow combination creates identity questioning
	If symbolSet.Contains("ReflectiveSurfaces") And symbolSet.Contains("ShadowManifestations")
		emergent.AddProperty("IdentityQuestioning", 
			symbolSet.GetSymbolIntensity("ReflectiveSurfaces") * 
			symbolSet.GetSymbolIntensity("ShadowManifestations") * 1.5)
	EndIf
	
	' Example: Transformation + Temporal creates evolution anxiety
	If symbolSet.Contains("TransformationMarkers") And symbolSet.Contains("TemporalDistortions")
		emergent.AddProperty("EvolutionAnxiety", 
			symbolSet.GetSymbolIntensity("TransformationMarkers") * 
			symbolSet.GetSymbolIntensity("TemporalDistortions") * 1.3)
	EndIf
	
	' Example: Natural + Architectural creates boundary dissolution
	If symbolSet.Contains("NaturalElements") And symbolSet.Contains("ArchitecturalSpaces")
		emergent.AddProperty("BoundaryDissolution", 
			symbolSet.GetSymbolIntensity("NaturalElements") * 
			symbolSet.GetSymbolIntensity("ArchitecturalSpaces") * 1.2)
	EndIf
	
	Return emergent
End
```

### Psychological Consistency
The system maintains psychological consistency through character profiles:

```wonkey
Function ValidateDreamPsychology:Bool(dream:Dream, character:Character)
	' Check if dream aligns with character psychology
	Local consistencyScore:Float = 0
	
	' Check primary element alignment
	consistencyScore += character.GetAffinityFor(dream.primaryElement.type) * 0.5
	
	' Check emotional tone alignment
	consistencyScore += CalculateEmotionalAlignment(dream.emotionalTone, character.psychologicalProfile) * 0.3
	
	' Check transformation state progression
	consistencyScore += CalculateTransformationConsistency(dream.transformationState, character.transformationArc) * 0.2
	
	Return consistencyScore >= 0.7  ' Require 70% psychological consistency
End
```

### Narrative Integration
The system ensures dreams align with story progression:

```wonkey
Function IntegrateWithNarrative:Dream(dream:Dream, narrativeContext:NarrativeContext)
	' Modify dream to better integrate with current narrative elements
	
	' Emphasize narrative-relevant symbols
	For Each relevantElement:String = EachIn narrativeContext.activeElements
		If dream.ContainsElementOfType(relevantElement)
			dream.AmplifyElement(relevantElement, 1.3)
		Else
			' Add subtle reference if missing critical element
			dream.AddSubtleReference(relevantElement, 0.4)
		EndIf
	Next
	
	' Incorporate recent plot developments
	For Each plotDevelopment:PlotDevelopment = EachIn narrativeContext.recentDevelopments
		dream.IncorporateReference(plotDevelopment, 0.6)
	Next
	
	' Adjust emotional tone to reflect character's narrative situation
	dream.ModulateEmotionalTone(narrativeContext.characterSituation, 0.5)
	
	Return dream
End
```

### Symbol Evolution Tracking
The system tracks how symbols evolve across dream sequences:

```wonkey
Function TrackSymbolEvolution:SymbolEvolutionData(dreamSequence:Dream[], character:Character)
	Local evolutionData:SymbolEvolutionData = New SymbolEvolutionData()
	
	' Track each symbol type across dreams
	For Each symbolType:String = EachIn AllSymbolTypes()
		Local evolutionPoints:Float[] = New Float[dreamSequence.Length]
		
		For i:Int = 0 Until dreamSequence.Length
			If dreamSequence[i].ContainsElementOfType(symbolType)
				evolutionPoints[i] = dreamSequence[i].GetElementIntensity(symbolType)
			Else
				evolutionPoints[i] = 0
			EndIf
		Next
		
		evolutionData.AddEvolutionTrack(symbolType, evolutionPoints)
	Next
	
	' Calculate transformation trajectory
	evolutionData.CalculateTrajectory()
	
	' Identify key transformation points
	evolutionData.IdentifyKeyPoints()
	
	Return evolutionData
End
```

By extracting core symbolic elements from character dreams and establishing combinatorial rules for their recombination, we create a system capable of both analyzing existing dreams and generating new ones that maintain psychological consistency and narrative alignment. The symbol extraction and recombination process allows for creative exploration of character psychology while ensuring dreams remain relevant to character development and story progression.
