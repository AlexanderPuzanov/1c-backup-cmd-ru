@echo off
setlocal
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set PrevCP=%%i)

chcp 1251 > nul

goto start
--------------------------------------
���� �������� ���� ������������
��� ������������� ������������� ���
�������� ������ 1� �����������
--------------------------------------
������ ������������ ��� ������
� ����������� WinRar 5
--------------------------------------
���������� ������ � ��������
��� �������� ��������� �����.
��������! ���� � �������� �� ������ 
��������� �������!
--------------------------------------
�������� ���� ������ 24/01/2015
��������� ����������� ������� 25/01/2015
����� ��������� �������
--------------------------------------

���� ���� �������� ��������� �������
�������� ����� � ����� �� �������!
�� ������ ���������� ���� ������!

:start
rem "���� � �������� � ������ 1� �����������"
:: ���� � ���� ���� �������, �����������
:: ��������� � �������� (���������� ��������� ����������)
set source="D:\1C\Base"
rem ������� ���� ������� ������.
set NumberArchives=10
rem ������ ��� �������
set password=123
rem ������������ ���������� ����� � ����� �����
set NumberStringsLog=90

rem ������� ����

set backup=%~dp0
set error=0
set LogFile=%backup%backup.log

if not exist %source% (goto NoSourceDir)
if not exist %backup% (goto NoBackupDir)
if exist %backup%%date%.rar (goto ExistBackup)

if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchiveProgram))

%ArchiveProgram% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%password% -k %backup% %source% --

if %ErrorLevel%==0 (set result="����� ������ �������"
goto log) else (set result="������ - %ErrorLevel%"
goto :error)

:NoArchiveProgram
set result="��������� ��������� �� ��������"
goto :error

:NoSourceDir
set result="������� � ������ �� ��������"
goto :error

:NoBackupDir
set result="������� ��� ������������� �� ��������"
goto :error

:ExistBackup
set result="����� ������� ��� ��� ������"
goto log

:error
set error=1

:log
rem "�����" http://www.cyberforum.ru/cmd-bat/thread1299615.html
set "logging=echo %date% %time% %result% >> "%LogFile%""
if exist "%LogFile%" (
 for /f %%i in ('"<"%LogFile%" find /c /v """') do (
  if %%i lss %NumberStringsLog% (
   %logging%
  ) else (
   <"%LogFile%" more +1>.tmp
   >"%LogFile%" type .tmp
   del .tmp
   %logging%
   )
  )
) else (
 %logging%
 )

if exist %backup%%date%.rar (forfiles /P %backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @path")

if %error%==1 (color 0c
echo %result%
pause)
color 07
chcp %PrevCP% >nul
endlocal
exit