rem @echo off
setlocal
rem запоминаем текущую кодовую страницу
:: на случай если она отличается от 866 
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set PrevCP=%%i)
rem установка кодовой страницы
chcp 1251 > nul
rem пропуск интро
goto Start
--------------------------------------
Этот пакетный файл предназначен
для автоматизации архивирования баз
файловой версии 1С Бухгалтерия
в облачный сервис Яндекс Диск
с уведомлениями на email о ошибках
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
Последнее исправление внесено 26/01/2015
Автор Александр Пузанов
--------------------------------------

Этот блок содержит настройки скрипта
Концевые слеши в путях не ставить!
Не забудьте установить свои данные!

:Start
rem "Путь к каталогу с базами 1С Бухгалтерия"
::   если в пути есть пробелы, обязательно
::   указывать в кавычках (английская раскладка клавиатуры)
set Source="D:\1C\Base"
rem За сколько дней хранить архивы
set NumberArchives=1
rem Пароль для архивов
set Password=123
rem Максимальное количество строк в файле логов
set NumberStringsLog=2
rem Путь к каталогу синхронизации с облаком.
rem Внимание!!! В пути не должно быть пробелов!!!
set Backup=E:\YandexDisk\backup-1C
rem Путь к программе mailsend.exe
set Email_Sender_Program=D:\mailsend\mailsend.exe
rem Данные отправителя
::  с этой почты будут отправляться
::  уведомления о ошибках
rem  email отправителя
set Email_Sender=backup@yandex.ru
rem пароль
set Email_Password=My_Password
rem Данные получателя
::  на эту почту будут отправляться
::  уведомления о ошибках
set Email_To=sysadmin@yandex.ru

rem Рабочий блок

rem Данные отправителя
::  smtp сервер
set SMTP_Server=smtp.yandex.ru
::  порт сервера
set SMTP_Port=465
rem логин получаем логин (часть email до @yandex.ru)
::  Взять из вывода команды ('echo %Email_Sender%')
::  первый элемент (tokens=1). Разделитель (delims=@).
for /f "tokens=1 delims=@" %%i in ('echo %Email_Sender%') do (set Email_Login=%%i)
::  имя отправителя (имя сервера)
set Sender_Name="Сервер — %computername%"

rem Путь к каталогу со скриптом (автоматически)
set PathScript="%~dp0"
rem метка наличие ошибок
set Error=0
rem Файл логов (в каталоге со скриптом).
set LogFile=%PathScript%backup.log

rem проверки 
rem если недоступен каталог с базами
if not exist %Source% (goto NoSourceDir)
rem если недоступен каталог для архивов
if not exist %Backup% (goto NoBackupDir)
rem Автоопределение пути к WinRar
::  ошибка если не найден
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES%\WinRAR\rar.exe") else (if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (set ArchiveProgram="%PROGRAMFILES(x86)%\WinRAR\rar.exe") else (goto NoArchiveProgram))
rem если сегодня архив уже был создан
rem %DATE% текущая дата (системная переменная)
if exist %Backup%\%DATE%.rar (goto ExistBackup)

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
%ArchiveProgram% a -cfg- -ma -htb -m5 -rr10p -ac -ow -agDD.MM.YYYY -ep1 -hp%Password% -k %PathScript% %Source% --

rem результат архивирования
rem %ErrorLevel% результат выполнения архивирования
:: возвращается rar.exe
rem если успешно приступить к перемещению архива
:: если ошибка записать в ее код в лог файл
if %ErrorLevel%==0 (set Result="Архив создан успешно"
goto MoveArchive) else (set Result="Ошибка - %ErrorLevel%"
goto Error)

:MoveArchive
rem перемещение архива в папку для хранения
rem %DATE% текущая дата (системная переменная)
rem переместить архив в папку синхронизации с облаком
move %PathScript%%DATE%.rar %Backup%
rem проверить результат перемещения и записать в лог файл
if exist %Backup%\%DATE%.rar (set Result="Задание выполнено успешно") else (set Result="Ошибка копирования файла"
goto Error)
goto Log

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
rem запись логов и очистка старых записей
rem %DATE% текущая дата (системная переменная)
rem %TIME% текущие время (системная переменная)
rem %Result% результат архивирования
rem %LogFile% путь к файлу логов
rem %NumberStringsLog% максимальное количество строк
::  в файле логов
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

rem копируем файл с логами в каталог
::  для синхронизации с облаком
::  /a /y копировать как тестовый файл
::  подтверждать замену автоматически
copy /y %LogFile% %Backup%

rem удаление старых архивов
rem если текущего архива очистку не проводить
:: защита от удаления последнего архива
rem forfiles - для каждого файла выполнять
:: /P %Backup% - в каталоге для синхронизации с облаком
:: %DATE% текущая дата (системная переменная)
:: /M *.rar - если архив rar
:: /D -%NumberArchives% - с датой создания более …
:: /C "cmd /c del /q @PATH" - удалять без подтверждения
if exist %Backup%\%DATE%.rar (forfiles /P %Backup% /M *.rar /D -%NumberArchives% /C "cmd /c del /q @PATH")

rem блок отправки емайл
rem -smtp  - сервер
rem -port  - порт
rem -ssl   - шифрование ssl
rem -auth-login  - авторизация по логину
rem -user  - логин (email до символа @)
rem -pass  - пароль емайл
rem -t     - email отправителя
rem -f     - email получателя
rem -name  - имя отправителя
rem -sub   - заголовок письма
rem -M     - текст письма
rem -enc-type  - тип кодирования
rem -cs        - кодировка текста
rem -mime-type - тип вложения
rem +cc +bc    - не отправлять копии
rem -q         - "бесшумная" работа
set Email_Send=^
%Email_Sender_Program% ^
 -smtp %SMTP_Server% ^
 -port %SMTP_Port% ^
 -ssl ^
 -auth-login ^
 -user %Email_Login% ^
 -pass %Email_Password% ^ 
 -auth-login -user %Email_Login% ^
 -pass %Email_Password% ^
 -t %Email_To% ^
 -f "%Email_Sender%" ^
 -name "%Sender_Name%" ^
 -sub "%Email_To_Subject%" ^
 -M "%Email_To_Text%" ^
 -enc-type "7bit" ^
 -cs "Windows-1251" ^
 -mime-type "text/plain" ^
 +cc +bc -q

rem Отправка email с уведомлением о ошибке
if %Error%==1 (Email_To_Subject="Ошибка архивирования"
Email_To_Text="%Result%"
%Email_Send%)

rem если есть важные ошибки
:: меняем цвет текста на красный
:: ставим скрипт на паузу 
if %Error%==1 (color 0c
echo %Result%
pause)

rem восстанавливаем настройки
:: (на случай если скрипт запускался
:: другим скриптом)
color 07
chcp %PrevCP% >nul
endlocal
rem exit /b