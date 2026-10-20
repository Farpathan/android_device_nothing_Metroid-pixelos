#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 The TeamWin Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

export TARGET_ARCH="arm64"
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL="C"

# Add standard TWRP lunch combos
add_lunch_combo twrp_Metroid-eng
add_lunch_combo twrp_Metroid-userdebug

# Auto-apply essential system patches for Nothing Phone (3) if present
if [ -d "device/nothing/Metroid/patches" ]; then
    if [ -f "device/nothing/Metroid/patches/system_vold.patch" ] && [ -d "system/vold" ]; then
        patch -d system/vold -p1 -N -r - --dry-run < device/nothing/Metroid/patches/system_vold.patch >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "-- Applying system/vold patches for Nothing Phone 3 decryption..."
            patch -d system/vold -p1 -N -r - < device/nothing/Metroid/patches/system_vold.patch >/dev/null 2>&1
        fi
    fi
    if [ -f "device/nothing/Metroid/patches/bootable_recovery.patch" ] && [ -d "bootable/recovery" ]; then
        patch -d bootable/recovery -p1 -N -r - --dry-run < device/nothing/Metroid/patches/bootable_recovery.patch >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "-- Applying bootable/recovery patches for Nothing Phone 3 crypto & haptics..."
            patch -d bootable/recovery -p1 -N -r - < device/nothing/Metroid/patches/bootable_recovery.patch >/dev/null 2>&1
        fi
    fi
    if [ -f "device/nothing/Metroid/patches/system_core_fastbootd.patch" ] && [ -d "system/core" ]; then
        patch -d system/core -p1 -N -r - --dry-run < device/nothing/Metroid/patches/system_core_fastbootd.patch >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "-- Applying system/core patches for Nothing Phone 3 fastbootd..."
            patch -d system/core -p1 -N -r - < device/nothing/Metroid/patches/system_core_fastbootd.patch >/dev/null 2>&1
        fi
    fi
fi
