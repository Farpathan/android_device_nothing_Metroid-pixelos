# Android Recovery Device Tree for Nothing Phone (3) (`Metroid`)

[![Device](https://img.shields.io/badge/Device-Nothing%20Phone%20(3)-000000?style=for-the-badge&logo=nothing)](https://nothing.tech)
[![Codename](https://img.shields.io/badge/Codename-Metroid%20%2F%20A024-blue?style=for-the-badge)](#device-specifications)
[![SoC](https://img.shields.io/badge/SoC-Qualcomm%20SM8735-red?style=for-the-badge&logo=qualcomm)](https://qualcomm.com)
[![Releases](https://img.shields.io/github/v/release/Farpathan/android_device_nothing_metroid?style=for-the-badge&color=success)](https://github.com/Farpathan/android_device_nothing_metroid/releases)

Unified Android recovery device tree for the **Nothing Phone (3)** (codename: `Metroid`, model: `A024`), featuring production bringups for both **OrangeFox Recovery Project** and **PitchBlack Recovery Project (PBRP)** with full hardware-wrapped File-Based Encryption (FBE v2) decryption.

---

## 🧭 Branch Directory

This repository maintains separate branches tailored to each recovery framework's build system and flags:

| Branch | Description | Latest Release |
| :--- | :--- | :--- |
| [`main`](https://github.com/Farpathan/android_device_nothing_metroid/tree/main) | **Base Device Tree**: Common recovery configurations, fstab, and documentation | Index / Home |
| [`fox_12.1`](https://github.com/Farpathan/android_device_nothing_metroid/tree/fox_12.1) | **OrangeFox Recovery Project**: Based on Android 12.1 minimal tree with OF UI, AIDL Gatekeeper & Keystore2 patches | [`ofox-R12.0_1-v0.5.0`](https://github.com/Farpathan/android_device_nothing_metroid/releases/tag/ofox-R12.0_1-v0.5.0) |
| [`pbrp`](https://github.com/Farpathan/android_device_nothing_metroid/tree/pbrp) | **PitchBlack Recovery Project**: Based on PBRP 4.0 / TWRP 3.7.1 with custom strobing flashlight and sysfs haptics | [`pbrp-v4.0-20261018`](https://github.com/Farpathan/android_device_nothing_metroid/releases/tag/pbrp-v4.0-20261018) |

---

## 📱 Device Specifications

| Feature | Specification |
| :--- | :--- |
| **Model** | Nothing Phone (3) (`A024`, `MetroidIND`) |
| **Chipset** | Qualcomm Snapdragon SM8735 (8s Gen 4 / tuna / sun) |
| **CPU** | Octa-core Kryo (1x Cortex-X4 + 4x Cortex-A720 + 3x Cortex-A520) |
| **GPU** | Adreno 830 |
| **Memory** | 8 GB / 12 GB / 16 GB LPDDR5X |
| **Storage** | 256 GB / 512 GB UFS 4.0 |
| **Display** | 6.7" Flexible AMOLED, 1260 × 2800 pixels, 120Hz refresh rate |
| **Battery** | 5000 mAh, 65W fast charging, Qi wireless charging |
| **Audio & Haptics** | Dual stereo speakers, RichTap haptics (`vibrator_nt`) |
| **OS at Launch** | Android 15 / Nothing OS 3.x (Kernel 6.1 LTS / 6.6) |

---

## 📊 Feature Status Matrix

| Feature | OrangeFox (`fox_12.1`) | PitchBlack (`pbrp`) | Notes |
| :--- | :---: | :---: | :--- |
| **Boot & GUI** | ✅ Working | ✅ Working | Native 1260x2800 rendering with custom dimming |
| **Touchscreen** | ✅ Working | ✅ Working | FocalTech FT3681 (`fts_ts`) with 120Hz input |
| **FBE v2 Decryption** | ✅ Working | ✅ Working | TrustZone KeyMint + AIDL Gatekeeper (`sun` SKU) |
| **Haptics** | ✅ Working | ✅ Working | Sysfs pulse driver (`/sys/class/leds/vibrator_nt`) |
| **Flashlight / Torch** | ✅ Working | ✅ Working | Rear dual-LED strobe (`led:torch_0` + `led:switch_0`) |
| **MTP File Transfer** | ✅ Working | ✅ Working | High-speed USB transfer to `/data/media/0` |
| **Backup / Restore** | ✅ Working | ✅ Working | Boot, DTBO, Data, System, Vendor, EFS, Modem |
| **ADB & Sideload** | ✅ Working | ✅ Working | Full root shell and OTA/ZIP sideload |
| **Fastbootd** | ✅ Working | ✅ Working | Userspace fastboot partition flashing |

---

## 📦 Releases & Downloads

Check the [Releases](https://github.com/Farpathan/android_device_nothing_metroid/releases) tab for pre-built recovery images and flashable zips:

* **PitchBlack Recovery Project**:
  * [**PBRP 4.0 - Latest Release (`pbrp-v4.0-20261018`)**](https://github.com/Farpathan/android_device_nothing_metroid/releases/tag/pbrp-v4.0-20261018)
* **OrangeFox Recovery Project**:
  * [**OrangeFox R12.0_1 - Latest Release (`ofox-R12.0_1-v0.5.0`)**](https://github.com/Farpathan/android_device_nothing_metroid/releases/tag/ofox-R12.0_1-v0.5.0)
  * [Older OrangeFox Builds (`ofox-v0.4.0`, `ofox-v0.3.0`, `ofox-v0.2.0`, `ofox-v0.1.0`)](https://github.com/Farpathan/android_device_nothing_metroid/releases)

---

## 🚀 Installation

### Option 1: Fastboot Flash (Direct recovery image)

1. Reboot your phone into bootloader:
   ```bash
   adb reboot bootloader
   ```
2. Verify fastboot connectivity:
   ```bash
   fastboot devices
   ```
3. Flash the recovery image to the recovery partition:
   ```bash
   # For OrangeFox:
   fastboot flash recovery OrangeFox-R12.0_1-Unofficial-Metroid.img

   # For PBRP:
   fastboot flash recovery PBRP-v4.0-Unofficial-Metroid.img
   ```
4. Reboot into recovery:
   ```bash
   fastboot reboot recovery
   ```

### Option 2: Flashable ZIP (Via custom recovery)

1. Boot into an existing working custom recovery.
2. Transfer the `.zip` file to internal storage or USB-OTG.
3. Select **Install** -> Select recovery zip -> Swipe to confirm flash.

---

## 🛠️ Building from Source

### Building OrangeFox (`fox_12.1`)
```bash
# Sync OrangeFox 12.1 minimal manifest
repo init --depth=1 -u https://gitlab.com/OrangeFox/manifest.git -b fox_12.1
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# Clone device tree on fox_12.1 branch
git clone https://github.com/Farpathan/android_device_nothing_metroid.git -b fox_12.1 device/nothing/Metroid

# Setup environment & build
. build/envsetup.sh
lunch twrp_Metroid-eng
mka recoveryimage -j$(nproc --all)
```

### Building PBRP (`pbrp`)
```bash
# Sync PBRP 12.1 minimal manifest
repo init --depth=1 -u https://github.com/PitchBlackRecoveryProject/manifest_pb -b android-12.1
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# Clone device tree on pbrp branch
git clone https://github.com/Farpathan/android_device_nothing_metroid.git -b pbrp device/nothing/Metroid

# Setup environment & build
. build/envsetup.sh
lunch pb_Metroid-eng
mka recoveryimage -j$(nproc --all)
```

---

## 🤝 Credits & Acknowledgements

* **Nothing Technology Limited** - Kernel source and device hardware
* **Qualcomm Technologies, Inc.** - Snapdragon SM8735 platform
* **TeamWin Recovery Project (TWRP)** - Recovery base and openrecoveryscript engine
* **The OrangeFox Recovery Project** - OrangeFox GUI, Fox vendor tools, and theme engine
* **PitchBlack Recovery Project (PBRP)** - PBRP GUI, customization, and tool suite
* **Community Contributors & Testers**
