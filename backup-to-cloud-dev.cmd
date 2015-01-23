rem echo off
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
��������� ����������� ������� 19/01/2015
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
rem ���� � ������������ WinRar
set archive="C:\Program Files\WinRAR\RAR.EXE"
rem ���� ����� (� �������� �� ��������).
set logfile=%backup%\backup.log
rem ������� ���� ������� ������.
set NumberArchives=1

rem ���� � �������� �� �������� (�������������)
set CurrentDisk="%~dp0"

rem ��������� ������
rem ���� ������� ����� ��� ��� ������ 
if exist %backup%\%date%.rar (goto ExistBackup)
rem ���� ���������� ������� � ������
if not exist %source% (goto NoSourceDir)
rem ���� ���������� ������� ��� �������
if not exist %backup% (goto NoBackupDir)
rem ���� ���������� ��������� ���������
if not exist %archive% (goto NoArchive)

rem �������������
rem %archive% a -cfg- -ma -htb -dh -m5 -rr10p -ac -os -ow -agDD.MM.YYYY -ep1 -hp123 -k %CurrentDisk% %source% --

rem ��������� �������������
if %ErrorLevel%==0 (goto move) else (set result="������ - %ErrorLevel%")
goto log

:move
rem ����������� ������ � ����� ��� ��������
move %CurrentDisk%\%date%.rar %backup%
if exist %backup%\%date%.rar (set result="������� ��������� �������") else (set result="������ ����������� �����")
goto log

:ExistBackup
set result="����� ��� ������ �����"
goto log

:NoSourceDir
set result="������� � ������ �� ��������"
goto log

:NoBackupDir
set result="������� ��� ������������� �� ��������"
goto log

:NoArchive
set result="��������� ��������� �� ��������"
goto log

:log
rem ������ �����.
echo %date% >> %logfile%
echo %time% >> %logfile%
echo %result% >> %logfile%
echo ... >> %logfile%

rem ������� ���� ������ ���� �� ������� � �������� ��������� ������
if exist %CurrentDisk%\%date%.rar (del %CurrentDisk%\%date%.rar /Q)

rem �������� ������ �������
forfiles /P %backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @path"

chcp 866 >nul
rem exit