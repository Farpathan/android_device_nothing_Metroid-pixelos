#
# Copyright (C) 2026 The PixelOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nothing/Metroid

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# GSI AVB keys, moved into vendor_boot by BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Virtual A/B with compression
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4
PRODUCT_VIRTUAL_AB_COW_VERSION := 3

# Soong namespaces: the caf sm8750 repos declare no namespace of their own.
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/qcom-caf/common/libqti-perfd-client

# QCOM caf common config (linker fragments, RFS symlinks)
$(call inherit-product, hardware/qcom-caf/common/common.mk)

# Relaxed checks for qcom blobs
RELAX_USES_LIBRARY_CHECK := true

# A/B updater packages
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_client \
    update_engine_sideload \
    update_verifier

# Boot control HAL (hardware/qcom-caf/bootctrl)
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

# f2fs utilities and userdata checkpoint
PRODUCT_PACKAGES += \
    sg_write_buffer \
    f2fs_io \
    check_f2fs \
    checkpoint_gc

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot@1.1-impl-mock

# TEE / KeyMint dependencies
PRODUCT_PACKAGES += \
    android.hardware.health-V1-ndk \
    libxml2.vendor

# The vintf manifest declares IHealth; healthd-ext provides it
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti

# base_vendor.mk only adds it for shipping API level 29 and older, but the
# stock vendor blobs still use /dev/vndbinder and the composer blocks without it
PRODUCT_PACKAGES += \
    vndservicemanager

# Older AIDL versions that stock blobs still load next to the current ones
PRODUCT_PACKAGES += \
    android.hardware.audio.core-V2-ndk.vendor \
    android.hardware.bluetooth.audio-V4-ndk.vendor \
    android.hardware.graphics.allocator-V1-ndk.vendor \
    android.hardware.graphics.common-V5-ndk.vendor \
    android.hardware.graphics.composer3-V3-ndk.vendor \
    android.media.audio.common.types-V3-ndk.vendor

# Audio HAL support from the sm8750 caf repos (hardware/qcom-caf/sm8750/audio)
# and the commonsys hal_adapter; module names confirmed in the synced tree.
PRODUCT_PACKAGES += \
    audioadsprpcd \
    audiohalservice.qti \
    libqcomvoiceprocessing \
    libvolumelistener \
    qtiaudiohalvendorextn

# audiohalservice.qti dlopens these, so nothing pulls them in on its own.
# Without the core HAL AudioFlinger null-derefs and audioserver crash-loops.
PRODUCT_PACKAGES += \
    libagmipcservice \
    libaudiocore.extension \
    libaudiocorehal.default \
    libaudiocorehal.qti \
    libaudioeffecthal.qti \
    libaudioplatform.qti

# PAL opens the virtual (AGM) mixer through these tinyalsa plugins and aborts
# without them; the rest are the IPC services, extensions and effect libraries
# that stock ships and the audio configs point at.
PRODUCT_PACKAGES += \
    lib_bt_bundle \
    libagm_compress_plugin \
    libagm_mixer_plugin \
    libagm_pcm_plugin \
    libaudiochargerlistener \
    libbundleaidl \
    libdownmixaidl \
    libdynamicsprocessingaidl \
    libfmpal \
    libhfp_pal \
    libloudnessenhanceraidl \
    libpaleventnotifier \
    libpalipcservice \
    libqcompostprocbundle \
    libqcomvisualizer \
    libreverbaidl \
    libsndcardparser \
    libvisualizeraidl


# Rootdir (prebuilt_etc modules in rootdir/Android.bp, see rootdir/README.md)
PRODUCT_PACKAGES += \
    fstab.qcom \
    fstab.qcom.vendor_ramdisk \
    init.qcom.rc \
    init.target.rc \
    init.nothing.rc \
    init.nt_product.rc \
    init.qcom.factory.rc \
    ueventd.qcom.rc \
    charger_fw_fstab.qti \
    init.metroid.bootlog.rc

# Firmware mount points and wlan firmware links (Android.bp). Without the
# mount points the modem/dsp partitions never mount, the ADSP never boots and
# the audio HAL aborts, which takes system_server down with it.
PRODUCT_PACKAGES += \
    firmware_WCNSS_qcom_cfg.ini_symlink \
    firmware_wlan_mac.bin_symlink \
    firmware_wlanmdsp.otaupdate_symlink \
    metroid_mountpoint_bt_firmware \
    metroid_mountpoint_dsp \
    metroid_mountpoint_firmware_mnt

# The stock IMS app (org.codeaurora.ims) needs this library; without it
# com.qti.phone crash-loops and Rescue Party reboots the phone.
PRODUCT_PACKAGES += \
    ims-ext-common \
    ims_ext_common.xml

# AIDL stubs for the stock Wi-Fi, sensors and USB services in proprietary-files.txt
PRODUCT_PACKAGES += \
    android.hardware.sensors-V2-ndk \
    android.hardware.usb-V1-ndk \
    android.hardware.wifi-V2-ndk \
    libwifi-system-iface \
    vendor.qti.hardware.wifi.supplicant-V1-ndk

# Runtime resource overlays (see overlay/README.md)
PRODUCT_PACKAGES += \
    CarrierConfigOverlayMetroid \
    MetroidConnectivityOverlay \
    MetroidTetheringOverlay \
    MetroidWifiOverlay \
    NTSystemUIResTarget \
    MetroidFrameworksResOverlay \
    MetroidSettingsOverlay \
    MetroidTelephonyOverlay \
    MetroidApertureOverlay \
    MetroidLineageSdkOverlay

# First-stage fstab, where init looks for it in the vendor ramdisk
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/init.recovery.qcom.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc

# Stock keeps the system_dlkm blocklist next to the vendor modules
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/vendor_dlkm-modules/system_dlkm.modules.blocklist:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist

# OEM otacerts
PRODUCT_EXTRA_RECOVERY_KEYS += \
    $(DEVICE_PATH)/security/otacert

# Enable Fuse Passthrough
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fuse.passthrough.enable=true

# Soong config for the recovery's UFS updater (bsg framework)
SOONG_CONFIG_NAMESPACES += ufsbsg
SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg

# Vendor blobs (generated by setup-makefiles.py from the blobs)
$(call inherit-product-if-exists, vendor/nothing/Metroid/Metroid-vendor.mk)

# Device configs (config.fs copies, vintf fragments, permissions;
# provided by the vintf/configs owner)
$(call inherit-product, $(DEVICE_PATH)/configs/configs.mk)
