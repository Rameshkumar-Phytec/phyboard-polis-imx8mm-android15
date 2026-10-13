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

## 7. Hardware Bring-Up & Verification Status

| Subsystem / Layer | Silicon Verification Status | Verification Details |
| :--- | :--- | :--- |
| **U-Boot 2024.04 (SPL + Proper)** | 🟢 **Verified on Hardware Silicon** | • Micron 2GB LPDDR4 @ 3000 MT/s initialized<br>• USDHC2 MicroSD boot mapped (MMC2 SPL / MMC1 Proper)<br>• ATF BL31 v2.10.0 loaded at EL3<br>• Zero-touch industrial autoboot from MMC sector `0x8008`<br>• Safe FDT relocation to `0x48000000` |
| **Linux Kernel 6.6.58 (ARM64 GKI)** | 🟢 **Verified on Hardware Silicon** | • Booted across all 4 Cortex-A53 cores at EL2<br>• GICv3, PSCI 1.1, ROHM BD71847 PMIC probed<br>• 2GB RAM / 640MB CMA allocated<br>• Early & runtime console verified on UART3 (`ttymxc2` @ 115200) |
| **Android 15 Userspace & HALs** | 🟡 **Ported / Untested on Silicon** | • Board target `phyboard_polis-userdebug` configured<br>• Makefiles, `fstab.nxp`, `init.rc`, and HAL configs created<br>• Full userspace graphics/UI verification currently in progress |

### Verified Hardware Boot Log (UART3 Console)
```text
U-Boot SPL 2024.04-PHYTEC-Android+ (Oct 13 2026 - 13:31:24 +0530)
DDRINFO: start DRAM init
DDRINFO: DRAM rate 3000MTS
DDRINFO:ddrphy calibration done
DDRINFO: ddrmix config done
Normal Boot
WDT:   Started watchdog@30280000 with servicing every 1000ms (60s timeout)
Trying to boot from MMC2
NOTICE:  Do not release JR0 to NS as it can be used by HAB
NOTICE:  BL31: v2.10.0  (release):automotive-15.0.0_1.3.0
NOTICE:  BL31: Built : 13:32:14, Oct 13 2026


U-Boot 2024.04-PHYTEC-Android+ (Oct 13 2026 - 13:31:24 +0530)

CPU:   i.MX8MMQ rev1.0 1600 MHz (running at 1200 MHz)
CPU:   Industrial temperature grade (-40C to 105C) at 37C
Reset cause: POR
Model: PHYTEC phyBOARD-Polis-i.MX8MM RDK
DRAM:  2 GiB
optee optee: OP-TEE api uid mismatch
board_init: EEPROM data init failed
Core:  110 devices, 27 uclasses, devicetree: separate
WDT:   Started watchdog@30280000 with servicing every 1000ms (60s timeout)
MMC:   FSL_SDHC: 0, FSL_SDHC: 1, FSL_SDHC: 2
Loading Environment from MMC... *** Warning - bad CRC, using default environment

In:    serial@30880000
Out:   serial@30880000
Err:   serial@30880000
flash target is MMC:1
Net:   eth0: ethernet@30be0000
...
u-boot=> mmc dev 1
switch to partitions #0, OK
mmc1 is current device
u-boot=> mmc read 0x40480000 0x8008 0x10000

MMC read: dev # 1, block # 32776, count 65536 ... 65536 blocks read: OK
u-boot=> cp.b ${fdtcontroladdr} 0x48000000 0x20000
u-boot=> setenv bootargs "console=ttymxc2,115200 earlycon init=/init firmware_class.path=/vendor/firmware loop.max_part=7 swiotlb=512 fw_devlink.strict=0"
u-boot=> booti 0x40480000 - 0x48000000
   Uncompressing Kernel Image to 0
Moving Image from 0x40480000 to 0x40600000, end=422e0000
## Flattened Device Tree blob at 48000000
   Booting using the fdt blob at 0x48000000
Working FDT set to 48000000
   Using Device Tree in place at 0000000048000000, end 000000004801120f
Working FDT set to 48000000
No RNG device
Unable to set property kaslr-seed, err=<unknown error>

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000] Linux version 6.6.58-g758ad1ac4e8e-PHYTEC-Android15 (ramesh@ramesh) (Android (11967740, +pgo, +bolt, +lto, +mlgo, based on r522817) clang version 18.0.1
[    0.000000] KASLR disabled due to lack of seed
[    0.000000] Machine model: PHYTEC phyBOARD-Polis-i.MX8MM RDK
[    0.000000] Reserved memory: created CMA memory pool at 0x0000000098000000, size 640 MiB
[    0.000000] OF: reserved mem: initialized node linux,cma, compatible id shared-dma-pool
[    0.000000] OF: reserved mem: 0x0000000098000000..0x00000000bfffffff (655360 KiB) map reusable linux,cma
[    0.000000] earlycon: ec_imx6q0 at MMIO 0x0000000030880000 (options '')
[    0.000000] printk: bootconsole [ec_imx6q0] enabled
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] smp: Bringing up secondary CPUs ...
[    0.082398] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[    0.083005] CPU2: Booted secondary processor 0x0000000002 [0x410fd034]
[    0.083526] CPU3: Booted secondary processor 0x0000000003 [0x410fd034]
[    0.083584] smp: Brought up 1 node, 4 CPUs
[    0.138440] SMP: Total of 4 processors activated.
[    0.143154] CPU features: detected: 32-bit EL0 Support
[    0.148332] CPU features: detected: 32-bit EL1 Support
[    0.153483] CPU features: detected: CRC32 instructions
[    0.158711] CPU: All CPU(s) started at EL2
[    0.212518] pinctrl core: initialized pinctrl subsystem
[    0.487069] clocksource: Switched to clocksource arch_sys_counter
[    1.321587] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    1.329901] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.6.58-g758ad1ac4e8e-PHYTEC-Android15 #1
[    1.338560] Hardware name: PHYTEC phyBOARD-Polis-i.MX8MM RDK (DT)
[    1.407339] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) ]---
```

---

## 8. License & Attribution

- **BSP Adaptations & Integration:** Copyright © 2025 PHYTEC Embedded Pvt. Ltd. (India).
- **Author:** T S Rameshkumar (<rameshkumar.t@phytecembedded.in>)
- Android is a trademark of Google LLC.
- i.MX is a trademark of NXP Semiconductors.
