<img align="left" width="128" height="128" src="Readme%20Resources/App%20Icon.png">

# MIST - macOS Installer Super Tool

A Mac utility that automatically downloads macOS Firmwares / Installers:

![Example - Firmwares](Readme%20Resources/Example%20-%20Firmwares.png)

![Example - Installers](Readme%20Resources/Example%20-%20Installers.png)

## :information_source: Check out [mist-cli](https://github.com/ninxsoft/mist-cli) for the companion command-line tool!

## Features

- [x] List all available macOS Firmwares / Installers available for download:
  - Display names, versions, builds, release dates and sizes
  - Show / hide betas
  - Show / hide macOS versions compatible with the Mac the app is being run from
  - Export lists as **CSV**, **JSON**, **Property List** or **YAML**
- [x] Download an available macOS Firmware / Installer:
  - For Apple Silicon Macs:
    - Download a Firmware Restore file (.ipsw)
    - Validates the SHA-1 checksum upon download
  - For Intel based Macs (Universal for macOS Big Sur and later):
    - Generate an Application Bundle (.app)
    - Generate a Disk Image (.dmg)
    - Generate a Bootable Disk Image (.iso)
      - For use with virtualization software (ie. Parallels Desktop, UTM, VMware Fusion, VirtualBox)
    - Generate a macOS Installer Package (.pkg)
      - Supports packages on **macOS Big Sur and newer** with a massive 12GB+ payload!
    - Optionally codesign Disk Images and macOS Installer Packages
    - Cache downloads to speed up build operations
    - Optionally specify custom catalog URLs, allowing you to list and download macOS Installers from the following:
      - **Customer Seed** - AppleSeed Program
      - **Developer Seed** - Apple Developer Program
      - **Public Seed** - Apple Beta Software Program
    - Validates the Chunklist checksums upon download
  - Automatic retries for failed downloads!

## Build Requirements

- Swift **5.5**.
- Xcode **14.0**.
- Runs on macOS Monterey **12.0** and later.

## Download

Grab the latest version of **Mist** from the [releases page](https://github.com/ninxsoft/Mist/releases).

## Credits / Thank You

- Project created and maintained by Nindi Gill ([ninxsoft](https://github.com/ninxsoft)).
- JP Simard ([jpsim](https://github.com/jpsim)) for [Yams](https://github.com/jpsim/Yams), used to export lists as YAML.
- Josh Kaplan ([jakaplan](https://github.com/jakaplan)) for [Blessed](https://github.com/trilemma-dev/Blessed), [EmbeddedPropertyList](https://github.com/trilemma-dev/EmbeddedPropertyList), and [SecureXPC](https://github.com/trilemma-dev/SecureXPC), which are all used to support the Privileged Helper Tool.
- The Sparkle Project ([sparkle-project](https://github.com/sparkle-project)) for [Sparkle](https://github.com/sparkle-project/Sparkle), used to auto update Mist.

## Version History

- 0.2

  - Users are now notified of incompatible macOS Firmwares / Installers before downloading
  - Placeholder icons for macOS Ventura have been updated with the real deal
  - Custom Catalog URLs are no longer being ignored
  - The Catalog URLs heading is now aligned correctly under Preferences

- 0.1.1

  - Intermediate cache directories are now created if required
  - Downloads no longer retry indefinitely

- 0.1

  - Initial release

## License

> Copyright © 2022 Nindi Gill
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
