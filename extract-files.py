#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2026 The PixelOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Extracts the proprietary blobs listed in proprietary-files.txt from a stock
# dump into vendor/nothing/Metroid.
#
# Usage, from the root of the ROM tree, with the stock dump unpacked into
# vendor/nothing/Metroid/proprietary (or pointed at with --src):
#   ./extract-files.py                       # extract
#   ./extract-files.py --regenerate_makefiles
#   ./setup-makefiles.py
#
# proprietary-files.txt was checked entry by entry against the full Nothing OS
# C5.0-260924-2115 dump: every entry exists there and carries its SHA-1.

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    # Blobs that pin older AIDL versions than the source libraries next to them;
    # Soong rejects mixed versions, so these are installed through PRODUCT_PACKAGES.
    (
        'android.hardware.audio.core-V2-ndk',
        'android.hardware.bluetooth.audio-V4-ndk',
        'android.hardware.graphics.allocator-V1-ndk',
        'android.hardware.graphics.common-V5-ndk',
        'android.hardware.graphics.composer3-V3-ndk',
        'android.media.audio.common.types-V3-ndk',
    ): lib_fixup_remove,
}

namespace_imports = [
    'device/nothing/Metroid',
    'hardware/qcom-caf/common/libqti-perfd-client',
    'hardware/qcom-caf/sm8750',
    'hardware/qcom-caf/wlan',
    'hardware/qcom-caf/wlan/qcwcn',
    'vendor/qcom/opensource/commonsys/display',
    'vendor/qcom/opensource/commonsys-intf/display',
    'vendor/qcom/opensource/dataservices',
    'vendor/qcom/opensource/display',
]

blob_fixups: blob_fixups_user_type = {
    # Nothing face HAL: stock lists 'disabled' twice and the AIDL service
    # interface is missing, so it never starts.
    'vendor/etc/init/android.hardware.biometrics.face-service.noth.rc': blob_fixup()
        .regex_replace('    disabled\n    disabled\n', '    disabled\n')
        .regex_replace(
            '    group camera system\n',
            '    group camera system\n'
            '    interface aidl android.hardware.biometrics.face.IFace/default\n',
        ),
    # cnd / qms: stock marks them disabled; qms also runs as the wrong user.
    'vendor/etc/init/cnd.rc': blob_fixup()
        .regex_replace('    disabled\n', ''),
    'vendor/etc/init/qms.rc': blob_fixup()
        .regex_replace('    disabled\n', '')
        .regex_replace(
            '     class main\n',
            '     class main\n'
            '     user root\n',
        )
        .regex_replace('    user root\n    group root\n', ''),
    # nt_logtool writes to /data/vendor/diag_mdlog before anything creates it.
    'vendor/etc/init/init.nt_logtool.rc': blob_fixup()
        .regex_replace(
            'service diag_gpslog_start ',
            'on post-fs-data\n'
            '    mkdir /data/vendor/diag_mdlog 0770 root system\n'
            '    restorecon_recursive /data/vendor/diag_mdlog\n\n'
            'service diag_gpslog_start ',
        ),
    # The stock perfservice duplicates a service PixelOS already starts
    # (some stock revisions carry it, the C5.0-260924-2115 one does not; the
    # replace is a no-op when the block is absent).
    'system_ext/etc/init/perfservice.rc': blob_fixup()
        .regex_replace(
            'service vendor.perfservice /system_ext/bin/perfservice\n'
            '    class main\n'
            '    user system\n'
            '    group system readproc\n\n',
            '',
        ),
    # The systemfeatures generator only parses XML 1.0.
    'system_ext/etc/permissions/vendor.qti.hardware.c2pa-V1-java.xml': blob_fixup()
        .regex_replace('<\\?xml version="2.0"', '<?xml version="1.0"'),
    # RNDIS function name used by the guest kernel on this platform.
    'vendor/etc/init/hw/init.qcom.usb.rc': blob_fixup()
        .regex_replace('ncm\\.0', 'ncm.gs6'),
    'vendor/etc/init/vendor.qti.hardware.perf2-hal-service.rc': blob_fixup()
        .regex_replace('    disabled\n    disabled\n', ''),
    'vendor/etc/init/vendor.qti.media.c2@1.0-service.rc': blob_fixup()
        .regex_replace('    disabled\n', ''),
    'vendor/etc/init/vendor.qti.media.c2audio@1.0-service.rc': blob_fixup()
        .regex_replace('    disabled\n', ''),
    # Some Nothing OS revisions link the charge HAL against the platform
    # variant of its interface lib while shipping only the non-platform .so.
    # With the C5.0-260924-2115 blobs the binary already links
    # vendor.noth.hardware.charge-V1-ndk.so, so this is a no-op there.
    'vendor/bin/hw/vendor.noth.hardware.charge-service': blob_fixup()
        .replace_needed(
            'vendor.noth.hardware.charge-V1-ndk_platform.so',
            'vendor.noth.hardware.charge-V1-ndk.so',
        ),
    # No other patchelf fixups: scanning DT_NEEDED of every ELF in the
    # reference dump found no library that is needed but not shipped (the
    # vendor blobs carry their own libbase, libutils, libcutils, libhardware
    # and libntf, and the _platform-named interface libs they link are
    # themselves shipped blobs).
}

module = ExtractUtilsModule(
    'Metroid',
    'nothing',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
