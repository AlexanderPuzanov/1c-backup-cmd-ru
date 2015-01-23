rem echo off
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
Последнее исправление внесено 19/01/2015
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
rem Путь к расположению WinRar
set archive="C:\Program Files\WinRAR\RAR.EXE"
rem Файл логов (в каталоге со скриптом).
set logfile=%backup%\backup.log
rem Сколько дней хранить архивы.
set NumberArchives=1

rem Путь к каталогу со скриптом (автоматически)
set CurrentDisk="%~dp0"

rem Обработка ошибок
rem Если сегодня архив уже был создан 
if exist %backup%\%date%.rar (goto ExistBackup)
rem Если недоступен каталог с базами
if not exist %source% (goto NoSourceDir)
rem Если недоступен каталог для архивов
if not exist %backup% (goto NoBackupDir)
rem Если недоступна программа архиватор
if not exist %archive% (goto NoArchive)

rem Архивирование
rem %archive% a -cfg- -ma -htb -dh -m5 -rr10p -ac -os -ow -agDD.MM.YYYY -ep1 -hp123 -k %CurrentDisk% %source% --

rem Результат архивирования
if %ErrorLevel%==0 (goto move) else (set result="Ошибка - %ErrorLevel%")
goto log

:move
rem Перемещение архива в папку для хранения
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
rem Запись логов.
echo %date% >> %logfile%
echo %time% >> %logfile%
echo %result% >> %logfile%
echo ... >> %logfile%

rem Удаляем файл архива если он остался в каталоге временных файлов
if exist %CurrentDisk%\%date%.rar (del %CurrentDisk%\%date%.rar /Q)

rem Удаление старых архивов
forfiles /P %backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @path"

chcp 866 >nul
rem exit