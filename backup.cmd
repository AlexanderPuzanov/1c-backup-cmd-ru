@echo off
setlocal
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set PrevCP=%%i)

chcp 1251 > nul

goto Start
--------------------------------------
Этот пакетный файл предназначен
для автоматизации архивирования баз
файловой версии 1С Бухгалтерия
--------------------------------------
Скрипт предназначен для работы
с архиватором WinRar 5
--------------------------------------
Разместить скрипт в каталоге
для хранения резервных копий.
ВНИМАНИЕ! Путь к катологу не должен 
содержать пробелы!
--------------------------------------
Пакетный файл создан 24/01/2015
Последнее исправление внесено 26/01/2015
Автор Александр Пузанов
--------------------------------------

Этот блок содержит настройки скрипта
Концевые слеши в путях не ставить!
Не забудьте установить свои данные!

:Start
rem "Путь к каталогу с базами 1С Бухгалтерия"
:: если в пути есть пробелы, обязательно
:: указывать в кавычках (английская раскладка клавиатуры)
set Source="D:\1C\Base"
rem За сколько дней хранить архивы
set NumberArchives=10
rem Пароль для архивов
set Password=123
rem Максимальное количество строк в файле логов
set NumberStringsLog=90

rem Рабочий блок

set Backup=%~dp0
set Error=0
set LogFile=%Backup%backup.log

if not exist %Source% (goto NoSourceDir)
if not exist %Backup% (goto NoBackupDir)
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchiveProgram))
if exist %Backup%%DATE%.rar (goto ExistBackup)

%ArchiveProgram% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%Password% -k %Backup% %Source% --

if %ErrorLevel%==0 (set Result="Архив создан успешно"
goto log) else (set Result="Ошибка - %ErrorLevel%"
goto Error)

:NoArchiveProgram
set Result="Программа архиватор не доступна"
goto Error

:NoSourceDir
set Result="Каталог с базами не доступен"
goto Error

:NoBackupDir
set Result="Каталог для архивирования не доступен"
goto Error

:ExistBackup
set Result="Архив сегодня уже был создан"
goto Log

:Error
set Error=1

:Log
rem "Магия" http://www.cyberforum.ru/cmd-bat/thread1299615.html
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