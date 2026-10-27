# VINTF metadata for Metroid

Three files, wired in `BoardConfigCommon.mk`:

| file | build variable | what it is |
| --- | --- | --- |
| `manifest.xml` | `DEVICE_MANIFEST_FILE` | the HALs nothing else declares (`type="device"`, `target-level="202404"`) |
| `compatibility_matrix.xml` | `DEVICE_MATRIX_FILE` | what the vendor image requires from the framework (empty) |
| `framework_compatibility_matrix.xml` | `DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE` | vendor-only HALs the framework may use (`type="framework"`, all `optional="true"`) |

## The stock fragments do most of the work

The blob list now ships the stock VINTF fragments: 111 entries under
`vendor/etc/vintf/manifest/` and `system_ext/etc/vintf/manifest/`, declaring 142
instances. On top of those, the caf modules built from source install their own
fragments (`hardware/qcom/display` for composer, allocator, demura and
`mapper.qti`; the audio-hal tree for `audioeffectservice_qti.xml` and
`manifest_audio_qti_services.xml`).

A second declaration of the same package/interface/instance is not merged away:
`HalManifest::addingConflictingFqInstance` treats it as a conflict, and the
manifest fetch then fails, which takes down HAL registration for the whole
device. So `manifest.xml` declares only what nothing else declares.

## What is declared, and why

Five HALs:

* `android.hardware.gatekeeper` and `android.hardware.nfc`: stock declares them
  in its product manifest (`vendor/etc/vintf/manifest_sun.xml` and
  `manifest_tuna.xml`). That is a device manifest, not a fragment, it is not in
  the blob list, and our `DEVICE_MANIFEST_FILE` takes its place.
* `vendor.qti.hardware.spu`: same, product manifest only.
* `android.hardware.authsecret` and `vendor.qti.hardware.sensorscalibrate`: no
  fragment exists anywhere in the stock image, but the service binary and its
  init script ship, so the service would abort on `addService`.

`<sepolicy><version>202404</version>` matches what stock's product manifest
declares and what FCM 202404 expects from a 202404 vendor image.

Everything else that is served (sensors, health, vibrator, composer, demura,
the audio HALs, the radio stack, the vendor extensions) is declared by a
fragment, so it is deliberately absent here.

## The gralloc mapper

`libui` loads the mapper through
`AServiceManager_openDeclaredPassthroughHal("mapper", "qti", ...)`, which is
`isDeclared("mapper/qti")` plus a load of `mapper.qti.so`. The declaration is
`<hal format="native"><name>mapper</name><fqname>@5.0/qti</fqname></hal>`, and it
comes from `hardware/qcom/display/gralloc/mapper.qti.xml`, installed by the caf
module `mapper.qti` (see `device-common.mk`). It is not repeated here.

## Verifying after a change

Two checks, in order:

1. `reconcile_fragments.py` reads the vintf paths from `proprietary-files.txt`,
   parses those fragments plus the caf-built ones out of the stock dump, and
   fails when an instance is declared twice or when a served HAL is declared
   nowhere. It printed zero duplicates for the current file.
2. `check_vintf_compat.py` checks every declared instance against FCM 202404
   merged with `framework_compatibility_matrix.xml`, which is the direction
   `assemble_vintf` enforces at build time.

`framework_compatibility_matrix.xml` is derived from `manifest.xml`: each
declared HAL whose name does not start with `android.` gets an `optional="true"`
entry (FCM 202404 covers `android.hardware.*`). Edit `manifest.xml` first, then
regenerate the matrix to match.

Both scripts are kept with the team artifacts, outside this repository.

## Known follow-ups

* `android.hardware.soundtrigger3`, `android.hardware.tetheroffload` and the
  keymint strongbox instance (`odm/overlayfs_origin` sku overlay) have
  fragments in the stock image but no service on this product; if one starts
  registering, the fragment already declares it.
* If a future blob refresh starts shipping a fragment for one of the five HALs
  above, drop that HAL here.
