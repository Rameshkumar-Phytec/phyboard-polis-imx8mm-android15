# PHYTEC Android 15 Manifest Repository

**Target Board:** PHYTEC phyBOARD-Polis i.MX8M Mini (PCM-066 / PCL-069 SOM, 2GB LPDDR4)  
**SoC:** NXP i.MX8M Mini Quad  
**Android Release:** Android 15.0.0_1.2.0  
**Linux Kernel:** Linux 6.6.58 (Android 15 GKI compliant)  
**U-Boot Version:** 2024.04 (PHYTEC Industrial Android 15 Auto-Boot)  
**Author:** T S Rameshkumar <rameshkumar.t@phytecembedded.in>  
**Organization:** PHYTEC Embedded Pvt. Ltd. (India)  

---

## 1. Quick Start / How to Fetch

To initialize and synchronize the complete Android 15 source tree for PHYTEC phyBOARD-Polis:

```bash
# 1. Install Google Repo tool if not already installed
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=${PATH}:~/bin

# 2. Create workspace directory
mkdir -p ~/phytec_imx8mm_android15
cd ~/phytec_imx8mm_android15

# 3. Initialize Repo with PHYTEC Manifest
repo init -u https://github.com/Rameshkumar-Phytec/phytec-manifest.git \
          -b imx-android-15 \
          -m phytec-android-15.0.0_1.2.0.xml

# 4. Synchronize source tree
repo sync -c --no-tags --prune -j$(nproc)
```

---

## 2. Repositories Managed by this Manifest

| Path in Android Tree | Upstream Reference | PHYTEC Repository & Branch |
| :--- | :--- | :--- |
| `vendor/nxp-opensource/uboot-imx` | `imx-linux-sdk/uboot-imx` | [`uboot-imx`](https://github.com/Rameshkumar-Phytec/uboot-imx) (`phytec-android_u-boot-imx8mm-polis-15.0.0_1.2.0`) |
| `vendor/nxp-opensource/kernel_imx` | `imx-linux-sdk/linux-imx` | [`linux-imx`](https://github.com/Rameshkumar-Phytec/linux-imx) (`phytec-android_kernel-imx8mm-polis-15.0.0_1.2.0`) |
| `device/nxp` | `imx-android/android-imx_device_fsl` | [`android-imx_device_fsl`](https://github.com/Rameshkumar-Phytec/android-imx_device_fsl) (`phytec-android_device-imx8mm-polis-15.0.0_1.2.0`) |

---

## 3. Build Instructions

```bash
# Setup build environment
source build/envsetup.sh

# Select PHYTEC lunch target
lunch phyboard_polis-userdebug

# Build Android images
./imx-make.sh -j$(nproc) 2>&1 | tee build-log.txt
```
