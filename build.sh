rm -rf bin
mkdir bin

if [[ -z "${ODIN_ROOT:-}" ]]; then
    echo "ODIN_ROOT not set, trying 'odin root'..."
    if ! command -v odin >/dev/null 2>&1; then
        echo "Error: 'odin' command not found and ODIN_ROOT is not set." >&2
        exit 1
    fi
    ODIN_ROOT="$(odin root)"
    export ODIN_ROOT
    echo "Using ODIN_ROOT=$ODIN_ROOT"
else
    echo "Using existing ODIN_ROOT=$ODIN_ROOT"
fi

STB_SRC="$ODIN_ROOT/vendor/stb/src"
if [[ ! -x "$STB_SRC/build_stb.sh" ]]; then
    echo "Error: build_stb.sh not found or not executable at: $STB_SRC/build_stb.sh" >&2
    exit 1
fi

here=$(pwd)
cd $STB_SRC
./build_stb.sh
cd $here

if [ "$1" = "release" ]; then
	odin build src -collection:formats=formats -out:bin/spall -debug -o:speed -no-bounds-check -define:GL_DEBUG=false -strict-style -minimum-os-version:11.0
elif [ "$1" = "opt" ]; then
	odin build src -collection:formats=formats -out:bin/spall -debug -o:speed -strict-style -minimum-os-version:11.0
else
	odin build src -collection:formats=formats -out:bin/spall -debug -strict-style -minimum-os-version:11.0
fi
