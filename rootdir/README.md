# rootdir

ROM init scripts, ueventd configuration and fstab for the Nothing Phone (3) (Metroid).

Everything is installed from `rootdir/Android.bp` as Soong modules; add the module names below to `PRODUCT_PACKAGES`.

## Modules

| Module | Source | Installed as |
| :--- | :--- | :--- |
| `fstab.qcom` | `etc/fstab.qcom` | `/vendor/etc/fstab.qcom`, plus a copy in the generic ramdisk (`/vendor/etc/fstab.qcom` during first stage) |
| `fstab.qcom.vendor_ramdisk` | `etc/fstab.qcom` | vendor ramdisk variant of `fstab.qcom`, at `/vendor/etc/fstab.qcom` there |
| `init.qcom.rc` | `etc/init.qcom.rc` | `/vendor/etc/init/hw/init.qcom.rc` |
| `init.target.rc` | `etc/init.target.rc` | `/vendor/etc/init/hw/init.target.rc` |
| `init.nothing.rc` | `etc/init.nothing.rc` | `/vendor/etc/init/hw/init.nothing.rc` |
| `init.nt_product.rc` | `etc/init.nt_product.rc` | `/vendor/etc/init/hw/init.nt_product.rc` |
| `init.qcom.factory.rc` | `etc/init.qcom.factory.rc` | `/vendor/etc/init/hw/init.qcom.factory.rc` |
| `ueventd.qcom.rc` | `etc/ueventd.qcom.rc` | `/vendor/etc/ueventd.rc` |
| `charger_fw_fstab.qti` | `etc/charger_fw_fstab.qti` | `/vendor/etc/charger_fw_fstab.qti` |

`fstab.qcom.vendor_ramdisk` is the vendor ramdisk variant Soong makes from `fstab.qcom`; both names must be in `PRODUCT_PACKAGES`.

## Provenance

- `fstab.qcom`: derived from the tree's `recovery.fstab` (tested on the device): same dynamic partitions, AVB flags, EROFS+ext4 entries, metadata/userdata encryption (f2fs inlinecrypt, wrapped keys, metadata encryption). Only the recovery-specific `/recovery` entry was dropped.
- `init.qcom.rc`, `init.target.rc`, `ueventd.qcom.rc`, `init.qcom.factory.rc`: QSSI (Qualcomm) content for tuna/SM8735, as shipped on stock Metroid.
- `init.nt_product.rc`: stock Nothing vendor file (Nothing's product init; NT_EDIT markers preserved).
- `init.nothing.rc`: PixelOS-authored permissions for Nothing's vibrator, torch and Glyph LED sysfs nodes.
- `charger_fw_fstab.qti`: stock charger-mode fstab (modem firmware mount).

## Notes

- `init.qcom.rc` imports `init.qti.ufs.rc` and `init.qcom.usb.rc`; `init.target.rc` imports `init.qti.kernel.rc`. The blob list installs those under `/vendor/etc/init/hw/`, and `init.qti.kernel.rc` in turn imports `init.qti.kernel.target.rc`, also shipped.
- Stock's `init.qcom.test.rc` and `stnfc_nt.rc` (NFC) are not part of this firmware image, so they are not imported (stock's own files import them and the import fails at boot). `init.qti.kernel.rc` inherits the same dangling `init.qti.kernel.test.rc` import from stock.
- UFS clock tuning stays inline in `init.qcom.rc`: the stock `init.qti.ufs.rc` only runs a debug script.
- `ueventd.qcom.rc` installs to `/vendor/etc/ueventd.rc`, which the system `/system/etc/ueventd.rc` imports on Android 13+. The legacy `/vendor/ueventd.rc` location must not be used (fatal log on first-api-level >= 33).
- The blob list must not install its own `fstab.qcom`, `init.qcom.rc`, `init.target.rc`, `init.nt_product.rc`, `ueventd.rc` or `charger_fw_fstab.qti` to avoid duplicate installs of the files above.
- Binaries these rc files reference that the stock image does not ship: `init.qti.can.sh`, `init.qti.ufs.debug.sh`, `system_ext/bin/mmi`, `vendor/bin/mmid`, `system/bin/qmiproxy`. The execs fail at boot exactly as they do on stock.
