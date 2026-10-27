#!/bin/bash
TARGET_DEV="${1:-/dev/sdc}"
echo "Flashing PHYTEC phyBOARD-Polis Android 15 to ${TARGET_DEV}..."
sudo ./imx-sdcard-partition.sh -f imx8mm "${TARGET_DEV}"
