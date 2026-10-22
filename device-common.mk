#
# Copyright (C) 2026 The PixelOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nothing/Metroid

# Soong Namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/qcom-caf/common/libqti-perfd-client \
    hardware/qcom-caf/sm8750/display

# Bluetooth & Audio AIDL configurations
$(call soong_config_set_bool, metroid, stock_bluetooth_audio, true)
$(call soong_config_set_bool, metroid, stock_vibrator, true)

# Display HALs from source (composer, allocator, demura, snapalloc)
PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.composer-service \
    vendor.qti.hardware.display.allocator-service \
    vendor.qti.hardware.display.demura-service \
    vendor.qti.hardware.display.snapalloc-impl \
    android.hardware.graphics.mapper@4.0-impl-qti-display \
    android.hardware.graphics.composer3-V3-ndk.vendor \
    vendor.qti.hardware.display.composer3-V1-ndk.vendor \
    vendor.qti.hardware.display.config-V12-ndk.vendor \
    vendor.qti.hardware.display.aiqe-V2-ndk.vendor

# Audio HAL from source (core + effects + extensions)
PRODUCT_PACKAGES += \
    audiohalservice.qti \
    qtiaudiohalvendorextn

# RichTap AW86938 stock vibrator HAL
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service.stock

# TEE / KeyMint dependency fix (libxml2 needed by qseecomd/libdrmfs)
PRODUCT_PACKAGES += \
    libxml2.vendor

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti

# Common AIDL/HIDL packages
PRODUCT_PACKAGES += \
    android.hardware.health-V1-ndk \
    android.frameworks.cameraservice.common-V1-ndk \
    android.hardware.sensors@2.1.vendor \
    libcodec2_vndk \
    android.hardware.radio@1.4.vendor \
    android.media.audio.common.types-V2-cpp

# VINTF Fragments
PRODUCT_PACKAGES += \
    camera_aon.metroid.xml \
    android.hardware.secure_element.metroid.xml \
    cacert.metroid.xml \
    hal_batch1.metroid.xml \
    hal_batch2.metroid.xml \
    hal_batch3.metroid.xml \
    camera_provider.metroid.xml \
    qms.metroid.xml \
    mwqem.metroid.xml \
    audio_bluetooth.metroid.xml \
    bluetooth_audio_provider.metroid.xml \
    media_c2.metroid.xml \
    perf2.metroid.xml \
    android.hardware.radio.config.metroid4.xml \
    android.hardware.radio.data.metroid4.xml \
    android.hardware.radio.messaging.metroid4.xml \
    android.hardware.radio.modem.metroid4.xml \
    android.hardware.radio.network.metroid4.xml \
    android.hardware.radio.sim.metroid4.xml \
    android.hardware.radio.voice.metroid4.xml \
    qti_radio_extensions.metroid.xml \
    android.hardware.power.metroid.xml \
    vendor.noth.hardware.charge.metroid.xml \
    ims-ext-common \
    ims_ext_common.xml

# Rootdir & Fstabs
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    $(DEVICE_PATH)/rootdir/etc/fstab.default:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.default \
    $(DEVICE_PATH)/rootdir/etc/fstab.emmc:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.emmc \
    $(DEVICE_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    $(DEVICE_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/first_stage_ramdisk/fstab.qcom \
    $(DEVICE_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/fstab.qcom \
    $(DEVICE_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

# Audio Policy & Volumes
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(DEVICE_PATH)/configs/audio/audio_module_config_primary.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_module_config_primary.xml

# Hardware Init Scripts
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/init.target.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.target.rc \
    $(DEVICE_PATH)/rootdir/etc/init.nothing.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nothing.rc \
    $(DEVICE_PATH)/rootdir/etc/init.nt_product.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nt_product.rc \
    $(DEVICE_PATH)/rootdir/etc/init.qcom.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.qcom.rc \
    $(DEVICE_PATH)/rootdir/etc/ueventd.qcom.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc
