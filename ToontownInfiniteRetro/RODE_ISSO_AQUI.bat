@echo off

set /P ttiUsername="Username (DEFAULT: username): " || ^
set ttiUsername=username
set ttiPassword=password
set TTI_PLAYCOOKIE=%ttiUsername%
set TTI_GAMESERVER=179.179.176.120

rem Read the contents of PPYTHON_PATH into %PPYTHON_PATH%:
set /P PPYTHON_PATH=<PPYTHON_PATH

echo ===============================
echo Starting Toontown Infinite Retro...
echo ppython: %PPYTHON_PATH%
echo Username: %ttiUsername%
echo Client Agent IP: %TTI_GAMESERVER%
echo ===============================

%PPYTHON_PATH% -m toontown.toonbase.ToontownStart
pause