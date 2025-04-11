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
