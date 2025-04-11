# RANKING & SOCIAL FEATURES FOR FOX SPIRIT ROMANCE

### Implementation: iDkP from GaragePixel  
**Date:** 2025-04-11  
**Aida Version:** 4.2.1  

---

## Purpose

This document outlines the design and implementation of the global ranking system and social features for *Fox Spirit Romance*. These features aim to enhance player engagement by introducing competitive and community-driven elements while maintaining a focus on privacy and security. 

---

## List of Functionality

### **1. Global Ranking System**
- **Player Ranking**:
	1. Players can compare their performance globally to see how close they were to achieving the Perfect Ending.
	2. The ranking system calculates a “distance score” from the Perfect Ending based on in-game decisions and progression.
	3. Players can view anonymized summaries of other players’ paths (e.g., “Discovered Mystery X”).

- **Data Insights**:
	1. Players can view aggregated stats, such as:
		- Number of Perfect Endings achieved globally.
		- Average progression scores.
	2. Rankings include non-revealing summaries of each player’s story path without spoilers.

---

### **2. Secure Access via Email Verification**
- **Email Requirement**:
	1. Players must register with a verified email address to access the ranking system.
	2. Two-Factor Authentication (2FA) is required, enhancing security and defending against bots.

- **Access Prompt**:
	1. After registration, players are prompted to enable ranking access.
	2. An optional checkbox allows players to join the official Discord server.

---

### **3. Discord Integration**
- **Server Invitation**:
	1. Players can opt to join the official Discord server when enabling ranking.
	2. The Discord server features community discussions and game updates.
	3. Players who join the Discord server can subscribe to a newsletter via their verified email.

---

### **4. Telemetry Integration**
- **Telemetry Data**:
	1. The ranking system collects anonymized telemetry data for product improvement.
		- Examples: number of Perfect Endings achieved, average progression levels.
	2. Telemetry is disclosed in the game’s Terms and Conditions (CGI).
	3. Clicking the word “telemetry” opens a subpage explaining:
		- Data is anonymized.
		- Data is used solely to improve the game experience.

---

### **5. Social Features**
- **Mini Social Network**:
	1. Players can create a profile with:
		- An avatar.
		- Location information (optional).
		- A short comment (filtered for inappropriate content).
	2. Comments appear on the global leaderboard.
		- Implicit encouragement to include Discord server links in comments, fostering organic game promotion.

- **Buzz-Driven Growth**:
	1. By allowing players to share ranked comments, the game builds community buzz.
	2. Avoids reliance on modern game distribution platforms while encouraging word-of-mouth growth.

---

## Notes on Implementation Choices

1. **Ranking Anonymity**:
	- Summaries of other players’ paths avoid spoilers, protecting narrative integrity.
	- Distance scores provide competitive motivation without revealing full endings.
  
2. **Security and Anti-Bot Measures**:
	- Email verification and 2FA ensure rankings remain human-driven.
	- Protects the ranking system from spam and fraudulent activity.

3. **Discord Integration**:
	- Provides an avenue for community interaction without mandatory participation.
	- Links the ranking system to broader community features like newsletters and discussions.

4. **Telemetry Disclosure**:
	- While telemetry data is discreetly mentioned in the Terms and Conditions, transparency is maintained via a clickable subpage.
	- Focus on anonymization reassures players about their privacy.

5. **Organic Promotion**:
	- The mini social network fosters game promotion through user-generated content, such as comments and Discord links.
	- Encourages buzz-driven growth instead of relying on external game platforms.

---

## Technical Advantages

1. **Enhanced Engagement**:
	- The ranking system adds a competitive layer to the game, encouraging replayability and deeper exploration of branching paths.

2. **Community Building**:
	- Discord integration and profile comments promote a sense of community among players.

3. **Privacy-Conscious Design**:
	- Anonymized telemetry and clear disclosures ensure players feel secure while participating in the ranking system.

4. **Sustainable Growth**:
	- Organic promotion through social features reduces dependency on traditional game distribution platforms.
	- Encourages players to share and discuss the game within their networks.

5. **Data-Driven Improvement**:
	- Telemetry data provides valuable insights into player behavior, helping developers refine the game experience.

---

## Conclusion

The global ranking system and social features for *Fox Spirit Romance* enhance player engagement by combining competitive elements, community interaction, and secure design. These features not only encourage replayability but also foster organic growth and community-driven promotion.
