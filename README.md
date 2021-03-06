# brick-doc - Documentation for Brick

## Stack

<!-- intro: the three levels (rdf, class, instance), rdf: everything is an entities, classes, instances and properties -->
Brick operates on three levels. At the **RDF level** everything is an *entity*. Triples of entities -- in the roles of subject, predicate and object -- make up statements. These are at the **Brick level** used to construct classes and relationships (called *properties*). At the **Model level** instances of classes are constructed and connected using the relationships defined at the Brick level. While the RDF level is defined in a triple store, both the Brick and Model level should be seen as graphs with classes and instances (depending on whether it is the Brick or Model level) as nodes and properties as named edges.

<!--TODO: Namespaces-->

![Stack Overview](figs/stack.png)

Dependency namespaces:
- [RDF](https://www.w3.org/TR/rdf-syntax/) Declared, but not used below the model layer. Used for creating class instances in the model.
- [OWL](https://www.w3.org/TR/owl-ref/) Used for classes, properties and property modifiers
- [RDFS](https://www.w3.org/TR/rdf-schema/) Used for extended class and property information (subtyping, range and domain).
- [SKOS](https://www.w3.org/2009/08/skos-reference/skos.html) Used for annotating entities with human readable definitions
- [XML](https://www.w3.org/XML/1998/namespace) Declared, but not used below the model layer.
- [XSD](https://www.w3.org/TR/xmlschema-2/) Declared, but not used below the model layer.

Brick namespaces:
- **Brick** Classes (aka Tagsets). These are the types.
- **BrickTag** Essentially a list of tags.
- **BrickFrame** The properties.

Extensions are supposed to go into separate namespaces. So are all building instances.

## Concepts

### Relations

- *usedBy* ?
- *usesMeasurement* ?
- *usesPoint* ?
- *usesTag* Used for associating a tagset with a tag.
- *equivalentTagset* ?
- *usesEquipment* ?
- *hasLocation* Physical encapsulation.
- *isPartOf* Logical encapsulation.
- *hasPoint* Has (in the logical sense) a relevant timeseries.
- *feeds* A flow of matter (electrons excepted).

**Note:** Was *controls* not supposed to be defined in **BrickFrame**?

### Tagsets

A class is defined as a subclass of one or more classes, with `owl:Class` as the base case. On the RDF level, this is a directed graph of *subClassOf* relations. Each node in this graph is a class entity and may have tags attached using the *usesTag* relation. To extract the mapping from tagset to tags one thus have to do:

```sparql
SELECT DISTINCT ?tagset ?tag
WHERE {
    ?tagset rdfs:subClassOf*/bf:usesTag ?tag .
}
```

This subclassing graph allows us a gradual way of dealing with uncertainty. The more we know about something in a building, the more precisely we can describe it when we create the model. Applications should query using generic types. If the building has the required components and its model is specific enough then the application will find a match.

### Flows

Flows of any form of matter (electrons excepted) is represented as an acyclic distribution graph (usually a tree rooted in some source). Edges between distribution nodes take the form of *feeds* relations and edges from a distribution node to a terminal node take the form of *isPointOf*.

### Loops

<!--intro: loops are modeled as sequences, equipment granularity, attached details, the sequence originates in whichevery part of the loop produces the transferred quality, the sequence ends in whichever part of the loop consumes the quality, applications are expected to understand the involved components well enough to deduce the loopieness -->
Loops are modeled as sequences at equipment granularity. Equipment details are attached to this stem through typed entities. The sequence begins at whichever part of the loop produces the transferred quality and ends at the part which consumes it. Applications are expected to understand the involved equipment well enough to deduce the involved loop and and relevant equipment details based on types.

## Aspects

### HVAC

<!--intro: highlevel hvac is an example of a complex loop being represented as a sequence, figure shows physical system along with the main components of the Brick graph, equipment details illustrated as red annotations to the stem -->
The main hvac setup is an example of a complex loop being represented as a sequence. The following illustration shows a physical system -- consisting of one AHU, one VAV, one HVAC zone and one room -- along with a corresponding partial Brick representation. Equipment details (such as sensors) are hinted in red.

![Highlevel HVAC structure](figs/hvac.png)

#### AHU - Air Handler Unit

The AHU has five distinct bodies of air, namely:

1. **Outside Air** The fresh air being pulled into the AHU.
2. **Mixed Air** The mixture of outside and return air before any conditioning has been applied in the primary flow.
3. **Supply Air** The conditioned air being sent to the VAVs.
4. **Return Air** The "spent" air returning from the VAVs.
5. **Exhaust Air** The "spent" air being removed from the building.

They are highlighted in the following overview:

![AHU Overview](figs/ahu.png)

All point relating to a AHU are connected as objects to the AHU instance using the *hasPoint* relation to an object of a type prefixed by `AHU_`. Most AHU point types has names indicated which body they belong to. That is `_Outside_Air_`, `_Mixed_Air_`, `_Supply_Air_`, `_Return_Air_` and `_Exhaust_Air_`. **Example:** Any instance of `AHU_Exhaust_Air_Temperature_Sensor` is measuring the temperature of the exhaust air.

Open questions:
- Some point types refer to `_Discharge_Air_`, `_Fresh_Air_` and `_Bypass_Air_`. What are these?
- It is not clear which body the type prefix `AHU_Static_Pressure_` refers to.
- What is the role of the `_PreHeat_` types and does it fit into the above figure?
- Are the `_Heat_Wheel_` types referring to a rotary heat exchanger?
- What does the economizer do and how does it fit into the above figure?
- What does the VFD (variable frequency drive) do and how does it fit into the above figure?

<!-- sparsely populated example-->
A sparsely populated model of an AHU could look like this:

![AHU Example](figs/ahu_example.png)

#### VAV - Variable Air Volume

The VAV has a supply and a return side:

![VAV Overview](figs/vav.png)

All points relating to a VAV are connected as objects to the VAV instance using the *hasPoint* relation to an object of a type prefixed by `VAV_`. Points relating to the supply side furthermore is split into those originating before the VAV fan (having `_Supply_` in its type) and those originating after the fan (having `_Discharge_` in its type). For the return side these are called `_Return_` (before any fan) and `_Exhaust_` (after any fan). After the side designator is the generic point class and before it is an optional modifier.

**Example**: The `VAV_Occupied_Cooling_Min_Supply_Air_Flow_Setpoint` is:
- `VAV` relates to a VAV.
- `Occupied_Cooling_Min` is a modifier indicating that the type relates the minimum level when occupied and cooling.
- `Supply` indicates that the setpoint is relevant to the input side of the supply side.
- `Air_Flow_Setpoint` it the generic point class telling us that the point represent a setpoint for airflow.

<!-- sparsely populated example-->
A sparsely populated model of a VAV could look like this:

![VAV Example](figs/vav_example.png)

#### HVAC Zone

An HVAC zone may cover one or more rooms. It may have sensors attached using *hasPoint*.

#### Room

A room may have sensors attached using *hasPoint*. Sensors may be attached at room-level or at zone-level depending on how much is known about it. Queries will have to take this into account.

### Electricity

<!-- intro: electricity aspect shaped by meters being points, example (building with main meter, light meter, one light and one fan) -->
The electricity aspect is shaped around the meters being points of equipment and submeters. The distribution tree is constructed using *isPointOf* relations. The following is an example of the electricity aspect of a sample building containing a main meter (meter1), a lighting submeter (meter2), a fan and a light:

![Example subgraph showing the electricity aspect](figs/electricity.png)

**Note:** It is unclear how non-(meter|load) components like a fuses or photovoltaics fit into this format.

