# m365apps

A lightweight, menu-driven script that installs (or uninstalls) **Microsoft 365 Apps** on Windows using Microsoft's official **Office Deployment Tool (ODT)** and curated XML configurations.

<!-- buttons -->

<!-- endbuttons -->

## What it does

`m365apps.ps1` shows a numbered menu, downloads the latest Office Deployment Tool (ODT) straight from Microsoft, extracts `setup.exe` next to the script and runs it against the XML configuration that matches your selection. The XML files in [XMLFiles/](XMLFiles/) describe exactly which products, languages and channels to install.

## How it works

1. **Boot** — [m365apps.ps1](m365apps.ps1) sets its working directory to the script folder and switches the console to UTF-8.
2. **Self-update** — at every run, the script downloads the official Office Deployment Tool self-extractor from the Microsoft Download Center:

   ```
   https://download.microsoft.com/download/6c1eeb25-cf8b-41d9-8d0d-cc1dbc032140/officedeploymenttool_19929-20090.exe
   ```

   It uses PowerShell `Invoke-WebRequest` with TLS 1.2, then runs the package with `/quiet /extract:<script folder>` to drop a fresh `setup.exe` next to the script. The file sits beside the `XMLFiles\` folder — this avoids any path-resolution issues when ODT reads the XML.
3. **Sanity check** — the script verifies that the `XMLFiles\` folder is present next to the .ps1 before showing the menu.
4. **Menu** — the script displays the options below and waits for the user to type a number.
5. **Install / uninstall** — the chosen option calls:

   ```powershell
   .\setup.exe /configure .\XMLFiles\<file>.xml
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

- **Windows 10 / 11** (x64). The script uses built-in PowerShell — no extra dependencies.
- **Administrator privileges** — run the script elevated, otherwise the Office Deployment Tool cannot write to Program Files.
- **Active internet connection** — both the ODT itself and the Office payload are downloaded at runtime.

## Usage

1. Download or clone this repository.
2. Double-click [m365apps.bat](m365apps.bat). The launcher clears the Mark-of-the-Web on the .ps1 and starts the PowerShell installer with the Bypass execution policy so it runs unsigned. `setup.exe` raises its own UAC prompt when it needs admin rights, so no manual "Run as administrator" is required.

   If you prefer to run the PowerShell script directly, open PowerShell in the script folder and run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\m365apps.ps1
   ```
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
