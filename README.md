# PixelOS device tree for the Nothing Phone (3) (`Metroid`)

Device tree for the Nothing Phone (3), codename `Metroid`, model `A024`
(`MetroidIND`), targeting [PixelOS](https://github.com/PixelOS-AOSP) on
Android 17 (branch `seventeen`).

This tree started from the OrangeFox recovery tree
(`Farpathan/android_device_nothing_metroid`) and is converted to a full ROM
build; the recovery pieces (decryption, `recovery.fstab`, fastbootd) are kept
working, since PixelOS ships its own recovery from this tree.

## Device

| | |
| :--- | :--- |
| SoC | Snapdragon 8s Gen 4 (SM8735, `tuna`) on the `sun` (SM8750) platform family; bootloader product `sun`, baseband `PAKALA_GEN_PACK-1.170946.5.187470.2` |
| GPU | Adreno 825 |
| Display | 1260 x 2800, 120 Hz |
| Partitions | A/B with dynamic partitions on `super` (9126805504 bytes, group `qti_dynamic_partitions`), Virtual A/B |
| Encryption | File-based encryption with hardware-wrapped keys (QCOM FBE) |

## Build

```bash
repo init --depth=1 -u https://github.com/PixelOS-AOSP/android_manifest -b seventeen --git-lfs
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# copy docs/metroid.xml to .repo/local_manifests/metroid.xml, then:
repo sync -c -j$(nproc --all)

. build/envsetup.sh
lunch custom_Metroid-userdebug
mka pixelos
```

The vendor tree is `vendor/nothing/Metroid`, generated from a stock dump by the
device tree's `extract-files.py` / `setup-makefiles.py`.

### Required prebuilts

The ROM builds with the stock prebuilt kernel (`prebuilt/kernel`). Two files
must be added on the build server from the stock firmware dump (see
`prebuilt/README.md`):

- `prebuilt/dtb.img` (from stock `boot.img`/`vendor_boot.img`)
- `prebuilt/dtbo.img` (from the stock `dtbo` partition)

Until the vendor repo carries the full stock vendor_boot module set, the
recovery subset in `prebuilt/vendor_boot-modules/` is used (see
`BoardConfigCommon.mk`).

## Recovery

`recovery.fstab` is the recovery fstab (kept from the OrangeFox tree). The
patches under `patches/recovery/` (`bootable/recovery`, `system/core`
fastbootd, `system/vold`) belong to the OrangeFox recovery build only; they
are **not** applied by the ROM build.

## Flashing

```bash
adb reboot bootloader
fastboot flash boot boot.img
fastboot flash vendor_boot vendor_boot.img
fastboot flash dtbo dtbo.img
fastboot -w
fastboot reboot
```

Flash both slots or use `fastboot update`. The bootloader boots the active
slot; it changes after an OTA or a ROM flash.

## Credits

- [PixelOS](https://github.com/PixelOS-AOSP) and
  [LineageOS](https://github.com/LineageOS) for the base
- [TeamWin Recovery Project](https://github.com/TeamWin) for the recovery tree
  this is based on
- Nothing for the [kernel source](https://github.com/NothingOSS/android_kernel_msm-6.6_nothing_sm8735)
