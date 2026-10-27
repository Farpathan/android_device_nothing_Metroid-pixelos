#!/bin/bash
#
# SPDX-FileCopyrightText: 2026 The PixelOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Applies the ROM build patches in patches/rom/<project path>/ to the source
# tree. Run from the top of the tree; patches that are already applied are
# skipped, so it is safe to run before every build.

set -e

top=$(pwd)
dir=$(dirname "$(readlink -f "$0")")/rom

for patch in $(cd "$dir" && find . -name '*.patch' | sort); do
    patch=${patch#./}
    project=$(dirname "$patch")
    if git -C "$top/$project" apply --check --reverse "$dir/$patch" 2>/dev/null; then
        echo "already applied: $patch"
    else
        git -C "$top/$project" apply "$dir/$patch"
        echo "applied: $patch"
    fi
done
