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
� ������������� �� email � �������
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
��������� ����������� ������� 26/01/2015
����� ��������� �������
--------------------------------------

���� ���� �������� ��������� �������
�������� ����� � ����� �� �������!
�� �������� ���������� ���� ������!

:Start
rem "���� � �������� � ������ 1� �����������"
::   ���� � ���� ���� �������, �����������
::   ��������� � �������� (���������� ��������� ����������)
set Source="D:\1C\Base"
rem �� ������� ���� ������� ������
set NumberArchives=1
rem ������ ��� �������
set Password=123
rem ������������ ���������� ����� � ����� �����
set NumberStringsLog=2
rem ���� � �������� ������������� � �������.
rem ��������!!! � ���� �� ������ ���� ��������!!!
set Backup=E:\YandexDisk\backup-1C
rem ���� � ��������� mailsend.exe
set Email_Sender_Program=D:\mailsend\mailsend.exe
rem ������ �����������
::  � ���� ����� ����� ������������
::  ����������� � �������
rem  email �����������
set Email_Sender=backup@yandex.ru
rem ������
set Email_Password=My_Password
rem ������ ����������
::  �� ��� ����� ����� ������������
::  ����������� � �������
set Email_To=sysadmin@yandex.ru

rem ������� ����

rem ������ �����������
::  smtp ������
set SMTP_Server=smtp.yandex.ru
::  ���� �������
set SMTP_Port=465
rem ����� �������� ����� (����� email �� @yandex.ru)
::  ����� �� ������ ������� ('echo %Email_Sender%')
::  ������ ������� (tokens=1). ����������� (delims=@).
for /f "tokens=1 delims=@" %%i in ('echo %Email_Sender%') do (set Email_Login=%%i)
::  ��� ����������� (��� �������)
set Sender_Name="������ %computername%"

rem ���� � �������� �� �������� (�������������)
set PathScript="%~dp0"
rem ����� ������� ������
set Error=0
rem ���� ����� (� �������� �� ��������).
set LogFile=%PathScript%backup.log

rem �������� 
rem ���� ���������� ������� � ������
if not exist %Source% (goto NoSourceDir)
rem ���� ���������� ������� ��� �������
if not exist %Backup% (goto NoBackupDir)
rem ��������������� ���� � WinRar
::  ������ ���� �� ������
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchiveProgram))
rem ���� ������� ����� ��� ��� ������
rem %DATE% ������� ���� (��������� ����������)
if exist %Backup%\%DATE%.rar (goto ExistBackup)

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
move %PathScript%%DATE%.rar %Backup%
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
::  ������������ ������ �������������
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

rem ���� �������� �����
rem -smtp  - ������
rem -port  - ����
rem -ssl   - ���������� ssl
rem -auth-login  - ����������� �� ������
rem -user  - ����� (email �� ������� @)
rem -pass  - ������ �����
rem -t     - email �����������
rem -f     - email ����������
rem -name  - ��� �����������
rem -sub   - ��������� ������
rem -M     - ����� ������
rem -enc-type  - ��� �����������
rem -cs        - ��������� ������
rem -mime-type - ��� ��������
rem +cc +bc    - �� ���������� �����
rem -q         - "���������" ������
set Email_Send=^
%Email_Sender_Program% ^
 -smtp %SMTP_Server% ^
 -port %SMTP_Port% ^
 -ssl ^
 -auth-login ^
 -user %Email_Login% ^
 -pass %Email_Password% ^ 
 -auth-login -user %Email_Login% ^
 -pass %Email_Password% ^
 -t %Email_To% ^
 -f "%Email_Sender%" ^
 -name "%Sender_Name%" ^
 -sub "%Email_To_Subject%" ^
 -M "%Email_To_Text%" ^
 -enc-type "7bit" ^
 -cs "Windows-1251" ^
 -mime-type "text/plain" ^
 +cc +bc -q

rem �������� email � ������������ � ������
if %Error%==1 (Email_To_Subject="������ �������������"
Email_To_Text="%Result%"
%Email_Send%)

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
rem exit /b