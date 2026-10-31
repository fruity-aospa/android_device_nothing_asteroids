#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024-2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

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

namespace_imports = [
    'hardware/nothing',
    'hardware/qcom-caf/sm8650',
    'vendor/qcom/common/vendor/perf',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'com.qualcomm.qti.dpm.api@1.0',
        'libntf',
        'vendor.qti.ImsRtpService-V1-ndk',
        'vendor.qti.diaghal@1.0',
        'vendor.qti.hardware.dpmaidlservice-V1-ndk',
        'vendor.qti.hardware.limits@1.0',
        'vendor.qti.hardware.limits@1.1',
        'vendor.qti.hardware.qccsyshal@1.0',
        'vendor.qti.hardware.qccsyshal@1.1',
        'vendor.qti.hardware.qccsyshal@1.2',
        'vendor.qti.hardware.wifidisplaysession@1.0',
        'vendor.qti.imsrtpservice@3.0',
        'vendor.qti.imsrtpservice@3.1',
        'vendor.qti.qccvndhal_aidl-V1-ndk',
        'vendor.qti.qspmhal-V1-ndk',
    ): lib_fixup_vendor_suffix,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/bin/init.qti.kernel.sh': blob_fixup()
        .regex_replace(r'(?m)^start_msm_irqbalance\n', ''),
    'system_ext/lib64/vendor.qti.hardware.qccsyshal@1.2-halimpl.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-full.so', 'libprotobuf-cpp-full-21.7.so'),
    'vendor/bin/hw/android.hardware.biometrics.face-service.noth': blob_fixup()
        .replace_needed('libcamera2ndk_vendor.so', 'libcamera2ndk_vendor-v34.so'),
    (
        'vendor/lib64/libdpps.so',
        'vendor/lib64/libsnapdragoncolor-manager.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    (
        'vendor/lib64/libqms_client.so',
        'vendor/bin/qcc-vendor',
        'vendor/bin/xtra-daemon',
        'vendor/bin/qms',
        'vendor/lib64/libcne.so',
        'vendor/lib64/libqcc_sdk.so',
    ): blob_fixup()
        .add_needed('libbinder_shim.so'),
    'vendor/lib64/libstfaceunlockppl.so': blob_fixup()
        .sig_replace(
            'fd 7b bd a9 fd 03 00 91 f3 53 01 a9 f4 03 00 aa f3 03 01 aa c0 0b 02 d0',
            '00 00 80 52 c0 03 5f d6 1f 20 03 d5 1f 20 03 d5 1f 20 03 d5 1f 20 03 d5',
        )
        .sig_replace(
            'fd 7b bb a9 fd 03 00 91 f3 53 01 a9 a0 17 00 f9 63 c3 ff 97 a1 17 40 f9',
            '00 00 80 52 c0 03 5f d6 1f 20 03 d5 1f 20 03 d5 1f 20 03 d5 1f 20 03 d5',
        )
        .sig_replace(
            '81 15 02 d0 21 00 71 39 01 00 00 b9 00 00 80 52 c0 03 5f d6',
            '21 00 80 52 01 00 00 b9 00 00 80 52 c0 03 5f d6 1f 20 03 d5',
        ),
    'vendor/etc/lvacfs_params/1mic/LVACFS_Configuration.txt': blob_fixup()
        .patch_file('audio/lvacfs_1mic_config.patch'),
    'vendor/etc/lvacfs_params/2mic/LVACFS_Configuration.txt': blob_fixup()
        .patch_file('audio/lvacfs_2mic_config.patch'),
    'vendor/lib64/libarcsoft_dark_vision_raw.so': blob_fixup()
        .clear_symbol_version('remote_register_buf')
        .clear_symbol_version('rpcmem_alloc')
        .clear_symbol_version('rpcmem_free'),
    (
        'vendor/lib64/libcapiv2uvvendor.so',
        'vendor/lib64/liblistensoundmodel2vendor.so',
        'vendor/lib64/libVoiceSdk.so',
    ): blob_fixup().replace_needed(
        'libtensorflowlite_c.so',
        'libtensorflowlite_c_vendor.so',
    ),
    'vendor/lib64/libmorpho_RapidEffect.so': blob_fixup()
        .clear_symbol_version('AHardwareBuffer_allocate')
        .clear_symbol_version('AHardwareBuffer_describe')
        .clear_symbol_version('AHardwareBuffer_lockPlanes')
        .clear_symbol_version('AHardwareBuffer_release')
        .clear_symbol_version('AHardwareBuffer_unlock'),
    'vendor/lib64/libntcamallocator.so': blob_fixup()
        .add_needed('libui_shim.so'),
    'vendor/lib64/libntcamskia.so': blob_fixup()
        .add_needed('libnativewindow.so'),
    'vendor/lib64/vendor.libdpmframework.so': blob_fixup()
        .add_needed('libbinder_shim.so')
        .add_needed('libhidlbase_shim.so'),
    'vendor/lib64/libqcodec2_core.so': blob_fixup()
        .add_needed('libcodec2_shim.so'),
    'vendor/lib64/libwa_sat.so': blob_fixup()
        .binary_regex_replace(b'/system\x00', b'/vendor\x00'),
}  # fmt: skip

module = ExtractUtilsModule(
    'asteroids',
    'nothing',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
