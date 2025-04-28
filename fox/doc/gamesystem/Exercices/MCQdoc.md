# MCQSelector Documentation Introduction
**Implementation by iDkP from GaragePixel - 2025-04-28 - Aida v4**

## Purpose
This introduction provides an overview of the **MCQSelector** documentation, explaining the system architecture and data structures that enable flexible, coordinate-based multiple-choice question generation.

## List of Functionality
* Content overview and navigation guidance
* System architecture introduction
* Data structure relationships explanation
* Implementation pattern summary
* Documentation usage recommendations

## Notes on Implementation

The MCQSelector documentation presents a comprehensive overview of the GaragePixel's coordinate-based multiple-choice question system. The document employs visual representations alongside technical explanations to illustrate how our array-based approach enables flexible question generation through coordinate selection.

The document successfully demonstrates the relationship between Sections, Queries, and Items through both visual diagrams and structural explanations. The array visualizations clearly show how questions and answers are organized in a grid format that supports programmatic selection and relationship mapping.

No logical errors were detected in the documentation. The relationships between components are consistently represented, and the data structures align with the described implementation patterns. The coordinate system provides a solid foundation for the MCQ generation algorithms described throughout the document.

## Technical Advantages

The documentation effectively communicates the **MCQSelector**'s core design principles, particularly its use of:

1. **Coordinate-Based Selection**: The grid structure enables precise targeting of questions and their related answers.

2. **Section Encapsulation**: The organization of content into topic-specific sections provides logical separation of quiz material.

3. **Query Construction Pattern**: The relationship between Items, Questions, and **Option**s follows a consistent pattern that supports diverse question types.

This documentation serves as an essential reference for GaragePixel implementing or extending the MCQSelector system, providing both conceptual understanding and practical implementation guidance.

## Terminology: ##

<table border="0" cellpadding="8">
	<tr>
		<td width="100" valign="middle" align="left">Section</td>
		<td width="50" valign="middle" align="center">→</td>
		<td width="160" valign="top">
			<table border="1" cellpadding="4" width="100%">
				<tr><th align="left">Query</th></tr>
				<tr><td align="left">Question</td></tr>
				<tr><td align="left">**Option** 2</td></tr>
				<tr><td align="left">**Option** 3</td></tr>
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
				<tr><td align="left">**Option** 2</td></tr>
				<tr><td align="left">**Option** 3</td></tr>
			</table>
		</td>
		<td width="50" valign="middle" align="center">←</td>
		<td width="100" valign="middle" align="left">Items</td>
	</tr>
</table>

- The Question and the **Option** are called "Item" because the system operates indifferently on a set to construct the Multiple Choice Questions form.

- Multiple Questions (Question's Serie) is called Section.

- A Question/**Option**s pair is called Query.

- The outputed Section always produce the Key (good answer) as **Option** 1, while the Distractors (bad answers) are the next **Option**s.

## Hierarchical structure: ##

Section (contains multiple Queries)
Query (contains one Question Item and multiple **Option** Items)
Item (atomic component, either a Question or an **Option**)
This creates a clean separation between:

The atomic components (Items) that are selected by coordinates
The logical groupings (Queries) that represent complete question/answer sets
The organizational units (Sections) that structure the overall assessment

## SectionArray: ##

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

The SectionArray is an 0-based 2d array contening codes in the format SxQy and SxAy interleaved by rows. This array isn't a part of the MCQSelector, but the code format is used in the MCQSelector.

## Section: ##

- Multiple Question/**Option**s is a called Section
- Question/**Option**s pair is called Query

## Query: ##

- Each Query is set from the data send to build a Section
- Range Question x,y
- Range **Option** x,y
- Key always **Option** #1
- Distractors always the next **Option**s

- Selected Question in range x,y
- Selected Answers (**Option**s) in range x,y in relative/absolute coordinates
- No out-of-bound guard in the selection process

- Number of Question by Section unlimited (list of Question)
- Number of **Option**s by Questions unlimited (list of **Option**s per list of Question)

- Within a Query, each Distractors is unique and different from the Key and Question, 	it uses the Comparator system.

## Comparator System: ##

- Compare level 0
	- SaQb compare a,b
- Compare level 1
	- SaQb compare a
- Compare level 2
	- SaQb compare b

- The comparison can compare Q or A item codes.

- Guard -> Abord after 1000 try by Query

## Substitution System: ##

- SubstitutionMode:Bool
- TempSubstitutedQuestion contains an item code
- Range x,y in relative/absolute coordinates per axis
- Substituted question choosen at the start of the Query set up and stored in TmpSubstituted
- At the very end of the Query's set up, the initial choosen Question is replaced by the value stored in TmpSubstitutedQuestion

## Ink Format implementation of a Query's **Prompt**: ##

While using the Query as used by the scenario to **Prompt** the player, the sequence is called **Prompt**.

The Ink script use a template with the maximum number of **Option**s, then use conditional logic to only display valid **Option**s:
``` "Ink"
=== query_template ===
{question_text}
* [{**Option**_1_text}]
    -> {**Option**_1_destination}
* {**Option**_count >= 2: [{**Option**_2_text}]
    -> {**Option**_2_destination}}
* {**Option**_count >= 3: [{**Option**_3_text}]
    -> {**Option**_3_destination}}
* {**Option**_count >= 4: [{**Option**_4_text}]
    -> {**Option**_4_destination}}
// And so on...
```

These are a maximum of 6 **Option**s by **Prompt** in the current project. 
But it's important to note that this implementation isn't a part of the MCQSelector algorithm.

## SectionArray: ##

The **MCQSelector** works independently and aside the SectionArray containing Questions/Keys. When the **MCQSelector** is lunched, it will generate a section of Questions who can have any number of **Option**s we want and any Question we want too. The number of Questions for the Section is choosen in a range. 
If we want always, per example, 3 questions by Sections, we set the range at 3,3. The same for the **Option**s, we can set a range of number of **Option**s. 
If, per example, we set the number of **Option**s at 3,6, the number of **Option**s generated by Questions in the Section will be randomly between 3 and 6.

For simplicity, the Key is always the **Option** 1 within the generated list of answers. This answer/key is indicated in the SectionArray as like in the example (green cells). 

So, we pass to the function of the **MCQSelector** a range of possible selected questions in X and Y. Then a range of possible **Option**s in X and Y in absolute coordinates, or relative coordinates to the selected Question. Within the generator itself, they is no boundary guard.
The Section generated is the output, as a serie of reference codes in lists. These reference codes can allows to load the content in the SectionArray. This array is zero-based, as it's more easy to operate in local coordinate within. But note that the Item's code nomenclature uses a 1-based system.

So, the **MCQSelector** is lunched with its parameters (ranges, etc), and then we use the output to find the Items in the SectionArray we want. There not limit about the number of Question by Section, and the number of **Option** by Question.
Configurable Comparison Logic
The Comparator level provides granular control over the item matching process. By setting the appropriate level (0, 1, 2, etc.), the system can intelligently select Distractors that challenge learners in specific ways:

- Level 0: Exact matching (compare full identifiers)

- Level 1: Category matching (compare only the category portion)

- Level 2: Subcategory matching (compare category and subcategory)

When the **MCQSelector** set the Items, any Distractors are repeated, and no Distractors are equal to the Key. This system use a Comparator algorithm which the behaviour can be set in order to selectively compare a part of the Item name.
By default, the Comparator is always 0, so each elements of the Answer (Key and Distractors) are compared. By example, if "S1Q1" and "S1Q2" are compared, when the Comparator is set to 0, "S1Q1"<>"S1Q2", the same if the Comparator is set to 2 because "Q1"<>"Q2". But if the Comparator is set to 1, then "S1"="S1". The consequence of this match will force the **MCQSelector** to search another Item where Distractor="Sn"<>"S1". If the equation isn't satisfacted according the range given to the function, a primitive guard against infinite loop crashes the scenario after 1000 attempts by Question.

While the **MCQSelector** itself do not rules the boundary guards, the program can attempt to point an Item (as code) that do not exists in the SectionArray. The guards can be implemented in the ExerciceSystem code.

So, this is how an ExerciceSystem could handles a boundary error: 
If the possible **Option**s are choosen in the relative y range 0,0, and in the relative coordinates x in the range -1,1, if the selected Question is "S2Q2", then the list of **Option** will be "S2A2" (the Key), "S2A1" and "S2A3" (the Distractors). But if the selected Question is "S2A1", the **Option**s should contains "S2A0" code that do not exists in the SectionArray (out of bounds). So the ExerciceSystem could trims the code as "S2A1" or mod the code as "S2A2". Anyway, the behaviour depends on how the ExerciceSystem is implemented, not the **MCQSelector**.

A last subsystem is the Substitution system who works with a boolean to activated it (SubstitutionMode) and a range x,y with local/global coordinate **Option**s for the two axis. This system allows to substitute the Question with any other Item within the range. This process occurs at the end of the Section selection process. See the last pratical example for usage.

## Dynamic Content Substitution: ##

The Substitution system transforms the way Questions and Answers relate to each other. By enabling the SubstitutionMode, the system can create exercises that test relationships between items rather than direct knowledge. This is particularly powerful for generating problems that test understanding of complementary concepts, opposites, or transformations.

The temporary storage of the substituted question (TempSubstitutedQuestion) ensures that the distractor selection process remains coherent even when the final question will be different from the initial selection.

## Boundary Management: ##

While the **MCQSelector** itself doesn't implement boundary protections, the document outlines strategies for the larger ExerciseSystem to handle out-of-bounds selections. This separation of concerns ensures that the generator remains focused on its core responsibility (creating diverse question sets) while allowing integration points for error handling.

The modular design enables different ExerciseSystems to implement custom boundary handling strategies appropriate to their specific needs, whether through trimming, modulo arithmetic, or other approaches.

## Example: ##

We lunch the **MCQSelector** who will produce a Section of one Question and two **Option**s.
The Question is choosen within the range x 0,2 and y 1,1. While the **Option**'s Number is in the range 2,2 (always 2 **Option**s), and are choosen in the range x 0,2 in absolute coordinate, and in the range y 0,0 in relative coordinate.

So, the List of Questions in the Section could contains: "S2Q1" or "S2Q2"or "S2Q3"
and the list of possible **Option**s for a Question would be "S2A1", "S2A2" and "S2A3". 
If the choosen Question was S2Q1, the Key in the **Option**'s list is "S2A1", if the choosen Question was "S2Q2", the Key in the **Option**'s list is "S2A2"... while the other **Option** is choosen between the two other Items "A"+n.

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

We lunch the **MCQSelector** who will produce a Section of one Question and two **Option**s.
In the ExerciceSystem's side, the **Prompt** is "Match the color with its corresponding name in French". 
The Question is choosen within the range x 0,2 and y 0,1. While the **Option**'s Number is in the range 2,2 (always 2 **Option**s), and are choosen in the range x 0,2 in absolute coordinate, and in the range y 0,1 in absolute coordinate.

For the example, we choose the Question "Red", the Key is then "Rouge". The  unique Distractor is choosen from "Vert", "Bleu", "Cyan", "Magenta" and "Jaune".
As the ExerciceSystem **Prompt**s a color, the same system knows it must display the second Item from the Answer Items. For this **Prompt**, knowing that the Question is the Item S1Q1, the Key is S1A1, and the Distractors could be S1An or S2An. In this example, the right answer share the first and second offset (1 and 1 of S1A1) with the Question. So from the displayed **Prompt**, it could be like:

"Match the color with its corresponding name in French"
   (shawn a red square)
   1. Rouge (S1A1, the Key)
   2. Magenta (S2A2, the Distractor)

### Example: "Name the category of this color" ###

Second example, the ExerciceSystem **Prompt**s "Name the category of this color".
The Question is choosen within the range x 0,2 and y 0,1. While the **Option**'s Number is in the range 2,2 (always 2 **Option**s), and are choosen in the range x 0,2 in absolute coordinate, and in the range y 0,1 in absolute coordinate. In the **MCQSelector**, we set the Comparator to 1, to compare the first Item only.

In this example, we choose the Question "Red". The Key is 
then "Primary","Rouge". Since the list in the Inc format is defined as 1-based, "Primary" is the first part, "Rouge" the second part. Since the Comparator is set to 1, the **MCQSelector** will compares "Primary" with another Item's first part in the Distractor selection process. Selecting this Distractor (unique since the range is 2,2 for two **Option**s in any case), the Distractor is choosen from "Vert", "Bleu", "Cyan", "Magenta" and "Jaune" where only "Cyan", "Magenta" and "Jaune" are valids, since the first part of these Items is "Secondary", which match with the Item category S2An. The **MCQSelector** will pick any items which the first part verify S1<>Sn. 
Since the **MCQSelector** will search a different Items as Distractors, this is important in this case to propose only 2 **Option**s, because if we set more possible **Option**s, like for example 3, the algorithm will search a 3th Distractor who don't match S1 and the S2 from the second Distractor, entering then in a infinite loop, until we enlarge the y range of the **Option**s.

So, this is how the **Prompt** is be shown from a ExerciceSystem:

"Name the category of this color"
   (shawn a red square)
   1. Primary (S1A1, the Key)
   2. Seconday (S2A2, the Distractor)

The limitation of this system is that a "category", or "set" can be only defined in column or row in the SectionArray.

### Example: "Find the complementary color" ###

Thirth example that use the Substitution process, the ExerciceSystem **Prompt**s "Find the complementary color".
The Question is choosen within the range x 0,2 and y 0,1. While the **Option**'s Number is in the range 2,2 (always 2 **Option**s), and are choosen in the range x 0,2 in absolute coordinate, and in the range y 0,1 in absolute coordinate. In the **MCQSelector**, we set the Comparator to 1, to compare the first Item only, and the SubstitutionMode to True.

In this example, we choose the Question "Red". The Key is 
then "Primary","Rouge". Since the SubstitutionMode is set to True, and the range is set in local coordinate in x with the range 0,0 and the y axis is set in local coordinate in the range 0,1, the **MCQSelector** will chooses any other Items within this range, so in this example, "Cyan" is the only valid substitution. The Key becomes "Primary", "Cyan", from the Item S2Q1 (it's Cyan from french, not english). But the Substitution process only operates at the very end of the Section's set up. For now, the whole system use Red (S1Q1) as the Question and considerate "Primary", "Rouge" as the Key (S1A1), but already choose the subtitued key as a temp value (TempSubstituedQuestion).

Since the Comparator is set to 1, the **MCQSelector** will compares "Primary" with another Item's first part in the Distractor selection process. The Distractor is choosen from "Vert", "Bleu", "Cyan", "Magenta" and "Jaune" where only "Cyan", "Magenta" and "Jaune" are valids, since the first part of these Items is "Secondary", which match with the Item category S2An. The **MCQSelector** will pick any items which the first part verify S1<>Sn. 

In this example, we want the Key for "Red" is "Cyan", so Cyan can't be picked neither as Distractor, because it matches with the temp substitued value. When an Item is selected as potential Distractor while the SubstitutionMode is activated, the Item is verified to not matches with the Question and the TempSubstitutedQuestion. 
The valid Distractors are "Magenta" and "Jaune".
At the end of the process, the TempSubstitutedQuestion (here, it's S2Q1) replace the Question (here, S1Q1). And the Section is done.

So, this is how the **Prompt** is be shown from a ExerciceSystem if we choose to read the Q for S2Q1 corresponding with the A of S2A1:

"Find the complementary color"
   (shawn a red square)
   1. Cyan (S1Q1, the Key)
   2. Yellow (S2Q3, possible Distractor)

The subtituted Item can be picked randomly in a range, so this system is only worst to explore.
