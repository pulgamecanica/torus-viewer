#!/bin/sh
echo -ne '\033c\033]0;Torus\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Torus.x86_64" "$@"
