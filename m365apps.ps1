<#
.SYNOPSIS
    Menu-driven installer for Microsoft 365 Apps using the official
    Office Deployment Tool (ODT) and curated XML configurations.

.DESCRIPTION
    Downloads the latest Office Deployment Tool from Microsoft, extracts
    setup.exe next to this script, then runs it against the XML the user
    picks from the menu. All paths are relative to the script folder.

.NOTES
    Run as administrator. If PowerShell blocks the script, launch with:
        powershell -ExecutionPolicy Bypass -File .\m365apps.ps1
#>

# Force the script to run from the folder where it is saved.
Set-Location -LiteralPath $PSScriptRoot

# UTF-8 console so the menu renders correctly.
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    chcp 65001 | Out-Null
} catch { }

Clear-Host

# The previously used direct setup.exe CDN URL stopped serving a usable
# binary, so we now grab the official Office Deployment Tool self-extractor
# from the Microsoft Download Center and extract setup.exe from it. The
# version below can be bumped to a newer build when Microsoft releases one.
$OdtUrl     = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_18827-20140.exe'
$OdtPackage = '.\odt_installer.exe'
$SetupExe   = '.\setup.exe'
$XmlFolder  = '.\XMLFiles'

function Stop-WithError {
    param([string]$Message)
    Write-Host ''
    Write-Host $Message -ForegroundColor Red
    Write-Host ''
    Read-Host 'Press Enter to exit'
    exit 1
}

# Always refresh setup.exe so the installer is never outdated.
if (Test-Path -LiteralPath $SetupExe) {
    Remove-Item -LiteralPath $SetupExe -Force -ErrorAction SilentlyContinue
}

Write-Host 'Downloading the Office Deployment Tool from Microsoft...'
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $OdtUrl -OutFile $OdtPackage -UseBasicParsing
} catch {
    Stop-WithError "Failed to download the Office Deployment Tool. Check your internet connection.`n$($_.Exception.Message)"
}

if (-not (Test-Path -LiteralPath $OdtPackage)) {
    Stop-WithError 'Failed to download the Office Deployment Tool.'
}

Write-Host 'Extracting setup.exe...'
$extractArgs = "/quiet /extract:`"$PSScriptRoot`""
$proc = Start-Process -FilePath $OdtPackage -ArgumentList $extractArgs -Wait -PassThru
Remove-Item -LiteralPath $OdtPackage -Force -ErrorAction SilentlyContinue

if (-not (Test-Path -LiteralPath $SetupExe)) {
    Stop-WithError "setup.exe was not extracted (ODT exit code $($proc.ExitCode))."
}

Write-Host 'setup.exe is ready.'
Write-Host ''

if (-not (Test-Path -LiteralPath $XmlFolder)) {
    Stop-WithError "The XMLFiles folder was not found next to this script.`nExpected location: $PSScriptRoot\XMLFiles"
}

# Menu definition: key => @{ Label; Xml }
$menu = [ordered]@{
    '1' = @{ Label = 'Install Office Business + Project + Visio';   Xml = 'InstallOfficeProjectVisio-Business.xml'   }
    '2' = @{ Label = 'Install Office Business (US+BR+MX)';          Xml = 'InstallOffice-Business-US.xml'            }
    '3' = @{ Label = 'Install Office Business (Brazil Only)';       Xml = 'InstallOffice-Business-BR.xml'            }
    '4' = @{ Label = 'Install Office Enterprise + Project + Visio'; Xml = 'InstallOfficeProjectVisio-Enterprise.xml' }
    '5' = @{ Label = 'Install Office Enterprise (US+BR+MX)';        Xml = 'InstallOffice-Enterprise-US.xml'          }
    '6' = @{ Label = 'Install Office Enterprise (Brazil Only)';     Xml = 'InstallOffice-Enterprise-BR.xml'          }
    '7' = @{ Label = 'Install Office Home + Project + Visio';       Xml = 'InstallOfficeProjectVisio-Home.xml'       }
    '8' = @{ Label = 'Install Office Home (US+BR+MX)';              Xml = 'InstallOffice-Home-US.xml'                }
    '9' = @{ Label = 'Install Office Home (Brazil Only)';           Xml = 'InstallOffice-Home-BR.xml'                }
    '0' = @{ Label = 'Uninstall All Office Packages';               Xml = 'UninstallOffice.xml'                      }
}

Write-Host '============================================================'
Write-Host '                MICROSOFT OFFICE INSTALLER'
Write-Host '============================================================'
Write-Host ''
foreach ($key in $menu.Keys) {
    Write-Host ("{0} - {1}" -f $key, $menu[$key].Label)
}
Write-Host ''
Write-Host '============================================================'

$choice = $null
while (-not $menu.Contains($choice)) {
    $choice = Read-Host 'Selection'
    if (-not $menu.Contains($choice)) {
        Write-Host 'Invalid option. Press a number from 0 to 9.' -ForegroundColor Yellow
    }
}

$selection = $menu[$choice]
$xmlPath   = Join-Path $XmlFolder $selection.Xml

if (-not (Test-Path -LiteralPath $xmlPath)) {
    Stop-WithError "XML configuration not found: $xmlPath"
}

Write-Host ''
Write-Host "$($selection.Label), please wait..."
& $SetupExe '/configure' $xmlPath
$exitCode = $LASTEXITCODE

Write-Host ''
Write-Host '============================================================'
if ($exitCode -eq 0) {
    Write-Host 'Process finished. Please check if the Office Setup started.'
} else {
    Write-Host "setup.exe exited with code $exitCode." -ForegroundColor Yellow
}
Read-Host 'Press Enter to exit'
