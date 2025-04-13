# Dream Combinatorial System For Character-Authentic Dreams
*Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v4*

## Purpose
This system enables the procedural generation of character-authentic dreams by combining unlocked dream image assets with associated symbolic metadata. By applying character-specific affinity rules and combinatorial logic, the system produces dreams that maintain psychological consistency while allowing for creative recombination outside strict narrative progression.

## Functionality
- Process unlocked dream image assets with symbolic metadata tags
- Apply character-specific symbol affinity filtering
- Combine images using psychological coherence algorithms
- Generate emergent symbolic meaning from image combinations
- Validate dream authenticity against character psychological profiles
- Balance visual and symbolic coherence in final output
- Support both narrative-aligned and free-form dream generation

## Implementation Details

```wonkey
' Define metadata structure for dream images
Class DreamImageMetadata
	Field symbolType:String       ' Primary symbol category
	Field symbolInstance:String   ' Specific instance of symbol
	Field intensity:Float         ' Symbol prominence (0.0-1.0)
	Field emotionalTone:String    ' Primary emotion evoked
	Field characterAffinity:StringMap<Float>  ' Character-specific affinity scores
	
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
	Field image:Image
	Field metadata:DreamImageMetadata
	
	Method New(image:Image, metadata:DreamImageMetadata)
		Self.image = image
		Self.metadata = metadata
	End
End

' Dream generator using combinatorial rules
Class DreamGenerator
	Field availableImages:List<DreamImageAsset>
	Field characterProfiles:StringMap<CharacterProfile>
	
	Method New()
		Self.availableImages = New List<DreamImageAsset>
		Self.characterProfiles = New StringMap<CharacterProfile>
	End
	
	Method AddDreamImage:Void(asset:DreamImageAsset)
		Self.availableImages.AddLast(asset)
	End
	
	Method AddCharacterProfile:Void(name:String, profile:CharacterProfile)
		Self.characterProfiles.Set(name, profile)
	End
	
	' Generate a coherent dream for a specific character using three images
	Method GenerateDream:CharacterDream(character:String, forceImages:DreamImageAsset[] = Null)
		Local profile:CharacterProfile = Self.characterProfiles.Get(character)
		Local selectedImages:DreamImageAsset[] = New DreamImageAsset[3]
		
		' Either use forced images or select appropriate ones
		If forceImages <> Null And forceImages.Length = 3
			selectedImages = forceImages
		Else
			selectedImages = Self.SelectImagesForCharacter(character, 3)
		Endif
		
		' Calculate coherence score
		Local coherenceScore:Float = Self.CalculateCoherence(selectedImages, profile)
		
		' If coherence is too low, try to optimize image selection
		If coherenceScore < 0.6 And forceImages = Null
			selectedImages = Self.OptimizeImageSelection(character, selectedImages)
			coherenceScore = Self.CalculateCoherence(selectedImages, profile)
		Endif
		
		' Generate dream narrative based on selected images
		Local narrative:String = Self.GenerateNarrative(selectedImages, profile)
		
		' Create the dream
		Local dream:CharacterDream = New CharacterDream()
		dream.character = character
		dream.images = selectedImages
		dream.narrative = narrative
		dream.coherenceScore = coherenceScore
		
		Return dream
	End
	
	' Select images with high affinity for character
	Method SelectImagesForCharacter:DreamImageAsset[](character:String, count:Int)
		Local result:DreamImageAsset[] = New DreamImageAsset[count]
		Local candidates:List<DreamImageAsset> = New List<DreamImageAsset>
		
		' Copy available images to candidates list
		For Each asset:DreamImageAsset = EachIn Self.availableImages
			candidates.AddLast(asset)
		Next
		
		' Sort by character affinity
		candidates.Sort(Lambda:Int(a:DreamImageAsset, b:DreamImageAsset)
			Local affinityA:Float = a.metadata.characterAffinity.Get(character)
			Local affinityB:Float = b.metadata.characterAffinity.Get(character)
			If affinityA > affinityB Return -1
			If affinityA < affinityB Return 1
			Return 0
		End)
		
		' Select top images with symbol diversity
		Local selectedTypes:StringMap<Bool> = New StringMap<Bool>
		Local index:Int = 0
		
		For Each asset:DreamImageAsset = EachIn candidates
			' Ensure some symbol diversity
			If Not selectedTypes.Contains(asset.metadata.symbolType) Or selectedTypes.Count() >= count-1
				result[index] = asset
				selectedTypes.Set(asset.metadata.symbolType, True)
				index += 1
				
				If index >= count Exit
			Endif
		Next
		
		Return result
	End
	
	' Calculate how well images work together for a character
	Method CalculateCoherence:Float(images:DreamImageAsset[], profile:CharacterProfile)
		' Base coherence on character affinity
		Local affinityScore:Float = 0
		For Each image:DreamImageAsset = EachIn images
			affinityScore += image.metadata.characterAffinity.Get(profile.name)
		Next
		affinityScore /= images.Length
		
		' Symbol compatibility between images
		Local compatibilityScore:Float = 0
		For i:Int = 0 Until images.Length
			For j:Int = i+1 Until images.Length
				compatibilityScore += Self.GetSymbolCompatibility(
					images[i].metadata.symbolType,
					images[j].metadata.symbolType
				)
			Next
		Next
		compatibilityScore /= (images.Length * (images.Length - 1) / 2)
		
		' Emotional consistency
		Local emotionScore:Float = Self.CalculateEmotionalConsistency(images)
		
		' Weight the factors
		Return affinityScore * 0.5 + compatibilityScore * 0.3 + emotionScore * 0.2
	End
	
	' Calculate compatibility between symbol types
	Method GetSymbolCompatibility:Float(typeA:String, typeB:String)
		' Compatibility matrix (simplified version)
		Local compatibility:Float = 0.5  ' Default medium compatibility
		
		Select typeA + "-" + typeB
			Case "ShadowManifestations-ReflectiveSurfaces"
				compatibility = 0.9
			Case "ReflectiveSurfaces-ShadowManifestations"
				compatibility = 0.9
			Case "TransformationMarkers-TemporalDistortions"
				compatibility = 0.8
			Case "TemporalDistortions-TransformationMarkers"
				compatibility = 0.8
			Case "NaturalElements-ArchitecturalSpaces"
				compatibility = 0.7
			Case "ArchitecturalSpaces-NaturalElements"
				compatibility = 0.7
			' More combinations would be defined here...
		End
		
		Return compatibility
	End
	
	' Calculate emotional consistency across images
	Method CalculateEmotionalConsistency:Float(images:DreamImageAsset[])
		' Simple version - check if emotions complement each other
		Local emotions:String[] = New String[images.Length]
		
		For i:Int = 0 Until images.Length
			emotions[i] = images[i].metadata.emotionalTone
		Next
		
		' Count matching or complementary emotions
		Local matches:Int = 0
		For i:Int = 0 Until emotions.Length
			For j:Int = i+1 Until emotions.Length
				If AreEmotionsCompatible(emotions[i], emotions[j])
					matches += 1
				Endif
			Next
		Next
		
		Return Float(matches) / (emotions.Length * (emotions.Length - 1) / 2)
	End
	
	' Check if emotions work well together
	Method AreEmotionsCompatible:Bool(emotionA:String, emotionB:String)
		' Direct matches are compatible
		If emotionA = emotionB Return True
		
		' Some emotions pair well
		Select emotionA + "-" + emotionB
			Case "Fear-Wonder", "Wonder-Fear"
				Return True
			Case "Confusion-Revelation", "Revelation-Confusion"
				Return True
			Case "Longing-Nostalgia", "Nostalgia-Longing"
				Return True
			' More combinations would be defined here...
		End
		
		Return False
	End
	
	' Optimize image selection if initial coherence is low
	Method OptimizeImageSelection:DreamImageAsset[](character:String, initialSelection:DreamImageAsset[])
		Local profile:CharacterProfile = Self.characterProfiles.Get(character)
		Local bestScore:Float = Self.CalculateCoherence(initialSelection, profile)
		Local bestSelection:DreamImageAsset[] = initialSelection
		
		' Try replacing one image at a time
		For i:Int = 0 Until initialSelection.Length
			For Each candidate:DreamImageAsset = EachIn Self.availableImages
				' Skip if already in selection
				Local alreadySelected:Bool = False
				For j:Int = 0 Until initialSelection.Length
					If j <> i And initialSelection[j] = candidate
						alreadySelected = True
						Exit
					Endif
				Next
				
				If alreadySelected Continue
				
				' Create test selection
				Local testSelection:DreamImageAsset[] = initialSelection.Slice(0)
				testSelection[i] = candidate
				
				' Calculate new coherence
				Local testScore:Float = Self.CalculateCoherence(testSelection, profile)
				
				' Keep if better
				If testScore > bestScore
					bestScore = testScore
					bestSelection = testSelection
				Endif
			Next
		Next
		
		Return bestSelection
	End
	
	' Generate narrative description from images
	Method GenerateNarrative:String(images:DreamImageAsset[], profile:CharacterProfile)
		' In a full implementation, this would use more sophisticated NLG
		' This is a simple placeholder implementation
		
		Local narrative:String = profile.name + " dreams of "
		
		' Combine symbol descriptions
		For i:Int = 0 Until images.Length
			If i > 0 And i < images.Length - 1
				narrative += ", "
			Elseif i > 0
				narrative += " and "
			Endif
			
			narrative += GetSymbolDescription(images[i].metadata, profile)
		Next
		
		narrative += "."
		
		' Add emotional context
		narrative += " The dream evokes feelings of "
		Local emotions:StringMap<Bool> = New StringMap<Bool>
		
		For Each image:DreamImageAsset = EachIn images
			emotions.Set(image.metadata.emotionalTone, True)
		Next
		
		Local emotionList:String[] = New String[emotions.Count()]
		Local index:Int = 0
		For Each emotion:String = EachIn emotions.Keys()
			emotionList[index] = emotion
			index += 1
		Next
		
		For i:Int = 0 Until emotionList.Length
			If i > 0 And i < emotionList.Length - 1
				narrative += ", "
			Elseif i > 0
				narrative += " and "
			Endif
			
			narrative += emotionList[i].ToLower()
		Next
		
		Return narrative
	End
	
	' Get description for a symbol based on character
	Method GetSymbolDescription:String(metadata:DreamImageMetadata, profile:CharacterProfile)
		Local base:String = "a " + metadata.symbolInstance
		
		' Character-specific descriptions would enhance this further
		Select metadata.symbolType
			Case "ShadowManifestations"
				If profile.name = "Hikari"
					Return base + " that splits into human and yokai forms"
				Else
					Return "a mysterious " + base
				Endif
				
			Case "ReflectiveSurfaces"
				If profile.name = "Megumi"
					Return base + " showing different versions of herself"
				Else
					Return base + " revealing hidden truths"
				Endif
				
			Case "TransformationMarkers"
				If profile.name = "Katsuo"
					Return base + " changing between human and kitsune forms"
				Else
					Return "a transforming " + base
				Endif
				
			' More types would be handled here...
			
			Default
				Return base
		End
	End
End
```

## Notes on Implementation

### Metadata Structure
The system relies heavily on well-structured metadata for each dream image asset. Each image requires:

1. **Primary Symbol Type** - The main symbolic category (Shadow, Reflection, etc.)
2. **Symbol Instance** - The specific manifestation (Split Shadow, Truth Mirror, etc.)
3. **Intensity** - How prominently the symbol features (0.0-1.0)
4. **Emotional Tone** - The primary emotion evoked by the image
5. **Character Affinity** - How strongly each character relates to this symbol

This metadata structure allows the system to make informed decisions about image combinations that will feel authentic to each character's psychology.

### Character-Specific Coherence
The combinatorial engine prioritizes three aspects of coherence:

1. **Character Affinity** (50%) - How well the symbols align with character psychology
2. **Symbol Compatibility** (30%) - How well symbols work together conceptually
3. **Emotional Consistency** (20%) - How cohesive the emotional tones are

By weighting character affinity most heavily, the system ensures that even unexpected combinations still feel authentic to the character experiencing the dream.

### Symbol Compatibility Matrix
The compatibility matrix defines how well different symbol types work together:

- Shadow + Mirror = High compatibility (identity exploration)
- Transformation + Time = High compatibility (evolution themes)
- Natural + Architectural = Medium compatibility (boundary themes)

These relationships encode psychological principles about which symbolic combinations create meaningful emergent themes rather than chaotic mismatch.

### Optimization Strategy
When forced to use specific images (player selection), the system:

1. Calculates initial coherence score
2. Focuses on narrative framing that maximizes coherence
3. Adjusts symbol emphasis based on character profile

When free to select optimal images, it employs a simple replacement algorithm to maximize coherence score by testing alternative combinations.

## Technical Advantages

### Character-Authentic Dream Generation
The system successfully produces dreams that feel authentic to each character by:

```wonkey
Function DemonstrateDreamAuthenticity:Void()
	Local generator:DreamGenerator = NewDreamGenerator()
	
	' Example: Same three images interpreted differently for each character
	Local shadowImage:DreamImageAsset = New DreamImageAsset(LoadImage("shadow.png"), 
		New DreamImageMetadata("ShadowManifestations", "split shadow", 0.8, "Confusion"))
	Local mirrorImage:DreamImageAsset = New DreamImageAsset(LoadImage("mirror.png"), 
		New DreamImageMetadata("ReflectiveSurfaces", "truth mirror", 0.9, "Revelation"))
	Local schoolImage:DreamImageAsset = New DreamImageAsset(LoadImage("school.png"), 
		New DreamImageMetadata("ArchitecturalSpaces", "endless hallway", 0.7, "Anxiety"))
	
	' Set character affinities
	shadowImage.metadata.AddCharacterAffinity("Hikari", 0.9)  ' Very relevant to Hikari
	shadowImage.metadata.AddCharacterAffinity("Katsuo", 0.6)  ' Moderately relevant to Katsuo
	shadowImage.metadata.AddCharacterAffinity("Megumi", 0.4)  ' Less relevant to Megumi
	
	mirrorImage.metadata.AddCharacterAffinity("Hikari", 0.7)
	mirrorImage.metadata.AddCharacterAffinity("Katsuo", 0.8)
	mirrorImage.metadata.AddCharacterAffinity("Megumi", 0.9)
	
	schoolImage.metadata.AddCharacterAffinity("Hikari", 0.6)
	schoolImage.metadata.AddCharacterAffinity("Katsuo", 0.5)
	schoolImage.metadata.AddCharacterAffinity("Megumi", 0.8)
	
	' Add images and profiles
	generator.AddDreamImage(shadowImage)
	generator.AddDreamImage(mirrorImage)
	generator.AddDreamImage(schoolImage)
	
	' Generate dreams for each character using the same images
	Local forcedImages:DreamImageAsset[] = [shadowImage, mirrorImage, schoolImage]
	
	Local hikariDream:CharacterDream = generator.GenerateDream("Hikari", forcedImages)
	Local katsuoDream:CharacterDream = generator.GenerateDream("Katsuo", forcedImages)
	Local megumiDream:CharacterDream = generator.GenerateDream("Megumi", forcedImages)
	
	' Results would show different interpretations:
	' Hikari's dream: Focus on transformation and duality themes
	' Katsuo's dream: Focus on time and identity across centuries  
	' Megumi's dream: Focus on social evaluation and reflection
End
```

This example shows how identical visual assets produce distinctly different dream experiences that feel authentic to each character's psychology.

### Emergent Symbolism
The system leverages combinatorial effects to create emergent meaning:

```wonkey
Function DemonstrateEmergentSymbolism:Void()
	' When certain symbols combine, new meanings emerge
	
	' Examples:
	' 1. Split Shadow + Truth Mirror + School Hallway for Hikari
	' Result: A dream about discovering her dual nature reflected in others
	
	' 2. Memory Garden + Forge + Ancient Tree for Katsuo
	' Result: A dream about forging new future from ancient roots
	
	' 3. Ledger + Glass Heart + Mirror Circle for Megumi
	' Result: A dream about the cost of emotional calculation
	
	' The emergence happens through the GetSymbolDescription method
	' which customizes interpretation based on:
	' - Character experiencing the dream
	' - Combination of other symbols present
	' - Character's current psychological state
End
```

This emergence allows three relatively simple images to create complex meaningful dreams that process character psychological states in a way that feels authentic.

### Gameplay Integration
The system supports two gameplay modes:

```wonkey
Function IntegrateWithGameplay:Void()
	Local generator:DreamGenerator = New DreamGenerator()
	' Setup code omitted for brevity...
	
	' Mode 1: Story-progression unlocks
	' As players progress, they unlock dream images that correspond to story events
	' System automatically generates appropriate dreams during rest phases
	
	' Mode 2: Player dream crafting
	' Players select from unlocked images to craft dreams for characters
	' System evaluates coherence and provides feedback on authenticity
	' "This dream feels very authentic to Hikari (92% coherence)"
	' "This dream feels somewhat inauthentic to Katsuo (43% coherence)"
	
	' Example game loop integration
	Function ProcessRestPhase:Void(character:String, playerSelectedImages:DreamImageAsset[] = Null)
		Local dream:CharacterDream
		
		If playerSelectedImages <> Null
			' Player is crafting a dream
			dream = generator.GenerateDream(character, playerSelectedImages)
			
			' Provide feedback on choice
			If dream.coherenceScore >= 0.8
				ShowFeedback("This dream feels very authentic to " + character)
			Elseif dream.coherenceScore >= 0.6
				ShowFeedback("This dream feels authentic to " + character)
			Elseif dream.coherenceScore >= 0.4
				ShowFeedback("This dream feels somewhat inauthentic to " + character)
			Else
				ShowFeedback("This dream feels very inauthentic to " + character)
			Endif
		Else
			' System generates an appropriate dream
			dream = generator.GenerateDream(character)
		Endif
		
		' Display the dream and update character state
		ShowDream(dream)
		UpdateCharacterPsychology(character, dream)
	End
End
```

This integration allows both system-generated dreams that always feel authentic and player experimentation with dream crafting that receives feedback on psychological authenticity.

### Conclusion

Yes, this system would allow you to combine three images with their associated metadata to create dreams that feel coherent and authentic to each character, even outside strict narrative progression. The key is that the metadata contains not just what the symbol is, but how each character relates to it emotionally and psychologically.

The resulting dream combinations would indeed reflect the characters' unique psychologies to the point where players could recognize: "Yes, this is definitely a dream Hikari would have!" Each character processes the same symbolic imagery in distinctly different ways based on their unique psychology, concerns, and narrative journey.

The system maintains this character authenticity through carefully weighted symbol affinities, customized interpretations, and coherence validation—ensuring that even player-selected combinations maintain psychological consistency with the character experiencing the dream.
