@echo off
setlocal enabledelayedexpansion

reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "BLUE=%ESC%[94m"
set "CYAN=%ESC%[96m"
set "BOLD=%ESC%[1m"
set "RESET=%ESC%[0m"

echo %CYAN%%BOLD%SMS OF DEATH - TELEPHONY RECOVERY TOOL%RESET%
echo %CYAN%%BOLD%======================================%RESET%
echo.

where adb >nul 2>&1
if !errorlevel! neq 0 (
    echo %YELLOW%ADB not found. Downloading Platform-Tools...%RESET%
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('https://dl.google.com/android/repository/platform-tools-latest-windows.zip', '%TEMP%\platform-tools-latest-windows.zip'); Expand-Archive -Path '%TEMP%\platform-tools-latest-windows.zip' -DestinationPath '%LOCALAPPDATA%\Android\Sdk\platform-tools' -Force; if (Test-Path '%LOCALAPPDATA%\Android\Sdk\platform-tools\platform-tools') { Move-Item -Path '%LOCALAPPDATA%\Android\Sdk\platform-tools\platform-tools\*' -Destination '%LOCALAPPDATA%\Android\Sdk\platform-tools\' -Force; Remove-Item '%LOCALAPPDATA%\Android\Sdk\platform-tools\platform-tools' -Recurse -Force }" >nul 2>&1
    if !errorlevel! neq 0 (
        echo %RED%Download failed. Install Platform-Tools manually.%RESET%
        goto EXIT_ERROR
    )
    set "PATH=%LOCALAPPDATA%\Android\Sdk\platform-tools;!PATH!"
    where adb >nul 2>&1
    if !errorlevel! neq 0 (
        echo %RED%Download failed. Install Platform-Tools manually.%RESET%
        goto EXIT_ERROR
    )
    echo %GREEN%ADB ready.%RESET%
) else (
    echo %GREEN%ADB ready.%RESET%
)
echo.

set RETRIED=0
:CHECK_DEVICES
set DEVICE_COUNT=0
set UNAUTH_COUNT=0
set TOTAL_COUNT=0
set "DETECTED_SERIAL="

adb start-server >nul 2>&1
for /F "tokens=1,2" %%A in ('adb devices 2^>nul') do (
    if not "%%A"=="" if not "%%A"=="List" if not "%%A"=="*" if not "%%B"=="" (
        set /a TOTAL_COUNT+=1
        if "%%B"=="device" (
            set /a DEVICE_COUNT+=1
            set "DETECTED_SERIAL=%%A"
        ) else if "%%B"=="unauthorized" (
            set /a UNAUTH_COUNT+=1
        )
    )
)

if !TOTAL_COUNT! equ 0 (
    echo %RED%No device found. Enable USB Debugging and connect via USB.%RESET%
    goto EXIT_ERROR
)
if !TOTAL_COUNT! gtr 1 (
    echo %RED%Multiple devices detected. Disconnect all but one.%RESET%
    goto EXIT_ERROR
)
if !UNAUTH_COUNT! gtr 0 (
    if !RETRIED! equ 0 (
        set RETRIED=1
        echo %YELLOW%Check your phone screen and tap 'Allow' for USB debugging.%RESET%
        powershell -NoProfile -Command "Start-Sleep -Seconds 15" >nul 2>&1
        goto CHECK_DEVICES
    )
)
if !DEVICE_COUNT! equ 1 (
    echo %GREEN%Device detected: !DETECTED_SERIAL!%RESET%
) else (
    echo %RED%No device found. Enable USB Debugging and connect via USB.%RESET%
    goto EXIT_ERROR
)
echo.

echo %YELLOW%%BOLD%WARNING: This clears telephony provider data for Android user 0.%RESET%
echo %YELLOW%%BOLD%Expect stored SMS and MMS to be lost. Other effects vary by device.%RESET%
echo %YELLOW%%BOLD%Verify a completed backup of your messages before continuing.%RESET%
echo %YELLOW%%BOLD%This last-resort reset does not install the Android security update.%RESET%
echo %RED%%BOLD%Type YES to continue, anything else to abort:%RESET%
set "CONFIRM="
set /p CONFIRM=
if not "!CONFIRM!"=="YES" (
    echo %RED%Aborted.%RESET%
    goto EXIT_ERROR
)
echo.

echo %CYAN%Clearing telephony provider data...%RESET%
adb -s "!DETECTED_SERIAL!" shell pm clear --user 0 com.android.providers.telephony
if !errorlevel! equ 0 (
    echo %GREEN%ADB returned exit code 0. Review its output above.%RESET%
) else (
    echo %RED%Command failed. Output above. Check that the phone is unlocked and USB debugging is authorized.%RESET%
    goto EXIT_ERROR
)
echo.

echo %GREEN%%BOLD%DONE. Disconnect the phone and reboot it manually.%RESET%
echo %GREEN%%BOLD%After restart, check signal, a normal call, and messaging.%RESET%
echo %YELLOW%Google lists this CVE at Android security patch level 2026-11-01.%RESET%
echo %YELLOW%Check the update for your exact model with its manufacturer.%RESET%
echo %YELLOW%If service still fails, contact support before attempting another reset.%RESET%

:EXIT_SUCCESS
echo.
pause
exit /b 0

:EXIT_ERROR
echo.
pause
exit /b 1
