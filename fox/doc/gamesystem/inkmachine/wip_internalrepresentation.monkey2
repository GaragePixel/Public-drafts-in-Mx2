#Import "<stdlib>"

'Using stdlib..'io.json
'Using stdlib.io.filesystem
Using stdlib.collections..
Using stdlib.math.random

Class Story 
	
	Method New(inkVersion:Int)
		Version = inkVersion
	End
	
	Method AddElement(element:StoryElement)
		_root.AddLast(element)
	End
	
	Property Version:Int()
		Return _inkVersion 
	Setter(version:int)
		_inkVersion=version
	End
	
	Property Root:List<StoryElement>() 'Read only!
		Return _root
	End 

	' Metadata about the story
	Field _inkVersion:Int
	Field _root:List<StoryElement> = New List<StoryElement>()

End

' Abstract base class for all story elements
Class StoryElement

	Enum Kinds
		Narrative 
		MediaTrigger 
		Choice 
		Branch 
		NarrativeBranch
		Sequence 
		Alternative
		Condition 
		Func'TODO
		Scene 
	End 
	
	Property Kind:StoryElement.Kinds()
		Return _kind
	End

	Operator To:String()
		
		select _kind
			Case StoryElement.Kinds.Narrative
				Return "Narrative"
			Case StoryElement.Kinds.MediaTrigger 
				Return "MediaTrigger"
			Case StoryElement.Kinds.Choice 
				Return "Choice"
			Case StoryElement.Kinds.Condition 
				Return "Condition"
			Case StoryElement.Kinds.Branch
				Return "Branch"
		End 
		
		Return "Scene"
	End
	
	Protected
	
	Field _kind:StoryElement.Kinds
End

' Narrative element (e.g., text prefixed with "^")
Class Narrative Extends StoryElement

	' Since Glues are special character sequence codes who can't be placed in
	' the middle of a phrase, the formatting must be carefully handled. 
	' The glue is a parameter and so then it's the property who overrides the content 
	' before return it, and not the one (human or machine) who has wrote the content, 
	' keeping the formatted output under control.
	Enum TypeGlue
		Normal 
		GluedAtStart
		GluedAtEnd
		Glued=GluedAtEnd 'default glue mode, similar to GluedAtEnd
	End 
	
	Property Content:String()
		'The content isn't formatted for direct printing (aside debugging) but for
		'a generic "output story parser" specific to an player/game engine.
		'This generic parser must be able to parse the generic formatting before
		'parsing specific features according the specific used engine.
		Local result:String
		Select _glue 
			Case Narrative.TypeGlue.GluedAtStart
				result="<> "+_content
			Case Narrative.TypeGlue.GluedAtEnd
				result=_content+" <>"
			Default
				result=_content
		End
		Return result
	End

	Property Glue:Narrative.TypeGlue()
		Return _glue
	End
	
	Method New(content:String,glue:Narrative.TypeGlue=Narrative.TypeGlue.Normal)
		Super._kind=StoryElement.Kinds.Narrative
		_glue=glue
		_content = content
	End

	Private 
	
	Field _content:String
	Field _glue:Narrative.TypeGlue
End

' Media trigger (e.g., images, music, or sound effects)
Class MediaTrigger Extends StoryElement

	Field mediaType:String
	Field identifier:String
	
	Method New(mediaType:String, identifier:String)
		Super._kind=StoryElement.Kinds.MediaTrigger
		Self.mediaType = mediaType
		Self.identifier = identifier
	End

End

' Choice element representing a player's decision
Class Choice Extends StoryElement

	Field text:String
	Field outcomeKey:String
	
	Method New(text:String, outcomeKey:String)
		Super._kind=StoryElement.Kinds.Choice
		Self.text = text
		Self.outcomeKey = outcomeKey
	End

End

' Conditional logic used to control branching
Class Condition Extends StoryElement

	Field variable:String
	Field comparator:String
	Field value:Variant
	
	Method New(variable:String, comparator:String, value:Variant)
		Super._kind=StoryElement.Kinds.Condition
		Self.variable = variable
		Self.comparator = comparator
		Self.value = value
	End
End

' A branch that connects parts of the story
Class Branch Extends StoryElement

	Field targetKey:String
	
	Method New(targetKey:String)
		Super._kind=StoryElement.Kinds.Branch
		Self.targetKey = targetKey
	End
End

' A branch who can display content that connects parts of the story
Class NarrativeBranch Extends StoryElement

	Field _narrative:Narrative
	Field _branch:Branch
	
	Method New(content:String,targetKey:String,glue:Narrative.TypeGlue=Narrative.TypeGlue.Normal)
		Super._kind=StoryElement.Kinds.NarrativeBranch
		_narrative=New Narrative(content,glue)
		_branch=New Branch(targetKey)
	End
End

' A branch who can display content that connects parts of the story
Class Sequence Extends StoryElement

	Enum Types
		Stopping 'go through the alternatives, and stick on last
		Cycle 'show each in turn, and then cycle
		Shuffle 'show one at random
		Once 'show each, once, in turn, until all have been shown
		
		'advanced
		ShuffleOnce 'which will shuffle the content, play through it, and then do nothing.
		shuffleStops 'will shuffle all the content (except the last entry), and once its been played, it'll stick on the last entry
	End 
	
	Field _alternatives:Stack<Alternative>
	Field _currentalternative:UInt=0
	Field _type:Sequence.Types
	
	Method New(type:Sequence.Types=Sequence.Types.Stopping)
		Super._kind=StoryElement.Kinds.Sequence
		_type=type
		_alternatives=New Stack<Alternative>
	End
	
	'Choose an alternative to return, accr the alternative's internal counter
	Method Shuffle:Alternative()
		
		Local result:Alternative
		Select _type 
			
			'go through the alternatives, and stick on last
			Case Sequence.Types.Stopping 
				Local alt:Alternative
				For alt=Eachin _alternatives
					If alt._counter=0
						alt._counter+=1
						result=alt
					End
				End  
				'Returns the last one; sticks on the last if every last one already visited
				If result=Null 
					result=_alternatives[_alternatives.Length-1]
					result._counter+=1
				End
				
			'show each in turn, and then cycle
			Case Sequence.Types.Cycle 
				Local alt:Alternative
				For alt=Eachin _alternatives
					If alt._counter=0
						alt._counter+=1
						result=alt
					End
				End 
				If result=Null 'Every Alternatives was already visited
					'Reinit
					For alt=Eachin _alternatives
						alt._counter=0
					End
					'returns the first one
					result=_alternatives[0]
					result._counter+=1
				End
				
			'show one at random
			Case Sequence.Types.Shuffle 
				Local rnd:UInt=Rnd(0,_alternatives.Length-1)
				result=_alternatives[rnd]
				result._counter+=1
				
			'show each, once, in turn, until all have been shown
			Case Sequence.Types.Once 
				Local alt:Alternative
				For alt=Eachin _alternatives
					If alt._counter=0
						alt._counter=1
						result=alt
					End
				End  
				'Returns no Alternative
				result=Null

			'which will shuffle the content, play through it, and then do nothing.
			Case Sequence.Types.ShuffleOnce 
				Local esc:Bool=False 
				Local tried:UInt=_alternatives.Length-1
				Local rnd:UInt
				Local tmp:Alternative
				Repeat
					rnd=Rnd(0,_alternatives.Length-1)
					tmp=_alternatives[rnd]
					If tmp._counter=0 esc=True
					tried-=1
					If tried=0 esc=True
				Until esc=True
				If tried<>0 
					result=tmp 'A no-visited-yet Alternative was found
					result._counter+=1
				Else 
					result=Null 'Each Alternatives was visited once, return nothing
				End
				
			'will shuffle all the content (except the last entry), and once its been played, it'll stick on the last entry			
			Case Sequence.Types.shuffleStops 
				Local esc:Bool=False 
				Local tried:UInt=_alternatives.Length-1
				Local rnd:UInt
				Local tmp:Alternative
				Repeat
					If _alternatives.Length>=2
						rnd=Rnd(0,_alternatives.Length-2) 'At least two items in the stack
					Else 
						result=_alternatives[0] 'Only one item in the stack
						result._counter+=1
						Return result
					End
					tmp=_alternatives[rnd]
					If tmp._counter=0 esc=True
					tried-=1
					If tried=1 esc=True
				Until esc=True
				If tried<>1 'Not each Alternative tested
					result=tmp 'A no-visited-yet Alternative was found
					result._counter+=1
				Else 'Each Alternative tested but the last one; return the last one 
					result=_alternatives[_alternatives.Length-1]
					result._counter+=1
				End
		End 
		Return result 
	End 
	
	Method AddlAternative:Bool(element:StoryElement)
		
		'Usage example:
		'	'This sequence represents the name changement of the original language
		'	Local mySequence=New Sequence( Sequence.Types.Stopping )
		'	Local mySequence.AddAlternative( New Alternative( New Narrative( "Monkey! oOk oOk" )))
		'	Local mySequence.AddAlternative( New Alternative( New Narrative( "Wonkey! huu huu" )))
		'	Local mySequence.AddAlternative( New Alternative( New NarrativeBranch( "Aida", "4" )))
		
		'Only Narrative/Branch/NarrativeBranch can be nested to a Sequence
		If element.Kind=StoryElement.Kinds.Narrative Or
			element.Kind=StoryElement.Kinds.Branch Or
			element.Kind=StoryElement.Kinds.NarrativeBranch
		
			_alternatives.Add(New Alternative(element))
		
			Return True 'Successfully added
		End
		
		Print "Warning: Wrong Alternative type, can't be added."
		Return False 'Not added	
	End
	
	Class Alternative 'okay it's just a node
	
		Field _kind:StoryElement.Kinds
		Field _alternative:StoryElement
		Field _counter:UInt=0
		
		Method New(alternative:StoryElement)
			_kind=alternative.Kind
			_alternative=alternative 
		End
		
		Property Element:StoryElement()
			Return _alternative 
		End 

		Property Counter:UInt() 'Read only!
			Return _counter 
		End
	End	
End



' A container for a scene or a segment of the story
Class Scene Extends StoryElement

	Field key:String
	Field elements:List<StoryElement> = New List<StoryElement>()
	
	Method New(key:String)
		Super._kind=StoryElement.Kinds.Scene
		Self.key = key
	End
	
	Method AddElement(element:StoryElement)
		elements.AddLast(element)
	End
End

' Main logic for representing the JSON structure
Class Book
	
	Method New(title:String, inkVersion:Int=21)
		_title=title
		_story = New Story(inkVersion)
	End
	
	Property Title:String()
		Return _title 
	End 

	Property Story:Story()
		Return _story
	End 
	
	Method AddScene:Scene(key:String)
		Local scene:Scene = New Scene(key)
		_story.AddElement(scene)
		Return scene
	End
	
	Method AddNarrative(content:String,glue:Narrative.TypeGlue=Narrative.TypeGlue.Normal)
		_story.AddElement(New Narrative(content,glue))
	End
	
	Method AddMediaTrigger(mediaType:String, identifier:String)
		_story.AddElement(New MediaTrigger(mediaType, identifier))
	End
	
	Method AddChoice(text:String, outcomeKey:String)
		_story.AddElement(New Choice(text, outcomeKey))
	End
	
	Method AddCondition(variable:String, comparator:String, value:Variant)
		_story.AddElement(New Condition(variable, comparator, value))
	End
	
	Method AddBranch(targetKey:String)
		_story.AddElement(New Branch(targetKey))
	End

	Method AddNarrativeBranch(content:String, targetKey:String, glue:Narrative.TypeGlue=Narrative.TypeGlue.Normal)
		_story.AddElement(New NarrativeBranch(content,targetKey,glue))
	End
	
	Private 

	Field _story:Story
	Field _title:String
End

' Example usage
Function Main()
	Local story:Book = CreateProject()
	Print("Story structure created successfully.")
	
	' List all elements
	ListStoryElements(story)
End

' Routine to recursively list all elements in a story
Function ListStoryElements(book:Book)
	Print("Listing Story Elements:")
	Print("------------------------")
	
	' Get the root story object
	Local story:Story = book.Story
	
	' Iterate over all root elements in the story
	For Local element:StoryElement = Eachin story.Root
		PrintElement(element, 0)
	End
End

Function CreateIntendationToken:String(indentLevel:Int)
	Local indent:String
	For Local i:Int = 0 Until indentLevel
		indent += " "
	End	
	Return indent
End

' Recursive function to print details of a StoryElement and its children
Function PrintElement(element:StoryElement, indentLevel:Int=3)
	Local indent:String = CreateIntendationToken(indentLevel) ' Create appropriate indentation
	
	Local kind:=element.Kind
	'Print element
	
	Select kind
		Case StoryElement.Kinds.Narrative
			'Local narrative:= element
			Local narrative:Narrative = Cast<Narrative>(element)
			Print(indent + "Narrative: " + narrative.Content)
		Case StoryElement.Kinds.MediaTrigger
			Local media:=Cast<MediaTrigger>(element)
			Print(indent + "MediaTrigger: " + media.mediaType + ": " + media.identifier)
		Case StoryElement.Kinds.Choice
			Local choice:=Cast<Choice>(element)
			Print(indent + "Choice: " + choice.text + " -> " + choice.outcomeKey)
		Case StoryElement.Kinds.Condition
			Local condition:=Cast<Condition>(element)
'			Print(indent + "Condition: " + condition.variable + " " + condition.comparator + " " + condition.value)
		Case StoryElement.Kinds.Branch
			Local branch:=Cast<Branch>(element)
			Print(indent + "Branch: -> " + branch.targetKey)
		Case StoryElement.Kinds.Scene
			Local scene:=Cast<Scene>(element)
			Print(indent + "Scene: " + scene.key)
			' Recursively print all elements in the scene
			For Local child:StoryElement = Eachin scene.elements
				PrintElement(child, indentLevel + 1)
			End
		Default
			Print(indent + "Unknown Element")
	End
	
End

Function CreateProject:Book()
	' Create a sample story
	Local story:Book = New Book("FoxRomance",21) ' Inky version 21
	
	' Add global elements to the story
	story.AddMediaTrigger("image", "city_summer_afternoon")
	story.AddMediaTrigger("music", "summer_ambient")
	story.AddMediaTrigger("sfx", "cicadas")
	story.AddNarrative("The summer heat shimmered over the pavement as I walked through the shopping district, heading nowhere in particular. School was out, and I had all the time in the world to wander.")
	story.AddNarrative("That's when I noticed him.")
	story.AddMediaTrigger("image", "katsuo_lost")
	story.AddMediaTrigger("music", "encounter_theme")
	story.AddNarrative("A boy my age stood at the intersection, his gaze flickering between a crumpled piece of paper in his hands and the buildings surrounding him. Something about him immediately caught my attention.")
	story.AddNarrative("Not only was he handsome—though he definitely was—but there was something... different.")
	story.AddNarrative("I hesitated for a moment, then decided to approach him.")
	story.AddMediaTrigger("image", "katsuo_closeup")
	story.AddNarrative("[Hikari: Are you lost?] I asked.")
	story.AddNarrative("He looked up, startled by my voice. [Boy: Ah, yes.] His voice was surprisingly gentle. [Boy: I'm looking for the Yokai Artifacts Museum. It's supposed to be somewhere in this area.]")
	story.AddNarrative("[Hikari: You're not too far off. It's just a few blocks that way.] I pointed down the side street.")
	story.AddNarrative("For just a moment—so briefly I almost thought I imagined it—I saw something shimmer around his form. Like an outline of... something else.")

	' Add choices to the story
	story.AddChoice("Pretend not to notice", "notice_nothing")
	story.AddChoice("Look more carefully", "notice_something")
	
	' Scene: notice_nothing
	Local sceneNoticeNothing:Scene = story.AddScene("notice_nothing")
	sceneNoticeNothing.AddElement(New Narrative("I blinked and kept my expression neutral. Whatever I'd seen—or thought I'd seen—was none of my business."))
	sceneNoticeNothing.AddElement(New Narrative("Some people deserve their privacy, their secrets."))
	sceneNoticeNothing.AddElement(New Branch("continue_conversation"))

	' Scene: notice_something
	Local sceneNoticeSomething:Scene = story.AddScene("notice_something")
	sceneNoticeSomething.AddElement(New Narrative("I couldn't help it: my eyes widened slightly as I looked at him more closely."))
	sceneNoticeSomething.AddElement(New Narrative("Yes, I saw, I saw his tails, his pointy ears... this boy... whom everyone could see, was an image."))
	sceneNoticeSomething.AddElement(New Branch("continue_conversation"))

	' Scene: continue_conversation
	Local sceneContinue:Scene = story.AddScene("continue_conversation")
	sceneContinue.AddElement(New Narrative("[Boy: The Yokai Museum...] he repeated, looking at his map again."))
	sceneContinue.AddElement(New Narrative("[Boy: I'm afraid I'm still not familiar with this area. I'm... new in town.]"))
	sceneContinue.AddElement(New Choice("Offer to guide him there", "offer_guide"))
	sceneContinue.AddElement(New Choice("Just give directions", "give_directions"))

	' Scene: offer_guide
	Local sceneOfferGuide:Scene = story.AddScene("offer_guide")
	sceneOfferGuide.AddElement(New Narrative("I wanted to be with him a little longer, find any excuse, but I wanted it to last longer than a fleeting encounter."))
	sceneOfferGuide.AddElement(New Narrative("[Hikari: I could show you the way, if you'd like] I offered."))
	sceneOfferGuide.AddElement(New Branch("arrive_at_museum"))

	' Scene: give_directions
	Local sceneGiveDirections:Scene = story.AddScene("give_directions")
	sceneGiveDirections.AddElement(New Narrative("[Hikari: It's three blocks down this street, then turn left at the bookstore. You'll see it just past the old temple gate. You can't miss the kitsune statues outside.]"))
	sceneGiveDirections.AddElement(New Branch("arrive_at_museum_alone"))

	' Scene: arrive_at_museum
	Local sceneArriveAtMuseum:Scene = story.AddScene("arrive_at_museum")
	sceneArriveAtMuseum.AddElement(New Narrative("We arrived at the small, traditional building that housed the Yokai Museum."))
	sceneArriveAtMuseum.AddElement(New Narrative("[Hikari: Here we are] I said, stopping at the steps. [Boy: May I ask your name?]"))
	sceneArriveAtMuseum.AddElement(New Narrative("[Hikari: Hikari] I said."))
	sceneArriveAtMuseum.AddElement(New Branch("summer_search"))

	' Scene: arrive_at_museum_alone
	Local sceneArriveAlone:Scene = story.AddScene("arrive_at_museum_alone")
	sceneArriveAlone.AddElement(New Narrative("From a distance, I watched as the mysterious boy found the museum and went inside."))
	sceneArriveAlone.AddElement(New Branch("summer_search"))

	' Scene: summer_search
	Local sceneSummerSearch:Scene = story.AddScene("summer_search")
	sceneSummerSearch.AddElement(New Narrative("The encounter with Katsuo lingered in my mind for days and weeks."))
	sceneSummerSearch.AddElement(New Choice("Research kitsune folklore intensively", "research_folklore"))
	sceneSummerSearch.AddElement(New Choice("Visit the museum regularly", "visit_museum"))
	sceneSummerSearch.AddElement(New Choice("Wait at our meeting spot", "wait_spot"))
	sceneSummerSearch.AddElement(New Choice("Try to forget the encounter", "forget_encounter"))

	Return story
End
