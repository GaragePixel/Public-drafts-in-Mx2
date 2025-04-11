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

Endings Tree Connections

The endings are primarily connected through major narrative branches in the main tree, which influence the outcome based on cumulative choices and affinity levels. Here's how the connections work:
Key Connection Points
1. Crisis Point: The Revelation

    The Fake Suicide Preparation and Night of Decision branches in the main tree directly lead to endings.
    Examples:
        If the player successfully builds trust with Katsuo, the Rooftop Confession leads to Perfect Ending paths.
        Failing to gain Katsuo's trust or revealing knowledge too soon can lead to Bad Endings, such as Memory Erasure or Death Path.

2. Transformation Journey

    Decisions during the Hot Springs Arrival and Kodama Journey Preparation influence the outcome.
    Examples:
        Essence Integration during the Kodama encounter leads to Good Endings, such as Identity Merging and Enhanced Transformation.
        Resistance to the sister's essence during the Kodama transformation results in a Death Ending.

3. Akane Avoidance Period

    The choices during this arc determine whether Akane becomes a powerful ally or leads to violent confrontation paths.
    Examples:
        Positive engagement with Akane leads to her redemption and more cooperative endings.
        Confrontation during the hallway scene results in Bad Endings, such as the Hospital Death Ending.

4. Megumi Relationship

    The Revengeful Girls Introduction and subsequent branches in the School Year Begins arc determine Megumi's influence on the story.
    Examples:
        High affinity with Megumi during key moments (e.g., School Festival, Reflection Pool) leads to Megumi Relationship Endings (e.g., Savior Path or Yakuza Queen Path).
        Low affinity results in abandonment or darker outcomes.

5. Bad Ending Branches

    Specific choices during key arcs connect directly to Bad Endings without further branching.
    Examples:
        Stalking Katsuo during the Investigation & Revelation arc can lead to the Hunter Death Ending.
        Sexual interactions during Locker Room Intimacy or the Audio-Visual Room Encounter can result in Suicide or Emotional Hollowing Endings.

Connection Summary Table
Endings Tree	Connected Main Tree Branch	Outcome
Perfect Ending Paths	Rooftop Confession (Crisis Point)	Harmony with Katsuo and yokai world
Kodama Transformation	Essence Integration (Transformation Journey)	Enhanced spiritual transformation
Megumi Savior Path	High Affinity in School Festival	Positive Megumi character arc
Yakuza Queen Path	Low Affinity in School Year Begins	Megumi becomes a criminal authority
Hospital Death Ending	Akane Avoidance Period (Hallway Confrontation)	Violent end caused by Akane
Hunter Death Ending	Stalking Evidence Path (Investigation & Revelation)	Death caused by Katsuo’s trauma
Memory Erasure/Traumatic Ends	Audio-Visual Room Encounter (White Day)	Emotional or physical breakdown
