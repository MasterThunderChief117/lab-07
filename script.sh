#!/bin/bash
for n in 1 2 3 4; do
  src="Testcase$n"
  out="Testcase${n}Diff"
  rm -rf "$out"

  for f1 in "$src"/*.1.txt; do
    [ -f "$f1" ] || continue
    f2="${f1%.1.txt}.2.txt"
    name=$(basename "$f1" .1.txt)

    diff -u "$f1" "$f2" > /dev/null
    if [ $? -eq 1 ]; then
      mkdir -p "$out"
      diff -u "$f1" "$f2" > "$out/${name}Diff.txt"
    fi
  done
done
