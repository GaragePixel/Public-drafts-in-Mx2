# IMPLEMENTING A MINI TREE STATE MACHINE IN DRAW.IO

## **Implementation Details**
- **Credit**: iDkP from GaragePixel  
- **Date**: 2025-04-12  
- **Aida Version**: 4.2.1
  
---

![Fox Spirit Logo](https://raw.githubusercontent.com/GaragePixel/Public-drafts-in-Mx2/refs/heads/main/fox/doc/img/2021-03-18-HIK-from-2020-07-13---02-BIG-01.gif "Fox Spirit Logo")


## **Purpose**
This document explains how to implement and test a **mini tree as a state machine** using **Draw.io's (diagrams.net)** interactive capabilities. It leverages the platform’s ability to handle **real-time state changes** and integrate with the **Arrange → Explore** feature for testing transitions and variable states.

---

## **List of Functionality**
### **1. State Representation**
- **Nodes as States**: Each tree node represents a specific **state** in the machine.
- **Edges as Transitions**: Directed edges connect nodes, representing possible **transitions** between states.

### **2. Variable Integration**
- **Variables as Metadata**:
	- Variables are attached to states as **custom properties**, allowing them to be read and written dynamically.
	- Example: A node may have properties like `state="active"` or `affinity=+1`.

### **3. Explore Interaction**
- Use **Arrange → Explore** in Draw.io to simulate state transitions and validate the tree's logic.

### **4. Testing Features**
- **Real-Time Updates**: Verify state changes (e.g., variable mutations) directly in the diagram.
- **Conditional Transitions**: Define transitions that depend on specific variable values or states.

---

## **Steps to Implement**

### **1. Create the Tree Diagram**
1. Open **Draw.io Desktop** or Web.
2. Use **UML State Diagram Shapes**:
	- Add **ellipse** or **rounded rectangle** shapes to represent states.
	- Use **arrows** to connect states, indicating transitions.
	- Label arrows with **conditions or triggers** (e.g., `Affinity +1`, `Click Event`).

### **2. Add Variables to States**
1. **Attach Metadata to Nodes**:
	- Right-click on a state node and select **Edit Data**.
	- Add custom properties like:
		```json
		{
			"state": "active",
			"affinity": "+1",
			"trust": "false"
		}
		```
	- These properties act as **variables** that can be read or updated dynamically.

2. **Define Initial States**:
	- Assign default values to variables in the starting state node.

### **3. Configure Transitions**
1. **Label Conditions**:
	- On transition arrows, add labels specifying conditions or triggers for transitions.
	- Example: `Affinity > 0 → Proceed`.

2. **Set Dynamic Changes**:
	- Indicate variable mutations or state changes directly on the transition label, e.g.:
		- `Affinity += 1`
		- `Trust = true`

### **4. Use Arrange → Explore to Test**
1. **Enable Explore Mode**:
	- Go to **Arrange → Explore** in the Draw.io menu bar.
	- This feature simulates state transitions and triggers interactive exploration.
2. **Interact with Nodes**:
	- Click on states and transitions to simulate changes.
	- Observe how variables update dynamically.

### **5. Add Custom Interaction**
1. **Waypoint Shapes**:
	- Add **waypoint shapes** to indicate branching paths or conditions.
	- Example: A waypoint could represent a decision like `If Affinity > 5, go to Node B`.
	- Waypoints can simplify complex trees by consolidating multiple conditions in a single step.

2. **Probability or Risk Diagrams** (Optional):
	- For complex decision-making, integrate **probability risk diagrams** to visualize outcomes based on variable states.

---

## **Testing the Mini Tree**
### **Example Setup**
1. **Tree Structure**:
	- Create nodes: `Start`, `State A`, `State B`, `End`.
	- Connect nodes with arrows labeled with conditions (e.g., `Affinity > 0 → State A`).

2. **Variable Assignment**:
	- `Start` Node:
		```json
		{
			"affinity": 0,
			"trust": "false"
		}
		```
	- `State A` Node:
		```json
		{
			"affinity": "+1",
			"trust": "true"
		}
		```

3. **Conditional Transitions**:
	- `Start → State A`: `Affinity > 0`.
	- `State A → End`: `Trust = true`.

4. **Simulate Transitions**:
	- Use **Arrange → Explore** to test transitions.
	- Click on `Start`, observe variable updates, and follow conditions to reach `End`.

---

## **Notes**
1. **Implementation Choices**:
	- The **UML State Diagram** is ideal for representing tree-like state machines due to its clear distinction between states and transitions.
	- Variables as **custom properties** allow for real-time interaction without external scripting.

2. **Technical Advantages**:
	- **Interactive Testing**: The **Explore** feature eliminates the need for external simulators.
	- **Extensibility**: Variables can support more advanced logic (e.g., weighted transitions, event-based triggers).

3. **Potential Risks**:
	- Overcomplicated trees with excessive variables may become difficult to manage.
	- Dependency on Draw.io's real-time features; limited extensibility for complex simulations.

---

## **Recommendations**
1. **Keep It Simple**:
	- Start with a small tree to validate the logic before scaling up.
	- Use clear labels and minimal conditions to avoid confusion.

2. **Document Variables**:
	- Maintain a separate document listing all variables, their possible states, and their transitions for clarity.

3. **Test Iteratively**:
	- Regularly use **Arrange → Explore** to ensure all transitions function as expected.

---

## **Conclusion**
By leveraging **Draw.io's** interactive features and state diagram capabilities, you can create and test a mini tree state machine efficiently. The **Arrange → Explore** feature allows real-time testing and validation, making it a powerful tool for prototyping branching narratives or decision trees.

# IMPLEMENTING SCHOOL YEAR BEGINS: RECOGNITION AS A STATE MACHINE IN DRAW.IO

## **Implementation Details**
- **Credit**: iDkP from GaragePixel  
- **Date**: 2025-04-12  
- **Aida Version**: 4.2.1  

---

## **Purpose**
This document provides step-by-step instructions to build the **"School Year Begins: Recognition"** section as a **state machine** in **Draw.io**, integrating variables and transitions for interactive testing.

---

## **List of Functionality**
1. **State Representation**:
	- Each major node (e.g., First Day Sequence, Classroom Dynamics, etc.) is a **state**.
	- Subnodes (e.g., "Recognize Katsuo despite girl disguise") are represented as **nested states** or **waypoints**.

2. **Transitions**:
	- Directed arrows represent **state transitions**.
	- Transitions are conditional, based on **variables** like `Affinity`, `Trust`, and `sexualContentEnabled`.

3. **Variable Management**:
	- Variables (`Affinity`, `Trust`, etc.) are stored as **custom properties** for each state.
	- Transitions update these variables dynamically.

4. **Testing via Arrange → Explore**:
	- Use **Arrange → Explore** to simulate transitions and validate state logic.

---

## **Steps to Implement**

### **1. Create the State Diagram**
1. **Open Draw.io**:
	- Launch the application or use the web version.
2. **Add Major States**:
	- Use **UML State Diagram Shapes** to represent states:
		- `First Day Sequence`
		- `Revengeful Girls Introduction`
		- `Classroom Dynamics`
		- `Swimming Class Locker Room`
		- `Stalker Arc`
3. **Add Substates**:
	- Nest substates within their respective parent states:
		- Example: Inside `First Day Sequence`, add substates:
			- `Recognize Katsuo despite girl disguise`
			- `Observe "Kazuko" in the Revengeful Girls`

### **2. Define Variables**
1. **Add Metadata to States**:
	- For each state, right-click and select **Edit Data**.
	- Add variables as JSON:
		```json
		{
			"Affinity": 0,
			"Trust": false,
			"sexualContentEnabled": false
		}
		```
2. **Set Initial Values**:
	- Define default variable values in the **Starting State** (e.g., `First Day Sequence`).

### **3. Configure Transitions**
1. **Label Arrows with Conditions**:
	- Add labels to arrows indicating transition conditions, e.g.:
		- `Affinity > 0`
		- `Trust = true`
2. **Dynamic Variable Updates**:
	- Indicate variable changes on transitions, e.g.:
		- `Affinity += 1`
		- `Trust = true`

### **4. Use Waypoints for Complex Logic**
1. **Add Waypoints**:
	- Use **waypoint shapes** for branching decisions:
		- Example: `If Affinity > 5, go to Revengeful Girls Introduction`.
2. **Consolidate Conditions**:
	- Waypoints simplify decision trees by grouping conditions.

### **5. Simulate with Arrange → Explore**
1. **Enable Explore Mode**:
	- Go to **Arrange → Explore** in Draw.io.
2. **Simulate Transitions**:
	- Click states and transitions to test logic.
	- Verify variable updates dynamically.

---

## **Example Implementation**

### **State Diagram**
1. **Major States**:
	- `First Day Sequence`
	- `Revengeful Girls Introduction`
	- `Classroom Dynamics`
	- `Swimming Class Locker Room`
	- `Stalker Arc`
2. **Initial Variables**:
	- `Affinity = 0`
	- `Trust = false`
	- `sexualContentEnabled = false`

### **Transition Logic**
1. **First Day Sequence**:
	- `Recognize Katsuo despite girl disguise`:
		- Transition: `Pretend not to notice → Affinity +1`
2. **Revengeful Girls Introduction**:
	- `Hallway Incident Observation`:
		- Transition: `Witness punishment scene → Justice perspective`
3. **Classroom Dynamics**:
	- `Sequence #1 - Interaction with Kazuko`:
		- Transition: `Laboratory partnership → Proximity test`

---

## **Notes**
1. **Implementation Choices**:
	- **UML State Diagram** is used for clarity in representing states and transitions.
	- Variables are stored as **custom properties** to allow dynamic updates.

2. **Technical Advantages**:
	- **Interactive Testing**: Use **Arrange → Explore** to validate transitions.
	- **Dynamic Logic**: Variable-based transitions add depth to the state machine.

3. **Potential Risks**:
	- Over-complicated trees with excessive variables may confuse players.
	- Dependency on Draw.io’s interactive capabilities limits extensibility.

---

## **Recommendations**
1. **Simplify Initial Setup**:
	- Start with a small subset of the tree to validate logic before implementing the full structure.
2. **Document Variables**:
	- Maintain a reference document for all variables and their possible states.
3. **Iterative Testing**:
	- Regularly test transitions and variable updates during implementation.

---

## **Conclusion**
By leveraging **Draw.io’s interactive state diagrams**, the **School Year Begins: Recognition** tree can be implemented as a functional state machine. This setup ensures clarity, replayability, and dynamic interactivity for players.

# IMPLEMENTING SCHOOL YEAR BEGINS: RECOGNITION AS A STATE MACHINE IN DRAW.IO

## **Implementation Details**
- **Credit**: iDkP from GaragePixel  
- **Date**: 2025-04-12  
- **Aida Version**: 4.2.1  

---

## **Purpose**
This document explains how to configure the **"School Year Begins: Recognition"** tree from the narrative file `final_structure` as a functional **state machine** in **Draw.io**. The goal is to enable interactivity for testing transitions, variable updates, and conditions.

---

## **List of Functionality**
1. **State Representation**:
	- Each major section (e.g., `First Day Sequence`, `Revengeful Girls Introduction`, `Classroom Dynamics`) is represented as a **state**.
	- Subsections (e.g., `Recognize Katsuo`, `Hallway Incident Observation`) are represented as **nested states** or **waypoints**.

2. **Transitions**:
	- Directed arrows represent **state transitions**.
	- Conditions like `Affinity > 5` or `Trust = True` are defined on transitions.

3. **Variable Management**:
	- Variables (`Affinity`, `Trust`, etc.) are attached to states as **custom properties**.
	- These variables are dynamically updated during transitions.

4. **Testing**:
	- Use **Arrange → Explore** in Draw.io to simulate transitions and test the tree logic.

---

## **Steps to Implement**

### **1. Create the State Diagram**
1. **Open Draw.io**:
	- Use the desktop or web version of Draw.io.
2. **Add Major States**:
	- Use **UML State Diagram Shapes** to add states for:
		- `First Day Sequence`
		- `Revengeful Girls Introduction`
		- `Classroom Dynamics`
		- `Swimming Class Locker Room`
		- `Stalker Arc`
3. **Add Substates**:
	- Nest substates within their parent states. For example:
		- Inside `First Day Sequence`:
			- `Recognize Katsuo despite girl disguise`
			- `Observe "Kazuko" in the Revengeful Girls`
		- Inside `Revengeful Girls Introduction`:
			- `Hallway Incident Observation`
			- `Response Options`
			- `Gang Structure Analysis`

---

### **2. Add Variables**
1. **Attach Metadata**:
	- Right-click a state and select **Edit Data**.
	- Add variables as JSON. For example:
		```json
		{
			"Affinity": 0,
			"Trust": false,
			"sexualContentEnabled": false,
			"violentContentEnabled": false
		}
		```
2. **Define Initial States**:
	- Set default values for variables in the starting state (`First Day Sequence`).

---

### **3. Configure Transitions**
1. **Label Transitions**:
	- Connect states with arrows.
	- Add labels to arrows to define conditions or actions. For example:
		- `Pretend not to notice → Affinity +1`
		- `Affinity > 5 → Proceed`
		- `Trust = True → Unlock Sequence #4`
2. **Dynamic Updates**:
	- Indicate variable changes on transitions. For example:
		- `Affinity += 1`
		- `Trust = True`

---

### **4. Use Waypoints for Complex Logic**
1. **Add Waypoints**:
	- Insert **waypoint shapes** for branches with multiple conditions.
		- Example: A waypoint after `Recognize Katsuo despite girl disguise` could branch to:
			- `Pretend not to notice → Affinity +1`
			- `Stare in shock → No change`
2. **Simplify Complex Branches**:
	- Use waypoints to consolidate conditions for readability.

---

### **5. Test with Arrange → Explore**
1. **Enable Explore Mode**:
	- Go to **Arrange → Explore** in Draw.io.
2. **Simulate Transitions**:
	- Click states and transitions to test dynamic behavior.
	- Observe how variables update and conditions are evaluated.

---

## **Example for "First Day Sequence"**
1. **State Setup**:
	- Parent State: `First Day Sequence`
	- Substates:
		- `Recognize Katsuo despite girl disguise`
		- `Observe "Kazuko" in the Revengeful Girls`
2. **Variable Setup**:
	- `Affinity = 0`
	- `Trust = false`
3. **Transitions**:
	- `Pretend not to notice → Affinity +1`
	- `Stare in shock → No change`
	- `Notice waka poetry speech → Unlock Revengeful Girls Introduction`

---

## **Notes**
1. **Implementation Choices**:
	- **UML State Diagrams** are ideal for representing the branching narrative structure.
	- Variables stored as **custom properties** allow for dynamic updates.

2. **Technical Advantages**:
	- The **Arrange → Explore** feature in Draw.io provides real-time testing of transitions and conditions.
	- Interactive diagrams help visualize narrative flow and debug logic.

3. **Potential Challenges**:
	- Complex trees with numerous variables may become difficult to manage without documentation.
	- Dependency on Draw.io's interactive capabilities limits extensibility for advanced simulations.

---

## **Recommendations**
1. **Start Small**:
	- Begin with a simple section (e.g., `First Day Sequence`) to validate the setup.
2. **Document Variables**:
	- Maintain a reference list of all variables, their possible values, and transitions.
3. **Iterative Testing**:
	- Regularly test the diagram as you add states and transitions.

---

## **Conclusion**
By following this guide, the **"School Year Begins: Recognition"** tree can be implemented as a fully interactive state machine in **Draw.io**. This setup allows for dynamic testing of transitions, variable updates, and narrative logic.

Here’s a **step-by-step guide** for creating a **state machine diagram** in **Draw.io** for the **1. PROLOGUE: SUMMER ENCOUNTER [July-August 1996]** from the `final_structure` file:

---

### **Step 1: Open Draw.io**
1. Go to [Draw.io](https://app.diagrams.net/) or open the desktop application.
2. Start a new blank diagram.

---

### **Step 2: Select UML State Diagram Shapes**
1. From the left-hand panel, click on **+More Shapes** (if UML shapes are not already visible).
2. Enable **UML** shapes:
   - Scroll down to **UML**.
   - Check the box next to it.
   - Click **Apply**.
3. You’ll now see **UML State Diagram** shapes in the left-hand toolbar.

---

### **Step 3: Create the Major States**
1. Drag and drop **State** shapes for each **major state** in the prologue:
   - `Summer Festival`
   - `Shrine Encounter`
   - `Yokai Interaction`
   - `End of Prologue`
2. Arrange them horizontally or vertically for clarity.

---

### **Step 4: Add Substates**
1. For each major state, create **nested substates** to represent specific events. For example:
   - **Summer Festival**:
     - `Arrive at Festival Grounds`
     - `Firework Display`
     - `Mysterious Figure Appears`
   - **Shrine Encounter**:
     - `Discover Shrine`
     - `Meet Yokai`
   - **Yokai Interaction**:
     - `Build Trust`
     - `Gain Insight`
2. Drag and drop smaller **State** shapes inside the major states to represent these substates.

---

### **Step 5: Connect States with Transitions**
1. Use the **Connector** tool (or drag arrows) to link the states and substates.
   - Example:
     - From `Summer Festival` to `Shrine Encounter`, draw an arrow.
     - From `Shrine Encounter` to `Yokai Interaction`, draw another arrow.
2. Label the transitions:
   - Add text to the arrows to define **conditions** or **actions** required for the transition.
   - Example Labels:
     - `Curiosity > 2 → Follow the figure`
     - `Trust > 0 → Proceed confidently`

---

### **Step 6: Define Transition Logic**
1. For key transitions, define the **conditions** that determine the path. Use labels like:
   - `Follow the figure → Leads to Shrine Encounter`
   - `Respond with curiosity → Trust +1`
   - `Respond with fear → Trust -1`
2. Use **diamonds** (decision nodes) for branching logic:
   - Example: After `Meet Yokai`:
     - `Trust > 2 → Positive Ending`
     - `Trust = 1 → Neutral Ending`
     - `Trust = 0 → Negative Ending`

---

### **Step 7: Add Variables**
1. **Attach Metadata**:
   - Right-click a state and select **Edit Data**.
   - Add variables as JSON. Example for `Summer Festival`:
     ```json
     {
       "Trust": 0,
       "Curiosity": 0,
       "EncounterOutcome": "Neutral"
     }
     ```
   - This allows you to track variable states dynamically.
2. **Set Initial Values**:
   - Define default values for variables in the starting state (`Summer Festival`).

---

### **Step 8: Add Waypoints for Complex Logic**
1. Use **waypoint shapes** to organize complex transitions.
   - Example: After `Mysterious Figure Appears`, branch to:
     - `Shrine Encounter` (if `Curiosity > 2`)
     - `End of Prologue` (if `Curiosity <= 2`)
2. Simplify the diagram by consolidating multiple conditions at a single waypoint.

---

### **Step 9: Test the Diagram**
1. Use **Arrange → Explore** in the Draw.io toolbar.
2. Simulate transitions by tracing paths between states and evaluating conditions.
3. Verify variable updates and transition logic.

---

### **Step 10: Save and Export**
1. Save your diagram as a `.drawio` file for future edits.
2. Export the diagram to **PNG** or **SVG** for sharing or embedding in documentation.

---

### **Example Diagram Layout**
Here’s an example layout for the **Prologue**:

1. **Summer Festival**:
   - Substates:
     - `Arrive at Festival Grounds`
     - `Firework Display`
     - `Mysterious Figure Appears`
   - Transitions:
     - `Firework Display → Mysterious Figure Appears`: `Curiosity += 1`
     - `Mysterious Figure Appears → Shrine Encounter`: `Curiosity > 2`

2. **Shrine Encounter**:
   - Substates:
     - `Discover Shrine`
     - `Meet Yokai`
   - Transitions:
     - `Discover Shrine → Meet Yokai`: No condition.
     - `Meet Yokai → Yokai Interaction`: `Trust += 1`

3. **Yokai Interaction**:
   - Substates:
     - `Build Trust`
     - `Gain Insight`
   - Transitions:
     - `Build Trust → Gain Insight`: No condition.
     - `Gain Insight → End of Prologue`: Variable-based outcomes.

4. **End of Prologue**:
   - Outcomes based on variables:
     - `Trust > 2 && Curiosity > 2 → Positive Outcome`
     - `Trust = 1 || Curiosity = 1 → Neutral Outcome`
     - `Trust < 1 || Curiosity < 1 → Negative Outcome`

---

### **Conclusion**
By following these steps, you can create an interactive state machine diagram for the **1. PROLOGUE: SUMMER ENCOUNTER [July-August 1996]**. This structure allows for testing transitions, logic, and variable updates. Let me know if you'd like more detailed examples!
