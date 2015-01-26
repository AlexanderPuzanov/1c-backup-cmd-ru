@echo off
setlocal
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set PrevCP=%%i)

chcp 1251 > nul

goto Start
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
��������� ����������� ������� 26/01/2015
����� ��������� �������
--------------------------------------

���� ���� �������� ��������� �������
�������� ����� � ����� �� �������!
�� �������� ���������� ���� ������!

:Start
rem "���� � �������� � ������ 1� �����������"
:: ���� � ���� ���� �������, �����������
:: ��������� � �������� (���������� ��������� ����������)
set Source="D:\1C\Base"
rem �� ������� ���� ������� ������
set NumberArchives=10
rem ������ ��� �������
set Password=123
rem ������������ ���������� ����� � ����� �����
set NumberStringsLog=90

rem ������� ����

set Backup=%~dp0
set Error=0
set LogFile=%Backup%backup.log

if not exist %Source% (goto NoSourceDir)
if not exist %Backup% (goto NoBackupDir)
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchiveProgram))
if exist %Backup%%DATE%.rar (goto ExistBackup)

%ArchiveProgram% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%Password% -k %Backup% %Source% --

if %ErrorLevel%==0 (set Result="����� ������ �������"
goto log) else (set Result="������ - %ErrorLevel%"
goto Error)

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

if exist %Backup%%DATE%.rar (forfiles /P %Backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @PATH")

if %Error%==1 (color 0c
echo %Result%
pause)
color 07
chcp %PrevCP% >nul
endlocal
exit /b