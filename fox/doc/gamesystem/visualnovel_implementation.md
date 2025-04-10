# Visual Novel Implementation in Monkey2 (Ink Format)

### Implementation: iDkP from GaragePixel  
**Date:** 2025-04-10  
**Aida Version:** 4.2.1  

---

## Purpose  
This document outlines the technical implementation of *Fox Spirit Romance* as a visual novel using the Monkey2 language and Ink scripting format. It focuses on integrating narrative mechanics, branching paths, and visual storytelling elements.  

---

## List of Functionality  

### 1. Narrative Branching System  
- **Affinity Metrics:**  
  - Track Hikari’s relationship with Katsuo and Megumi through player choices.  
  - Use metrics to determine available paths and endings.  
- **Dynamic Dialogue:**  
  - Implement conditional dialogue options based on affinity scores and prior decisions.  
- **Event Flags:**  
  - Set and check flags to trigger specific scenes or alter character behavior.  

### 2. Visual Storytelling  
- **Layered Backgrounds:**  
  - Use parallax scrolling for depth in festival and outdoor scenes.  
- **Character Sprites:**  
  - Include multiple expressions and poses for each character to reflect emotional states.  
- **Yokai Visualization:**  
  - Overlay semi-transparent yokai sprites to represent Hikari’s unique perception.  

### 3. Gameplay Mechanics  
- **Choice System:**  
  - Present players with meaningful choices that influence narrative outcomes.  
- **Investigation Mode:**  
  - Allow players to explore environments and interact with yokai for additional information.  
- **Affinity Checkpoints:**  
  - Gate certain scenes or dialogue options based on relationship thresholds.  

---

## Notes on Implementation  

1. **Ink Scripting:**  
   - Use Ink’s branching and conditional logic to manage complex dialogue trees and narrative paths.  

2. **Monkey2 Integration:**  
   - Develop custom UI elements for choice selection and affinity tracking.  
   - Optimize performance for layered visuals and animations.  

3. **Testing Framework:**  
   - Implement unit tests for key narrative sequences to ensure logical consistency and bug-free branching.  

---

## Technical Advantages  

1. **Scalability:**  
   - The modular design allows for easy expansion of narrative content and branching paths.  

2. **Player Agency:**  
   - The combination of choices and affinity metrics ensures that players feel their decisions matter.  

3. **Immersive Experience:**  
   - Advanced visual effects and yokai visualization enhance the storytelling.  

---

**Conclusion:**  
Implementing *Fox Spirit Romance* in Monkey2 with Ink scripting provides a robust framework for delivering a rich, branching narrative experience. The integration of visual and gameplay elements will create a compelling and immersive visual novel.  
