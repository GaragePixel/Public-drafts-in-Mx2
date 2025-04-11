# FOX SPIRIT ROMANCE NARRATIVE TREE DOCUMENTATION

## **Implementation Details**
- **Credit**: iDkP from GaragePixel  
- **Date**: 2025-04-11  
- **Aida Version**: 4.2.1  

---

## **Purpose**
This document provides a comprehensive breakdown of the narrative structure for *Fox Spirit Romance*. It highlights key branching paths, decision points, and how the endings tree integrates with the main storyline. This design ensures player choices are meaningful, leading to diverse outcomes and replayability.

---

## **List of Functionality**
1. **Main Narrative Tree**
   - Structured by episodic arcs
   - Includes key narrative beats, character interactions, and decision points
2. **Endings Tree**
   - Contains Perfect, Good, and Bad Endings
   - Connects to the main tree via major decision branches
3. **Affinity System**
   - Tracks player relationships with main characters
   - Influences character interactions and potential outcomes
4. **Yokai Integration**
   - Dual-world perception affecting both narrative and visuals
   - Emotional states manifest as yokai, influencing story progression
5. **Critical Failures**
   - Paths leading to Bad Endings due to poor decisions or low affinity

---

## **Notes on Implementation Choices**
### **1. Integration of Endings Tree**
All endings are designed to organically branch from the main tree. Key arcs that connect to endings include:
   - **Crisis Point: The Revelation**
   - **Transformation Journey**
   - **Akane Avoidance Period**
   - **Megumi Relationship**
   - **Stalker Arc**

### **2. Emotional Visualization Through Yokai**
   - Yokai are used to externalize character emotions, visually representing internal conflicts.
   - Example: Megumi's "black glow" yokai during her celebration of Akane's arrest highlights her inner turmoil.

### **3. Replayability**
   - Branching paths ensure no two playthroughs are identical.
   - Players are incentivized to explore different choices to unlock all endings.

---

## **Technical Advantages**
### **1. Branching Narrative**
   - The use of a modular tree structure allows for seamless integration of new branches without disrupting existing arcs.

### **2. Affinity System**
   - Tracks player choices to dynamically adjust character relationships.
   - High affinity unlocks deeper character interactions and Perfect Endings.

### **3. Dual-World Perception**
   - Combines narrative and visual storytelling by making yokai visible based on player decisions.
   - Adds depth to gameplay by connecting emotional consequences to visual feedback.

### **4. Choice-Driven Endings**
   - Every major arc has consequences that ripple through the storyline, ensuring player agency.

---

## **Diagram of Key Connections**
```
Main Narrative Tree
├── Prologue: Summer Encounter
├── School Year Begins
│   ├── Classroom Dynamics
│   ├── Stalker Arc
│   └── Revengeful Girls Introduction
├── School Festival Arc
├── Investigation & Revelation
│   ├── Akane Avoidance Period
│   ├── Stalking Evidence Path
│   └── Winter Break Encounters
├── White Day Celebrations
├── Crisis Point: The Revelation
│   ├── Fake Suicide Preparation
│   └── Rooftop Confession
├── Transformation Journey
│   ├── Hot Springs Arrival
│   └── Kodama Journey Preparation
└── Endings Tree
    ├── Perfect Endings
    ├── Good Endings
    └── Bad Endings
```
--- 

# FOX SPIRIT ROMANCE: ENDINGS TREE CONNECTIONS

## **Implementation Details**
- **Credit**: iDkP from GaragePixel  
- **Date**: 2025-04-11  
- **Aida Version**: 4.2.1  

---

## **Purpose**
This document analyzes how the **endings tree** connects to the **main narrative tree** in *Fox Spirit Romance*. The integration ensures that player choices and character affinity dynamically influence the story outcome, enhancing replayability and narrative depth.

---

## **Endings Tree Connections**
The endings are primarily connected through **major narrative branches** in the main tree. These branches influence the outcome based on cumulative choices and affinity levels. Below are the key connection points:

---

### **Key Connection Points**

#### **1. Crisis Point: The Revelation**
   - **Branches**: Fake Suicide Preparation, Night of Decision.
   - **Outcome Examples**:
     - Successfully building trust with Katsuo leads to **Perfect Endings** via the **Rooftop Confession**.
     - Failing to gain trust or revealing knowledge too soon results in **Bad Endings** like **Memory Erasure** or **Death Path**.

#### **2. Transformation Journey**
   - **Branches**: Hot Springs Arrival, Kodama Journey Preparation.
   - **Outcome Examples**:
     - **Essence Integration** during the Kodama encounter leads to **Good Endings**, such as **Identity Merging** and **Enhanced Transformation**.
     - Resistance to the sister’s essence results in a **Death Ending**.

#### **3. Akane Avoidance Period**
   - **Branches**: Choices during this arc determine Akane's role as a powerful ally or antagonist.
   - **Outcome Examples**:
     - Positive engagement with Akane leads to her redemption and cooperative endings.
     - Confrontation during the hallway scene results in **Bad Endings**, such as the **Hospital Death Ending**.

#### **4. Megumi Relationship**
   - **Branches**: Revengeful Girls Introduction, School Year Begins.
   - **Outcome Examples**:
     - High affinity during key moments (e.g., School Festival, Reflection Pool) leads to **Megumi Relationship Endings** like the **Savior Path** or **Yakuza Queen Path**.
     - Low affinity results in abandonment or darker outcomes.

#### **5. Bad Ending Branches**
   - **Specific Choices**: Certain arcs connect directly to **Bad Endings** without branching further.
   - **Outcome Examples**:
     - Stalking Katsuo during the **Investigation & Revelation** arc leads to the **Hunter Death Ending**.
     - Sexual interactions during **Locker Room Intimacy** or the **Audio-Visual Room Encounter** result in **Suicide** or **Emotional Hollowing**.

---

## **Connection Summary Table**

| **Endings Tree**            | **Connected Main Tree Branch**               | **Outcome**                              |
|------------------------------|----------------------------------------------|------------------------------------------|
| **Perfect Ending Paths**     | Rooftop Confession (Crisis Point)            | Harmony with Katsuo and yokai world      |
| **Kodama Transformation**    | Essence Integration (Transformation Journey) | Enhanced spiritual transformation        |
| **Megumi Savior Path**       | High Affinity in School Festival             | Positive Megumi character arc            |
| **Yakuza Queen Path**        | Low Affinity in School Year Begins           | Megumi becomes a criminal authority      |
| **Hospital Death Ending**    | Akane Avoidance Period (Hallway Confrontation) | Violent end caused by Akane              |
| **Hunter Death Ending**      | Stalking Evidence Path (Investigation & Revelation) | Death caused by Katsuo’s trauma          |
| **Memory Erasure/Traumatic Ends** | Audio-Visual Room Encounter (White Day)   | Emotional or physical breakdown          |

---

## **Integration Explanation**
The **endings tree** is not isolated but branches naturally from **major decision points** in the main tree. The narrative ensures that:
   - Player choices and character interactions cumulatively determine the ending path.
   - The design emphasizes replayability by making each decision significant.
   - Emotional depth is achieved by tying outcomes to affinity levels and trust-building mechanics.

Let me know if further breakdowns or diagrams are needed!

# FOX SPIRIT ROMANCE: NON-CONNECTED ENDINGS BRANCHES

## **Implementation Details**
- **Credit**: iDkP from GaragePixel  
- **Date**: 2025-04-11  
- **Aida Version**: 4.2.1  

---

## **Purpose**
This document highlights the ending branches in *Fox Spirit Romance* that are **not directly connected to the main narrative tree**. These endings are triggered via optional or isolated actions, functioning as standalone deviations from the primary storyline.  

---

## **List of Non-Connected Ending Branches**

### **1. Early Revelation Failures**
   - **Description**: Triggered when the player reveals Katsuo's true nature prematurely, before building trust or relationship levels.
   - **Triggers**:
     - Confronting Katsuo without evidence.
     - Revealing knowledge too early.
   - **Outcomes**:
     - **Memory Erasure**: Katsuo erases the protagonist's memory, leaving them disoriented.
     - **Spiritual Development End**: Katsuo abandons the protagonist, severing their connection to the yokai world.

---

### **2. Sexual Encounter Bad Endings**
   - **Description**: Triggered by optional intimate encounters leading to negative emotional or supernatural effects.
   - **Triggers**:
     - **Locker Room Intimacy**
     - **Audio-Visual Room Encounter**
   - **Outcomes**:
     - **Emotional Hollowing**: Hikari’s essence is partially consumed, leading to emotional detachment and depression.
     - **Suicide Ending**: Overwhelmed by emptiness, Hikari takes her own life.
     - **Memory Erasure Confrontation**: Katsuo manipulates Hikari’s memory, leaving her fragmented.

---

### **3. Stalking Evidence Path**
   - **Description**: Triggered by repeated stalking of Katsuo to gather evidence of his yokai nature.
   - **Triggers**:
     - Persistent spying without engaging main objectives.
   - **Outcomes**:
     - **Hunter Death Ending**: Katsuo, triggered by trauma from his mother's hunters, reacts violently, leading to Hikari's death.

---

### **4. Transformation Journey Failures**
   - **Description**: Specific failures during the Kodama spiritual journey, unrelated to prior narrative progressions.
   - **Triggers**:
     - Rejecting transformation during Kodama encounters.
     - Missing critical conditions for the spiritual journey.
   - **Outcomes**:
     - **Consciousness Dissolution**: Hikari fails to integrate with the Kodama, vanishing into the void.
     - **Death While Following**: Hikari follows an albino girl and dies in a traffic accident.

---

### **5. Megumi Relationship Bad Endings**
   - **Description**: Standalone endings based on isolated interactions with Megumi that go awry.
   - **Triggers**:
     - Specific choices during Megumi-focused scenes (e.g., School Festival or Council Room sequences).
   - **Outcomes**:
     - **Yakuza Power Figure**: Megumi becomes a criminal authority, discarding Hikari as irrelevant.
     - **Disintegration Death**: Megumi accepts a “powerful treasure” from Katsuo, which consumes her in a supernatural explosion.

---

### **6. Perfect Ending Path Failures**
   - **Description**: Failures tied to isolated actions during the Perfect Ending Path, not connected to the main storyline.
   - **Triggers**:
     - Specific choices during the spiritual journey or tengu confrontation.
   - **Outcomes**:
     - **Tengu Devours Hikari**: Katsuo fails to save Hikari during a tengu battle, leading to her death.
     - **Unborn Sister’s Revelation Failure**: Hikari fails to integrate with her unborn sister’s essence due to missing critical items (e.g., Katsuo’s fur scarf).

---

## **Summary**
The above ending branches are disconnected from the main narrative tree and are triggered by isolated actions or optional paths. While they enrich the narrative with additional outcomes, they do not influence the primary storyline progression. These branches enhance replayability by rewarding players who explore alternate decisions and interactions.

# FOX SPIRIT ROMANCE: COMPLETE ENDINGS PATHS

## **Implementation Details**
- **Credit**: iDkP from GaragePixel  
- **Date**: 2025-04-11  
- **Aida Version**: 4.2.1  

---

## **Purpose**
This document provides a comprehensive list of all endings paths in *Fox Spirit Romance*. It includes **Perfect Endings**, **Good Endings**, and **Bad Endings**, detailing the conditions and triggers for each. These paths ensure player choices feel significant, offering diverse outcomes and encouraging replayability.

---

## **List of Endings Paths**

### **1. Perfect Endings**
   - **Description**: Achieved through optimal choices, high affinity levels, and successful navigation of key moments.
   - **Paths**:
     1. **Partnership Path**:
        - Hikari and Katsuo achieve harmony as a human-yokai bridge.
        - Requires maximum trust and affection scores.
     2. **Support Path**:
        - Hikari and Katsuo maintain a near-perfect relationship, balancing human and yokai worlds.
        - Requires moderate trust and affection scores.
     3. **Caution Path**:
        - Hikari and Katsuo form a stable foundation with minimal integration.
        - Requires minimum acceptable trust and affection scores.

---

### **2. Good Endings**
   - **Description**: Achieved through balanced decisions and partial success in key moments.
   - **Paths**:
     1. **Megumi Savior Path**:
        - Positive engagement with Megumi leads to her redemption and positive social influence.
     2. **Identity Merging (Kodama Transformation)**:
        - Hikari integrates with her sister’s essence during the Kodama encounter, achieving enhanced transformation.
     3. **Enhanced Transformation**:
        - Achieved by successfully navigating the Kodama spiritual journey.

---

### **3. Bad Endings**
   - **Description**: Triggered by poor decisions, low affinity, or specific failures in key moments.
   - **Paths**:
     1. **Early Revelation Failures**:
        - Memory Erasure: Katsuo erases Hikari’s memory after premature knowledge revelation.
        - Spiritual Development End: Katsuo abandons Hikari, severing her connection to the yokai world.
     2. **Sexual Encounter Failures**:
        - Emotional Hollowing: Hikari’s essence is consumed, leading to depression and isolation.
        - Suicide Ending: Overwhelmed by emptiness, Hikari takes her own life.
        - Memory Erasure Confrontation: Katsuo manipulates Hikari’s memory, leaving her fragmented.
     3. **Stalking Evidence Failures**:
        - Hunter Death Ending: Katsuo reacts violently due to trauma, causing Hikari’s death.
     4. **Transformation Journey Failures**:
        - Consciousness Dissolution: Hikari fails to integrate with the Kodama, vanishing into the void.
        - Death While Following: Hikari follows an albino girl and dies in a traffic accident.
     5. **Megumi Relationship Failures**:
        - Yakuza Power Figure: Megumi becomes a criminal authority, discarding Hikari as irrelevant.
        - Disintegration Death: Megumi activates a supernatural artifact, leading to her destruction.
     6. **Perfect Ending Path Failures**:
        - Tengu Devours Hikari: Katsuo fails to save Hikari during a tengu confrontation.
        - Unborn Sister’s Revelation Failure: Hikari fails to integrate with her sister’s essence due to missing critical items (e.g., Katsuo’s fur scarf).
     7. **Akane Avoidance Period Failures**:
        - Hospital Death Ending: Confrontation during the hallway scene leads to Akane attacking Hikari fatally.

---

## **Notes**
- All endings are tied to the **affinity system**, which tracks the player’s relationship with key characters, influencing outcomes.
- Certain endings are isolated, triggered by optional actions or specific failures rather than cumulative choices.

---

## **Conclusion**
The diverse endings paths in *Fox Spirit Romance* encourage experimentation and replayability. Each decision impacts the story, ensuring players feel invested in shaping their unique narrative journey.
