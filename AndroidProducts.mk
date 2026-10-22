#
# Copyright (C) 2026 The PixelOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/custom_Metroid.mk \
    $(LOCAL_DIR)/aosp_Metroid.mk

COMMON_LUNCH_CHOICES := \
    custom_Metroid-user \
    custom_Metroid-userdebug \
    custom_Metroid-eng \
    aosp_Metroid-user \
    aosp_Metroid-userdebug \
    aosp_Metroid-eng
