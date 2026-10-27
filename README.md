# PHYTEC phyBOARD-Polis i.MX8M Mini — Android 15 BSP Release

[![Android](https://img.shields.io/badge/Android-15.0.0__1.2.0-green.svg)](https://source.android.com/)
[![Kernel](https://img.shields.io/badge/Linux%20Kernel-6.6.58%20GKI-blue.svg)](https://kernel.org/)
[![U-Boot](https://img.shields.io/badge/U--Boot-2024.04--PHYTEC-orange.svg)](https://www.denx.de/wiki/U-Boot)
[![PHYTEC](https://img.shields.io/badge/PHYTEC-Embedded%20Pvt%20Ltd-red.svg)](https://www.phytecembedded.in)

**Author:** T S Rameshkumar (<rameshkumar.t@phytecembedded.in>)  
**Organization:** PHYTEC Embedded Pvt. Ltd. (India)  
**Hardware Platform:** PHYTEC phyBOARD-Polis i.MX8M Mini (PCM-066 / PCL-069 SOM)  
**SoC:** NXP® i.MX 8M Mini Quad (4x ARM® Cortex®-A53 @ 1.8GHz, 1x Cortex®-M4F)  

---

## 1. Hardware Specifications

| Component | Specification |
| :--- | :--- |
| **System-on-Module** | PHYTEC phyCORE-i.MX8MM (PCM-066 / PCL-069) |
| **Carrier Board** | PHYTEC phyBOARD-Polis (PB-02820) |
| **RAM** | 2GB Micron LPDDR4 SDRAM (3000 MT/s, 16-bit bus) |
| **Storage / Boot** | USDHC2 (MicroSD Slot, mapped as MMC2 in SPL / MMC1 in U-Boot proper) |
| **eMMC** | USDHC3 (Onboard 8GB/16GB eMMC, mapped as MMC1 in SPL / MMC2 in U-Boot proper) |
| **Console Port** | UART3 (`ttymxc2`), 115200 baud, 8N1 |
| **Ethernet** | Gigabit Ethernet (Micrel KSZ9131RNX PHY) |
| **PMIC** | ROHM BD71847MWV |

---

## 2. Software Architecture

```
+--------------------------------------------------------------------------+
|                     Android 15 Userspace (AOSP 15.0.0_1.2.0)             |
|                 Product Target: phyboard_polis-userdebug                 |
+--------------------------------------------------------------------------+
|          Android HAL Layer: Audio, Camera, Health, Power, Thermal         |
+--------------------------------------------------------------------------+
|       Linux Kernel 6.6.58 (Android 15 GKI Compliant - ARM64 Architecture) |
|       Device Tree: imx8mm-phyboard-polis-rdk.dtb                         |
+--------------------------------------------------------------------------+
|       U-Boot 2024.04 (SPL + BL31 ATF v2.10.0 + Industrial Autoboot)      |
+--------------------------------------------------------------------------+
|                     PHYTEC phyBOARD-Polis i.MX8MM Silicon                 |
+--------------------------------------------------------------------------+
```

---

## 3. Repository Structure

```
.
├── phytec_phyboard_polis_android_setup.sh     # Industrial 1-click BSP setup & patch automation script
├── patches/
│   ├── uboot_patches/          # 7 Production-grade atomic commits for U-Boot 2024.04
│   │   ├── 0001-board-phytec-phycore_imx8mm-Add-2GB-LPDDR4-timings-a.patch
│   │   ├── 0002-configs-phycore-imx8mm-Add-Android-15-defconfigs-and.patch
│   │   ├── 0003-imx8mm-phyboard-polis-Map-SD2_BOOT-to-MMC2-and-annot.patch
│   │   ├── 0004-clk-imx8mm-Preserve-clock-provider-phandles-in-SPL-D.patch
│   │   ├── 0005-board-phytec-phycore_imx8mm-Add-industrial-auto-boot.patch
│   │   ├── 0006-board-phytec-phycore_imx8mm-Enable-native-boota-comm.patch
│   │   └── 0007-configs-phycore_imx8mm_android-Configure-800M-CMA-po.patch
│   ├── kernel_patches/         # 9 Production-grade subsystem commits for Linux Kernel 6.6.58
│   │   ├── 0001-pinctrl-scmi-Add-support-for-OEM-and-generic-pinconf.patch
│   │   ├── 0002-drivers-imx-Adapt-network-pfe-and-uio-drivers-for-An.patch
│   │   ├── 0003-arm64-configs-Add-PHYTEC-imx8-and-imx9-kernel-config.patch
│   │   ├── 0004-arm64-dts-freescale-Add-PHYTEC-phyCORE-i.MX8MM-SOM-s.patch
│   │   ├── 0005-arm64-dts-freescale-Add-PHYTEC-phyBOARD-Polis-carrie.patch
│   │   ├── 0006-arm64-dts-freescale-Add-PHYTEC-phyGATE-Tauri-L-devic.patch
│   │   ├── 0007-arm64-dts-imx8mm-phyboard-polis-Include-imx8mm-andro.patch
│   │   ├── 0008-clk-imx8mm-Register-UART3-as-critical-clock-and-add-.patch
│   │   └── 0009-drm-bridge-sn65dsi83-Add-ETML1010G3DRA-LVDS-panel-an.patch
│   ├── device_nxp_patches/     # 17 Production-grade build & HAL commits for device/nxp
│   │   ├── 0001-imx8m-phyboard_polis-Add-target-build-makefiles-and-.patch
│   │   ├── 0002-imx8m-phyboard_polis-Add-kernel-build-rules-and-Andr.patch
│   │   ├── 0003-imx8m-phyboard_polis-Add-init-rc-scripts-fstab-and-u.patch
│   │   ├── 0004-imx8m-phyboard_polis-Add-audio-camera-thermal-and-po.patch
│   │   ├── 0005-imx8m-phyboard_polis-Add-SELinux-policies-seccomp-fi.patch
│   │   ├── 0006-imx8m-phyboard_polis-Add-product-properties-and-fram.patch
│   │   ├── 0007-imx8m-phyboard_polis-Add-standalone-bootimage-dtboim.patch
│   │   ├── 0008-imx8m-phyboard_polis-Prune-built-in-and-inactive-dri.patch
│   │   ├── 0009-imx8m-phyboard_polis-Add-UART3-earlycon-to-BOARD_KER.patch
│   │   ├── 0010-imx8m-phyboard_polis-Align-GKI-defconfig-and-disable.patch
│   │   ├── 0011-imx8m-phyboard_polis-Prune-CONFIG_FEC_UIO-and-enable.patch
│   │   ├── 0012-imx8m-phyboard_polis-Restore-missing-GKI-vendor-ramd.patch
│   │   ├── 0013-imx8m-phyboard_polis-Prioritize-pinctrl-and-serial-d.patch
│   │   ├── 0014-imx8m-phyboard_polis-Enable-PF8x00-PMIC-regulator-mo.patch
│   │   ├── 0015-imx8m-phyboard_polis-Set-interactive-console-HOSTNAM.patch
│   │   ├── 0016-imx8m-phyboard_polis-Add-PEB-AV-10-LVDS-DTBO-target-.patch
│   │   └── 0017-imx8m-phyboard_polis-Configure-PEB-AV-10-LVDS-displa.patch
│   ├── build_soong_patches/    # 1 Build system fix for out-of-tree artifacts
│   │   └── 0001-dexpreopt_gen-Support-absolute-product_packages-path.patch
│   └── build_make_patches/     # 1 Lunch shortcut configuration
│       └── 0001-envsetup-Support-simplified-lunch-combo-phyboard_pol.patch
├── configs/
│   ├── imx8mm_phycore_android_defconfig  # U-Boot Android 15 defconfig
│   └── phycore_imx8mm.env                # Clean, industrial U-Boot autoboot environment
└── manifests/
    ├── phytec-android-15.0.0_1.2.0.xml   # Standalone Repo manifest XML
    ├── imx-android-15.0.0_1.2.0.xml      # NXP base manifest
    └── aosp-android-15.0.0_1.2.0.xml     # Google AOSP base manifest
```

---

## 4. Quick Start: Setting Up the BSP

### Prerequisites
- **Host OS:** Ubuntu 22.04 LTS (x86_64)
- **Disk Space:** At least 300 GB free disk space
- **Google `repo` Tool:**
  ```bash
  mkdir -p ~/bin
  curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
  chmod a+x ~/bin/repo
  export PATH=${PATH}:~/bin
  ```

- **Required Host Packages:**
  ```bash
  sudo apt update
  sudo apt install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev \
      libc6-dev-i386 libncurses5 x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
      libxml2-utils xsltproc unzip fontconfig libssl-dev bc rsync libyaml-dev gcc-aarch64-linux-gnu
  ```

---

### Cross-Compiler Toolchain (ARM64)
U-Boot and ATF compilation require the **Arm GNU Toolchain 11.3.rel1** (`aarch64-none-linux-gnu-`):
* **Automatic:** `phytec_phyboard_polis_android_setup.sh` automatically detects or downloads and extracts the toolchain from the official Arm Developer CDN if missing.
* **Manual Link (for reference):**
  ```bash
  wget https://developer.arm.com/-/media/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
  tar -xf arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
  ```

---

### Step-by-Step Setup Procedure

#### Step 1: Clone this Repository
```bash
git clone git@github.com:Rameshkumar-Phytec/phyboard-polis-imx8mm-android15.git
cd phyboard-polis-imx8mm-android15
```

#### Step 2: Run the Automated Setup Script
```bash
# This fetches NXP Android 15.0.0_1.2.0, installs proprietary vendor blobs,
# auto-configures the cross-toolchain, creates dedicated PHYTEC branches,
# and applies all 35 patch stacks cleanly.
source ./phytec_phyboard_polis_android_setup.sh
```

---

## 5. Building the Android BSP

From inside the generated `android_build/` directory:

### 1. Initialize Android Build Environment
```bash
cd android_build
source build/envsetup.sh
```

### 2. Choose the PHYTEC Lunch Combo
```bash
lunch phyboard_polis-userdebug
```

### 3. Build Images
```bash
# Full Android build
./imx-make.sh -j$(nproc) 2>&1 | tee build-log.txt

# Or build Bootloader (flash.bin) only
./imx-make.sh bootloader -j$(nproc)

# Or build Kernel (Image, DTBOs) only
./imx-make.sh kernel dtboimage -j$(nproc)
```

---

## 6. Flashing to MicroSD Card

Identify your SD card device (e.g. `/dev/sdX` via `lsblk`). When writing complete partition images built under `out/target/product/phyboard_polis/`:

### 1. Flash Bootloader (U-Boot SPL + Proper)
```bash
# Flash U-Boot (flash.bin) with 33 KiB offset
sudo dd if=out/target/product/phyboard_polis/flash.bin of=/dev/sdX bs=1024 seek=33 conv=fsync
```

### 2. Standard Android Partition Layout (GPT)
Flash the individual partition images to their respective GPT partition slots:

| Partition | Target Partition Device | Source Image File | Description |
| :--- | :--- | :--- | :--- |
| `dtbo_a` | `/dev/sdX1` | `dtbo-imx8mm.img` | Device Tree Blob Overlay |
| `boot_a` | `/dev/sdX3` | `boot.img` | Android 15 GKI Kernel (6.6.58) |
| `init_boot_a` | `/dev/sdX5` | `init_boot.img` | Generic First-Stage Ramdisk |
| `vendor_boot_a` | `/dev/sdX7` | `vendor_boot.img` | PHYTEC Vendor Ramdisk & DTB |
| `super` | `/dev/sdX12` | `super.img` | Android System, Vendor, Product, System Ext |
| `vbmeta_a` | `/dev/sdX15` | `vbmeta-imx8mm.img` | Verified Boot Metadata (AVB) |

```bash
# Example flashing script:
sudo dd if=out/target/product/phyboard_polis/dtbo-imx8mm.img of=/dev/sdX1 bs=4M conv=fsync
sudo dd if=out/target/product/phyboard_polis/boot.img of=/dev/sdX3 bs=4M conv=fsync
sudo dd if=out/target/product/phyboard_polis/init_boot.img of=/dev/sdX5 bs=4M conv=fsync
sudo dd if=out/target/product/phyboard_polis/vendor_boot.img of=/dev/sdX7 bs=4M conv=fsync
sudo dd if=out/target/product/phyboard_polis/super.img of=/dev/sdX12 bs=4M status=progress conv=fsync
sudo dd if=out/target/product/phyboard_polis/vbmeta-imx8mm.img of=/dev/sdX15 bs=4M conv=fsync
```

Set the boot DIP switches on phyBOARD-Polis for **SD Card Boot**:
- **S1 Switches:** `1: OFF, 2: ON, 3: ON, 4: OFF`

Insert the card, connect UART3 serial console (`115200 8N1`), and power on!

---

## 7. Hardware Bring-Up & Verification Status

| Subsystem / Layer | Silicon Verification Status | Verification Details |
| :--- | :--- | :--- |
| **U-Boot 2024.04 (SPL + Proper)** | 🟢 **Verified on Hardware Silicon** | • Micron 2GB LPDDR4 @ 3000 MT/s initialized<br>• USDHC2 MicroSD boot mapped (MMC2 SPL / MMC1 Proper)<br>• ATF BL31 v2.10.0 loaded at EL3<br>• Native `boota` autoboot with AVB slot selection<br>• Safe FDT relocation & 800MB CMA pool configured |
| **Linux Kernel 6.6.58 (ARM64 GKI)** | 🟢 **Verified on Hardware Silicon** | • Booted across all 4 Cortex-A53 cores at EL2<br>• GICv3, PSCI 1.1, ROHM BD71847 PMIC probed<br>• Gigabit Ethernet (Micrel KSZ9131RNX PHY) active<br>• Runtime console verified on UART3 (`ttymxc2` @ 115200) |
| **Display & Graphics (PEB-AV-10 LVDS)** | 🟢 **Verified on Hardware Silicon** | • EDT ETML1010G3DRA 10.1" WXGA LVDS display (1280x800)<br>• On-SOM TI SN65DSI83 DSI-to-LVDS bridge chip bound (`0x2d`)<br>• SurfaceFlinger HWC display active (`port=1 displayName="NXP Android"`)<br>• DRM connector `card0-LVDS-1` reported `connected`<br>• PWM4 backlight controllable via sysfs |
| **Android 15 Userspace & Services** | 🟢 **Verified on Hardware Silicon** | • Android 15.0.0_1.2.0 booted to graphical user desktop<br>• AVB dm-verity active with partition hash integrity<br>• HALs: Graphics Allocator, Mapper, Audio, Health, Thermal online<br>• Interactive root shell configured (`phyboard_polis:/ #`) |

### Verified Hardware Display Status & Diagnostics

```text
phyboard_polis:/ # dumpsys SurfaceFlinger --display-id
Display 4628311721810978561 (HWC display 0): port=1 pnpId=NXP displayName="NXP Android"

phyboard_polis:/ # cat /sys/class/drm/card0-LVDS-1/status
connected

phyboard_polis:/ # cat /sys/class/drm/card0-LVDS-1/modes
1280x800

phyboard_polis:/ # i2cdetect -y 0
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:                         -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- UU -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

phyboard_polis:/ # echo 6 > /sys/class/backlight/backlight/brightness
```

---

## 8. License & Attribution

- **BSP Adaptations & Integration:** Copyright © 2025 PHYTEC Embedded Pvt. Ltd. (India).
- **Author:** T S Rameshkumar (<rameshkumar.t@phytecembedded.in>)
- Android is a trademark of Google LLC.
- i.MX is a trademark of NXP Semiconductors.
