#
# Copyright (C) 2026 The PixelOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit PixelOS / custom common configuration
$(call inherit-product, vendor/custom/config/common_full_phone.mk)

# Inherit from Metroid device
$(call inherit-product, device/nothing/Metroid/device-Metroid.mk)

# Device identifiers
PRODUCT_NAME := custom_Metroid
PRODUCT_DEVICE := Metroid
PRODUCT_BRAND := Nothing
PRODUCT_MODEL := A024
PRODUCT_MANUFACTURER := Nothing

PRODUCT_GMS_CLIENTID_BASE := android-nothing
PRODUCT_SHIPPING_API_LEVEL := 35

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceProduct=MetroidIND \
    DeviceName=Metroid
