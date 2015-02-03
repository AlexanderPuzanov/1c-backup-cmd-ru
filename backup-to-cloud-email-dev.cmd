rem @echo off
setlocal
rem Запоминаем текущую кодовую страницу
::  на случай если она отличается от 866.
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set Prev_CP=%%i)
rem Установка кодовой страницы.
chcp 1251 > nul
rem Пропуск интро.
goto Start
--------------------------------------
Этот пакетный файл предназначен
для автоматизации архивирования баз
файловой версии 1С Бухгалтерия
в облачный сервис Яндекс Диск
с уведомлениями на email о ошибках.
--------------------------------------
Скрипт предназначен для работы
с архиватором WinRar не ниже 5 версии.
--------------------------------------
Для синхранизации с облаком установить:
https://disk.yandex.ru/download/YandexDiskSetup.exe
--------------------------------------
Не размещать скрипт в каталоге
для синхронизации с облаком!
Каталог в котором будет размещен скрипт
будет использован для создания
временных файлов в процессе работы.
--------------------------------------
Пакетный файл написан 27/01/2015
Последнее исправление внесено 03/02/2015
Автор – Александр Пузанов
email: puzanov.alexandr@gmail.com
--------------------------------------

Этот блок содержит настройки скрипта.
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
rem Путь к программе mailsend.exe
set Email_Sender_Program=D:\mailsend\mailsend1.17b14.exe
rem Данные отправителя.
::  С этой почты будут отправляться
::  уведомления о ошибках.
rem Email отправителя.
::  Email – @yandex.ru
set Email_Sender=backup@yandex.ru
rem Пароль.
set Email_Password=My_Password
rem Данные получателя.
::  На эту почту будут отправляться
::  уведомления о ошибках.
set Email_To=sysadmin@yandex.ru
rem --------------------------------------

rem Рабочий блок

rem Данные отправителя
rem SMTP сервер
set SMTP_Server=smtp.yandex.ru
rem Порт сервера
set SMTP_Port=465
rem Логин получаем логин (часть email до @yandex.ru).
::  Взять из вывода команды ('echo %Email_Sender%')
::  первый элемент (tokens=1). Разделитель (delims=@).
for /f "tokens=1 delims=@" %%i in ('echo %Email_Sender%') do (
	set Email_Login=%%i)
::  Имя отправителя (имя сервера)
set Sender_Name="Сервер — %computername%"

rem Путь к каталогу со скриптом
::  (автоматически).
set Path_Script="%~dp0"
rem Флаг наличие ошибок.
set Error=0
rem Файл логов (в каталоге со скриптом).
set Log_File=%Path_Script%backup.log

rem Проверки путей.
rem Если недоступен каталог с базами.
if not exist %Source% (goto No_SourceDir)
rem Если недоступен каталог для архивов.
if not exist %Backup% (goto No_BackupDir)

rem Автоопределение пути к WinRar.
::  Ошибка если не найден.
if exist "%PROGRAMFILES%\WinRAR\rar.exe" (
	set Archive_Program="%PROGRAMFILES%\WinRAR\rar.exe"
	) else (
		if exist "%PROGRAMFILES(x86)%\WinRAR\rar.exe" (
		set Archive_Program="%PROGRAMFILES(x86)%\WinRAR\rar.exe"
			) else (goto No_Archive_Program)
		)

rem Если сегодня архив уже был создан.
::  %DATE% текущая дата (системная переменная).
if exist %Backup%\%DATE%.rar (goto Exist_Backup)

rem Архивирование
rem Аргументы командной строки для rar.exe
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
%Archive_Program% a -cfg- -ma -htb -m5 -rr10p -ac -ow^
 -agDD.MM.YYYY -ep1 -hp%Password% -k %Path_Script% %Source% --

rem Результат архивирования.
::  %ErrorLevel% результат выполнения архивирования.
::  Возвращается после работы rar.exe
::  Если успешно приступить к перемещению архива
::  Если ошибка записать в ее код в лог файл.
if %ErrorLevel%==0 (
	set Result="Архив создан успешно"
	goto Move_Archive
	) else (
		set Result="Ошибка - %ErrorLevel%"
		goto Error)

rem Перемещение архива в папку для хранения.
::  %DATE% текущая дата (системная переменная).
rem Переместить архив в папку синхронизации с облаком.
:Move_Archive
move %Path_Script%%DATE%.rar %Backup%

rem Проверить результат перемещения и записать в лог файл.
if exist %Backup%\%DATE%.rar (
	set Result="Задание выполнено успешно"
	) else (set Result="Ошибка копирования файла"
		goto Error)

rem Если не было ошибок переходим к записи логов.
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

rem Поднятие флага ошибок. 
:Error
set Error=1

rem Запись логов и очистка старых записей.
::  %DATE% текущая дата (системная переменная).
::  %TIME% текущие время (системная переменная).
::  %Result% результат архивирования.
::  %Log_File% путь к файлу логов.
::  %Number_Strings_Log% максимальное количество строк
::  в файле логов.
::  "Магия" http://www.cyberforum.ru/cmd-bat/thread1299615.html
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

rem Копируем файл с логами в каталог
::  для синхронизации с облаком.
::  /y подтверждать замену автоматически
copy /y %Log_File% %Backup%

rem Удаление старых архивов.
::  Если нет текущего архива, очистку не проводить
::  (защита от удаления последнего архива).
::  forfiles - для каждого файла выполнять.
::  /P %Backup% - в каталоге для синхронизации с облаком.
::  %DATE% текущая дата (системная переменная).
::  /M *.rar - если архив rar.
::  /D -%NumberArchives% - с датой создания более …
::  /C "cmd /c del /q @PATH" - удалять без подтверждения
if exist %Backup%\%DATE%.rar (
	forfiles /P %Backup% /M *.rar /D -%Number_Archives% /C ^
	"cmd /c del /q @PATH")

rem Отправка email с уведомлением о ошибке.
::  Если были ошибки установить тему письма
::  и записать сообщение об ошибке в теме письма.
if %Error%==1 (
	set Email_To_Subject="Ошибка при архивирования"
	Email_To_Text=%Result%
	goto Email_Send)

rem Блок email с ежемесячным отчетом (файл логов).
::  Если сегодня первое число месяца
::  переслать файл логов.
::  %DATE:~0,2% от сегодняшней даты (01.01.2015)
::  взять два элемента начиная с первого.
if %DATE:~0,2%==1 (
	set Email_To_Subject="Емемесячный отчет"
	set Email_To_Text="Файл логов архивирования за %DATE:~3,7%"
	set Email_Send_Attach=-attach %Log_File%,text/plain,a
	goto Email_Send)

rem Если включен тестовый режим.
rem Отправка тестового письма.
if %Test_Mode%==1 (
	set Email_To_Subject="Тестовое письмо"
	set Email_To_Text="%Result%"
	set Email_Send_Attach=-attach %Log_File%,text/plain,a
	goto Email_Send)

rem Если нет причины отправлять email пропустить блок.
goto Skip_Email_Send

:Email_Send
rem Блок отправки емайл.
::  -smtp  - сервер.
::  -port  - порт.
::  -ssl   - шифрование ssl.
::  -auth-login  - авторизация по логину.
::  -user  - логин (email до символа @).
::  -pass  - пароль емайл.
::  -t     - email отправителя.
::  -f     - email получателя.
::  -name  - имя отправителя.
::  -sub   - заголовок письма.
::  -M     - текст письма.
::  -enc-type  - тип кодирования.
::  -cs        - кодировка текста.
::  -mime-type - тип вложения.
::  %Email_Send_Attach%
::  -attach %Log_File%,text/plain,a
::  переслать вложенный файл.
::  Путь, mime тип, а (вложение).
::  ^ - перенос на новую строку.
::  Первый параметр на одной строке 
::  с командой, иначе ошибка.
%Email_Sender_Program% -smtp %SMTP_Server%^
 -port %SMTP_Port%^
 -ssl^
 -auth-login^
 -user %Email_Login%^
 -pass %Email_Password%^
 -t %Email_To%^
 -f %Email_Sender%^
 -name %Sender_Name%^
 -sub %Email_To_Subject%^
 -cs "Windows-1251"^
 -enc-type "7bit"^ 
 -M %Email_To_Text%^
 %Email_Send_Attach%
 
:Skip_Email_Send

rem Если включен тестовый режим.
rem Если есть важные ошибки
::  меняем цвет текста на красный
::  ставим скрипт на паузу.
if %Test_Mode%==1 (
	if %Error%==1 (color 0c
		echo %Result%
		pause)

rem Восстанавливаем настройки
::  (на случай если скрипт запускался
::  другим скриптом)
color 07
chcp %Prev_CP% >nul
endlocal
@echo on
rem exit /b