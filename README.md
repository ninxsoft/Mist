<img align="left" width="128" height="128" src="README%20Resources/App%20Icon.png">

# MIST - macOS Installer Super Tool

![Latest Release](https://img.shields.io/github/v/release/ninxsoft/Mist?display_name=tag&label=Latest%20Release&sort=semver) ![Downloads](https://img.shields.io/github/downloads/ninxsoft/Mist/total?label=Downloads) [![Linting](https://github.com/ninxsoft/Mist/actions/workflows/linting.yml/badge.svg)](https://github.com/ninxsoft/Mist/actions/workflows/linting.yml) [![Unit Tests](https://github.com/ninxsoft/Mist/actions/workflows/unit_tests.yml/badge.svg)](https://github.com/ninxsoft/Mist/actions/workflows/unit_tests.yml) [![Build](https://github.com/ninxsoft/Mist/actions/workflows/build.yml/badge.svg)](https://github.com/ninxsoft/Mist/actions/workflows/build.yml)

A Mac utility that automatically downloads macOS Firmwares / Installers:

![Example Screenshot](README%20Resources/Example.png)

## :information_source: Check out [mist-cli](https://github.com/ninxsoft/mist-cli) for the companion command-line tool!

## ![Slack](README%20Resources/Slack.png) Check out [#mist](https://macadmins.slack.com/archives/CF0CFM5B7) on the [Mac Admins Slack](https://macadmins.slack.com) to discuss all things Mist!

## Features

- [x] List all available macOS Firmwares / Installers available for download:
  - Display names, versions, builds, release dates and sizes
  - Optionally show beta versions of macOS
  - Filter macOS versions that are compatible with the Mac the app is being run from
  - Export lists as **CSV**, **JSON**, **Property List** or **YAML**
- [x] Download available macOS Firmwares / Installers:
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
    - Select custom Software Update Catalogs, allowing you to list and download macOS Installers from the following:
      - **Standard:** The default catalog that ships with macOS
      - **Customer Seed:** The catalog available as part of the [AppleSeed Program](https://appleseed.apple.com/)
      - **Developer Seed:** The catalog available as part of the [Apple Developer Program](https://developer.apple.com/programs/)
      - **Public Seed:** The catalog available as part of the [Apple Beta Software Program](https://beta.apple.com/)
      - **Note:** Catalogs from the Seed Programs may contain beta / unreleased versions of macOS. Ensure you are a member of these programs before proceeding.
    - Validates the Chunklist checksums upon download
  - Automatic retries for failed downloads!

**Note:** Depending on what **Mist** downloads, you may require allowing **Full Disk Access** for **Mist** via [System Settings](https://support.apple.com/en-us/guide/mac-help/mh15217/13.0/mac/13.0):

![Full Disk Access](README%20Resources/Full%20Disk%20Access.png)

## Build Requirements

- Swift **5.8** | Xcode **14.0**.
- Runs on macOS Monterey **12.0** and later.

## Download

Grab the latest version of **Mist** from the [releases page](https://github.com/ninxsoft/Mist/releases).

## Credits / Thank You

- Project created and maintained by Nindi Gill ([ninxsoft](https://github.com/ninxsoft)).
- JP Simard ([jpsim](https://github.com/jpsim)) for [Yams](https://github.com/jpsim/Yams), used to export lists as YAML.
- Josh Kaplan ([jakaplan](https://github.com/jakaplan)) for [Blessed](https://github.com/trilemma-dev/Blessed) and [SecureXPC](https://github.com/trilemma-dev/SecureXPC), which are used to support the Privileged Helper Tool.
- The Sparkle Project ([sparkle-project](https://github.com/sparkle-project)) for [Sparkle](https://github.com/sparkle-project/Sparkle), used to auto update Mist.
- Callum Jones ([cj123](https://github.com/cj123)) for [IPSW Downloads API](https://ipswdownloads.docs.apiary.io), used to determine macOS Firmware metadata.

## License

> Copyright © 2023 Nindi Gill
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
