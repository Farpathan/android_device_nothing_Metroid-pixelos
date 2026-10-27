# Prebuilts

All binaries in this directory come from the stock Nothing firmware for the
Nothing Phone (3) (`A024`), matching bootloader `00265-PAKALA-1`, baseband
`PAKALA_GEN_PACK-1.170946.5.187470.2`. They are used as-is by the ROM build;
there is no kernel source build.

| File | Origin | Notes |
| :--- | :--- | :--- |
| `kernel` | stock `boot.img` | GKI 6.6 Image (arm64, 4K pages). Referenced by `TARGET_PREBUILT_KERNEL`. |
| `kernel-headers.tar.gz` | QTI UAPI headers | For the caf HALs; wired via `TARGET_PREBUILT_KERNEL_HEADERS`. `vendor/lineage/build` must support the gzip tarball (see `patches/README.md` notes from the previous attempt). |
| `vendor_boot-modules/` | stock `vendor_boot.img` | **Recovery subset** (29 modules + `modules.load`, `modules.load.recovery`): touch, haptics, charger, glink. Stopgap until the vendor repo carries the full 131-module stock set under `vendor/nothing/Metroid/proprietary/vendor_boot/lib/modules/`. |
| `dtb.img` | stock `boot.img`/`vendor_boot.img` | **TODO: add on the build server** (referenced by `TARGET_PREBUILT_DTB`; the build fails without it). |
| `dtbo.img` | stock `dtbo` partition | **TODO: add on the build server** (referenced by `BOARD_PREBUILT_DTBOIMAGE`; the build fails without it). |

## Kernel modules

`BOARD_VENDOR_RAMDISK_KERNEL_MODULES(_LOAD)` first looks in
`vendor/nothing/Metroid/proprietary/vendor_boot/lib/modules/` and falls back to
`vendor_boot-modules/` here. Once the full stock set is extracted into the
vendor repo, the fallback subset can be dropped.
