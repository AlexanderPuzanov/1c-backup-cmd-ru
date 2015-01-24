rem @echo off
setlocal
rem запоминаем текущую кодовую страницу
:: на случай если она отличается от 866 
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set PrevCP=%%i)
rem установка кодовой страницы
chcp 1251 > nul
rem пропуск интро
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
Последнее исправление внесено 24/01/2015
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

rem Путь к каталогу для хранения резервных копий
::  (каталог в котором находится скрипт)
::  устанавливается автоматически 
set backup=%~dp0
rem метка наличие ошибок
set error=0
rem Файл логов (в каталоге со скриптом).
set LogFile=%backup%backup.log

rem обработка ошибок 
rem если недоступен каталог с базами
if not exist %source% (goto NoSourceDir)
rem если недоступен каталог для архивов
if not exist %backup% (goto NoBackupDir)
rem если сегодня архив уже был создан
rem %date% текущая дата (системная переменная)
if exist %backup%%date%.rar (goto ExistBackup)

rem Автоопределение пути к WinRar
::  ошибка если не найден
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchiveProgram))

rem архивирование
rem аргументы командной строки для rar.exe
::  a     - архивировать все
:: -cfg-  - игнорировать файл конфигурации архиватора
::          и переменную окружения.
:: -ma    - создавать архивы RAR версии 5.0
:: -htb   - тип хеша BLAKE2
:: -m5    - метод сжатия максимальный
:: -rr10p - 10% для восстановления данных
:: -ac    - снять атрибут "архивный" у файлов
:: -ow    - сохранять информацию о правах доступа
:: -agDD.MM.YYYY - добавить к имени дату в формате
:: -ep1   - не сохранять путь к папке,
::          что бы предотвратить ошибочную перезапись баз
:: -hp    - зашифровать архив включая имена файлов
:: -k     - заблокировать архив (защита от изменений)
:: --     - больше нет аргументов
%ArchiveProgram% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%password% -k %backup% %source% --

rem результат архивирования
rem %ErrorLevel% результат выполнения архивирования
:: возвращается rar.exe
rem если успешно приступить к перемещению архива
:: если ошибка записать в ее код в лог файл
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
rem запись логов и очистка старых записей
rem %date% текущая дата (системная переменная)
rem %time% текущие время (системная переменная)
rem %result% результат архивирования
rem %LogFile% путь к файлу логов
rem %NumberStringsLog% максимальное количество строк
::  в файле логов
rem "Магия" http://www.cyberforum.ru/cmd-bat/thread1299615.html
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

rem удаление старых архивов
rem если текущего архива очистку не проводить
:: защита от удаления последнего архива
rem forfiles - для каждого файла выполнять
:: /P %backup% - в каталоге для синхронизации с облаком
:: /M *.rar - если архив rar
:: /D -%NumberArchives% - с датой создания более …
:: /C "cmd /c del /q @path" - удалять без подтверждения
if exist %backup%%date%.rar (forfiles /P %backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @path")

rem если есть важные ошибки
:: меняем цвет текста на красный
:: ставим скрипт на паузу 
if %error%==1 (color 0c
echo %result%
pause)
color 07
rem восстанавливаем настройки
:: (на случай если скрипт запускался 
:: другим скриптом)
color 07
chcp %PrevCP% >nul
endlocal
rem exit