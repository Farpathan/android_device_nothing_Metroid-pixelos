# Metroid device sepolicy

SELinux policy for the Nothing Phone (3), `Metroid` (Qualcomm SM8750 / `sun`,
`pakala` vendor platform), on Android 17.

## Wiring

`BoardConfigCommon.mk` must point the build at these three directories:

```make
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
```

The platform also pulls in `device/qcom/sepolicy` (QSSI), `device/qcom/sepolicy_vndr/sm8750`
and `device/lineage/sepolicy` from the manifest. This directory therefore contains only what
those do not: Nothing-specific files, properties, services and HAL extras.

## Layout

| Path | Contents |
|---|---|
| `vendor/*.te` | Device types and rules for vendor domains |
| `vendor/{file,genfs,property,service}_contexts` | Labels for Nothing nodes, props and AIDL services |
| `vendor/enforcing.te` | Rules collected from real enforcing boots (see below) |
| `private/` | `system_ext` private policy: `sltntc`, Glyph LED sysfs consumers, QTI telephony `seapp_contexts` |
| `public/` | Types shared between `system_ext` policy and the rest (`sltntc*`, `sysfs_led_driver_info`) |
| `private/compat/<api>/` | `new_objects` ignore lists for the four device-added public types |

## What upstream already labels: do not duplicate

`device/qcom/sepolicy_vndr` (`qva/` + `generic/vendor/sun`) labels every QTI service in the
stock dump: keymint (incl. SPU/strongbox), gatekeeper (incl. SPU), weaver, secure_element,
authsecret, spu, qseecom, identity, gnss, thermal, alarm, c2pa, perf2, lights, display colour,
servicetracker, pasrmanager, psiclient, minkipcbinder, qrtr-ns, camera provider, media c2,
qcrilNrd and `hostapd`. AOSP's own `vendor/file_contexts` labels the rest of the generic HALs.
Adding an entry for any of those here would only risk a conflicting label.

## Permissive domains and TODOs

* **No domain is permissive.** This policy ships no `permissive` statements.
* **TODO: unlabelled Nothing services.** `vendor.noth.hardware.sensor.sensor_extension-service`
  and `vendor.noth.hardware.stability-service` have no upstream SELinux type. They stay on
  `vendor_file`, so init refuses to start them under enforcing. They did not block boot on the
  reference enforcing boot; give them domains only when their interfaces are known.
* Most remaining `vendor_file` binaries in the dump (`/vendor/bin/*test*`, `agm*`, `diag_*`,
  `wdsdaemon`, ...) are factory/test tools that init never starts. They were unlabelled in the
  reference too.

## Note on the build flag

`BoardConfigCommon.mk` currently sets `androidboot.selinux=permissive`. Until that is removed,
this policy is loaded but not enforced: denials will not appear and `enforcing.te` will not be
exercised.

## The rules in `vendor/enforcing.te`

They were collected by booting the device with enforcing and reading:

```
adb shell 'logcat -d -b main,events,system | grep "avc: *denied"'
```

Use logcat, not dmesg: the kernel audit buffer is not readable by shell on this device. The file
records four passes, from 187 denials down to a clean enforcing boot.

## Verification

Checked against platform, QSSI, sepolicy_vndr (sm8750) and Lineage policy:

* every type used is declared in this tree or upstream
* nothing declared here is also declared upstream, and no context entry conflicts
* rules, parentheses and XML are well formed
