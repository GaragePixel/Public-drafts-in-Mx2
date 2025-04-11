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
