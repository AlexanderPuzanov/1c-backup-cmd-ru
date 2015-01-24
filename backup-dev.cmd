rem @echo off
setlocal
rem ���������� ������� ������� ��������
:: �� ������ ���� ��� ���������� �� 866 
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set PrevCP=%%i)
rem ��������� ������� ��������
chcp 1251 > nul
rem ������� �����
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
��������� ����������� ������� 24/01/2015
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

rem ���� � �������� ��� �������� ��������� �����
::  (������� � ������� ��������� ������)
::  ��������������� ������������� 
set backup=%~dp0
rem ����� ������� ������
set error=0
rem ���� ����� (� �������� �� ��������).
set LogFile=%backup%backup.log

rem ��������� ������ 
rem ���� ���������� ������� � ������
if not exist %source% (goto NoSourceDir)
rem ���� ���������� ������� ��� �������
if not exist %backup% (goto NoBackupDir)
rem ���� ������� ����� ��� ��� ������
rem %date% ������� ���� (��������� ����������)
if exist %backup%%date%.rar (goto ExistBackup)

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
%ArchiveProgram% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%password% -k %backup% %source% --

rem ��������� �������������
rem %ErrorLevel% ��������� ���������� �������������
:: ������������ rar.exe
rem ���� ������� ���������� � ����������� ������
:: ���� ������ �������� � �� ��� � ��� ����
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
rem ������ ����� � ������� ������ �������
rem %date% ������� ���� (��������� ����������)
rem %time% ������� ����� (��������� ����������)
rem %result% ��������� �������������
rem %LogFile% ���� � ����� �����
rem %NumberStringsLog% ������������ ���������� �����
::  � ����� �����
rem "�����" http://www.cyberforum.ru/cmd-bat/thread1299615.html
set "logging = echo %date% %time% %result% >> "%LogFile%""
if exist "%LogFile%" (
 for /f %%i in ('"<"%LogFile%" find /c /v """') do (
  if %%i lss %NumberStringsLog%(
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

rem �������� ������ �������
rem ���� �������� ������ ������� �� ���������
:: ������ �� �������� ���������� ������
rem forfiles - ��� ������� ����� ���������
:: /P %backup% - � �������� ��� ������������� � �������
:: /M *.rar - ���� ����� rar
:: /D -%NumberArchives% - � ����� �������� ����� �
:: /C "cmd /c del /q @path" - ������� ��� �������������
if exist %backup%%date%.rar (forfiles /P %backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @path")

rem ���� ���� ������ ������
:: ������ ���� ������ �� �������
:: ������ ������ �� ����� 
if %error%==1 (color 0c
echo %result%
pause)
color 07
rem ��������������� ���������
:: (�� ������ ���� ������ ���������� 
:: ������ ��������)
color 07
chcp %PrevCP% >nul
endlocal
rem exit