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
