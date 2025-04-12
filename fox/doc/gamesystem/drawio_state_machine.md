# IMPLEMENTING A MINI TREE STATE MACHINE IN DRAW.IO

## **Implementation Details**
- **Credit**: iDkP from GaragePixel  
- **Date**: 2025-04-12  
- **Aida Version**: 4.2.1  

---

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
