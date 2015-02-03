rem @echo off
setlocal
rem ���������� ������� ������� ��������
::  �� ������ ���� ��� ���������� �� 866.
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set Prev_CP=%%i)
rem ��������� ������� ��������.
chcp 1251 > nul
rem ������� �����.
goto Start
--------------------------------------
���� �������� ���� ������������
��� ������������� ������������� ���
�������� ������ 1� �����������
� �������� ������ ������ ����
� ������������� �� email � �������.
--------------------------------------
������ ������������ ��� ������
� ����������� WinRar �� ���� 5 ������.
--------------------------------------
��� ������������� � ������� ����������:
https://disk.yandex.ru/download/YandexDiskSetup.exe
--------------------------------------
�� ��������� ������ � ��������
��� ������������� � �������!
������� � ������� ����� �������� ������
����� ����������� ��� ��������
��������� ������ � �������� ������.
--------------------------------------
�������� ���� ������� 27/01/2015
��������� ����������� ������� 03/02/2015
����� � ��������� �������
email: puzanov.alexandr@gmail.com
--------------------------------------

���� ���� �������� ��������� �������.
�������� ����� � ����� �� �������!
�� �������� ���������� ���� ������!

:Start
rem �������� �����.
::  ������������ ��� �������� ��������.
::  ��� ������� ������� �� �����������,
::  ������������ ������ � ��������� �����
::  �� email.
::  1 - �������, 0 - ��������.
set Test_Mode=0
rem "���� � �������� � ������ 1� �����������".
::   ���� � ���� ���� �������, �����������
::   ��������� � ��������
::   (���������� ��������� ����������).
set Source="D:\1C\Base"
rem �� ������� ���� ������� ������.
set Number_Archives=30
rem ������ ��� �������.
set Password=123
rem ������������ ���������� ����� � ����� �����.
set Number_Strings_Log=90
rem ���� � �������� ������������� � �������.
rem ��������!!! � ���� �� ������ ���� ��������!!!
set Backup=E:\YandexDisk\backup-1C
rem ���� � ��������� mailsend.exe
set Email_Sender_Program=D:\mailsend\mailsend1.17b14.exe
rem ������ �����������.
::  � ���� ����� ����� ������������
::  ����������� � �������.
rem Email �����������.
::  Email � @yandex.ru
set Email_Sender=backup@yandex.ru
rem ������.
set Email_Password=My_Password
rem ������ ����������.
::  �� ��� ����� ����� ������������
::  ����������� � �������.
set Email_To=sysadmin@yandex.ru
rem --------------------------------------

rem ������� ����

rem ������ �����������
rem SMTP ������
set SMTP_Server=smtp.yandex.ru
rem ���� �������
set SMTP_Port=465
rem ����� �������� ����� (����� email �� @yandex.ru).
::  ����� �� ������ ������� ('echo %Email_Sender%')
::  ������ ������� (tokens=1). ����������� (delims=@).
for /f "tokens=1 delims=@" %%i in ('echo %Email_Sender%') do (
	set Email_Login=%%i)
::  ��� ����������� (��� �������)
set Sender_Name="������ %computername%"

rem ���� � �������� �� ��������
::  (�������������).
set Path_Script="%~dp0"
rem ���� ������� ������.
set Error=0
rem ���� ����� (� �������� �� ��������).
set Log_File=%Path_Script%backup.log

rem �������� �����.
rem ���� ���������� ������� � ������.
if not exist %Source% (goto No_SourceDir)
rem ���� ���������� ������� ��� �������.
if not exist %Backup% (goto No_BackupDir)

rem ��������������� ���� � WinRar.
::  ������ ���� �� ������.
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (
	set Archive_Program="%PROGRAMFILES%\WinRAR\rar.exe"
	) else (
		if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (
		set Archive_Program="%PROGRAMFILES(x86)%\WinRAR\rar.exe"
			) else (goto No_Archive_Program)
		)

rem ���� ������� ����� ��� ��� ������.
::  %DATE% ������� ���� (��������� ����������).
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
%Archive_Program% a -cfg- -ma -htb -m5 -rr10p -ac -ow^
 -agDD.MM.YYYY -ep1 -hp%Password% -k %Path_Script% %Source% --

rem ��������� �������������.
::  %ErrorLevel% ��������� ���������� �������������.
::  ������������ ����� ������ rar.exe
::  ���� ������� ���������� � ����������� ������
::  ���� ������ �������� � �� ��� � ��� ����.
if %ErrorLevel%==0 (
	set Result="����� ������ �������"
	goto Move_Archive
	) else (
		set Result="������ - %ErrorLevel%"
		goto Error)

rem ����������� ������ � ����� ��� ��������.
::  %DATE% ������� ���� (��������� ����������).
rem ����������� ����� � ����� ������������� � �������.
:Move_Archive
move %Path_Script%%DATE%.rar %Backup%

rem ��������� ��������� ����������� � �������� � ��� ����.
if exist %Backup%\%DATE%.rar (
	set Result="������� ��������� �������"
	) else (set Result="������ ����������� �����"
		goto Error)

rem ���� �� ���� ������ ��������� � ������ �����.
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

rem �������� ����� ������. 
:Error
set Error=1

rem ������ ����� � ������� ������ �������.
::  %DATE% ������� ���� (��������� ����������).
::  %TIME% ������� ����� (��������� ����������).
::  %Result% ��������� �������������.
::  %Log_File% ���� � ����� �����.
::  %Number_Strings_Log% ������������ ���������� �����
::  � ����� �����.
::  "�����" http://www.cyberforum.ru/cmd-bat/thread1299615.html
:Log
set "Logging=echo %DATE% %TIME% %Result% >> "%Log_File%""
if exist "%Log_File%" (
	for /f %%i in ('"<"%Log_File%" find /c /v """') do (
		if %%i lss %Number_Strings_Log% (
			%Logging%
			) else (
				<"%Log_File%" more +1>.tmp> "%Log_File%" type .tmp
				del .tmp
				%Logging%)
		)
	) else (
		%Logging%)

rem �������� ���� � ������ � �������
::  ��� ������������� � �������.
::  /y ������������ ������ �������������
copy /y %Log_File% %Backup%

rem �������� ������ �������.
::  ���� ��� �������� ������, ������� �� ���������
::  (������ �� �������� ���������� ������).
::  forfiles - ��� ������� ����� ���������.
::  /P %Backup% - � �������� ��� ������������� � �������.
::  %DATE% ������� ���� (��������� ����������).
::  /M *.rar - ���� ����� rar.
::  /D -%NumberArchives% - � ����� �������� ����� �
::  /C "cmd /c del /q @PATH" - ������� ��� �������������
if exist %Backup%\%DATE%.rar (
	forfiles /P %Backup% /M *.rar /D -%Number_Archives% /C ^
	"cmd /c del /q @PATH")

rem �������� email � ������������ � ������.
::  ���� ���� ������ ���������� ���� ������
::  � �������� ��������� �� ������ � ���� ������.
if %Error%==1 (
	set Email_To_Subject="������ ��� �������������"
	Email_To_Text=%Result%
	goto Email_Send)

rem ���� email � ����������� ������� (���� �����).
::  ���� ������� ������ ����� ������
::  ��������� ���� �����.
::  %DATE:~0,2% �� ����������� ���� (01.01.2015)
::  ����� ��� �������� ������� � �������.
if %DATE:~0,2%==1 (
	set Email_To_Subject="����������� �����"
	set Email_To_Text="���� ����� ������������� �� %DATE:~3,7%"
	set Email_Send_Attach=-attach %Log_File%,text/plain,a
	goto Email_Send)

rem ���� ������� �������� �����.
rem �������� ��������� ������.
if %Test_Mode%==1 (
	set Email_To_Subject="�������� ������"
	set Email_To_Text="%Result%"
	set Email_Send_Attach=-attach %Log_File%,text/plain,a
	goto Email_Send)

rem ���� ��� ������� ���������� email ���������� ����.
goto Skip_Email_Send

:Email_Send
rem ���� �������� �����.
::  -smtp  - ������.
::  -port  - ����.
::  -ssl   - ���������� ssl.
::  -auth-login  - ����������� �� ������.
::  -user  - ����� (email �� ������� @).
::  -pass  - ������ �����.
::  -t     - email �����������.
::  -f     - email ����������.
::  -name  - ��� �����������.
::  -sub   - ��������� ������.
::  -M     - ����� ������.
::  -enc-type  - ��� �����������.
::  -cs        - ��������� ������.
::  -mime-type - ��� ��������.
::  %Email_Send_Attach%
::  -attach %Log_File%,text/plain,a
::  ��������� ��������� ����.
::  ����, mime ���, � (��������).
::  ^ - ������� �� ����� ������.
::  ������ �������� �� ����� ������ 
::  � ��������, ����� ������.
%Email_Sender_Program% -smtp %SMTP_Server%^
 -port %SMTP_Port%^
 -ssl^
 -auth-login^
 -user %Email_Login%^
 -pass %Email_Password%^
 -t %Email_To%^
 -f %Email_Sender%^
 -name %Sender_Name%^
 -sub %Email_To_Subject%^
 -cs "Windows-1251"^
 -enc-type "7bit"^ 
 -M %Email_To_Text%^
 %Email_Send_Attach%
 
:Skip_Email_Send

rem ���� ������� �������� �����.
rem ���� ���� ������ ������
::  ������ ���� ������ �� �������
::  ������ ������ �� �����.
if %Test_Mode%==1 (
	if %Error%==1 (color 0c
		echo %Result%
		pause)

rem ��������������� ���������
::  (�� ������ ���� ������ ����������
::  ������ ��������)
color 07
chcp %Prev_CP% >nul
endlocal
@echo on
rem exit /b