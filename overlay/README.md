# Runtime resource overlays

Static RRO modules for the Nothing Phone (3) (`Metroid`), installed via
`PRODUCT_PACKAGES` in `device-common.mk`.

Values are taken from the previous bring-up attempt
(`Farpathan/android_device_nothing_Metroid-pixelos`, branch `seventeen`), which
traced them to the stock NothingOS firmware (1260 x 2800 native panel, vendor
SKU `sun`); see the per-file comments and the table below. Where a stock APK
name is cited, it is the stock overlay APK the values were extracted from.

| Module | Target package | Covers | Source of values |
| :--- | :--- | :--- | :--- |
| `MetroidFrameworksResOverlay` | `android` | display cutout + shape, rounded corners, status bar heights, auto-brightness curve, UDFPS sensor props, peak refresh rate 120 Hz, IMS/iwlan services, eUICC slot, power profile | stock `FrameworksResCommon_Sys_Metroid.apk` (extracted 2026-07-10 by the previous attempt) and stock config; UDFPS props derived from the live HAL (`getSensorProps` 540/2176/92 in 1080x2400 space, scaled 7/6) |
| `NTSystemUIResTarget` | `com.android.systemui` | UDFPS overlay max refresh rate, keyguard margins, UDFPS icon pixel pitch | stock SystemUI config |
| `MetroidSettingsOverlay` | `com.android.settings` | UDFPS enrollment progress bar, UDFPS enrollment artwork height, face-enroll education strings | stock Settings resources |
| `MetroidTelephonyOverlay` | `com.android.phone` | QTI IMS package (`org.codeaurora.ims`) | stock Telephony config |
| `CarrierConfigOverlayMetroid` | `com.android.carrierconfig` | per-MCC/MNC VoLTE/VoWiFi/carrier config (US carriers, Tele2, AT&T) | stock carrier config |
| `MetroidConnectivityOverlay` | `com.android.connectivity.resources` | exclude `usb0` from Ethernet IpClient | previous attempt (device-specific fix) |
| `MetroidTetheringOverlay` | `com.android.networkstack.tethering` | NCM tethering regexes | previous attempt (device-specific fix) |
| `MetroidWifiOverlay` | `com.android.wifi.resources` | 5/6 GHz, softap ACS/11ac | stock wifi config |
| `MetroidApertureOverlay` | `org.lineageos.aperture` | aux cameras, logical zoom ratios, FHD60 routing | stock camera config |
| `MetroidLineageSdkOverlay` | `org.lineageos.platform` | Essential Key handler (`MetroidKeyHandler.jar`: not yet in this tree, see TODO) | previous attempt |

PixelOS-specific overlays (for PixelOS's SystemUI/Settings extras) could not be
derived from the sources available on this machine (no PixelOS source tree and
no stock `product/overlay` APKs in the dump). `rro_overlays/` is reserved for
them; add modules there once the PixelOS source is available on the build
server.
