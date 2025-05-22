@echo OFF
echo Setting variables
set ip=%4
set user=admin
set tempPass=%1
set tempPass2=%2
set pass=%3
set NTPAddress=192.168.90.1
echo Setting new password
DEL r.txt
curl --user %user%:%tempPass% --digest --globoff "http://%ip%/cgi-bin/userManager.cgi?action=modifyPassword&name=admin&pwd=%pass%&pwdOld=%tempPass%" > r.txt
type r.txt
findstr /C:"Error" r.txt
set res=%errorlevel%
if "%res%"=="0" (
  echo Password invalid, trying other pass...
  DEL r2.txt
  curl --user %user%:%tempPass2% --digest --globoff "http://%ip%/cgi-bin/userManager.cgi?action=modifyPassword&name=admin&pwd=%pass%&pwdOld=%tempPass2%" > r2.txt
  type r2.txt
  findstr /C:"Error" r2.txt
  set res=%errorlevel%
  if "%res%"=="0" (
    echo }(%errorlevel%)
    echo Both passwords incorrect, exiting... %errorlevel%
  ) else (
    echo Success
  )
) else (
  echo Success
)

echo Setting video config
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&Encode[0].MainFormat[0].Video.BitRateControl=VBR&Encode[0].MainFormat[0].Video.FPS=5&Encode[0].ExtraFormat[0].VideoEnable=true&Encode[0].ExtraFormat[0].Video.FPS=5&Encode[0].ExtraFormat[0].Video.BitRateControl=VBR"

echo Setting time
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&Locales.TimeFormat=dd-MM-yyyy%%20HH:mm:ss"

echo Setting DST
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&Locales.DSTEnable=true&Locales.DSTEnd.Day=0&Locales.DSTEnd.Week=-1&Locales.DSTEnd.Month=10&Locales.DSTEnd.Hour=2&Locales.DSTEnd.Hour=0&Locales.DSTStart.Day=0&Locales.DSTStart.Hour=2&Locales.DSTStart.Week=-1&Locales.DSTStart.Month=3&Locales.DSTStart.Day=0"

echo Setting NTP
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&NTP.Enable=true&NTP.Address=%NTPAddress%"

echo Setting MotionDetect
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&MotionDetect[0].Enable=true&MotionDetect[0].Level=5"

for /f %%i in ('powershell -Command "$env:ip -replace '\.', '-'"') do set "name=%%i"

echo Setting router name to %name%
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&General.MachineName=%name%"

