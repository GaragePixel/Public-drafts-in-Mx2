// FOX SPIRIT ROMANCE: PROLOGUE
// Episode 1: Summer Encounter
// Implementation: iDkP from GaragePixel
// Date: 2025-04-08

// =============================================
// VARIABLES SETUP
// =============================================

VAR player_name = "Hikari"
VAR trust_level = 0
VAR knowledge_level = 0
VAR understanding_level = 0
VAR determination_level = 0
VAR patience_level = 0

// =============================================
// CHOICE TRACKING
// =============================================

VAR research_visits = 0
VAR museum_visits = 0
VAR wait_visits = 0
VAR dreams_visited = false
VAR total_choices_made = 0

VAR came_from_research = false
VAR came_from_museum = false
VAR came_from_waiting = false


// =============================================
// CREDITS SEQUENCE TRACKING
// =============================================

VAR credits_museum = false
VAR credits_research = false
VAR credits_waiting = false
VAR credits_dreams = false
VAR credits_shown = 0

// =============================================
// START
// =============================================

# image: city_summer_afternoon
# music: summer_ambient
# sfx: cicadas

The summer heat shimmered over the pavement as I walked through the shopping district, heading nowhere in particular. School was out, and I had all the time in the world to wander.

That's when I noticed him.

# image: katsuo_lost
# music: encounter_theme

A boy my age stood at the intersection, his gaze flickering between a crumpled piece of paper in his hands and the buildings surrounding him. Something about him immediately caught my attention.

Not only was he handsome—though he definitely was—but there was something... different.
Yes, that's how I've seen the world. Ever since I was little. But it got me into some pretty serious trouble, and I promised not to talk about it anymore, I promised to ignore it. But how could I ignore what was right in front of my eyes that day?

I hesitated for a moment, then decided to approach him.

# image: katsuo_closeup

"Are you lost?" I asked.

He looked up, startled by my voice. "Ah, yes." His voice was surprisingly gentle. "I'm looking for the Yokai Artifacts Museum. It's supposed to be somewhere in this area."

I smiled. The Yokai Museum was small but fascinating—one of my favorite places.

"You're not too far off. It's just a few blocks that way." I pointed down the side street.

For just a moment—so briefly I almost thought I imagined it—I saw something shimmer around his form. Like an outline of... something else.

* [Pretend not to notice] -> notice_nothing
* [Look more carefully] -> notice_something

=== notice_nothing ===
# sound: heart_beat

I blinked and kept my expression neutral. Whatever I'd seen—or thought I'd seen—was none of my business. Some people deserved their privacy, their secrets. I couldn't help it: I looked at him discreetly. I saw, I saw his tails, his pointy ears... this boy... whom everyone could see, was an image. The real boy, however, was something else, a spirit, the kind that resembles humans!
I've always been able to see these things floating everywhere. It's hard to ignore them. But how can you ignore something so magnificent?

"Sorry hmm... do you feel alright?" he asked cautiously.

"Ho! Sorry, it's nothing! " I said quickly. 'Hmm... Have I met you anywhere before?"

He relaxed. "Oh, you know... I look a bit like everyone else!"

I thought then: "Or no one else."

~ trust_level += 1

-> continue_conversation

=== notice_something ===
# sound: heart_beat

I couldn't help it: my eyes widened slightly as I looked at him more closely. Yes, I saw, I saw his tails, his pointy ears... this boy... whom everyone could see, was an image. The real boy, however, was something else, a spirit, the kind that resembles humans!
I've always been able to see these things floating everywhere. It's caused me some problems. It's hard to ignore them. But how can you ignore something so magnificent?

As I stared at his face, he tensed, his eyes narrowing in sudden suspicion.

"What are you looking at?" he asked cautiously.

"Nothing! Sorry," I said quickly. "I just thought... I recognized you from somewhere."

He relaxed. "Oh, you know... I look a bit like everyone else!"

I thought then: "Or no one else."

~ trust_level -= 1

-> continue_conversation

=== continue_conversation ===

"The Yokai Museum..." he repeated, looking at his map again. However, curious plan, very cute. "I'm afraid I'm still not familiar with this area. I'm... new in town."

* [Offer to guide him there] -> offer_guide
* [Just give directions] -> give_directions

=== offer_guide ===

I wanted to be with him a little longer, find any excuse, but I wanted it to last longer than a fleeting encounter. "I could show you the way, if you'd like," I offered. "It's one of my favorite places, actually."

He seemed surprised by my offer, but then he smiled—a warm, genuine expression that made my heart race.

"That's very kind of you. I'd appreciate it."

# image: city_streets_walking
# music: gentle_walk

As we walked together, I had to choose my next words carefully.

* [Ask about his interest in yokai] -> ask_about_yokai
* [Keep the conversation casual] -> casual_conversation

=== ask_about_yokai ===

"So, what brings you to the Yokai Museum?" I asked. "Are you interested in folklore?"

A slight tension appeared in his shoulders.

"I find the stories... relevant to my studies," he said carefully. "The way different cultures interpret the supernatural reveals much about human nature, don't you think?"

There was something evasive about his answer that only heightened my curiosity.

~ trust_level -= 1

-> arrive_at_museum

=== casual_conversation ===

"It's a really interesting little museum," I said, keeping the conversation light. "Not many people know about it, though. It's kind of a hidden gem."

He nodded, visibly relaxing as we walked.

"I appreciate places that preserve old knowledge," he said. "Things that might otherwise be forgotten."

~ trust_level += 1

-> arrive_at_museum

=== give_directions ===

"It's three blocks down this street, then turn left at the bookstore. You'll see it just past the old temple gate. You can't miss the kitsune statues outside."

He nodded gratefully. "Thank you for your help."

As he walked away, I couldn't help feeling I'd just let something important slip through my fingers.

-> arrive_at_museum_alone

=== arrive_at_museum ===

# image: museum_entrance
# sound: footsteps_stopping

We arrived at the small, traditional building that housed the Yokai Museum. Two weathered kitsune statues guarded the entrance, their stone expressions both mischievous and wise.

"Here we are," I said, stopping at the steps.

He turned to me, studying my face for a moment.

"Thank you for guiding me. May I ask your name?"

"Hikari," I said.

"Hikari," he repeated, as if testing how it felt to say it. "I'm Katsuo."

He hesitated, as if considering something, then gave a small bow.

"Perhaps we'll meet again, Hikari."

With that, he turned and entered the museum, leaving me standing there with the strange feeling that something significant had just happened.

-> summer_search

=== arrive_at_museum_alone ===

# image: museum_entrance_distant
# sound: city_ambient

From a distance, I watched as the mysterious boy found the museum and went inside. Something told me I should have accompanied him, that I'd missed an opportunity.

But why did I feel so drawn to a complete stranger?
Just because he's a yokai?
I know they're there, but seeing one like that, humanoid in form, moving in the material world, is a rather rare encounter. I was paralyzed, I didn't know what to do to get its attention on me.

I stood there for several minutes before finally turning away, unable to shake the feeling that something important had just slipped through my fingers.

-> summer_search

=== summer_search ===

# image: calendar_summer
# music: summer_progression

The encounter with Katsuo lingered in my mind for days and weeks. I couldn't forget him, his magnificent tails, his splendid natural aura, the feeling of well-being I felt by his side.

Did I really see a humanoid yokai that day? I've been waiting for this moment for so long.
I decided I needed to learn more, both about the yokai and the mysterious Katsuo. Yet I was certain of what I had seen.

+ {research_visits == 0 && museum_visits == 0 && !came_from_research && not dreams_visited} [Research kitsune folklore intensively] -> research_folklore
+ {museum_visits == 0 && research_visits > 0 && !came_from_museum && not dreams_visited} [Visit the museum regularly] -> visit_museum
+ {wait_visits < 2 && !came_from_waiting && not dreams_visited} [Wait at our meeting spot] -> wait_spot
+ {not dreams_visited} [Try to forget the encounter] -> recurring_dreams
+ {research_visits >= 1 && museum_visits >= 1 && wait_visits >= 2 && dreams_visited == false} [Continue my journey] -> summer_end
+ {dreams_visited == true} [Continue my journey] -> summer_end

=== research_folklore ===
# image: library_books
# sound: page_turning

~ knowledge_level += 1
~ research_visits += 1
~ total_choices_made += 1
~ credits_research = true
~ came_from_research = true
~ came_from_museum = false
~ came_from_waiting = false
~ credits_shown += 1

{credits_shown == 1: # credit: Director - Yumiko Hayashi}
{credits_shown == 2: # credit: Writer - Kazuto Ishiguro}
{credits_shown == 3: # credit: Character Design - Mei Zhang}
{credits_shown == 4: # credit: Music Composition - Hiroshi Takahashi}

I immersed myself in my research, spending long hours at the local library reading everything I could find about kitsune and other yokai.

The stories fascinated me: fox spirits with the power to shapeshift, create illusions, and bewitch humans. Creatures both feared and revered throughout Japanese history.

I discovered their weaknesses: it is said that running water could disrupt their magic, or that dogs could perceive their true nature. I studied accounts of kitsune-human relationships, some ending tragically, others in transcendence.

With each book, with each story, my conviction grew: Katsuo was a kitsune.
~ understanding_level += 1

I still had two more weeks of summer vacation. What should I do next?

-> summer_search

=== visit_museum ===
# image: museum_interior
# sound: museum_ambient

~ museum_visits += 1
~ total_choices_made += 1
~ credits_museum = true
~ came_from_research = false
~ came_from_museum = true
~ came_from_waiting = false
~ credits_shown += 1

{credits_shown == 1: # credit: Director - Yumiko Hayashi}
{credits_shown == 2: # credit: Writer - Kazuto Ishiguro}
{credits_shown == 3: # credit: Character Design - Mei Zhang}
{credits_shown == 4: # credit: Music Composition - Hiroshi Takahashi}

I began visiting the Yokai Museum regularly, studying the exhibits while discreetly asking questions about new employees or regular visitors.

The elderly caretaker, Mr. Tanaka, eventually noticed my repeated visits.

“You’ve developed a keen interest in yokai, young lady,” he remarked one afternoon as I examined a display of kitsune artifacts.

“I’ve always been fascinated,” I replied. “But recently, I’ve been wondering… do you believe they still exist today? Among us?”

Mr. Tanaka gave me a knowing smile. “Old stories say that yokai are masters of disguise. Who can say what—or who—they are in the modern world?”

As we talked, I felt his presence. Not that he was there, hidden, but perhaps not so far away. In any case, he was still there not long ago.

When I asked him about a boy who might have come to the museum, perhaps to give a presentation at school or something, Mr. Tanaka was simply evasive. "This museum is visited by a lot of high school students! I can't remember everyone. Try the Purikura!"

I had the distinct impression he knew more than he was letting on.

I still had time before the end of summer. What to do next?

-> summer_search

=== wait_spot ===
# image: meeting_spot_sunset
# music: waiting_theme

~ patience_level += 1
~ wait_visits += 1
~ total_choices_made += 1
~ credits_waiting = true
~ came_from_research = false
~ came_from_museum = false
~ came_from_waiting = true
~ credits_shown += 1

{!{credits_shown == 1: # credit: Director - Yumiko Hayashi}{credits_shown == 2: # credit: Writer - Kazuto Ishiguro}{credits_shown == 3: # credit: Character Design - Mei Zhang}{credits_shown == 4: # credit: Music Composition - Hiroshi Takahashi}}

I returned to the spot where we'd first met, day after day, hoping to encounter Katsuo again.

Some days I'd wait for hours, watching people pass by. Once, I even spent the entire night at the bus stop nearby, watching the intersection until dawn painted the sky pink.

"Looking for someone?" an old woman selling flowers asked me on my fifth day of waiting.

"A friend," I replied, though I wasn't sure if that was the right word for Katsuo.

"Must be someone special," she observed, noting the intensity of my vigil.

I nodded. "I think he might be."

But despite my persistence, Katsuo never appeared. It was as if he'd vanished from the city entirely—or perhaps had never truly been there at all.

~ determination_level += 1

I still had time before summer ended. What should I do next?

-> summer_search

=== recurring_dreams ===
# image: dreamscape_fox
# music: dream_sequence

~ trust_level -= 1
~ dreams_visited = true
~ total_choices_made += 1
~ credits_dreams = true
~ came_from_research = false
~ came_from_museum = false
~ came_from_waiting = false
~ credits_shown += 1

{credits_shown == 1: # credit: Director - Yumiko Hayashi}
{credits_shown == 2: # credit: Writer - Kazuto Ishiguro}
{credits_shown == 3: # credit: Character Design - Mei Zhang}
{credits_shown == 4: # credit: Music Composition - Hiroshi Takahashi}

I tried to push this strange encounter from my mind. It had been brief, perhaps meaningless. Just a lost boy looking for a museum. Perhaps, seeing invisible yokai everywhere and hoping to meet a spirit, I had undoubtedly imagined all this.

But at night, this dream betrayed my determination.

In it, Katsuo appeared with golden eyes and multiple tails swirling around him like flames. He looked at me with that impossible gaze and asked, "Do you really see me, Hikari?"

I woke up with my heart pounding, the question echoing in my mind.

Things I had always glimpsed, I had learned to ignore. But it was becoming harder and harder to deny: something had awakened inside me after my encounter with Katsuo. Something that couldn't be put back to sleep. Instead of ignoring this world that had caused me problems, I had to... on the contrary, try to communicate with them. Do it more discreetly, but stop ignoring them.

I still had time before the end of summer. What should I do next?

-> summer_search

=== summer_end ===

# image: summer_ending
# music: season_transition

As August drew to a close, I had to accept that my summer quest had yielded no concrete results. Katsuo remained elusive, a mystery I could not solve.

Yet, this experience had transformed me. I noticed these things more and more, discerning them more precisely: wisps of energy around certain people, small creatures hidden in the shadows, patterns; the whole invisible world lurking beneath the material world and reflecting it.

The world seemed bigger now, full of possibilities and secrets. Whatever Katsuo was, meeting him had awakened something in me I couldn't—and wouldn't—repress.

{trust_level > 0: My intuition told me our paths would cross again. I had respected his secrets, and perhaps that would matter when we next met.}

{knowledge_level > 0: Armed with knowledge about kitsune and other yokai, I felt better prepared for whatever might come next. If Katsuo was indeed a fox spirit, I now understood more about what that might mean.}

{understanding_level > 0: My research had given me perspective. The relationship between humans and yokai was never simple in the old stories. I would need to be careful, but also open to possibilities beyond normal human experience.}

{determination_level > 0: Though my search had been fruitless, my determination had only grown stronger. If Katsuo was still in this city, I would find him eventually. I just needed to be patient.}

{patience_level > 0: All those hours of waiting had taught me patience. If this was meant to be, it would happen in its own time. I couldn't force it.}

As I prepared for the new school year, I carried with me the memory of our brief encounter—a past love, never realized, and forever regretted. Or perhaps just delayed, waiting for the right moment to begin.

# music: fade_out
# delay: 3
# music: title_theme
# image: title_screen

# title: FOX SPIRIT ROMANCE

-> END_EPISODE_1

=== END_EPISODE_1 ===
# external_call: LOAD_NEXT_EPISODE
-> DONE
