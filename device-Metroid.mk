#
# Copyright (C) 2026 The PixelOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nothing/Metroid

# Inherit common device definitions
$(call inherit-product, $(DEVICE_PATH)/device-common.mk)

# Keylayout (the Essential Key, scancode 250, falls back to CAMERA unless the
# system_server key handler intercepts it; see keylayout/gpio-keys.kl)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/gpio-keys.kl

# TODO(keyhandler): MetroidKeyHandler (torch on the Essential Key). The
# keyhandler/ source is not part of this tree yet; add the package once owned.

# Early system properties (loaded before zygote; from the previous attempt)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.hw_timeout_multiplier=4 \
    ro.keystore.boot_level_key.strategy=TRUSTED_ENVIRONMENT:MAX_USES_PER_BOOT \
    persist.vendor.morpho.eis.force_gmenode=1
