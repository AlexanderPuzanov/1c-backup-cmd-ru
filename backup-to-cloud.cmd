echo off
chcp 1251 >nul
goto start
--------------------------------------
Этот пакетный файл предназначен
для автоматизации архивирования баз
файловой версии 1С Бухгалтерия
в облачный сервис Яндекс Диск
--------------------------------------
Скрипт предназначен для работы
с архиватором WinRar 5
--------------------------------------
Для синхранизации с облаком установить
https://disk.yandex.ru/download/YandexDiskSetup.exe
--------------------------------------
Не размещать скрипт в каталоге
для синхронизации с облаком!
Каталог в котором будет размещен скрипт
будет использован для создания
временных файлов в процессе работы.
--------------------------------------
Пакетный файл написан 19/01/2015
Последнее исправление внесено 23/01/2015
Автор Александр Пузанов
--------------------------------------

Этот блок содержит настройки скрипта
"Пути содержащие пробелы взять в кавычки!"
Концевые слеши в путях не ставить!
Не забуте установить свои данные!
:start
rem Путь к базам 1С Бухгалтерия
set source=D:\1C\Base
rem Путь к месту к папке синхронизации с облаком
set backup=E:\backup-1C
rem Сколько дней хранить архивы.
set NumberArchives=10
rem Пароль для архивов
set password=123

rem Рабочий блок
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set archive="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set archive="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchive))
set logfile=%backup%\backup.log
set CurrentDisk="%~dp0"
if exist %backup%\%date%.rar (goto ExistBackup)
if not exist %source% (goto NoSourceDir)
if not exist %backup% (goto NoBackupDir)
%archive% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%password% -k %CurrentDisk% %source% --
if %ErrorLevel%==0 (goto move) else (set result="Ошибка - %ErrorLevel%")
goto log
:move
move %CurrentDisk%\%date%.rar %backup%
if exist %backup%\%date%.rar (set result="Задание выполнено успешно") else (set result="Ошибка копирования файла")
goto log
:ExistBackup
set result="Архив был создан ранее"
goto log
:NoSourceDir
set result="Каталог с базами не доступен"
goto log
:NoBackupDir
set result="Каталог для архивирования не доступен"
goto log
:NoArchive
set result="Программа архиватор не доступна"
goto log
:log
echo %date% >> %logfile%
echo %time% >> %logfile%
echo %result% >> %logfile%
echo ... >> %logfile%
if exist %CurrentDisk%\%date%.rar (del %CurrentDisk%\%date%.rar /Q)
if exist %backup%\%date%.rar (forfiles /P %backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @path")
chcp 866 >nul
exit