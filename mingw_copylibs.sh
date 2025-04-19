#!/bin/bash
set -e
exe="$1"
syspfx="$2"
extradlldirs="$3"
mingwldd="$4"

dir="$(echo "$exe" | sed 's:[/\\][^/\\]*$::')"

grepstr="not found|system32|winsxs|linux-vdso|ld-linux"
sedstr="s/(0x[0-9a-fA-F]*)//g"
sedstr2="s/.*=> //g"

venvdir=mingw_copylibs_venv

echo "info: exe:$exe dir:$dir syspfx:$syspfx extradlldirs:$extradlldirs"

python3 -m venv "$venvdir"
if [[ -f ".\\$venvdir\\Scripts\\pip" ]]; then
    pip=".\\$venvdir\\Scripts\\pip"
    python=".\\$venvdir\\Scripts\\python"
elif [[ -f "./$venvdir/bin/pip" ]]; then
    pip="./$venvdir/bin/pip"
    python="./$venvdir/bin/python"
fi
"$pip" install pefile

lddstr=$("$python" "$mingwldd" "$exe" --dll-lookup-dirs "$syspfx/bin" $extradlldirs)
echo "${lddstr}"
echo "${lddstr}" | grep -Evi "$grepstr" | sed "$sedstr" | sed "$sedstr2" | while read -r file; do
if [[ -f "$file" ]]; then
    cp -n "$file" "$dir"
    echo "Copied $file"
fi
done
