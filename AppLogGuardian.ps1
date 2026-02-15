# Testausgabe – nur einmal
Write-Host "Script startet..." -ForegroundColor Green

# Pfad des Skripts ermitteln
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$configPath = Join-Path $scriptPath "config.json"

if (!(Test-Path $configPath)) {
    Write-Host "Config-Datei nicht gefunden! Pfad geprüft:" -ForegroundColor Red
    Write-Host $configPath
    exit
}

$config = Get-Content $configPath | ConvertFrom-Json

Write-Host "Config geladen: " ($config.MonitoredApplications -join ", ")
Write-Host "MaxEvents:" $config.MaxEvents

if ($config.EventLevels) {
    Write-Host "EventLevels aus JSON: $($config.EventLevels -join ', ')" -ForegroundColor Cyan
} else {
    Write-Host "Keine EventLevels definiert" -ForegroundColor Yellow
}

# Pfad für Export-Datei
$exportFile = Join-Path $scriptPath ("AppLogGuardian_{0}.txt" -f (Get-Date -Format "yyyyMMdd_HHmmss"))

# Neues Export-File anlegen
"" | Out-File -FilePath $exportFile -Encoding UTF8
Write-Host "Export-Datei: $exportFile"

# Hilfsfunktion: schreibt gleichzeitig auf Konsole + Datei
function Write-Log {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
    $Text | Out-File $exportFile -Append
}



Write-Log "=== Versionsprüfung ===" Cyan

foreach ($app in $config.MonitoredApplications) {
    Write-Log "App: $app" White

    $found = $false

    # --- Microsoft Defender ---
    if ($app -like "*Defender*") {
        if (Get-Command Get-MpComputerStatus -ErrorAction SilentlyContinue) {
            $defender = Get-MpComputerStatus
            Write-Log "  Version (Defender Engine): $($defender.AMEngineVersion)" Green
            Write-Log "  Signaturen: $($defender.AntivirusSignatureVersion)" Green
            $found = $true
        }
    }

    # --- Microsoft Office Apps ---
    if (-not $found -and $app -match "Word|Excel|PowerPoint|Outlook") {
        $officeKey = "HKLM:\Software\Microsoft\Office\ClickToRun\Configuration"

        if (Test-Path $officeKey) {
            $officeVersion = (Get-ItemProperty $officeKey).VersionToReport
            Write-Log "  Version (Office Click-to-Run): $officeVersion" Green
            $found = $true
        }
    }

    # --- Normale Programme ---
    if (-not $found) {
        $registryPaths = @(
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
            "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
        )

        $apps = foreach ($path in $registryPaths) {
            Get-ItemProperty $path -ErrorAction SilentlyContinue |
                Where-Object { $_.DisplayName -like "*$app*" }
        }

        if ($apps) {
            foreach ($a in $apps) {
                Write-Log ("  Version: {0}" -f $a.DisplayVersion) Green
                $found = $true
            }
        }
    }

    if (-not $found) {
        Write-Log "  Nicht installiert" Yellow
    }
}

Write-Log "" Cyan
Write-Log "=== Eventlog-Auswertung (Application Log) ===" Cyan

foreach ($app in $config.MonitoredApplications) {

    Write-Log "" White
    Write-Log ("Events für: {0}" -f $app) White
    Write-Log "-----------------------------" White

    try {
        $events = Get-WinEvent -LogName Application -ErrorAction Stop |
            Where-Object {
                ($eventLevels -contains $_.LevelDisplayName) -and
                ($_.Message -like "*$app*")
            } |
            Select-Object -First $config.MaxEvents

        if ($events) {
            foreach ($event in $events) {
                $color = switch ($event.LevelDisplayName) {
                    "Critical" { "Magenta" }
                    "Error"    { "Red" }
                    "Warning"  { "Yellow" }
                    default    { "White" }
                }

                Write-Log ("[{0}] {1}" -f $event.TimeCreated, $event.LevelDisplayName) $color
                Write-Log ("  Quelle: $($event.ProviderName)") White
                Write-Log ("  EventID: $($event.Id)") White
                Write-Log ("  Nachricht: $($event.Message.Substring(0, [Math]::Min(200, $event.Message.Length)))") White
            }
        } else {
            Write-Log "  Keine relevanten Events gefunden." Green
        }
    }
    catch {
        Write-Log "  Fehler beim Lesen des Eventlogs." Red
    }
}


