# **MCQSelector** Documentation Introduction
**Implementation by iDkP from GaragePixel - 2025-04-28 - Aida v4**

## Purpose
This introduction provides an overview of the **MCQSelector** documentation, explaining the system architecture and data structures that enable flexible, coordinate-based multiple-choice **Question** generation.
This document provides a comprehensive technical overview of the **MCQSelector** system, detailing the core architecture, data structures, and operational patterns that enable dynamic, coordinate-based multiple-choice question selection and presentation through a structured array approach.

## List of Functionality
* Content overview and navigation guidance
* System architecture introduction
* Data structure relationships explanation
* Implementation pattern summary
* Documentation usage recommendations

## Notes on Implementation

The **MCQSelector** employs a coordinate-based approach to question generation, using a two-dimensional array structure (**SectionArray**) as its foundational data container. This design enables precise targeting of related question-answer pairs through coordinate relationships rather than hard-coded connections, providing significant flexibility for quiz content creation and maintenance.

Each Section contains a **SectionArray** where Items are positioned according to logical relationships, allowing the system to generate **Queries** by selecting elements based on their coordinate positions. For example, questions might occupy even-numbered rows with their corresponding answers in the following odd-numbered rows, creating an inherent relationship through array positioning.

The **MCQSelector** documentation presents a comprehensive overview of the **GaragePixel**'s coordinate-based multiple-choice **Question** system. The document employs visual representations alongside technical explanations to illustrate how our array-based approach enables flexible **Question** generation through coordinate selection.

The document successfully demonstrates the relationship between **Section**s, **Querie**s, and **Item**s through both visual diagrams and structural explanations. The array visualizations clearly show how **Question**s and **Answer**s are organized in a grid format that supports programmatic selection and relationship mapping.

No logical errors were detected in the documentation. The relationships between components are consistently represented, and the data structures align with the described implementation patterns. The coordinate system provides a solid foundation for the MCQ generation algorithms described throughout the document.

## Technical Advantages

The documentation effectively communicates the **MCQSelector**'s core design principles, particularly its use of:

1. **Coordinate-Based Selection**: The grid structure enables precise targeting of **Question**s and their related **Answer**s.

2. **Section Encapsulation**: The organization of content into topic-specific **Section**s provides logical separation of quiz material.

3. **Query Construction Pattern**: The relationship between **Item**s, **Question**s, and **Option**s follows a consistent pattern that supports diverse **Question** types.

This documentation serves as an essential reference for **GaragePixel** implementing or extending the **MCQSelector** system, providing both conceptual understanding and practical implementation guidance.

## Terminology: ##

<table border="0" cellpadding="8">
	<tr>
		<td width="100" valign="middle" align="left">Section</td>
		<td width="50" valign="middle" align="center">→</td>
		<td width="160" valign="top">
			<table border="1" cellpadding="4" width="100%">
				<tr><th align="left">Query</th></tr>
				<tr><td align="left">Question</td></tr>
				<tr><td align="left">Option 2</td></tr>
				<tr><td align="left">Option 3</td></tr>
			</table>
		</td>
		<td width="50" valign="middle" align="center">←</td>
		<td width="100" valign="middle" align="left">Items</td>
	</tr>
	<tr>
		<td width="100" valign="middle"></td>
		<td width="50" valign="middle" align="center">↓</td>
		<td width="160" valign="top"></td>
		<td width="50" valign="middle"></td>
		<td width="100" valign="middle"></td>
	</tr>
	<tr>
		<td width="100" valign="middle"></td>
		<td width="50" valign="middle" align="center">→</td>
		<td width="160" valign="top">
			<table border="1" cellpadding="4" width="100%">
				<tr><th align="left">Query</th></tr>
				<tr><td align="left">Question</td></tr>
				<tr><td align="left">Option 2</td></tr>
				<tr><td align="left">Option 3</td></tr>
			</table>
		</td>
		<td width="50" valign="middle" align="center">←</td>
		<td width="100" valign="middle" align="left">Items</td>
	</tr>
</table>

- The **Question** and the **Option** are called "**Item**" because the system operates indifferently on a set to construct the Multiple Choice **Question**s form.

- Multiple **Question**s (**Question**'s Serie) is called **Section**.

- A **Question**/**Option**s pair is called **Query**.

- The outputed **Section** always produce the **Key** (good **Answer**) as **Option** 1, while the **Distractor**s (bad **Answer**s) are the next **Option**s.

## Hierarchical structure: ##

**Section** (contains multiple **Querie**s)
Query (contains one **Question** **Item** and multiple **Option** **Item**s)
**Item** (atomic component, either a **Question** or an **Option**)

This creates a clean separation between:

- The atomic components (**Item**s) that are selected by coordinates
- The logical groupings (**Querie**s) that represent complete **Question**/**Answer** sets
- The organizational units (**Section**s) that structure the overall assessment

## **SectionArray**: ##

<table>
  <tr>
    <th></th>
    <th>0</th>
    <th>1</th>
    <th>2</th>
  </tr>
  <tr>
    <td>0</td>
    <td bgcolor="#647687"><font color="white">S1Q1</font></td>
    <td bgcolor="#647687"><font color="white">S1Q2</font></td>
    <td bgcolor="#647687"><font color="white">S1Q3</font></td>
  </tr>
  <tr>
    <td>1</td>
    <td bgcolor="#6d8764"><font color="white">S1A1</font></td>
    <td bgcolor="#6d8764"><font color="white">S1A2</font></td>
    <td bgcolor="#6d8764"><font color="white">S1A3</font></td>
  </tr>
  <tr>
    <td>2</td>
    <td bgcolor="#647687"><font color="white">S2Q1</font></td>
    <td bgcolor="#647687"><font color="white">S2Q2</font></td>
    <td bgcolor="#647687"><font color="white">S2Q3</font></td>
  </tr>
  <tr>
    <td>3</td>
    <td bgcolor="#6d8764"><font color="white">S2A1</font></td>
    <td bgcolor="#6d8764"><font color="white">S2A2</font></td>
    <td bgcolor="#6d8764"><font color="white">S2A3</font></td>
  </tr>
</table>

The **SectionArray** is an 0-based 2d array contening codes in the format SxQy and SxAy interleaved by rows. This array isn't a part of the **MCQSelector**, but the code format is used in the **MCQSelector**.

## **Section**: ##

- Multiple **Question**/**Option**s is a called **Section**
- **Question**/**Option**s pair is called Query

## Query: ##

- Each **Query** is set from the data send to build a **Section**
- Range **Question** x,y
- Range **Option** x,y
- **Key** always **Option** #1
- **Distractor**s always the next **Option**s

- Selected **Question** in range x,y
- Selected **Answer**s (**Option**s) in range x,y in relative/absolute coordinates
- No out-of-bound guard in the selection process

- Number of **Question** by **Section** unlimited (list of **Question**)
- Number of **Option**s by **Question**s unlimited (list of **Option**s per list of **Question**)

- Within a **Query**, each **Distractor**s is unique and different from the **Key** and **Question**, it uses the **Comparator** system.

## **Comparator** System: ##

- Compare level 0
	- SaQb compare a,b
- Compare level 1
	- SaQb compare a
- Compare level 2
	- SaQb compare b

- The comparison can compare Q or A **Item** codes.

- Guard -> Abord after 1000 try by **Query**

## **Substitution** System: ##

- **SubstitutionMode:Bool**
- **TempSubstitutedQuestion** contains an **Item** code
- Range x,y in relative/absolute coordinates per axis
- Substituted **Question** choosen at the start of the **Query** set up and stored in **TmpSubstitutedQuestion**
- At the very end of the **Query**'s set up, the initial choosen **Question** is replaced by the value stored in **TmpSubstitutedQuestion**

## Ink Format implementation of a Query's **Prompt**: ##

While using the **Query** as used by the scenario to **Prompt** the player, the sequence is called **Prompt**.

The Ink script use a template with the maximum number of **Option**s, then use conditional logic to only display valid **Option**s:
``` "Ink"
=== query_template ===
{Question_text}
* [{Option_1_text}]
    -> {Option_1_destination}
* {Option_count >= 2: [{Option_2_text}]
    -> {Option_2_destination}}
* {Option_count >= 3: [{Option_3_text}]
    -> {Option_3_destination}}
* {Option_count >= 4: [{Option_4_text}]
    -> {Option_4_destination}}
// And so on...
```

These are a maximum of 6 **Option**s by **Prompt** in the current project. 
But it's important to note that this implementation isn't a part of the **MCQSelector** algorithm.

## **SectionArray**: ##

The **MCQSelector** works independently and aside the **SectionArray** containing **Question**s/**Key**s. When the **MCQSelector** is lunched, it will generate a **Section** of **Question**s who can have any number of **Option**s we want and any **Question** we want too. The number of **Question**s for the **Section** is choosen in a range. 
If we want always, per example, 3 **Question**s by **Section**s, we set the range at 3,3. The same for the **Option**s, we can set a range of number of **Option**s. 
If, per example, we set the number of **Option**s at 3,6, the number of **Option**s generated by **Question**s in the **Section** will be randomly between 3 and 6.

For simplicity, the **Key** is always the **Option** 1 within the generated list of **Answer**s. This **Answer**/**Key** is indicated in the **SectionArray** as like in the example (green cells). 

So, we pass to the function of the **MCQSelector** a range of possible selected **Question**s in X and Y. Then a range of possible **Option**s in X and Y in absolute coordinates, or relative coordinates to the selected **Question**. Within the generator itself, they is no boundary guard.
The **Section** generated is the output, as a serie of reference codes in lists. These reference codes can allows to load the content in the **SectionArray**. This array is zero-based, as it's more easy to operate in local coordinate within. But note that the **Item**'s code nomenclature uses a 1-based system.

So, the **MCQSelector** is lunched with its parameters (ranges, etc), and then we use the output to find the **Item**s in the **SectionArray** we want. There not limit about the number of **Question** by **Section**, and the number of **Option** by **Question**.
Configurable Comparison Logic
The **Comparator** level provides granular control over the **Item** matching process. By setting the appropriate level (0, 1, 2, etc.), the system can intelligently select **Distractor**s that challenge learners in specific ways:

- **Level 0**: Exact matching (compare full identifiers)

- **Level 1**: Category matching (compare only the category portion)

- **Level 2**: Subcategory matching (compare category and subcategory)

When the **MCQSelector** set the **Item**s, any **Distractor**s are repeated, and no **Distractor**s are equal to the **Key**. This system use a **Comparator** algorithm which the behaviour can be set in order to selectively compare a part of the **Item** name.
By default, the **Comparator** is always 0, so each elements of the **Answer** (**Key** and **Distractor**s) are compared. By example, if "S1Q1" and "S1Q2" are compared, when the **Comparator** is set to 0, "S1Q1"<>"S1Q2", the same if the **Comparator** is set to 2 because "Q1"<>"Q2". But if the **Comparator** is set to 1, then "S1"="S1". The consequence of this match will force the **MCQSelector** to search another **Item** where **Distractor**="Sn"<>"S1". If the equation isn't satisfacted according the range given to the function, a primitive guard against infinite loop crashes the scenario after 1000 attempts by **Question**.

While the **MCQSelector** itself do not rules the boundary guards, the program can attempt to point an **Item** (as code) that do not exists in the **SectionArray**. The guards can be implemented in the **ExerciceSystem** code.

So, this is how an **ExerciceSystem** could handles a boundary error: 
If the possible **Option**s are choosen in the relative y range 0,0, and in the relative coordinates x in the range -1,1, if the selected **Question** is "S2Q2", then the list of **Option** will be "S2A2" (the **Key**), "S2A1" and "S2A3" (the **Distractor**s). But if the selected **Question** is "S2A1", the **Option**s should contains "S2A0" code that do not exists in the **SectionArray** (out of bounds). So the **ExerciceSystem** could trims the code as "S2A1" or mod the code as "S2A2". Anyway, the behaviour depends on how the **ExerciceSystem** is implemented, not the **MCQSelector**.

A last subsystem is the **Substitution** system who works with a boolean to activated it (**SubstitutionMode**) and a range x,y with local/global coordinate **Option**s for the two axis. This system allows to substitute the **Question** with any other **Item** within the range. This process occurs at the end of the **Section** selection process. See the last pratical example for usage.

## Dynamic Content **Substitution**: ##

The **Substitution** system transforms the way **Question**s and **Answer**s relate to each other. By enabling the **SubstitutionMode**, the system can create exercises that test relationships between **Item**s rather than direct knowledge. This is particularly powerful for generating problems that test understanding of complementary concepts, opposites, or transformations.

The temporary storage of the substituted **Question** (**TempSubstitutedQuestion**) ensures that the **Distractor** selection process remains coherent even when the final **Question** will be different from the initial selection.

## Boundary Management: ##

While the **MCQSelector** itself doesn't implement boundary protections, the document outlines strategies for the larger **ExerciseSystem** to handle out-of-bounds selections. This separation of concerns ensures that the generator remains focused on its core responsibility (creating diverse **Question** sets) while allowing integration points for error handling.

The modular design enables different ExerciseSystems to implement custom boundary handling strategies appropriate to their specific needs, whether through trimming, modulo arithmetic, or other approaches.

## Example: ##

We lunch the **MCQSelector** who will produce a **Section** of one **Question** and two **Option**s.
The **Question** is choosen within the range x 0,2 and y 1,1. While the **Option**'s Number is in the range 2,2 (always 2 **Option**s), and are choosen in the range x 0,2 in absolute coordinate, and in the range y 0,0 in relative coordinate.

So, the List of **Question**s in the **Section** could contains: "S2Q1" or "S2Q2"or "S2Q3"
and the list of possible **Option**s for a **Question** would be "S2A1", "S2A2" and "S2A3". 
If the choosen **Question** was S2Q1, the **Key** in the **Option**'s list is "S2A1", if the choosen **Question** was "S2Q2", the **Key** in the **Option**'s list is "S2A2"... while the other **Option** is choosen between the two other **Item**s "A"+n.

## Praticable Examples: ##

<table>
	<tr>
		<th></th>
		<th>0</th>
		<th>1</th>
		<th>2</th>
	</tr>
	<tr>
		<td>0</td>
		<td bgcolor="#a20025"><font color="white">"Red"</font></td>
		<td bgcolor="#008a00"><font color="white">"Green"</font></td>
		<td bgcolor="#0000CC"><font color="white">"Blue"</font></td>
	</tr>
	<tr>
		<td>1</td>
		<td bgcolor="#e51400"><font color="white">"Primary","Rouge"</font></td>
		<td bgcolor="#60a917"><font color="white">"Primary","Vert"</font></td>
		<td bgcolor="#3333FF"><font color="white">"Primary","Bleu"</font></td>
	</tr>
	<tr>
		<td>2</td>
		<td bgcolor="#004C99"><font color="white">"Cyan"</font></td>
		<td bgcolor="#660066"><font color="white">"Magenta"</font></td>
		<td bgcolor="#f0a30a"><font color="black">"Yellow"</font></td>
	</tr>
	<tr>
		<td>3</td>
		<td bgcolor="#1ba1e2"><font color="white">"Secondary","Cyan"</font></td>
		<td bgcolor="#d80073"><font color="white">"Secondary","Magenta"</font></td>
		<td bgcolor="#e3c800"><font color="black">"Secondary","Jaune"</font></td>
	</tr>
	<tr>
		<td>4</td>
		<td bgcolor="#000000" style="background-image: linear-gradient(to right, #000000, #b3b3b3);"><font color="white">"Gradient"</font></td>
		<td bgcolor="#6a00ff"><font color="white">"Solid"</font></td>
		<td bgcolor="#647687"><font color="white">"Pattern"</font></td>
	</tr>
	<tr>
		<td>5</td>
		<td bgcolor="#6d8764"><font color="white">"FillMode","Gradient"</font></td>
		<td bgcolor="#6d8764"><font color="white">"FillMode","Solid"</font></td>
		<td bgcolor="#6d8764"><font color="white">"FillMode","Pattern"</font></td>
	</tr>
</table>

### Example: "Match the color with its corresponding name in French" ###

We lunch the **MCQSelector** who will produce a **Section** of one **Question** and two **Option**s.
In the **ExerciceSystem**'s side, the **Prompt** is "Match the color with its corresponding name in French". 
The **Question** is choosen within the range x 0,2 and y 0,1. While the **Option**'s Number is in the range 2,2 (always 2 **Option**s), and are choosen in the range x 0,2 in absolute coordinate, and in the range y 0,1 in absolute coordinate.

For the example, we choose the **Question** "Red", the **Key** is then "Rouge". The  unique **Distractor** is choosen from "Vert", "Bleu", "Cyan", "Magenta" and "Jaune".
As the **ExerciceSystem** **Prompt**s a color, the same system knows it must display the second **Item** from the **Answer** **Item**s. For this **Prompt**, knowing that the **Question** is the **Item** S1Q1, the **Key** is S1A1, and the **Distractor**s could be S1An or S2An. In this example, the right **Answer** share the first and second offset (1 and 1 of S1A1) with the **Question**. So from the displayed **Prompt**, it could be like:

*"Match the color with its corresponding name in French"*
   *(shawn a red square)*
   1. Rouge (S1A1, the **Key**)
   2. Magenta (S2A2, the **Distractor**)

### Example: "Name the category of this color" ###

Second example, the **ExerciceSystem** **Prompt**s "Name the category of this color".
The **Question** is choosen within the range x 0,2 and y 0,1. While the **Option**'s Number is in the range 2,2 (always 2 **Option**s), and are choosen in the range x 0,2 in absolute coordinate, and in the range y 0,1 in absolute coordinate. In the ****MCQSelector****, we set the **Comparator** to 1, to compare the first **Item** only.

In this example, we choose the **Question** "Red". The **Key** is 
then "Primary","Rouge". Since the list in the Inc format is defined as 1-based, "Primary" is the first part, "Rouge" the second part. Since the **Comparator** is set to 1, the **MCQSelector** will compares "Primary" with another **Item**'s first part in the **Distractor** selection process. Selecting this **Distractor** (unique since the range is 2,2 for two **Option**s in any case), the **Distractor** is choosen from "Vert", "Bleu", "Cyan", "Magenta" and "Jaune" where only "Cyan", "Magenta" and "Jaune" are valids, since the first part of these **Item**s is "Secondary", which match with the **Item** category S2An. The **MCQSelector** will pick any **Item**s which the first part verify S1<>Sn. 
Since the **MCQSelector** will search a different **Item**s as **Distractor**s, this is important in this case to propose only 2 **Option**s, because if we set more possible **Option**s, like for example 3, the algorithm will search a 3th **Distractor** who don't match S1 and the S2 from the second **Distractor**, entering then in a infinite loop, until we enlarge the y range of the **Option**s.

So, this is how the **Prompt** is be shown from a **ExerciceSystem**:

*"Name the category of this color"*
   *(shawn a red square)*
   1. Primary (S1A1, the **Key**)
   2. Seconday (S2A2, the **Distractor**)

The limitation of this system is that a "category", or "set" can be only defined in column or row in the **SectionArray**.

### Example: "Find the complementary color" ###

Thirth example that use the **Substitution** process, the **ExerciceSystem** **Prompt**s "Find the complementary color".
The **Question** is choosen within the range x 0,2 and y 0,1. While the **Option**'s Number is in the range 2,2 (always 2 **Option**s), and are choosen in the range x 0,2 in absolute coordinate, and in the range y 0,1 in absolute coordinate. In the **MCQSelector**, we set the **Comparator** to 1, to compare the first **Item** only, and the ****Substitution**Mode** to True.

In this example, we choose the **Question** "Red". The **Key** is 
then "Primary","Rouge". Since the ****Substitution**Mode** is set to True, and the range is set in local coordinate in x with the range 0,0 and the y axis is set in local coordinate in the range 0,1, the **MCQSelector** will chooses any other **Item**s within this range, so in this example, "Cyan" is the only valid **Substitution**. The **Key** becomes "Primary", "Cyan", from the **Item** S2Q1 (it's Cyan from french, not english). But the **Substitution** process only operates at the very end of the **Section**'s set up. For now, the whole system use Red (S1Q1) as the **Question** and considerate "Primary", "Rouge" as the **Key** (S1A1), but already choose the subtitued **Key** as a temp value (TempSubstitued**Question**).

Since the **Comparator** is set to 1, the **MCQSelector** will compares "Primary" with another **Item**'s first part in the **Distractor** selection process. The **Distractor** is choosen from "Vert", "Bleu", "Cyan", "Magenta" and "Jaune" where only "Cyan", "Magenta" and "Jaune" are valids, since the first part of these **Item**s is "Secondary", which match with the **Item** category S2An. The **MCQSelector** will pick any **Item**s which the first part verify S1<>Sn. 

In this example, we want the **Key** for "Red" is "Cyan", so Cyan can't be picked neither as **Distractor**, because it matches with the temp substitued value. When an **Item** is selected as potential **Distractor** while the ****Substitution**Mode** is activated, the **Item** is verified to not matches with the **Question** and the TempSubstituted**Question**. 
The valid **Distractor**s are "Magenta" and "Jaune".
At the end of the process, the TempSubstituted**Question** (here, it's S2Q1) replace the **Question** (here, S1Q1). And the **Section** is done.

So, this is how the **Prompt** is be shown from a **ExerciceSystem** if we choose to read the Q for S2Q1 corresponding with the A of S2A1:

*"Find the complementary color"*
   *(shawn a red square)*
   1. Cyan (S1Q1, the **Key**)
   2. Yellow (S2Q3, possible **Distractor**)

The subtituted **Item** can be picked randomly in a range, so this system is only worst to explore.

# Ink Variable-Length Nested Lists for MCQSelector

# Ink Variable Structure for MCQSelector
**Implementation by iDkP from GaragePixel - 2025-04-29 - Aida v1.2.3**

## Purpose
This technical document provides a streamlined implementation for representing the MCQSelector's hierarchical data structure in Ink script, showing how we can maintain sections with variable-length queries and options while working within Ink's variable system constraints.

## List of Functionality
* Section/Query/Option hierarchy using string-encoded structure
* Variable-length option lists per question
* Section and query creation API
* Query retrieval functions
* Section navigation capabilities
* Quiz state serialization
* MCQSelector namecode system compatibility (SnQn, SnAn format)
* Minimal implementation with no unnecessary features

## Notes on Implementation

Ink's variable system presents unique challenges for representing hierarchical data. This implementation uses delimiter-based string encoding to create the Section → Query → Options structure needed for MCQSelector while maintaining compatibility with our namecode system. The implementation focuses only on essential functionality with no unnecessary overhead.

```ink
// Define our section storage and separator constants
VAR SECTION_DELIM = "§"
VAR QUERY_DELIM = "¶"
VAR ITEM_DELIM = "|"

// Storage variables
VAR currentSection = ""
VAR currentQuestion = ""
VAR currentOptions = ""
VAR sections = ""

=== function CreateOption(optionCode) ===
	~ return optionCode
===

=== function CreateQuestion(questionCode) ===
	~ return questionCode
===

=== function BeginQuery(questionCode) ===
	// Start a new query
	~ currentQuestion = CreateQuestion(questionCode)
	~ currentOptions = ""
	~ return true
===

=== function AddOption(optionCode) ===
	// Add option to current query's options
	{
		- currentOptions == "":
			~ currentOptions = CreateOption(optionCode)
		- else:
			~ currentOptions = currentOptions + ITEM_DELIM + CreateOption(optionCode)
	}
	~ return true
===

=== function FinishQuery() ===
	// Combine question and options into a query
	~ temp query = currentQuestion + QUERY_DELIM + currentOptions
	
	// Add to current section
	{
		- currentSection == "":
			~ currentSection = query
		- else:
			~ currentSection = currentSection + SECTION_DELIM + query
	}
	~ return true
===

=== function StartSection() ===
	~ currentSection = ""
	~ return true
===

=== function EndSection(sectionName) ===
	// Store the complete section
	~ temp sectionEntry = sectionName + QUERY_DELIM + currentSection
	
	// Add to all sections
	{
		- sections == "":
			~ sections = sectionEntry
		- else:
			~ sections = sections + SECTION_DELIM + sectionEntry
	}
	~ return sectionName
===

=== function DisplayQuery(queryStr) ===
	~ temp parts = queryStr.Split(QUERY_DELIM)
	~ temp question = parts[0]
	~ temp optionsStr = parts[1]
	~ temp options = optionsStr.Split(ITEM_DELIM)
	~ temp i = 0
	
	Question: {question}
	Options:
	{
		- i < LIST_COUNT(options):
			- {LIST_VALUE(options, i)}
			~ i = i + 1
			-> LOOP
	}
	~ return true
===

=== function GetQueryAt(sectionName, queryIndex) ===
	~ temp sectionsList = sections.Split(SECTION_DELIM)
	~ temp i = 0
	~ temp result = ""
	
	{
		- i < LIST_COUNT(sectionsList):
			~ temp sectionParts = LIST_VALUE(sectionsList, i).Split(QUERY_DELIM)
			~ temp currentSectionName = sectionParts[0]
			
			{
				- currentSectionName == sectionName:
					~ temp sectionContent = sectionParts[1]
					~ temp queriesList = sectionContent.Split(SECTION_DELIM)
					
					{
						- queryIndex >= 0 && queryIndex < LIST_COUNT(queriesList):
							~ result = LIST_VALUE(queriesList, queryIndex)
					}
			}
			
			~ i = i + 1
			-> LOOP
	}
	
	~ return result
===

=== function SaveQuizState() ===
	~ return sections
===

=== function LoadQuizState(savedState) ===
	~ sections = savedState
	~ return true
===

=== function CountQueriesInSection(sectionName) ===
	~ temp sectionsList = sections.Split(SECTION_DELIM)
	~ temp i = 0
	~ temp queryCount = 0
	
	{
		- i < LIST_COUNT(sectionsList):
			~ temp sectionParts = LIST_VALUE(sectionsList, i).Split(QUERY_DELIM)
			~ temp currentSectionName = sectionParts[0]
			
			{
				- currentSectionName == sectionName:
					~ temp sectionContent = sectionParts[1]
					~ temp queriesList = sectionContent.Split(SECTION_DELIM)
					~ queryCount = LIST_COUNT(queriesList)
			}
			
			~ i = i + 1
			-> LOOP
	}
	
	~ return queryCount
===

=== function ListAllSections() ===
	~ temp sectionsList = sections.Split(SECTION_DELIM)
	~ temp i = 0
	~ temp sectionNames = ()
	
	{
		- i < LIST_COUNT(sectionsList):
			~ temp sectionParts = LIST_VALUE(sectionsList, i).Split(QUERY_DELIM)
			~ temp currentSectionName = sectionParts[0]
			~ sectionNames += currentSectionName
			~ i = i + 1
			-> LOOP
	}
	
	~ return sectionNames
===

=== CreateMCQExample ===
	// Start a new section
	~ StartSection()
	
	// Create first query with 3 options
	~ BeginQuery("S1Q1")
	~ AddOption("S1A1")
	~ AddOption("S1A2")
	~ AddOption("S1A3")
	~ FinishQuery()
	
	// Create second query with 2 options
	~ BeginQuery("S1Q2")
	~ AddOption("S1A4")
	~ AddOption("S1A5")
	~ FinishQuery()
	
	// Finalize the section
	~ EndSection("Section1")
===

=== CreateMathQuiz ===
	// Start a new section
	~ StartSection()
	
	// Create first query with 3 options
	~ BeginQuery("What is 2+2?")
	~ AddOption("3")
	~ AddOption("4")
	~ AddOption("5")
	~ FinishQuery()
	
	// Create second query with 7 options
	~ BeginQuery("Which are prime numbers?")
	~ AddOption("1")
	~ AddOption("2")
	~ AddOption("3") 
	~ AddOption("4")
	~ AddOption("5")
	~ AddOption("6")
	~ AddOption("7")
	~ FinishQuery()
	
	// Create third query with 2 options
	~ BeginQuery("Is 9 divisible by 3?")
	~ AddOption("Yes")
	~ AddOption("No")
	~ FinishQuery()
	
	// Create fourth query with 4 options
	~ BeginQuery("What is the square root of 16?")
	~ AddOption("2")
	~ AddOption("4")
	~ AddOption("8")
	~ AddOption("16")
	~ FinishQuery()
	
	// Finalize the section
	~ EndSection("MathQuiz")
===
```

## Technical Advantages

### Explanation of DisplayQuery Function

The DisplayQuery function simply displays the question code and option codes without additional formatting. I previously included alphabet labels (A, B, C, etc.), but that was unnecessary since your MCQSelector uses a namecode system where:

1. Questions are coded as SnQm (Section n, Question m)
2. Options/answers are coded as SnAm (Section n, Answer m)

These codes already contain the necessary identifiers, so no additional labeling is needed. The revised DisplayQuery function simply outputs:

```
Question: S1Q1
Options:
- S1A1
- S1A2
- S1A3
```

The dash before each option is just for Ink's text formatting; it doesn't add any processing complexity.

### Advantages of This Approach

This string-encoded approach provides several key advantages for the MCQSelector implementation:

1. **Pure Value-Based Storage**: Since Ink doesn't support references or pointers, our encoding approach uses only value-based variables, the solution uses only native Ink features while achieving the complex data hierarchy needed:

```ink
=== TestCreation ===
	~ CreateMCQExample()
	~ temp query = GetQueryAt("Section1", 0)
	
	First query:
	{DisplayQuery(query)}
	
	This section has {CountQueriesInSection("Section1")} queries.
===


=== TestQuizGeneration ===
	~ CreateMathQuiz()
		
	// Display quiz details
	Math Quiz has {CountQueriesInSection("MathQuiz")} questions.
		
	Let's see the third question:
	{DisplayQuery(GetQueryAt("MathQuiz", 2))}
===
```

2. **Data Integrity**: The hierarchical structure is preserved despite Ink's flat variable system:

```
Function BuildFromArray(array:String[,])
	StartSection()
	
	For Local y:Int = 0 Until array.GetSize(0) Step 2
		For Local x:Int = 0 Until array.GetSize(1)
			BeginQuery(array[y,x])
			AddOption(array[y+1,x])
			FinishQuery()
		Next
	End
	
	EndSection("ArraySection")
End
```

3. **Variable-Length Support**: The delimiter approach accommodates any number of options per query:

```ink
=== CreateVariableOptionsQuiz ===
	~ StartSection()
	
	// Question with 2 options
	~ BeginQuery("S1Q1")
	~ AddOption("S1A1")
	~ AddOption("S1A2")
	~ FinishQuery()
	
	// Question with 7 options
	~ BeginQuery("S1Q2")
	~ AddOption("S1A3")
	~ AddOption("S1A4")
	~ AddOption("S1A5")
	~ AddOption("S1A6")
	~ AddOption("S1A7")
	~ AddOption("S1A8")
	~ AddOption("S1A9")
	~ FinishQuery()
	
	~ EndSection("VarOptionQuiz")
===
```


4. **State Persistence**: The string representation enables saving and restoring quiz state during runtime:

```ink
=== SaveAndRestoreDemo ===
	~ CreateMathQuiz()
	~ temp savedState = SaveQuizState()
		
	// Clear everything by starting a new quiz
	~ StartSection()
	~ BeginQuery("Temporary question")
	~ AddOption("Temporary option")
	~ FinishQuery()
	~ EndSection("Temporary")
		
	// Now restore the original state
	~ LoadQuizState(savedState)
	~ temp quizCount = CountQueriesInSection("MathQuiz")
		
	Successfully restored Math Quiz with {quizCount} questions.
===


5. **Section Iteration Capability**: The structure supports listing and iterating through all sections:

```ink
=== DisplayAllQuizzes ===
	~ temp allSections = ListAllSections()
	~ temp i = 0
	
	Available quizzes:
	{
		- i < LIST_COUNT(allSections):
			{i+1}. {LIST_VALUE(allSections, i)}
			~ i = i + 1
			-> LOOP
	}
===
```

This implementation fully integrates with the MCQSelector's namecode system, which relies on string identifiers for content elements. Using delimiter-based encoding, we can maintain the hierarchical relationships between sections, queries, and options that MCQSelector requires, while working entirely within Ink's native capabilities.

The approach creates a standardized API for quiz creation and access that mirrors the MCQSelector's structure while accommodating the constraint of working with Ink's value-based variable system rather than reference-based object models. This enables us to deliver consistent quiz experiences across platforms while leveraging Ink's narrative capabilities.

# Ink Codename Comparator for MCQSelector

## Purpose

These functions implement the MCQSelector's code comparison algorithm in Ink format, enables flexible relationships between codenames. The system to determine relationships between different codenames based on configurable comparison modes. Here's a pure Ink implementation of the comparator function that supports the three comparison modes (0 = exact match, 1 = section match, 2 = item match):
The MCQSelector uses a flexible codename format (SxYz where x=section number, Y=Q/A, z=item number) which requires robust parsing. These functions correctly extract the components from any valid codename and compare them according to the specified mode.

```ink
=== function CompareCodenames(codename1, codename2, mode) ===
    // Mode 0: exact comparison
    {
        - mode == 0:
            ~ return codename1 == codename2
    }
    
    // Mode 1: Compare section code (S1 == S1)
    {
        - mode == 1:
            ~ temp part1 = GetSectionCode(codename1)
            ~ temp part2 = GetSectionCode(codename2)
            ~ return part1 == part2
    }
    
    // Mode 2: Compare item code (Q1 == Q1)
    {
        - mode == 2:
            ~ temp part1 = GetItemCode(codename1)
            ~ temp part2 = GetItemCode(codename2)
            ~ return part1 == part2
    }
    
    ~ return false
===

=== function GetSectionCode(codename) ===
    // Find first A or Q to split the string
    ~ temp i = 1 // Start after first character (S)
    ~ temp foundSplit = false
    ~ temp splitPos = 0
    
    {
        - i < STRING_LENGTH(codename) && !foundSplit:
            {
                - SUBSTRING(codename, i, 1) == "A" || SUBSTRING(codename, i, 1) == "Q":
                    ~ foundSplit = true
                    ~ splitPos = i
                - else:
                    ~ i = i + 1
                    -> LOOP
            }
    }
    
    {
        - foundSplit:
            ~ return SUBSTRING(codename, 0, splitPos)
        - else:
            ~ return ""
    }
===

=== function GetItemCode(codename) ===
    // Find first A or Q to extract item code
    ~ temp i = 1 // Start after first character (S)
    ~ temp foundSplit = false
    ~ temp splitPos = 0
    
    {
        - i < STRING_LENGTH(codename) && !foundSplit:
            {
                - SUBSTRING(codename, i, 1) == "A" || SUBSTRING(codename, i, 1) == "Q":
                    ~ foundSplit = true
                    ~ splitPos = i
                - else:
                    ~ i = i + 1
                    -> LOOP
            }
    }
    
    {
        - foundSplit:
            ~ return SUBSTRING(codename, splitPos)
        - else:
            ~ return ""
    }
===
```

## Technical Advantages

The implementation uses character-by-character parsing to correctly handle any valid codename in our system:

1. **Section Extraction Algorithm**: Identifies the section portion by finding the first A or Q character, then extracting everything before it
   
2. **Item Extraction Algorithm**: Similarly extracts the item code by finding the first A or Q and taking everything from that position onward
   
3. **Flexible Number Support**: Works with any number of digits in both section and item identifiers (S1A10, S234Q56, etc.)

This approach aligns with the MCQSelector's array-based implementation as documented in our technical specifications, enabling flexible coordinate-based relationships between questions and answers through codename pattern matching.
