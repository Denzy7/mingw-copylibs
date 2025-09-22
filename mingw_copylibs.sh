#!/bin/bash
set -e

if [[ $# -lt 1 ]]; then
    echo "usage: $0 file.exe|file.dll|PE_FILE [dll-lookup-dirs]"
    exit 1
fi

rootpath=$(dirname $(realpath $0))
exe="$(realpath $1)"
extradlldirs="${@:2} ."
mingwldd="$rootpath/mingw-ldd/mingw_ldd/mingw_ldd.py"

dir="$(echo "$exe" | sed 's:[/\\][^/\\]*$::')"

grepstr="not found|system32|winsxs|linux-vdso|ld-linux"
sedstr="s/(0x[0-9a-fA-F]*)//g"
sedstr2="s/.*=> //g"

venvdir=mingw_copylibs_venv

if ! [[ -f "$exe" ]]; then
    echo "cannot find file $exe"
    exit 1
fi

echo "info: exe:$exe dir:$dir extradlldirs:$extradlldirs"

python3 -m venv "$venvdir"
if [[ -f ".\\$venvdir\\Scripts\\pip" ]]; then
    pip=".\\$venvdir\\Scripts\\pip"
    python=".\\$venvdir\\Scripts\\python"
elif [[ -f "./$venvdir/bin/pip" ]]; then
    pip="./$venvdir/bin/pip"
    python="./$venvdir/bin/python"
fi
"$pip" install pefile

lddstr=$("$python" "$mingwldd" "$exe" --dll-lookup-dirs $extradlldirs)
echo "${lddstr}"
echo "${lddstr}" | grep -Evi "$grepstr" | sed "$sedstr" | sed "$sedstr2" | while read -r file; do
if [[ -f "$file" ]]; then
    cp -n "$file" "$dir"
    echo "Copied $file"
fi
done
