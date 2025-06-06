# Ink Scripting Language Implementation Guide

*Documentation by iDkP from GaragePixel • 2025-04-18 • Aida v4*

## Purpose

This document provides comprehensive implementation guidelines for the Ink narrative scripting language, enabling effective utilization of its full capabilities for interactive storytelling. It extracts and systematizes core syntactical rules, structural patterns, and advanced functionality from exemplary implementations to establish a consistent development framework. This framework enables creation of sophisticated branching narratives with state tracking, conditional logic, and variable manipulation while maintaining narrative coherence and player agency throughout complex story structures.

## Functionality List

1. **Narrative Structure Implementation**
   - Knot and stitch organization framework
   - Branching choice architecture
   - Fallthrough and divert mechanics
   - Narrative flow control methodologies
   - Tunneling implementation for temporary diversions

2. **Variable System Architecture**
   - Global and temporary variable implementation
   - Logic-controlled narrative adaptation
   - Numerical operation integration
   - String manipulation framework
   - List variable functionality

3. **Conditional Logic Framework**
   - Branching condition implementation
   - Content variation based on state
   - Logic-driven narrative progression
   - Multi-condition evaluation methodology
   - Alternative content selection systems

4. **Advanced Functionality Implementation**
   - Threading for parallel narrative tracks
   - Knowledge state tracking mechanisms
   - Random content selection protocols
   - Function implementation for reusable logic
   - Tag system for external engine communication

## Core Syntax Implementation

### Narrative Structure Framework

Ink organizes content through hierarchical containers providing both organizational and functional benefits:

```ink
=== knot_name ===
Main content goes here.
-> next_knot

= stitch_name
Subdivision content.
-> END
```

**Implementation Rules:**
1. Knots (major sections) defined with `=== knot_name ===` triple equals syntax
2. Stitches (subsections) defined with `= stitch_name` single equals syntax
3. Diverts using arrow syntax: `-> destination`
4. Terminal points use `-> END` to conclude flow
5. Knot/stitch names must use lowercase with underscores (no spaces or special characters)
6. Content automatically flows from one line to the next without additional syntax
7. Empty lines ignored in output but enhance readability

### Choice Structure Implementation

Choices provide the primary interactive mechanism, creating branching narrative paths:

```ink
* [Choice text shown to player] Text after selection.
* Choice without brackets is both shown and included in output.
+ Sticky choice remains available after selection.
* -> knot_name
```

**Implementation Rules:**
1. Asterisk (*) defines standard choices that appear once
2. Plus sign (+) creates sticky choices that remain available
3. Text in square brackets [shown only in choice menu]
4. Text outside brackets displayed after selection
5. No brackets means text appears in both choice and result
6. Indentation after choice creates content specific to that choice
7. Content at same level as choice displays for all branches after respective choice content
8. Choice can contain direct divert using `* -> destination`

### Variable Implementation

Ink supports variable-driven narrative adaptation through state tracking:

```ink
VAR health = 100
VAR player_name = "Traveler"
VAR has_weapon = false
~ temp local_var = 5

{health <= 0: You have perished.}
My name is {player_name}.
{has_weapon: You grip your weapon tightly.}

~ health = health - 20
```

**Implementation Rules:**
1. Global variables declared with `VAR name = value` syntax
2. Temporary variables declared with `~ temp name = value` 
3. Variable modification through tilde: `~ variable = new_value`
4. Mathematical operations: `~ health = health - damage`
5. String variables require quotes: `VAR name = "value"`
6. Boolean variables use true/false: `VAR flag = true`
7. Variables accessed directly by name in text or conditions
8. Temporary variables exist only within current knot scope

### Conditional Logic Framework

Conditional logic enables dynamic content adaptation:

```ink
{condition: content if true}
{condition: content if true|content if false}
{
    - condition_1: content if condition_1 true
    - condition_2: content if condition_2 true
    - else: default content
}
```

**Implementation Rules:**
1. Basic condition: `{condition: content}`
2. Alternative syntax: `{condition: true content|false content}`
3. Multi-condition using dash syntax within braces
4. Conditions evaluate variables, comparisons, or functions
5. Logical operators: `and`, `or`, `not`
6. Comparison operators: `==`, `!=`, `>`, `<`, `>=`, `<=`
7. Conditions can check variable existence with just variable name
8. Complex conditions should use parentheses for clarity

## Advanced Functionality Implementation

### List Variable Framework

Lists provide enumeration functionality with manipulation capabilities:

```ink
LIST emotions = happy, sad, angry, confused
VAR current_mood = happy

~ current_mood = sad
{current_mood == sad: You feel melancholy.}

LIST inventory = (sword), shield, potion, map
~ inventory += potion
{inventory ? potion: You have a potion.}
```

**Implementation Rules:**
1. Defined with `LIST name = item1, item2, item3` syntax
2. Default value indicated with parentheses: `(item1)`
3. List variables can be assigned single values: `~ var = item`
4. Add item with: `~ list += item`
5. Remove item with: `~ list -= item`
6. Check containment with: `{list ? item: text}`
7. List comparison works with standard operators
8. Lists can be subset of other lists using full list specification

### Threading Implementation

Threading enables parallel narrative tracks:

```ink
<- thread_1(parameter)
<- thread_2

=== thread_1(param) ===
Thread content with {param}.
->->

=== thread_2 ===
Second thread content.
->->
```

**Implementation Rules:**
1. Thread diverts use left arrow: `<- thread_name`
2. Threads can accept parameters: `<- thread(parameter)`
3. Thread definitions match standard knot syntax
4. Threads must end with `->->` to return to calling point
5. Threads maintain separation from main story flow
6. Multiple threads can be called sequentially
7. Thread return points preserve narrative flow
8. Threads can modify global but not temp variables across boundaries

### Tunneling Framework

Tunneling allows temporary narrative diversions:

```ink
-> tunnel_sequence ->
Continues here after tunnel.

=== tunnel_sequence ===
Tunnel content here.
->->
```

**Implementation Rules:**
1. Tunnel call uses bidirectional arrows: `-> tunnel ->`
2. Tunnel definition matches standard knot syntax
3. Tunnels must end with `->->` to return to calling point
4. Tunnels can be nested through multiple levels
5. Content after tunnel call executes after tunnel returns
6. Tunnels can contain choices affecting story state
7. Tunnels can receive parameters: `-> tunnel(param) ->`
8. Tunnels preserve temp variable scope within their execution

### Function Implementation

Functions provide reusable logic operations:

```ink
=== function add_health(amount) ===
~ temp new_health = health + amount
~ health = new_health
~ return health

Your health increased to {add_health(10)}.
```

**Implementation Rules:**
1. Functions defined using `=== function name(parameters) ===`
2. Parameters are optional and comma-separated
3. Functions must explicitly return using `~ return value`
4. Functions called by name: `function_name(parameters)`
5. Can be used directly in text: `{function_name()}`
6. Return values can be assigned: `~ var = function_name()`
7. Functions should not generate narrative output
8. Functions can modify global state, including variables

### Dynamic Content Selection

Ink provides mechanisms for random or sequential content:

```ink
{shuffle:
    - First random option.
    - Second random option.
    - Third random option.
}

{cycle:
    - First time text.
    - Second time text.
    - Subsequent visits.
}
```

**Implementation Rules:**
1. Shuffle selects random item with `{shuffle: - option1 - option2}`
2. Cycle proceeds sequentially with `{cycle: - option1 - option2}`
3. Once chosen cycle persists with `{cycle once: - option1 - option2}`
4. Items must be preceded by dash marker
5. Each item must be on separate line
6. Sequence must be enclosed in braces
7. Options can contain variables and conditionals
8. Nested shuffles and cycles are supported

### Tag System Implementation

Tags provide metadata or instructions to external systems:

```ink
# character: protagonist
# emotion: happy
# music: battle_theme

Dialog line with associated metadata.
```

**Implementation Rules:**
1. Tags defined with hash symbol: `# tag: value`
2. Multiple tags can be applied to same content
3. Tags don't appear in narrative output
4. Tags can be placed on separate lines or after content
5. Tag format should match external system expectations
6. Tags without values supported: `# tag`
7. Tags commonly used for integration with game engines
8. Standard usage includes scene, character, emotion, and audio cues

## Variable Tracking Implementation

### Numerical Operation Framework

Ink supports comprehensive mathematical operations:

```ink
VAR damage = 15
VAR defense = 5
VAR health = 100

~ temp actual_damage = damage - defense
~ health = health - actual_damage

Damage taken: {actual_damage}. Remaining health: {health}.
```

**Implementation Rules:**
1. Standard operators: `+`, `-`, `*`, `/`, `%` (modulo)
2. Operations can be chained: `~ var = (a + b) * c`
3. Parentheses control operation precedence
4. Results can be stored or used directly
5. Integer and floating point values supported
6. Division produces floating point results
7. Increment shorthand: `~ var++` or `~ var--`
8. Assignment operators: `+=`, `-=`, `*=`, `/=`

### Knowledge State Implementation

Tracking narrative knowledge enables adaptive storytelling:

```ink
VAR knows_secret = false
VAR betrayed_ally = false

* [Ask about the ancient artifact]
    ~ knows_secret = true
    The artifact holds immense power.
* [Blame your ally]
    ~ betrayed_ally = true
    Your ally looks hurt by your accusation.

{knows_secret and betrayed_ally: 
    The full truth becomes clear - your ally was protecting you.
}
```

**Implementation Rules:**
1. Boolean variables track binary knowledge states
2. Variables set through choice consequences: `~ var = true`
3. Complex states combine multiple variables
4. Narrative adapts through conditional checks
5. Knowledge accumulation creates emergent storylines
6. Previous choices influence available options
7. Track character relationships with dedicated variables
8. Reset knowledge for specific narrative branches if needed

### String Manipulation Framework

String handling enables dynamic text adaptation:

```ink
VAR player_name = ""
VAR title = "novice"

* [Enter your name]
    ~ temp input = "Traveler"
    ~ player_name = input
    Name recorded.

Greetings, {player_name} the {title}.
{player_name == "": You remain anonymous.}
```

**Implementation Rules:**
1. Strings defined with quotes: `VAR name = "value"`
2. Empty strings allowed: `VAR name = ""`
3. String concatenation with plus: `~ str = str1 + str2`
4. String comparison uses standard operators
5. String interpolation with braces: `{variable}`
6. Empty string evaluates as false in conditions
7. String variables can be modified during runtime
8. Integration with external string input requires engine support

## Notes

The comprehensive analysis of Ink's implementation across multiple examples reveals several critical design patterns and best practices:

1. **Hierarchical Organization Priority**
   - Effective Ink stories establish clear knot/stitch hierarchy for both organization and function
   - Major story branches should be separate knots while variations remain stitches
   - Overuse of deeply nested choices creates maintenance challenges
   - Tunnel implementation provides superior alternative to excessive nesting

2. **State Management Centralization**
   - Global variables should be declared at document beginning with clear naming conventions
   - Knowledge state variables follow boolean naming pattern (has_X, knows_Y)
   - Numerical variables should include units where applicable (damage_points)
   - State should be modified in isolated, clearly marked sections when possible

3. **Choice Design Philosophy**
   - Choices should provide meaningful agency with distinct consequences
   - Purely cosmetic choices can use gathers to maintain narrative coherence
   - Choice text should suggest consequences without explicitly stating them
   - Sticky choices should be reserved for recurring options that remain logical

4. **Thread Implementation Strategy**
   - Threads excel for parallel processes that don't require immediate player interaction
   - Environmental descriptions, internal thoughts, or background events
   - Thread naming should indicate purpose (describe_room, character_thoughts)
   - Excessive threading creates tracking complexity and should be used judiciously

The most significant implementation discovery involves the interplay between variable state tracking and conditional narrative branching. Sophisticated Ink implementations rarely rely on explicit branching alone, instead leveraging accumulated state variables to create emergent narrative experiences where previous choices subtly influence options and outcomes throughout the story.

## Technical Advantages

### Narrative Coherence Architecture

The Ink implementation framework provides significant technical advantages:

1. **Structural Integrity Maintenance**
   - Hierarchical organization prevents narrative dead-ends
   - Tunneling enables contextual exploration without flow disruption
   - Gathers consolidate branching paths maintaining narrative momentum
   - State tracking creates consistent character and world behavior

2. **Readability Enhancement**
   - Clear syntactical separation between structure and content
   - Hierarchical organization mirrors natural story structure
   - Explicit divert markers indicate narrative flow
   - Consistent indentation reinforces choice consequence relationships

3. **Maintainability Optimization**
   - Isolated narrative components enable targeted revision
   - Tunnels and functions promote content reusability
   - Variable state tracking centralizes conditional logic
   - Knot/stitch naming conventions create intuitive navigation

4. **Runtime Performance Efficiency**
   - Direct divert implementation minimizes parsing overhead
   - Condition evaluation architecture optimizes branching decisions
   - Variable state modifications consolidated in discrete operations
   - Function implementation reduces duplicate logic execution

### Narrative Flexibility Implementation

The framework enables sophisticated storytelling capabilities:

1. **Adaptive Narrative Architecture**
   - Condition-based content variation creates personalized experiences
   - Knowledge state tracking enables persistent consequence frameworks
   - Variable-driven character relationships evolve naturally
   - Shuffled content provides replay value without structure duplication

2. **Player Agency Enhancement**
   - Choice design methodology focuses on meaningful decisions
   - Consequence accumulation creates emergent storylines
   - State tracking enables subtle influence over extended narrative
   - Conditional choice availability responds to player history

3. **Content Management Optimization**
   - Tunnel implementation reduces content duplication
   - Function framework centralizes repeated logic
   - Thread architecture enables parallel narrative expansion
   - Tag system facilitates external system integration

4. **Narrative Testing Enhancement**
   - Clear structure visualization simplifies flow validation
   - Variable tracking enables state verification
   - Function isolation facilitates unit testing
   - Conditional path testing through variable manipulation

The Ink implementation framework establishes a comprehensive ecosystem for interactive narrative development, balancing technical capability with authoring accessibility. The most significant advantage derives from the variable state tracking architecture, which enables complex, responsive narratives without requiring exponential content creation for each possible path, creating sophisticated player experiences through emergence rather than explicit branch multiplication.

# Ink Lists Manipulation Guide
**Implementation by iDkP from GaragePixel - 2025-04-27 - Aida v1.2.3**

## Purpose
This document explains how to perform common list operations in Ink scripting language, focusing on retrieving list length and inserting items at specific positions within lists.

## List of Functionality
* Getting the number of items in a list (List.Length)
* Inserting an item at the beginning of a list
* List manipulation best practices
* Performance considerations

## Notes on Implementation

### Getting List Length

In Ink, to get the number of elements in a list, you use the `LIST_COUNT()` function:

```
LIST fruits = apple, banana, orange, pear
VAR fruitCount = LIST_COUNT(fruits)
// fruitCount will equal 4
```

This is equivalent to the `List.Length` property in other languages. The `LIST_COUNT()` function works with both named lists and temporary list variables.

### Inserting Items at the Beginning of a List

Ink doesn't provide a direct `Insert()` method like some other languages. To insert an item at the beginning of a list, you need to use list addition with the item you want to insert:

```
LIST myList = Item1, Item2, Item3, Item4
VAR newList = (Item5, ()) + myList
// newList now contains: Item5, Item1, Item2, Item3, Item4
```

The syntax `(Item5, ())` creates a single-element list containing `Item5`. The empty parentheses are necessary because Ink requires list literals to be wrapped in parentheses.

For dynamic insertion using a variable:

```
LIST myList = Item1, Item2, Item3, Item4
VAR itemToInsert = Item5
VAR newList = (itemToInsert, ()) + myList
```

### Alternative Approach Using List Operations

If you're working with more complex list manipulations, you can use a combination of list operations:

```
LIST myList = Item1, Item2, Item3, Item4
VAR itemToInsert = Item5

// Create an empty list
VAR newList = ()  

// Add the new item first
newList = LIST_ADD(newList, itemToInsert)

// Then add all items from the original list
VAR i = 0
~ temp originalCount = LIST_COUNT(myList)
{ loop:
    ~ newList = LIST_ADD(newList, LIST_VALUE(myList, i))
    ~ i = i + 1
    { i < originalCount:
        -> loop
    }
}
```

## Technical Advantages

### Performance Considerations

When working with lists in Ink, it's important to understand the performance implications:

1. **List Addition vs. Individual Operations**: Using the list addition operator (+) is generally more efficient than adding individual items in a loop, especially for small to medium-sized lists. The runtime performance is optimized for these operations.

2. **Immutable Lists**: Ink lists are immutable, meaning that operations like adding items create new lists rather than modifying existing ones. This has memory implications when performing many list operations in sequence.

3. **List Size Limitations**: While there's no hard-coded limit to list sizes in Ink, performance can degrade with very large lists. For most narrative applications, this is rarely an issue, but it's something to be aware of when designing systems that might grow to contain hundreds of items.

### Integration with State Tracking

One of the key advantages of Ink's list implementation is its seamless integration with the state tracking system:

```
LIST inventory = ()
VAR maxItems = 10

=== add_item(itemToAdd) ===
{ LIST_COUNT(inventory) >= maxItems:
    Too many items in inventory!
    -> done
}

~ inventory = LIST_ADD(inventory, itemToAdd)
Added {itemToAdd} to inventory.

-> done
```

This approach allows you to maintain inventory systems, quest logs, or other state-tracking mechanisms within your narrative flow while leveraging Ink's built-in state persistence.

### Practical Applications

In a game context, list manipulation can be used for various systems:

1. **Inventory Management**: Adding and removing items from the player's possession
2. **Dialog Systems**: Tracking conversation topics that have been discussed
3. **Quest Progress**: Maintaining collections of completed objectives
4. **Character Relationships**: Storing lists of character traits or relationship states

Using the insertion technique described above, you could implement a priority queue where new urgent items are always pushed to the front of a list, ensuring they're processed first in your game logic.

# Ink List Reassignment Clarification
**Implementation by iDkP from GaragePixel - 2025-04-27 - Aida v1.2.3**

## Purpose
This document explains the limitations of Ink list reassignment and provides proper techniques for modifying list content while maintaining reference integrity.

## List of Functionality
* Clarification of LIST vs VAR declarations in Ink
* Correct patterns for list modification
* Alternative approaches for list manipulation
* Memory and performance considerations

## Notes on Implementation

In Ink, the LIST keyword defines a named collection of constants rather than a variable container. This is why the following syntax does not work:

```
LIST myList = Item1, Item2, Item3, Item4
VAR newList = (Item5, ()) + myList
LIST myList = newList  // ERROR: Cannot reassign a LIST declaration
```

The correct approach is to use the VAR keyword for any list that needs to be modified:

```
LIST Items = Item1, Item2, Item3, Item4, Item5  // Define all possible items
VAR myList = (Item1, Item2, Item3, Item4)       // Create a variable containing items
~ myList = (Item5, ()) + myList                 // Modify the variable directly
// myList now contains: Item5, Item1, Item2, Item3, Item4
```

Notice the tilde (~) before the assignment, which is required for variable modification statements in Ink.

Alternatively, if you need to preserve the original list:

```
LIST Items = Item1, Item2, Item3, Item4, Item5
VAR originalList = (Item1, Item2, Item3, Item4)
VAR modifiedList = (Item5, ()) + originalList
// originalList remains unchanged
// modifiedList contains: Item5, Item1, Item2, Item3, Item4
```

## Technical Advantages

### LIST vs VAR Separation

Ink's separation of LIST declarations (as constants) from VAR assignments (as changeable values) provides several key benefits:

1. **Memory Efficiency**: The LIST declaration defines the universe of possible values only once, reducing redundant storage.

2. **Type Safety**: By pre-defining all valid list items, Ink can prevent accidental assignment of invalid values.

3. **Serialization Optimization**: When saving game state, Ink only needs to store which items from the predefined universe are present in each list variable, not the full item definitions.

This design reflects Ink's origins as a narrative scripting language where a finite set of story elements (characters, locations, items) might appear in various combinations throughout the story.

### List Operation Performance

While working with lists in Ink, keep these performance considerations in mind:

1. **Addition vs Replacement**: Adding to a list (using +) creates an entirely new list in memory. For large lists with frequent modifications, consider your memory usage patterns.

2. **Full List Operations**: Operations like LIST_ALL() create complete lists, which can be expensive for large universes of items.

3. **List Comparisons**: When comparing lists (using ==, >, <, etc.), Ink compares the entire contents of both lists, which can become expensive for large collections.

For most narrative games, these performance considerations rarely become bottlenecks, but they're important to understand when designing complex systems like inventory management or quest tracking.

### Alternative Approaches for Complex List Manipulation

If your game requires extensive list manipulation, consider these alternative patterns:

```ink
LIST Items = Item1, Item2, Item3, Item4, Item5
VAR inventory = ()

=== function add_to_front(ref _list, _item) ===
    ~ return (_item, ()) + _list

=== function insert_at(ref _list, _item, _position) ===
    // Create temporary lists for before and after the insertion point
    ~ temp before = ()
    ~ temp after = ()
    ~ temp i = 0
    ~ temp listCount = LIST_COUNT(_list)
    
    // Split the list at the insertion point
    { loop:
        { i < _position:
            ~ before = LIST_ADD(before, LIST_VALUE(_list, i))
        - else:
            ~ after = LIST_ADD(after, LIST_VALUE(_list, i))
        }
        ~ i = i + 1
        { i < listCount:
            -> loop
        }
    }
    
    // Combine the parts with the new item
    ~ return before + (_item, ()) + after
```

These reusable functions can be called from anywhere in your Ink script to provide more advanced list manipulation capabilities without sacrificing the benefits of Ink's list system.
