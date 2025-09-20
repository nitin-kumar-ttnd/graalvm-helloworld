#!/bin/bash

echo "=========================================="
echo "  Comprehensive Startup Time Comparison"
echo "=========================================="
echo ""

# Function to measure startup time
measure_startup() {
    local cmd="$1"
    local name="$2"
    
    echo "Testing $name..." >&2
    
    # Warm up run (discard result)
    eval "$cmd" > /dev/null 2>&1
    
    # Measure multiple runs for better accuracy
    local total_time=0
    local runs=3
    
    for i in $(seq 1 $runs); do
        start_time=$(python3 -c "import time; print(int(time.time() * 1000))")
        eval "$cmd" > /dev/null 2>&1
        end_time=$(python3 -c "import time; print(int(time.time() * 1000))")
        run_time=$((end_time - start_time))
        total_time=$((total_time + run_time))
    done
    
    local avg_time=$((total_time / runs))
    echo "Average startup time: ${avg_time}ms" >&2
    echo "" >&2
    
    echo $avg_time
}

echo "=== Test 1: Minimal Hello World ==="
echo "Compiling minimal version..."
javac HelloWorldMinimal.java
native-image HelloWorldMinimal minimal > /dev/null 2>&1

minimal_java=$(measure_startup "java HelloWorldMinimal" "Minimal Java")
minimal_native=$(measure_startup "./minimal" "Minimal Native")

echo "=== Test 2: Standard Hello World ==="
echo "Compiling standard version..."
javac HelloWorld.java
native-image HelloWorld standard > /dev/null 2>&1

standard_java=$(measure_startup "java HelloWorld" "Standard Java")
standard_native=$(measure_startup "./standard" "Standard Native")

echo "=== Test 3: Hello World with Dependencies ==="
echo "Compiling version with dependencies..."
javac HelloWorldWithDeps.java
native-image HelloWorldWithDeps withdeps > /dev/null 2>&1

deps_java=$(measure_startup "java HelloWorldWithDeps" "Java with Dependencies")
deps_native=$(measure_startup "./withdeps" "Native with Dependencies")

echo "=========================================="
echo "           COMPREHENSIVE RESULTS"
echo "=========================================="
echo ""
echo "Minimal Hello World:"
echo "  Java:  ${minimal_java}ms"
echo "  Native: ${minimal_native}ms"
echo "  Improvement: $(( (minimal_java - minimal_native) * 100 / minimal_java ))%"
echo ""
echo "Standard Hello World:"
echo "  Java:  ${standard_java}ms"
echo "  Native: ${standard_native}ms"
echo "  Improvement: $(( (standard_java - standard_native) * 100 / standard_java ))%"
echo ""
echo "With Dependencies:"
echo "  Java:  ${deps_java}ms"
echo "  Native: ${deps_native}ms"
echo "  Improvement: $(( (deps_java - deps_native) * 100 / deps_java ))%"
echo ""
echo "File sizes:"
echo "  Minimal .class:     $(ls -lh HelloWorldMinimal.class | awk '{print $5}')"
echo "  Minimal native:     $(ls -lh minimal | awk '{print $5}')"
echo "  Standard .class:    $(ls -lh HelloWorld.class | awk '{print $5}')"
echo "  Standard native:    $(ls -lh standard | awk '{print $5}')"
echo "  WithDeps .class:    $(ls -lh HelloWorldWithDeps.class | awk '{print $5}')"
echo "  WithDeps native:    $(ls -lh withdeps | awk '{print $5}')"
echo ""
echo "=========================================="
