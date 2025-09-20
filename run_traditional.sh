#!/bin/bash
set -euo pipefail
javac HelloWorld.java

# Warmup
for i in {1..5}; do java HelloWorld >/dev/null; done

# 50 timed runs -> collect seconds with us precision
runs=50
out=()
for i in $(seq 1 $runs); do
  start=$(python3 - <<'PY'
import time; print(time.perf_counter())
PY
)
  java HelloWorld >/dev/null
  end=$(python3 - <<'PY'
import time; print(time.perf_counter())
PY
)
  awk "BEGIN {print ($end - $start) * 1000}"
done | sort -n > jvm_times.txt

median=$(awk ' {a[NR]=$1} END{print a[int((NR+1)/2)]} ' jvm_times.txt)
echo "JVM median ms: $median"
