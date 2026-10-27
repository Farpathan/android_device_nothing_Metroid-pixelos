# configs/: files the device tree installs

* `config.fs` (`TARGET_FS_CONFIG_GEN`): Qualcomm vendor AIDs (2901..2917) and the
  `/vendor/{firmware_mnt,dsp,bt_firmware}` mountpoint directory entries that
  `build_image` needs to keep those empty directories in the vendor image.
* `configs.mk`: the `PRODUCT_COPY_FILES` list, inherited from `device-common.mk`.
* `audio/`, `permissions/`: files copied by `configs.mk` (see below).

## The rule: never copy what the blobs already ship

`PRODUCT_COPY_FILES` onto a destination that a vendor blob module installs is a
duplicate-destination build error. Nearly every config file the bring-up brief
mentions is already in `proprietary-files.txt` (i.e. `vendor/nothing/Metroid`),
so it is **not** copied here:

| file | shipped by blobs as | copied here? |
| --- | --- | --- |
| media codecs | `vendor/etc/media_codecs_tuna_v0.xml` | no |
| media codecs performance | `vendor/etc/media_codecs_performance_tuna_v0.xml` | no |
| media profiles | `vendor/etc/media_profiles_tuna_v0.xml` (selected by `ro.media.xml_variant.profiles=_tuna_v0`) | no |
| video system specs | `vendor/etc/media_{kera_v0,tuna_v0,tuna_v1}/video_system_specs.json` | no |
| wifi config | `vendor/etc/wifi/{WCNSS_qcom_cfg.ini,wpa_supplicant_overlay.conf,p2p_supplicant_overlay.conf,vendor_cmd.xml}` | no |
| sensors | `vendor/etc/sensors/hals.conf` | no |
| power | `vendor/etc/perf/powerhint.xml` (Qualcomm power HAL reads this, not a `powerhint.json`) | no |
| audio HAL module config | `vendor/etc/audio/audio_module_config_primary.xml` | no |
| QTI privapp permissions | `vendor/etc/permissions/privapp-permissions-qti-vendor.xml`, `system_ext/etc/permissions/privapp-permissions-qti-system-ext.xml`, `system_ext/etc/permissions/com.qti.qcc.vendor_qcc.xml` | no |

## What is copied, and from where

### `audio/` → `/vendor/etc/`

All four files are the stock `sku_tuna` files from the dump, byte for byte:

| source (dump) | destination |
| --- | --- |
| `vendor/etc/audio/sku_tuna/audio_policy_configuration.xml` | `/vendor/etc/audio_policy_configuration.xml` |
| `vendor/etc/audio/sku_tuna/audio_policy_volumes.xml` | `/vendor/etc/audio_policy_volumes.xml` |
| `vendor/etc/audio/sku_tuna/default_volume_tables.xml` | `/vendor/etc/default_volume_tables.xml` |
| `vendor/etc/audio/sku_tuna/r_submix_audio_policy_configuration.xml` | `/vendor/etc/r_submix_audio_policy_configuration.xml` |

Reason: the dump only ships this config set under `vendor/etc/audio/sku_tuna/`,
but the policy references `r_submix`, `audio_policy_volumes.xml` and
`default_volume_tables.xml` at the `/vendor/etc/` top level, and its two relative
includes resolve against the directory of the file being parsed. With the copies
above, the policy is complete wherever audioserver picks it up:

* `ro.boot.product.hardware.sku=tuna` (the stock bootloader sets it),
  audioserver uses `/vendor/etc/audio/sku_tuna/audio_policy_configuration.xml`
  and the copies are unused;
* no sku: audioserver uses the top-level copy, whose includes now resolve.

The other absolute includes of the policy
(`bluetooth_qti_hearing_aid_audio_policy_configuration.xml`,
`stub_audio_policy_configuration.xml`) are already at the top level in the blobs.

### `permissions/` → `/system_ext/etc/permissions/`

Stock permission grants whose files are **not** in the blob dump. They are
harmless if the package is absent (the policy is keyed by package name):

* `privapp-permissions-qti-telephony-service.xml`: `MODIFY_AUDIO_ROUTING` for
  `com.qualcomm.qti.telephonyservice`
* `privapp-permissions-qti-data-status.xml`: `READ_PRECISE_PHONE_STATE`,
  `WRITE_APN_SETTINGS` for `com.qti.qualcomm.datastatusnotification`
* `privapp-permissions-qti-qcc.xml`: `INTERACT_ACROSS_USERS` for `com.qti.qcc`
* `privapp-permissions-com.google.android.euicc.xml`,
  `default-permissions-com.google.android.euicc.xml`: EUICC (GMS) grants

None of those apps is in the current blob list, so today these files grant
nothing. They are kept so that a fixed-up blob list or a GMS-carrying build does
not hit a privapp-permissions denial.

## Verification

* `xmllint --noout` on every XML here.
* Every source path in `configs.mk` exists (checked with `test -f`).
* No destination string in `configs.mk` collides with a path in
  `proprietary-files.txt` (checked by comparing the destination list against the
  blob list).
