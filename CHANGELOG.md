# Changelog

## [0.5](https://github.com/ninxsoft/Mist/releases/tag/v0.5) - 2022-12-29

- The macOS Installer cache can now be emptied even if **Cache downloads** is disabled - thanks Pico Mitchell ([PicoMitchell](https://github.com/PicoMitchell))!
- Window tabs are now disabled - thanks Pico Mitchell ([PicoMitchell](https://github.com/PicoMitchell))!
- The **Close Window (⌘-W)** keyboard shortcut is now available once again - thanks Pico Mitchell ([PicoMitchell](https://github.com/PicoMitchell))!
- CSV exports are now working correctly again - thanks JoGlib ([JoGlib](https://github.com/JoGilb))!
- Removed unused declarations and imports (ie. dead code)
- Bumped [Sparkle](https://github.com/sparkle-project/Sparkle) version to **2.3.1**
- Minor cosmetic fixes

## [0.4](https://github.com/ninxsoft/Mist/releases/tag/v0.4) - 2022-12-10

- Building a package for macOS Big Sur or newer is now much faster, as the Apple-provided package is just re-used
- Custom Catalog URLs have been replaced with a default set of Apple-provided Software Update Catalogs in the app preferences
  - The standard catalog that ships with macOS is enabled by default
  - Additional Seed Program catalogs can be enabled
  - **Note:** Catalogs from the Seed Programs may contain beta / unreleased versions of macOS. Ensure you are a member of these programs before proceeding
- Users are now notified when the macOS Installer cache directory has incorrect ownership / permissions, and are given the option to repair
- Cache directories for specific macOS Installers with incorrect ownership / permissions will attempt to repair on-the-fly

## [0.3](https://github.com/ninxsoft/Mist/releases/tag/v0.3) - 2022-09-26

- The macOS Installer cache directory can now be customised in the app preferences
- Calculating ISO image sizes is _slightly_ more dynamic (to better support macOS Ventura ISOs)
- macOS Installer SHA-1 checksums are now only validated when they are present
- Minor cosmetic tweaks

## [0.2](https://github.com/ninxsoft/Mist/releases/tag/v0.2) - 2022-07-15

- Users are now notified of incompatible macOS Firmwares / Installers before downloading
- Placeholder icons for macOS Ventura have been updated with the real deal
- Custom Catalog URLs are no longer being ignored
- The Catalog URLs heading is now aligned correctly under Preferences

## [0.1.1](https://github.com/ninxsoft/Mist/releases/tag/v0.1.1) - 2022-07-01

- Intermediate cache directories are now created if required
- Downloads no longer retry indefinitely

## [0.1](https://github.com/ninxsoft/Mist/releases/tag/v0.1) - 2022-07-01

- Initial release
