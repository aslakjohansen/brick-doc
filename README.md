# brick-doc - Documentation for Brick

## Stack

<!-- intro: the three levels (rdf, class, instance), rdf: everything is an entities, classes, instances and properties -->
Brick operates on three levels. At the RDF level everything is an *entity*. Triples of entities in the roles of subject, predicate and object make up statements. These are at the Brick level used to construct classes and relationships (known as properties). At the Model level instances of classes are constructed and connected using the relationships defined at the Brick level. While the RDF level is a tripel store, both the Brick and Model level should be seen as graphs with classes and instances (depending on whether it is the Brick or Model level) as nodes and properties as named edges.

![Stack Overview](figs/stack.png)

Dependency namespaces:
- [RDF](https://www.w3.org/TR/rdf-syntax/) Declared, but not used below the model layer. Used for creating class instances in the model.
- [OWL](https://www.w3.org/TR/owl-ref/) Usd for classes, properties and property modifiers
- [RDFS](https://www.w3.org/TR/rdf-schema/) Used for extended class and property information (subtyping, range and domain).
- [SKOS](https://www.w3.org/2009/08/skos-reference/skos.html) Used for annotating entities with human readable definitions
- [XML](https://www.w3.org/XML/1998/namespace) Declared, but not used below the model layer.
- [XSD](https://www.w3.org/TR/xmlschema-2/) Declared, but not used below the model layer.

Brick namespaces:
- **Brick** Classes (aka Tagsets). These are the types.
- **BrickTag** Essentially a list of tags.
- **BrickFrame** The properties.

## Concepts

### Tagsets

A class can be defined as a subclass to another (or multiple) classes. On the RDF level, this is a directed graph of *subClassOf* relations. Each node is this graph is a class entity and may have tags attached using the *usesTag* relation. To extract the mapping from tagset to tags one thus have to do:

```sparql
SELECT DISTINCT ?tagset ?tag
WHERE {
    ?tagset rdfs:subClassOf*/bf:usesTag ?tag .
}
```

### Flows

Flows of any form of matter is represented as an asyclic distribution graph (usually a tree rooted in some source). Edges between distribution nodes take the form of *feeds* relations and edges from a distribution node to a terminal node take the form of *isPointOf*.

<!--correct?-->

### Loops

<!--intro: loops are modeled as sequences, the sequence originates in whichevery part of the loop produces the transferred quality, the sequence ends in whichever part of the loop consumes the quality, applications are expected to understand the involved components well enlugh to deduce the loopieness -->

## Aspects

### HVAC

### Electricity

