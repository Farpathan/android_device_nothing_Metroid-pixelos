# Recovery device tree for the Nothing Phone (3) (`Metroid`)

TWRP device tree for the Nothing Phone (3), codename `Metroid`, model `A024` (`MetroidIND`). It covers the hardware bringup a recovery needs on this phone: decryption of `/data`, display, touch, haptics, fastbootd and the A/B dynamic partitions.

Prebuilt images are on the [Releases](https://github.com/Farpathan/android_device_nothing_metroid/releases) page.

## Device

| | |
| :--- | :--- |
| SoC | Qualcomm Snapdragon 8s Gen 4 (SM8735, `tuna`, vendor SKU `sun`) |
| Display | 1260 x 2800, 120 Hz |
| Touch | FocalTech FT3681 (`fts_ts`) |
| Partitions | A/B with dynamic partitions on `super`, Virtual A/B |
| Encryption | File-based encryption with hardware-wrapped keys |

## How decryption works

The stock KeyMint and Gatekeeper services can't be built from source, because Qualcomm's QSEECom and Mink IPC headers aren't public. So `init.recovery.qcom.rc` mounts the phone's own `/vendor` early and runs the stock `qseecomd`, `android.hardware.security.keymint-service-qti` and `android.hardware.gatekeeper-service-qti` from it. KeyMint and Gatekeeper load recovery's `libbinder.so` first through `/tmp/keymint_libs`, and the extra libraries they need are in `twrp/recovery/root/system/lib64/`.

## Building

```bash
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
git clone https://github.com/Farpathan/android_device_nothing_metroid.git -b main device/nothing/Metroid

. build/envsetup.sh
lunch twrp_Metroid-eng
mka recoveryimage -j$(nproc --all)
```

`vendorsetup.sh` applies the patches in `patches/` to `bootable/recovery`, `system/core` and `system/vold` during `envsetup.sh`. They add decryption support, fastbootd USB fixes, haptics and the vendor unmount and Format Data fixes.

## Flashing

```bash
adb reboot bootloader
fastboot flash recovery_a out/target/product/Metroid/recovery.img
fastboot flash recovery_b out/target/product/Metroid/recovery.img
fastboot reboot recovery
```

Flash both slots. The bootloader boots the recovery of the active slot, and the active slot changes after an OTA or a ROM flash.

## Credits

- [TeamWin Recovery Project](https://github.com/TeamWin) for TWRP
- Nothing for the [kernel source](https://github.com/NothingOSS/android_kernel_msm-6.6_nothing_sm8735)
