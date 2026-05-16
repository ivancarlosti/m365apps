# m365apps

A lightweight, menu-driven script that installs (or uninstalls) **Microsoft 365 Apps** on Windows using Microsoft's official **Office Deployment Tool (ODT)** and curated XML configurations.

<!-- buttons -->

<!-- endbuttons -->

## What it does

`m365apps.bat` shows a numbered menu, downloads the latest `setup.exe` (ODT) straight from Microsoft, and runs it against the XML configuration that matches your selection. The XML files in [XMLFiles/](XMLFiles/) describe exactly which products, languages and channels to install.

## How it works

1. **Boot** — [m365apps.bat](m365apps.bat) sets its working directory to the script folder and switches the console to UTF-8.
2. **Self-update** — at every run, the script downloads the latest Office Deployment Tool binary from Microsoft's official CDN:

   ```
   https://officecdn.microsoft.com/pr/wsus/setup.exe
   ```

   It tries `curl.exe` first (built into Windows 10 1803+ and Windows 11), and falls back to PowerShell `Invoke-WebRequest` with TLS 1.2 if curl is unavailable. The file is saved to `%TEMP%\m365apps_setup.exe`, so the repo never carries an outdated binary.
3. **Menu** — the script displays the options below and waits for a single keypress via `CHOICE`.
4. **Install / uninstall** — the chosen option calls:

   ```bat
   "%TEMP%\m365apps_setup.exe" /configure "XMLFiles\<file>.xml"
   ```

   The ODT then downloads the requested Office bits from Microsoft and silently installs them according to the XML.

## Menu options

| Key | Action | XML used |
| :-: | --- | --- |
| `1` | Install Office Business + Project + Visio | [InstallOfficeProjectVisio-Business.xml](XMLFiles/InstallOfficeProjectVisio-Business.xml) |
| `2` | Install Office Business (US + BR + MX) | [InstallOffice-Business-US.xml](XMLFiles/InstallOffice-Business-US.xml) |
| `3` | Install Office Business (Brazil only) | [InstallOffice-Business-BR.xml](XMLFiles/InstallOffice-Business-BR.xml) |
| `4` | Install Office Enterprise + Project + Visio | [InstallOfficeProjectVisio-Enterprise.xml](XMLFiles/InstallOfficeProjectVisio-Enterprise.xml) |
| `5` | Install Office Enterprise (US + BR + MX) | [InstallOffice-Enterprise-US.xml](XMLFiles/InstallOffice-Enterprise-US.xml) |
| `6` | Install Office Enterprise (Brazil only) | [InstallOffice-Enterprise-BR.xml](XMLFiles/InstallOffice-Enterprise-BR.xml) |
| `7` | Install Office Home + Project + Visio | [InstallOfficeProjectVisio-Home.xml](XMLFiles/InstallOfficeProjectVisio-Home.xml) |
| `8` | Install Office Home (US + BR + MX) | [InstallOffice-Home-US.xml](XMLFiles/InstallOffice-Home-US.xml) |
| `9` | Install Office Home (Brazil only) | [InstallOffice-Home-BR.xml](XMLFiles/InstallOffice-Home-BR.xml) |
| `0` | Uninstall **all** Office products | [UninstallOffice.xml](XMLFiles/UninstallOffice.xml) |

## What the XML configurations do

All install profiles in [XMLFiles/](XMLFiles/) share the same defaults:

- `OfficeClientEdition="64"` — 64-bit install
- `Channel="Current"` — Microsoft 365 Current Channel
- `ExcludeApp` — removes `Groove` (OneDrive for Business legacy) and `Lync` (Skype for Business)
- `AUTOACTIVATE="1"` — activates automatically when a license is available
- `PinIconsToTaskbar="TRUE"` — pins app icons to the taskbar
- `Display Level="None"` and `AcceptEULA="TRUE"` — fully silent install
- `Updates Enabled="TRUE"` — keeps Office updating after install

Variants differ by **product SKU** (`O365BusinessRetail`, `O365ProPlusRetail`, `O365HomePremRetail`), **languages**, and whether **Visio Pro** and **Project Pro** are included. The `-BR` files install only `pt-br`; the `-US` files install `en-us`, `pt-br` and `es-mx`; the `ProjectVisio` files install `en-us` plus `pt-br` / `es-mx` proofing tools.

[UninstallOffice.xml](XMLFiles/UninstallOffice.xml) runs `<Remove All="TRUE" />`, which silently removes every Click-to-Run Office product on the machine.

## Requirements

- **Windows 10 / 11** (x64). The script uses built-in `curl.exe` or PowerShell — no extra dependencies.
- **Administrator privileges** — right-click `m365apps.bat` and choose **Run as administrator**, otherwise the Office Deployment Tool cannot write to Program Files.
- **Active internet connection** — both the ODT itself and the Office payload are downloaded at runtime.

## Usage

1. Download or clone this repository.
2. Right-click [m365apps.bat](m365apps.bat) → **Run as administrator**.
3. Pick a number from the menu and wait. The Office installer window may stay hidden (silent mode); installation progress can be observed in Task Manager (`OfficeClickToRun.exe`).
4. When finished, sign in with your Microsoft 365 account to activate.

## Customizing an install

To tweak which products, languages or channel are installed, edit the matching XML in [XMLFiles/](XMLFiles/). The schema is Microsoft's official Office Deployment Tool format — see the [ODT configuration reference](https://learn.microsoft.com/en-us/deployoffice/office-deployment-tool-configuration-options) for every supported option (channels like `MonthlyEnterprise` or `SemiAnnual`, additional `<ExcludeApp>` entries, MAK keys, logging, etc.). You can also generate a fresh XML from the Microsoft 365 Apps admin center at [config.office.com](https://config.office.com) and drop it into [XMLFiles/](XMLFiles/).

## Custom fixes

The [Custom fixes/](Custom%20fixes/) folder contains optional registry tweaks:

- **[Show Insider button](Custom%20fixes/Show%20Insider%20button/)** — hides the Office Insider button in apps that show it by default.
- **[Update branch](Custom%20fixes/Update%20branch/)** — removes a stuck `UpdateBranch` registry value that can pin Office to the wrong channel.

Double-click the `.reg` file you need and confirm the prompt. Both are sourced from Robert Sparnaaij's articles on [msoutlook.info](https://www.msoutlook.info).

<!-- footer -->
---

## 🧑‍💻 Consulting and technical support
* For personal support and queries, please submit a new issue to have it addressed.
* For commercial related questions, please [**contact me**][ivancarlos] for consulting costs. 

| 🩷 Project support |
| :---: |
If you found this project helpful, consider [**buying me a coffee**][buymeacoffee]
|Thanks for your support, it is much appreciated!|

[ivancarlos]: https://ivancarlos.me
[buymeacoffee]: https://www.buymeacoffee.com/ivancarlos
