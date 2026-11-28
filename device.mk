#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Platform
TARGET_BOARD_PLATFORM := volcano
TARGET_KERNEL_VERSION := 6.1
TARGET_USES_KERNEL_PLATFORM := false

# QTI components
TARGET_COMMON_QTI_COMPONENTS := \
    alarm \
    av \
    bt \
    display \
    perf \
    usb \
    wfd

# GPS (device ships prebuilt GNSS HALs; avoid inheriting source HAL packages)
PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/gps

PRODUCT_PACKAGES += \
    QCOMGPSFrameworksOverlay \
    gps.conf \
    batching.conf \
    gnss_antenna_info.conf \
    gnss@2.0-base.policy \
    gnss@2.0-edgnss-daemon.policy \
    gnss@2.0-xtra-daemon.policy \
    gnss@2.0-xtwifi-client.policy

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

$(call inherit-product, vendor/nothing/asteroids/asteroids-vendor.mk)

# Dolby (optional)
$(call inherit-product-if-exists, hardware/dolby/dolby.mk)

# Weather provider for Launcher At a Glance; weather and location remain opt-in.
PRODUCT_PACKAGES += OmniJaws

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)

PRODUCT_RO_FILE_SYSTEM ?= ext4

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=$(PRODUCT_RO_FILE_SYSTEM) \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=$(PRODUCT_RO_FILE_SYSTEM) \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# API
PRODUCT_SHIPPING_API_LEVEL := 35

# ART
PRODUCT_ENABLE_UFFD_GC := true

# Adreno (device owns proprietary GPU blobs; include open-source permissions/props only)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_3.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.egl=adreno \
    ro.hardware.vulkan=adreno \
    ro.opengles.version=196610

# Audio
$(call soong_config_set_bool,android_hardware_audio,skip_speaker_layout_channel_mask_field,true)
$(call soong_config_set,qtiaudio,headers_namespace,.)
$(call soong_config_set,qtiaudio,libarpal_namespace,.)
$(call soong_config_set,qtiaudio,feature_agm_hidl,true)
$(call soong_config_set,qtiaudio,feature_disabled_dts_eagle,true)
$(call soong_config_set,qtiaudio,feature_gef_support,true)
$(call soong_config_set,qtiaudio,feature_instance_id,true)
$(call soong_config_set,qtiaudio,feature_mcs,true)
$(call soong_config_set,qtiaudio,feature_pal_hidl,true)

AUDIO_HAL_DIR := hardware/qcom/audio
AUDIO_PAL_DIR := vendor/qcom/opensource/arpal-lx

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

PRODUCT_COPY_FILES += \
    $(AUDIO_HAL_DIR)/configs/volcano/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_volcano/audio_effects.conf \
    $(AUDIO_HAL_DIR)/configs/volcano/mem_logger_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mem_logger_config.xml \
    $(AUDIO_HAL_DIR)/configs/volcano/microphone_characteristics.xml:$(TARGET_COPY_OUT_VENDOR)/etc/microphone_characteristics.xml \
    $(AUDIO_PAL_DIR)/configs/volcano/card-defs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/card-defs.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_volcano/audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(LOCAL_PATH)/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(LOCAL_PATH)/audio/mixer_paths_volcano_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_volcano/mixer_paths_volcano_qrd.xml \
    $(LOCAL_PATH)/audio/mixer_paths_volcano_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_volcano_qrd.xml \
    $(LOCAL_PATH)/audio/resourcemanager_volcano_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_volcano/resourcemanager_volcano_qrd.xml \
    $(LOCAL_PATH)/audio/resourcemanager_volcano_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/resourcemanager_volcano_qrd.xml \
    $(LOCAL_PATH)/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_volcano/audio_effects.xml \
    $(LOCAL_PATH)/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(LOCAL_PATH)/audio/usecaseKvManager.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usecaseKvManager.xml

PRODUCT_PACKAGES += \
    android.hardware.audio@7.1-impl \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.audio.service \
    android.hardware.bluetooth.audio-impl_hw_symlink \
    android.hardware.soundtrigger@2.3-impl \
    audio.bluetooth.default \
    audio.primary.volcano \
    audio.r_submix.default \
    audio.usb.default \
    audioadsprpcd \
    lib_bt_aptx \
    lib_bt_ble \
    lib_bt_bundle \
    libagm_compress_plugin \
    libagm_mixer_plugin \
    libagm_pcm_plugin \
    libaudiochargerlistener \
    libbatterylistener \
    libcustomva_intf \
    libfmpal \
    libhapticgenerator \
    libhfp_pal \
    libhotword_intf \
    libpalclient \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libvolumelistener \
    sound_trigger.primary.volcano

# Biometrics
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.nothing

$(call soong_config_set_bool,nothing_fingerprint,use_lhbm,true)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

TARGET_HAS_UDFPS := true

# Boot Control
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

# Camera
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

$(call inherit-product-if-exists, vendor/nothing/camera/nothing-camera.mk)

PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.config-V2-ndk.vendor

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# Memory
PRODUCT_PACKAGES += \
    libvmmem

# Data
PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/dataservices

PRODUCT_PACKAGES += \
    librmnetctl

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)


# Device Extras & Doze
PRODUCT_PACKAGES += \
    DeviceExtras \
    NothingDoze

# eUICC
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/default-permissions-com.google.android.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions-com.google.android.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_JPN/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ProEEA/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ProROW/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ProTUR/android.hardware.telephony.euicc.xml

PRODUCT_PACKAGES += \
    NothingEsimSwitcher \
    NothingEuicc

# FeliCa
PRODUCT_PACKAGES += \
    NothingFelicaDisabler

# FWK Detect
PRODUCT_PACKAGES += \
    libvndfwk_detect_jni.qti_vendor

# Fastboot
PRODUCT_PACKAGES += \
    fastbootd

# Glyph
PRODUCT_PACKAGES += \
    GlyphAdapter \
    ParanoidGlyph

# Graphics
PRODUCT_REQUIRES_INSECURE_EXECMEM_FOR_SWIFTSHADER := true

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.allocator@1.0-service \
    hwservicemanager

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti \
    android.hardware.health-service.qti_recovery

# Init (import only non-conflicting common QTI init bits; device/vendor own modprobe & post_boot scripts)
PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/init

PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/init/init.qcom.early_boot.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.early_boot.sh \
    device/qcom/common/vendor/init/init.qcom.post_boot.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.post_boot.sh

PRODUCT_PACKAGES += \
    fstab.default \
    fstab.default.vendor_ramdisk \
    init.aospa.perf.common.rc \
    init.aospa.perf.common.sh \
    init.asteroids.hw.rc \
    init.asteroids.nfc.sh \
    init.asteroids.rc \
    init.class_main.sh \
    init.crda.sh \
    init.kernel.init_boot-memory.sh \
    init.mdm.sh \
    init.qcom.aospa.rc \
    init.qcom.class_core.sh \
    init.qcom.coex.sh \
    init.qcom.efs.sync.sh \
    init.qcom.rc \
    init.qcom.recovery.rc \
    init.qcom.sdio.sh \
    init.qcom.sh \
    init.qcrild.sh \
    init.qti.kernel.rc \
    init.qti.kernel.sh \
    init.qti.kernel.target.rc \
    init.qti.write.sh \
    init.recovery.qcom.rc \
    init.target.rc \
    init.veth_ipa_config.sh \
    qca6234-service.sh \
    system_dlkm_asteroids_modprobe.sh \
    ueventd.asteroids.rc \
    ueventd.qcom.rc \
    vendor_modprobe.sh

# Kernel
 PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/system_dlkm.modules.blocklist:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/idc/fts_ts.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/fts_ts.idc \
    $(LOCAL_PATH)/keylayout/fts_ts.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/fts_ts.kl \
    $(LOCAL_PATH)/configs/gpio-keys.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/gpio-keys.kl

# Keymint
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore_V3.xml

# Lights
TARGET_EXCLUDES_QTI_LIGHTS := true
$(call soong_config_set,nothing_glyph,device,phone3a)

PRODUCT_PACKAGES += \
    android.hardware.lights-service.glyph

# Health extension
$(call soong_config_set,lineage_health,charging_control_charging_path,/proc/charger/usb_charger_en)

PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media/media_profiles_volcano_v1_Base.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_volcano_v1_Base.xml \
    $(LOCAL_PATH)/configs/media/media_profiles_volcano_v1_Pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_volcano_v1_Pro.xml

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml

# Memtrack
PRODUCT_PACKAGES += \
    vendor.qti.hardware.memtrack-service

# NFC
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf \
    $(LOCAL_PATH)/configs/nfc/libnfc-hal-st21-BASE.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st21-BASE.conf \
    $(LOCAL_PATH)/configs/nfc/libnfc-hal-st21-PRO.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st21-PRO.conf \
    $(LOCAL_PATH)/configs/nfc/libnfc-hal-st54j-JPN.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st54j-JPN.conf \
    $(LOCAL_PATH)/configs/nfc/libnfc-hal-st54j-PRO.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st54j-PRO.conf \
    $(LOCAL_PATH)/configs/nfc/libnfc-nci-JPN.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci-JPN.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_JPN/android.hardware.nfc.ese.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml

PRODUCT_PACKAGES += \
    android.hardware.nfc-service.st

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rro_overlays/partition_order.xml:$(TARGET_COPY_OUT_PRODUCT)/overlay/partition_order.xml

PRODUCT_ENFORCE_RRO_TARGETS := *

PRODUCT_PACKAGES += \
    AsteroidsApertureDevOverlay \
    AsteroidsApertureOverlay \
    AsteroidsFrameworksOverlay \
    AsteroidsLauncherOverlay \
    AsteroidsMainlineWifiOverlay \
    AsteroidsProMainlineWifiOverlay \
    AsteroidsProSettingsProviderOverlay \
    AsteroidsProWifiOverlay \
    AsteroidsSettingsOverlay \
    AsteroidsSettingsProviderOverlay \
    AsteroidsSystemUIOverlay \
    AsteroidsWifiOverlay \
    CarrierConfigResCommon_Vendor \
    FrameworksResCommon_Vendor \
    FrameworksResTarget_Vendor \
    NcmTetheringOverlay \
    SecureElementResTarget_Vendor \
    SettingsResCommon_Vendor \
    SystemUIResCommon_Vendor \
    TelephonyResCommon_Sys \
    TelephonyResCommon_Vendor \
    UwbResCommon_Vendor \
    WifiResCommonMainline_Vendor \
    WifiResCommon_Vendor \
    WifiResMainlineTarget \
    WifiResTarget

# Partitions
PRODUCT_BUILD_RECOVERY_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Permissions
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/default-permissions-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions-nothing.xml \
    $(LOCAL_PATH)/configs/default-permissions-system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/default-permissions/default-permissions-nothing.xml \
    $(LOCAL_PATH)/configs/hidden-api-whitelist-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/hidden-api-whitelist-nothing.xml \
    $(LOCAL_PATH)/configs/privapp-permissions-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-nothing.xml \
    $(LOCAL_PATH)/configs/sysconfig_qti.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/sysconfig_qti.xml \
    $(LOCAL_PATH)/configs/sysconfig_wfc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/sysconfig_wfc.xml

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Public Libraries
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/public.libraries.system_ext.txt:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/public.libraries.txt

# QSPA
PRODUCT_PACKAGES += \
    qspa_vendor.rc \
    vendor.qti.qspa-service

# Ramdisk
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# SKU properties
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sku/build_EEA.prop:$(TARGET_COPY_OUT_ODM)/etc/build_EEA.prop \
    $(LOCAL_PATH)/sku/build_IND.prop:$(TARGET_COPY_OUT_ODM)/etc/build_IND.prop \
    $(LOCAL_PATH)/sku/build_JPN.prop:$(TARGET_COPY_OUT_ODM)/etc/build_JPN.prop \
    $(LOCAL_PATH)/sku/build_TUR.prop:$(TARGET_COPY_OUT_ODM)/etc/build_TUR.prop \
    $(LOCAL_PATH)/sku/build_ProEEA.prop:$(TARGET_COPY_OUT_ODM)/etc/build_ProEEA.prop \
    $(LOCAL_PATH)/sku/build_ProIND.prop:$(TARGET_COPY_OUT_ODM)/etc/build_ProIND.prop \
    $(LOCAL_PATH)/sku/build_ProROW.prop:$(TARGET_COPY_OUT_ODM)/etc/build_ProROW.prop \
    $(LOCAL_PATH)/sku/build_ProTUR.prop:$(TARGET_COPY_OUT_ODM)/etc/build_ProTUR.prop

# Secure Element
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_JPN/android.hardware.se.omapi.ese.xml

PRODUCT_PACKAGES += \
    android.hardware.secure_element-service.thales

# Security
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
INIT_BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := 2026-04-05

# Sensors
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_volcano/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_volcano/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_volcano/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_volcano/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_volcano/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_volcano/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_volcano/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_volcano/android.hardware.sensor.stepdetector.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf \

TP_SYSFS_PATH := /sys/devices/platform/soc/ac0000.qcom,qupv3_0_geni_se/a80000.spi/spi_master/spi0/spi0.0

$(call soong_config_set,nothing_sensors,tp_single_tap_path,$(TP_SYSFS_PATH)/fts_gesture_single_tap_pressed)
$(call soong_config_set,nothing_sensors,tp_single_tap_enabled_path,$(TP_SYSFS_PATH)/fts_gesture_single_tap_enabled)
$(call soong_config_set,nothing_sensors,tp_single_tap_coords_path,/proc/touchpanel/gesture_code)

$(call soong_config_set,nothing_sensors,tp_udfps_path,$(TP_SYSFS_PATH)/fts_fod_pressed)
$(call soong_config_set,nothing_sensors,tp_udfps_enabled_path,$(TP_SYSFS_PATH)/fts_fod_enabled)

PRODUCT_PACKAGES += \
    android.hardware.sensors-service.nothing-multihal \
    sensors.nothing \
    sensors.dynamic_sensor_hal

# Soong
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/nothing \
    hardware/qcom/wlan/qcwcn \
    kernel/nothing/sm7635 \
    hardware/qcom/audio \
    vendor/qcom/opensource/audio-hal/st-hal-ar

# Storage
PRODUCT_CHARACTERISTICS := nosdcard

# Task profiles
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# Telephony
# Only the QSSI half of the QTI telephony component: its vendor half also
# exports vendor/qcom/opensource/data-ipa-cfg-mgr, which clashes with the
# sm8650 IPACM above.
$(call inherit-product, device/qcom/common/system/telephony/qti-telephony.mk)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.telephony.mbms.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.mbms.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml

PRODUCT_PACKAGES += \
    extphonelib \
    extphonelib-product \
    extphonelib.xml \
    extphonelib_product.xml \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils \
    qti-telephony-utils-prd \
    qti_telephony_utils.xml \
    qti_telephony_utils_prd.xml \
    telephony-ext

PRODUCT_PACKAGES += \
    qcrilNrDb_vendor

PRODUCT_BOOT_JARS += \
    nt-telephony-interface

# Nothing-fwk
PRODUCT_PACKAGES += \
    nothing-fwk

PRODUCT_BOOT_JARS += \
    nothing-fwk

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal/thermal-engine.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf


# USB
PRODUCT_HAS_GADGET_HAL := true
$(call inherit-product, vendor/qcom/opensource/usb/vendor_product.mk)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/usb/etc

# Update Engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

# Vendor Service Manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator.service.nothing-rt_ics

# Wi-Fi
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/qca6750/WCNSS_qcom_cfg.ini \

    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    firmware_wlanmdsp.otaupdate_symlink \
    firmware_wlan_mac.bin_symlink \
    hostapd \
    libwifi-hal-ctrl \
    libwifi-hal-qcom \
    wpa_supplicant \
    wpa_supplicant.conf
