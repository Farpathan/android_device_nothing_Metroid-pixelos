# Device config files installed by the device tree.
#
# Inherited from device-common.mk. Only files that the blob dump does NOT
# already ship are copied here: PRODUCT_COPY_FILES onto a destination the
# vendor blob Android.bp/module already provides is a duplicate-destination
# build error. See configs/README.md for the audit that decided this list.

# --- Audio policy -----------------------------------------------------------
# The blob dump ships the audio policy only inside vendor/etc/audio/sku_tuna/,
# while the policy/volumes files reference each other (and r_submix, volumes,
# volume tables) at the /vendor/etc/ top level. Copy the stock sku_tuna files
# verbatim to those top-level paths so the policy is self-consistent even when
# ro.boot.product.hardware.sku is not set. When the sku property IS set,
# audioserver reads /vendor/etc/audio/sku_tuna/audio_policy_configuration.xml
# directly and these copies are simply unused.
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(DEVICE_PATH)/configs/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(DEVICE_PATH)/configs/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(DEVICE_PATH)/configs/audio/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml

# --- Audio HAL interfaces --------------------------------------------------
# Stock list minus btaudio_sw. The source-built audiohalservice.qti searches
# only the sku directory, not /vendor/etc/audio where stock keeps the file. The
# stock Bluetooth module extends libaudioserviceexampleimpl as built against
# audio core V2, but ours is built against V4, so loading it crashes the HAL.
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/audio/vendor_audio_interfaces.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_tuna/vendor_audio_interfaces.xml

# --- Permissions ------------------------------------------------------------
# Privileged/default permission grants that no blob file provides. The stock
# aggregate files (privapp-permissions-qti-vendor.xml,
# privapp-permissions-qti-system-ext.xml, com.qti.qcc.vendor_qcc.xml) come from
# the blob dump and are NOT repeated here.
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/permissions/privapp-permissions-qti-telephony-service.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-qti-telephony-service.xml \
    $(DEVICE_PATH)/configs/permissions/privapp-permissions-qti-data-status.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-qti-data-status.xml \
    $(DEVICE_PATH)/configs/permissions/privapp-permissions-qti-qcc.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-qti-qcc.xml \
    $(DEVICE_PATH)/configs/permissions/privapp-permissions-com.google.android.euicc.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-com.google.android.euicc.xml \
    $(DEVICE_PATH)/configs/permissions/default-permissions-com.google.android.euicc.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/default-permissions-com.google.android.euicc.xml
