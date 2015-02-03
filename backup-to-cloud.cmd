@echo off
setlocal
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set Prev_CP=%%i)
chcp 1251 > nul
goto Start
--------------------------------------
Этот пакетный файл предназначен
для автоматизации архивирования баз
файловой версии 1С Бухгалтерия
в облачный сервис Яндекс Диск.
--------------------------------------
Скрипт предназначен для работы
с архиватором WinRar не ниже 5 версии.
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
Последнее исправление внесено 03/02/2015
Автор – Александр Пузанов
email: puzanov.alexandr@gmail.com
--------------------------------------

Этот блок содержит настройки скрипта
Концевые слеши в путях не ставить!
Не забудьте установить свои данные!

:Start
rem Тестовый режим.
::  Предназначен для проверки настроек.
::  При ошибках консоль не закрывается,
::  отправляется письмо с вложенным логом
::  на email.
::  1 - включен, 0 - выключен.
set Test_Mode=0
rem "Путь к каталогу с базами 1С Бухгалтерия".
::   Если в пути есть пробелы, обязательно
::   указывать в кавычках
::   (английская раскладка клавиатуры).
set Source="D:\1C\Base"
rem За сколько дней хранить архивы.
set Number_Archives=30
rem Пароль для архивов.
set Password=123
rem Максимальное количество строк в файле логов.
set Number_Strings_Log=90
rem Путь к каталогу синхронизации с облаком.
rem Внимание!!! В пути не должно быть пробелов!!!
set Backup=E:\YandexDisk\backup-1C
rem --------------------------------------

rem Рабочий блок

set Path_Script="%~dp0"
set Error=0
set Log_File=%Path_Script%backup.log

if not exist %Source% (goto No_SourceDir)
if not exist %Backup% (goto No_BackupDir)

if exist "%PROGRAMFILES%\WinRAR\rar.exe" (
	set Archive_Program="%PROGRAMFILES%\WinRAR\rar.exe"
	) else (
		if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (
		set Archive_Program="%PROGRAMFILES(x86)%\WinRAR\rar.exe"
			) else (goto No_Archive_Program)
		)

if exist %Backup%\%DATE%.rar (goto Exist_Backup)

%Archive_Program% a -cfg- -ma -htb -m5 -rr10p -ac -ow^
 -agDD.MM.YYYY -ep1 -hp%Password% -k %Path_Script% %Source% --

if %ErrorLevel%==0 (
	set Result="Архив создан успешно"
	goto Move_Archive
	) else (
		set Result="Ошибка - %ErrorLevel%"
		goto Error)

:Move_Archive
move %Path_Script%%DATE%.rar %Backup%

if exist %Backup%\%DATE%.rar (
	set Result="Задание выполнено успешно"
	) else (set Result="Ошибка копирования файла"
		goto Error)
		
goto Log

:No_Archive_Program
set Result="Программа архиватор не доступна"
goto Error

:No_Source_Dir
set Result="Каталог с базами не доступен"
goto Error

:No_Backup_Dir
set Result="Каталог для архивирования не доступен"
goto Error

:Exist_Backup
set Result="Архив сегодня уже был создан"
goto Log
 
:Error
set Error=1

:Log
set "Logging=echo %DATE% %TIME% %Result% >> "%Log_File%""
if exist "%Log_File%" (
	for /f %%i in ('"<"%Log_File%" find /c /v """') do (
		if %%i lss %Number_Strings_Log% (
			%Logging%
			) else (
				<"%Log_File%" more +1>.tmp> "%Log_File%" type .tmp
				del .tmp
				%Logging%)
		)
	) else (
		%Logging%)

copy /y %Log_File% %Backup%

if exist %Backup%\%DATE%.rar (
	forfiles /P %Backup% /M *.rar /D -%Number_Archives% /C ^
	"cmd /c del /q @PATH")

if Test_Mode==1 (
	if %Error%==1 (color 0c
		echo %Result%
		pause)

color 07
chcp %Prev_CP% >nul
endlocal
@echo on
exit /b