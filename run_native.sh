#!/bin/bash
set -euo pipefail

# Build lean native image
native-image --no-fallback -O3 -H:Name=helloworld HelloWorld

# Warmup
for i in {1..5}; do ./helloworld >/dev/null; done

runs=50
./helloworld >/dev/null # one extra to heat FS

for i in $(seq 1 $runs); do
  start=$(python3 - <<'PY'
import time; print(time.perf_counter())
PY
)
  ./helloworld >/dev/null
  end=$(python3 - <<'PY'
import time; print(time.perf_counter())
PY
)
  awk "BEGIN {print ($end - $start) * 1000}"
done | sort -n > native_times.txt

median=$(awk ' {a[NR]=$1} END{print a[int((NR+1)/2)]} ' native_times.txt)
echo "Native median ms: $median"
