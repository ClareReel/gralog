# GrALoG Ford-Fulkerson Maximum Flow Plugin

A plugin for [GrALoG](https://github.com/gralog/gralog) that provides interactive visualization of the Ford-Fulkerson maximum flow algorithm.

## Current Status: Phase 1 Complete ✅

**What's Working:**
- ✅ Flow Network structure with directed edges
- ✅ Edge capacity and flow properties
- ✅ Source and sink vertex designation
- ✅ Visual feedback with color-coded edges
- ✅ Flow validation (conservation and capacity constraints)
- ✅ Inspector integration for property editing

**Coming in Phase 2:**
- ⏳ Ford-Fulkerson algorithm implementation
- ⏳ Automatic flow computation
- ⏳ Augmenting path finding (BFS/DFS)
- ⏳ Step-by-step visualization
- ⏳ Animation controls

## Quick Start

### Running the Plugin

**Option 1: Use the Launcher Script (Easiest)**

From Git Bash or MSYS:
```bash
cd c:/Projects/git-repos/gralog
./run-gralog-with-plugin.sh
```

From Windows Command Prompt:
```cmd
cd c:\Projects\git-repos\gralog
run-gralog-with-plugin.bat
```

**Option 2: Manual Java Command**

```bash
cd c:/Projects/git-repos/gralog/gralog
java -cp "gralog-fx/build/libs/gralog-fx.jar;../gralog-fordfulkerson-plugin/build/libs/gralog-fordfulkerson-plugin-1.0.0.jar" gralog.gralogfx.MainWindow
```

### Using the Plugin in GrALoG

1. **Create a Flow Network**
   - File → New
   - Select "Flow Network" from the dropdown
   - Click OK

2. **Build Your Network**
   - Click on canvas to add vertices
   - Drag between vertices to create directed edges
   - Right-click vertices to set as source (s) or sink (t)

3. **Set Capacities**
   - Select an edge
   - In the Inspector panel, set the `capacity` value
   - Edge label shows "flow/capacity" (e.g., "0/10")

4. **Visual Feedback**
   - Source vertices: Light green with dark green border
   - Sink vertices: Light red with dark red border
   - Edges with no flow: Black
   - Edges with partial flow: Dark gray
   - Saturated edges (flow = capacity): Blue

## Building

```bash
cd gralog-fordfulkerson-plugin
bash gradlew clean build
```

The plugin JAR will be created at:
```
build/libs/gralog-fordfulkerson-plugin-1.0.0.jar
```

## Project Structure

```
gralog-fordfulkerson-plugin/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── gralog/fordfulkerson/
│   │   │       ├── FordFulkersonPlugin.java       # Plugin entry point
│   │   │       └── structure/
│   │   │           ├── FlowVertex.java            # Network vertex
│   │   │           ├── FlowEdge.java              # Edge with capacity/flow
│   │   │           ├── FlowNetwork.java           # Main structure
│   │   │           └── FlowNetworkRenderer.java   # Visualization
│   │   └── resources/
│   │       └── META-INF/services/
│   │           └── gralog.plugins.Plugin          # Service registration
│   └── test/
│       └── java/
│           └── gralog/fordfulkerson/
│               └── FlowNetworkTest.java           # Unit tests
├── build.gradle                                    # Build configuration
├── settings.gradle
├── README.md                                       # This file
└── RUNNING.md                                      # Detailed running instructions
```

## API Overview

### FlowNetwork

```java
FlowNetwork network = new FlowNetwork();

// Add vertices
FlowVertex source = network.addVertex();
FlowVertex sink = network.addVertex();

// Designate source and sink
network.setSource(source);  // Auto-labels as "s"
network.setSink(sink);      // Auto-labels as "t"

// Add edge
FlowEdge edge = network.addEdge(source, sink);
edge.setCapacity(10.0);
edge.setFlow(5.0);

// Query edge state
edge.getResidualCapacity();     // Returns 5.0
edge.hasResidualCapacity();     // Returns true
edge.getFlowLabel();            // Returns "5/10"

// Network-wide operations
network.getTotalFlow();                 // Total flow from source
network.validateFlowConservation();     // Check flow conservation
network.validateCapacityConstraints();  // Check capacity limits
network.resetFlows();                   // Reset all flows to 0
```

### FlowEdge Properties

- `capacity` (Double) - Maximum flow the edge can carry
- `flow` (Double) - Current flow on the edge
- Automatically enforces: `0 ≤ flow ≤ capacity`
- Always directed (cannot be undirected)

### Validation

**Flow Conservation:**
For each vertex v (except source and sink):
```
Σ(incoming flows) = Σ(outgoing flows)
```

**Capacity Constraint:**
For each edge e:
```
0 ≤ flow(e) ≤ capacity(e)
```

## Development

### Requirements
- Java 11 or later
- Gradle (wrapper included)
- GrALoG core library

### Testing
```bash
bash gradlew test
```

### Building JAR
```bash
bash gradlew jar
```

## Implementation Phases

### ✅ Phase 1: Core Structure (COMPLETE)
- Basic flow network data structure
- Visual rendering with color coding
- Source/sink designation
- Property editing via Inspector

### ⏳ Phase 2: Algorithm Core (NEXT)
- ResidualGraph class
- AugmentingPathFinder (BFS/DFS)
- FordFulkersonAlgorithm implementation
- AlgorithmState tracking

### ⏳ Phase 3: Step-by-Step Visualization
- Discrete algorithm steps
- Animation controls
- Statistics panel
- Path highlighting

### ⏳ Phase 4: Advanced Features
- Residual graph toggle
- Min-cut visualization
- Path history
- Settings dialog

### ⏳ Phase 5: Polish & Testing
- Comprehensive test suite
- Performance optimization
- Documentation
- Example networks

## Documentation

- [RUNNING.md](RUNNING.md) - Detailed instructions for running the plugin
- [../docs/commit-logs/phase01.md](../docs/commit-logs/phase01.md) - Phase 1 completion log
- [../docs/GrALoG_FordFulkerson_Plugin_Design-2nd-run.md](../docs/GrALoG_FordFulkerson_Plugin_Design-2nd-run.md) - Complete design document

## License

This plugin follows GrALoG's licensing.
GrALoG is licensed under GPL version 3 or later.

## References

- [GrALoG GitHub Repository](https://github.com/gralog/gralog)
- [Ford-Fulkerson Algorithm (Wikipedia)](https://en.wikipedia.org/wiki/Ford%E2%80%93Fulkerson_algorithm)
- [Maximum Flow Problem](https://en.wikipedia.org/wiki/Maximum_flow_problem)

## Authors

Developed as part of the GrALoG plugin ecosystem.

---

**Version:** 1.0.0 (Phase 1)
**Last Updated:** December 1, 2025
