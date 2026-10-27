# Patches

## ROM build

`rom/<project path>/*.patch` are applied to the PixelOS tree before a build:

```bash
device/nothing/Metroid/patches/apply.sh
```

Run it from the top of the tree. Patches already applied are skipped.

| Patch | Target | Purpose |
| :--- | :--- | :--- |
| `rom/hardware/qcom-caf/sm8750/audio/pal/0001-Fix-format-specifiers-in-log-calls.patch` | `hardware/qcom-caf/sm8750/audio/pal` | log format strings that fail `-Werror,-Wformat` with the Android 17 clang |

## Recovery

The `recovery/` patches come from the OrangeFox recovery tree and are for
**recovery builds only** (TWRP/OrangeFox). `apply.sh` does not touch them;
`vendorsetup.sh` used to apply them automatically, but it is gone.

| Patch | Target | Purpose |
| :--- | :--- | :--- |
| `recovery/bootable_recovery.patch` | `bootable/recovery` | recovery crypto & haptics fixes |
| `recovery/system_core_fastbootd.patch` | `system/core` | fastbootd USB fixes on this device |
| `recovery/system_vold.patch` | `system/vold` | decryption / vendor unmount / Format Data fixes |

If the PixelOS recovery or fastbootd shows the same symptoms on this device,
these patches are the reference for porting the fixes over.
