rem @echo off
setlocal
rem ���������� ������� ������� ��������
:: �� ������ ���� ��� ���������� �� 866 
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set PrevCP=%%i)
rem ��������� ������� ��������
chcp 1251 > nul
rem ������� �����
goto Start
--------------------------------------
���� �������� ���� ������������
��� ������������� ������������� ���
�������� ������ 1� �����������
� �������� ������ ������ ����
--------------------------------------
������ ������������ ��� ������
� ����������� WinRar 5
--------------------------------------
��� ������������� � ������� ����������
https://disk.yandex.ru/download/YandexDiskSetup.exe
--------------------------------------
�� ��������� ������ � ��������
��� ������������� � �������!
������� � ������� ����� �������� ������
����� ����������� ��� ��������
��������� ������ � �������� ������.
--------------------------------------
�������� ���� ������� 19/01/2015
��������� ����������� ������� 25/01/2015
����� ��������� �������
--------------------------------------

���� ���� �������� ��������� �������
�������� ����� � ����� �� �������!
�� ������ ���������� ���� ������!

:Start
rem "���� � �������� � ������ 1� �����������"
:: ���� � ���� ���� �������, �����������
:: ��������� � �������� (���������� ��������� ����������)
set Source="D:\1C\Base"
rem ���� � ����� � ����� ������������� � �������
rem ��������!!! � ������ �� ������ ���� ��������!!!
set Backup=E:\YandexDisk\backup-1C
rem ������� ���� ������� ������.
set NumberArchives=1
rem ������ ��� �������
set Password=123
rem ������������ ���������� ����� � ����� �����
set NumberStringsLog=90

rem ������� ����

rem ���� � �������� �� �������� (�������������)
set PathScript="%~dp0"
rem ����� ������� ������
set Error=0
rem ���� ����� (� �������� �� ��������).
set LogFile=%PathScript%backup.log

rem ���� ����������� ���� � WinRar
::  ������ ���� �� ������
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set archive="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set archive="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchive))

rem ��������� ������ 
rem ���� ���������� ������� � ������
if not exist %Source% (goto NoSourceDir)
rem ���� ���������� ������� ��� �������
if not exist %Backup% (goto NoBackupDir)
rem ���� ������� ����� ��� ��� ������
rem %DATE% ������� ���� (��������� ����������)
if exist %Backup%\%DATE%.rar (goto ExistBackup)

rem ��������������� ���� � WinRar
::  ������ ���� �� ������
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchiveProgram))

rem �������������
rem ��������� ��������� ������ ��� rar.exe
::  a     - ������������ ���
:: -cfg-  - ������������ ���� ������������ ����������
::          � ���������� ���������.
:: -ma    - ��������� ������ RAR ������ 5.0
:: -htb   - ��� ���� BLAKE2
:: -m5    - ����� ������ ������������
:: -rr10p - 10% ��� �������������� ������
:: -ac    - ����� ������� "��������" � ������
:: -ow    - ��������� ���������� � ������ �������
:: -agDD.MM.YYYY - �������� � ����� ���� � �������
:: -ep1   - �� ��������� ���� � �����,
::          ��� �� ������������� ��������� ���������� ���
:: -hp    - ����������� ����� ������� ����� ������
:: -k     - ������������� ����� (������ �� ���������)
:: --     - ������ ��� ����������
%ArchiveProgram% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%Password% -k %PathScript% %Source% --

rem ��������� �������������
rem %ErrorLevel% ��������� ���������� �������������
:: ������������ rar.exe
rem ���� ������� ���������� � ����������� ������
:: ���� ������ �������� � �� ��� � ��� ����
if %ErrorLevel%==0 (set Result="����� ������ �������"
goto MoveArchive) else (set Result="������ - %ErrorLevel%"
goto Error)

:MoveArchive
rem ����������� ������ � ����� ��� ��������
rem %DATE% ������� ���� (��������� ����������)
rem ����������� ����� � ����� ������������� � �������
move %PathScript%\%DATE%.rar %Backup%
rem ��������� ��������� ����������� � �������� � ��� ����
if exist %Backup%\%DATE%.rar (set Result="������� ��������� �������") else (set Result="������ ����������� �����"
goto Error)
goto Log

:NoArchiveProgram
set Result="��������� ��������� �� ��������"
goto Error

:NoSourceDir
set Result="������� � ������ �� ��������"
goto Error

:NoBackupDir
set Result="������� ��� ������������� �� ��������"
goto Error

:ExistBackup
set Result="����� ������� ��� ��� ������"
goto Log

:Error
set Error=1

:Log
rem ������ ����� � ������� ������ �������
rem %DATE% ������� ���� (��������� ����������)
rem %TIME% ������� ����� (��������� ����������)
rem %Result% ��������� �������������
rem %LogFile% ���� � ����� �����
rem %NumberStringsLog% ������������ ���������� �����
::  � ����� �����
rem "�����" http://www.cyberforum.ru/cmd-bat/thread1299615.html
set "Logging=echo %DATE% %TIME% %Result% >> "%LogFile%""
if exist "%LogFile%" (
 for /f %%i in ('"<"%LogFile%" find /c /v """') do (
  if %%i lss %NumberStringsLog% (
   %Logging%
  ) else (
   <"%LogFile%" more +1>.tmp
   >"%LogFile%" type .tmp
   del .tmp
   %Logging%
   )
  )
) else (
 %Logging%
 )

rem �������� ���� � ������ � ������� 
::  ��� ������������� � �������
::  /a /y ���������� ��� �������� ����
::  ������������ ������
copy /y %LogFile% %Backup%

rem �������� ������ �������
rem ���� �������� ������ ������� �� ���������
:: ������ �� �������� ���������� ������
rem forfiles - ��� ������� ����� ���������
:: /P %Backup% - � �������� ��� ������������� � �������
:: %DATE% ������� ���� (��������� ����������)
:: /M *.rar - ���� ����� rar
:: /D -%NumberArchives% - � ����� �������� ����� �
:: /C "cmd /c del /q @PATH" - ������� ��� �������������
if exist %Backup%\%DATE%.rar (forfiles /P %Backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @PATH")

rem ���� ���� ������ ������
:: ������ ���� ������ �� �������
:: ������ ������ �� ����� 
if %Error%==1 (color 0c
echo %Result%
pause)

rem ��������������� ���������
:: (�� ������ ���� ������ ���������� 
:: ������ ��������)
color 07
chcp %PrevCP% >nul
endlocal
rem exit

