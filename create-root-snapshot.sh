#!/bin/bash

SNAP_NAME="root-snapshot-$(date +%Y-%m-%d)"
sudo mkdir -p /mnt/btrfs-root
sudo mount -o subvolid=5 /dev/sda3 /mnt/btrfs-root
sudo mkdir -p /mnt/btrfs-root/snapshots/root
sudo btrfs subvolume snapshot /mnt/btrfs-root/@ /mnt/btrfs-root/snapshots/root/$SNAP_NAME
sudo umount /mnt/btrfs-root
