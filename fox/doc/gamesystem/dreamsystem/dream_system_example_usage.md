# Dream Image Combination System
*Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v4*

## Purpose
This document provides a practical example of the dream image combination system, demonstrating how image assets with symbolic metadata can be combined to create character-authentic dreams in the Fox narrative universe.

## Functionality
- Definition of DreamImageAsset class with metadata attributes
- Character profile integration with symbol affinities
- Implementation of basic dream combination algorithm
- Demonstration of different dream interpretations for each character
- Coherence calculation between dream elements
- Example of symbol emergence through combination

## Implementation Example

```monkey2 name=DreamImageExample.monkey2
' Dream Image Combination System
' Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v1.2

' Basic metadata structure for dream images
Class SymbolMetadata
	Field symbolType:String       ' Primary symbol category
	Field symbolInstance:String   ' Specific manifestation
	Field intensity:Float         ' Prominence (0.0-1.0)
	Field emotionalTone:String    ' Primary emotion evoked
	Field characterAffinity:StringMap<Float>  ' Character-specific scores
	
	Method New(type:String, instance:String, intensity:Float, emotion:String)
		Self.symbolType = type
		Self.symbolInstance = instance
		Self.intensity = intensity
		Self.emotionalTone = emotion
		Self.characterAffinity = New StringMap<Float>
	End
	
	Method AddCharacterAffinity:Void(character:String, score:Float)
		Self.characterAffinity.Set(character, score)
	End
End

' Dream image asset with metadata
Class DreamImageAsset
	Field imagePath:String        ' Path to image file
	Field metadata:SymbolMetadata
	
	Method New(path:String, metadata:SymbolMetadata)
		Self.imagePath = path
		Self.metadata = metadata
	End
	
	Method ToString:String()
		Return "Image: " + imagePath + " [" + metadata.symbolType + ": " + metadata.symbolInstance + "]"
	End
End

' Character profile for dream interpretation
Class CharacterProfile
	Field name:String
	Field dominantSymbols:String[]
	Field psychologicalTraits:StringMap<Float>
	
	Method New(name:String)
		Self.name = name
		Self.dominantSymbols = New String[0]
		Self.psychologicalTraits = New StringMap<Float>
	End
	
	Method AddDominantSymbol:Void(symbol:String)
		Self.dominantSymbols = Self.dominantSymbols.Resize(Self.dominantSymbols.Length + 1)
		Self.dominantSymbols[Self.dominantSymbols.Length - 1] = symbol
	End
	
	Method SetTrait:Void(trait:String, value:Float)
		Self.psychologicalTraits.Set(trait, value)
	End
	
	Method GetTraitValue:Float(trait:String, defaultValue:Float = 0.0)
		If Self.psychologicalTraits.Contains(trait)
			Return Self.psychologicalTraits.Get(trait)
		Endif
		
		Return defaultValue
	End
End

' Result of combining dream images for a character
Class CharacterDream
	Field character:String
	Field images:DreamImageAsset[]
	Field narrative:String
	Field coherenceScore:Float
	
	Method ToString:String()
		Local result:String = "Dream for " + character + " (Coherence: " + coherenceScore + ")" + String.FromChar(10)
		result += "Images: " + String.FromChar(10)
		
		For Local i:Int = 0 Until images.Length
			result += "  - " + images[i].ToString() + String.FromChar(10)
		Next
		
		result += "Narrative: " + narrative
		
		Return result
	End
End

' Dream combination system
Class DreamCombiner
	Field characterProfiles:StringMap<CharacterProfile>
	
	Method New()
		Self.characterProfiles = New StringMap<CharacterProfile>
	End
	
	Method AddCharacterProfile:Void(profile:CharacterProfile)
		Self.characterProfiles.Set(profile.name, profile)
	End
	
	' Combine dream images for a specific character
	Method CombineDream:CharacterDream(character:String, images:DreamImageAsset[])
		Local profile:CharacterProfile = Self.characterProfiles.Get(character)
		Local dream:CharacterDream = New CharacterDream()
		
		dream.character = character
		dream.images = images
		dream.coherenceScore = Self.CalculateCoherence(images, profile)
		dream.narrative = Self.GenerateNarrative(images, profile)
		
		Return dream
	End
	
	' Calculate coherence between images for a character
	Method CalculateCoherence:Float(images:DreamImageAsset[], profile:CharacterProfile)
		Local affinityScore:Float = 0.0
		Local compatibilityScore:Float = 0.0
		Local emotionalScore:Float = 0.0
		
		' Calculate character affinity (50% weight)
		For Local i:Int = 0 Until images.Length
			If images[i].metadata.characterAffinity.Contains(profile.name)
				affinityScore += images[i].metadata.characterAffinity.Get(profile.name)
			Endif
		Next
		affinityScore = affinityScore / images.Length
		
		' Calculate symbol compatibility (30% weight)
		Local pairCount:Int = 0
		For Local i:Int = 0 Until images.Length
			For Local j:Int = i + 1 Until images.Length
				compatibilityScore += Self.GetSymbolCompatibility(
					images[i].metadata.symbolType,
					images[j].metadata.symbolType
				)
				pairCount += 1
			Next
		Next
		
		If pairCount > 0
			compatibilityScore = compatibilityScore / pairCount
		Endif
		
		' Calculate emotional consistency (20% weight)
		Local emotionMap:StringMap<Int> = New StringMap<Int>
		Local totalEmotions:Int = 0
		
		For Local i:Int = 0 Until images.Length
			Local emotion:String = images[i].metadata.emotionalTone
			totalEmotions += 1
			
			If emotionMap.Contains(emotion)
				emotionMap.Set(emotion, emotionMap.Get(emotion) + 1)
			Else
				emotionMap.Set(emotion, 1)
			Endif
		Next
		
		Local dominantCount:Int = 0
		For Local count:Int = EachIn emotionMap.Values()
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
	
	' Calculate compatibility between two symbol types
	Method GetSymbolCompatibility:Float(typeA:String, typeB:String)
		' This would be a full compatibility matrix in production
		Local compatibilityMatrix:String[][] = New String[][](
			New String[]("ShadowManifestations", "ReflectiveSurfaces", "0.9"),
			New String[]("ShadowManifestations", "TransformationMarkers", "0.8"),
			New String[]("ReflectiveSurfaces", "ArchitecturalSpaces", "0.7"),
			New String[]("NaturalElements", "TemporalDistortions", "0.6"),
			New String[]("TransformationMarkers", "TemporalDistortions", "0.9"),
			New String[]("QuantificationSystems", "ReflectiveSurfaces", "0.7")
		)
		
		For Local pair:String[] = EachIn compatibilityMatrix
			If (pair[0] = typeA And pair[1] = typeB) Or (pair[0] = typeB And pair[1] = typeA)
				Return Float(pair[2])
			Endif
		Next
		
		' Default medium compatibility
		Return 0.5
	End
	
	' Generate narrative description from the dream images
	Method GenerateNarrative:String(images:DreamImageAsset[], profile:CharacterProfile)
		Local character:String = profile.name
		Local narrative:String = character + " dreams of "
		
		' Add descriptions of each image element
		For Local i:Int = 0 Until images.Length
			If i > 0 And i < images.Length - 1
				narrative += ", "
			Elseif i > 0
				narrative += " and "
			Endif
			
			narrative += Self.GetImageDescription(images[i], profile)
		Next
		
		narrative += "."
		
		' Add character-specific interpretation
		Select character
			Case "Hikari"
				narrative += " The dream reflects her evolving dual nature, as she navigates the boundary between human and yokai."
			Case "Katsuo"
				narrative += " The dream echoes across centuries of memory, bridging his ancient kitsune nature with his present human form."
			Case "Megumi"
				narrative += " The dream reveals her struggle between maintaining social control and embracing authentic connection."
		End
		
		Return narrative
	End
	
	' Get character-specific description of an image
	Method GetImageDescription:String(image:DreamImageAsset, profile:CharacterProfile)
		Local baseDescription:String = "a " + image.metadata.symbolInstance
		
		' Customize description based on character
		Select profile.name
			Case "Hikari"
				Select image.metadata.symbolType
					Case "ShadowManifestations"
						Return baseDescription + " that splits between human and fox form"
					Case "ReflectiveSurfaces"
						Return baseDescription + " revealing her transforming nature"
					Case "TransformationMarkers"
						Return baseDescription + " showing her emerging yokai abilities"
					Case "ArchitecturalSpaces"
						Return baseDescription + " bridging human and spirit worlds"
					Default
						Return baseDescription
				End
				
			Case "Katsuo"
				Select image.metadata.symbolType
					Case "ShadowManifestations"
						Return baseDescription + " persisting across centuries"
					Case "TemporalDistortions"
						Return baseDescription + " connecting different historical eras"
					Case "ReflectiveSurfaces"
						Return baseDescription + " showing his many identities through time"
					Case "TransformationMarkers"
						Return baseDescription + " representing his shifting forms"
					Default
						Return baseDescription
				End
				
			Case "Megumi"
				Select image.metadata.symbolType
					Case "ReflectiveSurfaces"
						Return baseDescription + " capturing her social image"
					Case "QuantificationSystems"
						Return baseDescription + " measuring her standing with others"
					Case "ArchitecturalSpaces"
						Return baseDescription + " representing social hierarchies"
					Default
						Return baseDescription
				End
				
			Default
				Return baseDescription
		End
	End
End

' Example implementation showing three dream images combined for different characters
Function Main:Int()
	Print("Dream Image Combination System")
	Print("Implementation by iDkP from GaragePixel - 2025-04-13" + String.FromChar(10))
	
	' Create three sample dream images with metadata
	Local splitShadow:DreamImageAsset = CreateSplitShadowImage()
	Local truthMirror:DreamImageAsset = CreateTruthMirrorImage()
	Local schoolHallway:DreamImageAsset = CreateSchoolHallwayImage()
	
	' Display image information
	Print("Dream Image Assets:")
	Print("1. " + splitShadow.ToString())
	Print("2. " + truthMirror.ToString())
	Print("3. " + schoolHallway.ToString() + String.FromChar(10))
	
	' Setup character profiles
	Local combiner:DreamCombiner = New DreamCombiner()
	SetupCharacterProfiles(combiner)
	
	' Create image array
	Local images:DreamImageAsset[] = New DreamImageAsset[3]
	images[0] = splitShadow
	images[1] = truthMirror
	images[2] = schoolHallway
	
	' Generate dreams for each character using same images
	Print("Generating character-specific dreams from identical images..." + String.FromChar(10))
	
	Local characters:String[] = ["Hikari", "Katsuo", "Megumi"]
	For Local character:String = EachIn characters
		Local dream:CharacterDream = combiner.CombineDream(character, images)
		Print(dream.ToString())
		Print(String.FromChar(10) + "---" + String.FromChar(10))
	Next
	
	Return 0
End

' Create a split shadow image with metadata
Function CreateSplitShadowImage:DreamImageAsset()
	Local metadata:SymbolMetadata = New SymbolMetadata("ShadowManifestations", "split shadow", 0.9, "Confusion")
	
	' Add character affinities
	metadata.AddCharacterAffinity("Hikari", 0.9)  ' Highly relevant to Hikari
	metadata.AddCharacterAffinity("Katsuo", 0.6)  ' Moderately relevant to Katsuo
	metadata.AddCharacterAffinity("Megumi", 0.4)  ' Less relevant to Megumi
	
	Return New DreamImageAsset("assets/dreams/split_shadow.png", metadata)
End

' Create a truth mirror image with metadata
Function CreateTruthMirrorImage:DreamImageAsset()
	Local metadata:SymbolMetadata = New SymbolMetadata("ReflectiveSurfaces", "truth mirror", 0.8, "Revelation")
	
	' Add character affinities
	metadata.AddCharacterAffinity("Hikari", 0.7)
	metadata.AddCharacterAffinity("Katsuo", 0.8)
	metadata.AddCharacterAffinity("Megumi", 0.9)  ' Very relevant to Megumi
	
	Return New DreamImageAsset("assets/dreams/truth_mirror.png", metadata)
End

' Create a school hallway image with metadata
Function CreateSchoolHallwayImage:DreamImageAsset()
	Local metadata:SymbolMetadata = New SymbolMetadata("ArchitecturalSpaces", "endless hallway", 0.7, "Anxiety")
	
	' Add character affinities
	metadata.AddCharacterAffinity("Hikari", 0.6)
	metadata.AddCharacterAffinity("Katsuo", 0.5)
	metadata.AddCharacterAffinity("Megumi", 0.8)
	
	Return New DreamImageAsset("assets/dreams/school_hallway.png", metadata)
End

' Setup character psychological profiles
Function SetupCharacterProfiles:Void(combiner:DreamCombiner)
	' Hikari's profile
	Local hikari:CharacterProfile = New CharacterProfile("Hikari")
	hikari.AddDominantSymbol("ShadowManifestations")
	hikari.AddDominantSymbol("TransformationMarkers")
	hikari.SetTrait("Duality", 0.9)
	hikari.SetTrait("Transformation", 0.8)
	hikari.SetTrait("Spirituality", 0.7)
	combiner.AddCharacterProfile(hikari)
	
	' Katsuo's profile
	Local katsuo:CharacterProfile = New CharacterProfile("Katsuo")
	katsuo.AddDominantSymbol("TemporalDistortions")
	katsuo.AddDominantSymbol("ReflectiveSurfaces")
	katsuo.SetTrait("Longevity", 0.9)
	katsuo.SetTrait("Identity", 0.8)
	katsuo.SetTrait("Duty", 0.8)
	combiner.AddCharacterProfile(katsuo)
	
	' Megumi's profile
	Local megumi:CharacterProfile = New CharacterProfile("Megumi")
	megumi.AddDominantSymbol("ReflectiveSurfaces")
	megumi.AddDominantSymbol("QuantificationSystems")
	megumi.SetTrait("Control", 0.9)
	megumi.SetTrait("SocialAwareness", 0.8)
	megumi.SetTrait("Reflection", 0.7)
	combiner.AddCharacterProfile(megumi)
End
```

## Notes on Implementation

### Metadata Structure
The sample implementation uses a symbolic metadata approach that encodes several key properties for each dream image:

1. **Symbol Type** - Primary symbolic category (e.g., Shadow, Reflection)
2. **Symbol Instance** - Specific manifestation within that category
3. **Intensity** - How prominently this symbol manifests
4. **Emotional Tone** - Primary emotion evoked by the image
5. **Character Affinities** - How strongly each character relates to the symbol

This metadata structure enables the system to make informed decisions about how each character would interpret these symbolic elements.

### Character Profiles
Character profiles encode two important aspects:

1. **Dominant Symbols** - Symbol types that resonate most strongly with a character
2. **Psychological Traits** - Character-specific psychological attributes

These profiles allow the system to generate appropriately distinct interpretations of identical imagery based on each character's unique psychology.

### Dream Combination Algorithm
The dream combination process follows a three-part coherence evaluation:

1. **Character Affinity** (50% weight) - How relevant the symbols are to the character
2. **Symbol Compatibility** (30% weight) - How well the symbols work together conceptually
3. **Emotional Consistency** (20% weight) - How cohesive the emotional tones are

This weighting ensures that even unusual symbol combinations can feel authentic if they align well with a character's psychology.

### Character-Specific Interpretations
The narrative generation demonstrates how identical symbolic imagery produces distinctly different dream experiences for each character:

- **Hikari** interprets symbols through the lens of transformation and duality
- **Katsuo** views symbols through the context of time and multiple identities
- **Megumi** processes symbols in terms of social evaluation and control

## Technical Advantages

### Symbol Recycling With Unique Interpretation
The system allows the same image assets to be reused while creating distinctly different narrative experiences. This provides both technical efficiency (reusing art assets) and narrative depth (different interpretations).

For example, a "split shadow" asset is interpreted as:
- For Hikari: Evidence of her emerging dual nature
- For Katsuo: A reflection of his existence across multiple time periods
- For Megumi: A social fracturing or inconsistency in self-presentation

### Coherence Scoring For Player Feedback
The coherence calculation provides a valuable gameplay mechanic where players can experiment with dream combinations and receive feedback on how "authentic" their creation feels for a specific character.

This scoring system enables:
1. Tutorial guidance for new players
2. Achievement systems for creating highly coherent dreams
3. Gameplay mechanics where dream authenticity affects character development

### Extensible Symbol Framework
The symbol type system is designed for extensibility, allowing new symbolic elements to be added without disrupting existing combinations:

1. Define new symbol type and instances
2. Add compatibility ratings with existing symbol types
3. Add character-specific interpretation logic
4. Integrate into existing dream combination system

This extensibility supports ongoing content development, allowing new dream imagery to be added throughout game development and even post-release.

### Emergent Narrative Generation
By combining just three images with their associated symbolic metadata, the system generates emergent narratives that feel psychologically authentic to each character. This emergent quality creates dream experiences that are greater than the sum of their parts.

The dream experience isn't just displaying three images in sequence; it's creating a cohesive psychological experience that reflects the character's unique perspective on these symbolic elements and how they interact.
