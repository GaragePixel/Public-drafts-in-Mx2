# Japanese School Swimming Pool Classes
# iDkP from GaragePixel - 2025-04-12 - Aida v1.2

## Purpose
This document provides comprehensive technical specifications and cultural context for the Japanese school swimming pool class system, facilitating accurate representation in simulation and game development environments. The information is structured to support implementation of realistic swimming class mechanics with appropriate seasonal, evaluative, and procedural constraints.

## List of functionality
- Seasonal swimming class schedule implementation (typically June-July)
- Student evaluation rubric with four-level progression system
- Gender-segregated class structure with appropriate swimwear requirements
- Health check protocol implementation with temperature and physical condition flags
- Swimming curriculum progression from basic floating to advanced stroke techniques
- Teacher-student interaction patterns during instruction and evaluation
- Pool facility management mechanics including cleaning rotation system
- Weather-dependent class cancellation parameters

## Notes
Japanese school swimming lessons are a distinctive cultural institution with specific implementation requirements:

### Seasonal Timing
Swimming classes are predominantly conducted during the early summer term (June-July) to align with warmer weather while avoiding the intense August heat. Some schools with indoor facilities may extend the season from May to September. Implementation should include weather condition checks - classes are typically canceled during rain due to safety concerns about lightning and visibility.

### Pool Infrastructure
The typical school pool is 25m in length with 5-6 lanes, though elementary schools may utilize smaller 15m pools. Water depth ranges from 1.0m to 1.2m for elementary and 1.2m to 1.5m for secondary schools. Water temperature is maintained between 26°C and 28°C. Most pools are outdoor facilities requiring seasonal preparation and maintenance.

### Required Equipment
Students must possess:
- School-designated swimwear (navy blue for boys, navy blue or black one-piece for girls)
- Swimming cap (typically white or color-coded by class/year)
- Towel
- Waterproof bag for wet items
- Swimming goggles (optional but common)

### Class Structure
Swimming classes typically follow this pattern:
1. Pre-class health check (temperature, physical condition assessment)
2. Changing into swimwear (gender-separated changing rooms)
3. Showering requirement before entering pool
4. Warm-up exercises on pool deck
5. Skill instruction and practice (30-35 minutes)
6. Cool-down and dismissal
7. Pool cleaning duties (student rotation system)

### Evaluation System
Students are evaluated on a four-level progression system:
- Level 1: Water familiarization and basic floating
- Level 2: Basic strokes and 25m continuous swimming
- Level 3: Multiple stroke proficiency and 50m continuous swimming
- Level 4: Advanced techniques and 100m continuous swimming

Assessment includes both technical execution and distance achievement metrics. Final evaluations typically contribute to physical education grades on a 1-5 scale (5 being highest).

### Cultural Elements
Swimming education is considered a critical survival skill in Japan, an island nation. Classes emphasize both athletic development and safety consciousness. Many schools maintain a "mandatory participation" policy with only medical exemptions accepted.

## Technical Advantages
The Japanese swimming class system offers several implementation advantages for simulation environments:

### Well-Defined Structure
The highly structured nature of Japanese swimming classes provides clear state transitions and evaluation checkpoints. This facilitates clean implementation of progression mechanics without ambiguous edge cases.

### Seasonal Constraints
The limited seasonal window creates natural pacing mechanisms and concentrated narrative opportunities within the early summer period. Weather-dependent cancellation adds environmental variability to scheduling systems.

### Visual Standardization
Uniform swimwear requirements simplify asset development while allowing for character identification through swimming cap colors or minor swimwear variations within regulation parameters.

### Dual-Purpose Skill System
The swimming proficiency progression can serve both as a game mechanic (unlocking new swimming capabilities) and as a narrative device (tracking character development). The four-level system provides sufficient granularity without excessive complexity.

### Integrated Social Dynamics
The communal aspects of pool cleaning, health checks, and class structure naturally incorporate social interaction points into the mechanical implementation. These elements create opportunities for character development through routine activities.

### Safety Protocol Integration
The health check system provides a built-in mechanic for conditional participation that can be leveraged for story branching or character status effects. Temperature checks and physical condition assessments create natural decision points in the simulation flow.
