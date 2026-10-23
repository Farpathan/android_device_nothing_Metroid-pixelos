#
# Copyright (C) 2026 The PixelOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nothing/Metroid

# Inherit Common Device Definitions
$(call inherit-product, $(DEVICE_PATH)/device-common.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(DEVICE_PATH)/overlay

PRODUCT_PACKAGES += \
    CarrierConfigOverlayMetroid \
    MetroidWifiOverlay \
    MetroidTetheringOverlay \
    MetroidConnectivityOverlay \
    NTSystemUIResTarget

# Keylayout & Essential Key (scancode 250)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/gpio-keys.kl

PRODUCT_PACKAGES += \
    MetroidKeyHandler

# Early System Properties (Loaded before Zygote)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.hw_timeout_multiplier=4 \
    ro.keystore.boot_level_key.strategy=TRUSTED_ENVIRONMENT:MAX_USES_PER_BOOT \
    persist.vendor.morpho.eis.force_gmenode=1


# Audio SKU Volumes & Fallback Copy
PRODUCT_COPY_FILES += \
    vendor/nothing/Metroid/proprietary/vendor/etc/audio/sku_tuna/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    vendor/nothing/Metroid/proprietary/vendor/etc/audio/sku_tuna/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    vendor/nothing/Metroid/proprietary/vendor/etc/audio/sku_tuna/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    vendor/nothing/Metroid/proprietary/vendor/lib64/libkeymaster_messages.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libkeymaster_messages.so \
    vendor/nothing/Metroid/proprietary/vendor/lib64/libwfdaac_vendor.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libwfdaac_vendor.so

# Kernel DLKM Modules
include $(DEVICE_PATH)/dlkm_modules.mk

# Force Copy Missing Blobs & Vendor Makefiles
$(call inherit-product-if-exists, $(DEVICE_PATH)/proprietary_force_copy.mk)
$(call inherit-product-if-exists, vendor/nothing/Metroid/Metroid-vendor.mk)
