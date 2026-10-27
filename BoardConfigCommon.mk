#
# Copyright (C) 2026 The PixelOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nothing/Metroid

# Dexpreopt (matches the previous attempt; revisit once builds are stable)
WITH_DEXPREOPT := false

# A/B System Updates. Keep in sync with the "_a"/"_b" partition pairs on the device.
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    vendor_boot \
    system \
    system_ext \
    product \
    vendor \
    vendor_dlkm \
    system_dlkm \
    odm \
    recovery \
    dtbo \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo300

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a75

# Platform: the bootloader reports product "sun" and the baseband is PAKALA
# (SM8750 family). The silicon is a Snapdragon 8s Gen 4 (SM8735, "tuna"),
# which is a member of the sun platform family; the vendor SKU is "sun"
# (ro.boot.product.vendor.sku sun) and all QCOM caf repos are the sm8750 ones.
TARGET_NO_BOOTLOADER := true
BOARD_VENDOR := nothing
TARGET_SOC := sun
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_SOC)
TARGET_BOARD_PLATFORM := $(TARGET_SOC)
QCOM_BOARD_PLATFORMS := $(TARGET_SOC)
TARGET_BOARD_PLATFORM_GPU := Adreno-825

BOARD_USES_QCOM_HARDWARE := true
BOARD_NO_RADIOIMAGE := true

# Allow prebuilt ELF blobs shipped via PRODUCT_COPY_FILES
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_PREBUILT_ELF_FILES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true
BUILD_BROKEN_INCORRECT_PARTITION_IMAGES := true

# Custom OEM Android IDs
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/configs/config.fs

# Kernel / Boot Image Header v4
BOARD_BOOT_HEADER_VERSION := 4
BOARD_INIT_BOOT_HEADER_VERSION := 4
BOARD_RAMDISK_USE_LZ4 := true
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_TAGS_OFFSET := 0x00000100
BOARD_DTB_OFFSET := 0x01f00000

# Kernel cmdline (boot.img header). bootopt/erofs.reserved_pages come from the
# previous attempt's live-device extraction; TODO: re-verify against the stock
# boot.img header once it is dumped.
BOARD_KERNEL_CMDLINE := video=vfb:640x400,bpp=32,memsize=3072000 qcom_geni_serial.con_enabled=0 console=ttynull bootopt=64S3,32N2,64N2 erofs.reserved_pages=64 nosoftlockup log_buf_len=1M ignore_loglevel printk.devkmsg=on
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

# Vendor cmdline for vendor_boot, verbatim from the stock
# vendor_boot.mkbootimg-args (minus the trailing "bootconfig" token, which
# mkbootimg re-appends because BOARD_BOOTCONFIG is set).
BOARD_VENDOR_CMDLINE := video=vfb:640x400,bpp=32,memsize=3072000 qcom_geni_serial.con_enabled=0 nosoftlockup console=ttynull qcom_geni_serial.con_enabled=0 log_buf_len=1M ignore_loglevel printk.devkmsg=on

BOARD_KERNEL_IMAGE_NAME := kernel

# Bootconfig (takes precedence over the cmdline), from the stock bootconfig.
# selinux=permissive until the device sepolicy is validated, then drop the line
# (stock ships no androidboot.selinux entry and boots enforcing).
BOARD_BOOTCONFIG := \
    androidboot.hardware=qcom \
    androidboot.memcg=1 \
    androidboot.usbcontroller=a600000.dwc3 \
    androidboot.load_modules_parallel=true \
    androidboot.hypervisor.protected_vm.supported=true \
    androidboot.vendor.qspa=true \
    androidboot.serialconsole=0 \
    androidboot.selinux=permissive

# Prebuilt stock kernel (GKI 6.6, no kernel source build; see prebuilt/README.md)
TARGET_KERNEL_VERSION := 6.6
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
# QTI UAPI headers for the caf HALs (vendor/lineage/build must handle the
# gzip tarball, see patches/README notes from the previous attempt)
TARGET_PREBUILT_KERNEL_HEADERS := $(DEVICE_PATH)/prebuilt/kernel-headers.tar.gz

# DTB/DTBO: prebuilts from the stock firmware (see prebuilt/README.md).
# dtb.img is the *.dtb files in BOARD_PREBUILT_DTBIMAGE_DIR joined in order.
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img

BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_INIT_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

# Kernel modules in the vendor_boot ramdisk (first stage + recovery): the full
# stock vendor_boot module set (341 modules + modules.load, modules.load.recovery
# and modules.blocklist), extracted from the stock vendor_boot.img. The build
# only packs the .ko files, modules.load and modules.blocklist into the
# ramdisk; modules.dep/modules.softdep/modules.alias stay in prebuilt/ for
# reference (matching what other GKI device trees ship).
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(wildcard $(DEVICE_PATH)/prebuilt/vendor_boot-modules/*.ko)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(shell cat $(DEVICE_PATH)/prebuilt/vendor_boot-modules/modules.load 2>/dev/null)
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(shell cat $(DEVICE_PATH)/prebuilt/vendor_boot-modules/modules.load.recovery 2>/dev/null)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(DEVICE_PATH)/prebuilt/vendor_boot-modules/modules.blocklist

# Dynamic partitions (sizes from fastboot, 2026-10-27)
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9122611200 # BOARD_SUPER_PARTITION_SIZE - 4MiB
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    product \
    vendor \
    vendor_dlkm \
    system_dlkm \
    odm

# EROFS everywhere (stock filesystem), f2fs userdata
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 67108864
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_PARTITION_RESERVED_SIZE := 67108864
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 67108864
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 67108864
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_PARTITION_RESERVED_SIZE := 67108864
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_PARTITION_RESERVED_SIZE := 67108864
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_DLKMIMAGE_PARTITION_RESERVED_SIZE := 67108864
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

TARGET_COPY_OUT_SYSTEM := system
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm
BOARD_USES_VENDOR_DLKMIMAGE := true
BOARD_USES_SYSTEM_DLKMIMAGE := true

# TODO(blobs): populate vendor_dlkm/system_dlkm with the stock prebuilt module
# sets (vendor repo), otherwise both partitions build empty and the device
# hard-resets early in boot (the stock fstab first-stage-mounts them).

# Recovery (AOSP/Lineage-style, shares the vendor_boot ramdisk)
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_SUPPRESS_SECURE_ERASE := true
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab

# Vendor freeze / shipping level (vendor is Android 15-based; TODO: re-verify
# ro.vendor.api_level against the current stock vendor once the dump is done)
BOARD_SHIPPING_API_LEVEL := 202404
VENDOR_SECURITY_PATCH := 2026-04-05
BOOT_SECURITY_PATCH := 2026-06-05

# Verified Boot (AVB), chained vbmeta_system/vbmeta_vendor like stock
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
METROID_AVB_KEY_PATH ?= external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_KEY_PATH := $(METROID_AVB_KEY_PATH)
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

BOARD_AVB_BOOT_KEY_PATH := $(METROID_AVB_KEY_PATH)
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 3

BOARD_AVB_RECOVERY_KEY_PATH := $(METROID_AVB_KEY_PATH)
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := $(METROID_AVB_KEY_PATH)
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

BOARD_AVB_VBMETA_VENDOR := vendor vendor_dlkm system_dlkm odm
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := $(METROID_AVB_KEY_PATH)
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 4

BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

# Encryption
BOARD_USES_QCOM_FBE_DECRYPTION := true
BOARD_USES_METADATA_PARTITION := true
TARGET_USES_MKE2FS := true
TARGET_USES_LOGD := true

# Treble & VINTF (files provided by the vintf owner, see vintf/ and configs/)
PRODUCT_ENFORCE_VINTF_MANIFEST := true
PRODUCT_FULL_TREBLE := true
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/vintf/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/vintf/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(DEVICE_PATH)/vintf/framework_compatibility_matrix.xml

# SEPolicy (device policy provided by the sepolicy owner, see sepolicy/)
include device/qcom/sepolicy/SEPolicy.mk
include device/qcom/sepolicy_vndr/sm8750/SEPolicy.mk
include device/lineage/sepolicy/common/sepolicy.mk
-include device/custom/sepolicy/sepolicy.mk # PixelOS's own policy (OTA updater app)
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private

# 64-bit media stack
TARGET_DYNAMIC_64_32_MEDIASERVER := true
TARGET_DYNAMIC_64_32_DRMSERVER := true
