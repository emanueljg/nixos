#!/usr/bin/env sh

# posix magic for getting absolute script location
# https://stackoverflow.com/a/43919044
a="/$0"; a="${a%/*}"; a="${a:-.}"; a="${a##/}/"; BINDIR=$(cd "$a"; pwd)
MODULESDIR="$(realpath ${BINDIR}/../modules)"
MODULESREGISTRY="${MODULESDIR}/registry.nix";

mkindent () { 
    local INDENTLEVEL=$1

    printf "%${INDENTLEVEL}s" ' '
}  

mktitle () {
    local MODDIR=$1
    local INDENTLEVEL=$2

    local INDENT="$(mkindent "$INDENTLEVEL")"
    local TITLE="$(basename "$MODDIR" | tr '[:lower:]' '[:upper:]')"

    echo "${INDENT}# ${TITLE}"
}

relmod () {
    FILEPATH=$1
    echo '"'"$FILEPATH"'"' | sed -e 's/.*\/modules\//"\//'
} 

modattr () {
    FILEPATH=$1
    local INDENTLEVEL=$2

    EXTENSION="$(echo $FILEPATH | rev | cut -c -3 | rev)"
    
    NAME="$(basename "$FILEPATH" | rev | cut -c 5- | rev)"
    VALUE="$(relmod "$FILEPATH")"

    echo "$(mkindent "$INDENTLEVEL")${NAME} = ${VALUE};" 
}

reg () {
    local MODDIR="$1"
    local INDENTLEVEL="$2"

    local DIRS="$(find "$MODDIR" -maxdepth 1 -mindepth 1 -type d)"
    local FILES="$(find "$MODDIR" -maxdepth 1 -mindepth 1 -type f -name '*.nix')"

    if [ -n "${DIRS}${FILES}" ]; then 
        echo
        echo "$(mktitle "$MODDIR" "$INDENTLEVEL")"
        for f in $FILES; do
            modattr "$f" "$((INDENTLEVEL + 2))"
        done
        for d in $DIRS; do
            reg "$d" "$((INDENTLEVEL + 2))"
        done
    fi
}

drymain () {
    echo '{' 
    reg "$MODULESDIR" 0 | sed -e '1,4d'
    # the sed removes some junk that gets generated
    # due to the implementation detail. 
    echo '}'
}

main () {
    echo "$(drymain)" > "$MODULESDIR/registry.nix"
}

main



