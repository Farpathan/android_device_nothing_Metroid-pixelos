# Patches

These patches come from the OrangeFox recovery tree and are for **recovery
builds only** (TWRP/OrangeFox). They are **not** applied by the PixelOS ROM
build; `vendorsetup.sh` used to apply them automatically, but it is gone.

| Patch | Target | Purpose |
| :--- | :--- | :--- |
| `recovery/bootable_recovery.patch` | `bootable/recovery` | recovery crypto & haptics fixes |
| `recovery/system_core_fastbootd.patch` | `system/core` | fastbootd USB fixes on this device |
| `recovery/system_vold.patch` | `system/vold` | decryption / vendor unmount / Format Data fixes |

If the PixelOS recovery or fastbootd shows the same symptoms on this device,
these patches are the reference for porting the fixes over.
