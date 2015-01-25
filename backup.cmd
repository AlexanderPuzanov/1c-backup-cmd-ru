@echo off
setlocal
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set PrevCP=%%i)

chcp 1251 > nul

goto start
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
Последнее исправление внесено 25/01/2015
Автор Александр Пузанов
--------------------------------------

Этот блок содержит настройки скрипта
Концевые слеши в путях не ставить!
Не забуте установить свои данные!

:start
rem "Путь к каталогу с базами 1С Бухгалтерия"
:: если в пути есть пробелы, обязательно
:: указывать в кавычках (английская раскладка клавиатуры)
set source="D:\1C\Base"
rem Сколько дней хранить архивы.
set NumberArchives=10
rem Пароль для архивов
set password=123
rem Максимальное количество строк в файле логов
set NumberStringsLog=90

rem Рабочий блок

set backup=%~dp0
set error=0
set LogFile=%backup%backup.log

if not exist %source% (goto NoSourceDir)
if not exist %backup% (goto NoBackupDir)
if exist %backup%%date%.rar (goto ExistBackup)

if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchiveProgram))

%ArchiveProgram% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%password% -k %backup% %source% --

if %ErrorLevel%==0 (set result="Архив создан успешно"
goto log) else (set result="Ошибка - %ErrorLevel%"
goto :error)

:NoArchiveProgram
set result="Программа архиватор не доступна"
goto :error

:NoSourceDir
set result="Каталог с базами не доступен"
goto :error

:NoBackupDir
set result="Каталог для архивирования не доступен"
goto :error

:ExistBackup
set result="Архив сегодня уже был создан"
goto log

:error
set error=1

:log
rem "Магия" http://www.cyberforum.ru/cmd-bat/thread1299615.html
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