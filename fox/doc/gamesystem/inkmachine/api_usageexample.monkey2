Function CreateProject:Book()
	' Create a sample story
	Local story:Book = New Book(21) ' Inky version 21
	
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
	story.AddNarrative("\Are you lost?\ I asked.")
	story.AddNarrative("He looked up, startled by my voice. \Ah, yes.\ His voice was surprisingly gentle. \I'm looking for the Yokai Artifacts Museum. It's supposed to be somewhere in this area.\")
	story.AddNarrative("\You're not too far off. It's just a few blocks that way.\ I pointed down the side street.")
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
	sceneContinue.AddElement(New Narrative("\The Yokai Museum...\ he repeated, looking at his map again."))
	sceneContinue.AddElement(New Narrative("I'm afraid I'm still not familiar with this area. I'm... new in town."))
	sceneContinue.AddElement(New Choice("Offer to guide him there", "offer_guide"))
	sceneContinue.AddElement(New Choice("Just give directions", "give_directions"))

	' Scene: offer_guide
	Local sceneOfferGuide:Scene = story.AddScene("offer_guide")
	sceneOfferGuide.AddElement(New Narrative("I wanted to be with him a little longer, find any excuse, but I wanted it to last longer than a fleeting encounter."))
	sceneOfferGuide.AddElement(New Narrative("\I could show you the way, if you'd like\ I offered."))
	sceneOfferGuide.AddElement(New Branch("arrive_at_museum"))

	' Scene: give_directions
	Local sceneGiveDirections:Scene = story.AddScene("give_directions")
	sceneGiveDirections.AddElement(New Narrative("\It's three blocks down this street, then turn left at the bookstore. You'll see it just past the old temple gate. You can't miss the kitsune statues outside.\"))
	sceneGiveDirections.AddElement(New Branch("arrive_at_museum_alone"))

	' Scene: arrive_at_museum
	Local sceneArriveAtMuseum:Scene = story.AddScene("arrive_at_museum")
	sceneArriveAtMuseum.AddElement(New Narrative("We arrived at the small, traditional building that housed the Yokai Museum."))
	sceneArriveAtMuseum.AddElement(New Narrative("\Here we are\ I said, stopping at the steps. \May I ask your name?\"))
	sceneArriveAtMuseum.AddElement(New Narrative("\Hikari\ I said."))
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
