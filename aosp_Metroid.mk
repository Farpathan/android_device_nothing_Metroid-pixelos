#
# Copyright (C) 2026 The PixelOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

TARGET_SCREEN_WIDTH := 1260
TARGET_SCREEN_HEIGHT := 2800
TARGET_SCREEN_DENSITY := 480

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit PixelOS / Custom common configuration
$(call inherit-product-if-exists, vendor/custom/config/common_full_phone.mk)
$(call inherit-product-if-exists, vendor/pixelos/config/common_full_phone.mk)

# Inherit from Metroid device
$(call inherit-product, device/nothing/Metroid/device-Metroid.mk)

# Qualcomm vibrator product include adds generic service; keep stock RichTap
PRODUCT_PACKAGES := $(filter-out vendor.qti.hardware.vibrator.service,$(PRODUCT_PACKAGES))

# Device identifiers
PRODUCT_NAME := aosp_Metroid
PRODUCT_DEVICE := Metroid
PRODUCT_BRAND := Nothing
PRODUCT_MODEL := A024
PRODUCT_MANUFACTURER := Nothing

PRODUCT_GMS_CLIENTID_BASE := android-nothing
PRODUCT_SHIPPING_API_LEVEL := 35

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceProduct=MetroidIND \
    DeviceName=Metroid
