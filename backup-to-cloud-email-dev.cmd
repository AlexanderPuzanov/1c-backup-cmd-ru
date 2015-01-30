rem @echo off
setlocal
rem ���������� ������� ������� ��������
:: �� ������ ���� ��� ���������� �� 866 
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set Prev_CP=%%i)
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
set Number_Archives=1
rem ������ ��� �������
set Password=123
rem ������������ ���������� ����� � ����� �����
set Number_Strings_Log=2
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
set Path_Script="%~dp0"
rem ����� ������� ������
set Error=0
rem ���� ����� (� �������� �� ��������).
set Log_File=%Path_Script%backup.log

rem �������� 
rem ���� ���������� ������� � ������
if not exist %Source% (goto No_SourceDir)
rem ���� ���������� ������� ��� �������
if not exist %Backup% (goto No_BackupDir)
rem ��������������� ���� � WinRar
::  ������ ���� �� ������
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set Archive_Program="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set Archive_Program="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto No_Archive_Program))
rem ���� ������� ����� ��� ��� ������
rem %DATE% ������� ���� (��������� ����������)
if exist %Backup%\%DATE%.rar (goto Exist_Backup)

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
%Archive_Program% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%Password% -k %Path_Script% %Source% --

rem ��������� �������������
rem %ErrorLevel% ��������� ���������� �������������
:: ������������ rar.exe
rem ���� ������� ���������� � ����������� ������
:: ���� ������ �������� � �� ��� � ��� ����
if %ErrorLevel%==0 (set Result="����� ������ �������"
goto Move_Archive) else (set Result="������ - %ErrorLevel%"
goto Error)

:Move_Archive
rem ����������� ������ � ����� ��� ��������
rem %DATE% ������� ���� (��������� ����������)
rem ����������� ����� � ����� ������������� � �������
move %Path_Script%%DATE%.rar %Backup%
rem ��������� ��������� ����������� � �������� � ��� ����
if exist %Backup%\%DATE%.rar (set Result="������� ��������� �������") else (set Result="������ ����������� �����"
goto Error)
goto Log

:No_Archive_Program
set Result="��������� ��������� �� ��������"
goto Error

:No_Source_Dir
set Result="������� � ������ �� ��������"
goto Error

:No_Backup_Dir
set Result="������� ��� ������������� �� ��������"
goto Error

:Exist_Backup
set Result="����� ������� ��� ��� ������"
goto Log

:Error
set Error=1

:Log
rem ������ ����� � ������� ������ �������
rem %DATE% ������� ���� (��������� ����������)
rem %TIME% ������� ����� (��������� ����������)
rem %Result% ��������� �������������
rem %Log_File% ���� � ����� �����
rem %Number_Strings_Log% ������������ ���������� �����
::  � ����� �����
rem "�����" http://www.cyberforum.ru/cmd-bat/thread1299615.html
set "Logging=echo %DATE% %TIME% %Result% >> "%Log_File%""
if exist "%Log_File%" (
 for /f %%i in ('"<"%Log_File%" find /c /v """') do (
  if %%i lss %Number_Strings_Log% (
   %Logging%
  ) else (
   <"%Log_File%" more +1>.tmp
   >"%Log_File%" type .tmp
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
copy /y %Log_File% %Backup%

rem �������� ������ �������
rem ���� �������� ������ ������� �� ���������
:: ������ �� �������� ���������� ������
rem forfiles - ��� ������� ����� ���������
:: /P %Backup% - � �������� ��� ������������� � �������
:: %DATE% ������� ���� (��������� ����������)
:: /M *.rar - ���� ����� rar
:: /D -%NumberArchives% - � ����� �������� ����� �
:: /C "cmd /c del /q @PATH" - ������� ��� �������������
if exist %Backup%\%DATE%.rar (forfiles /P %Backup% /M *.rar /D -%Number_Archives% /C "cmd /c del /q @PATH")

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
 -t %Email_To% ^
 -f %Email_Sender% ^
 -name %Sender_Name% ^
 -sub %Email_To_Subject% ^
 -M %Email_To_Text% ^
 -enc-type "7bit" ^
 -cs "Windows-1251" ^
 -mime-type "text/plain" ^
 +cc +bc -q

rem �������� email � ������������ � ������
if %Error%==1 (Email_To_Subject="������ �������������"
Email_To_Text=%Result%
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
chcp %Prev_CP% >nul
endlocal
rem exit /b