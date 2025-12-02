# Running the Ford-Fulkerson Plugin

This guide explains how to run and test your Ford-Fulkerson plugin in GrALoG.

## Prerequisites

- Java 11 or later installed
- GrALoG core built successfully (already done)
- Plugin JAR built successfully (already done)

## Method 1: Use the Launcher Script (Recommended)

The easiest way is to use the provided launcher scripts:

**For Git Bash/MSYS:**
```bash
cd /c/Projects/git-repos/gralog
./run-gralog-with-plugin.sh
```

**For Windows Command Prompt:**
```cmd
cd c:\Projects\git-repos\gralog
run-gralog-with-plugin.bat
```

These scripts will automatically:
1. Build your plugin
2. Check if GrALoG is built (build if needed)
3. Copy the plugin JAR to GrALoG's libs directory
4. Add the plugin to config.xml (if not already there)
5. Launch GrALoG with all dependencies

## Method 2: Manual Copy and Run

### Step 1: Build the Plugin
```bash
cd c:\Projects\git-repos\gralog\gralog-fordfulkerson-plugin
bash gradlew clean build
```

### Step 2: Copy Plugin to GrALoG libs Directory
```bash
cp build/libs/gralog-fordfulkerson-plugin-1.0.0.jar ../gralog/build/dist/libs/
```

### Step 3: Add Plugin to config.xml
Edit `../gralog/build/dist/config.xml` and add this line before `</gralog>`:
```xml
<plugin location="libs/gralog-fordfulkerson-plugin-1.0.0.jar" />
```

The file should look like:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<gralog>
  <plugin location="libs/gralog-automaton.jar" />
  ...
  <plugin location="libs/gralog-fordfulkerson-plugin-1.0.0.jar" />
</gralog>
```

### Step 4: Run GrALoG
```bash
cd ../gralog/build/dist
java -jar gralog-fx.jar
```

**Important:** GrALoG loads plugins specified in `config.xml`, not all JARs from the `libs` directory automatically.

## Method 2: Use Gradle Run Task

### Option A: Run from GrALoG Main Directory
```bash
cd c:\Projects\git-repos\gralog\gralog
bash gradlew run
```

Note: This may not automatically include your plugin unless it's added to the main settings.gradle.

### Option B: Add Plugin to GrALoG Build

Edit `c:\Projects\git-repos\gralog\gralog\settings.gradle` and add:
```gradle
include 'gralog-fordfulkerson-plugin'
project(':gralog-fordfulkerson-plugin').projectDir = new File('../gralog-fordfulkerson-plugin')
```

Then rebuild:
```bash
cd c:\Projects\git-repos\gralog\gralog
bash gradlew clean build
bash gradlew run
```

## Method 3: Create a Launch Script

Create a file `run-with-plugin.sh` in `c:\Projects\git-repos\gralog\gralog\`:

```bash
#!/bin/bash

# Build plugin first
cd ../gralog-fordfulkerson-plugin
bash gradlew build
cd ../gralog

# Get all JAR files
CORE_JARS="gralog-core/build/libs/gralog-core.jar"
PLUGIN_JARS="gralog-automaton/build/libs/gralog-automaton.jar:gralog-fx/build/libs/gralog-fx.jar"
FORDFULKERSON_JAR="../gralog-fordfulkerson-plugin/build/libs/gralog-fordfulkerson-plugin-1.0.0.jar"

# Run GrALoG with all plugins
java -cp "$CORE_JARS:$PLUGIN_JARS:$FORDFULKERSON_JAR" gralog.gralogfx.MainWindow
```

Make it executable and run:
```bash
chmod +x run-with-plugin.sh
./run-with-plugin.sh
```

## Testing the Plugin

Once GrALoG launches:

### 1. Create a Flow Network
1. Go to **File → New**
2. Look for "Flow Network" in the structure types dropdown
3. Select "Flow Network" and click OK
4. You should see an empty canvas

### 2. Add Vertices
1. Click on the canvas to add vertices
2. Add at least 4 vertices (for a simple test network)

### 3. Designate Source and Sink
1. Right-click on the first vertex
2. Look for an option to "Set as Source" or edit properties
3. The vertex should turn light green with a green border and be labeled "s"
4. Right-click on the last vertex and set as sink
5. It should turn light red with a red border and be labeled "t"

### 4. Add Edges
1. Drag from one vertex to another to create directed edges
2. All edges should be directed (arrows)
3. Double-click an edge to edit its properties
4. You should see "capacity" and "flow" fields in the Inspector

### 5. Set Capacities
1. Select an edge
2. In the Inspector panel, set the capacity (e.g., 10)
3. The edge label should show "0/10" (flow/capacity)

### 6. Test Visualization
1. Set different flow values on edges
2. Edges with flow = 0 should be black
3. Edges with 0 < flow < capacity should be dark gray
4. Edges with flow = capacity should be blue (saturated)

### 7. Verify Validation Methods
In the console or through scripts, you can test:
- `network.validateFlowConservation()` - should return true for valid flows
- `network.validateCapacityConstraints()` - should return true
- `network.getTotalFlow()` - should show total flow from source

## Troubleshooting

### Plugin Not Showing Up
- **Issue:** "Flow Network" doesn't appear in structure types
- **Solution:** Make sure the plugin JAR is on the classpath
- **Check:** Look for `gralog.fordfulkerson.FordFulkersonPlugin` in console output

### Classpath Issues
- **Issue:** "ClassNotFoundException" or "NoClassDefFoundError"
- **Solution:** Verify the classpath separator (`:` on Unix/Mac, `;` on Windows)
- **Check:** Ensure gralog-core.jar is also on the classpath

### JavaFX Not Found
- **Issue:** "Error: JavaFX runtime components are missing"
- **Solution:**
  - For Java 11+, you may need to add JavaFX separately
  - Or use the gradlew run command which handles dependencies

### Builds Fail
- **Issue:** "Cannot find symbol" errors
- **Solution:** Make sure gralog-core is built first:
  ```bash
  cd c:\Projects\git-repos\gralog\gralog
  bash gradlew build
  ```

## Expected Behavior in Phase 1

✅ **What Works:**
- Creating Flow Network structures
- Adding/removing vertices and edges
- Setting edge capacities and flows manually
- Seeing visual feedback (colors) based on flow state
- Source/sink designation with auto-labeling
- Inspector showing capacity and flow properties

❌ **What Doesn't Work Yet (Phase 2+):**
- Running Ford-Fulkerson algorithm
- Automatic flow computation
- Finding augmenting paths
- Step-by-step visualization
- Animation controls

## Quick Test Commands

If you have access to GrALoG's console or scripting:

```java
// Create a simple test network
FlowNetwork net = new FlowNetwork();
FlowVertex s = net.addVertex();
FlowVertex v1 = net.addVertex();
FlowVertex v2 = net.addVertex();
FlowVertex t = net.addVertex();

net.setSource(s);
net.setSink(t);

FlowEdge e1 = net.addEdge(s, v1);
e1.setCapacity(10);
FlowEdge e2 = net.addEdge(s, v2);
e2.setCapacity(5);
FlowEdge e3 = net.addEdge(v1, t);
e3.setCapacity(10);
FlowEdge e4 = net.addEdge(v2, t);
e4.setCapacity(5);

// Manually set flows for testing
e1.setFlow(7);
e2.setFlow(5);
e3.setFlow(7);
e4.setFlow(5);

System.out.println("Total flow: " + net.getTotalFlow());  // Should print 12
System.out.println("Flow conservation valid: " + net.validateFlowConservation());  // Should print true
System.out.println("Capacity constraints valid: " + net.validateCapacityConstraints());  // Should print true
```

## Next Steps

After confirming the plugin works:
1. Test creating various network topologies
2. Verify the visual rendering (colors, labels)
3. Test edge cases (zero capacity, self-loops, etc.)
4. Prepare for Phase 2: Algorithm implementation

---

**Current Status:** Phase 1 Complete - Manual network creation and visualization working
**Next Phase:** Phase 2 - Ford-Fulkerson algorithm implementation
