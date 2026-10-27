# TARGET_FS_CONFIG_GEN for Metroid.
#
# Qualcomm vendor AIDs. The stock vendor image uses these uids/gids for its
# daemons; without the definitions the build cannot assign them to the files
# extracted from the blob dump.
#
# Values are the stock Qualcomm allocation (2901..2917). Do not renumber: they
# have to match the file ownership recorded in the vendor image.
[AID_VENDOR_QTI_DIAG]
value:2901

[AID_VENDOR_QDSS]
value:2902

[AID_VENDOR_RFS]
value:2903

[AID_VENDOR_RFS_SHARED]
value:2904

[AID_VENDOR_ADPL_ODL]
value:2905

[AID_VENDOR_QRTR]
value:2906

[AID_VENDOR_THERMAL]
value:2907

[AID_VENDOR_FASTRPC]
value:2908

[AID_VENDOR_QTR]
value:2909

[AID_VENDOR_NXP_STRONGBOX]
value:2910

[AID_VENDOR_NXP_WEAVER]
value:2911

[AID_VENDOR_SSGTZD]
value:2912

[AID_VENDOR_THALES_STRONGBOX]
value:2913

[AID_VENDOR_QCC]
value:2914

[AID_VENDOR_NXP_AUTHSECRET]
value:2915

[AID_VENDOR_THALES_WEAVER]
value:2916

[AID_VENDOR_THALES_AUTHSECRET]
value:2917

# Mountpoint directories for the fstab entries in rootdir (and recovery.fstab).
#
# The trailing "/" is what marks a section as a DIRECTORY: fs_config_generator
# puts entries ending in "/" into fs_config_dirs and everything else into
# fs_config_files. Without the slash these entries are inert file entries.
# Without any entry, an empty mountpoint directory has no fs_config record and
# can be dropped by the image build; the mount then fails, /vendor/firmware_mnt
# stays empty, the adsp/cdsp/mss/wpss remoteprocs never find their .mdt firmware
# and the device comes up without wifi, with almost no sensors and without a
# baseband.
#
# root:root 0755: the vfat mounts in fstab already force uid/gid on mount, and
# for the ext4 /vendor/dsp mount 0755 keeps the firmware readable by every
# vendor daemon (SELinux still mediates access).
[vendor/firmware_mnt/]
mode: 0755
user: AID_ROOT
group: AID_ROOT
caps: 0

[vendor/dsp/]
mode: 0755
user: AID_ROOT
group: AID_ROOT
caps: 0

[vendor/bt_firmware/]
mode: 0755
user: AID_ROOT
group: AID_ROOT
caps: 0
