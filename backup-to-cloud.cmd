@echo off
setlocal
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set Prev_CP=%%i)
chcp 1251 > nul
goto Start
--------------------------------------
���� �������� ���� ������������
��� ������������� ������������� ���
�������� ������ 1� �����������
� �������� ������ ������ ����.
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
�������� ���� ������� 19/01/2015
��������� ����������� ������� 06/02/2015
����� � ��������� �������
email: puzanov.alexandr@gmail.com
--------------------------------------

���� ���� �������� ��������� �������
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
set "Source=D:\1C\Base"
rem �� ������� ���� ������� ������.
set Number_Archives=30
rem ������ ��� �������.
set Password=123
rem ������������ ���������� ����� � ����� �����.
set Number_Strings_Log=90
rem ���� � �������� ������������� � �������.
set "Backup=E:\YandexDisk\backup-1C"
rem --------------------------------------

rem ������� ����

set "Path_Script=%~dp0"
set Error=0
set "Log_File=%Path_Script%backup.log"

if not exist "%Source%" (goto No_Source_Dir)
if not exist "%Backup%" (goto No_Backup_Dir)

if exist "%PROGRAMFILES%\WinRAR\rar.exe" (
	set Archive_Program="%PROGRAMFILES%\WinRAR\rar.exe"
	) else (
		if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (
		set Archive_Program="%PROGRAMFILES(x86)%\WinRAR\rar.exe"
			) else (goto No_Archive_Program)
		)

if exist "%Backup%\%DATE%.rar" (goto Exist_Backup)

%Archive_Program% a -cfg- -ma -htb -m5 -rr10p -ow^
 -agDD.MM.YYYY -ep1 -hp%Password% -k "%Path_Script%" "%Source%" --

if %ErrorLevel%==0 (
	set Result="����� ������ �������"
	goto Move_Archive
	) else (
		set Result="������ - %ErrorLevel%"
		goto Error)

:Move_Archive
move "%Path_Script%%DATE%.rar" "%Backup%"

if exist "%Backup%\%DATE%.rar" (
	set Result="������� ��������� �������"
	) else (set Result="������ ����������� �����"
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
set "Logging=echo %DATE% %TIME% %Result%>>"%Log_File%""
if exist "%Log_File%" (
	for /f %%i in ('"<"%Log_File%" find /c /v """') do (
		if %%i lss %Number_Strings_Log% (
			%Logging%
			) else (
				<"%Log_File%" more +1>.tmp
				>"%Log_File%" type .tmp
				del .tmp
				%Logging%)
		)
			) else (
				%Logging%)

if exist "%Backup%" (copy /y "%Log_File%" "%Backup%")

if exist "%Backup%\%DATE%.rar" (
	forfiles /P "%Backup%" /M *.rar /D -%Number_Archives% /C ^
	"cmd /c del /q @PATH")

if %Test_Mode%==1 (
	if %Error%==1 (color 0c
		echo %Result%
		pause)
 )

color 07
chcp %Prev_CP% >nul
endlocal
@echo on
exit /b