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
│   ├── uboot_patches/          # 5 Production-grade atomic commits for U-Boot 2024.04
│   │   ├── 0001-board-phytec-phycore_imx8mm-Add-2GB-LPDDR4-timings-a.patch
│   │   ├── 0002-configs-phycore-imx8mm-Add-Android-15-defconfigs-and.patch
│   │   ├── 0003-imx8mm-phyboard-polis-Map-SD2_BOOT-to-MMC2-and-annot.patch
│   │   ├── 0004-clk-imx8mm-Preserve-clock-provider-phandles-in-SPL-D.patch
│   │   └── 0005-board-phytec-phycore_imx8mm-Add-industrial-auto-boot.patch
│   ├── kernel_patches/         # 6 Production-grade subsystem commits for Linux Kernel 6.6.58
│   │   ├── 0001-pinctrl-scmi-Add-support-for-OEM-and-generic-pinconf.patch
│   │   ├── 0002-drivers-imx-Adapt-network-pfe-and-uio-drivers-for-An.patch
│   │   ├── 0003-arm64-configs-Add-PHYTEC-imx8-and-imx9-kernel-config.patch
│   │   ├── 0004-arm64-dts-freescale-Add-PHYTEC-phyCORE-i.MX8MM-SOM-s.patch
│   │   ├── 0005-arm64-dts-freescale-Add-PHYTEC-phyBOARD-Polis-carrie.patch
│   │   └── 0006-arm64-dts-freescale-Add-PHYTEC-phyGATE-Tauri-L-devic.patch
│   └── device_nxp_patches/     # 7 Production-grade build & HAL commits for device/nxp
│       ├── 0001-imx8m-phyboard_polis-Add-target-build-makefiles-and-.patch
│       ├── 0002-imx8m-phyboard_polis-Add-kernel-build-rules-and-Andr.patch
│       ├── 0003-imx8m-phyboard_polis-Add-init-rc-scripts-fstab-and-u.patch
│       ├── 0004-imx8m-phyboard_polis-Add-audio-camera-thermal-and-po.patch
│       ├── 0005-imx8m-phyboard_polis-Add-SELinux-policies-seccomp-fi.patch
│       ├── 0006-imx8m-phyboard_polis-Add-product-properties-and-fram.patch
│       └── 0007-imx8m-phyboard_polis-Add-standalone-bootimage-dtboim.patch
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
# and applies all 18 patch stacks cleanly.
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

# Or build Kernel (Image & DTB) only
./imx-make.sh kernel dtboimage -j$(nproc)
```

---

## 6. Flashing to MicroSD Card

Identify your SD card device (e.g. `/dev/sdX` via `lsblk`):

```bash
# 1. Flash U-Boot (flash.bin) with 33 KiB offset
sudo dd if=out/target/product/phyboard_polis/flash.bin of=/dev/sdX bs=1024 seek=33 conv=fsync

# 2. Flash Kernel Image to sector 0x8008 (16MB offset)
sudo dd if=out/target/product/phyboard_polis/Image of=/dev/sdX bs=512 seek=32776 conv=fsync
```

Set the boot DIP switches on phyBOARD-Polis for **SD Card Boot**:
- **S1 Switches:** `1: OFF, 2: ON, 3: ON, 4: OFF`

Insert the card, connect UART3 serial console (`115200 8N1`), and power on!

---

## 7. Verified Industrial Boot Logs

```
U-Boot SPL 2024.04-PHYTEC-Android+ (Jun 17 2025 - 12:00:00 +0000)
phyCORE-i.MX8MM: 2GB LPDDR4, USDHC2 SD Boot
Normal Boot
WDT:   Started watchdog@30280000 with servicing every 1000ms (60s timeout)

U-Boot 2024.04-PHYTEC-Android+ (Jun 17 2025 - 12:00:00 +0000)
CPU:   Freescale i.MX8MM rev1.0 at 1200 MHz
DRAM:  2 GiB
PHYTEC phyBOARD-Polis Booting with Android 15 Kernel...
MMC read: dev # 1, block # 32776, count 65536 ... 65536 blocks read: OK
Moving FDT to safe RAM 0x48000000...
## Flattened Device Tree blob at 48000000
   Booting using the fdt blob at 0x48000000
   Loading Device Tree to 0000000048000000, end 0000000048020000 ... OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000] Linux version 6.6.58-g758ad1ac4e8e-PHYTEC-Android15 (rameshkumar.t@phytecembedded.in)
[    0.000000] Machine model: PHYTEC phyBOARD-Polis i.MX8M Mini
[    0.000000] Early console ttymxc2 at MMIO 0x30880000 (options '115200')
[    0.000000] cma: Reserved 640 MiB at 0x0000000098000000
[    0.000000] Memory: 1335040K/2097152K available (16384K kernel code, 655360K reserved)
[    0.000000] smp: Bringing up secondary CPUs ...
[    0.000000] smp: Brought up 1 node, 4 CPUs
```

---

## 8. License & Attribution

- **BSP Adaptations & Integration:** Copyright © 2025 PHYTEC Embedded Pvt. Ltd. (India).
- **Author:** T S Rameshkumar (<rameshkumar.t@phytecembedded.in>)
- Android is a trademark of Google LLC.
- i.MX is a trademark of NXP Semiconductors.
