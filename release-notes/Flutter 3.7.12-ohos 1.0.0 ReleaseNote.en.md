## Version Overview
This version is the Flutter OpenHarmony platform version 1.0.0, based on the Flutter 3.7.12. This version supports and improves the capabilities of the OpenHarmony platform, provides platform-based channels, external texture, cloud SDKs and other features, and optimizes performance.

## Release scope
HarmonyOS NEXT, API12

## New features
- Support OpenHarmony platform Flutter Channel
- Support OpenHarmony platform Flutter Engine
- Support OpenHarmony platform Flutter Command line tool
- Support OpenHarmony platform External Texture
- Support OpenHarmony platform SDK
- Official library & Third-party library OpenHarmony platform adaptation

## Release time
August 28, 2024

## Version Mapping
- ROM: 205.0.0.61(SP1C00E63R4P9) / NEXT.0.0.61(SP1C00E63R4P9)
- IDE: DevEco Studio 5.0.3.706
- SDK: HarmonyOS SDK 5.0.0.61(SP1), API12
- Flutter SDK: 3.7.12-ohos-1.0.0

## Development Documentation

- [Document](https://gitee.com/openharmony-sig/flutter_samples/tree/master/ohos/docs)

## Third-party library list
- Official library:

    [Official library](https://gitee.com/openharmony-sig/flutter_packages)

- Third-party library:

    | Third-party library name | Warehouse address |
    |:----|:----|
    |sqflite|https://gitee.com/openharmony-sig/flutter_sqflite|
    |permission_handler|https://gitee.com/openharmony-sig/flutter_permission_handler|
    |fluttertoast|https://gitee.com/openharmony-sig/flutter_fluttertoast|
    |connectivity_plus|https://gitee.com/openharmony-sig/flutter_plus_plugins|
    |device_info_plus|https://gitee.com/openharmony-sig/flutter_plus_plugins|
    |package_info_plus|https://gitee.com/openharmony-sig/flutter_plus_plugins|
    |connectivity|https://gitee.com/openharmony-sig/flutter_plus_plugins|
    |package_info|https://gitee.com/openharmony-sig/flutter_plus_plugins|
    |audio_session|https://gitee.com/openharmony-sig/flutter_audio_session/|
    |flutter_native_image|https://gitee.com/openharmony-sig/flutter_native_image|
    |flutter_sound|https://gitee.com/openharmony-sig/flutter_sound|
    |image_gallery_saver|https://gitee.com/openharmony-sig/flutter_image_gallery_saver|
    |location|https://gitee.com/openharmony-sig/flutter_location|
    |power_image|https://gitee.com/openharmony-sig/flutter_power_image|
    |share_plus|https://gitee.com/openharmony-sig/flutter_plus_plugins|
    |wakelock|https://gitee.com/openharmony-sig/flutter_wakelock|
    |flutter_console|https://gitee.com/openharmony-sig/flutter_console|
    |audioplayers|https://gitee.com/openharmony-sig/flutter_audioplayers|
    |gpu_image|https://gitee.com/openharmony-sig/flutter_gpu_image|
    |image_crop|https://gitee.com/openharmony-sig/flutter_image_crop|
    |bitmap|https://gitee.com/openharmony-sig/flutter_bitmap|
    |leak_detector|https://gitee.com/openharmony-sig/flutter_leak_detector|
    |flutter_math_fork|https://gitee.com/openharmony-sig/flutter_math_fork|
    |flutter_contacts|https://gitee.com/openharmony-sig/flutter_contacts|
    |flutter_inappwebview|https://gitee.com/openharmony-sig/flutter_inappwebview|
    |flutter_keyboard_visibility|https://gitee.com/openharmony-sig/flutter_keyboard_visibility|
    |flutter_widget_from_html|https://gitee.com/openharmony-sig/flutter_widget_from_html|
    |mobile_scanner|https://gitee.com/openharmony-sig/fluttertpc_mobile_scanner|
    |device_util|https://gitee.com/openharmony-sig/fluttertpc_device_util|
    |export_video_frame|https://gitee.com/openharmony-sig/fluttertpc_export_video_frame|
    |flutter_local_notifications|https://gitee.com/openharmony-sig/fluttertpc_flutter_local_notifications|
    |flutter_phone_direct_caller|https://gitee.com/openharmony-sig/fluttertpc_flutter_phone_direct_caller|
    |flutter_screenshot_callback|https://gitee.com/openharmony-sig/fluttertpc_screenshot_callback|
    |flutter_sms|https://gitee.com/openharmony-sig/fluttertpc_flutter_sms|
    |media_info|https://gitee.com/openharmony-sig/fluttertpc_media_info|
    |orientation|https://gitee.com/openharmony-sig/fluttertpc_orientation|
    |recognition_qrcode|https://gitee.com/openharmony-sig/fluttertpc_recognition_qrcode|
    |video_compress|https://gitee.com/openharmony-sig/fluttertpc_video_compress|
    |share_extend|https://gitee.com/openharmony-sig/fluttertpc_share_extend|
    |catcher|https://gitee.com/openharmony-sig/fluttertpc_catcher|
    |flutter_mailer|https://gitee.com/openharmony-sig/fluttertpc_flutter_mailer|
    |gallery_saver|https://gitee.com/openharmony-sig/fluttertpc_gallery_saver|
    |flutter_localization|https://gitee.com/openharmony-sig/flutter_localization|
    |keyboard_actions|https://gitee.com/openharmony-sig/fluttertpc_keyboard_actions|
    |native_device_orientation|https://gitee.com/openharmony-sig/fluttertpc_native_device_orientation|
    |screen|https://gitee.com/openharmony-sig/fluttertpc_screen|
    |pdf_render|https://gitee.com/openharmony-sig/fluttertpc_pdf_render|


## Known Issues
- When multiple PlatformViews are mixed with native development, the first PlatformView page will not be updated when opening the second page and returning to the first page.