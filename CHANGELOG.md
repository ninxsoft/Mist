# Changelog

## [0.9.1](https://github.com/ninxsoft/Mist/releases/tag/v0.9.1) - 2023-08-25

- Fixed insecure HTTP URLs for certain Firmware files - thanks [F1248](https://github.com/F1248)!
- Fixed a bug where downloads were not being cancelled when the Escape key was being pressed - thanks [F1248](https://github.com/F1248)!
- Rolled back the Bootable Disk Image (ISO) shrinking logic that was preventing the ISOs from booting correctly - thanks [mviron](https://github.com/mviron), [tulgeywood](https://github.com/tulgeywood) and [mibosshard](https://github.com/mibosshard)!
- Improved the error message output when installing the Privileged Helper Tool failed - thanks [DevLiuSir](https://github.com/DevLiuSir) and [bhagatparwinder](https://github.com/bhagatparwinder)!
- Bumped [Yams](https://github.com/jpsim/Yams) version to **5.0.6**

## [0.9](https://github.com/ninxsoft/Mist/releases/tag/v0.9) - 2023-06-26

- Added the ability to remove individual macOS Installer cached downloads
  - Managed via the app **Settings > Installers** pane
  - Thanks [dracinn](https://github.com/dracinn)!
- Added a shiny new macOS Sonoma application installer icon!
- Updated Firmware / Installer tooltips to include release names
- Improved the error messaging when refreshing Firmwares fails due to pending server-side updates
- Bootable Disk Image (ISO) sizes are now calculated dynamically, with minimal free space
  - Thanks [devZer0](https://github.com/devZer0) and [carlashley](https://github.com/carlashley)!
- Fixed a bug where scrolling / clicking on the **Beta** ribbon on top of images caused Mist to crash
  - Thanks [PicoMitchell](https://github.com/PicoMitchell), [5T33Z0](https://github.com/5T33Z0) and [matxpa](https://github.com/matxpa)!

## [0.8.1](https://github.com/ninxsoft/Mist/releases/tag/v0.8.1) - 2023-06-15

- Fixed a bug where **macOS Sierra 10.12.6**, **OS X El Capitan 10.11.6** and **OS X Yosemite 10.10.5** would fail to download
  - Thanks [BenFRC5147](https://github.com/BenFRC5147), [AKERDoc](https://github.com/AKERDoc), [F1248](https://github.com/F1248) and [crystall1nedev](https://github.com/crystall1nedev)!
- Fixed another bug where Mist allowed exporting **ISOs** when it should not

## [0.8](https://github.com/ninxsoft/Mist/releases/tag/v0.8) - 2023-06-14

- Mist now supports the creation of **Bootable Installers**
  - If available, click on the new Bootable Installer button on the right-hand side of the **Installers** list rows
  - Select a **Mac OS Extended (Journaled)** volume to create a Bootable Installer
  - Available for **macOS Big Sur 11** and newer on **Apple Silicon Macs**
  - Available for **OS X Yosemite 10.10.5** and newer on **Intel-based Macs**
  - Thanks [5T33Z0](https://github.com/5T33Z0)!
- Fixed a bug where Mist allowed exporting **ISOs** for **OS X Mountain Lion 10.8.5** and older on **Intel-based Macs**
- Adding missing **tooltips** for Firmwares / Installers (hover to view)
- Minor cosmetic fixes, including tweaks to button styles and accent colors

## [0.7.1](https://github.com/ninxsoft/Mist/releases/tag/v0.7.1) - 2023-06-09

- Fixed a bug where the list of Firmwares / Installers would wrap incorrectly when **Show scroll bars** was set to **Always** in **Settings > Appearance**
  - Thanks [kevinmcox](https://github.com/kevinmcox)!

## [0.7](https://github.com/ninxsoft/Mist/releases/tag/v0.7) - 2023-06-09

- Added preliminary support for **macOS Sonoma 14**
- Updated the **app icon** and **accent color** to reflect macOS Sonoma (including dark appearance)
- Updated the **Download** button look and feel
- Moved the **Beta** tag to a ribbon that wraps around the macOS icon
- Mist now scrolls to the active task automatically in the activity screen
- Mist now remembers the last selected **Firmwares** / **Installers** tab when the app is relaunched
- Added missing tooltip for the **Refresh** toolbar button
- Updated the **Firmware** icon for the **Settings > Firmwares** pane
  - Thanks [isthisthingon](https://isthisthingon.tech)!
- Fixed a bug where **Full Disk Access** was being checked even when downloading Firmwares
  - Thanks [dczward](https://macadmins.slack.com/team/U19TV67S6) and [PicoMitchell](https://github.com/PicoMitchell)!
- Fixed a bug where selecting an **ISO** for compatible Installers caused non-compatible Installers to display available export types incorrectly
- Fixed a bug where Intel Macs would not determine compatible legacy operating systems (**10.7 - 10.12**) correctly
  - Thanks [BenFRC5147](https://github.com/BenFRC5147)!

## [0.6](https://github.com/ninxsoft/Mist/releases/tag/v0.6) - 2023-06-06

- Added support for the following legacy operating systems:
  - macOS Sierra 10.12.6
  - OS X El Capitan 10.11.6
  - OS X Yosemite 10.10.5
  - OS X Mountain Lion 10.8.5
  - Mac OS X Lion 10.7.5
  - Thanks [n8felton](https://github.com/n8felton)!
- Added a **Show in Finder upon completion** checkbox to the download screen
  - Thanks [BigMacAdmin](https://github.com/BigMacAdmin)!
- Added a **Full Disk Access** verfication step prior to downloading a macOS Firmware / Installer
  - Thanks [ihubgit](https://github.com/ihubgit) & [NorseGaud](https://github.com/NorseGaud)!
- Added a warning when attempting to build an **ISO** for **macOS Catalina 10.15 or older** on Apple Silicon Macs
  - Thanks [KenjiTakahashi](https://github.com/KenjiTakahashi)!
- The Mist.app **Login Item** title now displays the app name and not the developer's name
  - Thanks [PicoMitchell](https://github.com/PicoMitchell)!
- Temporary volumes are now hidden, and no longer show in Finder when mounted during image creation
  - Thanks [wakco](https://github.com/wakco)!
- Mist now has more comprehensive error messages of failed tasks
  - Thanks [IronCraftMan](https://github.com/IronCraftMan)!
- Fixed a bug where warning messages would not cascade correctly
- Fixed a bug where file and directory ownership was being checked incorrectly
- Fixed a bug where icons would flicker during animation in the **Settings > Applications** tab
- Fixed a bug where the Mist window would not resize correctly

## [0.5](https://github.com/ninxsoft/Mist/releases/tag/v0.5) - 2022-12-29

- The macOS Installer cache can now be emptied even if **Cache downloads** is disabled
  - Thanks [PicoMitchell](https://github.com/PicoMitchell)!
- Window tabs are now disabled
  - Thanks [PicoMitchell](https://github.com/PicoMitchell)!
- The **Close Window (⌘-W)** keyboard shortcut is now available once again
  - Thanks [PicoMitchell](https://github.com/PicoMitchell)!
- CSV exports are now working correctly again
  - Thanks [JoGlib](https://github.com/JoGilb)!
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
