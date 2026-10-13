# PHYTEC phyBOARD-Polis i.MX8M Mini — Android BSP Portal

[![Android](https://img.shields.io/badge/Android-15.0.0__1.2.0-green.svg)](https://source.android.com/)
[![Kernel](https://img.shields.io/badge/Linux%20Kernel-6.6.58%20GKI-blue.svg)](https://kernel.org/)
[![U-Boot](https://img.shields.io/badge/U--Boot-2024.04--PHYTEC-orange.svg)](https://www.denx.de/wiki/U-Boot)
[![PHYTEC](https://img.shields.io/badge/PHYTEC-Embedded%20Pvt%20Ltd-red.svg)](https://www.phytecembedded.in)
[![Release](https://img.shields.io/badge/Release-v15.0.0__1.2.0--alpha-purple.svg)](https://github.com/Rameshkumar-Phytec/phyboard-polis-imx8mm-android15/tree/rel-android-15.0.0_1.2.0-alpha)

**Author:** T S Rameshkumar (<rameshkumar.t@phytecembedded.in>)  
**Organization:** PHYTEC Embedded Pvt. Ltd. (India)  
**Target Platform:** PHYTEC phyBOARD-Polis i.MX8M Mini (PCM-066 / PCL-069 System-on-Module)  
**SoC:** NXP® i.MX 8M Mini Quad (4x ARM® Cortex®-A53 @ 1.8GHz, 1x Cortex®-M4F)  

---

## 1. Project Overview

Welcome to the **PHYTEC phyBOARD-Polis i.MX8M Mini Android BSP** project repository. 

This repository serves as the central hub for running modern Android on industrial PHYTEC i.MX8M Mini hardware. It provides production-grade patch stacks, automated workspace initialization tooling, Repo manifests, and complete documentation for board bring-up and image building.

---

## 2. Hardware Support

| Component | Specification |
| :--- | :--- |
| **System-on-Module** | PHYTEC phyCORE-i.MX8MM (PCM-066 / PCL-069) |
| **Carrier Board** | PHYTEC phyBOARD-Polis (PB-02820) |
| **Processor** | NXP i.MX 8M Mini Quad (ARMv8 64-bit) |
| **RAM** | 2GB Micron LPDDR4 SDRAM (3000 MT/s, 16-bit bus) |
| **Boot Media** | USDHC2 (MicroSD Slot) / USDHC3 (Onboard eMMC) |
| **Serial Console** | UART3 (`ttymxc2`) @ 115200 baud, 8N1 |
| **Power Management** | ROHM BD71847MWV PMIC |
| **Ethernet** | Gigabit Ethernet (Micrel KSZ9131RNX PHY) |

---

## 3. Releases & Branches

The `main` branch functions as the repository project index. All BSP payloads, patch series, configurations, and automated setup scripts are maintained in dedicated release branches and tags:

| Release / Branch | Tag | Status | Description |
| :--- | :--- | :--- | :--- |
| [`rel-android-15.0.0_1.2.0-alpha`](https://github.com/Rameshkumar-Phytec/phyboard-polis-imx8mm-android15/tree/rel-android-15.0.0_1.2.0-alpha) | [`v15.0.0_1.2.0-alpha`](https://github.com/Rameshkumar-Phytec/phyboard-polis-imx8mm-android15/releases/tag/v15.0.0_1.2.0-alpha) | **Active / Silicon-Verified** | **Android 15 Alpha Release**<br>• Linux Kernel 6.6.58 (Android 15 GKI)<br>• U-Boot 2024.04 with Zero-Touch Industrial Autoboot<br>• 1-Click setup script (`phytec_phyboard_polis_android_setup.sh`)<br>• 18 stacked production patches (U-Boot, Kernel, Device/HAL) |

---

## 4. Quick Start: Checking Out the Alpha Release

To get the full BSP, setup scripts, and patch series, clone the **`rel-android-15.0.0_1.2.0-alpha`** branch:

```bash
# Clone the Alpha Release branch
git clone -b rel-android-15.0.0_1.2.0-alpha https://github.com/Rameshkumar-Phytec/phyboard-polis-imx8mm-android15.git
cd phyboard-polis-imx8mm-android15

# Run the 1-click automated setup script
# (Fetches AOSP/NXP Android 15, auto-downloads toolchain, and applies all patches)
source ./phytec_phyboard_polis_android_setup.sh

# Build Android 15
cd android_build
source build/envsetup.sh
lunch phyboard_polis-userdebug
./imx-make.sh -j$(nproc) 2>&1 | tee build-log.txt
```

---

## 5. Hardware Bring-Up & Verification Status

| Subsystem / Layer | Silicon Verification Status | Verification Details |
| :--- | :--- | :--- |
| **U-Boot 2024.04 (SPL + Proper)** | 🟢 **Verified on Hardware Silicon** | • Micron 2GB LPDDR4 @ 3000 MT/s initialized<br>• USDHC2 MicroSD boot mapped (MMC2 SPL / MMC1 Proper)<br>• ATF BL31 v2.10.0 loaded at EL3<br>• Zero-touch industrial autoboot from MMC sector `0x8008`<br>• Safe FDT relocation to `0x48000000` |
| **Linux Kernel 6.6.58 (ARM64 GKI)** | 🟢 **Verified on Hardware Silicon** | • Booted across all 4 Cortex-A53 cores at EL2<br>• GICv3, PSCI 1.1, ROHM BD71847 PMIC probed<br>• 2GB RAM / 640MB CMA allocated<br>• Early & runtime console verified on UART3 (`ttymxc2` @ 115200) |
| **Android 15 Userspace & HALs** | 🟡 **Ported / Untested on Silicon** | • Board target `phyboard_polis-userdebug` configured<br>• Makefiles, `fstab.nxp`, `init.rc`, and HAL configs created<br>• Full userspace graphics/UI verification currently in progress |

---

## 6. License & Attribution

- **BSP Adaptations & Integration:** Copyright © 2025 PHYTEC Embedded Pvt. Ltd. (India).
- **Author:** T S Rameshkumar (<rameshkumar.t@phytecembedded.in>)
- Android is a trademark of Google LLC.
- i.MX is a trademark of NXP Semiconductors.
