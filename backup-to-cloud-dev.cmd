rem ���������� ������ ���������
rem echo off
rem ��������� ������� ��������
chcp 1251 >nul
rem ������� �����
goto start
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
��������� ����������� ������� 23/01/2015
����� ��������� �������
--------------------------------------

���� ���� �������� ��������� �������
"���� ���������� ������� ����� � �������!"
�������� ����� � ����� �� �������!
�� ������ ���������� ���� ������!
:start
rem ���� � ����� 1� �����������
set source=D:\1C\Base
rem ���� � ����� � ����� ������������� � �������
set backup=E:\backup-1C
rem ������� ���� ������� ������.
set NumberArchives=1
rem ������ ��� �������
set password=123

rem ������� ����

rem ���� ����������� ���� � WinRar
::  ������ ���� �� ������
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set archive="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set archive="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchive))
rem ���� � �������� �� �������� (�������������)
set CurrentDisk="%~dp0"
rem ���� ����� (� �������� �� ��������).
set logfile=%CurrentDisk%\backup.log

rem ��������� ������
rem %date% ������� ���� (��������� ����������) 
rem ���� ������� ����� ��� ��� ������
if exist %backup%\%date%.rar (goto ExistBackup)
rem ���� ���������� ������� � ������
if not exist %source% (goto NoSourceDir)
rem ���� ���������� ������� ��� �������
if not exist %backup% (goto NoBackupDir)

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
%archive% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%password% -k %CurrentDisk% %source% --

rem ��������� �������������
rem %ErrorLevel% ��������� ���������� �������������
:: ������������ rar.exe
rem ���� ������� ���������� � ����������� ������
:: ���� ������ �������� � �� ��� � ��� ����
if %ErrorLevel%==0 (goto move) else (set result="������ - %ErrorLevel%")
goto log

:move
rem ����������� ������ � ����� ��� ��������
rem %date% ������� ���� (��������� ����������)
rem ����������� ����� � ����� ������������� � �������
move %CurrentDisk%\%date%.rar %backup%
rem ��������� ��������� ����������� � �������� � ��� ����
if exist %backup%\%date%.rar (set result="������� ��������� �������") else (set result="������ ����������� �����"
goto :error)
goto log

:NoArchive
set result="��������� ��������� �� ��������"
goto :error

:NoSourceDir
set result="������� � ������ �� ��������"
goto :error

:NoBackupDir
set result="������� ��� ������������� �� ��������"
goto :error

:ExistBackup
set result="����� ��� ������ �����"
goto log

:error
set error=1

:log
rem ������ �����.
rem %date% ������� ���� (��������� ����������)
rem %time% ������� ����� (��������� ����������)
echo %date% >> %logfile%
echo %time% >> %logfile%
echo %result% >> %logfile%
echo ... >> %logfile%
rem �������� ���� ����� � ����� ��� �������������
move %logfile% %backup%\backup.log /Y

rem ������� ���� ������ ���� �� ������� 
::  � �������� ��������� ������
if exist %CurrentDisk%\%date%.rar (del %CurrentDisk%\%date%.rar /Q)

rem �������� ������ �������
rem ���� �������� ������ ������� �� ���������
:: ������ �� �������� ���������� ������
rem forfiles - ��� ������� ����� ���������
:: /P %backup% - � �������� ��� ������������� � �������
:: /M *.rar - ���� ����� rar
:: /D -%NumberArchives% - � ����� �������� ����� �
:: /C "cmd /c del /q @path" - ������� ��� �������������
if exist %backup%\%date%.rar (forfiles /P %backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @path")

rem �� ������ ���� ������ ���������� 
:: ������ �������� ���������� ��������
:: ������� ��������
rem ���� ���� ������ ������
:: ������ ���� ������ �� �������
:: ������ ������ �� ����� 
if %error%==1 (color 0c
echo %result%
pause
) else (chcp 866 >nul
exit)
