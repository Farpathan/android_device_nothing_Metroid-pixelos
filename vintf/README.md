# VINTF metadata for Metroid

Three files, wired in `BoardConfigCommon.mk`:

| file | build variable | what it is |
| --- | --- | --- |
| `manifest.xml` | `DEVICE_MANIFEST_FILE` | what the vendor image serves (`type="device"`, `target-level="202404"`) |
| `compatibility_matrix.xml` | `DEVICE_MATRIX_FILE` | what the vendor image requires from the framework (empty) |
| `framework_compatibility_matrix.xml` | `DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE` | vendor-only HALs the framework may use (`type="framework"`, all `optional="true"`) |

## Why one manifest and not fragments

The manifest is a single `manifest.xml`, not a set of `vintf_fragment` modules.
A fragment that is not regenerated on an incremental build gets pruned from
`vendor/etc/vintf/manifest/`, which is a failure mode the earlier bring-up hit
(services then abort on `addService` with "-3 not declared"). One file in
`DEVICE_MANIFEST_FILE` always lands at `/vendor/etc/vintf/manifest.xml` and is
merged on device like any fragment.

`libui` loads the gralloc mapper through
`AServiceManager_openDeclaredPassthroughHal("mapper", "qti", ...)`, i.e. it asks
servicemanager `isDeclared("mapper/qti")` and then loads `mapper.qti.so`. That is
an ordinary manifest lookup against the merged manifest, so the mapper is
declared here as a `format="native"` HAL with instance `qti`: no standalone
fragment is needed for it. (The earlier tree carried a comment claiming libui
only sees standalone fragments; the libbinder code path is
`IServiceManager::isDeclared` → `HalManifest::hasNativeInstance`, which reads the
merged manifest.)

## Do not duplicate blob-provided fragments

The blob dump already installs:

* `vendor/etc/vintf/manifest/vendor.qti.qccvndhal_aidl-service.xml`
* `system_ext/etc/vintf/manifest/vendor.qti.qccsyshal_aidl-service.xml` (type `framework`)

Neither is declared here. Adding them again makes `assemble_vintf` fail on the
duplicate.

## What is declared, and why

Rule: declare every HAL whose stock service calls `addService()`: an undeclared
AIDL HAL makes the service abort in a crash loop: and declare nothing that has
no serving binary.

The list is derived from the stock dump (service `.rc` files and
`android.hardware.*-V<n>-ndk.so` / `vendor.*-V<n>-ndk.so` libraries in
`proprietary-files.txt`) cross-checked with the fragments of the earlier bring-up.
Interface versions are the versions of the shipped NDK libraries.

Declared on purpose although the earlier tree omitted them: `sensors`,
`thermal`, `health`, `boot`, `usb`, `usb.gadget`, `graphics.allocator`,
`memtrack`, `weaver`, `authsecret`, `wifi.supplicant`, every
`android.hardware.radio.*` HAL and the native `mapper`. Stock ships a service for
each; declaring a HAL that is never served costs nothing, while omitting a served
one breaks it.

Deliberately **not** declared (no serving binary in the stock dump):

* `android.hardware.soundtrigger3`: lib only, no service
* `android.hardware.vibrator`: lib + `hw/vibrator.default.so`, no service
* `android.hardware.tetheroffload`: lib only, no service
* `android.hardware.security.keymint` / `strongbox` instance, thales strongbox
  only exists in the `odm/overlayfs_origin` sku overlay
* `android.hardware.radio.ims`: no `android.hardware.radio.ims-V*-ndk.so`
  (the shipped IMS HAL is `vendor.qti.hardware.radio.ims`)
* `vendor.qti.hardware.ListenSoundModel`: not served (same conclusion as the
  earlier bring-up)

If one of these turns out to be served after all, add it to `manifest.xml` and
update the matrix as described below; the build will not fail either way, only the service
registration will.

## Keeping the two matrices honest

`framework_compatibility_matrix.xml` is derived from `manifest.xml`: every
declared HAL whose name does not start with `android.` gets an `optional="true"`
entry (FCM 202404 already covers `android.hardware.*`). When editing
`manifest.xml`, update the matrix to match. Every declared instance must be
covered by FCM 202404 or by the device framework matrix (the direction
`assemble_vintf` enforces at build time), and no two declarations may share a
package/interface/instance.

Known follow-ups for the first boot test:

* `vendor/etc/vintf/manifest/` may still gain a vendor-provided
  `android.hardware.graphics.mapper` declaration from a future blob refresh; the
  duplicate would then have to be dropped here.
* Stock may additionally declare HIDL HALs (display composer, wfd) from
  fragments that the pruned dump no longer contains. None are declared yet.
