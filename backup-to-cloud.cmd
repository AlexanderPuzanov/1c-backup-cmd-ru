echo off
chcp 1251 >nul
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
set NumberArchives=10
rem ������ ��� �������
set password=123

rem ������� ����
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set archive="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set archive="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchive))
set logfile=%backup%\backup.log
set CurrentDisk="%~dp0"
if exist %backup%\%date%.rar (goto ExistBackup)
if not exist %source% (goto NoSourceDir)
if not exist %backup% (goto NoBackupDir)
%archive% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%password% -k %CurrentDisk% %source% --
if %ErrorLevel%==0 (goto move) else (set result="������ - %ErrorLevel%")
goto log
:move
move %CurrentDisk%\%date%.rar %backup%
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
:log
echo %date% >> %logfile%
echo %time% >> %logfile%
echo %result% >> %logfile%
echo ... >> %logfile%
if exist %CurrentDisk%\%date%.rar (del %CurrentDisk%\%date%.rar /Q)
if exist %backup%\%date%.rar (forfiles /P %backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @path")
if %error%==1 (color 0c
echo %result%
pause
) else (chcp 866 >nul
exit)