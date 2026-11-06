#!/bin/bash
status=0
for n in 1 2 3 4; do
  src="Testcase$n"
  out="Testcase${n}Diff"
  ok=1
  anydiff=0

  for f1 in "$src"/*.1.txt; do
    [ -f "$f1" ] || continue
    f2="${f1%.1.txt}.2.txt"
    name=$(basename "$f1" .1.txt)
    outfile="$out/${name}Diff.txt"

    diff -u "$f1" "$f2" > /dev/null
    if [ $? -eq 0 ]; then
      if [ -e "$outfile" ]; then
        echo "unexpected $outfile" >&2; ok=0
      fi
    else
      anydiff=1
      if [ ! -f "$outfile" ]; then
        echo "missing $outfile" >&2; ok=0
      elif ! cmp -s <(tail -n +3 "$outfile") <(diff -u "$f1" "$f2" | tail -n +3); then
        echo "wrong contents in $outfile" >&2; ok=0
      fi
    fi
  done

  if [ $anydiff -eq 1 ]; then
    [ -d "$out" ] || { echo "missing $out" >&2; ok=0; }
  else
    [ -e "$out" ] && { echo "$out should not exist" >&2; ok=0; }
  fi

  if [ $ok -eq 1 ]; then
    echo "Testcase$n: PASS"
  else
    echo "Testcase$n: FAIL"
    status=1
  fi
done
exit $status
