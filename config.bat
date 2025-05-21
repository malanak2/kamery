@echo OFF
echo Setting variables
set ip=%1
set user=admin
set tempPass=Admin1234
set pass=%2
set NTPAddress=192.168.90.1
echo Setting new password
curl --user %user%:%tempPass% --digest --globoff "http://%ip%/cgi-bin/userManager.cgi?action=modifyPassword&name=admin&pwd=%pass%&pwdOld=%tempPass%"

echo Setting video config
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&Encode[0].MainFormat[0].Video.BitRateControl=VBR&Encode[0].MainFormat[0].Video.FPS=5&Encode[0].ExtraFormat[0].videoEnable=true&Encode[0].ExtraFormat[0].Video.FPS=5&Encode[0].ExtraFormat[0].Video.BitRateControl=VBR"

echo Setting time
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&Locales.TimeFormat=dd-MM-yyyy%%20HH:mm:ss"

echo Setting DST
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&Locales.DSTEnable=true&Locales.DSTEnd.Day=0&Locales.DSTEnd.Week=-1&Locales.DSTEnd.Month=10&Locales.DSTEnd.Hour=0&Locales.DSTStart.Day=0&Locales.DSTStart.Hour=2&Locales.DSTStart.Week=-1&Locales.DSTStart.Month=3&Locales.DSTStart.Day=0"

echo Setting NTP
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&NTP.Enable=true&NTP.Address=%NTPAddress%"

echo Setting MotionDetect
curl --user %user%:%pass% --digest --globoff "http://%ip%/cgi-bin/configManager.cgi?action=setConfig&MotionDetect[0].Enable=1&MotionDetect[0].Sensitivity=5"

