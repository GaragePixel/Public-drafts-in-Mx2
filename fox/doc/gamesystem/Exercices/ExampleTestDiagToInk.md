# MCQ Generator System in Ink
**Implementation by iDkP from GaragePixel - 2025-04-27 - Aida v1.2.3**

## Purpose
This document demonstrates how the Multiple Choice Question (MCQ) Generator system can be implemented using Ink scripting language, providing a lightweight solution for dynamic question generation without requiring complex visual rendering.

## List of Functionality
* Question and Option selection based on coordinate inputs
* Comparator system for selective matching of Items
* Substitution mechanism for advanced question transformation
* Global variable management for maintaining state
* Loop guard protection against infinite processing
* Section generation with configurable parameters

## Notes on Implementation

The MCQGenerator functions as a selector system that chooses a Question and its associated Options, where the first Option is always the Answer (Key) and the others are Distractors. Unlike the diagram representation, the SectionArray is virtualized rather than being directly part of the MCQ system.

In Ink, we can implement this selection logic using variables and functions that operate on coordinates, without needing to maintain the full array structure in memory:

```ink
// Global variables for MCQ Generator
VAR questionRangeX = (0, 2)  // Min, Max
VAR questionRangeY = (0, 1)  // Min, Max
VAR optionsCount = (2, 2)    // Min, Max (always 2 options in our example)
VAR optionsRangeX = (0, 2)   // Min, Max
VAR optionsRangeY = (0, 1)   // Min, Max
VAR optionsRelativeMode = false
VAR comparator = 1          // Compare by first component
VAR substitutionMode = false
VAR substitutionRangeX = (0, 0)
VAR substitutionRangeY = (0, 1)
VAR substitutionRelativeMode = true

// Generated Section storage
VAR Section_Question = ()
VAR Section_Options = ()
VAR LoopGuard = 0

=== function InitMCQGenerator() ===
    ~ Section_Question = ()
    ~ Section_Options = ()
    ~ LoopGuard = 0
    ~ return true

=== function GetItemAtCoordinates(x, y, isQuestion) ===
    // This function would normally access the SectionArray
    // Here we're virtualizing it with a string construction
    { isQuestion:
        ~ return "S" + (y+1) + "Q" + (x+1)
    - else:
        ~ return "S" + (y+1) + "A" + (x+1)
    }

=== function GetItemText(itemCode) ===
    // Virtualized access to item text
    { itemCode:
        - "S1Q1": ~ return "Red"
        - "S1Q2": ~ return "Green"
        - "S1Q3": ~ return "Blue"
        - "S2Q1": ~ return "Cyan"
        - "S2Q2": ~ return "Magenta"
        - "S2Q3": ~ return "Yellow"
        - "S1A1": ~ return ("Primary", "Rouge")
        - "S1A2": ~ return ("Primary", "Vert")
        - "S1A3": ~ return ("Primary", "Bleu")
        - "S2A1": ~ return ("Secondary", "Cyan")
        - "S2A2": ~ return ("Secondary", "Magenta")
        - "S2A3": ~ return ("Secondary", "Jaune")
        - else: ~ return ("Unknown", "Unknown")
    }

=== function CompareItems(item1, item2) ===
    // Compare based on the comparator level
    { comparator:
        - 0: ~ return item1 == item2
        - 1: 
            // Extract and compare the S1/S2 part
            ~ temp itemPart1 = StringSlice(item1, 0, 2)
            ~ temp itemPart2 = StringSlice(item2, 0, 2)
            ~ return itemPart1 == itemPart2
        - 2:
            // Extract and compare the Q/A part
            ~ temp itemPart1 = StringSlice(item1, 2, 2)
            ~ temp itemPart2 = StringSlice(item2, 2, 2)
            ~ return itemPart1 == itemPart2
        - else: ~ return item1 == item2
    }

=== function GenerateMCQ() ===
    ~ InitMCQGenerator()
    
    // 1. Select Question
    ~ temp qx = RANDOM(questionRangeX)
    ~ temp qy = RANDOM(questionRangeY)
    ~ temp questionCode = GetItemAtCoordinates(qx, qy, true)
    ~ Section_Question = questionCode
    
    // 2. Identify Key
    ~ temp keyCode = GetItemAtCoordinates(qx, qy, false)
    
    // 3. Handle substitution if enabled
    ~ temp TempSubstitutedQuestion = ""
    { substitutionMode:
        ~ temp subX = RANDOM(substitutionRangeX)
        ~ temp subY = RANDOM(substitutionRangeY)
        
        // Apply coordinate transformation if relative mode
        { substitutionRelativeMode:
            ~ subX = subX + qx
            ~ subY = subY + qy
        }
        
        ~ TempSubstitutedQuestion = GetItemAtCoordinates(subX, subY, true)
    }
    
    // 4. Generate options
    ~ temp numOptions = RANDOM(optionsCount)
    ~ Section_Options = LIST_ADD(Section_Options, keyCode)  // Key is always the first option
    
    // 5. Generate distractors
    ~ temp distractorCount = 0
    { 
        - distractorCount < numOptions-1 && LoopGuard < 1000:
            ~ temp optX = RANDOM(optionsRangeX)
            ~ temp optY = RANDOM(optionsRangeY)
            
            // Apply coordinate transformation if relative mode
            { optionsRelativeMode:
                ~ optX = optX + qx
                ~ optY = optY + qy
            }
            
            ~ temp distractorCode = GetItemAtCoordinates(optX, optY, false)
            
            // Verify distractor is valid (not equal to key by comparator logic)
            { not CompareItems(distractorCode, keyCode) && not LIST_COUNT(LIST_INTERSECTION(Section_Options, (distractorCode))) > 0:
                // When substitution is active, also verify against temp substituted question
                { substitutionMode && TempSubstitutedQuestion != "":
                    ~ temp substitutedKeyCode = GetItemAtCoordinates(subX, subY, false)
                    { not CompareItems(distractorCode, substitutedKeyCode):
                        ~ Section_Options = LIST_ADD(Section_Options, distractorCode)
                        ~ distractorCount = distractorCount + 1
                    }
                - else:
                    ~ Section_Options = LIST_ADD(Section_Options, distractorCode)
                    ~ distractorCount = distractorCount + 1
                }
            }
            
            ~ LoopGuard = LoopGuard + 1
            -> RETRY
    }
    
    // 6. Replace question with substituted question if needed
    { substitutionMode && TempSubstitutedQuestion != "":
        ~ Section_Question = TempSubstitutedQuestion
    }
    
    ~ return true
```

The implementation above is conceptual and demonstrates how the MCQGenerator would work in Ink. The core logic remains the same as the diagram, with the main difference being that the SectionArray is virtualized through functions that construct item codes based on coordinates.

Note that at the very beginning of the `GenerateMCQ()` function, we reset the global variables `Section_Question`, `Section_Options`, and `LoopGuard` to ensure a clean state for each generation process.

## Technical Advantages

### Virtual SectionArray

The virtualization of the SectionArray in this implementation has several advantages:

1. **Memory Efficiency**: Instead of maintaining a full 2D array in memory, we construct item codes on-demand based on coordinates. This is particularly important in narrative engines like Ink where variable storage might be limited.

2. **Simplified Integration**: By abstracting the SectionArray behind functions like `GetItemAtCoordinates()` and `GetItemText()`, we allow the actual data storage to be implemented separately from the selection logic.

3. **Flexible Backend**: The actual items could be stored in various formats (JSON, XML, database) and the virtualization layer would adapt accordingly without changing the MCQGenerator logic.

### Coordinate-Based Selection

The coordinate-based selection system provides powerful capabilities:

1. **Predictable Relationships**: Items at the same coordinates in the Question and Answer spaces have an inherent relationship, making it easy to identify the Key for any Question.

2. **Range-Based Selection**: By specifying ranges for Question and Option selection, we can target specific regions of the content space without hard-coding specific items.

3. **Relative Positioning**: The optionsRelativeMode allows Options to be selected relative to the Question's position, enabling relational patterns like "adjacent items" or "items in the same row/column".

### Global State Management

Using global variables for the MCQGenerator state has both advantages and considerations:

1. **Simplified Interface**: Functions don't need to return complex data structures since the state is maintained globally.

2. **Persistence**: The generated Section remains available between narrative nodes without needing to pass it as a parameter.

3. **State Reset**: The explicit reset at the beginning of the generation process ensures previous generations don't affect new ones.

### Adaptability to Ink's Constraints

The implementation works within Ink's constraints while maintaining the core functionality:

1. **List Operations**: Leveraging Ink's list functions like `LIST_ADD` and `RANDOM` allows us to implement the selection logic without needing custom data structures.

2. **Function Reusability**: The modular design with separate functions for item access, comparison, and generation allows for reuse and maintenance.

3. **Loop Protection**: The LoopGuard mechanism prevents infinite loops during distractor selection, a critical safeguard in a narrative engine where infinite loops would freeze the game.

This implementation demonstrates that while Ink is primarily designed for narrative branching, it can be adapted for more complex systems like MCQ generation when properly structured.
