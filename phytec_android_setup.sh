#!/usr/bin/env bash
# ==============================================================================
# PHYTEC Embedded Pvt. Ltd. (India)
# Script: phytec_android_setup.sh
# Target: PHYTEC phyBOARD-Polis i.MX8M Mini (PCM-066 / PCL-069 SOM, 2GB LPDDR4)
# Release: Android 15.0.0_1.2.0 (Linux Kernel 6.6.58 GKI)
# Author: T S Rameshkumar <rameshkumar.t@phytecembedded.in>
# GitHub: https://github.com/Rameshkumar-Phytec
# Copyright (C) 2025 PHYTEC Embedded Pvt. Ltd.
# ==============================================================================

(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0

safe_exit() {
    local code="${1:-0}"
    if [ "$SOURCED" -eq 1 ]; then
        return "$code"
    else
        exit "$code"
    fi
}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}"
echo "================================================================================"
echo "    PHYTEC phyBOARD-Polis i.MX8M Mini - Android 15 BSP Setup Environment     "
echo "    Author: T S Rameshkumar <rameshkumar.t@phytecembedded.in>                  "
echo "    GitHub: https://github.com/Rameshkumar-Phytec                              "
echo "    PHYTEC Embedded Pvt. Ltd. (India)                                          "
echo "================================================================================"
echo -e "${NC}"

SKIP_SYNC=0
FORCE_PATCHES=0
MANIFEST_URL="https://github.com/Rameshkumar-Phytec/phytec-manifest"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-sync)
            SKIP_SYNC=1
            shift
            ;;
        --force-patches)
            FORCE_PATCHES=1
            shift
            ;;
        --manifest-url)
            MANIFEST_URL="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: [source] $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --skip-sync        Skip repo init and repo sync (use existing checkout)"
            echo "  --force-patches    Reset branches to base tags and re-apply patch stacks"
            echo "  --manifest-url URL Use custom manifest repository URL"
            echo "  -h, --help         Display this help message"
            echo ""
            safe_exit 0
            ;;
        *)
            echo -e "${YELLOW}[WARNING] Unknown argument: $1${NC}"
            shift
            ;;
    esac
done

if [ -n "${BASH_SOURCE[0]}" ]; then
    REL_PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    REL_PACKAGE_DIR="$PWD"
fi

if [ -z "$WORKSPACE" ]; then
    if [ -d "$REL_PACKAGE_DIR/android_build" ]; then
        WORKSPACE="$REL_PACKAGE_DIR"
    elif [ -d "$REL_PACKAGE_DIR/../android_build" ]; then
        WORKSPACE="$(cd "$REL_PACKAGE_DIR/.." && pwd)"
    else
        WORKSPACE="$PWD"
    fi
fi

if [ -z "$android_builddir" ]; then
    if [ -d "$REL_PACKAGE_DIR/android_build" ]; then
        android_builddir="$REL_PACKAGE_DIR/android_build"
    else
        android_builddir="$WORKSPACE/android_build"
    fi
fi

echo -e "${BLUE}[INFO] REL_PACKAGE_DIR  : ${BOLD}${REL_PACKAGE_DIR}${NC}"
echo -e "${BLUE}[INFO] WORKSPACE        : ${BOLD}${WORKSPACE}${NC}"
echo -e "${BLUE}[INFO] android_builddir : ${BOLD}${android_builddir}${NC}"

PATCH_DIR=""
for candidate in \
    "${REL_PACKAGE_DIR}/patches" \
    "${WORKSPACE}/patches" \
    "${REL_PACKAGE_DIR}/../patches"; do
    if [ -d "${candidate}/uboot_patches" ]; then
        PATCH_DIR="$(cd "${candidate}" && pwd)"
        break
    fi
done

if [ -n "${PATCH_DIR}" ]; then
    echo -e "${BLUE}[INFO] PATCH_DIR        : ${BOLD}${PATCH_DIR}${NC}"
fi

# Locate or Setup AARCH64 Cross-Compiler Toolchain
TOOLCHAIN_DIR_NAME="arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu"
TOOLCHAIN_BIN=""

# 1. Check relative package or workspace directories
for tc_candidate in \
    "${REL_PACKAGE_DIR}/${TOOLCHAIN_DIR_NAME}/bin/aarch64-none-linux-gnu-" \
    "${WORKSPACE}/${TOOLCHAIN_DIR_NAME}/bin/aarch64-none-linux-gnu-"; do
    if [ -f "${tc_candidate%aarch64-none-linux-gnu-}aarch64-none-linux-gnu-gcc" ]; then
        TOOLCHAIN_BIN="${tc_candidate}"
        break
    fi
done

# 2. Check if archive exists and extract if necessary
if [ -z "${TOOLCHAIN_BIN}" ]; then
    for tar_candidate in \
        "${REL_PACKAGE_DIR}/${TOOLCHAIN_DIR_NAME}.tar.xz" \
        "${WORKSPACE}/${TOOLCHAIN_DIR_NAME}.tar.xz"; do
        if [ -f "${tar_candidate}" ]; then
            echo -e "${BLUE}[INFO] Extracting cross-toolchain from $(basename "${tar_candidate}")...${NC}"
            tar -xf "${tar_candidate}" -C "$(dirname "${tar_candidate}")"
            TOOLCHAIN_BIN="$(dirname "${tar_candidate}")/${TOOLCHAIN_DIR_NAME}/bin/aarch64-none-linux-gnu-"
            break
        fi
    done
fi

# 3. Check system PATH fallback
if [ -z "${TOOLCHAIN_BIN}" ]; then
    if command -v aarch64-none-linux-gnu-gcc >/dev/null 2>&1; then
        SYS_TC="$(command -v aarch64-none-linux-gnu-gcc)"
        TOOLCHAIN_BIN="${SYS_TC%gcc}"
    elif command -v aarch64-linux-gnu-gcc >/dev/null 2>&1; then
        SYS_TC="$(command -v aarch64-linux-gnu-gcc)"
        TOOLCHAIN_BIN="${SYS_TC%gcc}"
    fi
fi

# 4. Automatically download and extract official Arm GNU Toolchain if still missing
if [ -z "${TOOLCHAIN_BIN}" ]; then
    echo -e "${BLUE}[INFO] Toolchain not found locally. Downloading official Arm GNU Toolchain 11.3.rel1...${NC}"
    TC_URL="https://developer.arm.com/-/media/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz"
    TC_TAR="${WORKSPACE}/${TOOLCHAIN_DIR_NAME}.tar.xz"
    
    if command -v wget >/dev/null 2>&1; then
        wget -c "${TC_URL}" -O "${TC_TAR}"
    elif command -v curl >/dev/null 2>&1; then
        curl -L "${TC_URL}" -o "${TC_TAR}"
    fi

    if [ -f "${TC_TAR}" ]; then
        echo -e "${BLUE}[INFO] Extracting toolchain to ${WORKSPACE}...${NC}"
        tar -xf "${TC_TAR}" -C "${WORKSPACE}"
        if [ -f "${WORKSPACE}/${TOOLCHAIN_DIR_NAME}/bin/aarch64-none-linux-gnu-gcc" ]; then
            TOOLCHAIN_BIN="${WORKSPACE}/${TOOLCHAIN_DIR_NAME}/bin/aarch64-none-linux-gnu-"
        fi
    fi
fi

if [ -n "${TOOLCHAIN_BIN}" ]; then
    export AARCH64_GCC_CROSS_COMPILE="${TOOLCHAIN_BIN}"
    echo -e "${GREEN}[INFO] Toolchain configured: ${AARCH64_GCC_CROSS_COMPILE}${NC}"
else
    echo -e "${YELLOW}[WARNING] AARCH64 GCC toolchain not found. Install gcc-aarch64-linux-gnu or place ${TOOLCHAIN_DIR_NAME}.${NC}"
fi

mkdir -p "$android_builddir"
cd "$android_builddir" || safe_exit 1

# Repo Init & Sync
if [ "$SKIP_SYNC" -eq 0 ]; then
    if [ ! -d ".repo" ]; then
        echo -e "\n${CYAN}>>> Phase 1: Initializing Android 15 Repo Manifest...${NC}"
        echo -e "${BLUE}[INFO] Initializing PHYTEC manifest (${MANIFEST_URL})...${NC}"
        repo init -u "$MANIFEST_URL" -b imx-android-15 -m phytec-android-15.0.0_1.2.0.xml || {
            echo -e "${YELLOW}[WARNING] Custom manifest init failed, falling back to upstream NXP manifest...${NC}"
            repo init -u https://github.com/nxp-imx/imx-manifest -b imx-android-15 -m imx-android-15.0.0_1.2.0.xml
        }

        if [ $? -ne 0 ]; then
            echo -e "${RED}[ERROR] Repo init failed! Please check your network and repo credentials.${NC}"
            safe_exit 1
        fi
    fi

    echo -e "\n${CYAN}>>> Phase 2: Synchronizing Repositories...${NC}"
    retry=0
    max_retry=3
    repo sync -c --no-tags --prune
    while [ $retry -lt $max_retry ] && [ $? -ne 0 ]; do
        retry=$((retry+1))
        echo -e "${YELLOW}[WARNING] Retrying repo sync (Attempt $retry/$max_retry)...${NC}"
        repo sync -c --no-tags --prune
    done

    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERROR] Repo sync failed after $max_retry attempts.${NC}"
        safe_exit 1
    fi
else
    echo -e "\n${YELLOW}[INFO] Skipping repo sync as requested (--skip-sync).${NC}"
fi

# Copy Proprietary Vendor Binaries
echo -e "\n${CYAN}>>> Phase 3: Installing Proprietary Packages & EULA...${NC}"
if [ -d "$REL_PACKAGE_DIR/vendor/nxp" ]; then
    mkdir -p "$android_builddir/vendor"
    cp -r "$REL_PACKAGE_DIR"/vendor/nxp "$android_builddir"/vendor/
    echo -e "${GREEN}[OK] Copied vendor/nxp proprietary binaries.${NC}"
fi

if [ -f "$REL_PACKAGE_DIR/EULA.txt" ]; then
    cp "$REL_PACKAGE_DIR"/EULA.txt "$android_builddir"/
fi

if compgen -G "$REL_PACKAGE_DIR/SCR*" > /dev/null; then
    cp "$REL_PACKAGE_DIR"/SCR* "$android_builddir"/
fi

# Apply Patches if needed
apply_patch_stack() {
    local SUB_DIR="$1"
    local BRANCH_NAME="$2"
    local BASE_TAG="$3"
    local PATCH_SUBDIR="$4"

    local TARGET_PATH="$android_builddir/$SUB_DIR"
    local PATCH_PATH="$PATCH_DIR/$PATCH_SUBDIR"

    echo -e "\n${BOLD}[Component] $SUB_DIR${NC}"

    if [ ! -d "$TARGET_PATH" ]; then
        echo -e "${RED}[ERROR] Target directory $TARGET_PATH does not exist!${NC}"
        return 1
    fi

    cd "$TARGET_PATH" || return 1

    local BRANCH_EXISTS=0
    if git rev-parse --verify "$BRANCH_NAME" >/dev/null 2>&1; then
        BRANCH_EXISTS=1
    fi

    if [ "$FORCE_PATCHES" -eq 1 ] || [ "$BRANCH_EXISTS" -eq 0 ]; then
        echo -e "${BLUE}[INFO] Creating branch '${BRANCH_NAME}' from base '${BASE_TAG}'...${NC}"
        git checkout -B "$BRANCH_NAME" "$BASE_TAG"

        if [ -d "$PATCH_PATH" ] && [ -n "$(ls -A "$PATCH_PATH"/*.patch 2>/dev/null)" ]; then
            echo -e "${BLUE}[INFO] Applying PHYTEC patch stack from $PATCH_SUBDIR...${NC}"
            git am --whitespace=fix "$PATCH_PATH"/*.patch
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}[OK] Successfully applied patches to $SUB_DIR!${NC}"
            else
                echo -e "${RED}[ERROR] Failed to apply patches in $SUB_DIR! Aborting git am.${NC}"
                git am --abort
                return 1
            fi
        fi
    else
        echo -e "${GREEN}[OK] Branch '${BRANCH_NAME}' already active in $SUB_DIR.${NC}"
        git checkout "$BRANCH_NAME"
    fi
}

if [ -n "$PATCH_DIR" ]; then
    echo -e "\n${CYAN}>>> Phase 4: Applying PHYTEC phyBOARD-Polis Android 15 Patches...${NC}"

    apply_patch_stack \
        "vendor/nxp-opensource/uboot-imx" \
        "phytec-android_u-boot-imx8mm-polis-15.0.0_1.2.0" \
        "android-15.0.0_1.2.0" \
        "uboot_patches"

    apply_patch_stack \
        "vendor/nxp-opensource/kernel_imx" \
        "phytec-android_kernel-imx8mm-polis-15.0.0_1.2.0" \
        "android-15.0.0_1.2.0" \
        "kernel_patches"

    apply_patch_stack \
        "device/nxp" \
        "phytec-android_device-imx8mm-polis-15.0.0_1.2.0" \
        "android-15.0.0_1.2.0" \
        "device_nxp_patches"
fi

cd "$android_builddir"

echo -e "\n${GREEN}${BOLD}"
echo "================================================================================"
echo "    PHYTEC Android 15 Environment Successfully Configured!                    "
echo "================================================================================"
echo -e "${NC}"
echo -e "Target Product: ${BOLD}${CYAN}phyboard_polis-userdebug${NC}"
echo -e "Toolchain:      ${BOLD}${YELLOW}${AARCH64_GCC_CROSS_COMPILE:-System Default}${NC}"
echo ""
echo -e "${BOLD}Next Build Steps:${NC}"
echo -e "  1. Navigate to build directory:"
echo -e "     ${CYAN}cd ${android_builddir}${NC}"
echo ""
echo -e "  2. Initialize Android build environment:"
echo -e "     ${CYAN}source build/envsetup.sh${NC}"
echo ""
echo -e "  3. Select PHYTEC target lunch combo:"
echo -e "     ${CYAN}lunch phyboard_polis-userdebug${NC}"
echo ""
echo -e "  4. Build Android images:"
echo -e "     ${CYAN}./imx-make.sh -j\$(nproc) 2>&1 | tee build-log.txt${NC}"
echo ""
echo -e "  To build bootloader only:"
echo -e "     ${CYAN}./imx-make.sh bootloader -j\$(nproc)${NC}"
echo ""
echo -e "  To build kernel & DTBs only:"
echo -e "     ${CYAN}./imx-make.sh kernel dtboimage -j\$(nproc)${NC}"
echo "================================================================================"

unset SKIP_SYNC
unset FORCE_PATCHES
unset MANIFEST_URL
unset SOURCED
