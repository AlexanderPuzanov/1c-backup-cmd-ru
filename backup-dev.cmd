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
�������� ������ 1� �����������.
--------------------------------------
������ ������������ ��� ������
� ����������� WinRar �� ���� 5 ������.
--------------------------------------
���������� ������ � ��������
��� �������� ��������� �����.
--------------------------------------
�������� ���� ������ 24/01/2015
��������� ����������� ������� 03/02/2015
����� � ��������� �������
email: puzanov.alexandr@gmail.com
--------------------------------------

���� ���� �������� ��������� �������
�������� ����� � ����� �� �������!
�� ���������� ���������� ���� ������!

:Start
rem �������� �����
::  ������������ ��� �������� ��������.
::  ��� ������� ������� �� �����������,
::  ������������ ������ � ��������� �����
::  �� email
::  1 - �������, 0 - ��������
set Test_Mode=0
rem "���� � �������� � ������ 1� �����������".
set "Source=D:\1C\Base"
rem �� ������� ���� ������� ������
set Number_Archives=30
rem ������ ��� �������
set Password=123
rem ������������ ���������� ����� � ����� �����
set Number_Strings_Log=90
rem --------------------------------------

rem ������� ����

rem ���� � �������� �� ��������.
::  %~dp0 � ������ ���� (������� ����������� ����)
::  � �������� ������������ �������.
set "Backup=%~dp0"
rem ���� ������� ������.
set Error=0
rem ���� ����� (� �������� �� ��������).
set "Log_File=%Backup%backup.log"

rem �������� �����.
rem ���� ���������� ������� � ������.
if not exist "%Source%" (goto No_Source_Dir)
rem ���� ���������� ������� ��� �������.
if not exist "%Backup%" (goto No_Backup_Dir)

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
if exist "%Backup%\%DATE%.rar" (goto Exist_Backup)

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
%ArchiveProgram% a -cfg- -ma -htb -m5 -rr10p -ac -ow^
 -agDD.MM.YYYY -ep1 -hp%Password% -k "%Backup%" "%Source%" --

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

rem �������� ������ �������.
::  ���� ��� �������� ������, ������� �� ���������
::  (������ �� �������� ���������� ������).
::  forfiles - ��� ������� ����� ���������.
::  /P %Backup% - � �������� ��� ������������� � �������.
::  %DATE% ������� ���� (��������� ����������).
::  /M *.rar - ���� ����� rar.
::  /D -%NumberArchives% - � ����� �������� ����� �
::  /C "cmd /c del /q @PATH" - ������� ��� �������������
if exist "%Backup%\%DATE%.rar" (
	forfiles /P "%Backup%" /M *.rar /D -%Number_Archives% /C ^
	"cmd /c del /q @PATH")

rem ���� ������� �������� �����.
rem ���� ���� ������ ������
::  ������ ���� ������ �� �������
::  ������ ������ �� �����.
if %Test_Mode%==1 (
	if %Error%==1 (color 0c
		echo %Result%
		pause)
 )

rem ��������������� ���������
::  (�� ������ ���� ������ ����������
::  ������ ��������)
color 07
chcp %Prev_CP% >nul
endlocal
@echo on
rem exit /b