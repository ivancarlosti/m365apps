# Microsoft 365 Apps script

A lightweight, menu-driven script that installs (or uninstalls) Microsoft 365 Apps on Windows using Microsoft's official Office Deployment Tool (ODT) and curated XML configurations.

<!-- buttons -->
[![Stars](https://img.shields.io/github/stars/ivancarlosti/m365apps?label=⭐%20Stars&color=gold&style=flat)](https://github.com/ivancarlosti/m365apps/stargazers)
[![Watchers](https://img.shields.io/github/watchers/ivancarlosti/m365apps?label=Watchers&style=flat&color=red)](https://github.com/sponsors/ivancarlosti)
[![Forks](https://img.shields.io/github/forks/ivancarlosti/m365apps?label=Forks&style=flat&color=ff69b4)](https://github.com/sponsors/ivancarlosti)
[![Downloads](https://img.shields.io/github/downloads/ivancarlosti/m365apps/total?label=Downloads&color=success)](https://github.com/ivancarlosti/m365apps/releases)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/ivancarlosti/m365apps?label=Activity)](https://github.com/ivancarlosti/m365apps/pulse)  
[![GitHub Issues](https://img.shields.io/github/issues/ivancarlosti/m365apps?label=Issues&color=orange)](https://github.com/ivancarlosti/m365apps/issues)
[![License](https://img.shields.io/github/license/ivancarlosti/m365apps?label=License)](LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/ivancarlosti/m365apps?label=Last%20Commit)](https://github.com/ivancarlosti/m365apps/commits)
[![Security](https://img.shields.io/badge/Security-View%20Here-purple)](https://github.com/ivancarlosti/m365apps/security)  
[![Code of Conduct](https://img.shields.io/badge/Code%20of%20Conduct-2.1-4baaaa)](https://github.com/ivancarlosti/m365apps?tab=coc-ov-file)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/ivancarlosti?label=GitHub%20Sponsors&color=ffc0cb)][sponsor]
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00)][buymeacoffee]
[![Patreon](https://img.shields.io/badge/Patreon-f96854)][patreon]
<!-- endbuttons -->

## 📦 About

`m365apps` is a self-contained Windows installer that wraps the official
[Microsoft Office Deployment Tool (ODT)](https://learn.microsoft.com/en-us/deployoffice/overview-office-deployment-tool)
with a friendly menu. It downloads the latest `setup.exe` straight from
Microsoft's CDN at runtime, then drives it with one of the curated XML
configurations under [XMLFiles/](XMLFiles/) so you can install or uninstall
Microsoft 365 Apps (Business, Enterprise or Home, with optional Project and
Visio) without manually crafting a configuration file.

## 🚀 Usage

1. Download the latest release (or clone this repo).
2. Right-click [m365apps.bat](m365apps.bat) and choose **Run as administrator**.
3. Pick an option from the menu and let the installer run.

The script will self-elevate via UAC if you forget the right-click step.

## ⚙️ How the script works

[m365apps.bat](m365apps.bat) runs in four stages:

### 1. Elevation
The first block checks whether the script is already running with
administrative rights. If not, it generates a small VBScript in `%TEMP%` that
re-launches the batch file through `ShellExecute ... "runas"`, triggering the
UAC prompt. Once elevated, execution jumps to the `:Privileges_got` label.

### 2. Bootstrap the Office Deployment Tool
Instead of shipping `setup.exe` in the repository, the script downloads a
fresh copy from Microsoft on every run:

```
SETUP_URL = https://officecdn.microsoft.com/pr/wsus/setup.exe
SETUP_DIR = %TEMP%\m365apps
SETUP_EXE = %TEMP%\m365apps\setup.exe
```

- The temp folder is created if missing.
- Any leftover `setup.exe` from a previous run is removed first, so you always
  use the latest signed binary published by Microsoft.
- The download is performed by the built-in `curl.exe` (available on Windows
  10 1803+ and Windows 11) with `-fSL` so failures abort the script with a
  clear message.

### 3. Interactive menu
A `choice /c 1234567890` prompt presents ten options:

| Key | Action |
| :-: | :----- |
| 1 | Install Office Business + Project + Visio (US + BR + MX) |
| 2 | Install Office Business (US + BR + MX) |
| 3 | Install Office Business (Brazil only) |
| 4 | Install Office Enterprise + Project + Visio (US + BR + MX) |
| 5 | Install Office Enterprise (US + BR + MX) |
| 6 | Install Office Enterprise (Brazil only) |
| 7 | Install Office Home + Project + Visio (US + BR + MX) |
| 8 | Install Office Home (US + BR + MX) |
| 9 | Install Office Home (Brazil only) |
| 0 | Uninstall all Office packages |

Each selection sets `DESC` (label shown to the user) and `XML` (path to the
matching configuration under [XMLFiles/](XMLFiles/)) and jumps to a single
`:run` label that invokes:

```
"%SETUP_EXE%" /configure "%XML%"
```

This is the standard ODT command — `setup.exe` reads the XML, contacts
Microsoft's CDN and installs/uninstalls the requested products and languages.

### 4. Cleanup
When `setup.exe` returns control, the script deletes the temporary
`setup.exe` and removes `%TEMP%\m365apps`, leaving no binaries behind. It then
pauses so you can confirm that the Office installer started before closing
the window.

## 🗂️ Configuration files

The XML files under [XMLFiles/](XMLFiles/) follow the standard
[Office Deployment Tool schema](https://learn.microsoft.com/en-us/deployoffice/office-deployment-tool-configuration-options).
Edit them (or drop new ones in) to customise products, languages, channels or
excluded apps, then point a new menu entry at the file.

## 🛠️ Requirements

- Windows 10 1803 or later (for the built-in `curl.exe`) / Windows 11.
- Administrator rights (the script self-elevates).
- An active internet connection — `setup.exe` and the Office payload are both
  downloaded from Microsoft.

<!-- footer -->
---

## 🧑‍💻 Consulting and technical support
* For personal support and queries, please submit a new issue to have it addressed.
* For commercial related questions, please [**contact me**][ivancarlos] for consulting costs. 

| 🩷 Project support |
| :---: |
If you found this project helpful, consider [**buying me a coffee**][buymeacoffee]
|Thanks for your support, it is much appreciated!|

[cc]: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/adding-a-code-of-conduct-to-your-project
[contributing]: https://docs.github.com/en/articles/setting-guidelines-for-repository-contributors
[security]: https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository
[support]: https://docs.github.com/en/articles/adding-support-resources-to-your-project
[it]: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository#configuring-the-template-chooser
[prt]: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository
[funding]: https://docs.github.com/en/articles/displaying-a-sponsor-button-in-your-repository
[ivancarlos]: https://ivancarlos.me
[buymeacoffee]: https://buymeacoffee.com/ivancarlos
[patreon]: https://www.patreon.com/ivancarlos
[paypal]: https://icc.gg/donate
[sponsor]: https://github.com/sponsors/ivancarlosti
