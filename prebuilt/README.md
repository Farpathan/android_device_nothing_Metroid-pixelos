# Prebuilts

All binaries in this directory come from the stock Nothing firmware for the
Nothing Phone (3) (`A024`), package `C5.0-260924-2115`, matching bootloader
`00265-PAKALA-1` and baseband `PAKALA_GEN_PACK-1.170946.5.187470.2`. They are
used as-is by the ROM build; there is no kernel source build.

| File | Origin | Notes |
| :--- | :--- | :--- |
| `kernel` | stock `boot.img` | GKI 6.6.127 Image (`android15-8`, build `ab15756704`, arm64, 4K pages), the version every module here is built for. Referenced by `TARGET_PREBUILT_KERNEL`. |
| `kernel-headers.tar.gz` | QTI UAPI headers | For the caf HALs; `kernel-headers/Makefile` unpacks it as the `headers_install` step of `TARGET_KERNEL_SOURCE`. |
| `dtb/stock.dtb` | stock `vendor_boot` dtb | The stock device tree blob, the only file in `BOARD_PREBUILT_DTBIMAGE_DIR`, so the built `dtb.img` matches stock byte for byte. |
| `dtbo.img` | stock `dtbo` partition | Overlay DTBO image (`BOARD_PREBUILT_DTBOIMAGE`), 48 MiB, matches `BOARD_DTBOIMG_PARTITION_SIZE`. |
| `pvmfw.img` | stock `pvmfw` partition | Never flashed. Only its AVB hash descriptor goes into `vbmeta.img`, because ABL refuses a slot whose vbmeta chain does not cover pvmfw. |
| `vendor_boot-modules/` | stock `vendor_boot.img` | The **full** stock vendor_boot module set: 341 `.ko` plus `modules.load`, `modules.load.recovery`, `modules.blocklist`, `modules.dep`, `modules.softdep`, `modules.alias`. |
| `vendor_dlkm-modules/` | stock `vendor_dlkm.img` | The stock vendor_dlkm `lib/modules`: 311 `.ko`, `modules.load` (572 lines, 311 unique), `modules.blocklist`, `system_dlkm.modules.blocklist` and the depmod outputs. |
| `system_dlkm-modules/` | stock `system_dlkm.img` | The stock system_dlkm `lib/modules`: 96 signed GKI `.ko` and the depmod outputs. Stock loads none of them directly; vendor modules pull them in as dependencies. |

## Kernel modules

`BOARD_VENDOR_RAMDISK_KERNEL_MODULES(_LOAD)` and
`BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE` point at
`vendor_boot-modules/` (see BoardConfigCommon.mk). The build packs the `.ko`
files, `modules.load` and `modules.blocklist` into the vendor_boot ramdisk;
`modules.dep`, `modules.softdep` and `modules.alias` are kept here for
reference only, matching what other GKI device trees ship.

`modules.load` (122 entries) is the first-stage load order and includes the
UFS phy, pinctrl and clock modules first stage needs to mount `/system`.
`modules.load.recovery` (344 entries) is the recovery load order.
