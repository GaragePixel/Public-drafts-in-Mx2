# GLOBAL RANKING AND SOCIAL FEATURES DESIGN

### Implementation: iDkP from GaragePixel  
**Date:** 2025-04-11  
**Aida Version:** 4.2.1  

---

## Purpose

This document outlines the design and implementation of the global ranking and social features for a visual novel. These features aim to enhance player engagement, encourage organic promotion of the game, and provide insights into player progression while maintaining privacy and ethical considerations.

---

## List of Functionality

### **1. Global Ranking System**
- **Functionality**:
	1. Players can view their ranking on a global leaderboard.
	2. Rankings reflect proximity to the Perfect Ending and other metrics, such as mastery of mysteries or specific achievements.
	3. Players can compare their scores with anonymized summaries of other players' paths.
- **Requirements**:
	- Players must verify their email to access rankings.
	- Two-factor authentication (2FA) is mandatory to prevent bot abuse.

---

### **2. Discord Server Integration**
- **Functionality**:
	1. Players can opt-in to join the official Discord server via a checkbox during rank validation.
	2. Discord membership allows players to subscribe to a newsletter via their verified email.
- **Benefits**:
	- Builds community engagement and fosters discussions around the game.

---

### **3. Telemetry and Privacy**
- **Functionality**:
	1. Telemetry is linked to the ranking system and mentioned discreetly in the Terms and Conditions (CGI).
	2. A clickable "telemetry" link provides a subpage explaining anonymized data collection (e.g., game completions, progression stats).
- **Transparency**:
	- The subpage ensures players understand telemetry's purpose in improving game features without compromising individual privacy.

---

### **4. Social Profile Features**
- **Functionality**:
	1. Players can choose an avatar from a limited selection.
	2. Profiles include optional location data and a short comment field (filtered for inappropriate content).
	3. Comments can implicitly promote the game by allowing players to link Discord servers or game-related content.
- **Buzz Mechanism**:
	- Comments with game-related buzzwords trigger visual effects, such as stars, ribbons, or special marks on avatars. These are Easter eggs and not explicitly documented.

---

### **5. Profile Customization and Progression**
The global ranking and social features are designed to enhance player engagement, build a vibrant community, and support the game's growth through organic promotion. By combining innovative elements like the dream system with robust privacy protections, these features represent a thoughtful balance of creativity, functionality, and ethical considerations.

# DREAM EXPLICATION SYSTEM DESIGN

### Implementation: iDkP from GaragePixel  
**Date:** 2025-04-11  
**Aida Version:** 4.2.1  

---

## Purpose

The Dream Explication System is a unique feature designed to deepen player immersion by reflecting their in-game journey through symbolic dreams. These dreams are generated automatically based on the player's progression, decisions, and outcomes, providing a personalized, interpretive experience. They act as a "mirror" of the player's narrative path, including their emotional and psychological state.

---

## List of Functionality

### **1. Dream Generation**
- **Process**:
	1. The system selects 3-4 key images from the player's journey.
	2. Images are either juxtaposed or combined into a sequence to form a cohesive "dream" or "nightmare."
	3. The selection is based on:
		- Critical story events.
		- Paths taken, including bad endings.
		- Specific achievements or missed opportunities.
- **Interpretation**:
	- Dreams are designed to be open to interpretation, encouraging players to reflect on their journey.
	- Nightmares are generated if the player's path involves significant failures, tragedies, or fatal endings.

---

### **2. Dream Representation**
- **Visual Style**:
	1. Dreams utilize in-game assets but apply filters and overlays for a dream-like aesthetic.
	2. Colors, lighting, and effects vary based on the emotional tone of the dream.
		- Warm tones for positive dreams.
		- Cold or desaturated tones for nightmares.
- **Structure**:
	- Dreams are presented as a sequence of still images, with transitions that mimic the flow of a dream (e.g., fade-ins, blurs).

---

### **3. Symbolism and Meaning**
- **Key Elements**:
	1. **Qualia Representation**: Each dream includes visual elements tied to key narrative moments or themes.
		- Example: A shattered object might symbolize a failed relationship or missed opportunity.
	2. **Emotional Reflection**: The player's mental state is mirrored in the dream's tone and content.
		- Example: A nightmare involving pursuit might reflect the player's choices leading to fear or guilt.
	3. **Character Influence**: Characters prominently featured in the story appear in the dream, often representing unresolved conflicts or emotional connections.

---

### **4. Dream Accessibility**
- **Player Interaction**:
	1. Dreams are viewable in the player's profile under the global ranking system.
	2. Players cannot revisit past dreams in order to encourage replays.
- **Community Integration**:
	- Dreams are shared as part of the player's profile summary, offering a glimpse into their unique journey without revealing spoilers.

---

### **5. Nightmare System**
- **Trigger Conditions**:
	1. Bad endings or significant failures (e.g., a major character's death).
	2. Persistent negative affinity with key characters.
	3. Repeated pursuit of paths leading to tragic outcomes.
- **Visuals**:
	- Nightmares are darker, with distorted visuals and unsettling symbolism.
	- Example: A recurring image of falling symbolizes the player's inability to change their fate.

---

## Notes on Implementation Choices

1. **Dynamic Image Selection**:
	- Images are selected dynamically based on the player's unique path to ensure no two dreams are identical.
	- This system encourages replayability, as players explore different routes to see how their dreams change.

2. **Symbolism Over Explicitness**:
	- Dreams are designed to be interpretive, avoiding direct explanations.
	- This ambiguity deepens the player's emotional connection and encourages community discussions about possible meanings.

3. **Nightmare Design**:
	- Nightmares are deliberately unsettling but not overly graphic, maintaining the game's tone and accessibility.
	- They serve as a narrative device to emphasize the consequences of player choices.

4. **Integration with Global Ranking**:
	- Dreams are tied to the player's profile in the ranking system, adding a personalized and reflective element to community interactions.

---

## Technical Advantages

1. **Immersion and Emotional Depth**:
	- Dreams act as a narrative mirror, enhancing emotional engagement by reflecting the player's journey and choices.
	- The use of symbolic imagery taps into universal storytelling tropes, making the feature universally relatable.

2. **Replayability**:
	- The dynamic generation of dreams incentivizes players to explore alternate paths and endings to unlock new dream sequences.
	- Players are encouraged to reflect on their past decisions and strive for the Perfect Ending to see how their dreams evolve.

3. **Community Engagement**:
	- Sharing dreams in the global ranking system fosters discussions and speculation among players, creating a sense of community and shared exploration.
	- The interpretive nature of dreams invites players to share their interpretations, deepening the game's impact.

4. **Narrative Integration**:
	- Dreams seamlessly integrate with the game's themes of memory, identity, and transformation.
	- The system reinforces the idea that every choice has lasting consequences, both in the narrative and the player's reflection.

5. **Visual and Technical Appeal**:
	- The dream-like aesthetic provides a unique visual experience, setting the game apart from traditional visual novels.
	- Utilizing existing assets with overlays and filters minimizes development costs while maximizing creative output.

---

## Conclusion

The Dream Explication System is a powerful tool for enhancing player immersion and engagement. By reflecting the player's journey through symbolic and interpretive dreams, it provides a deeply personal and emotional experience. Its integration with the global ranking system adds a layer of community interaction, making it a standout feature in the visual 

# DREAM VIRTUAL MACHINE IMPLEMENTATION PROPOSAL

### Implementation: iDkP from GaragePixel  
**Date:** 2025-04-11  
**Aida Version:** 4.2.1  

---

## Purpose

This document proposes a technical implementation of the Dream Explication System using a virtual machine (VM) approach. The VM will dynamically generate dreams based on pre-compiled rules, leveraging symbolic classifications and connections derived from AI-generated interpretations. This system ensures that each player's dream is unique, immersive, and reflective of their journey.

---

## List of Functionality

### **1. Rule-Based Virtual Machine**
- **Purpose**:
	- To connect and combine visual elements dynamically based on pre-defined rules generated during pre-compilation.
- **Features**:
	1. **Symbolic Rule Generation**:
		- AI-driven training on the game's symbolic classification system.
		- Rules define how visual elements (e.g., images, transitions) are combined to create interpretable dreams.
	2. **Connection Logic**:
		- The VM uses logical rules to link narrative events and emotional tones to corresponding dream elements.
	3. **Dynamic Execution**:
		- At runtime, the VM processes the player's progression data and applies the pre-compiled rules to construct the dream sequence.

---

### **2. AI-Driven Symbolism Training**
- **Purpose**:
	- To classify and interpret in-game elements (e.g., objects, characters, scenarios) for symbolic meaning.
- **Features**:
	1. **Training Dataset**:
		- Uses a dataset of narrative elements, player decisions, and thematic contexts.
	2. **Symbolism Mapping**:
		- AI generates mappings between in-game elements and symbolic representations (e.g., a shattered mirror = failed relationships).
	3. **Rule Generation**:
		- Based on symbolic mappings, AI generates connection rules for the VM to use during dream construction.

---

### **3. Dream Construction Process**
- **Steps**:
	1. **Data Input**:
		- The VM receives player progression data, including critical story events, paths taken, and achievements.
	2. **Rule Matching**:
		- The VM matches the player's data with pre-compiled symbolic rules to select and arrange visual elements.
	3. **Sequence Assembly**:
		- The VM combines selected images into a cohesive sequence, applying transitions and overlays for a dream-like aesthetic.
	4. **Output**:
		- The generated dream is displayed in the player's profile, with corresponding emotional tone (dream or nightmare).
	5. **Sharing system**:
		- The generated dream can be shared in community website, it export the dream as image and add the player's discord or social network id if any.
  		- The dream can be adapted for the be like a postal card during exceptional events from the japanese calendar. The most important celebrations are the new year, lover day, white day etc. Some special card can be generated when the game reachs some milestones (old, number of players, number of generated dreams, new versions... etc).

---

### **4. Interpretation and Emotional Tone**
- **Dreams**:
	- Constructed with warm tones and harmonious visuals for positive outcomes.
- **Nightmares**:
	- Constructed with distorted visuals, cold tones, and unsettling transitions for negative outcomes.
- **Rules**:
	- Pre-compiled rules include conditions for tone, such as:
		- Significant failures or bad endings trigger nightmare sequences.
		- High affinity or successful achievements trigger positive dreams.

---

### **5. Integration with Global Ranking**
- **Dream Profiles**:
	- Generated dreams are tied to the player's global ranking profile.
	- Players can view their latest dream and compare it with anonymized summaries of other players' dreams.
- **Community Sharing**:
	- Dreams are shared as part of the player's profile, fostering discussions and interpretations within the community.

---

## Notes on Implementation Choices

1. **Pre-Compilation of Rules**:
	- Rules are generated pre-compilation to reduce computational overhead during runtime.
	- The symbolic classification system ensures consistency in dream generation across all players.

2. **Dynamic Execution**:
	- The VM executes rules dynamically, allowing for highly personalized dreams based on individual player paths.

3. **AI Integration**:
	- The use of AI for training and rule generation ensures that the system can adapt to complex narrative elements and produce meaningful interpretations.

4. **Scalability**:
	- The VM is designed to handle a large number of players simultaneously, ensuring smooth performance even as the player base grows.

5. **Player Privacy**:
	- All data used for dream generation is anonymized and processed locally to maintain player privacy.

---

## Technical Advantages

1. **Personalized Experience**:
	- The VM creates dreams that are uniquely tailored to each player's journey, enhancing immersion and emotional engagement.

2. **Replayability**:
	- Dynamic rule execution ensures that replaying the game leads to new dream sequences, encouraging players to explore alternate paths.

3. **Efficiency**:
	- Pre-compilation of rules minimizes runtime overhead, allowing the VM to operate efficiently even on lower-end systems.

4. **Scalability**:
	- The modular design of the VM allows for easy updates and expansion, accommodating new narrative elements or symbolic rules.

5. **Community Engagement**:
	- Sharing dreams in the global ranking system fosters community interaction and discussion, adding a social dimension to the game.

---

## Conclusion

The proposed VM implementation for the Dream Explication System leverages AI-generated rules and dynamic execution to create a personalized and immersive player experience. By combining narrative depth with technical efficiency, this system enhances both individual engagement and community interaction, making it a standout feature in the global ranking system.
