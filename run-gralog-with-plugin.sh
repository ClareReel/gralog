#!/bin/bash

# Run GrALoG with Ford-Fulkerson Plugin
# This script launches GrALoG with the Ford-Fulkerson plugin loaded

echo "=== GrALoG Ford-Fulkerson Plugin Launcher ==="
echo ""

# Navigate to the plugin directory and build
echo "Building plugin..."
cd gralog-fordfulkerson-plugin
bash gradlew build -x test
if [ $? -ne 0 ]; then
    echo "ERROR: Plugin build failed!"
    exit 1
fi
echo "✓ Plugin built successfully"
echo ""

# Navigate back to gralog directory
cd ../gralog

# Check if gralog dist is built
if [ ! -f "build/dist/gralog-fx.jar" ]; then
    echo "GrALoG distribution not built. Building now..."
    bash gradlew assemble
    if [ $? -ne 0 ]; then
        echo "ERROR: GrALoG build failed!"
        exit 1
    fi
    echo "✓ GrALoG built successfully"
fi
echo ""

# Copy plugin to libs directory
echo "Copying plugin to GrALoG libs directory..."
cp -f "../gralog-fordfulkerson-plugin/build/libs/gralog-fordfulkerson-plugin-1.0.0.jar" "build/dist/libs/"
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to copy plugin JAR!"
    exit 1
fi
echo "✓ Plugin copied successfully"
echo ""

# Add plugin to config.xml if not already there
if grep -q "gralog-fordfulkerson-plugin" "build/dist/config.xml"; then
    echo "✓ Plugin already in config"
else
    echo "Adding plugin to config.xml..."
    sed -i 's|</gralog>|  <plugin location="libs/gralog-fordfulkerson-plugin-1.0.0.jar" />\n</gralog>|' "build/dist/config.xml"
    echo "✓ Plugin added to config"
fi
echo ""

echo "Launching GrALoG with Ford-Fulkerson plugin..."
echo "Working directory: build/dist"
echo ""
echo "Once GrALoG opens:"
echo "  1. Go to File → New"
echo "  2. Select 'Flow Network' from the structure dropdown"
echo "  3. Start creating your flow network!"
echo ""

# Navigate to dist directory and run
cd build/dist
java -jar gralog-fx.jar

echo ""
echo "GrALoG closed."
