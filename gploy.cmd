:: <# g p l o y v 1.0 © github.com/joshuacline
:: Granular Windows deployment re-envisioned.
@ECHO OFF&&SETLOCAL ENABLEDELAYEDEXPANSION&&SET "ARGS=%*"
FOR %%1 in (0 1 2 3 4 5 6 7 8 9) DO (CALL SET "ARG%%1=%%%%1%%")
GOTO:GET_INIT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:MAIN_MENU
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "MOUNT="&&IF NOT DEFINED MENU_MODE SET "MENU_MODE=NORMAL"
IF "%PROG_MODE%"=="RAMDISK" FOR %%a in (BASIC CUSTOM) DO (IF "%MENU_MODE%"=="%%a" GOTO:%MENU_MODE%_MODE)
IF NOT "%GUI_LAUNCH%"=="DISABLED" IF NOT "%WINPE_BOOT%"=="1" GOTO:GUI_MODE
IF EXIST "%ProgFolder%\$PKX" ECHO.Cleaning up pkx folder from previous session...&&SET "FOLDER_DEL=%ProgFolder%\$PKX"&&CALL:FOLDER_DEL
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:GET_SPACE_ENV&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                                gploy&&ECHO.&&ECHO.&&IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% 0 %$$%) %U09% Change Boot Order
ECHO. (%##% 1 %$$%) %U07% Image Processing&&ECHO. (%##% 2 %$$%) %U08% Image Management&&ECHO. (%##% 3 %$$%) %U11% Other Management&&ECHO. (%##% 4 %$$%) %U04% BootDisk Creator&&ECHO. (%##% 5 %$$%) %U03% Settings
ECHO.&&ECHO.&&IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="Z:\%HOST_FOLDERX%" ECHO.          ^< Disk %@@%%HOST_NUMBER%%$$% UID %@@%%HOST_TARGET%%$$% ^>
IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="X:\$" ECHO.        ^< Disk %COLOR2%ERROR%$$% UID %COLOR2%%HOST_TARGET%%$$% ^>
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&TITLE gploy v%VER_CUR%  (%ProgFolder%)
IF "%PROG_MODE%"=="RAMDISK" ECHO.  (%##%Q%$$%)uit  (%##%*%$$%) Basic Menu                                    %@@%%FREE%GB%$$% Free
IF "%PROG_MODE%"=="PORTABLE" IF "%WINPE_BOOT%"=="1" ECHO.  (%##%Q%$$%)uit                                                   %@@%%FREE%GB%$$% Free
IF "%PROG_MODE%"=="PORTABLE" IF NOT "%WINPE_BOOT%"=="1" ECHO.  (%##%Q%$$%)uit  (%##%*%$$%) %U06% Switch to GUI                            %@@%%FREE%GB%$$% Free
CALL:PAD_LINE&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF "%SELECT%"=="Q" GOTO:QUIT
IF DEFINED SELECT CALL:SHORTCUT_RUN
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF "%SELECT%"=="1" GOTO:IMAGE_PROCESSING
IF NOT DEFINED IMAGE_LAST SET "IMAGE_LAST=IMAGE"
IF "%SELECT%"=="2" GOTO:%IMAGE_LAST%_MANAGEMENT
IF NOT DEFINED MISC_LAST SET "MISC_LAST=FILE"
IF "%SELECT%"=="3" GOTO:%MISC_LAST%_MANAGEMENT
IF "%SELECT%"=="4" GOTO:BOOT_CREATOR
IF "%SELECT%"=="5" GOTO:SETTINGS_MENU
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="RAMDISK" SET "MENU_MODE=BASIC"&&GOTO:BASIC_MODE
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="PORTABLE" IF NOT "%WINPE_BOOT%"=="1" SET "GUI_LAUNCH=ENABLED"&&(ECHO.&&ECHO.GUI_LAUNCH=ENABLED)>>"gploy.ini"
IF "%SELECT%"=="~" SET&&CALL:PAUSED
IF "%SELECT%"=="0" IF "%PROG_MODE%"=="RAMDISK" CALL:BCD_MENU
GOTO:MAIN_MENU
:GUI_MODE
START powershell -noprofile -WindowStyle Hidden -executionpolicy bypass -command "$Content = Get-Content -Path '%~f0' -raw -Encoding utf8;$ContentUTF = [ScriptBlock]::Create($Content);& $ContentUTF"
GOTO:QUIT
:BASIC_MODE
@ECHO OFF&&SET "MOUNT="&&CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:GET_SPACE_ENV&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                                              gploy&&ECHO.&&ECHO.&&ECHO. (%##% 0 %$$%) %U09% Change Boot Order&&ECHO. (%##% 1 %$$%) %U07% Backup&&ECHO. (%##% 2 %$$%) %U07% Restore
ECHO.&&ECHO.&&IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="Z:\%HOST_FOLDERX%" ECHO.          ^< Disk %@@%%HOST_NUMBER%%$$% UID %@@%%HOST_TARGET%%$$% ^>
IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="X:\$" ECHO.        ^< Disk %COLOR2%ERROR%$$% UID %COLOR2%%HOST_TARGET%%$$% ^>
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&TITLE gploy v%VER_CUR%  (%ProgFolder%)
ECHO.  (%##%Q%$$%)uit  (%##%*%$$%) Main Menu                                    %@@%%FREE%GB%$$% Free
CALL:PAD_LINE&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF "%SELECT%"=="Q" GOTO:QUIT
IF DEFINED SELECT CALL:SHORTCUT_RUN
IF DEFINED HOST_ERROR GOTO:BASIC_MODE
IF "%SELECT%"=="0" CALL:BCD_MENU&SET "SELECT="
IF "%SELECT%"=="1" CALL:BASIC_BACKUP&SET "SELECT="
IF "%SELECT%"=="2" CALL:BASIC_RESTORE&SET "SELECT="
IF "%SELECT%"=="*" SET "MENU_MODE=NORMAL"&&GOTO:MAIN_MENU
GOTO:BASIC_MODE
:CUSTOM_MODE
@ECHO OFF&&SET "MOUNT="&&CLS&&SET "MENU_MODE=NORMAL"&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:GET_SPACE_ENV&TITLE
IF NOT DEFINED MENU_LIST GOTO:MAIN_MENU
IF NOT EXIST "%ListFolder%\%MENU_LIST%" SET "MENU_LIST="&&GOTO:MAIN_MENU
SET "$HEAD_CHECK=%ListFolder%\%MENU_LIST%"&&CALL:GET_HEADER
IF NOT "%$HEAD%"=="MENU-SCRIPT" ECHO.&&ECHO.%COLOR4%ERROR:%$$% %MENU_LIST% is not a base or execution list. Leaving custom menu.&&ECHO.&&CALL:PAUSED&GOTO:MAIN_MENU
SET "TIMER_MSG= %$$%Executing %@@%%MENU_LIST%%$$% in [ %COLOR4%%%TIMER%%%$$% ] seconds. %##%Close window to abort.%$$%"&&SET "TIMER=10"&&CALL:TIMER&&SET "MENU_MODE=CUSTOM"&&CALL:SETS_HANDLER
CLS&&CALL %CMD% /C ""%ProgFolder%\gploy.cmd" -IMAGEMGR -RUN -LIST "%MENU_LIST%" -MENU"
SET "TIMER=10"&&CALL:TIMER&&SET "TIMER_MSG= %$$%Reboot in [ %COLOR4%%%TIMER%%%$$% ] seconds."&&SET "TIMER=15"&&CALL:TIMER
GOTO:QUIT
:COMMAND_MODE
IF DEFINED GUI_ACTIVE SET "PROG_MODE=GUI"&&CALL:SETS_HANDLER&CLS
IF NOT "%PROG_MODE%"=="GUI" SET "PAD_TYPE=0"&&CALL:SETS_MAIN
SET "MOUNT="&&IF NOT "%ARG1%"=="/?" IF NOT "%ARG1%"=="-HELP" IF NOT "%ARG1%"=="-INTERNAL" IF NOT "%ARG1%"=="-AUTOBOOT" IF NOT "%ARG1%"=="-NEXTBOOT" IF NOT "%ARG1%"=="-BOOTMAKER" IF NOT "%ARG1%"=="-BOOTCREATOR" IF NOT "%ARG1%"=="-DISKMGR" IF NOT "%ARG1%"=="-FILEMGR" IF NOT "%ARG1%"=="-IMAGEPROC" IF NOT "%ARG1%"=="-IMAGEMGR" ECHO.Type gploy.cmd -help for more options.&&GOTO:QUIT
IF "%ARG1%"=="/?" SET "ARG1=-HELP"
IF "%ARG1%"=="-HELP" CALL:COMMAND_HELP
IF "%ARG1%"=="-BOOTMAKER" SET "ARG1=-BOOTCREATOR"
IF "%ARG1%"=="-INTERNAL" IF "%ARG2%"=="-SETTINGS" SET "MENU_EXIT=1"&&GOTO:SETTINGS_MENU
IF "%ARG1%"=="-FILEMGR" IF NOT "%ARG2%"=="-GRANT" ECHO.Valid options are -grant
IF "%ARG1%"=="-FILEMGR" IF "%ARG2%"=="-GRANT" IF NOT EXIST "%ARG3%" ECHO.%COLOR4%ERROR:%$$% %ARG3% doesn't exist
IF "%ARG1%"=="-FILEMGR" IF "%ARG2%"=="-GRANT" IF DEFINED ARG3 IF EXIST "%ARG3%" SET "$PICK=%ARG3%"&&CALL:FMGR_OWN
IF "%ARG1%"=="-NEXTBOOT" IF NOT "%ARG2%"=="-RECOVERY" IF NOT "%ARG2%"=="-VHDX" ECHO.Valid options are -recovery and -vhdx
IF "%ARG1%"=="-NEXTBOOT" FOR %%a in (VHDX RECOVERY) DO (IF "%ARG2%"=="-%%a" SET "BOOT_TARGET=%%a"&&CALL:BOOT_TOGGLE)
IF "%ARG1%"=="-NEXTBOOT" IF DEFINED BOOT_OK ECHO.Next boot is %NEXT_BOOT%
IF "%ARG1%"=="-NEXTBOOT" IF NOT DEFINED BOOT_OK ECHO.%COLOR4%ERROR:%$$% The boot environment is not installed on this system.
IF "%ARG1%"=="-AUTOBOOT" IF NOT "%ARG2%"=="-INSTALL" IF NOT "%ARG2%"=="-REMOVE" ECHO.Valid options are -install and -remove
IF "%ARG1%"=="-AUTOBOOT" IF "%ARG2%"=="-REMOVE" SET "BOOTSVC=REMOVE"&&CALL:AUTOBOOT_SVC
IF "%ARG1%"=="-AUTOBOOT" IF "%ARG2%"=="-INSTALL" SET "BOOTSVC=INSTALL"&&CALL:AUTOBOOT_SVC
IF "%ARG1%"=="-BOOTCREATOR" CALL:COMMAND_BOOTCREATOR
IF "%ARG1%"=="-DISKMGR" CALL:COMMAND_DISKMGR
IF "%ARG1%"=="-IMAGEMGR" CALL:COMMAND_IMAGEMGR
IF "%ARG1%"=="-IMAGEPROC" SET "SOURCE_TYPE="&&SET "TARGET_TYPE="&&SET "$PASS="&&FOR %%▓ in (WIM PATH VHDX) DO (IF "%ARG2%"=="-%%▓" SET "$PASS=1"&&SET "SOURCE_TYPE=%%▓"&&CALL:COMMAND_IMAGEPROC_%%▓)
IF "%ARG1%"=="-IMAGEPROC" IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% ARG2 not -wim, -path, or -vhdx&&EXIT /B
GOTO:QUIT
:COMMAND_IMAGEPROC_PATH
IF NOT DEFINED ARG3 ECHO.%COLOR4%ERROR:%$$% ARG3 'path' is not specified&&EXIT /B
IF NOT EXIST "%ARG3%\*" ECHO.%COLOR4%ERROR:%$$% 'path' "%ARG3%" doesn't exist&&EXIT /B
IF NOT "%ARG4%"=="-WIM" ECHO.%COLOR4%ERROR:%$$% ARG4 is not -wim&&EXIT /B
IF NOT DEFINED ARG5 ECHO.%COLOR4%ERROR:%$$% ARG5 'wim' is not specified&&EXIT /B
IF NOT "%ARG6%"=="-XLVL" ECHO.%COLOR4%ERROR:%$$% ARG6 is not -xlvl&&EXIT /B
IF NOT "%ARG7%"=="FAST" IF NOT "%ARG7%"=="MAX" ECHO.%COLOR4%ERROR:%$$% ARG7 'compression' is not fast or max&&EXIT /B
SET "TARGET_TYPE=WIM"&&SET "PATH_SOURCE=%ARG3%"&&SET "WIM_TARGET=%ARG5%"&&SET "COMPRESS=%ARG7%"&&CALL:IMAGEPROC_START
EXIT /B
:COMMAND_IMAGEPROC_VHDX
IF NOT DEFINED ARG3 ECHO.%COLOR4%ERROR:%$$% ARG3 'vhdx' is not specified&&EXIT /B
IF NOT EXIST "%ImageFolder%\%ARG3%" ECHO.%COLOR4%ERROR:%$$% 'vhdx' "%ImageFolder%\%ARG3%" doesn't exist&&EXIT /B
IF NOT "%ARG4%"=="-INDEX" ECHO.%COLOR4%ERROR:%$$% ARG4 is not -index&&EXIT /B
IF NOT DEFINED ARG5 ECHO.%COLOR4%ERROR:%$$% ARG5 'index' number is not specified&&EXIT /B
SET "$PASS="&&FOR %%▓ in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25) DO (IF "%ARG5%"=="%%▓" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% ARG5 'index' is not between 1-25&&EXIT /B
IF NOT "%ARG6%"=="-WIM" ECHO.%COLOR4%ERROR:%$$% ARG6 is not -wim&&EXIT /B
IF NOT DEFINED ARG7 ECHO.%COLOR4%ERROR:%$$% ARG7 'wim' is not specified&&EXIT /B
IF NOT "%ARG8%"=="-XLVL" ECHO.%COLOR4%ERROR:%$$% ARG8 is not -xlvl&&EXIT /B
IF /I NOT "%ARG9%"=="FAST" IF /I NOT "%ARG9%"=="MAX" ECHO.%COLOR4%ERROR:%$$% ARG9 'compression' is not fast or max&&EXIT /B
SET "TARGET_TYPE=WIM"&&SET "VHDX_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "WIM_TARGET=%ARG7%"&&SET "COMPRESS=%ARG9%"&&CALL:IMAGEPROC_START
EXIT /B
:COMMAND_IMAGEPROC_WIM
IF NOT DEFINED ARG3 ECHO.%COLOR4%ERROR:%$$% 'wim' [%ARG3%] is not defined&&EXIT /B
IF NOT EXIST "%ImageFolder%\%ARG3%" ECHO.%COLOR4%ERROR:%$$% 'wim' "%ImageFolder%\%ARG3%" doesn't exist&&EXIT /B
IF NOT "%ARG4%"=="-INDEX" ECHO.%COLOR4%ERROR:%$$% ARG4 is not -index&&EXIT /B
IF NOT DEFINED ARG5 ECHO.%COLOR4%ERROR:%$$% ARG5 'index' number is not specified&&EXIT /B
SET "$PASS="&&FOR %%▓ in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25) DO (IF "%ARG5%"=="%%▓" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% ARG5 'index' is not between 1-25&&EXIT /B
SET "$PASS="&&FOR %%▓ in (PATH VHDX) DO (IF "%ARG6%"=="-%%▓" SET "$PASS=1"&&SET "TARGET_TYPE=%%▓")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% ARG6 'target' is not -path or -vhdx&&EXIT /B
IF "%TARGET_TYPE%"=="PATH" IF NOT DEFINED ARG7 ECHO.%COLOR4%ERROR:%$$% ARG7 'path' is not specified&&EXIT /B
IF "%TARGET_TYPE%"=="PATH" IF NOT EXIST "%ARG7%\*" ECHO.%COLOR4%ERROR:%$$% 'path' "%ARG7%" doesn't exist&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" IF NOT DEFINED ARG7 ECHO.%COLOR4%ERROR:%$$% ARG7 'vhdx' is not specified&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" IF NOT "%ARG8%"=="-SIZE" ECHO.%COLOR4%ERROR:%$$% ARG8 is not -size&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" IF NOT DEFINED ARG9 ECHO.%COLOR4%ERROR:%$$% ARG9 'size' is not specified&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" SET "WIM_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "VHDX_TARGET=%ARG7%"&&SET "VHDX_SIZE=%ARG9%"&&CALL:IMAGEPROC_START
IF "%TARGET_TYPE%"=="PATH" SET "INPUT=%ARG7%"&&SET "OUTPUT=ARG7"&&CALL:SLASHER
IF "%TARGET_TYPE%"=="PATH" SET "WIM_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "PATH_TARGET=%ARG7%"&&CALL:IMAGEPROC_START
EXIT /B
:COMMAND_IMAGEMGR
SET "$PASS="&&SET "$LISTPACK="&&FOR %%▓ in (NEWPACK EXAMPLE EXPORT CREATE RUN) DO (IF "%ARG2%"=="-%%▓" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.ERROR: ARG2 not -newpack, -export, -example, -create, or -run&&EXIT /B
IF "%ARG2%"=="-NEWPACK" SET "MENU_SKIP=1"&&CALL:PROJ_NEW
IF "%ARG2%"=="-EXAMPLE" IF DEFINED ARG3 SET "NEW_NAME=%ARG3%"&&SET "MENU_SKIP=1"&&CALL:BASE_TEMPLATE
IF "%ARG2%"=="-EXPORT" IF "%ARG3%"=="-DRIVERS" IF "%ARG4%"=="-LIVE" SET "LIVE_APPLY=1"&&CALL:DRVR_EXPORT_SKIP
IF "%ARG2%"=="-EXPORT" IF "%ARG3%"=="-DRIVERS" IF "%ARG4%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG5 IF EXIST "%ImageFolder%\%ARG5%" SET "$PICK=%ImageFolder%\%ARG5%"&&CALL:DRVR_EXPORT_SKIP
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-BASE" IF DEFINED ARG4 SET "NEW_NAME=%ARG4%"&&IF "%ARG5%"=="-LIVE" SET "LIVE_APPLY=1"&&SET "BASE_CHOICE=%ARG6%"&&CALL:LIST_BASE_CREATE_CMD
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-BASE" IF DEFINED ARG4 SET "NEW_NAME=%ARG4%"&&IF "%ARG5%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG6 IF EXIST "%ImageFolder%\%ARG6%" SET "$PICK=%ImageFolder%\%ARG6%"&&SET "BASE_CHOICE=%ARG7%"&&CALL:LIST_BASE_CREATE_CMD
IF "%ARG2%"=="-RUNEXT" IF DEFINED ARG3 IF DEFINED ARG4 IF EXIST "%ARG4%" SET "INPUT=%ARG4%"&&CALL:GET_FILEEXT
IF "%ARG2%"=="-RUNEXT" IF DEFINED ARG3 IF DEFINED ARG4 IF EXIST "%ARG4%" SET "INPUT=%$PATH_X%"&&SET "OUTPUT=$PATH_X"&&CALL:SLASHER&&FOR /F "TOKENS=1 DELIMS=." %%a IN ("%EXT_UPPER%") DO (SET "ARG3=-%%a")
IF "%ARG2%"=="-RUNEXT" IF "%ARG3%"=="-LIST" IF EXIST "%ARG4%" SET "ARG2=-RUN"&&SET "ListFolder=%$PATH_X%"&&SET "ARG4=%$FILE_X%%$EXT_X%"
IF "%ARG2%"=="-RUNEXT" IF "%ARG3%"=="-PACK" IF EXIST "%ARG4%" SET "PackFolder=%$PATH_X%"&&SET "ARG4=%$FILE_X%%$EXT_X%"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-CUSTOM" SET "CUSTOM_SESSION=1"&&SET "DELETE_DONE=%ARG4%"&&SET "ARG3=-LIST"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-PACK" IF DEFINED ARG4 IF NOT EXIST "%PackFolder%\%ARG4%" ECHO.%COLOR4%ERROR:%$$% pack "%PackFolder%\%ARG4%" doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF DEFINED ARG4 IF NOT EXIST "%ListFolder%\%ARG4%" ECHO.%COLOR4%ERROR:%$$% list "%ListFolder%\%ARG4%" doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-VHDX" IF DEFINED ARG6 IF NOT EXIST "%ImageFolder%\%ARG6%" ECHO.%COLOR4%ERROR:%$$% vhdx "%ImageFolder%\%ARG6%" doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-PATH" IF NOT DEFINED ARG6 ECHO.%COLOR4%ERROR:%$$% path [%ARG6%] is not defined&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-PATH" IF DEFINED ARG6 IF NOT EXIST "%ARG6%\*" ECHO.%COLOR4%ERROR:%$$% path "%ARG6%" doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED ARG4 SET "PARSE_X="&&FOR /F "TOKENS=1-9* DELIMS=%U00%" %%a in ('ECHO.%ARGS%') DO (IF "%%b"=="COMMAND" SET "PARSE_X=1"&&SET "ARG4=%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"&&SET "ARGZ=5"&&CALL SET "ARGX=%%f"&&CALL:GET_ARGS)
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED PARSE_X FOR /F "TOKENS=1-6* DELIMS= " %%a in ('ECHO.%ARG5%') DO (SET "ARG5=%%a"&&SET "ARG6=%%b"&&SET "ARG7=%%c"&&SET "ARG8=%%d"&&SET "ARG9=%%e")
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED PARSE_X SET "PARSE_X="&&FOR %%a in (5 6 7 8 9) DO (SET "CAPS_SET=ARG%%a"&&CALL SET "CAPS_VAR=%%ARG%%a%%"&&CALL:CAPS_SET)
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED ARG4 SET "DELETE_DONE=1"&&SET "ARG3=-LIST"&&SET "ARG4=$LIST"&&ECHO.MENU-SCRIPT>"%ListFolder%\$LIST"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED ARG4 ECHO.%ARG4%>"%ListFolder%\$LIST"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-PACK" IF DEFINED ARG4 IF EXIST "%PackFolder%\%ARG4%" SET "$PACK_FILE=%PackFolder%\%ARG4%"&&SET "$LISTPACK=%ARG4%"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF DEFINED ARG4 IF EXIST "%ListFolder%\%ARG4%" SET "$LIST_FILE=%ListFolder%\%ARG4%"&&SET "$LISTPACK=%ARG4%"
IF NOT DEFINED $LISTPACK GOTO:COMMAND_IMAGEMGR_END
IF "%ARG2%"=="-RUN" FOR %%G in ("%$LISTPACK%") DO (SET "CAPS_SET=IMAGEMGR_EXT"&&SET "CAPS_VAR=%%~xG"&&CALL:CAPS_SET)
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF "%IMAGEMGR_EXT%"==".BASE" SET "BASE_EXEC=1"&&CALL:LIST_VIEWER&SET "IMAGEMGR_EXT=.LIST"&SET "$HEAD=MENU-SCRIPT"&SET "$LISTPACK=$LIST"&SET "$LIST_FILE=%ListFolder%\$LIST"&IF "%FOLDER_MODE%"=="ISOLATED" MOVE /Y "$LIST" "%ListFolder%">NUL 2>&1
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF DEFINED ERROR GOTO:COMMAND_IMAGEMGR_END
IF "%ARG2%"=="-RUN" IF DEFINED MENU_SESSION SET "ARG5=-MENU"
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-LIVE" SET "CURR_TARGET=LIVE_APPLY"&&CALL:IMAGEMGR_EXECUTE_COMMAND
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-MENU" SET "CURR_TARGET=LIVE_APPLY"&&SET "MENU_SESSION=1"&&CALL:IMAGEMGR_EXECUTE_COMMAND
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-PATH" IF DEFINED ARG6 IF EXIST "%ARG6%" SET "CURR_TARGET=PATH_APPLY"&&SET "INPUT=%ARG6%"&&SET "OUTPUT=TARGET_PATH"&&CALL:SLASHER&&CALL:IMAGEMGR_EXECUTE_COMMAND
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-VHDX" IF DEFINED ARG6 IF EXIST "%ImageFolder%\%ARG6%" SET "CURR_TARGET=VDISK_APPLY"&&SET "$VDISK_FILE=%ImageFolder%\%ARG6%"&&CALL:IMAGEMGR_EXECUTE_COMMAND
:COMMAND_IMAGEMGR_END
IF DEFINED DELETE_DONE DEL /Q /F "%ListFolder%\%DELETE_DONE%">NUL 2>&1
SET "DELETE_DONE="
EXIT /B
:IMAGEMGR_EXECUTE_COMMAND
IF "%CURR_TARGET%"=="PATH_APPLY" IF "%TARGET_PATH%"=="%SYSTEMDRIVE%" SET "CURR_TARGET=LIVE_APPLY"
SET "PATH_APPLY="&&SET "LIVE_APPLY="&&SET "VDISK_APPLY="&&SET "%CURR_TARGET%=1"
FOR %%G in ("%$LISTPACK%") DO (SET "CAPS_SET=IMAGEMGR_EXT"&&SET "CAPS_VAR=%%~xG"&&CALL:CAPS_SET)
IF "%$LISTPACK%"=="$LIST" SET "IMAGEMGR_EXT=.LIST"
IF "%IMAGEMGR_EXT%"==".LIST" SET "CURR_SESSION=EXEC"&&CALL:LIST_EXEC
IF "%IMAGEMGR_EXT%"==".PKX" SET "CURR_SESSION=PACK"&&CALL:PKX_EXEC
SET "%CURR_TARGET%="&&IF "%PROG_MODE%"=="GUI" CALL:PAUSED
FOR %%▓ in (CURR_SESSION CURR_TARGET TARGET_PATH PATH_APPLY LIVE_APPLY VDISK_APPLY) DO (SET "%%▓=")
EXIT /B
:COMMAND_DISKMGR
SET "$PASS="&&FOR %%▓ in (DISKLIST INSPECT ERASE CHANGEUID CREATE FORMAT DELETE MOUNT UNMOUNT) DO (IF "%ARG2%"=="-%%▓" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.ERROR: ARG2 not -DISKLIST, -INSPECT, -ERASE, -CREATE, -FORMAT, -DELETE, -MOUNT, or -UNMOUNT&&EXIT /B
IF DEFINED ARG2 IF "%ARG3%"=="-DISKUID" IF DEFINED ARG4 SET "DISK_TARGET=%ARG4%"&&CALL:DISK_DETECT>NUL 2>&1
IF DEFINED ARG2 IF "%ARG3%"=="-DISKUID" IF DEFINED ARG4 SET "ARG3=-DISK"&&SET "ARG4=%DISK_DETECT%"
IF DEFINED ARG2 IF "%ARG3%"=="-DISK" IF "%DISK_TARGET%"=="00000000" ECHO.%COLOR4%ERROR:%$$% Disk uid 00000000 can not be addressed by uid. Convert to GPT first (erase).&&EXIT /B
IF "%ARG3%"=="-DISK" IF DEFINED ARG4 CALL:DISK_DETECT>NUL 2>&1
IF "%ARG2%"=="-LIST" CALL:DISK_LIST
IF "%ARG2%"=="-INSPECT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&CALL:DISKMGR_INSPECT
IF "%ARG2%"=="-ERASE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&SET "$GET=TST_LETTER"&&CALL:LETTER_ANY&&CALL:DISKMGR_ERASE&SET "TST_LETTER="
IF "%ARG2%"=="-CHANGEUID" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&SET "GET_DISK_ID=%ARG5%"&&CALL:DISKMGR_CHANGEID
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-SIZE"  IF DEFINED ARG6 SET "PART_SIZE=%ARG6%"&&CALL:DISKMGR_CREATE
IF "%ARG2%"=="-FORMAT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&CALL:DISKMGR_FORMAT
IF "%ARG2%"=="-DELETE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&CALL:DISKMGR_DELETE
IF "%ARG2%"=="-MOUNT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&IF "%ARG7%"=="-LETTER" IF DEFINED ARG8 SET "DISK_LETTER=%ARG8%"&&CALL:DISKMGR_MOUNT
IF "%ARG2%"=="-MOUNT" IF "%ARG3%"=="-VHDX" IF EXIST "%ImageFolder%\%ARG4%" SET "$VDISK_FILE=%ImageFolder%\%ARG4%"&&IF "%ARG5%"=="-LETTER" IF DEFINED ARG6 SET "VDISK_LTR=%ARG6%"&&CALL:VDISK_ATTACH
IF "%ARG2%"=="-MOUNT" IF "%ARG3%"=="-VHDX" IF EXIST "%ImageFolder%\%ARG4%" IF "%ARG5%"=="-LETTER" IF DEFINED ARG6 IF "%ARG7%"=="-HIVE" SET "TARGET_PATH=%VDISK_LTR%:"&&CALL:MOUNT_EXT
IF "%ARG2%"=="-UNMOUNT" IF "%ARG3%"=="-LETTER" IF DEFINED ARG4 IF "%ARG5%"=="-HIVE" CALL:MOUNT_INT
IF "%ARG2%"=="-UNMOUNT" IF "%ARG3%"=="-LETTER" IF DEFINED ARG4 SET "$LTR=%ARG4%"&&CALL:DISKMGR_UNMOUNT
EXIT /B
:COMMAND_BOOTCREATOR
IF "%ARG2%"=="-CREATE" IF NOT EXIST "%CacheFolder%\BOOT.SAV" ECHO.%COLOR4%ERROR:%$$% Boot media %CacheFolder%\boot.sav doesn't exist&&EXIT /B
IF DEFINED ARG2 IF "%ARG3%"=="-DISKUID" IF DEFINED ARG4 SET "DISK_TARGET=%ARG4%"&&CALL:DISK_DETECT>NUL 2>&1
IF DEFINED ARG2 IF "%ARG3%"=="-DISKUID" IF DEFINED ARG4 SET "ARG3=-DISK"&&SET "ARG4=%DISK_DETECT%"
IF DEFINED ARG2 IF "%ARG3%"=="-DISK" IF "%DISK_TARGET%"=="00000000" ECHO.%COLOR4%ERROR:%$$% Disk uid 00000000 can not addressed by uid. Convert to GPT first (erase).&&EXIT /B
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF DEFINED ARG6 SET "VHDX_SLOTX=%ARG6%"&&CALL:BOOT_CREATOR_START
EXIT /B
:COMMAND_HELP
ECHO. Command Line Parameters:
ECHO.   %##%Miscellaneous%$$%
ECHO.   -help                                                           This menu
ECHO.   -nextboot -vhdx                                                 Schedule next boot to vhdx
ECHO.   -nextboot -recovery                                             Schedule next boot to recovery
ECHO.   -autoboot -install                                              Install reboot to recovery switcher service
ECHO.   -autoboot -remove                                               Remove reboot to recovery switcher service
ECHO.   %##%Image Processing%$$%
ECHO.   -imageproc -wim %@@%x.wim%$$% -index %@@%#%$$% -vhdx %@@%x.vhdx%$$% -size %@@%GB%$$%
ECHO.   -imageproc -vhdx %@@%x.vhdx%$$% -index %@@%#%$$% -wim %@@%x.wim%$$% -xlvl %@@%fast/max%$$%
ECHO. Examples-
ECHO.   %@@%-imageproc -wim x.wim -index 1 -path "c:\abc"%$$%
ECHO.   %@@%-imageproc -path "c:\abc" -wim x.wim -xlvl fast%$$%
ECHO.   %@@%-imageproc -wim x.wim -index 1 -vhdx x.vhdx -size 25%$$%
ECHO.   %@@%-imageproc -vhdx x.vhdx -index 1 -wim x.wim -xlvl fast%$$%
ECHO.   %##%Image Management%$$%
ECHO.   -imagemgr -run -list %@@%x.list%$$% -live /or/ -vhdx /or/ -path /or/ -menu%$$%
ECHO.   -imagemgr -run -item %@@%"%U00%x%U00%x%U00%x%U00%x%U00%"%$$% -live /or/ -vhdx %@@%x.vhdx%$$%
ECHO.   -imagemgr -run -pack %@@%x.pkx%$$% -live /or/ -vhdx /or/ -path /or/ -menu%$$%
ECHO.   -imagemgr -create -base %@@%x.base%$$% -live /or/ -vhdx %@@%x.vhdx%$$%
ECHO. Examples-
ECHO.   %@@%-imagemgr -run -list "x y z.list" -live%$$%
ECHO.   %@@%-imagemgr -run -pack x.pkx -vhdx x.vhdx%$$%
ECHO.   %@@%-imagemgr -run -item "%U00%EXTPACKAGE%U00%x y z.appx%U00%INSTALL%U00%DX%U00%" -vhdx x.vhdx%$$%
ECHO.   %@@%-imagemgr -run -list "x y z.list" -menu%$$%
ECHO.   %@@%-imagemgr -create -base x.base -live "1 2 3 4 5 6 7"%$$%
ECHO.   %@@%-imagemgr -create -base x.base -vhdx x.vhdx "1 2 3 4 5 6 7"%$$%
ECHO.   %##%File Management%$$%
ECHO.   -filemgr -grant %@@%file/folder%$$%
ECHO. Examples-
ECHO.   %@@%-filemgr -grant c:\x.txt%$$%
ECHO.   %##%Disk Management%$$%
ECHO.   -diskmgr -list                                                  Condensed list of disks
ECHO.   -diskmgr -inspect -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$%                     DiskPart inquiry on specified disk
ECHO.   -diskmgr -erase -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$%                       Delete all partitions on specified disk
ECHO.   -diskmgr -create -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% -size %@@%GB%$$%             Create NTFS partition on specified disk
ECHO.   -diskmgr -format -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% -part %@@%#%$$%              Format partition w/NTFS on specified disk
ECHO.   -diskmgr -delete -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% -part %@@%#%$$%              Delete partition on specified disk
ECHO.   -diskmgr -changeuid -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% %@@%new-uid%$$%           Change disk uid of specified disk
ECHO.   -diskmgr -mount -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% -part %@@%#%$$% -letter %@@%letter%$$%         Assign drive letter
ECHO.   -diskmgr -unmount -letter %@@%letter%$$%                                         Remove drive letter
ECHO.   -diskmgr -mount -vhdx %@@%x.vhdx%$$% -letter %@@%letter%$$%                              Mount virtual disk
ECHO. Examples-
ECHO.   %@@%-diskmgr -create -disk 0 -size 25%$$%
ECHO.   %@@%-diskmgr -mount -disk 0 -part 1 -letter e%$$%
ECHO.   %@@%-diskmgr -unmount -letter e%$$%
ECHO.   %##%BootDisk Creator%$$%
ECHO.   -bootcreator -create -disk %@@%#%$$% -vhdx %@@%x.vhdx%$$%                         Erase specified disk and make bootable
ECHO.   -bootcreator -create -diskuid %@@%uid%$$% -vhdx %@@%x.vhdx%$$%                    Erase specified disk and make bootable
ECHO. Examples-
ECHO.   %@@%-bootcreator -create -disk 0 -vhdx x.vhdx%$$%
ECHO.   %@@%-bootcreator -create -diskuid 12345678-1234-1234-1234-123456781234 -vhdx x.vhdx
ECHO.
EXIT /B
:BASE_EXAMPLE
ECHO.MENU-SCRIPT
ECHO.❗* Builder Execution Interactive List Items *❗
ECHO.
ECHO.❕Table❕ⓠ: Execution item, suppresses announcement / ⓡ: Reference item, no announcement❕
ECHO.❕Note❕List items without a 'ⓠ' or 'ⓡ' prefix are processed as execution.❕
ECHO.
ECHO.❕Group❕🪟Builder interactive items❕🪛Choice item❕Normal❕
ECHO.❕Note❕Choice Item. Choice1-9 are valid. Up to 9 choices seperated by '❗'.❕
ECHO.❕ⓠChoice1❕Select an option❕✅Choice1 1 selected❗❎Choice1 2 selected❗❎Choice1 3 selected❕VolaTILE❕
ECHO.❕ⓠTextHost❕Choice1.S:◁Choice1.S▷ Choice1.I:◁Choice1.I▷ Choice1.1:◁Choice1.1▷ Choice1.2:◁Choice1.2▷ Choice1.3:◁Choice1.3▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Group:◁Group▷ SubGroup:◁SubGroup▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder interactive items❕🪛Prompt item❕Normal❕
ECHO.❕Note❕Prompt Item. PROMPT1-9 are valid. Prompt filter 'Number', 'Letter', 'Alpha', 'Menu', 'Most', and 'None' are usable options. Minimum and maximum character limit are optional.❕
ECHO.❕ⓠPrompt1❕Enter text❕Alpha❗3-20❕VolaTILE❕
ECHO.❕ⓠTextHost❕ⓠPrompt1.S:◁Prompt1.S▷ Prompt1.I:◁Prompt1.I▷ Prompt1.1:◁Prompt1.1▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder interactive items❕🪛Picker item❕Normal❕
ECHO.❕Note❕Picker Item. Picker1-9 are valid. '◁ImageFolder▷', '◁ListFolder▷', '◁PackFolder▷', '◁CacheFolder▷', and '◁ProgFolder▷' are suggested options.❕
ECHO.❕ⓠPicker1❕Select a file❕◁ImageFolder▷❗*.wim❕VolaTILE❕
ECHO.❕ⓠTextHost❕Picker1.S:◁Picker1.S▷ Picker1.I:◁Picker1.I▷ Picker1.1:◁Picker1.1▷❕Screen❕DX❕
ECHO.
ECHO.
ECHO.
ECHO.❗* Builder Execution Non-Interactive List Items *❗
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛Condit item❕Normal❕
ECHO.❕Note❕Condit Item. Condit1-9 are valid. 'Defined', 'Ndefined', 'Exist', 'Nexist', 'EQ', 'NE', 'GE', 'LE', 'LT', and 'GT' are usable options. Enter ◁Null▷ into the 4th column if 'else' is not needed.❕
ECHO.❕ⓠString1❕TestString❕String❕1❕
ECHO.❕ⓠCondit1❕◁WinTar▷❗Exist❕WinTar Exists❕◁Null▷❕
ECHO.❕ⓠCondit2❕◁String1.I▷❗EQ❗1❕String1 1 equals 'TestString'❕String1 1 does not equal 'TestString'❕
ECHO.❕ⓠTextHost❕Condit1.S:◁Condit1.S▷ Condit1.I:◁Condit1.I▷ Condit1.1:◁Condit1.1▷ Condit1.2:◁Condit1.2▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Condit2.S:◁Condit2.S▷ Condit2.I:◁Condit2.I▷ Condit2.1:◁Condit2.1▷ Condit2.2:◁Condit2.2▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛Array item❕Normal❕
ECHO.❕Note❕Array items are similar to a condit item, except the condition is always 'EQ'. Basically it's an array of if's. Optional 5th column adds 'else' function.❕
ECHO.❕ⓠArray1❕a❕a❗b❗c❕✅Array1 Option 1 selected❗✅Array1 Option 2 selected❗✅Array1 Option 3 selected❕
ECHO.❕ⓠArray2❕1❕1❗2❗3❕✅Array2 0ption 1 selected❗✅Array2 Option 2 selected❗✅Array2 Option 3 selected❕✅Array2 Else 1 selected❗✅Array2 Else 2 selected❗✅Array2 Else 3 selected❕
ECHO.❕ⓠTextHost❕Array1.S:◁Array1.S▷ Array1.I:◁Array1.I▷ Array1.1:◁Array1.1▷ Array1.2:◁Array1.2▷ Array1.3:◁Array1.3▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Array2.S:◁Array2.S▷ Array2.I:◁Array2.I▷ Array2.1:◁Array2.1▷ Array2.2:◁Array2.2▷ Array2.3:◁Array2.3▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛Math item❕Normal❕
ECHO.❕Note❕Math item. MATH1-9 are valid. '+', '-', '/', and '*' are usable options.❕
ECHO.❕ⓠMath1❕1❕*❕5❕
ECHO.❕ⓠTextHost❕Math1.S:◁Math1.S▷ Math1.I:◁Math1.I▷ Math1.1:◁Math1.1▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛String item❕Normal❕
ECHO.❕Note❕String item. String1-9 are valid. 'String' and 'Integer' are usable options.❕
ECHO.❕ⓠString1❕10❗20❗30❗40❗50❕Integer❕3❕
ECHO.❕ⓠString2❕A❗B❗C❗D❗E❕String❕2❕
ECHO.❕ⓠTextHost❕String1.S:◁String1.S▷ String1.I:◁String1.I▷ String1.1:◁String1.1▷ String1.2:◁String1.2▷ String1.3:◁String1.3▷ String1.4:◁String1.4▷ String1.5:◁String1.5▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕String2.S:◁String2.S▷ String2.I:◁String2.I▷ String2.1:◁String2.1▷ String2.2:◁String2.2▷ String2.3:◁String2.3▷ String2.4:◁String2.4▷ String2.5:◁String2.5▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛Routine item❕Normal❕
ECHO.❕Note❕Routine items are loop based. Routine1-9 are valid. 'Command' and 'Split' are usable options. Optional column number match seperated by '❗'. An asterisk can be used in column 4 as a tokens modifier eg '3*'.❕
ECHO.❕ⓠRoutine1❕^<^>:❗DIR /B C:\❗1❗Program Files❕Command❕1❕
ECHO.❕ⓠRoutine2❕:❗A:B:C❗3❗C❕Split❕2❕
ECHO.❕X❕ⓠRoutine1❕^<^>:❗DIR /B C:\❕Command❕1❕
ECHO.❕X❕ⓠRoutine2❕:❗A:B:C❕Split❕2❕
ECHO.❕ⓠTextHost❕Routine1.S:◁Routine1.S▷ Routine1.I:◁Routine1.I▷  Routine1.1:◁Routine1.1▷ Routine1.2:◁Routine1.2▷ Routine1.3:◁Routine1.3▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Routine2.S:◁Routine2.S▷ Routine2.I:◁Routine2.I▷  Routine2.1:◁Routine2.1▷ Routine2.2:◁Routine2.2▷ Routine2.3:◁Routine2.3▷❕Screen❕DX❕
ECHO.
ECHO.
ECHO.
ECHO.❗* Builder Reference List Items Example *❗
ECHO.
ECHO.❕Group❕🎨Reference Example❕🎨Theme ➥ ◁Array1.S▷❕Normal❕
ECHO.❕ⓡRoutine1❕ ❗reg.exe query "◁HiveUser▷\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme"❗1❗AppsUseLightTheme❕Command❕3❕
ECHO.❕ⓡArray1❕◁Routine1.S▷❕0x0❗0x1❗◁Null▷❕🌑Dark❗🌕Light❗❔NoValue❕
ECHO.❕ⓠChoice1❕Select an option❕🌕Light theme❗🌑Dark theme❕VolaTILE❕
ECHO.❕ⓠArray1❕◁Choice1.I▷❕1❗2❕1❗0❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize❗AppsUseLightTheme❗◁Array1.S▷❗Dword❕Create❕DX❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize❗SystemUsesLightTheme❗◁Array1.S▷❗Dword❕Create❕DX❕
ECHO.❕ⓠTextHost❕◁Choice1.S▷ applied.❕Screen❕DX❕
ECHO.
ECHO.
ECHO.
ECHO.❗* Execution List Items *❗
ECHO.
ECHO.❕Group❕🪟Execution items❕🪛Command item❕Normal❕
ECHO.❕Note❕Command item. 'Normal', 'NoMount', 'Normal❗RAU', 'Normal❗RAS', 'Normal❗RATI', 'NoMount❗RAU', 'NoMount❗RAS', or 'NoMount❗RATI' are usable options.❕
ECHO.❕ⓠCommand❕echo.testing 1 2 3.❕Normal❕DX❕
ECHO.
ECHO.❕Group❕🪟Execution items❕🪛Registry create item❕Normal❕
ECHO.❕Note❕Registry item. 'Create', 'Delete', 'Create❗RAU', 'Create❗RAS', 'Create❗RATI', 'Delete❗RAU', 'Delete❗RAS', or 'Delete❗RATI' are usable options. 'Dword', 'Qword', 'Binary', 'String', 'Expand', and 'Multi' are usable options.❕
ECHO.
ECHO.❕Note❕Registry item create key.❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❕Create❕DX❕
ECHO.
ECHO.❕Note❕Registry item create value with empty value and data.❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❗◁Null▷❗TestData❗String❕Create❕DX❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❗TestValue❗◁Null▷❗String❕Create❕DX❕
ECHO.
ECHO.❕Note❕Registry item delete value.❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❗TestValue❕Delete❕DX❕
ECHO.
ECHO.❕Note❕Registry item delete key.❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❕Delete❕DX❕
ECHO.
ECHO.❕Group❕🪟Execution items❕🪛FileOper item❕Normal❕
ECHO.❕Note❕FileOper item. 'Create', 'Delete', 'Rename', 'Copy', 'Move', and 'Takeown' are usable options.❕
ECHO.❕Note❕FileOper item create folder.❕
ECHO.❕ⓠFileOper❕c:\test❕Create❕DX❕
ECHO.
ECHO.❕Note❕FileOper item move.❕
ECHO.❕ⓠTextHost❕test❕File❗c:\testmove.txt❕DX❕
ECHO.❕ⓠFileOper❕testmove.txt❗c:\test❕Move❕DX❕
ECHO.
ECHO.❕Group❕🪟Execution items❕🪛Session item + TextHost item❕Normal❕
ECHO.❕Note❕Alternatively, using these unicode '％' or '＄' symbols guarantees passing a percent or dollar sign.❕
ECHO.❕Note❕TextHost item. 'Screen' and 'File' are usable options. When outputting to a file, using the '◁U00▷' and '◁U01▷' variables will create white '❕' and red '❗' columns, and the '◁U0P▷' and '◁U0D▷' generates unicode '％' or '＄' symbols.❕
ECHO.❕ⓠTextHost❕MENU-SCRIPT❕File❗◁ListFolder▷\testlist.list❕DX❕
ECHO.❕ⓠTextHost❕◁U00▷ⓠTextHost◁U00▷Greetings from session 2◁U00▷Screen◁U00▷DX◁U00▷❕File❗◁ListFolder▷\testlist.list❕DX❕
ECHO.❕Note❕Session item. Using the '-PATH "◁DrvTar▷"' parameter during an active session will reuse the active session's target.❕
ECHO.❕ⓠSession❕-IMAGEMGR -RUN -LIST "testlist.list" -PATH "◁DrvTar▷"❕◁Null▷❕DX❕
ECHO.❕ⓠTextHost❕End of session 1❕Screen❕DX❕
ECHO.❕ⓠFileOper❕◁ListFolder▷\testlist.list❕Delete❕DX❕
ECHO.
ECHO.❕Group❕🪟Miscellaneous Examples❕Items being used in conjunction❕Normal❕
ECHO.❕ⓠChoice1❕Select an option❕🪛Choice A❗🪛Choice B❗🪛Choice C❗❕VolaTILE❕
ECHO.❕ⓠArray1❕◁Choice1.I▷❕1❗2❗3❕A❗B❗C❕
ECHO.❕ⓠArray2❕◁Array1.S▷❕A❗B❗C❕DX❗DX❗DX❕
ECHO.❕ⓠTextHost❕Choice ◁Array2.S▷ picked.❕Screen❕◁Array2.1▷❕
ECHO.❕ⓠTextHost❕Choice ◁Array2.S▷ picked.❕Screen❕◁Array2.2▷❕
ECHO.❕ⓠTextHost❕Choice ◁Array2.S▷ picked.❕Screen❕◁Array2.3▷❕
EXIT /B
:MENU_EXAMPLE_BASE
ECHO.MENU-SCRIPT
ECHO.❗* This is an example of a custom menu for recovery *❗
ECHO.
ECHO.❕Group❕Recovery Operation Example❕Backup picked vhdx to backup.wim❕Normal❕
ECHO.❕ⓠPicker1❕Select a vhdx to backup❕◁ProgFolder▷❗*.vhdx❕VolaTILE❕
ECHO.❕ⓠCondit1❕◁ProgFolder▷\◁Picker1.S▷❗Exist❕DX❕DX❕
ECHO.❕ⓠTextHost❕◁ProgFolder▷\◁Picker1.S▷ does not exist.❕Screen❕◁Condit1.2▷❕
ECHO.❕ⓠTextHost❕Deleting backup.wim❕Screen❕◁Condit1.1▷❕
ECHO.❕ⓠFileOper❕◁ImageFolder▷\backup.wim❕Delete❕◁Condit1.1▷❕
ECHO.❕ⓠSession❕-imageproc -vhdx "◁Picker1.S▷" -index 1 -wim "backup.wim" -size 25❕◁Null▷❕◁Condit1.1▷❕
ECHO.❕ⓠCommand❕PAUSE❕Normal❕DX❕
ECHO.
ECHO.❕Group❕Recovery Operation Example❕Restore picked wim to current.vhdx❕Normal❕
ECHO.❕ⓠPicker1❕Select a wim to restore❕◁ImageFolder▷❗*.wim❕VolaTILE❕
ECHO.❕ⓠCondit1❕◁ProgFolder▷\◁Picker1.S▷❗Exist❕DX❕DX❕
ECHO.❕ⓠTextHost❕◁ImageFolder▷\◁Picker1.S▷ does not exist.❕Screen❕◁Condit1.2▷❕
ECHO.❕ⓠTextHost❕Deleting current.vhdx❕Screen❕◁Condit1.1▷❕
ECHO.❕ⓠFileOper❕◁ProgFolder▷\current.vhdx❕Delete❕◁Condit1.1▷❕
ECHO.❕ⓠSession❕-imageproc -wim "◁Picker1.S▷" -index 1 -vhdx "current.vhdx" -size 25❕◁Null▷❕◁Condit1.1▷❕
ECHO.❕ⓠCommand❕PAUSE❕Normal❕DX❕
EXIT /B
:MENU_EXAMPLE_EXEC
ECHO.MENU-SCRIPT
ECHO.❗* This is an example of a reboot to restore scenerio as an execution list *❗
ECHO.
ECHO.❕ⓠCondit1❕◁ImageFolder▷\backup.wim❗Exist❕DX❕DX❕
ECHO.❕ⓠTextHost❕ECHO.◁ImageFolder▷\backup.wim does not exist.❕Screen❕◁Condit1.2▷❕
ECHO.❕ⓠTextHost❕Deleting current.vhdx❕Screen❕◁Condit1.1▷❕
ECHO.❕ⓠFileOper❕◁ProgFolder▷\current.vhdx❕Delete❕◁Condit1.1▷❕
ECHO.❕ⓠSession❕-imageproc -wim "backup.wim" -index 1 -vhdx "current.vhdx" -size 25❕◁Null▷❕◁Condit1.1▷❕
ECHO.❕ⓠCommand❕PAUSE❕Normal❕DX❕
EXIT /B
:GET_INIT
SET "CMD=CMD.EXE"&&SET "DISM=DISM.EXE"&&SET "REG=REG.EXE"&&SET "BCDEDIT=BCDEDIT.EXE"
SET "ERROR="&&SET "MENU_EXIT="&&SET "SETS_LOAD="&&SET "GUI_ACTIVE="
SET "VER_GET=%~f0"&&CALL:GET_PROGVER&&CD /D "%~DP0"&&CHCP 65001>NUL
IF EXIST "%ProgFolder0%\$CON" SET "GUI_ACTIVE=1"&DEL /F /Q "%ProgFolder0%\$CON">NUL 2>&1
SET "ORIG_CD=%CD%"&&FOR /F "TOKENS=*" %%a in ("%CD%") DO (SET "CAPS_SET=ProgFolder0"&&SET "CAPS_VAR=%%a"&&CALL:CAPS_SET)
FOR /F "TOKENS=1-2 DELIMS=:" %%a IN ("%ProgFolder0%") DO (SET "CHAR_STR=%%b"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK&&IF "%%b"=="\" SET "ProgFolder0=%%a:")
IF DEFINED CHAR_FLG SET "ERROR=Remove the space from the path or folder name, then launch again."
IF NOT EXIST "%ProgFolder0%" SET "ERROR=Invalid path or folder name. Relocate, then launch again."
IF "%ProgFolder0%"=="X:\$" IF NOT "%SYSTEMDRIVE%"=="X:" SET "ERROR=Relocate to path other than X:\$."
IF "%ProgFolder0%"=="%SYSTEMDRIVE%\WINDOWS\SYSTEM32" SET "ERROR=Invalid path or folder name. Relocate, then launch again."
SET "PATH_TEMP="&&FOR /F "TOKENS=1-9 DELIMS=\" %%a IN ("%ProgFolder0%") DO (IF "%%a\%%b\%%c"=="%SystemDrive%\WINDOWS\TEMP" SET "PATH_TEMP=1"
IF "%%a\%%b\%%d\%%e\%%f"=="%SystemDrive%\USERS\APPDATA\LOCAL\TEMP" SET "PATH_TEMP=1")
IF DEFINED PATH_TEMP SET "ERROR=This should not be run from a temp folder. Extract zip into a new folder, then launch again."
%REG% query "HKU\S-1-5-19\Environment">NUL
IF NOT "%ERRORLEVEL%" EQU "0" SET "ERROR=Right click and run as administrator."
SET "LANG_PASS="&&FOR /F "TOKENS=4-5 DELIMS= " %%a IN ('DIR') DO (IF "%%a %%b"=="bytes free" SET "LANG_PASS=1")
IF NOT DEFINED LANG_PASS SET "ERR_MSG=Non-english host language/locale."
IF "%SYSTEMDRIVE%"=="X:" IF EXIST "X:\$\HOST_TARGET" SET "WINPE_BOOT=1"
IF DEFINED ERROR CALL ECHO.ERROR: %ERROR%&&PAUSE&&GOTO:QUIT
CALL:SESSION_CLEAR&CALL:GET_ARGS&CALL:GET_SID&CALL:MOUNT_INT
IF DEFINED ARG1 SET "PROG_MODE=COMMAND"&&GOTO:COMMAND_MODE
IF NOT "%ProgFolder0%"=="X:\$" SET "PROG_MODE=PORTABLE"&&CALL:SETS_HANDLER&&GOTO:MAIN_MENU
IF "%ProgFolder0%"=="X:\$" IF "%SystemDrive%"=="X:" SET "PROG_MODE=RAMDISK"
IF EXIST "%ProgFolder0%\RECOVERY_LOCK" CALL:RECOVERY_LOCK
IF DEFINED LOCKOUT GOTO:QUIT
CALL:HOST_AUTO&&CALL:SETS_HANDLER&&CALL:LOGO
%REG% DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\MiniNT" /f>NUL 2>&1
GOTO:MAIN_MENU
:GET_FILEPATH
FOR %%G in ("%$GET_FILEPATH%") DO (SET "$PATH=%%~dG%%~pG"&&SET "$BODY=%%~nG"&&SET "$EXT=%%~xG")
SET "$GET_FILEPATH="&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "$PATH=%%$PATH:%%G=%%G%%"&&CALL SET "$BODY=%%$BODY:%%G=%%G%%"&&CALL SET "$EXT=%%$EXT:%%G=%%G%%")
EXIT /B
:GET_ARGS
FOR %%1 in (1 2 3 4 5 6 7 8 9) DO (IF DEFINED ARG%%1 SET "ARGZ=%%1"&&CALL SET "ARGX=%%ARG%%1%%"&&CALL:GET_ARGSX)
IF DEFINED ARG1 FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
FOR %%1 in (1 2 3 4 5 6 7 8 9) DO (IF DEFINED ARG%%1 CALL SET "ARG%%1=%%ARG%%1:%%G=%%G%%"))
EXIT /B
:GET_ARGSX
CALL SET "ARG%ARGZ%=%ARGX:"=%"
CALL SET "ARG%ARGZ%X=%ARGX:"=%"
EXIT /B
:GET_BYTES
FOR %%a in (INPUT OUTPUT) DO (IF NOT DEFINED %%a EXIT /B)
SET "%OUTPUT%="&&SET "XNT=0"&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%INPUT%^| FIND /V ""') do (SET "CHAR=%%G"&&SET /A "XNT+=1"&&CALL:CHAR_XNT)
GOTO:GET_BYTES_%GET_BYTES%
:GET_BYTES_GB
IF %XNT% LSS 10 SET /A "%OUTPUT%=0"
IF "%XNT%"=="10" SET /A "%OUTPUT%=%CHAR1%"
IF "%XNT%"=="11" SET /A "%OUTPUT%=%CHAR1%%CHAR2%"
IF "%XNT%"=="12" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%"
IF "%XNT%"=="13" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%"
IF "%XNT%"=="14" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%"
IF "%XNT%"=="15" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%"
IF "%XNT%"=="16" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%"
GOTO:GET_BYTES_END
:GET_BYTES_MB
IF %XNT% LSS 7 SET /A "%OUTPUT%=0"
IF "%XNT%"=="7" SET /A "%OUTPUT%=%CHAR1%"
IF "%XNT%"=="8" SET /A "%OUTPUT%=%CHAR1%%CHAR2%"
IF "%XNT%"=="9" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%"
IF "%XNT%"=="10" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%"
IF "%XNT%"=="11" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%"
IF "%XNT%"=="12" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%"
IF "%XNT%"=="13" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%"
IF "%XNT%"=="14" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%%CHAR8%"
IF "%XNT%"=="15" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%%CHAR8%%CHAR9%"
IF "%XNT%"=="16" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%%CHAR8%%CHAR9%%CHAR10%"
:GET_BYTES_END
FOR %%a in (1 2 3 4 5 6 7 8 9 10) DO (SET "CHAR%%a=")
SET "INPUT="&&SET "OUTPUT="&&SET "CHAR="&&SET "GET_BYTES="&&EXIT /B
:CHAR_XNT
IF %XNT% GTR 10 EXIT /B
SET "CHAR%XNT%=%CHAR%"
EXIT /B
:GET_FREE_SPACE
FOR %%a in (INPUT OUTPUT) DO (IF NOT DEFINED %%a EXIT /B)
SET "%OUTPUT%="&&FOR /F "TOKENS=1-5 DELIMS= " %%a IN ('DIR "%INPUT%\" 2^>NUL') DO (SET "OUTPUTX=%%c")
IF NOT DEFINED OUTPUTX SET "%OUTPUT%=ERROR"&&SET "OUTPUT="&&SET "INPUT="&&SET "ERROR=GET_FREE_SPACE"&&CALL:DEBUG&&EXIT /B
SET "%OUTPUT%=%OUTPUTX:,=%"
CALL SET "CHECK_VAR=%%%OUTPUT%%%"&&SET "$CHECK=NUMBER"&&CALL:CHECK
IF NOT DEFINED ERROR CALL SET "INPUT=%%%OUTPUT%%%"&&CALL:GET_BYTES
SET "OUTPUT="&&SET "OUTPUTX="&&SET "INPUT="&&EXIT /B
:GET_SPACE_ENV
SET "FREE="&&FOR /F "TOKENS=1-5 DELIMS= " %%a IN ('DIR "%ProgFolder%\"') DO (SET "FREE=%%c")
IF DEFINED FREE SET "FREE=%FREE:,=%"
IF DEFINED FREE SET "GET_BYTES=GB"&&SET "INPUT=%FREE%"&&SET "OUTPUT=FREE"&&CALL:GET_BYTES
EXIT /B
:GET_FILESIZE
FOR %%a in (INPUT OUTPUT) DO (IF NOT DEFINED %%a EXIT /B)
SET "%OUTPUT%="&&FOR /F "TOKENS=1-5* SKIP=3 DELIMS= " %%a IN ('DIR "%INPUT%"') DO (IF NOT "%%e"=="" IF NOT DEFINED OUTPUTX SET "OUTPUTX=%%d")
IF NOT DEFINED OUTPUTX SET "%OUTPUT%=ERROR"&&SET "OUTPUT="&&SET "INPUT="&&SET "ERROR=GET_FILESIZE"&&CALL:DEBUG&&EXIT /B
SET "%OUTPUT%=%OUTPUTX:,=%"
CALL SET "CHECK_VAR=%%%OUTPUT%%%"&&SET "$CHECK=NUMBER"&&CALL:CHECK
IF NOT DEFINED ERROR CALL SET "INPUT=%%%OUTPUT%%%"&&CALL:GET_BYTES
SET "OUTPUT="&&SET "OUTPUTX="&&SET "INPUT="&&EXIT /B
:GET_FILEEXT
SET "$PATH_X="&&SET "$FILE_X="&&SET "$EXT_X="&&FOR %%G in ("%INPUT%") DO (SET "$PATH_X=%%~dG%%~pG"&&SET "$FILE_X=%%~nG"&&SET "$EXT_X=%%~xG")
SET "$CASE=UPPER"&&SET "CAPS_SET=EXT_UPPER"&&SET "CAPS_VAR=%$EXT_X%"&&CALL:CAPS_SET
SET "INPUT="&&EXIT /B
:GET_SID
FOR /F "TOKENS=2* SKIP=1 DELIMS=:\. " %%a in ('%REG% QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUser 2^>NUL') do (IF "%%a"=="REG_SZ" SET "UsrNam=%%b")
FOR /F "TOKENS=2* SKIP=1 DELIMS=:\. " %%a in ('%REG% QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUserSID 2^>NUL') do (IF "%%a"=="REG_SZ" SET "UsrSid=%%b")
SET "ERRORLEVEL=0"&&EXIT /B
:GET_NEXTBOOT
SET "BOOT_OK="&&SET "GUID_TMP="&&SET "GUID_CUR="&&FOR /F "TOKENS=1-5 DELIMS= " %%a in ('%BCDEDIT% /V') do (
IF "%%a"=="displayorder" SET "GUID_CUR=%%b"
IF "%%a"=="identifier" SET "GUID_TMP=%%b"
IF "%%a"=="description" IF "%%b"=="Recovery" SET "BOOT_OK=1"&&GOTO:GET_NEXTBOOTX)
:GET_NEXTBOOTX
IF "%GUID_TMP%"=="%GUID_CUR%" SET "NEXT_BOOT=RECOVERY"
IF NOT "%GUID_TMP%"=="%GUID_CUR%" SET "NEXT_BOOT=VHDX"
EXIT /B
:GET_WIMINDEX
IF NOT DEFINED $IMAGE_X EXIT /B
FOR /F "TOKENS=1-5 SKIP=5 DELIMS=:<> " %%a in ('%DISM% /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"%$IMAGE_X%" 2^>NUL') DO (IF "%%a"=="Index" SET "INDEX_Z=%%b"
IF "%%d"=="%INDEX_WORD%" SET "INDEX_WORD="&&SET "$IMAGE_X="&&EXIT /B)
SET "INDEX_WORD="&&SET "INDEX_Z="&&SET "$IMAGE_X="&&EXIT /B
:GET_PATHINFO
FOR %%a in ($PATHEDIT $PATHVER) DO (IF DEFINED %%a SET "%%a=")
IF "%$PATH_X%"=="%SYSTEMDRIVE%" SET "$IMAGE_X=ONLINE"
IF "%$PATH_X%"=="%SYSTEMDRIVE%\" SET "$IMAGE_X=ONLINE"
IF NOT "%$IMAGE_X%"=="ONLINE" SET "$IMAGE_X=IMAGE:"%$PATH_X%""
FOR /F "TOKENS=1-2* DELIMS=<>: " %%a in ('%DISM% /ENGLISH /%$IMAGE_X% /GET-CURRENTEDITION 2^>NUL') DO (IF "%%a %%b"=="Image Version" IF NOT "%%c"=="undefined>" SET "$PATHVER=%%c"
IF "%%a %%b"=="Current Edition" IF NOT "%%c"=="undefined>" SET "$PATHEDIT=%%c")
IF NOT DEFINED $PATHVER SET "ERROR=GET_PATHINFO"&&CALL:DEBUG
SET "$PATH_X="&&SET "$IMAGE_X="&&EXIT /B
:GET_IMAGEINFO
FOR %%a in ($IMGNAME $IMGEDIT $IMGDESC $IMGVER $BUILD) DO (IF DEFINED %%a SET "%%a=")
FOR /F "TOKENS=1-2* SKIP=3 DELIMS=:<> " %%a in ('%DISM% /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"%$IMAGE_X%" /Index:%INDEX_X% 2^>NUL') DO (
IF "%%a"=="Name" IF NOT "%%b"=="undefined" IF NOT "%%c"=="" SET "$IMGNAME=%%b %%c"
IF "%%a"=="Name" IF NOT "%%b"=="undefined" IF "%%c"=="" SET "$IMGNAME=%%b"
IF "%%a"=="Description" IF NOT "%%b"=="undefined" IF NOT "%%c"=="" SET "$IMGDESC=%%b %%c"
IF "%%a"=="Description" IF NOT "%%b"=="undefined" IF "%%c"=="" SET "$IMGDESC=%%b"
IF "%%a"=="Version" IF NOT "%%b"=="undefined" SET "$IMGVER=%%b"
IF "%%a"=="Edition" IF NOT "%%b"=="undefined" SET "$IMGEDIT=%%b"
IF "%%a %%b"=="ServicePack Build" IF NOT "%%c"=="undefined>" SET "$BUILD=%%c")
IF DEFINED $IMGVER IF DEFINED $BUILD SET "$IMGVER=%$IMGVER%.%$BUILD%"&&SET "$BUILD="
IF NOT DEFINED $IMGVER SET "ERROR=GET_IMAGEINFO"&&CALL:DEBUG
SET "$IMAGE_X="&&SET "INDEX_X="&&EXIT /B
:GET_PROGVER
IF NOT DEFINED VER_SET SET "VER_SET=VER_CUR"
IF EXIST "%VER_GET%" SET /P VER_CHK=<"%VER_GET%"
SET "%VER_SET%="&&FOR /F "TOKENS=1-9 DELIMS= " %%A IN ("%VER_CHK%") DO (SET "%VER_SET%=%%I")
IF NOT DEFINED %VER_SET% SET "ERROR=GET_PROGVER"&&CALL:DEBUG
SET "VER_CHK="&&SET "VER_GET="&&SET "VER_SET="&&EXIT /B
:GET_HEADER
SET "$HEAD="&&FOR %%a in ($HEAD_CHECK) DO (IF NOT DEFINED %%a EXIT /B)
SET /P $HEAD=<"%$HEAD_CHECK%"
IF NOT DEFINED $HEAD SET "ERROR=HEADER"&&GOTO:HEADER_SKIP
FOR /F "TOKENS=1-9 DELIMS= " %%a IN ("!$HEAD!") DO (IF "%%a"=="MENU-SCRIPT" SET "$HEAD=MENU-SCRIPT"
IF NOT "%%b"=="" FOR %%◌ in (%%a %%b %%c %%d %%e %%f %%g %%h) DO (IF "%%◌"=="MENU" SET "MENU_SESSION=1"))
IF NOT "!$HEAD!"=="MENU-SCRIPT" SET "ERROR=HEADER"&&ECHO.%COLOR2%ERROR:%$$% Header is not MENU-SCRIPT, check file.
:HEADER_SKIP
IF DEFINED ERROR IF "%DEBUG%"=="ENABLED" CALL:DEBUG
SET "$HEAD_CHECK="&&EXIT /B
:GET_RANDOM
IF NOT DEFINED RND_TYPE SET "RND_TYPE=1"
CALL:RND%RND_TYPE% >NUL 2>&1
IF NOT DEFINED RND1 GOTO:GET_RANDOM
IF "%RND2%"=="%RND1%" GOTO:GET_RANDOM
SET "RND2=%RND1%"&&CALL SET "%RND_SET%=%RND1%"&&SET "RND_TYPE="&&SET "RND_SET="&&SET "RND1="
EXIT /B
:RND1
FOR /F "TOKENS=1-9 DELIMS=:." %%a in ("%TIME%") DO (FOR /F "DELIMS=" %%G IN ('%CMD% /D /U /C CALL ECHO.%%d') DO (CALL SET "RND1=%%G"))
EXIT /B
:RND2
SET "RND1=%RANDOM%%RANDOM%"&&SET "RND1=!RND1:~5,5!"&&SET "RND1=!RND1:~1,1!"
EXIT /B
:TIMER
FOR /F "TOKENS=3 DELIMS=:." %%a in ("%TIME%") DO (IF NOT "%%a"=="%TIMER_LAST%" SET "TIMER_LAST=%%a"&&SET /A "TIMER-=1"&&IF DEFINED TIMER_MSG CLS&&CALL ECHO.%TIMER_MSG%)
IF NOT "%TIMER%"=="0" GOTO:TIMER
SET "TIMER="&&SET "TIMER_LAST="&&SET "TIMER_MSG="&&EXIT /B
:TIMER_POINT3
FOR /F "TOKENS=1-9 DELIMS=:." %%a in ("%TIME%") DO (FOR /F "DELIMS=" %%G IN ('%CMD% /D /U /C CALL ECHO.%%d') DO (CALL SET "TIMER_X=%%G"))
FOR %%a in (2 5 8) DO (IF "%TIMER_X%"=="%%a" SET "TIMER_X="&&EXIT /B)
GOTO:TIMER_POINT3
:SLASHER
FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%INPUT%^| FIND /V ""') do (SET "SLASH_X=%%G"&&CALL:SLASHER_X)
IF NOT "%SLASH_X%"=="\" IF EXIST "%INPUT%\" SET "%OUTPUT%=%INPUT%"
IF "%SLASH_X%"=="\" IF EXIST "%INPUT%" SET "%OUTPUT%=%SLASH_Z%"
IF NOT EXIST "%INPUT%\" SET "%OUTPUT%="
FOR %%a in (SLASH_X SLASH_Y SLASH_Z OUTPUT INPUT) DO (SET "%%a=")
EXIT /B
:SLASHER_X
SET "SLASH_Z=%SLASH_Y%"&&SET "SLASH_Y=%SLASH_Y%%SLASH_X%"
EXIT /B
:CLEAN
IF EXIST "%ListFolder%\$LIST" DEL /Q /F "%ListFolder%\$LIST">NUL 2>&1
IF NOT EXIST "$*" EXIT /B
IF EXIST "%ImageFolder%\$TEMP.vhdx" CALL:VTEMP_DELETE>NUL 2>&1
IF EXIST "%ImageFolder%\$TEMP.wim" DEL /Q /F "%ImageFolder%\$TEMP.wim">NUL 2>&1
FOR %%G in (TEMP LIST DISK LOG) DO (IF EXIST "$%%G*" DEL /Q /F "$%%G*">NUL 2>&1)
FOR %%G in (DRVR FEAT) DO (IF NOT DEFINED %%G_QRY IF EXIST "$%%G" DEL /Q /F "$%%G">NUL 2>&1)
FOR %%G in (RAS RATI) DO (IF NOT DEFINED CURR_TARGET IF EXIST "$%%G.cmd" CALL:RASTI_CHECK&CALL:RAS_DELETE&DEL /Q /F "$%%G.cmd">NUL 2>&1)
EXIT /B
:FOLDER_DEL
IF NOT DEFINED FOLDER_DEL EXIT /B
%DISM% /cleanup-MountPoints>NUL 2>&1
ATTRIB -R -S -H "%FOLDER_DEL%" /S /D /L>NUL 2>&1
TAKEOWN /F "%FOLDER_DEL%" /R /D Y>NUL 2>&1
ICACLS "%FOLDER_DEL%" /grant %USERNAME%:F /T>NUL 2>&1
RD /S /Q "\\?\%FOLDER_DEL%">NUL 2>&1
SET "FOLDER_DEL="&&EXIT /B
:PAD_PREV
ECHO.               Press (%##%Enter%$$%) to return to previous menu
EXIT /B
:PAUSED
IF NOT DEFINED NO_PAUSE SET /P "PAUSED=.                      Press (%##%Enter%$$%) to continue..."
SET "NO_PAUSE="&&EXIT /B
:CONFIRM
IF DEFINED ERROR EXIT /B
SET "$HEADERS= %U01% %U01% %U01% %U01%                  %COLOR4%Are you sure?%$$% Press (%##%X%$$%) to proceed%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" SET "ERROR=CONFIRM"&&CALL:DEBUG
EXIT /B
:RECOVERY_LOCK
SET "LOCKOUT="&&SET "$HEADERS= %U01% %U01% %U01% %U01%                       Enter recovery password%U01% %U01% %U01% "&&SET "$NO_ERRORS=1"&&SET "$SELECT=RECOVERY_PROMPT"&&SET "$CHECK=MOST"&&CALL:PROMPT_BOX
SET /P RECOVERY_LOCK=<"%ProgFolder0%\RECOVERY_LOCK"
IF NOT "%RECOVERY_PROMPT%"=="%RECOVERY_LOCK%" SET "LOCKOUT=1"
SET "RECOVERY_PROMPT="&&SET "RECOVERY_LOCK="
EXIT /B
:DEBUG
IF NOT "%DEBUG%"=="ENABLED" EXIT /B
IF NOT DEFINED ERROR EXIT /B
ECHO.%COLOR4%ERROR:%$$% %ERROR%
CALL:PAUSED
EXIT /B
:PAD_LINE
IF NOT DEFINED PAD_TYPE SET "PAD_TYPE=1"
IF NOT DEFINED ACC_COLOR SET "ACC_COLOR=6"
IF NOT DEFINED BTN_COLOR SET "BTN_COLOR=7"
IF NOT DEFINED TXT_COLOR SET "TXT_COLOR=0"
IF NOT DEFINED PAD_SIZE SET "PAD_SIZE=LARGE"
IF NOT DEFINED PAD_SEQ SET "PAD_SEQ=0000000000"
IF "%PAD_TYPE%"=="0" SET "PADX= "&&ECHO.%$$%&&EXIT /B
IF "%PAD_TYPE%"=="1" SET "PADX=─"
IF "%PAD_TYPE%"=="2" SET "PADX=━"
IF "%PAD_TYPE%"=="3" SET "PADX=◌"
IF "%PAD_TYPE%"=="4" SET "PADX=○"
IF "%PAD_TYPE%"=="5" SET "PADX=●"
IF "%PAD_TYPE%"=="6" SET "PADX=❍"
IF "%PAD_TYPE%"=="7" SET "PADX=□"
IF "%PAD_TYPE%"=="8" SET "PADX=■"
IF "%PAD_TYPE%"=="9" SET "PADX=☰"
IF "%PAD_TYPE%"=="10" SET "PADX=☲"
IF "%PAD_TYPE%"=="11" SET "PADX=░"
IF "%PAD_TYPE%"=="12" SET "PADX=▒"
IF "%PAD_TYPE%"=="13" SET "PADX=▓"
IF "%PAD_TYPE%"=="14" SET "PADX=~"
IF "%PAD_TYPE%"=="15" SET "PADX=="
IF "%PAD_TYPE%"=="16" SET "PADX=#"
SET "PAD_SEQX=%PAD_SEQ%"&&IF NOT "%PAD_SEQ%X"=="%PAD_SEQX%X" SET "XNTX=0"&&SET "COLORX="&&FOR /F "DELIMS=" %%G IN ('%CMD% /D /U /C ECHO.%PAD_SEQ%^| FIND /V ""') do (CALL SET "COLORX=%%G"&&CALL:COLOR_ASSIGN&&CALL SET /A XNTX+=1)
IF "%PAD_SIZE%"=="LARGE" SET "PAD_BLK=%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%"
IF "%PAD_SIZE%"=="SMALL" SET "PAD_BLK=%#0%%PADX%%#1%%PADX%%#2%%PADX%%#3%%PADX%%#4%%PADX%%#5%%PADX%%#6%%PADX%%#7%%PADX%%#8%%PADX%%#9%%PADX%"
IF "%PAD_SIZE%"=="LARGE" ECHO.%#0%%PAD_BLK%%#1%%PAD_BLK%%#2%%PAD_BLK%%#3%%PAD_BLK%%#4%%PAD_BLK%%#5%%PAD_BLK%%#6%%PAD_BLK%%$$%
IF "%PAD_SIZE%"=="SMALL" ECHO.%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%$$%
SET "#Z=%$$%"&&SET "#0=%#1%"&SET "#1=%#2%"&SET "#2=%#3%"&SET "#3=%#4%"&SET "#4=%#5%"&SET "#5=%#6%"&SET "#6=%#7%"&SET "#7=%#8%"&SET "#8=%#9%"&SET "#9=%#0%"&&SET "PAD_BLK="&&SET "PADX="&&SET "COLORX=%$$%"
EXIT /B
:COLOR_ASSIGN
IF DEFINED XNTX CALL SET "#%XNTX%=%%COLOR%COLORX%%%"
EXIT /B
:PAD_WRITE
::ECHO.>>"TXT.TXT" 2>&1
EXIT /B
:BOX_DISP
IF "%PAD_BOX%"=="DISABLED" EXIT /B
IF "%$BOX%"=="RT" ECHO.%##%╭────────────────────────────────────────────────────────────────────╮%$$%
IF "%$BOX%"=="RB" ECHO.%##%╰────────────────────────────────────────────────────────────────────╯%$$%
IF "%$BOX%"=="ST" ECHO.%##%┌────────────────────────────────────────────────────────────────────┐%$$%
IF "%$BOX%"=="SB" ECHO.%##%└────────────────────────────────────────────────────────────────────┘%$$%
EXIT /B
:MENU_SELECT
IF DEFINED ERROR CALL:DEBUG&&SET "ERROR="
IF NOT DEFINED $CASE SET "$CASE=UPPER"
IF NOT DEFINED $CHECK SET "$CHECK=MENU"
IF NOT DEFINED $SELECT SET "$SELECT=SELECT"
SET "%$SELECT%="&&SET "SELECT_VAR="&&SET /P "SELECT_VAR=$>>"
IF NOT DEFINED SELECT_VAR SET "ERROR=MENU_SELECT"
IF NOT DEFINED ERROR SET "SELECT_VAR=%SELECT_VAR:"=%"
IF NOT DEFINED ERROR SET "SELECT_VAR=%SELECT_VAR:;=%"
IF NOT DEFINED ERROR SET "CHECK_VAR=%SELECT_VAR%"&&CALL:CHECK
IF NOT DEFINED ERROR IF /I "%$CASE%"=="ANY" SET "%$SELECT%=%SELECT_VAR%"
IF NOT DEFINED ERROR FOR %%■ in (UPPER LOWER) DO (IF /I "%%■"=="%$CASE%" SET "CAPS_SET=%$SELECT%"&&SET "CAPS_VAR=%SELECT_VAR%"&&CALL:CAPS_SET)
IF NOT DEFINED ERROR IF NOT DEFINED %$SELECT% SET "ERROR=MENU_SELECT"
IF DEFINED ERROR SET "%$SELECT%="&&IF DEFINED $VERBOSE FOR /F "TOKENS=*" %%■ in ("%SELECT_VAR% ") DO (ECHO.%COLOR4%ERROR:%$$% input [ %COLOR4%%%■%$$%] is invalid)
SET "SELECT_LAST=%SELECT_VAR%"
IF DEFINED $CHOICE SET "$CHOICE_LAST=%$CHOICE%"
ECHO.%$$%&&CALL SET "$CHOICE=%%$ITEM%SELECT_VAR%%%"
FOR %%a in ($CASE $SELECT SELECT_VAR) DO (SET "%%a=")
IF NOT DEFINED $PICKER EXIT /B
FOR %%a in ($PICKER $PICK $PATH $BODY $EXT) DO (SET "%%a=")
IF NOT DEFINED $CHOICE EXIT /B
IF NOT EXIST "%$FOLD%\%$CHOICE%" EXIT /B
IF EXIST "%$FOLD%\%$CHOICE%" SET "$PICK=%$FOLD%\%$CHOICE%"
IF NOT DEFINED ERROR FOR %%G in ("%$PICK%") DO (SET "$PATH=%%~dG%%~pG"&&SET "$BODY=%%~nG"&&SET "$EXT=%%~xG")
IF NOT DEFINED ERROR FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "$EXT=%%$EXT:%%G=%%G%%")
EXIT /B
:CAPS_SET
IF NOT DEFINED CAPS_VAR SET "%CAPS_SET%="&&SET "CAPS_SET="&&SET "CAPS_VAR="&&SET "$CASE="&&EXIT /B
IF NOT DEFINED $CASE SET "$CASE=UPPER"
IF /I "%$CASE%"=="LOWER" FOR %%G in (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO (CALL SET "CAPS_VAR=%%CAPS_VAR:%%G=%%G%%")
IF /I "%$CASE%"=="UPPER" FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "CAPS_VAR=%%CAPS_VAR:%%G=%%G%%")
IF "%CAPS_VAR%"=="=" SET "CAPS_VAR="
IF /I "%CAPS_VAR%"=="a=a" SET "CAPS_VAR="
CALL SET "%CAPS_SET%=%CAPS_VAR%"
SET "CAPS_SET="&&SET "CAPS_VAR="&&SET "$CASE="
EXIT /B
:CHECK
IF "%DEBUG%"=="ENABLED" ECHO.$CHECK[%$CHECK%]&&CALL:DEBUG
SET "$CHECK_LAST=%$CHECK%"&&FOR /F "TOKENS=1-3 DELIMS=❗-" %%a IN ("%$CHECK%") DO (SET "$CHECK=%%a"&&SET "TEXTMIN=%%b"&&SET "TEXTMAX=%%c")
IF NOT DEFINED CHECK_VAR SET "ERROR=CHECK"
IF /I "%$CHECK%"=="NONE" GOTO:TEXTMINMAXCHK
SET "NUMBERS=0 1 2 3 4 5 6 7 8 9"&&SET "LETTERS=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z"
IF /I "%$CHECK%"=="NUMBER" SET "NO_SPACE=1"&&SET "NO_ASTRK=1"&&SET "CHECK_FLT=%NUMBERS% ^""
IF /I "%$CHECK%"=="LETTER" SET "NO_SPACE=1"&&SET "NO_ASTRK=1"&&SET "CHECK_FLT=%LETTERS% ^""
IF /I "%$CHECK%"=="ALPHA" SET "NO_SPACE=1"&&SET "NO_ASTRK=1"&&SET "CHECK_FLT=%NUMBERS% %LETTERS% . - _ ^""
IF /I "%$CHECK%"=="PATH" SET "NO_ASTRK=1"&&SET "CHECK_FLT=%NUMBERS% %LETTERS% . - _ ^\ ^: ^""
IF /I "%$CHECK%"=="MENU" SET "NO_SPACE=1"&&SET "CHECK_FLT=%NUMBERS% %LETTERS% @ # $ . - _ + = ~ ^* ^""
IF /I "%$CHECK%"=="MOST" SET "CHECK_FLT=%NUMBERS% %LETTERS% @ # $ ^\ ^/ ^: ^( ^) ^[ ^] ^{ ^} ^. ^- ^_ ^+ ^= ^~ ^* ^%% ^""
IF NOT DEFINED ERROR SET "$XNT=-2"&&FOR /F "DELIMS=" %%■ in ('%CMD% /D /U /C ECHO."%CHECK_VAR%"^| FIND /V ""') do (SET "$GO="&&SET /A "$XNT+=1"&&FOR %%a in (%CHECK_FLT%) DO (
IF "[%%■]"=="[*]" IF NOT DEFINED NO_ASTRK SET "$GO=1"
IF "[%%■]"=="[ ]" IF NOT DEFINED NO_SPACE SET "$GO=1"
IF "[%%■]"=="[!]" SET "ERROR=CHECK"
IF "[%%a]"=="[%%■]" SET "$GO=1")
IF NOT DEFINED $GO SET "ERROR=CHECK")
:TEXTMINMAXCHK
IF NOT DEFINED ERROR IF DEFINED TEXTMIN CALL:TEXTMIN
IF NOT DEFINED ERROR IF DEFINED TEXTMAX CALL:TEXTMAX
:CHECK_END
SET "$CHECK=%$CHECK_LAST%"&&FOR %%a in ($CHECK_LAST CHECK_VAR CHECK_FLT TEXTMIN TEXTMAX NUMBERS LETTERS NO_SPACE NO_ASTRK) DO (SET "%%a=")
IF DEFINED ERROR IF "%DEBUG%"=="ENABLED" CALL:DEBUG
EXIT /B
:TEXTMIN
IF /I "%$CHECK%"=="NUMBER" SET /A "TEXTMIN=%TEXTMIN%"&&SET /A "CHECK_VAR=%CHECK_VAR%"
IF /I "%$CHECK%"=="NUMBER" IF %CHECK_VAR% LSS %TEXTMIN% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %CHECK_VAR% LSS %TEXTMIN%)
IF /I NOT "%$CHECK%"=="NUMBER" IF %$XNT% LSS %TEXTMIN% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %$XNT% LSS %TEXTMIN%)
EXIT /B
:TEXTMAX
IF /I "%$CHECK%"=="NUMBER" SET /A "TEXTMAX=%TEXTMAX%"&&SET /A "CHECK_VAR=%CHECK_VAR%"
IF /I "%$CHECK%"=="NUMBER" IF %CHECK_VAR% GTR %TEXTMAX% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %CHECK_VAR% GTR %TEXTMAX%)
IF /I NOT "%$CHECK%"=="NUMBER" IF %$XNT% GTR %TEXTMAX% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %$XNT% GTR %TEXTMAX%)
EXIT /B
:CHAR_CHK
FOR %%a in (CHAR_STR CHAR_CHK) DO (IF NOT DEFINED %%a EXIT /B)
SET "CHAR_FLG="&&FOR /F "DELIMS=" %%■ in ('%CMD% /D /U /C ECHO.%CHAR_STR%^| FIND /V ""') do (IF "%%■"=="%CHAR_CHK%" SET "CHAR_FLG=1"&&SET "ERROR=CHAR_CHK"&&CALL:DEBUG)
EXIT /B
:LOGO
IF "%RECOVERY_LOGO%"=="DISABLED" EXIT /B
IF NOT DEFINED RECOVERY_LOGO SET "RECOVERY_LOGO=DISABLED"
SET "ROW_X=%%@1%%█%%@2%%█%%@3%%█%%@4%%█%%@1%%█%%@2%%█%%@3%%█%%@4%%█"&&SET "ROW_T=%%@1%% %%@2%%▀%%@3%%█%%@4%%█%%@1%%█%%@2%%█%%@3%%▀%%@4%% "&&SET "ROW_B=%%@1%% %%@2%%▄%%@3%%█%%@4%%█%%@1%%█%%@2%%█%%@3%%▄%%@4%% "
SET "RND_SET=@1"&&CALL:GET_RANDOM&&SET "RND_SET=@2"&&CALL:GET_RANDOM&&SET "RND_SET=@3"&&CALL:GET_RANDOM&&SET "RND_SET=@4"&&CALL:GET_RANDOM
CALL SET "@1=%%COLOR%@1%%%"&&CALL SET "@2=%%COLOR%@2%%%"&&CALL SET "@3=%%COLOR%@3%%%"&&CALL SET "@4=%%COLOR%@4%%%"&&SET "LOGOX="&&SET "XNTZ="&&CALL:LOGO_X&&CLS&&FOR %%a in (@1 @2 @3 @4 @5 @6 @7 @8 @9 ROW_X ROW_T ROW_B) DO (SET "%%a=")
EXIT /B
:LOGO_X
CLS&&CALL ECHO.%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%&&SET "@1=%@2%"&SET "@2=%@3%"&SET "@3=%@4%"&SET "@4=%@1%"&&CALL ECHO.%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%&&ECHO.&&ECHO.                               %COLOR0%WELCOME TO&&ECHO.&&ECHO.       %@1% ▄█     █▄   ▄█ ███▄▄▄▄   ███████▄   ▄█  ▄███████  ▄█   ▄█▄&&ECHO.       %@2%███     ███ ███ ███▀▀▀██▄ ███  ▀███ ███ ███   ███ ███ ▄███▀&&ECHO.       %@3%███     ███ ███ ███   ███ ███   ███ ███ ███   █▀  ███▐██▀&&ECHO.       %@4%███     ███ ███ ███   ███ ███   ███ ███ ███      ▄█████▀&&ECHO.       %@1%███     ███ ███ ███   ███ ███   ███ ███ ███   █▄  ███▐██▄&&ECHO.       %@2%███ ▄█▄ ███ ███ ███   ███ ███  ▄███ ███ ███   ███ ███ ▀███▄&&ECHO.       %@3% ▀███▀███▀  █▀   ▀█   █▀  ███████▀  █▀  ███████▀  ███   ▀█▀&&ECHO.&&ECHO.                          %COLOR0%RECOVERY ENVIRONMENT&&ECHO.
CALL ECHO.%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%&&SET "@1=%@2%"&SET "@2=%@3%"&SET "@3=%@4%"&SET "@4=%@1%"
CALL ECHO.%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%$$% &&SET "@1=%@4%"&SET "@2=%@1%"&SET "@3=%@2%"&SET "@4=%@3%"
CALL:TIMER_POINT3&SET /A "XNTZ+=1"&IF NOT "%XNTZ%"=="7" GOTO:LOGO_X
EXIT /B
:SETS_LIST
SET SETS_LIST=GUI_LAUNCH GUI_RESUME GUI_SCALE GUI_CONFONT GUI_CONFONTSIZE GUI_CONTYPE GUI_FONTSIZE GUI_LVFONTSIZE GUI_TXT_FORE GUI_TXT_BACK GUI_BTN_COLOR GUI_HLT_COLOR GUI_BG_COLOR GUI_PAG_COLOR PAD_BOX PAD_TYPE PAD_SIZE PAD_SEQ TXT_COLOR ACC_COLOR BTN_COLOR COMPRESS SAFE_EXCLUDE HOST_HIDE PE_WALLPAPER BOOT_TIMEOUT VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5 ADDFILE_0 ADDFILE_1 ADDFILE_2 ADDFILE_3 ADDFILE_4 ADDFILE_5 ADDFILE_6 ADDFILE_7 ADDFILE_8 ADDFILE_9 HOTKEY_1 SHORT_1 HOTKEY_2 SHORT_2 HOTKEY_3 SHORT_3 MENU_MODE MENU_LIST REFERENCE RECOVERY_LOGO APPX_SKIP COMP_SKIP SVC_SKIP SXS_SKIP DEBUG
EXIT /B
:SETS_LOAD
IF EXIST "gploy.ini" FOR /F "TOKENS=1-1* DELIMS==" %%a in (gploy.ini) DO (IF NOT "%%a"=="   " SET "%%a=%%b")
EXIT /B
:SETS_CLEAR
CALL:SETS_LIST
FOR %%a in (%SETS_LIST%) DO (SET %%a=)
SET "SETS_LIST="&&EXIT /B
:SETS_HANDLER
IF NOT "%PROG_MODE%"=="RAMDISK" SET "ProgFolder=%ProgFolder0%"
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%ProgFolder%" SET "ProgFolder=%ProgFolder0%"
CD /D "%ProgFolder0%"&&IF "%PROG_MODE%"=="PORTABLE" IF NOT EXIST "gploy.ini" IF NOT DEFINED SETS_LOAD CALL:SETS_MAIN
IF EXIST "gploy.ini" IF NOT DEFINED SETS_LOAD SET "SETS_LOAD=1"&&CALL:SETS_LOAD
CALL:SETS_LIST&&ECHO.gploy v %VER_CUR% Settings>"gploy.ini"
FOR %%a in (%SETS_LIST%) DO (CALL ECHO.%%a=%%%%a%%>>"gploy.ini")
SET "SETS_LIST="&&IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="X:\$" SET "HOST_GET=1"
IF "%PROG_MODE%"=="RAMDISK" IF NOT "%DISK_TARGET%"=="%HOST_TARGET%" SET "HOST_GET=1"
IF DEFINED HOST_GET SET "HOST_GET="&&CALL:HOST_AUTO
IF "%PROG_MODE%"=="RAMDISK" IF EXIST "Z:\%HOST_FOLDERX%" COPY /Y "gploy.ini" "Z:\%HOST_FOLDERX%">NUL
:SETS_MAIN
IF NOT DEFINED PAD_TYPE SET "PAD_TYPE=1"
IF NOT DEFINED ACC_COLOR SET "ACC_COLOR=6"
IF NOT DEFINED BTN_COLOR SET "BTN_COLOR=7"
IF NOT DEFINED TXT_COLOR SET "TXT_COLOR=0"
IF NOT DEFINED VHDX_SIZE SET "VHDX_SIZE=25"
IF NOT DEFINED REFERENCE SET "REFERENCE=LIVE"
IF NOT DEFINED PAD_SIZE SET "PAD_SIZE=LARGE"
IF NOT DEFINED PAD_BOX SET "PAD_BOX=ENABLED"
IF NOT DEFINED PAD_SEQ SET "PAD_SEQ=0000000000"
IF NOT DEFINED HOST_FOLDER SET "HOST_FOLDER=$"
IF NOT DEFINED HOST_HIDE SET "HOST_HIDE=DISABLED"
IF NOT DEFINED SAFE_EXCLUDE SET "SAFE_EXCLUDE=ENABLED"
IF NOT DEFINED ADDFILE_0 SET "ADDFILE_0=list\tweaks.base"
IF NOT DEFINED HOTKEY_1 SET "HOTKEY_1=CMD"&&SET "SHORT_1=CMD.EXE"
IF NOT DEFINED HOTKEY_2 SET "HOTKEY_2=NOTE"&&SET "SHORT_2=NOTEPAD.EXE"
IF NOT DEFINED HOTKEY_3 SET "HOTKEY_3=REG"&&SET "SHORT_3=REGEDIT.EXE"
IF NOT DEFINED APPX_SKIP SET "APPX_SKIP=Microsoft.DesktopAppInstaller Microsoft.VCLibs.140.00"
IF NOT "%PROG_MODE%"=="RAMDISK" SET "ProgFolder=%ProgFolder0%"
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%ProgFolder%" SET "ProgFolder=%ProgFolder0%"
SET "FOLDER_MODE=UNIFIED"&&IF NOT "%COMPRESS%"=="FAST" IF NOT "%COMPRESS%"=="MAX" SET "COMPRESS=FAST"
IF EXIST "%ProgFolder%\CACHE" IF EXIST "%ProgFolder%\IMAGE" IF EXIST "%ProgFolder%\PACK" IF EXIST "%ProgFolder%\LIST" SET "FOLDER_MODE=ISOLATED"
IF "%FOLDER_MODE%"=="ISOLATED" FOR %%a in (Cache Image Pack List) DO (SET "%%aFolder=%ProgFolder%\%%a")
IF "%FOLDER_MODE%"=="UNIFIED" FOR %%a in (Cache Image Pack List) DO (SET "%%aFolder=%ProgFolder%")
IF DEFINED REFERENCE IF /I NOT "%REFERENCE%"=="DISABLED" IF NOT EXIST "%ImageFolder%\%REFERENCE%" SET "REFERENCE=LIVE"
FOR %%a in (MOUNT TARGET_PATH PATH_APPLY LIVE_APPLY VDISK_APPLY ERROR $NO_MOUNT $HALT $ONLY1 $ONLY2 $ONLY3 $VERBOSE $VHDX VDISK VDISK_LTR MENU_SESSION CUSTOM_SESSION MENU_SKIP DELETE_DONE FEAT_QRY DRVR_QRY SC_PREPARE RO_PREPARE) DO (SET "%%a=")
CHCP 65001>NUL&IF NOT DEFINED U00 SET "U00=❕"&&SET "U01=❗"&&SET "U02=🗂 "&&SET "U03=🛠️"&&SET "U04=💾"&&SET "U05=🗳 "&&SET "U06=🪟"&&SET "U07=🔄"&&SET "U08=🪛"&&SET "U09=🥾"&&SET "U10=✒ "&&SET "U11=🗃 "&&SET "U12=🎨"&&SET "U13=🧾"&&SET "U14=⏳"&&SET "U15=✅"&&SET "U16=❎"&&SET "U17=🚫"&&SET "U18=🗜 "&&SET "U19=🛡 "&&SET "U0L=◁"&&SET "U0R=▷"&&SET "U0P=％"&&SET "U0D=＄"&&SET "COLOR0=[97m"&&SET "COLOR1=[31m"&&SET "COLOR2=[91m"&&SET "COLOR3=[33m"&&SET "COLOR4=[93m"&&SET "COLOR5=[92m"&&SET "COLOR6=[96m"&&SET "COLOR7=[94m"&&SET "COLOR8=[34m"&&SET "COLOR9=[95m"
CALL SET "@@=%%COLOR%ACC_COLOR%%%"&&CALL SET "##=%%COLOR%BTN_COLOR%%%"&&CALL SET "$$=%%COLOR%TXT_COLOR%%%"
SET "COLORA=%@@%"&&SET "COLORB=%##%"&&SET "COLORT=%$$%"
FOR %%a in (COMMAND GUI) DO (IF "%PROG_MODE%"=="%%a" EXIT /B)
FOR %%a in (MENU_LIST) DO (SET "OBJ_FLD=%ListFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (PE_WALLPAPER) DO (SET "OBJ_FLD=%CacheFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (VHDX_SLOTX WIM_SOURCE VHDX_SOURCE) DO (SET "OBJ_FLD=%ImageFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (SET "ADDFILE_NUM=%%a"&&CALL SET "ADDFILE_CHK=%%ADDFILE_%%a%%"&&CALL:ADDFILE_CHK)
IF "%PROG_MODE%"=="RAMDISK" FOR %%a in (VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5) DO (SET "OBJ_FLD=%ProgFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (MENU_LIST PE_WALLPAPER PATH_SOURCE PATH_TARGET WIM_SOURCE VHDX_SOURCE WIM_TARGET VHDX_TARGET VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5) DO (IF NOT DEFINED %%a SET "%%a=SELECT")
IF NOT EXIST "%PATH_SOURCE%\" SET "PATH_SOURCE=SELECT"
IF NOT EXIST "%PATH_TARGET%\" SET "PATH_TARGET=SELECT"
FOR %%a in (ADDFILE_CHK ADDFILE_NUM OBJ_FLD OBJ_CHK OBJ_CHKX) DO (SET "%%a=")
EXIT /B
:ADDFILE_CHK
IF NOT DEFINED ADDFILE_%ADDFILE_NUM% SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%ADDFILE_CHK%"=="SELECT" EXIT /B
FOR /F "TOKENS=1-9 DELIMS=\" %%a in ("%ADDFILE_CHK%") DO (
IF "%%a"=="pack" IF NOT EXIST "%PackFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="list" IF NOT EXIST "%ListFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="image" IF NOT EXIST "%ImageFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="cache" IF NOT EXIST "%CacheFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="main" IF NOT EXIST "%ProgFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT")
EXIT /B
:OBJ_CLEAR
CALL SET "OBJ_CHKX=%%%OBJ_CHK%%%"
IF NOT EXIST "%OBJ_FLD%\%OBJ_CHKX%" CALL SET "%OBJ_CHK%=SELECT"
EXIT /B
:FOLDER_MODE
SET "$HEADERS= %U01% %U01% %U01%        The folder structure will be regenerated. If a file is %U01%    open or mounted and cannot be moved it's possible to lose data.%U01% %U01% %U01% %U01%                         Press (%##%X%$$%) to proceed"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" EXIT /B
IF "%FOLDER_MODE%"=="UNIFIED" SET "FOLDER_MODE=ISOLATED"&&GOTO:FOLDER_ISOLATED
IF "%FOLDER_MODE%"=="ISOLATED" SET "FOLDER_MODE=UNIFIED"&&GOTO:FOLDER_UNIFIED
:FOLDER_UNIFIED
FOR %%a in (CACHE IMAGE PACK LIST) DO (IF EXIST "%ProgFolder%\%%a" MOVE /Y "%ProgFolder%\%%a\*.*" "%ProgFolder%">NUL 2>&1)
FOR %%a in (CACHE IMAGE PACK LIST) DO (IF EXIST "%ProgFolder%\%%a" XCOPY /S /C /Y "%ProgFolder%\%%a" "%ProgFolder%">NUL 2>&1)
FOR %%a in (CACHE IMAGE PACK LIST) DO (IF EXIST "%ProgFolder%\%%a" RD /Q /S "\\?\%ProgFolder%\%%a">NUL 2>&1)
IF "%PROG_MODE%"=="GUI" ECHO.Restart app for changes to take effect.&&CALL:PAUSED
EXIT /B
:FOLDER_ISOLATED
FOR %%a in (cache image pack list) DO (IF NOT EXIST "%ProgFolder%\%%a" MD "%ProgFolder%\%%a">NUL 2>&1)
FOR %%a in (XML JPG PNG REG EFI SDI SAV) DO (IF EXIST "%ProgFolder%\*.%%a" MOVE /Y "%ProgFolder%\*.%%a" "%ProgFolder%\CACHE">NUL 2>&1)
FOR %%a in (LIST BASE) DO (IF EXIST "%ProgFolder%\*.%%a" MOVE /Y "%ProgFolder%\*.%%a" "%ProgFolder%\LIST">NUL 2>&1)
FOR %%a in (ISO VHDX WIM) DO (IF EXIST "%ProgFolder%\*.%%a" MOVE /Y "%ProgFolder%\*.%%a" "%ProgFolder%\IMAGE">NUL 2>&1)
FOR %%a in (PKX CAB MSU APPX APPXBUNDLE MSIXBUNDLE) DO (IF EXIST "%ProgFolder%\*.%%a" MOVE /Y "%ProgFolder%\*.%%a" "%ProgFolder%\PACK">NUL 2>&1)
IF "%PROG_MODE%"=="GUI" ECHO.Restart app for changes to take effect.&&CALL:PAUSED
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:FILE_VIEWER
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&CALL:BOX_HEADERS
SET "$FOLD=!$FOLD:◁=%%!"&&SET "$FOLD=!$FOLD:▷=%%!"
SET "$FILT=!$FILT:◁=%%!"&&SET "$FILT=!$FILT:▷=%%!"
FOR /F "TOKENS=*" %%a IN ("!$FOLD!") DO (CALL SET "$FOLD=%%a")
FOR /F "TOKENS=*" %%a IN ("!$FILT!") DO (CALL SET "$FILT=%%a")
ECHO.&&ECHO.  %@@%AVAILABLE %$FILT%s:%$$%&&ECHO.&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
IF NOT DEFINED $NO_ERRORS CALL:PAD_PREV
IF DEFINED $CHOICEMINO SET "$CHOICEMIN=0"
IF NOT DEFINED $CHOICEMINO SET "$CHOICEMIN=1"
IF DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$CHOICEMAXO%"
IF NOT DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$XNT%"
IF DEFINED $CHECKO SET "$CHECK=%$CHECKO%"
IF NOT DEFINED $CHECKO SET "$CHECK=NUMBER❗%$CHOICEMIN%-%$CHOICEMAX%"
CALL:MENU_SELECT
IF NOT DEFINED $CHOICE IF NOT DEFINED ERROR SET "$CHOICE=%SELECT%"
IF DEFINED $NO_ERRORS IF NOT DEFINED $CHOICE IF DEFINED $ITEM1 GOTO:FILE_VIEWER
FOR %%a in ($FOLD $FILT $CHOICEMINO $CHOICEMAXO $CHECKO $CENTERED $HEADERS $NO_ERRORS $VERBOSE) DO (SET "%%a=")
EXIT /B
:FILE_LIST
FOR %%a in ($FOLD $FILT) DO (IF NOT DEFINED %%a GOTO:FILE_LIST_SKIP)
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEM%%a SET "$ITEM%%a=")
IF NOT DEFINED $DISP SET "$DISP=NUM"
IF "%$DISP%"=="NUM" SET "$PICKER=1"
IF DEFINED $ITEMSTOP CALL:ITEMSTOP
IF EXIST "!$FOLD!" FOR /F "TOKENS=1-9 DELIMS= " %%a IN ("!$FILT!") DO (IF NOT "%%a"=="" SET "$FILTARG=%%a"&&CALL:FILTARG&&IF NOT "%%b"=="" SET "$FILTARG=%%b"&&CALL:FILTARG&&IF NOT "%%c"=="" SET "$FILTARG=%%c"&&CALL:FILTARG&&IF NOT "%%d"=="" SET "$FILTARG=%%d"&&CALL:FILTARG&&IF NOT "%%e"=="" SET "$FILTARG=%%e"&&CALL:FILTARG&&IF NOT "%%f"=="" SET "$FILTARG=%%f"&&CALL:FILTARG&&IF NOT "%%g"=="" SET "$FILTARG=%%g"&&CALL:FILTARG&&IF NOT "%%h"=="" SET "$FILTARG=%%h"&&CALL:FILTARG&&IF NOT "%%i"=="" SET "$FILTARG=%%i"&&CALL:FILTARG)
IF NOT DEFINED $ITEM1 ECHO.&&ECHO.   Empty.&&ECHO.
IF DEFINED $ITEMSBTM CALL:ITEMSBTM
:FILE_LIST_SKIP
FOR %%a in ($DISP $ITEMSTOP $ITEMSBTM $FILTARG) DO (SET "%%a=")
EXIT /B
:FILTARG
IF NOT EXIST "!$FOLD!\!$FILTARG!" EXIT /B
FOR /F "TOKENS=*" %%■ in ('DIR /A: /B /O:GN "!$FOLD!\!$FILTARG!"') DO (CALL SET /A "$XNT+=1"&&CALL SET "$VCLM$=%%■"&&CALL:FILE_LISTX)
EXIT /B
:FILE_LISTX
SET "$ITEM%$XNT%=!$VCLM$!"
IF EXIST "!$FOLD!\!$VCLM$!\*" (SET "$LCLR1=%@@%"&&SET "$LCLR2=%$$%") ELSE (SET "$LCLR1="&&SET "$LCLR2=")
IF "%$DISP%"=="NUM" FOR /F "TOKENS=*" %%● in ("!$VCLM$!") DO (ECHO. %$$%^( %##%%$XNT%%$$% ^) %$LCLR1%%%●%$LCLR2%)
IF "%$DISP%"=="BAS" FOR /F "TOKENS=*" %%● in ("!$VCLM$!") DO (ECHO.   %$LCLR1%%%●%$LCLR2%)
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:LIST_VIEWER
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
SET "INPUT=%$LIST_FILE%"&&CALL:GET_FILEEXT
IF /I NOT "%REFERENCE%"=="LIVE" IF /I NOT "%REFERENCE%"=="DISABLED" IF NOT DEFINED $VATTACH SET "LIVE_APPLY="&&SET "$VDISK_FILE=%ImageFolder%\%REFERENCE%"&&SET "VDISK_LTR=ANY"&&ECHO.Loading reference image...&&CALL:VDISK_ATTACH
IF /I NOT "%REFERENCE%"=="LIVE" IF /I NOT "%REFERENCE%"=="DISABLED" IF NOT DEFINED $VATTACH IF EXIST "%VDISK_LTR%:\" SET "TARGET_PATH=%VDISK_LTR%:"&&SET "$VATTACH=1"&&CALL:MOUNT_EXT
IF /I "%REFERENCE%"=="LIVE" SET "TARGET_PATH=%SYSTEMDRIVE%"&&SET "LIVE_APPLY=1"&&CALL:MOUNT_INT
IF DEFINED BASE_EXEC (SET "$LIST_MODE=Execute") else (SET "$LIST_MODE=Builder")
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&SET "$CENTERED=1"&&SET "$HEADERS=%U13% List %$LIST_MODE%%U01% %U01%  !$FILE_X!%$EXT_X%%U01% %U01%"&&CALL:BOX_HEADERS&SET "$LIST_SCOPE=GROUP"&&CALL:LIST_FILE
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&IF NOT DEFINED ERROR CALL:PAD_PREV
IF DEFINED ERROR SET "TIMER=1"&&CALL:TIMER&&GOTO:LIST_VIEWER_END
SET "$VERBOSE=1"&&SET "$CHECK=NUMBER❗1-%$XNT%"&&CALL:MENU_SELECT
IF NOT DEFINED ERROR FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 IN ("!$CHOICE!") DO (SET "$ONLY2=%%2")
IF DEFINED ERROR SET "$ONLY1="&&GOTO:LIST_VIEWER_END
:SUBGROUP_BOX
SET "INPUT=%$LIST_FILE%"&&CALL:GET_FILEEXT&&CALL:SESSION_CLEAR
IF DEFINED BASE_EXEC (SET "$LIST_MODE=Execute") else (SET "$LIST_MODE=Builder")
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&SET "$CENTERED=1"&&SET "$HEADERS=%U13% !$FILE_X!%$EXT_X%%U01% %U01%!$ONLY2!%U01% %U01%"&&CALL:BOX_HEADERS&&SET "$LIST_SCOPE=SUBGROUP"&&CALL:LIST_FILE
ECHO.&&ECHO.                        Multiples OK ( %##%1 2 3%$$% )
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV
SET "$VERBOSE=1"&&SET "LIST_START="&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF NOT DEFINED ERROR FOR %%a in (%SELECT%) DO (CALL SET "FULL_TARGET=%%$ITEM%%a%%"&&CALL:UNIFIED_PARSE_BUILDER)
IF NOT DEFINED LIST_START IF DEFINED SELECT SET "ERROR=1"&&FOR /F "TOKENS=*" %%■ in ("%SELECT_LAST% ") DO (ECHO.%COLOR4%ERROR:%$$% input [ %COLOR4%%%■%$$%] is invalid)
IF DEFINED ERROR SET "ERROR="&&SET "$ONLY2="&&GOTO:LIST_VIEWER
:LIST_VIEWER_APPEND
IF DEFINED BASE_EXEC SET "$LIST_FILE=%ListFolder%\$LIST"&&GOTO:LIST_VIEWER_END
SET "$CENTERED="&&SET "$HEADERS=                            %U04% Append Items%U01% %U01%                             Select a list"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) Create new list"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" CALL:LIST_MAKE
IF "%SELECT%"=="0" IF NOT DEFINED ERROR MOVE /Y "$LIST" "%$PICK%">NUL&GOTO:LIST_VIEWER_END
IF DEFINED ERROR SET "ERROR="&&SET "$ONLY3="&&GOTO:SUBGROUP_BOX
SET "$LIST_FILE=%$PICK%"&&CALL:LIST_COMBINE&&CALL:APPEND_SCREEN
:LIST_VIEWER_END
FOR %%▓ in (LIVE_APPLY BASE_EXEC GROUP_TYPE $ONLY1 $ONLY2 $ONLY3 $CENTERED $HEADERS $NO_ERRORS $VERBOSE) DO (SET "%%▓=")
IF /I NOT "%REFERENCE%"=="LIVE" IF /I NOT "%REFERENCE%"=="DISABLED" IF DEFINED $VATTACH ECHO.Unloading reference image...&&SET "$VDISK_FILE=%ImageFolder%\%REFERENCE%"&CALL:MOUNT_INT&CALL:VDISK_DETACH
SET "$VATTACH="&&EXIT /B
:UNIFIED_PARSE_BUILDER
IF NOT DEFINED FULL_TARGET EXIT /B
SET "FULL_TARGETQ=%FULL_TARGET:"=%"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 in ("%FULL_TARGETQ%") DO (
SET "GROUP_TARGET=%%2"&&SET "SUB_TARGET=%%3"&&SET "GROUP_TYPE=%%4"&&SET "GROUP_MSG=%%5"&&SET "GROUP_CHOICES=%%6"&&SET "GROUP_CHOICE=%%7"
IF NOT "%%1"=="" SET "COLUMN_XNT=1"&&IF NOT "%%2"=="" SET "COLUMN_XNT=2"&&IF NOT "%%3"=="" SET "COLUMN_XNT=3"&&IF NOT "%%4"=="" SET "COLUMN_XNT=4"&&IF NOT "%%5"=="" SET "COLUMN_XNT=5"&&IF NOT "%%6"=="" SET "COLUMN_XNT=6"&&IF NOT "%%7"=="" SET "COLUMN_XNT=7")
FOR /F "TOKENS=*" %%░ IN ("%GROUP_TYPE%") DO (IF /I NOT "%%░"=="NORMAL" IF /I NOT "%%░"=="DRAWER" IF /I NOT "%%░"=="SCOPED" SET "GROUP_TYPE=NORMAL")
IF /I "%GROUP_TYPE%"=="NORMAL" CALL:NORMAL_LIST
IF /I "%GROUP_TYPE%"=="DRAWER" CALL:DRAWER_BOX
IF /I "%GROUP_TYPE%"=="SCOPED" CALL:DRAWER_BOX
EXIT /B
:LIST_FILE
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEM%%a SET "$ITEM%%a=")
IF NOT EXIST "%$LIST_FILE%" GOTO:LIST_FILE_SKIP
SET "$HEAD_CHECK=%$LIST_FILE%"&&CALL:GET_HEADER
IF DEFINED ERROR GOTO:LIST_FILE_SKIP
IF DEFINED $ITEMSTOP CALL:ITEMSTOP
COPY /Y "%$LIST_FILE%" "$TEMP">NUL 2>&1
SET "$VCLM2_LAST="&&SET "$SUBGROUP_LAST="&&SET "$LIST_FILEX="&&SET "$LIST_FILEZ="&&IF EXIST "$TEMP" FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%1 in ($TEMP) DO (
IF "%$LIST_SCOPE%"=="GROUP" IF /I "%%1"=="GROUP" SET "$LIST_FILEX=1"&&SET "$LIST_FILEZ="
IF "%$LIST_SCOPE%"=="SUBGROUP" IF /I "%%1"=="GROUP" IF NOT "%%2"=="%$ONLY2%" SET "$LIST_FILEZ="
IF "%$LIST_SCOPE%"=="SUBGROUP" IF /I "%%1"=="GROUP" IF "%%2"=="%$ONLY2%" SET "$LIST_FILEX=1"&&IF /I NOT "%REFERENCE%"=="DISABLED" SET "$LIST_FILEZ=1"
IF DEFINED $LIST_FILEZ IF NOT "%%1"=="" FOR /F "TOKENS=* DELIMS=ⓡ" %%░ IN ("%%1") DO (IF NOT "%%1"=="%%░" SET "$VCLMX=%%░"&&CALL:LIST_FILEX_SKIP)
IF DEFINED $LIST_FILEX SET "$LIST_FILEX="&&SET "$VCLM1=%%1"&&SET "$VCLM2=%%2"&&SET "$VCLM3=%%3"&&SET "$VCLM4=%%4"&&SET "$VCLM5=%%5"&&SET "$VCLM6=%%6"&&SET "$VCLM7=%%7"&&SET "$VCLM8=%%8"&&SET "$VCLM9=%%9"&&CALL:LIST_FILEX)
IF "%$LIST_SCOPE%"=="SUBGROUP" IF DEFINED $SUBGROUP_LAST SET "$SUBGROUP_LAST=!$SUBGROUP_LAST:◁=%%!"&&SET "$SUBGROUP_LAST=!$SUBGROUP_LAST:▷=%%!"&&CALL SET "$SUBGROUP_LAST=!$SUBGROUP_LAST!"&&FOR /F "TOKENS=*" %%░ IN ("!$SUBGROUP_LAST!") DO (ECHO. %%░%$$%)
IF NOT DEFINED $ITEM1 ECHO.&&ECHO.   Empty.&&ECHO.
IF DEFINED $ITEMSBTM CALL:ITEMSBTM
:LIST_FILE_SKIP
FOR %%a in ($VCLM1 $VCLM2 $VCLM3 $VCLM4 $VCLM5 $VCLM6 $VCLM7 $VCLM2_LAST $ITEMSTOP $ITEMSBTM) DO (SET "%%a=")
EXIT /B
:LIST_FILEX_SKIP
SET "COLUMN0="&&FOR %%░ IN (X) DO (
IF NOT "%%1"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%"
IF NOT "%%2"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%"
IF NOT "%%3"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%"
IF NOT "%%4"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%"
IF NOT "%%5"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%"
IF NOT "%%6"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%"
IF NOT "%%7"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%"
IF NOT "%%8"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%%%8%U00%"
IF NOT "%%9"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%%%8%U00%%%9%U00%"
IF DEFINED COLUMN0 CALL:UNIFIED_PARSE_EXECUTE)
SET "$VCLMX="&&EXIT /B
:LIST_FILEX
IF DEFINED $VCLM2 SET "$VCLM2=!$VCLM2:"=!"
IF DEFINED $VCLM3 SET "$VCLM3=!$VCLM3:"=!"
IF "%$LIST_SCOPE%"=="GROUP" IF DEFINED $VCLM2 FOR /F "TOKENS=*" %%░ IN ("!$VCLM2!") DO (IF "%%░"=="!$VCLM2_LAST!" EXIT /B
SET "$VCLM2_LAST=%%░")
SET /A "$XNT+=1"
IF "%$LIST_SCOPE%"=="GROUP" IF DEFINED $VCLM2 FOR /F "TOKENS=*" %%░ IN ("!$VCLM2!") DO (ECHO. %$$%^( %##%%$XNT%%$$% ^) %%░%$$%)
IF "%$LIST_SCOPE%"=="SUBGROUP" IF DEFINED $SUBGROUP_LAST SET "$SUBGROUP_LAST=!$SUBGROUP_LAST:◁=%%!"&&SET "$SUBGROUP_LAST=!$SUBGROUP_LAST:▷=%%!"&&CALL SET "$SUBGROUP_LAST=!$SUBGROUP_LAST!"&&FOR /F "TOKENS=*" %%░ IN ("!$SUBGROUP_LAST!") DO (ECHO. %%░%$$%)
IF "%$LIST_SCOPE%"=="SUBGROUP" IF DEFINED $VCLM3 FOR /F "TOKENS=*" %%░ IN ("!$VCLM3!") DO (SET "$SUBGROUP_LAST=%$$%( %##%%$XNT%%$$% ) %%░%$$%")
FOR %%░ IN (X) DO (
IF NOT "%%1"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%"
IF NOT "%%2"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%"
IF NOT "%%3"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%"
IF NOT "%%4"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%"
IF NOT "%%5"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%"
IF NOT "%%6"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%"
IF NOT "%%7"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%"
IF NOT "%%8"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%%%8%U00%"
IF NOT "%%9"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%%%8%U00%%%9%U00%"
IF "%%1"=="" SET "$ITEM%$XNT%=")
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:NORMAL_LIST
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
FOR %%▓ in (FULL_TARGET $LIST_FILE) DO (IF NOT DEFINED %%▓ EXIT /B)
IF NOT EXIST "%$LIST_FILE%" EXIT /B
SET "NORMAL_LISTX="&&SET "WRITEZ="&&SET "$XNT="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%a in ($TEMP) DO (
IF /I "%%a"=="GROUP" IF "%%b"=="!GROUP_TARGET!" IF "%%c"=="!SUB_TARGET!" SET "NORMAL_LISTX=1"&&SET "WRITEZ=1"
IF /I "%%a"=="GROUP" IF NOT "%%b"=="!GROUP_TARGET!" SET "NORMAL_LISTX="
IF /I "%%a"=="GROUP" IF NOT "%%c"=="!SUB_TARGET!" SET "NORMAL_LISTX="
IF DEFINED NORMAL_LISTX IF NOT "%%a"=="" FOR /F "TOKENS=* DELIMS=ⓡ" %%░ IN ("%%a") DO (IF NOT "%%a"=="%%░" SET "$VCLMX=%%░"&&CALL:NORMAL_LIST_SKIP)
IF NOT "%%a"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%"
IF NOT "%%b"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%"
IF NOT "%%c"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%"
IF NOT "%%d"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%"
IF NOT "%%e"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"
IF NOT "%%f"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%"
IF NOT "%%g"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%"
IF NOT "%%h"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%"
IF NOT "%%i"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%%%i%U00%"
IF "%%a"=="" SET "$NORMAL_ITEM="
IF DEFINED NORMAL_LISTX SET "$VCLM1=%%a"&&SET "$VCLM2=%%b"&&SET "$VCLM3=%%c"&&SET "$VCLM4=%%d"&&SET "$VCLM5=%%e"&&SET "$VCLM6=%%f"&&SET "$VCLM7=%%g"&&CALL:NORMAL_LISTX)
EXIT /B
:NORMAL_LIST_SKIP
SET "COLUMN0="&&FOR %%░ IN (X) DO (
IF NOT "%%a"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%"
IF NOT "%%b"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%"
IF NOT "%%c"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%"
IF NOT "%%d"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%"
IF NOT "%%e"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"
IF NOT "%%f"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%"
IF NOT "%%g"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%"
IF NOT "%%h"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%"
IF NOT "%%i"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%%%i%U00%"
IF DEFINED COLUMN0 CALL:UNIFIED_PARSE_EXECUTE)
SET "$VCLMX="&&EXIT /B
:NORMAL_LISTX
SET "$VCLM1=!$VCLM1:"=!"
SET "@QUIET="&&FOR /F "TOKENS=* DELIMS=ⓠ" %%● IN ("!$VCLM1!") DO (IF NOT "%%●"=="!$VCLM1!" SET "$VCLM1=%%●"&&SET "@QUIET=1")
IF NOT DEFINED LIST_START SET "LIST_START=1"&&(ECHO.MENU-SCRIPT)>"$LIST"
IF DEFINED WRITEZ SET "WRITEZ="&&ECHO.>>"$LIST"
FOR %%@ in (PROMPT CHOICE PICKER) DO (FOR %%▓ in (0 1 2 3 4 5 6 7 8 9) DO (IF /I "!$VCLM1!"=="%%@%%▓" CALL:NORMAL_LIST_%%@))
ECHO.!$NORMAL_ITEM!>>"$LIST"
EXIT /B
:NORMAL_LIST_CHOICE
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a in ("!$VCLM3!") DO (
IF NOT "%%a"=="" SET "$CHOICE_LIST=%U01%%%a%U01%"
IF NOT "%%b"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%"
IF NOT "%%c"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%"
IF NOT "%%d"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%"
IF NOT "%%e"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%"
IF NOT "%%f"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%%%f%U01%"
IF NOT "%%g"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%%%f%U01%%%g%U01%"
IF NOT "%%h"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%%%f%U01%%%g%U01%%%h%U01%"
IF NOT "%%i"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%%%f%U01%%%g%U01%%%h%U01%%%i%U01%"
IF "%%a"=="" SET "$CHOICE_LIST=")
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01%!$VCLM2!"
SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:CHOICE_BOX
IF DEFINED @QUIET FOR /F "TOKENS=*" %%● IN ("!$VCLM1!") DO (SET "$VCLM1=ⓠ%%●")
SET "$NORMAL_ITEM=%U00%!$VCLM1!%U00%!$VCLM2!%U00%!$VCLM3!%U00%!SELECT!%U00%"
EXIT /B
:NORMAL_LIST_PICKER
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01%!$VCLM2!"
SET "$FOLD="&&SET "$FILT="&&FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$VCLM3!") DO (SET "$FOLD=%%a"&&SET "$FILT=%%b")
IF NOT DEFINED $FILT SET "$FILT=*.*"
IF NOT DEFINED $FOLD SET "$FOLD=%ProgFolder%"
SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:FILE_VIEWER
IF DEFINED @QUIET FOR /F "TOKENS=*" %%● IN ("!$VCLM1!") DO (SET "$VCLM1=ⓠ%%●")
SET "$NORMAL_ITEM=%U00%!$VCLM1!%U00%!$VCLM2!%U00%!$VCLM3!%U00%!$CHOICE!%U00%"
EXIT /B
:NORMAL_LIST_PROMPT
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01% %U01% %U01%!$VCLM2!%U01% %U01% "
SET "$CHECK=!$VCLM3!"&&SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:PROMPT_BOX
IF DEFINED @QUIET FOR /F "TOKENS=*" %%● IN ("!$VCLM1!") DO (SET "$VCLM1=ⓠ%%●")
SET "$NORMAL_ITEM=%U00%!$VCLM1!%U00%!$VCLM2!%U00%!$VCLM3!%U00%!SELECT!%U00%"
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:DRAWER_BOX
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
IF NOT DEFINED FULL_TARGET EXIT /B
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&SET "$CENTERED=1"&&SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01%"&&CALL:BOX_HEADERS&&CALL:DRAWER_LIST
IF NOT DEFINED $ITEMD1 ECHO.   Empty.
ECHO.&&ECHO.                        Multiples OK ( %##%1 2 3%$$% )&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
SET "LIST_STARTZ="&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF DEFINED SELECT FOR %%a in (%SELECT%) DO (CALL SET "$DRAWER_ITEM=%%$ITEMD%%a%%"&&CALL:DRAWER_WRITE)
IF NOT DEFINED LIST_STARTZ IF DEFINED SELECT FOR /F "TOKENS=*" %%■ in ("%SELECT_LAST% ") DO (ECHO.%COLOR4%ERROR:%$$% input [ %COLOR4%%%■%$$%] is invalid)
IF NOT DEFINED $ITEMD1 SET "ERROR="&&SET "$CENTERED="&&EXIT /B
IF NOT DEFINED LIST_STARTZ SET "ERROR="&&GOTO:DRAWER_BOX
SET "$CENTERED="&&EXIT /B
:DRAWER_LIST
FOR %%▓ in (FULL_TARGET $LIST_FILE) DO (IF NOT DEFINED %%▓ EXIT /B)
IF NOT EXIST "%$LIST_FILE%" EXIT /B
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEMD%%a SET "$ITEMD%%a=")
SET "DRAWER_LISTX="&&SET "WRITEZ="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%a in ($TEMP) DO (
IF /I "%%a"=="GROUP" IF "%%b"=="!GROUP_TARGET!" IF "%%c"=="!SUB_TARGET!" SET "DRAWER_LISTX=1"
IF /I "%%a"=="GROUP" IF NOT "%%b"=="!GROUP_TARGET!" SET "DRAWER_LISTX="
IF /I "%%a"=="GROUP" IF NOT "%%c"=="!SUB_TARGET!" SET "DRAWER_LISTX="
IF NOT "%%a"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%"
IF NOT "%%b"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%"
IF NOT "%%c"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%"
IF NOT "%%d"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%"
IF NOT "%%e"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"
IF NOT "%%f"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%"
IF NOT "%%g"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%"
IF NOT "%%h"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%"
IF NOT "%%i"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%%%i%U00%"
IF "%%a"=="" SET "$DRAWER_ITEM="
IF DEFINED DRAWER_LISTX IF DEFINED $DRAWER_ITEM CALL:DRAWER_LISTX)
EXIT /B
:DRAWER_LISTX
IF NOT DEFINED $XNT SET "$XNT=0"&&EXIT /B
SET /A "$XNT+=1"
IF /I "!GROUP_TYPE!"=="DRAWER" FOR /F "TOKENS=*" %%□ IN ("!$DRAWER_ITEM!") DO (SET "$ITEMD%$XNT%=%%□"&&ECHO. %$$%^( %##%%$XNT%%$$% ^) %%□%$$%)
IF /I "!GROUP_TYPE!"=="SCOPED" FOR /F "TOKENS=*" %%□ IN ("!$DRAWER_ITEM!") DO (SET "$ITEMD%$XNT%=%%□"&&ECHO. %$$%^( %##%%$XNT%%$$% ^) %%b%$$%)
EXIT /B
:DRAWER_WRITE
IF NOT DEFINED LIST_START SET "LIST_START=1"&&(ECHO.MENU-SCRIPT)>"$LIST"
IF DEFINED GROUP_CHOICES CALL:DRAWER_WRITE_CHOICE&&ECHO.>>"$LIST"
IF DEFINED GROUP_CHOICES SET "GROUP_CHOICES="&&FOR /F "TOKENS=*" %%▓ in ("!GROUP_ITEM!") DO (ECHO.%%▓>>"$LIST")
FOR /F "TOKENS=*" %%▓ in ("!$DRAWER_ITEM!") DO (SET "$DRAWER_ITEM="&&ECHO.%%▓>>"$LIST")
SET "LIST_STARTZ=1"&&EXIT /B
:DRAWER_WRITE_CHOICE
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="&&SET "GROUP_ITEM="
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 IN ("!$DRAWER_ITEM!") DO (SET "$ARBIT=%%2")
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01%  !GROUP_MSG!"
SET "$CHOICE_LIST=!GROUP_CHOICES!"&&SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:CHOICE_BOX
FOR /F "TOKENS=1-9 DELIMS=❕" %%a in ("!FULL_TARGET!") DO (SET "GROUP_ITEM=❕%%a❕%%b❕%%c❕%%d❕%%e❕%%f❕!SELECT!❕")
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:PROMPT_BOX
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&CALL:BOX_HEADERS&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
IF NOT DEFINED $NO_ERRORS CALL:PAD_PREV
IF NOT DEFINED $CASE SET "$CASE=ANY"
CALL:MENU_SELECT
IF DEFINED $NO_ERRORS IF DEFINED ERROR GOTO:PROMPT_BOX
FOR %%a in ($NO_ERRORS $HEADERS $CENTERED) DO (SET "%%a=")
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:CHOICE_BOX
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&CALL:BOX_HEADERS&&ECHO.
CALL:CHOICE_LIST
IF NOT DEFINED $ITEMC1 ECHO.   Empty.
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&IF NOT DEFINED $NO_ERRORS CALL:PAD_PREV
IF DEFINED $CHOICEMINO SET "$CHOICEMIN=0"
IF NOT DEFINED $CHOICEMINO SET "$CHOICEMIN=1"
IF DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$CHOICEMAXO%"
IF NOT DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$XNT%"
IF DEFINED $CHECKO SET "$CHECK=%$CHECKO%"
IF NOT DEFINED $CHECKO SET "$CHECK=NUMBER❗%$CHOICEMIN%-%$CHOICEMAX%"
SET "$VERBOSE=1"&&CALL:MENU_SELECT
IF DEFINED $NO_ERRORS IF NOT DEFINED $ITEMC1 SET "ERROR="
IF DEFINED $NO_ERRORS IF DEFINED ERROR IF DEFINED $ITEMC1 GOTO:CHOICE_BOX
FOR %%a in ($NO_ERRORS $CHOICE_LIST $ITEMSTOP $ITEMSBTM $CHOICEMINO $CHOICEMAXO $CHECKO $HEADERS $CENTERED) DO (SET "%%a=")
EXIT /B
:CHOICE_LIST
FOR %%a in ($CHOICE_LIST) DO (IF NOT DEFINED %%a GOTO:CHOICE_LIST_SKIP)
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEMC%%a SET "$ITEMC%%a=")
IF DEFINED $ITEMSTOP CALL:ITEMSTOP
SET "$CHOICE_LIST=!$CHOICE_LIST:◁=%%!"&&SET "$CHOICE_LIST=!$CHOICE_LIST:▷=%%!"
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$CHOICE_LIST!") DO (
IF "%%e"=="" ECHO.&&IF "%%c"=="" ECHO.&&IF "%%a"=="" ECHO.
IF NOT "%%a"=="" SET "$VCLM$=%%a"&&CALL:CHOICE_LISTX&&IF NOT "%%b"=="" SET "$VCLM$=%%b"&&CALL:CHOICE_LISTX&&IF NOT "%%c"=="" SET "$VCLM$=%%c"&&CALL:CHOICE_LISTX&&IF NOT "%%d"=="" SET "$VCLM$=%%d"&&CALL:CHOICE_LISTX&&IF NOT "%%e"=="" SET "$VCLM$=%%e"&&CALL:CHOICE_LISTX&&IF NOT "%%f"=="" SET "$VCLM$=%%f"&&CALL:CHOICE_LISTX&&IF NOT "%%g"=="" SET "$VCLM$=%%g"&&CALL:CHOICE_LISTX&&IF NOT "%%h"=="" SET "$VCLM$=%%h"&&CALL:CHOICE_LISTX&&IF NOT "%%i"=="" SET "$VCLM$=%%i"&&CALL:CHOICE_LISTX
IF "%%f"=="" ECHO.&&IF "%%d"=="" ECHO.&&IF "%%b"=="" ECHO.)
IF NOT DEFINED $ITEMC1 ECHO.&&ECHO.   Empty.&&ECHO.
IF DEFINED $ITEMSBTM CALL:ITEMSBTM
:CHOICE_LIST_SKIP
FOR %%a in (XXX) DO (SET "%%a=")
EXIT /B
:CHOICE_LISTX
CALL SET /A "$XNT+=1"
CALL SET "$ITEMC%$XNT%=!$VCLM$!"
FOR /F "TOKENS=*" %%# in ("!$VCLM$!") DO (ECHO. %$$%^( %##%%$XNT%%$$% ^) %%#)
EXIT /B
:ITEMSTOP
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$ITEMSTOP!") DO (IF NOT "%%a"=="" ECHO.%%a&&IF NOT "%%b"=="" ECHO.%%b&&IF NOT "%%c"=="" ECHO.%%c&&IF NOT "%%d"=="" ECHO.%%d&&IF NOT "%%e"=="" ECHO.%%e&&IF NOT "%%f"=="" ECHO.%%f&&IF NOT "%%g"=="" ECHO.%%g&&IF NOT "%%h"=="" ECHO.%%h&&IF NOT "%%i"=="" ECHO.%%i)
EXIT /B
:ITEMSBTM
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$ITEMSBTM!") DO (IF NOT "%%a"=="" ECHO.%%a&&IF NOT "%%b"=="" ECHO.%%b&&IF NOT "%%c"=="" ECHO.%%c&&IF NOT "%%d"=="" ECHO.%%d&&IF NOT "%%e"=="" ECHO.%%e&&IF NOT "%%f"=="" ECHO.%%f&&IF NOT "%%g"=="" ECHO.%%g&&IF NOT "%%h"=="" ECHO.%%h&&IF NOT "%%i"=="" ECHO.%%i)
EXIT /B
:BOX_HEADERS
IF NOT DEFINED $HEADERS EXIT /B
SET "$HEADERS_LAST=!$HEADERS!"&&SET "$HEADERSX=!$HEADERS:◁=%%!"&&SET "$HEADERSX=!$HEADERSX:▷=%%!"
IF NOT "!$HEADERSX!"=="!$HEADERS!" CALL SET "$HEADERS=!$HEADERSX!"
IF NOT DEFINED $CENTERED FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$HEADERS!") DO (IF NOT "%%a"=="" ECHO.%%a&&IF NOT "%%b"=="" ECHO.%%b&&IF NOT "%%c"=="" ECHO.%%c&&IF NOT "%%d"=="" ECHO.%%d&&IF NOT "%%e"=="" ECHO.%%e&&IF NOT "%%f"=="" ECHO.%%f&&IF NOT "%%g"=="" ECHO.%%g&&IF NOT "%%h"=="" ECHO.%%h&&IF NOT "%%i"=="" ECHO.%%i)
IF DEFINED $CENTERED FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$HEADERS!") DO (IF NOT "%%a"=="" SET "$CENTERED_MSG=%%a"&&CALL:TXT_CENTER&&IF NOT "%%b"=="" SET "$CENTERED_MSG=%%b"&&CALL:TXT_CENTER&&IF NOT "%%c"=="" SET "$CENTERED_MSG=%%c"&&CALL:TXT_CENTER&&IF NOT "%%d"=="" SET "$CENTERED_MSG=%%d"&&CALL:TXT_CENTER&&IF NOT "%%e"=="" SET "$CENTERED_MSG=%%e"&&CALL:TXT_CENTER&&IF NOT "%%f"=="" SET "$CENTERED_MSG=%%f"&&CALL:TXT_CENTER&&IF NOT "%%g"=="" SET "$CENTERED_MSG=%%g"&&CALL:TXT_CENTER&&IF NOT "%%h"=="" SET "$CENTERED_MSG=%%h"&&CALL:TXT_CENTER&&IF NOT "%%i"=="" SET "$CENTERED_MSG=%%i"&&CALL:TXT_CENTER)
SET "$HEADERS=!$HEADERS_LAST!"
EXIT /B
:TXT_CENTER
IF "!$CENTERED_MSG!"==" " ECHO.&&SET "$CENTERED_MSG="&&SET "$QUIET="&&EXIT /B
SET "$XNT="&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO."!$CENTERED_MSG!"^| FIND /V ""') do (SET /A "$XNT+=1")
SET "$TSPACE=35"&&SET /A "$XNT/=2"
SET /A "$TSPACE-=%$XNT%"&&SET "$SPACE_BUF="&&SET "$XNT="&&FOR %%1 in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35) DO (SET "$XNT=%%1"&&CALL:CENTER_TITLE)
FOR /F "TOKENS=* DELIMS=" %%a in ("%$SPACE_BUF%!$CENTERED_MSG!") DO (SET "TXT_CENTER=%%a"&&IF NOT DEFINED $QUIET ECHO.%%a)
FOR %%a in ($CENTERED_MSG $SPACE_BUF $TSPACE $QUIET) DO (SET "%%a=")
EXIT /B
:CENTER_TITLE
IF NOT DEFINED $TSPACE EXIT /B
SET "$SPACE_BUF= %$SPACE_BUF%"&&IF "%$XNT%"=="%$TSPACE%" SET "$TSPACE="
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:SETTINGS_MENU
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:SETS_HANDLER&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                              %U03% Settings&&ECHO.&&ECHO.
ECHO. (%##% 1 %$$%) %U12% Appearance&&ECHO. (%##% 2 %$$%) %U15% Shortcuts&&ECHO. (%##% 3 %$$%) %U02% Folder Layout        %@@%%FOLDER_MODE%%$$%
IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% 4 %$$%) %U19% Host Hide            %@@%%HOST_HIDE%%$$%&&ECHO. (%##% 5 %$$%) %U07% Update
ECHO. (%##% . %$$%) %U17% Clear Settings
IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% * %$$%) %U01% %COLOR2%Enable Custom Menu%$$%
ECHO.&&ECHO.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT IF DEFINED MENU_EXIT GOTO:QUIT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="." CALL:SETS_CLEAR&SET "SELECT="&IF "%PROG_MODE%"=="GUI" ECHO.Restart app for changes to take effect.&CALL:PAUSED
IF "%SELECT%"=="~" IF NOT "%DEBUG%"=="ENABLED" SET "DEBUG=ENABLED"&SET "SELECT="
IF "%SELECT%"=="~" IF "%DEBUG%"=="ENABLED" SET "DEBUG=DISABLED"&SET "SELECT="
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="RAMDISK" GOTO:MENU_LIST
IF "%SELECT%"=="1" GOTO:APPEARANCE
IF "%SELECT%"=="2" GOTO:SHORTCUTS
IF "%SELECT%"=="3" CALL:FOLDER_MODE&SET "SELECT="
IF "%SELECT%"=="4" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="DISABLED" SET "HOST_HIDE=ENABLED"&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.           The vhdx host partition will be hidden upon exit.&&ECHO.                     Boot into recovery to revert.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED&SET "SELECT="
IF "%SELECT%"=="4" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="ENABLED" SET "HOST_HIDE=DISABLED"&&SET "SELECT="
IF "%SELECT%"=="5" IF "%PROG_MODE%"=="RAMDISK" GOTO:UPDATE_RECOVERY
GOTO:SETTINGS_MENU
:MENU_LIST
SET "$HEADERS=                        %U01% Custom Main Menu %U01%%U01% %U01%                             Select a list"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) Create new template"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF DEFINED ERROR GOTO:SETTINGS_MENU
IF "%SELECT%"=="0" CALL:MENU_TEMPLATE&GOTO:MENU_LIST
SET "MENU_LISTX=%$CHOICE%"&&SET "$HEADERS= %U01%                %COLOR2%Attention:%$$% This is an advanced feature%U01%    that can be used in reboot to restore and many other scenerios.%U01% %U01% %U01%         Proceeding will load a list instead of the main menu.%U01% %U01% %U01%                         Press (%##%X%$$%) to proceed"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" GOTO:MENU_LIST
SET "MENU_LIST=%MENU_LISTX%"&&SET "MENU_MODE=CUSTOM"&&ECHO.&&ECHO.Using %@@%%MENU_LISTX%%$$% instead of the main menu.&&ECHO.&&CALL:PAUSED&GOTO:CUSTOM_MODE
GOTO:MENU_LIST
:MENU_TEMPLATE
SET "$HEADERS=                     Custom Recovery Menu Template"&&SET "$CHOICE_LIST=Base-List%U01%Exec-List"&&SET "$SELECT=SELECTX"&&CALL:CHOICE_BOX
IF DEFINED ERROR EXIT /B
IF "%SELECTX%"=="1" SET "REC_LIST=base"
IF "%SELECTX%"=="2" SET "REC_LIST=list"
SET "$HEADERS= %U01% %U01% %U01% %U01%                        Enter name of new .%REC_LIST%%U01% %U01% %U01% "&&SET "$SELECT=NEW_NAME"&&SET "$CHECK=PATH"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF "%SELECTX%"=="1" CALL:MENU_EXAMPLE_BASE>"%ListFolder%\%NEW_NAME%.%REC_LIST%"
IF "%SELECTX%"=="2" CALL:MENU_EXAMPLE_EXEC>"%ListFolder%\%NEW_NAME%.%REC_LIST%"
START NOTEPAD.EXE "%ListFolder%\%NEW_NAME%.%REC_LIST%"
EXIT /B
:APPEARANCE
CLS&&CALL:SETS_HANDLER&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U12% Appearance&&ECHO.&&ECHO.&&ECHO. (%##% 1 %$$%) Pad Type           %@@%PAD %PAD_TYPE%%$$%&&ECHO. (%##% 2 %$$%) Pad Size           %@@%%PAD_SIZE%%$$%&&ECHO. (%##% 3 %$$%) Pad Sequence       %@@%%PAD_SEQ%%$$%&&CALL ECHO. (%##% 4 %$$%) Text Color         %@@%COLOR %%COLOR%TXT_COLOR%%%%TXT_COLOR%%$$%&&CALL ECHO. (%##% 5 %$$%) Accent Color       %@@%COLOR %%COLOR%ACC_COLOR%%%%ACC_COLOR%%$$%&&CALL ECHO. (%##% 6 %$$%) Button Color       %@@%COLOR %%COLOR%BTN_COLOR%%%%BTN_COLOR%%$$%&&ECHO. (%##% 7 %$$%) Pad Box            %@@%%PAD_BOX%%$$%&&ECHO.&&ECHO.&&ECHO.                         Color (%##% - %$$%/%##% + %$$%) Shift&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:SETTINGS_MENU
IF "%SELECT%"=="+" CALL:COLOR_SHIFT_TXT&SET "SELECT="
IF "%SELECT%"=="-" CALL:COLOR_SHIFT_PAD&SET "SELECT="
IF "%SELECT%"=="1" CALL:PAD_TYPE&SET "SELECT="
IF "%SELECT%"=="2" IF "%PAD_SIZE%"=="LARGE" SET "PAD_SIZE=SMALL"&SET "SELECT="
IF "%SELECT%"=="2" IF "%PAD_SIZE%"=="SMALL" SET "PAD_SIZE=LARGE"&SET "SELECT="
IF "%SELECT%"=="3" SET "$HEADERS=                             %U12% Appearance%U01% %U01%                  Enter 10 digit color sequence seed%U01% %U01% %U01% %U01% %U01%          [ %COLOR0%0%COLOR0%0%COLOR0%0%COLOR0%0%COLOR0%0%COLOR6%6%COLOR6%6%COLOR6%6%COLOR6%6%COLOR6%6%$$% ]    [ %COLOR0%0%COLOR1%1%COLOR2%2%COLOR3%3%COLOR4%4%COLOR5%5%COLOR6%6%COLOR7%7%COLOR8%8%COLOR9%9%$$% ]    [ %COLOR1%11%COLOR2%22%COLOR3%33%COLOR4%44%COLOR5%55%$$% ]%U01% %U01% "&&SET "$SELECT=COLOR_XXX"&&SET "$CHECK=NUMBER"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF "%SELECT%"=="3" SET "XNTX="&&FOR /F "DELIMS=" %%G IN ('%CMD% /D /U /C ECHO.%COLOR_XXX%^| FIND /V ""') do (CALL SET /A XNTX+=1)
IF "%SELECT%"=="3" IF "%XNTX%"=="10" SET "PAD_SEQ=%COLOR_XXX%"&&SET "COLOR_XXX="&SET "SELECT="
IF "%SELECT%"=="4" SET "COLOR_TMP=TXT_COLOR"&&CALL:COLOR_CHOICE&SET "SELECT="
IF "%SELECT%"=="5" SET "COLOR_TMP=ACC_COLOR"&&CALL:COLOR_CHOICE&SET "SELECT="
IF "%SELECT%"=="6" SET "COLOR_TMP=BTN_COLOR"&&CALL:COLOR_CHOICE&SET "SELECT="
IF "%SELECT%"=="7" IF "%PAD_BOX%"=="DISABLED" SET "PAD_BOX=ENABLED"&SET "SELECT="
IF "%SELECT%"=="7" IF "%PAD_BOX%"=="ENABLED" SET "PAD_BOX=DISABLED"&SET "SELECT="
GOTO:APPEARANCE
:PAD_TYPE
SET "$HEADERS=                             %U12% Appearance%U01% %U01%                           Select a pad type%U01% %U01% %U01% (%##%0%$$%) %@@%None%$$%  (%##%1%$$%) %@@%─%$$%  (%##%2%$$%) %@@%━%$$%  (%##%3%$$%) %@@%◌%$$%  (%##%4%$$%) %@@%○%$$%  (%##%5%$$%) %@@%●%$$%  (%##%6%$$%) %@@%❍%$$%  (%##%7%$$%) %@@%□%$$%  (%##%8%$$%) %@@%■%$$%%U01% %U01%    (%##%9%$$%) %@@%☰%$$%  (%##%10%$$%) %@@%☲%$$%  (%##%11%$$%) %@@%░%$$%  (%##%12%$$%) %@@%▒%$$%  (%##%13%$$%) %@@%▓%$$%   (%##%14%$$%) %@@%~%$$%  (%##%15%$$%) %@@%=%$$%  (%##%16%$$%) %@@%#%$$%%U01% "&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER❗0-16"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "PAD_TYPE=%SELECTX%"
EXIT /B
:COLOR_CHOICE
SET "$HEADERS=                             %U12% Appearance%U01% %U01%                             Select a color%U01% %U01% %U01% %U01%                  [ %COLOR0% 0 %COLOR1% 1 %COLOR2% 2 %COLOR3% 3 %COLOR4% 4 %COLOR5% 5 %COLOR6% 6 %COLOR7% 7 %COLOR8% 8 %COLOR9% 9 %$$% ]%U01% %U01% "&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER❗0-9"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "%COLOR_TMP%=%SELECTX%"
SET "COLOR_TMP="&&EXIT /B
:COLOR_SHIFT_PAD
FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%PAD_SEQ%^| FIND /V ""') do (SET "XXX_XXX=%%G"&&SET /A "PAD_XNT+=1"&&CALL:PAD_XNT)
SET "PAD_SEQ=%PAD_SHIFT%"&&FOR %%a in (PAD_SHIFT PAD_XNT XXX_XXX) DO (SET "%%a=")
EXIT /B
:COLOR_SHIFT_TXT
FOR %%a in (TXT_COLOR ACC_COLOR BTN_COLOR) DO (SET /A "%%a+=1")
IF "%TXT_COLOR%"=="10" SET "TXT_COLOR=0"
IF "%ACC_COLOR%"=="10" SET "ACC_COLOR=0"
IF "%BTN_COLOR%"=="10" SET "BTN_COLOR=0"
EXIT /B
:PAD_XNT
IF %PAD_XNT% GTR 10 EXIT /B
SET /A "XXX_XXX+=1"&&IF "%XXX_XXX%"=="9" SET "XXX_XXX=0"
SET "PAD_SHIFT=%PAD_SHIFT%%XXX_XXX%"
EXIT /B
:COMPRESS_LVL
IF /I "%COMPRESS%"=="FAST" SET "COMPRESS=MAX"&&EXIT /B
IF /I "%COMPRESS%"=="MAX" SET "COMPRESS=FAST"&&EXIT /B
EXIT /B
:SHORTCUTS
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&SET "$HEADERS=                             %U15% Shortcuts%U01% %U01%                      Select a main menu shortcut"&&SET "$CHOICE_LIST=%HOTKEY_1%	%SHORT_1%%U01%%HOTKEY_2%	%SHORT_2%%U01%%HOTKEY_3%	%SHORT_3%"&&CALL:CHOICE_BOX
IF DEFINED ERROR GOTO:SETTINGS_MENU
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:SETTINGS_MENU
IF DEFINED SELECT CALL:SHORTCUT_RUN
SET "SHORT_SET="&&FOR %%a in (1 2 3) DO (
IF "%SELECT%"=="%%a" SET "SHORT_SET=1"&&SET "$HEADERS=                             %U15% Shortcuts%U01% %U01% %U01% %U01% %U01%             Enter a command or the path to an application%U01% %U01% %U01% "&&SET "$SELECT=SHORT_X%SELECT%"&&SET "$CASE=ANY"&&SET "$CHECK=MOST"&&CALL:PROMPT_BOX
IF "%SELECT%"=="%%a" IF NOT DEFINED ERROR CALL SET "SHORT_%SELECT%=%%SHORT_X%SELECT%%%"&&SET "$HEADERS=                             %U15% Shortcuts%U01% %U01% %U01% %U01% %U01%                         Enter 3+ digit hotkey%U01% %U01% %U01% "&&SET "$SELECT=HOTKEY_X%SELECT%"&&SET "$CASE=ANY"&&SET "$CHECK=ALPHA"&&CALL:PROMPT_BOX
IF "%SELECT%"=="%%a" IF NOT DEFINED ERROR CALL SET "HOTKEY_%SELECT%=%%HOTKEY_X%SELECT%%%"&&SET "SHORT_XNT=0"&&FOR /F "DELIMS=" %%G in ('CALL %CMD% /D /U /C ECHO.%%HOTKEY_%SELECT%%%^| FIND /V ""') do (CALL SET /A "SHORT_XNT+=1"))
IF DEFINED SHORT_SET IF NOT DEFINED ERROR IF NOT "%SHORT_XNT%" GEQ "3" SET "HOTKEY_%SELECT%="&&SET "SHORT_%SELECT%="
GOTO:SHORTCUTS
:SHORTCUT_RUN
IF "%SELECT%"=="%HOTKEY_1%" SET "SHORT_RUN=%SHORT_1%"
IF "%SELECT%"=="%HOTKEY_2%" SET "SHORT_RUN=%SHORT_2%"
IF "%SELECT%"=="%HOTKEY_3%" SET "SHORT_RUN=%SHORT_3%"
IF NOT DEFINED SHORT_RUN EXIT /B
CALL START %SHORT_RUN%
SET "SHORT_RUN="&&EXIT /B
:AUTOBOOT_SVC
CALL:GET_NEXTBOOT
IF NOT DEFINED BOOT_OK ECHO.%COLOR4%ERROR:%$$% The boot environment is not installed on this system.&&EXIT /B
IF "%BOOTSVC%"=="INSTALL" ECHO.Recovery switcher service is installed.&&SC CREATE AutoBoot binpath="%WinDir%\SYSTEM32\%CMD% /C %BCDEDIT% /displayorder %GUID_TMP% /addfirst" start=auto>NUL 2>&1
IF "%BOOTSVC%"=="REMOVE" ECHO.Recovery switcher service is removed.&&SC DELETE AutoBoot>NUL 2>&1
SET "BOOTSVC="&&EXIT /B
:UPDATE_RECOVERY
CLS&&CALL:SETS_HANDLER&&CALL:GET_SPACE_ENV&&SET "$HEADERS=                            Recovery Update"&&SET "$CHOICE_LIST=Program  (%##%*%$$%) Test%U01%Recovery Wallpaper%U01%Recovery Password%U01%Boot Media%U01%Host Folder%U01%EFI Files%U01%gploy.ini"&&SET "$CHECKO=MENU"&&SET "$VERBOSE=1"&&CALL:CHOICE_BOX
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:SETTINGS_MENU
IF "%SELECT%"=="*" IF EXIST "%ProgFolder%\gploy.cmd" SET "VER_GET=%ProgFolder%\gploy.cmd"&&CALL:GET_PROGVER&&COPY /Y "%ProgFolder%\gploy.cmd" "%ProgFolder0%"&GOTO:MAIN_MENU
SET "$GO="&&FOR %%a in (1 2 3 4 5 6 7) DO (IF "%SELECT%"=="%%a" SET "$GO=1")
IF NOT DEFINED $GO GOTO:UPDATE_RECOVERY
FOR %%a in (0 1 2 3 4 5 ERROR) DO (IF "%FREE%"=="%%a" ECHO.%COLOR2%ERROR:%$$% Not enough free space. Clear some space and try again. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END)
IF "%SELECT%"=="1" SET "UPDATE_TYPE=PROG"
IF "%SELECT%"=="2" SET "UPDATE_TYPE=WALL"
IF "%SELECT%"=="3" SET "UPDATE_TYPE=PASS"
IF "%SELECT%"=="4" SET "UPDATE_TYPE=BOOT"
IF "%SELECT%"=="5" SET "UPDATE_TYPE=HOST"
IF "%SELECT%"=="6" SET "UPDATE_TYPE=EFI"
IF "%SELECT%"=="7" SET "UPDATE_TYPE=SETS"
IF "%UPDATE_TYPE%"=="SETS" SET "$HEADERS=                           Default Settings"&&SET "$NO_ERRORS=1"&&SET "$CHOICE_LIST=Replace gploy.ini%U01%Remove gploy.ini"&&SET "$VERBOSE=1"&&CALL:CHOICE_BOX
IF "%UPDATE_TYPE%"=="SETS" IF DEFINED ERROR GOTO:UPDATE_RECOVERY
IF "%UPDATE_TYPE%"=="SETS" IF "%SELECT%"=="1" SET "UPDATE_TYPE=CONFIG"
IF "%UPDATE_TYPE%"=="SETS" IF "%SELECT%"=="2" SET "UPDATE_TYPE=DEL_CONFIG"
IF "%UPDATE_TYPE%"=="CONFIG" IF NOT EXIST "%ProgFolder%\gploy.ini" ECHO.%COLOR4%ERROR:%$$% File gploy.ini is not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="EFI" IF NOT EXIST "%CacheFolder%\boot.sdi" IF NOT EXIST "%CacheFolder%\bootmgfw.efi" ECHO.%COLOR4%ERROR:%$$% Files boot.sdi and bootmgfw.efi are not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="BOOT" IF NOT EXIST "%CacheFolder%\boot.sav" ECHO.%COLOR4%ERROR:%$$% File boot.sav is not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PROG" IF NOT EXIST "%ProgFolder%\gploy.cmd" ECHO.%COLOR4%ERROR:%$$% File gploy.cmd is not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PROG" SET "VER_GET=%ProgFolder%\gploy.cmd"&&SET "VER_SET=VER_X"&&CALL:GET_PROGVER
IF "%UPDATE_TYPE%"=="PROG" SET "VER_GET=%ProgFolder0%\gploy.cmd"&&SET "VER_SET=VER_Y"&&CALL:GET_PROGVER
IF "%UPDATE_TYPE%"=="PROG" IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File gploy.cmd is corrupt. Abort.&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PASS" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.        %COLOR4%Important:%$$% Do not use any of these symbols [%COLOR2% ^< ^> %% ^^! ^& ^^^^ %$$%].&&ECHO.&&ECHO.                       Enter new recovery password&&ECHO.               Press (%##%0%$$%) to remove the recovery password&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&SET "$SELECT=RECOVERY_LOCK"&&SET "$CASE=ANY"&&SET "$CHECK=MOST"&&SET "$VERBOSE=1"&&CALL:MENU_SELECT
IF "%UPDATE_TYPE%"=="PASS" IF DEFINED ERROR CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PASS" IF "%RECOVERY_LOCK%"=="0" SET "RECOVERY_LOCK="
IF "%UPDATE_TYPE%"=="WALL" CALL:PE_WALLPAPER
IF "%UPDATE_TYPE%"=="WALL" IF NOT DEFINED $PICK SET "ERROR=UPDATE_RECOVERY"&&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="HOST" CALL:HOST_FOLDER
IF "%UPDATE_TYPE%"=="HOST" IF DEFINED ERROR GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="HOST" IF EXIST "Z:\%HOST_FOLDER%" ECHO.%COLOR2%ERROR:%$$% Host folder %@@%%HOST_FOLDER%%$$% already exists. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="HOST" REN "Z:\%HOST_FOLDERX%" "%HOST_FOLDER%">NUL 2>&1
IF "%UPDATE_TYPE%"=="HOST" IF NOT EXIST "Z:\%HOST_FOLDER%" ECHO.%COLOR2%ERROR:%$$% Host folder is currently in use. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="HOST" REN "Z:\%HOST_FOLDER%" "%HOST_FOLDERX%">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" SET "$PATH_X=%SYSTEMDRIVE%"&&CALL:GET_PATHINFO&MOVE /Y "%CacheFolder%\boot.sav" "%CacheFolder%\$BOOT.wim">NUL
IF "%UPDATE_TYPE%"=="BOOT" SET "INDEX_WORD=Setup"&&SET "$IMAGE_X=%CacheFolder%\$BOOT.wim"&&CALL:GET_WIMINDEX
IF "%UPDATE_TYPE%"=="BOOT" IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
IF "%UPDATE_TYPE%"=="BOOT" SET "$IMAGE_X=%CacheFolder%\$BOOT.wim"&&SET "INDEX_X=%INDEX_Z%"&&CALL:GET_IMAGEINFO
IF "%UPDATE_TYPE%"=="BOOT" MOVE /Y "%CacheFolder%\$BOOT.wim" "%CacheFolder%\boot.sav">NUL
IF "%UPDATE_TYPE%"=="BOOT" IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File boot.sav is corrupt. Abort.&&CALL:PAUSED&GOTO:UPDATE_END
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.
IF "%UPDATE_TYPE%"=="DEL_CONFIG" ECHO.           This will remove the default gploy.ini file.
IF "%UPDATE_TYPE%"=="CONFIG" ECHO.           This will replace the default gploy.ini file.
IF "%UPDATE_TYPE%"=="EFI" ECHO.             This will replace the current EFI boot files.
IF "%UPDATE_TYPE%"=="BOOT" ECHO.        This will replace %@@%v%$PATHVER%%$$% with %@@%v%$IMGVER%%$$%
IF "%UPDATE_TYPE%"=="PROG" ECHO.                  This will replace %@@%v%VER_Y%%$$% with %@@%v%VER_X%%$$%.
IF "%UPDATE_TYPE%"=="PASS" IF DEFINED RECOVERY_LOCK ECHO.           Recovery password will be changed to %@@%%RECOVERY_LOCK%%$$%.
IF "%UPDATE_TYPE%"=="PASS" IF NOT DEFINED RECOVERY_LOCK ECHO.                  Recovery password will be cleared.
IF "%UPDATE_TYPE%"=="WALL" ECHO.              This will replace the recovery background.
IF "%UPDATE_TYPE%"=="HOST" ECHO.              Host folder will be changed to %@@%%HOST_FOLDER%%$$%.&&ECHO.       %COLOR4%NOTE:%$$% The boot menu will need to be configured next boot.
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&SET "TIMER=5"&&CALL:TIMER&&CALL:CONFIRM
IF NOT "%CONFIRM%"=="X" SET "ERROR=UPDATE_RECOVERY"&&GOTO:UPDATE_END
SET "REBOOT_MAN=1"&&CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.                  %COLOR4%Recovery update has been initiated.%$$%&&ECHO.  %COLOR2%Caution:%$$% Interrupting this process can render the disk unbootable.&&ECHO.
CALL:EFI_MOUNT
IF DEFINED ERROR GOTO:UPDATE_END
SET "GET_BYTES=MB"&&SET "INPUT=%EFI_LETTER%:"&&SET "OUTPUT=EFI_FREE"&&CALL:GET_FREE_SPACE
IF NOT DEFINED ERROR SET "GET_BYTES=MB"&&SET "INPUT=%EFI_LETTER%:\$.WIM"&&SET "OUTPUT=BOOT_X"&&CALL:GET_FILESIZE
IF NOT DEFINED ERROR SET /A "EFI_FREE+=%BOOT_X%"
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% Unable to get file size or free space. Abort.&&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="EFI" IF EXIST "%CacheFolder%\boot.sdi" ECHO.Using boot.sdi located in folder, for efi image boot support.&&COPY /Y "%CacheFolder%\boot.sdi" "%EFI_LETTER%:\Boot">NUL
IF "%UPDATE_TYPE%"=="EFI" IF EXIST "%CacheFolder%\bootmgfw.efi" ECHO.Using bootmgfw.efi located in folder, for the efi bootloader.&&COPY /Y "%CacheFolder%\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL
IF "%UPDATE_TYPE%"=="EFI" FOR %%a in (boot.sdi bootmgfw.efi) DO (IF NOT EXIST "%CacheFolder%\%%a" ECHO.File %%a is not located in folder, skipping.)
IF "%UPDATE_TYPE%"=="EFI" ECHO.Unmounting EFI...&&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
CALL:VTEMP_CREATE
IF DEFINED ERROR CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
ECHO.Extracting boot-media...
IF "%UPDATE_TYPE%"=="BOOT" MOVE /Y "%CacheFolder%\boot.sav" "%CacheFolder%\$BOOT.wim">NUL
IF "%UPDATE_TYPE%"=="BOOT" SET "INDEX_WORD=Setup"&&SET "$IMAGE_X=%CacheFolder%\$BOOT.wim"&&CALL:GET_WIMINDEX
IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
IF NOT "%UPDATE_TYPE%"=="BOOT" %DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%EFI_LETTER%:\$.WIM" /INDEX:1 /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF "%UPDATE_TYPE%"=="BOOT" %DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%CacheFolder%\$BOOT.wim" /INDEX:%INDEX_Z% /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF "%UPDATE_TYPE%"=="BOOT" MOVE /Y "%CacheFolder%\$BOOT.wim" "%CacheFolder%\boot.sav">NUL
IF NOT EXIST "%VDISK_LTR%:\Windows" ECHO.%COLOR2%ERROR:%$$% BOOT MEDIA&&ECHO.Unmounting EFI...&&SET "ERROR=UPDATE_RECOVERY"&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="BOOT" MD "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%ProgFolder0%\gploy.cmd" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%ProgFolder0%\HOST_TARGET" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%ProgFolder0%\HOST_FOLDER" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%WINDIR%\System32\setup.bmp" "%VDISK_LTR%:\Windows\System32">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF NOT EXIST "%ProgFolder0%\SETTINGS_INI" DEL /Q /F "\\?\%VDISK_LTR%:\$\SETTINGS_INI">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF NOT EXIST "%ProgFolder0%\RECOVERY_LOCK" DEL /Q /F "\\?\%VDISK_LTR%:\$\RECOVERY_LOCK">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF EXIST "%ProgFolder0%\SETTINGS_INI" COPY /Y "%ProgFolder0%\SETTINGS_INI" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF EXIST "%ProgFolder0%\RECOVERY_LOCK" COPY /Y "%ProgFolder0%\RECOVERY_LOCK" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF EXIST "%VDISK_LTR%:\setup.exe" DEL /Q /F "\\?\%VDISK_LTR%:\setup.exe">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" (ECHO.[LaunchApp]&&ECHO.AppPath=X:\$\gploy.cmd)>"%VDISK_LTR%:\Windows\System32\winpeshl.ini"
IF "%UPDATE_TYPE%"=="BOOT" ECHO.Updating boot media %@@%v%$PATHVER%%$$% to %@@%v%$IMGVER%%$$%.
IF "%UPDATE_TYPE%"=="DEL_CONFIG" ECHO.Removing default gploy.ini file.&&DEL /Q /F "\\?\%VDISK_LTR%:\$\SETTINGS_INI">NUL 2>&1
IF "%UPDATE_TYPE%"=="CONFIG" ECHO.Updating default gploy.ini file.&&COPY /Y "%ProgFolder%\gploy.ini" "%VDISK_LTR%:\$\SETTINGS_INI">NUL
IF "%UPDATE_TYPE%"=="PROG" ECHO.Updating gploy.cmd %@@%v%VER_Y%%$$% to %@@%v%VER_X%%$$%.&&COPY /Y "%ProgFolder%\gploy.cmd" "%VDISK_LTR%:\$">NUL
IF "%UPDATE_TYPE%"=="PROG" ECHO.Removing default gploy.ini file to ensure compatibility.&&DEL /Q /F "\\?\%VDISK_LTR%:\$\SETTINGS_INI">NUL 2>&1
IF "%UPDATE_TYPE%"=="PASS" IF DEFINED RECOVERY_LOCK ECHO.Recovery password will be changed to %@@%%RECOVERY_LOCK%%$$%.&&ECHO.%RECOVERY_LOCK%>"%VDISK_LTR%:\$\RECOVERY_LOCK"
IF "%UPDATE_TYPE%"=="PASS" IF NOT DEFINED RECOVERY_LOCK ECHO.Recovery password will be cleared.&&DEL /Q /F "\\?\%VDISK_LTR%:\$\RECOVERY_LOCK">NUL 2>&1
IF "%UPDATE_TYPE%"=="WALL" ECHO.Using %PE_WALLPAPER% located in folder for the recovery wallpaper.
IF "%UPDATE_TYPE%"=="WALL" TAKEOWN /F "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1
IF "%UPDATE_TYPE%"=="WALL" ICACLS "%VDISK_LTR%:\Windows\System32\setup.bmp" /grant %USERNAME%:F>NUL 2>&1
IF "%UPDATE_TYPE%"=="WALL" COPY /Y "%CacheFolder%\%PE_WALLPAPER%" "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1
IF "%UPDATE_TYPE%"=="HOST" ECHO.Host folder will be changed to %@@%%HOST_FOLDER%%$$%.&&ECHO.%HOST_FOLDER%>"%VDISK_LTR%:\$\HOST_FOLDER"
ECHO.Saving boot-media...&&%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%VDISK_LTR%:" /IMAGEFILE:"%ImageFolder%\$TEMP.wim" /COMPRESS:%COMPRESS% /NAME:"WindowsPE" /CheckIntegrity /Verify /Bootable&ECHO.
SET "$IMAGE_X=%ImageFolder%\$TEMP.wim"&&SET "INDEX_X=1"&&CALL:GET_IMAGEINFO
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File boot.sav is corrupt. Abort.&&ECHO.Unmounting EFI...&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
SET "GET_BYTES=MB"&&SET "INPUT=%ImageFolder%\$TEMP.wim"&&SET "OUTPUT=BOOT_X"&&CALL:GET_FILESIZE
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% Unable to get file size or free space. Abort.&&ECHO.Unmounting EFI...&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
CALL:GET_SPACE_ENV&&FOR %%a in (EFI_FREE BOOT_X) DO (IF NOT DEFINED %%a SET "%%a=0")
IF %EFI_FREE% LEQ %BOOT_X% ECHO.%COLOR2%ERROR:%$$% File boot.sav %BOOT_X%MB exceeds %EFI_FREE%MB. Abort.&&ECHO.Unmounting EFI...&&SET "ERROR=UPDATE_RECOVERY"&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
FOR %%a in (0 ERROR) DO (IF "%FREE%"=="%%a" ECHO.%COLOR2%ERROR:%$$% Not enough free space. Clear some space and try again. Abort.&&ECHO.Unmounting EFI...&&SET "ERROR=UPDATE_RECOVERY"&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END)
DEL /Q /F "%EFI_LETTER%:\$.WIM">NUL 2>&1
MOVE /Y "%ImageFolder%\$TEMP.wim" "%EFI_LETTER%:\$.WIM">NUL
ECHO.Unmounting EFI...&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT
:UPDATE_END
IF EXIST "%ImageFolder%\$TEMP.wim" DEL /Q /F "%ImageFolder%\$TEMP.wim">NUL 2>&1
IF "%UPDATE_TYPE%"=="HOST" IF NOT DEFINED ERROR REN "Z:\%HOST_FOLDERX%" "%HOST_FOLDER%">NUL 2>&1
IF NOT DEFINED ERROR FOR %%a in (Z:\%HOST_FOLDER% Z:) DO (ICACLS "%%a" /deny everyone:^(DE,WA,WDAC^)>NUL 2>&1)
IF DEFINED REBOOT_MAN ECHO.&&ECHO.                       THE SYSTEM WILL NOW RESTART.&&ECHO.&&ECHO.              %@@%UPDATE FINISH:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED&GOTO:QUIT
SET "RECOVERY_LOCK="&&GOTO:UPDATE_RECOVERY
:VTEMP_CREATE
IF DEFINED ERROR EXIT /B
IF EXIST "%ImageFolder%\$TEMP.vhdx" CALL:VTEMP_DELETE>NUL 2>&1
ECHO.Mounting temporary vdisk...&&SET "$VDISK_FILE=%ImageFolder%\$TEMP.vhdx"&&SET "VDISK_LTR=ANY"&&SET "VHDX_SIZE=50"&&CALL:VDISK_CREATE>NUL 2>&1
IF NOT EXIST "%VDISK_LTR%:\" SET "ERROR=VTEMP_CREATE"&&CALL:DEBUG
EXIT /B
:VTEMP_DELETE
IF EXIST "%ImageFolder%\$TEMP.vhdx" ECHO.Unmounting temporary vdisk...&&SET "$VDISK_FILE=%ImageFolder%\$TEMP.vhdx"&&CALL:VDISK_DETACH>NUL 2>&1
IF EXIST "%ImageFolder%\$TEMP.vhdx" DEL /Q /F "%ImageFolder%\$TEMP.vhdx">NUL 2>&1
EXIT /B
:PE_WALLPAPER
SET "$HEADERS=                          Recovery Wallpaper"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%CacheFolder%"&&SET "$FILT=*.JPG *.PNG"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=WALL"&&CALL:BASIC_FILE&EXIT /B
IF DEFINED $PICK SET "PE_WALLPAPER=%$CHOICE%"
IF NOT DEFINED $PICK SET "PE_WALLPAPER=SELECT"
EXIT /B
:HOST_FOLDER
SET "$HEADERS= %U01% %U01% %U01% %U01%                      Enter the host folder name%U01% %U01% %U01% "&&SET "$CHECK=ALPHA❗1-20"&&SET "$VERBOSE=1"&&SET "$SELECT=SELECTX"&&CALL:PROMPT_BOX
IF NOT DEFINED SELECTX SET "ERROR=HOST_FOLDER"&&CALL:DEBUG
IF DEFINED ERROR CALL:PAUSED
IF NOT DEFINED ERROR SET "HOST_FOLDER=%SELECTX%"
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:IMAGE_PROCESSING
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&FOR %%a in (SOURCE TARGET) DO (IF NOT DEFINED %%a_TYPE SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX")
SET "SOURCE_LOCATION="&&FOR %%a in (A B C D E F G H I J K L N O P Q R S T U W Y Z) DO (IF EXIST "%%a:\sources\boot.wim" SET "SOURCE_LOCATION=%%a:\sources")
SET "PROC_DISPLAY="&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                        %U07% Image Processing^|%SOURCE_TYPE%&&ECHO.
IF DEFINED SOURCE_LOCATION ECHO. (%##%-%$$%) Import Boot  %COLOR5%Windows Installation Media Detected%$$%  Import WIM (%##%+%$$%)&&ECHO.
IF NOT EXIST "%ImageFolder%\*.WIM" ECHO.        %@@%Insert a Windows Disc/ISO to import installation media%$$%&&ECHO.
IF NOT EXIST "%CacheFolder%\BOOT.SAV" ECHO.            %@@%Insert a Windows Disc/ISO to import boot media%$$%&&ECHO.
IF "%SOURCE_TYPE%"=="WIM" IF "%WIM_SOURCE%"=="SELECT" SET "WIM_INDEX=1"&&SET "$IMGEDIT="
IF NOT DEFINED $IMGEDIT SET "$IMGEDIT=SELECT"&&SET "WIM_INDEX=1"
FOR %%G in (%SOURCE_TYPE% %TARGET_TYPE%) DO (IF "%%G"=="VHDX" SET "PROC_DISPLAY=1")
FOR %%G in (%SOURCE_TYPE% %TARGET_TYPE%) DO (IF "%%G"=="PATH" SET "PROC_DISPLAY=2")
IF "%PROC_DISPLAY%"=="1" ECHO.  %@@%AVAILABLE %@@%%SOURCE_TYPE%s%$$% (%##%X%$$%) %@@%%TARGET_TYPE%s%$$%:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM *.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST
IF "%PROC_DISPLAY%"=="2" ECHO.  %@@%AVAILABLE %@@%%SOURCE_TYPE%s%$$% (%##%X%$$%) %@@%%TARGET_TYPE%s%$$%:%$$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO.   %%G:)
IF "%PROC_DISPLAY%"=="2" SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM"&&SET "$DISP=BAS"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="PATH" ECHO. [%@@%PATH%$$%] (%##%S%$$%)ource %@@%%PATH_SOURCE%%$$%&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="VHDX" ECHO. [%@@%VHDX%$$%] (%##%S%$$%)ource %@@%%VHDX_SOURCE%%$$%&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="WIM" ECHO. [%@@%WIM%$$%] (%##%S%$$%)ource %@@%%WIM_SOURCE%%$$%   (%##%I%$$%)ndex %@@%%WIM_INDEX%%$$%   Edition: %@@%%$IMGEDIT%%$$%&&CALL:PAD_LINE
IF "%TARGET_TYPE%"=="VHDX" ECHO. [%@@%VHDX%$$%] (%##%T%$$%)arget %@@%%VHDX_TARGET%%$$%        (%##%C%$$%)onvert      (%##%V%$$%)disk Size %@@%%VHDX_SIZE%GB%$$%&&CALL:PAD_LINE
IF "%TARGET_TYPE%"=="WIM" ECHO. [%@@%WIM%$$%] (%##%T%$$%)arget %@@%%WIM_TARGET%%$$%         (%##%C%$$%)onvert          (%##%.%$$%)Compression %@@%%COMPRESS%%$$%&&CALL:PAD_LINE
IF "%TARGET_TYPE%"=="PATH" ECHO. [%@@%PATH%$$%] (%##%T%$$%)arget %@@%%PATH_TARGET%%$$%        (%##%C%$$%)onvert&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="C" CALL:IMAGEPROC_START&SET "SELECT="
IF "%SELECT%"=="X" CALL:IMAGEPROC_SLOT&SET "SELECT="
IF "%SELECT%"=="T" CALL:IMAGEPROC_TARGET&SET "SELECT="
IF "%SELECT%"=="S" CALL:IMAGEPROC_SOURCE&SET "SELECT="
IF "%SELECT%"=="V" IF "%TARGET_TYPE%"=="VHDX" CALL:IMAGEPROC_VSIZE&SET "SELECT="
IF "%SELECT%"=="I" IF "%SOURCE_TYPE%"=="WIM" IF NOT "%WIM_SOURCE%"=="SELECT" CALL:WIM_INDEX_MENU
IF "%SELECT%"=="+" IF DEFINED SOURCE_LOCATION CALL:SOURCE_IMPORT&SET "SELECT="
IF "%SELECT%"=="-" IF DEFINED SOURCE_LOCATION CALL:BOOT_IMPORT&SET "SELECT="
IF "%SELECT%"=="." CALL:COMPRESS_LVL&SET "SELECT="
GOTO:IMAGE_PROCESSING
:IMAGEPROC_START
SET "SOURCE_X="&&SET "TARGET_X="&&IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.         %@@%IMAGE PROCESSING START:%$$%  %DATE%  %TIME%
CALL SET "SOURCE_X=%%%SOURCE_TYPE%_SOURCE%%%"
CALL SET "TARGET_X=%%%TARGET_TYPE%_TARGET%%%"
FOR %%a in (SOURCE_X TARGET_X) DO (IF NOT DEFINED %%a SET "%%a=SELECT")
IF "%SOURCE_X%"=="SELECT" ECHO.&&ECHO.                          %COLOR4%Source %SOURCE_TYPE% not set.%$$%&&GOTO:IMAGEPROC_END
IF "%TARGET_X%"=="SELECT" ECHO.&&ECHO.                          %COLOR4%Target %TARGET_TYPE% not set.%$$%&&GOTO:IMAGEPROC_END
IF "%SOURCE_TYPE%"=="PATH" IF NOT EXIST "%PATH_SOURCE%\" ECHO.&&ECHO.                         %COLOR4%Source %SOURCE_TYPE% doesn't exist.%$$%&&GOTO:IMAGEPROC_END
IF "%TARGET_TYPE%"=="PATH" IF NOT EXIST "%PATH_TARGET%\" ECHO.&&ECHO.                         %COLOR4%Target %TARGET_TYPE% doesn't exist.%$$%&&GOTO:IMAGEPROC_END
IF "%TARGET_TYPE%"=="WIM" IF EXIST "%ImageFolder%\%WIM_TARGET%" ECHO.&&ECHO. %COLOR4%Target %WIM_TARGET% exists. Try another name or delete the existing file.%$$%&&GOTO:IMAGEPROC_END
IF "%TARGET_TYPE%"=="VHDX" IF EXIST "%ImageFolder%\%VHDX_TARGET%" SET "$HEADERS= %U01% %U01%                  File %@@%%VHDX_TARGET%%$$% already exists.%U01% %U01%  %COLOR2%Note:%$$% Updating can cause loss of data. Create a backup beforehand.%U01% %U01%                         Press (%##%X%$$%) to proceed%U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF "%TARGET_TYPE%"=="VHDX" IF EXIST "%ImageFolder%\%VHDX_TARGET%" IF NOT "%CONFIRM%"=="X" ECHO.&&ECHO. %##%Abort.%$$%&&GOTO:IMAGEPROC_END
IF NOT DEFINED WIM_INDEX SET "WIM_INDEX=1"
IF NOT DEFINED VHDX_SIZE SET "VHDX_SIZE=25"
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="VHDX" CALL:WIM2VHDX
IF "%SOURCE_TYPE%"=="VHDX" IF "%TARGET_TYPE%"=="WIM" CALL:VHDX2WIM
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" SET "$PATH_X=%PATH_SOURCE%"&&CALL:GET_PATHINFO
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" IF NOT DEFINED $PATHEDIT SET "$PATHEDIT=Index_1"
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" ECHO.Capturing %PATH_SOURCE% to target image %WIM_TARGET%...&&%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%PATH_SOURCE%" /IMAGEFILE:"%ImageFolder%\%WIM_TARGET%" /COMPRESS:%COMPRESS% /NAME:"%$PATHEDIT%"
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="PATH" ECHO.Applying image %WIM_SOURCE% index %WIM_INDEX% to %PATH_TARGET%...&&%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%ImageFolder%\%WIM_SOURCE%" /INDEX:%WIM_INDEX% /APPLYDIR:"%PATH_TARGET%"
:IMAGEPROC_END
ECHO.&&ECHO.          %@@%IMAGE PROCESSING END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:WIM2VHDX
ECHO.&&IF EXIST "%ImageFolder%\%VHDX_TARGET%" SET "$VDISK_FILE=%ImageFolder%\%VHDX_TARGET%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT EXIST "%ImageFolder%\%VHDX_TARGET%" SET "$VDISK_FILE=%ImageFolder%\%VHDX_TARGET%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_CREATE
IF NOT EXIST "%VDISK_LTR%:\" ECHO.&&ECHO.          %COLOR4%Vdisk Error. If VHDX refuses mounting, try another.%$$%
IF EXIST "%VDISK_LTR%:\" ECHO.Applying image %WIM_SOURCE% index %WIM_INDEX% to %VDISK_LTR%:...
IF EXIST "%VDISK_LTR%:\" %DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%ImageFolder%\%WIM_SOURCE%" /INDEX:%WIM_INDEX% /APPLYDIR:"%VDISK_LTR%:"
ECHO.&&CALL:VDISK_DETACH
EXIT /B
:VHDX2WIM
ECHO.&&SET "$VDISK_FILE=%ImageFolder%\%VHDX_SOURCE%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT EXIST "%VDISK_LTR%:\" ECHO.&&ECHO.          %COLOR4%Vdisk Error. If VHDX refuses mounting, try another.%$$%
IF EXIST "%VDISK_LTR%:\" SET "$PATH_X=%VDISK_LTR%:"&&CALL:GET_PATHINFO
IF EXIST "%VDISK_LTR%:\" IF NOT DEFINED $PATHEDIT SET "$PATHEDIT=Index_1"
IF EXIST "%VDISK_LTR%:\" ECHO.Capturing %VDISK_LTR%: to target image %WIM_TARGET%...
IF EXIST "%VDISK_LTR%:\" %DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%VDISK_LTR%:" /IMAGEFILE:"%ImageFolder%\%WIM_TARGET%" /COMPRESS:%COMPRESS% /NAME:"%$PATHEDIT%"
ECHO.&&CALL:VDISK_DETACH
EXIT /B
:BASIC_BACKUP
SET "$HEADERS=                          %U07% Image Processing%U01% %U01%              Select a virtual hard disk image to backup"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=VHDX"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
SET "VHDX_SOURCE=%$BODY%%$EXT%"
SET "SOURCE_TYPE=VHDX"&&SET "TARGET_TYPE=WIM"&&CALL:IMAGEPROC_TARGET
IF NOT DEFINED WIM_TARGET EXIT /B
IF EXIST "%ImageFolder%\%WIM_TARGET%" ECHO.&&ECHO.%COLOR2%ERROR:%$$% File already exists.&&EXIT /B
SET "WIM_INDEX=1"&&CALL:IMAGEPROC_START
EXIT /B
:BASIC_RESTORE
SET "$HEADERS=                          %U07% Image Processing%U01% %U01%                      Select an image to restore"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=WIM"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
SET "WIM_SOURCE=%$BODY%%$EXT%"
CALL:WIM_INDEX_MENU
IF DEFINED ERROR EXIT /B
SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"&&CALL:IMAGEPROC_TARGET
IF NOT DEFINED VHDX_TARGET EXIT /B
IF EXIST "%ImageFolder%\%VHDX_TARGET%" ECHO.&&ECHO.%COLOR2%ERROR:%$$% File already exists.&&EXIT /B
CALL:IMAGEPROC_VSIZE
IF DEFINED ERROR EXIT /B
CALL:IMAGEPROC_START
EXIT /B
:BOOT_IMPORT
IF EXIST "%CacheFolder%\boot.sav" SET "$HEADERS= %U01% %U01% %U01% %U01%         File boot.sav already exists. Press (%##%X%$$%) to overwrite%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF EXIST "%CacheFolder%\boot.sav" IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%SOURCE_LOCATION%\boot.wim" ECHO.Importing %@@%boot.wim%$$% to boot.sav...&&COPY /Y "%SOURCE_LOCATION%\boot.wim" "%CacheFolder%\boot.sav"
EXIT /B
:SOURCE_IMPORT
SET "WIM_EXT="&&FOR %%G in (wim esd) DO (IF EXIST "%SOURCE_LOCATION%\install.%%G" SET "WIM_EXT=%%G")
IF EXIST "%CacheFolder%\boot.sav" SET "$HEADERS= %U01% %U01% %U01% %U01%                        Enter name of new .WIM%U01% %U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT DEFINED NEW_NAME EXIT /B
IF EXIST "%ImageFolder%\%NEW_NAME%.wim" SET "$HEADERS= %U01% %U01% %U01% %U01%         File %NEW_NAME%.wim already exists. Press (%##%X%$$%) to overwrite.%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF EXIST "%ImageFolder%\%NEW_NAME%.wim" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED NEW_NAME ECHO.Copying install.%WIM_EXT% to %@@%%NEW_NAME%.wim%$$%...&&COPY /Y "%SOURCE_LOCATION%\install.%WIM_EXT%" "%ImageFolder%\%NEW_NAME%.wim"&&SET "NEW_NAME="
EXIT /B
:IMAGEPROC_VSIZE
SET "$HEADERS=                          %U07% Image Processing%U01% %U01% %U01% %U01%                       Enter new VHDX size in GB%U01% %U01% %U01% %U01%                 Note: 25GB or greater is recommended"&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER❗1-9999"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR SET "ERROR=IMAGEPROC_VSIZE"&&EXIT /B
SET "VHDX_SIZE=%SELECTX%"
EXIT /B
:IMAGEPROC_TARGET
IF "%TARGET_TYPE%"=="PATH" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U07% Image Processing&&ECHO.&&ECHO.                         Enter the PATH target&&ECHO.&&ECHO.  %@@%AVAILABLE PATHs:%$$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO. ^( %##%%%G%$$% ^) Volume %%G:)
IF "%TARGET_TYPE%"=="PATH" ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MOST"&&SET "$SELECT=PATH_LETTER"&&CALL:MENU_SELECT
IF "%TARGET_TYPE%"=="PATH" IF DEFINED PATH_LETTER FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%PATH_LETTER%"=="%%G" IF EXIST "%%G:\" SET "PATH_TARGET=%PATH_LETTER%:"&&EXIT /B)
IF "%TARGET_TYPE%"=="PATH" IF DEFINED PATH_LETTER SET "INPUT=%PATH_LETTER%"&&SET "OUTPUT=PATH_TARGET"&&CALL:SLASHER
IF "%TARGET_TYPE%"=="PATH" IF NOT DEFINED PATH_LETTER SET "PATH_TARGET="
IF NOT "%TARGET_TYPE%"=="PATH" SET "$HEADERS=                          %U07% Image Processing%U01% %U01% %U01% %U01% %U01%                        Enter name of new .%TARGET_TYPE%%U01% %U01% %U01% "&&SET "$NO_ERRORS=1"&&SET "$SELECT=SELECTX"&&SET "$CHECK=PATH"&&CALL:PROMPT_BOX
IF "%TARGET_TYPE%"=="WIM" IF DEFINED SELECTX SET "WIM_TARGET=%SELECTX%.wim"
IF "%TARGET_TYPE%"=="VHDX" IF DEFINED SELECTX SET "VHDX_TARGET=%SELECTX%.vhdx"
EXIT /B
:IMAGEPROC_SOURCE
IF "%SOURCE_TYPE%"=="PATH" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U07% Image Processing&&ECHO.&&ECHO.                         Enter the PATH source&&ECHO.&&ECHO.  %@@%AVAILABLE PATHs:%$$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO. ^( %##%%%G%$$% ^) Volume %%G:)
IF "%SOURCE_TYPE%"=="PATH" ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MOST"&&SET "$SELECT=PATH_LETTER"&&CALL:MENU_SELECT
IF "%SOURCE_TYPE%"=="PATH" FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%PATH_LETTER%"=="%%G" IF EXIST "%%G:\" SET "PATH_SOURCE=%PATH_LETTER%:"&&EXIT /B)
IF "%SOURCE_TYPE%"=="PATH" IF DEFINED PATH_LETTER SET "INPUT=%PATH_LETTER%"&&SET "OUTPUT=PATH_SOURCE"&&CALL:SLASHER
IF "%SOURCE_TYPE%"=="PATH" IF NOT DEFINED PATH_LETTER SET "PATH_SOURCE="
IF NOT "%SOURCE_TYPE%"=="PATH" SET "$HEADERS=                          %U07% Image Processing%U01% %U01%                          Select a %SOURCE_TYPE% source"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %U13% File Operation"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.%SOURCE_TYPE%"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF NOT "%SOURCE_TYPE%"=="PATH" IF "%SELECT%"=="0" SET "FILE_TYPE=%SOURCE_TYPE%"&&CALL:BASIC_FILE&EXIT /B
IF NOT "%SOURCE_TYPE%"=="PATH" CALL SET "%SOURCE_TYPE%_SOURCE=%$CHOICE%"
EXIT /B
:WIM_INDEX_MENU
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U07% Image Processing&&ECHO.&&ECHO.                            Select an index&&ECHO.&&ECHO.  %@@%AVAILABLE INDEXs:%$$%&&ECHO.
SET "INDEX_DSP="&&SET "NAME_DSP="&&FOR /F "TOKENS=1-7 SKIP=5 DELIMS=:<> " %%a in ('%DISM% /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"%ImageFolder%\%WIM_SOURCE%" 2^>NUL') DO (
IF "%%a"=="Index" SET "INDEX_DSP=%%b"
IF "%%a"=="Name" SET "NAME_DSP=%%b %%c %%d %%e %%f %%g"&&CALL:WIM_INDEX_LIST)
IF NOT DEFINED INDEX_DSP ECHO.%COLOR2%ERROR%$$%&&SET "ERROR=WIM_INDEX_MENU"&&CALL:DEBUG&&EXIT /B
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT SET "ERROR=WIM_INDEX_MENU"&&CALL:DEBUG&&EXIT /B
SET "$IMAGE_X=%ImageFolder%\%WIM_SOURCE%"&&SET "INDEX_X=%SELECT%"&&CALL:GET_IMAGEINFO
SET "WIM_INDEX=%SELECT%"&&IF DEFINED ERROR SET "WIM_INDEX=1"&&ECHO.%COLOR2%ERROR%$$%
EXIT /B
:WIM_INDEX_LIST
ECHO. ( %##%%INDEX_DSP%%$$% ) %NAME_DSP%
EXIT /B
:IMAGEPROC_SLOT
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="PATH" SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"&&EXIT /B
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="VHDX" SET "SOURCE_TYPE=VHDX"&&SET "TARGET_TYPE=WIM"&&EXIT /B
IF "%SOURCE_TYPE%"=="VHDX" IF "%TARGET_TYPE%"=="WIM" SET "SOURCE_TYPE=PATH"&&SET "TARGET_TYPE=WIM"&&EXIT /B
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=PATH"&&EXIT /B
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:IMAGE_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "IMAGE_LAST=IMAGE"&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U13% Image Management&&ECHO.
ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&SET "$DISP=BAS"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U13%LIST%$$%(%##%X%$$%)PACK%U05%%$$%  (%##%R%$$%)un List  (%##%E%$$%)dit List  (%##%B%$$%)uild List  (%##%.%$$%)Reference&&CALL:PAD_LINE
IF DEFINED ADV_IMGM ECHO. [%@@%OPTIONS%$$%] (%##%S%$$%)afe Exclude %@@%%SAFE_EXCLUDE%%$$%&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="." CALL:REFERENCE
IF "%SELECT%"=="X" GOTO:PACKAGE_MANAGEMENT
IF "%SELECT%"=="R" SET "IMAGEMGR_TYPE=LIST"&&CALL:IMAGEMGR_EXECUTE&SET "SELECT="
IF "%SELECT%"=="B" CALL:IMAGEMGR_BUILDER&SET "SELECT="
IF "%SELECT%"=="O" IF DEFINED ADV_IMGM SET "ADV_IMGM="&SET "SELECT="
IF "%SELECT%"=="O" IF NOT DEFINED ADV_IMGM SET "ADV_IMGM=1"&SET "SELECT="
IF "%SELECT%"=="E" CALL:LIST_EDIT&&SET "SELECT="
IF "%SELECT%"=="S" IF "%SAFE_EXCLUDE%"=="DISABLED" SET "SAFE_EXCLUDE=ENABLED"&SET "SELECT="
IF "%SELECT%"=="S" IF "%SAFE_EXCLUDE%"=="ENABLED" SET "SAFE_EXCLUDE=DISABLED"&SET "SELECT="
GOTO:IMAGE_MANAGEMENT
:REFERENCE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U13% Reference&&ECHO.&&ECHO.            Select a reference image to load with the menu&&ECHO.&&ECHO.  %@@%AVAILABLE *.VHDXs:%$$%&&ECHO.&&ECHO. ( %##%0%$$% ) %U06% Current Environment&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO. ( %##%.%$$% ) Disabled&&ECHO.
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF "%SELECT%"=="0" SET "REFERENCE=LIVE"
IF "%SELECT%"=="." SET "REFERENCE=DISABLED"
IF NOT DEFINED $PICK EXIT /B
SET "REFERENCE=%$CHOICE%"
EXIT /B
:LIST_EDIT
SET "$HEADERS=                             %U13% Edit List%U01% %U01%                             Select a list"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=LISTS"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
START NOTEPAD "%$PICK%"
EXIT /B
:IMAGEMGR_EXECUTE
IF "%IMAGEMGR_TYPE%"=="LIST" SET "$HEADERS=                            %U13% List Execute%U01% %U01%                            Select an option"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF DEFINED ERROR EXIT /B
IF "%IMAGEMGR_TYPE%"=="PACK" SET "$HEADERS=                            %U05% Pack Execute%U01% %U01%                            Select an option"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" IF "%IMAGEMGR_TYPE%"=="PACK" SET "FILE_TYPE=PKX"&&CALL:BASIC_FILE&EXIT /B
IF "%SELECT%"=="0" IF "%IMAGEMGR_TYPE%"=="LIST" SET "FILE_TYPE=LISTS"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
SET "$LISTPACK=%$CHOICE%"&&FOR %%G in ("%$PICK%") DO (SET "CAPS_SET=IMAGEMGR_EXT"&&SET "CAPS_VAR=%%~xG"&&CALL:CAPS_SET)
IF "%IMAGEMGR_EXT%"==".BASE" SET "$LIST_FILE=%$PICK%"&SET "BASE_EXEC=1"&&CALL:LIST_VIEWER&SET "IMAGEMGR_EXT=.LIST"&SET "$HEAD=MENU-SCRIPT"&SET "$LISTPACK=$LIST"&IF "%FOLDER_MODE%"=="ISOLATED" MOVE /Y "$LIST" "%ListFolder%">NUL
IF DEFINED ERROR EXIT /B
IF DEFINED MENU_SESSION CLS&&CALL %CMD% /C ""%ProgFolder%\gploy.cmd" -IMAGEMGR -RUN -%IMAGEMGR_TYPE% "%$LISTPACK%" -MENU"&CALL:PAUSED&EXIT /B
IF "%IMAGEMGR_EXT%"==".PKX" SET "$IMGMGRX=                           %U05% Pack Execute"
IF "%IMAGEMGR_EXT%"==".LIST" SET "$IMGMGRX=                           %U13% List Execute"
SET "$ITEMSTOP= ( %##%0%$$% ) %##%Current Environment%$$%"&&SET "$HEADERS=%$IMGMGRX%%U01% %U01%                            Select a target"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF DEFINED ERROR EXIT /B
IF "%SELECT%"=="0" SET "LIVE_APPLY=1"
IF NOT DEFINED LIVE_APPLY CLS&&CALL %CMD% /C ""%ProgFolder%\gploy.cmd" -IMAGEMGR -RUN -%IMAGEMGR_TYPE% "%$LISTPACK%" -vhdx "%$CHOICE%""&&CALL:PAUSED&EXIT /B
IF DEFINED LIVE_APPLY CLS&&CALL %CMD% /C ""%ProgFolder%\gploy.cmd" -IMAGEMGR -RUN -%IMAGEMGR_TYPE% "%$LISTPACK%" -live"&CALL:PAUSED&EXIT /B
EXIT /B
:LIST_EXEC
IF NOT DEFINED $LIST_FILE EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" IF NOT "%PROG_MODE%"=="GUI" IF NOT EXIST "%ProgFolder%\$PKX" CLS
SET "MOUNT="&&CALL:MOUNT_INT&&FOR %%G in ("%$LIST_FILE%") DO SET "LIST_NAME=%%~nG%%~xG"
IF NOT DEFINED LIST_ITEMS_EXECUTE CALL:LIST_ITEMS
IF NOT DEFINED SAFE_EXCLUDE SET "SAFE_EXCLUDE=ENABLED"
SET "$BOX=ST"&&CALL:BOX_DISP
IF NOT DEFINED CUSTOM_SESSION ECHO.             %@@%%CURR_SESSION%-LIST START:%$$%  %DATE%  %TIME%&&ECHO.
SET "$HEAD_CHECK=%$LIST_FILE%"&&CALL:GET_HEADER
IF DEFINED ERROR GOTO:LIST_EXEC_END
IF DEFINED MENU_SESSION GOTO:LIST_EXEC_JUMP
IF DEFINED VDISK_APPLY SET "VDISK_LTR=ANY"&CALL:VDISK_ATTACH
IF DEFINED VDISK_APPLY SET "TARGET_PATH=%VDISK_LTR%:"
IF DEFINED LIVE_APPLY SET "TARGET_PATH=%SYSTEMDRIVE%"
IF DEFINED PATH_APPLY SET "TARGET_PATH=%TARGET_PATH%"
IF DEFINED LIVE_APPLY IF NOT DEFINED CUSTOM_SESSION IF NOT DEFINED MENU_SESSION ECHO.Using live system as target.
IF NOT EXIST "%TARGET_PATH%\" ECHO.&&ECHO.           %COLOR4%Path error or Windows is not installed on Vdisk.%$$%&&ECHO.&&GOTO:LIST_EXEC_END
:LIST_EXEC_JUMP
FOR %%□ in ($HALT GROUP SUBGROUP) DO (IF DEFINED %%□ SET "%%□=")
CALL:SESSION_CLEAR&&CALL:RAS_DELETE
COPY /Y "%$LIST_FILE%" "$TEMP">NUL 2>&1
IF EXIST "$TEMP" FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ($TEMP) DO (
SET "COLUMN0="&&IF DEFINED $HALT ECHO.%COLOR2%ERROR:%$$% HALT.&&GOTO:LIST_EXEC_END
IF NOT "%%a"=="" SET "COLUMN0=%U00%%%a%U00%"
IF NOT "%%b"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%"
IF NOT "%%c"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%"
IF NOT "%%d"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%"
IF NOT "%%e"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"
IF NOT "%%f"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%"
IF NOT "%%g"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%"
IF NOT "%%h"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%"
IF NOT "%%i"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%%%i%U00%"
IF DEFINED COLUMN0 CALL:UNIFIED_PARSE_EXECUTE)
:LIST_EXEC_END
CALL:MOUNT_INT&IF DEFINED VDISK_APPLY CALL:VDISK_DETACH
CALL:SESSION_CLEAR&&CALL:RAS_DELETE
IF NOT DEFINED CUSTOM_SESSION ECHO.&&ECHO.             %@@%%CURR_SESSION%-LIST END:%$$%  %DATE%  %TIME%
SET "$BOX=SB"&&CALL:BOX_DISP&&SET "MOUNT="&&CALL:MOUNT_INT
IF NOT EXIST "%ProgFolder%\$PKX" CALL:CLEAN
FOR %%a in (LIST_ITEMS_EXECUTE LIST_ITEMS_BUILDER DRVR_QRY FEAT_QRY SC_PREPARE RO_PREPARE) DO (SET "%%a=")
EXIT /B
:UNIFIED_PARSE_EXECUTE
IF NOT DEFINED COLUMN0 EXIT /B
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a IN ("!COLUMN0!") DO (SET "COLUMN1=%%a"&&SET "COLUMN2=%%b"&&SET "COLUMN3=%%c"&&SET "COLUMN4=%%d")
IF NOT DEFINED COLUMN4 EXIT /B
SET "$INPUT=!COLUMN1!"&&SET "$OUTPUT=COLUMN1"&&SET "$NO_QUOTE=1"&&CALL:EXPAND_INPUT
IF NOT DEFINED COLUMN1 EXIT /B
FOR /F "TOKENS=* DELIMS=ⓡ" %%● IN ("!COLUMN1!") DO (IF NOT "%%●"=="!COLUMN1!" SET "COLUMN1=!COLUMN1:ⓡ=!"&&IF NOT DEFINED $VCLMX EXIT /B)
SET "@QUIET="&&FOR /F "TOKENS=* DELIMS=ⓠ" %%● IN ("!COLUMN1!") DO (IF NOT "%%●"=="!COLUMN1!" SET "@QUIET=1"&&SET "COLUMN1=!COLUMN1:ⓠ=!")
SET "$RAS="&&SET "$ITEM_TYPE="&&IF NOT DEFINED LIST_ITEMS_EXECUTE CALL:LIST_ITEMS
FOR %%● in (%LIST_ITEMS_EXECUTE%) DO (IF /I "%%●"=="!COLUMN1!" SET "$ITEM_TYPE=EXECUTE")
FOR %%● in (%LIST_ITEMS_BUILDER%) DO (IF /I "%%●"=="!COLUMN1!" SET "$ITEM_TYPE=BUILDER")
IF NOT DEFINED $ITEM_TYPE EXIT /B
IF /I "!COLUMN1!"=="GROUP" CALL:SESSION_CLEAR
IF "!$ITEM_TYPE!"=="BUILDER" CALL:SCRO_QUEUE&&FOR %%○ in (1 2 3 4 5 6 7 8 9 I S) DO (SET "!COLUMN1!.%%○=")
IF "!$ITEM_TYPE!"=="BUILDER" FOR /F "TOKENS=1 DELIMS=123456789" %%● IN ("!COLUMN1!") DO (CALL:%%●_ITEM)
IF "!$ITEM_TYPE!"=="EXECUTE" SET "$INPUT=!COLUMN4!"&&SET "$OUTPUT=COLUMN4"&&CALL:EXPAND_INPUT
IF "!$ITEM_TYPE!"=="EXECUTE" IF NOT DEFINED COLUMN4 EXIT /B
IF "!$ITEM_TYPE!"=="EXECUTE" FOR /F "TOKENS=*" %%● in ("!COLUMN4!") DO (IF /I "%%●"=="DX" CALL:!COLUMN1!_ITEM
FOR %%○ in (SC RO) DO (IF /I "%%●"=="%%○" CALL:SCRO_CREATE))
CD /D "%ProgFolder0%">NUL 2>&1
EXIT /B
:TEXTHOST_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!"&&SET "$OUTPUT=ZCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (FILE SCREEN) DO (IF /I "!$ZCLM1$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not valid. Example: 'SCREEN' or 'FILE❗C:\TEXT.TXT'&&EXIT /B
IF /I "!$ZCLM1$!"=="FILE" IF EXIST "!$ZCLM2$!\*" ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not valid. Textfile target is a folder.&&EXIT /B
IF DEFINED QCLM2 SET "$QCLM2$=!QCLM2:%%=％!"&&SET "$QCLM2$=!$QCLM2$:◁=%%!"&&SET "$QCLM2$=!$QCLM2$:▷=%%!"&&SET "$QCLM2$=!$QCLM2$:＄=$!"&&FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (CALL SET "$QCLM2$=%%●"&&SET "$QCLM2$=!$QCLM2$:％=%%!")
IF /I "!$ZCLM1$!"=="FILE" FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (ECHO.%%●>>"!$ZCLM2$!")
IF /I "!$ZCLM1$!"=="SCREEN" FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (ECHO.%%●)
EXIT /B
:SESSION_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
CALL %CMD% /C ""%ProgFolder%\gploy.cmd" !$QCLM2$!"
EXIT /B
:GROUP_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 in ("!$QCLM2$!%U01%!$QCLM3$!") DO (SET "GROUP=%%1"&&SET "SUBGROUP=%%2")
IF DEFINED $QCLM7$ FOR /F "TOKENS=*" %%● IN ("!$QCLM7$!") DO (SET "CHOICE0.I=%%●"
FOR %%○ in (1 2 3 4 5 6 7 8 9) DO (IF "%%●"=="%%○" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM6$!") DO (SET "CHOICE0.S=%%%$QCLM7$%"&&SET "CHOICE0.%%●=%%%$QCLM7$%")))
FOR %%● in (S I) DO (IF NOT DEFINED CHOICE0.%%● SET "CHOICE0.I="&&SET "CHOICE0.S=")
EXIT /B
:PICKER_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
FOR /F "TOKENS=*" %%○ in ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=%%○"&&SET "!$QCLM1$!.S=%%○")
EXIT /B
:PROMPT_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
FOR /F "TOKENS=*" %%○ in ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=%%○"&&SET "!$QCLM1$!.S=%%○")
EXIT /B
:CHOICE_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
FOR /F "TOKENS=*" %%○ IN ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=%%○"
FOR %%◌ in (1 2 3 4 5 6 7 8 9) DO (IF "%%○"=="%%◌" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM3$!") DO (SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.%%◌=%%%$QCLM4$%")))
FOR %%○ in (S I) DO (IF NOT DEFINED !$QCLM1$!.%%○ SET "!$QCLM1$!.I="&&SET "!$QCLM1$!.S=")
EXIT /B
:STRING_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM2$!") DO (
IF /I "!$QCLM3$!"=="STRING" IF NOT "%%1"=="" SET "!$QCLM1$!.1=%%1"&&IF NOT "%%2"=="" SET "!$QCLM1$!.2=%%2"&&IF NOT "%%3"=="" SET "!$QCLM1$!.3=%%3"&&IF NOT "%%4"=="" SET "!$QCLM1$!.4=%%4"&&IF NOT "%%5"=="" SET "!$QCLM1$!.5=%%5"&&IF NOT "%%6"=="" SET "!$QCLM1$!.6=%%6"&&IF NOT "%%7"=="" SET "!$QCLM1$!.7=%%7"&&IF NOT "%%8"=="" SET "!$QCLM1$!.8=%%8"&&IF NOT "%%9"=="" SET "!$QCLM1$!.9=%%9"
IF /I "!$QCLM3$!"=="INTEGER" IF NOT "%%1"=="" SET /A "!$QCLM1$!.1=%%1"&&IF NOT "%%2"=="" SET /A "!$QCLM1$!.2=%%2"&&IF NOT "%%3"=="" SET /A "!$QCLM1$!.3=%%3"&&IF NOT "%%4"=="" SET /A "!$QCLM1$!.4=%%4"&&IF NOT "%%5"=="" SET /A "!$QCLM1$!.5=%%5"&&IF NOT "%%6"=="" SET /A "!$QCLM1$!.6=%%6"&&IF NOT "%%7"=="" SET /A "!$QCLM1$!.7=%%7"&&IF NOT "%%8"=="" SET /A "!$QCLM1$!.8=%%8"&&IF NOT "%%9"=="" SET /A "!$QCLM1$!.9=%%9")
FOR /F "TOKENS=*" %%○ IN ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=%%○"
FOR %%◌ in (1 2 3 4 5 6 7 8 9) DO (IF "%%○"=="%%◌" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM2$!") DO (
IF /I "!$QCLM3$!"=="STRING" SET "!$QCLM1$!.S=%%%$QCLM4$%"
IF /I "!$QCLM3$!"=="INTEGER" SET /A "!$QCLM1$!.S=%%%$QCLM4$%"
)))
FOR %%○ in (S I) DO (IF NOT DEFINED !$QCLM1$!.%%○ SET "!$QCLM1$!.I="&&SET "!$QCLM1$!.S=")
EXIT /B
:EXPANDOFLEX
IF DEFINED $NO_QUOTE SET "$NO_QUOTE="&&SET "$INPUT=!$INPUT:"=!"
SET "!$OUTPUT!0=!$INPUT!"&&FOR /F "TOKENS=1-9 DELIMS=%DELIMS%" %%a in ("!$INPUT!") DO (SET "PART1=%%a"&&SET "PART2=%%b"&&SET "PART3=%%c"&&SET "PART4=%%d"&&SET "PART5=%%e"&&SET "PART6=%%f"&&SET "PART7=%%g"&&SET "PART8=%%h"&&SET "PART9=%%i")
FOR %%● in (1 2 3 4 5 6 7 8 9) DO (SET "$PART%%●="&&SET "!$OUTPUT!%%●="&&SET "$!$OUTPUT!%%●="&&SET "$!$OUTPUT!%%●$="&&IF DEFINED PART%%● SET "!$OUTPUT!%%●=!PART%%●!"&&SET "$PART%%●=!PART%%●:◁=%%!"&&SET "$PART%%●=!$PART%%●:▷=%%!"&&SET "$!$OUTPUT!%%●=!$PART%%●!"&&CALL SET "$!$OUTPUT!%%●$=!$PART%%●!"
IF DEFINED PART%%● IF NOT DEFINED $NULLED IF NOT DEFINED $!$OUTPUT!%%●$ SET "$!$OUTPUT!%%●$=!PART%%●!"
IF DEFINED PART%%● IF DEFINED $NULLED SET "$NULLED="&&IF NOT DEFINED $!$OUTPUT!%%●$ SET "$!$OUTPUT!%%●$=◁Null▷")
IF "!$OUTPUT!"=="QCLM" SET "$QCLM1$=!$QCLM1$:ⓡ=!"&&SET "$QCLM1$=!$QCLM1$:ⓠ=!"
FOR %%● in ($INPUT $OUTPUT) DO (SET "%%●=")
EXIT /B
:EXPAND_INPUT
FOR %%● in ($INPUT $OUTPUT) DO (IF NOT DEFINED %%● SET "$INPUT_OG="&&SET "$INPUT="&&SET "$OUTPUT="&&SET "$NO_QUOTE="&&EXIT /B)
IF DEFINED $NO_QUOTE SET "$NO_QUOTE="&&SET "$INPUT=!$INPUT:"=!"
SET "!$OUTPUT!="&&SET "$INPUT_OG=!$INPUT!"&&SET "$INPUT=!$INPUT:◁=%%!"&&SET "$INPUT=!$INPUT:▷=%%!"
IF DEFINED $INPUT FOR /F "TOKENS=*" %%● in ("!$INPUT!") DO (CALL SET "$INPUT=%%●")
IF NOT DEFINED $INPUT IF NOT DEFINED $NULLED SET "!$OUTPUT!=!$INPUT_OG!"
IF NOT DEFINED $INPUT IF DEFINED $NULLED SET "$NULLED="&&SET "!$OUTPUT!=◁Null▷"
IF DEFINED $INPUT SET "!$OUTPUT!=!$INPUT!"
FOR %%● in ($INPUT_OG $INPUT $OUTPUT) DO (SET "%%●=")
EXIT /B
:RASTI_CREATE
IF NOT "%WINPE_BOOT%"=="1" SET "SRV_X="&&FOR /F "TOKENS=1-2* DELIMS= " %%a in ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\Services\$RAS" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" SET "SRV_X=1"&&IF NOT "%%c"=="%CMD% /C START %ProgFolder0%\$RAS.cmd" %REG% add "HKLM\SYSTEM\ControlSet001\Services\$RAS" /v "ImagePath" /t REG_EXPAND_SZ /d "%CMD% /C START %ProgFolder0%\$RAS.cmd" /f)
IF NOT "%WINPE_BOOT%"=="1" IF NOT DEFINED SRV_X SC CREATE $RAS BINPATH="%CMD% /C START "%ProgFolder0%\$RAS.cmd"" START=DEMAND>NUL 2>&1
IF /I "%$RAS%"=="RATI" ECHO.%REG% add "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /v "ImagePath" /t REG_EXPAND_SZ /d "%CMD% /C START %ProgFolder0%\$RATI.cmd" /f^>NUL 2^>^&^1>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.NET STOP TrustedInstaller^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.NET START TrustedInstaller^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.NET STOP TrustedInstaller^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.%REG% add "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /v "ImagePath" /t REG_EXPAND_SZ /d "%%%%SystemRoot%%%%\servicing\TrustedInstaller.exe" /f^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.DEL /Q /F "%ProgFolder0%\$RAS.cmd"^>NUL^&EXIT>>"%ProgFolder0%\$RAS.cmd"
ECHO.@ECHO OFF^&CD /D "%ProgFolder0%">"%ProgFolder0%\$%$RAS%.cmd"
IF NOT DEFINED VAR_ITEMS CALL:VAR_ITEMS
FOR %%■ in (DrvTar WinTar UsrTar HiveSoftware HiveSystem HiveUser ProgFolder ImageFolder ListFolder PackFolder CacheFolder PkxFolder ApplyTarget UsrNam UsrSid %VAR_ITEMS%) DO (IF DEFINED %%■ ECHO.SET "%%■=!%%■!">>"%ProgFolder0%\$%$RAS%.cmd")
ECHO.CALL:ROUTINE^>"%ProgFolder0%\$LOG">>"%ProgFolder0%\$%$RAS%.cmd"
ECHO.DEL /Q /F "%ProgFolder0%\$%$RAS%.cmd"^>NUL^&EXIT>>"%ProgFolder0%\$%$RAS%.cmd"
ECHO.:ROUTINE>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%"=="COMMAND" IF EXIST "$LIST" ECHO.FOR /F "TOKENS=*" %%%%@ in ($LIST) DO (%CMD% /C %%%%@)>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%:%$QCLM3$%"=="SERVICE:DELETE" ECHO.%REG% DELETE "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%:%$QCLM3$%"=="SERVICE:AUTO" ECHO.%REG% ADD "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V "Start" /T REG_DWORD /D "2" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%:%$QCLM3$%"=="SERVICE:MANUAL" ECHO.%REG% ADD "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V "Start" /T REG_DWORD /D "3" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%:%$QCLM3$%"=="SERVICE:DISABLE" ECHO.%REG% ADD "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V "Start" /T REG_DWORD /D "4" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%"=="TASK" ECHO.%REG% DELETE "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%"=="TASK" ECHO.%REG% DELETE "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{%TASKID%}" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%"=="TASK" ECHO.DEL /Q /F "%WinTar%\System32\Tasks\%$QCLM2$%"^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
SET "XNT="&&ECHO.EXIT /B>>"%ProgFolder0%\$%$RAS%.cmd"
IF NOT "%WINPE_BOOT%"=="1" NET START $RAS>NUL 2>&1
IF "%WINPE_BOOT%"=="1" IF "%$RAS%"=="RAS" CALL %CMD% /C "%ProgFolder0%\$RAS.cmd"
IF "%WINPE_BOOT%"=="1" IF "%$RAS%"=="RATI" CALL %CMD% /C "%ProgFolder0%\$RAS.cmd">NUL 2>&1
:RASTI_WAIT
SET /A "XNT+=1"&&FOR %%■ in (SERVICE TASK) DO (IF /I "%$QCLM1$%"=="%%■" FOR %%□ in (RAS RATI) DO (
IF EXIST "%ProgFolder0%\$%%□.cmd" CALL:TIMER_POINT3
IF EXIST "%ProgFolder0%\$%%□.cmd" IF "%XNT%"=="10" IF NOT DEFINED RETRY SET "RETRY=1"&&GOTO:RASTI_CREATE
IF EXIST "%ProgFolder0%\$%%□.cmd" IF "%XNT%"=="10" IF DEFINED RETRY CALL:RASTI_CHECK&DEL /Q /F "%ProgFolder0%\$%%□.cmd">NUL 2>&1))
FOR %%□ in (RAS RATI) DO (IF EXIST "%ProgFolder0%\$%%□.cmd" GOTO:RASTI_WAIT)
IF EXIST "%ProgFolder0%\$LOG" IF /I NOT "%$QCLM1$%"=="SERVICE" IF /I NOT "%$QCLM1$%"=="TASK" FOR /F "TOKENS=* DELIMS=" %%□ in (%ProgFolder0%\$LOG) DO (ECHO.%%□)
IF EXIST "%ProgFolder0%\$LOG" DEL /Q /F "%ProgFolder0%\$LOG">NUL 2>&1
SET "RETRY="&&SET "XNT="&&EXIT /B
:RASTI_CHECK
SET "$GO="&&FOR /F "TOKENS=1-3* DELIMS= " %%a in ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" IF "%%c"=="%CMD%" SET "$GO=1")
IF NOT DEFINED $GO EXIT /B
IF NOT "%WINPE_BOOT%"=="1" SET "SRV_X="&&FOR /F "TOKENS=1-2* DELIMS= " %%a in ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\Services\$RAS" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" SET "SRV_X=1"&&IF NOT "%%c"=="%CMD% /C START %ProgFolder0%\$RAS.cmd" %REG% add "HKLM\SYSTEM\ControlSet001\Services\$RAS" /v "ImagePath" /t REG_EXPAND_SZ /d "%CMD% /C START %ProgFolder0%\$RAS.cmd" /f)
IF NOT "%WINPE_BOOT%"=="1" IF NOT DEFINED SRV_X SC CREATE $RAS BINPATH="%CMD% /C START "%ProgFolder0%\$RAS.cmd"" START=DEMAND>NUL 2>&1
ECHO.NET STOP TrustedInstaller^>NUL 2^>^&^1>"%ProgFolder0%\$RAS.cmd"
ECHO.%REG% add "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /v "ImagePath" /t REG_EXPAND_SZ /d "%%%%SystemRoot%%%%\servicing\TrustedInstaller.exe" /f^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
ECHO.DEL /Q /F "%ProgFolder0%\$RAS.cmd"^>NUL^&EXIT>>"%ProgFolder0%\$RAS.cmd"
IF NOT "%WINPE_BOOT%"=="1" NET START $RAS>NUL 2>&1
IF "%WINPE_BOOT%"=="1" CALL %CMD% /C "%ProgFolder0%\$RAS.cmd"
EXIT /B
:RAS_DELETE
IF "%WINPE_BOOT%"=="1" EXIT /B
FOR /F "TOKENS=1 DELIMS= " %%a IN ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\SERVICES\$RAS" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" SC DELETE $RAS>NUL 2>&1)
EXIT /B
:ARRAY_ITEM
SET "$IFELSE="
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=$QCLM2$"&&SET "$NULLED=1"&&CALL:EXPAND_INPUT
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM4!"&&SET "$OUTPUT=ACTN"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!"&&SET "$OUTPUT=MATCH"&&SET "$NULLED=1"&&CALL:EXPANDOFLEX
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH1$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.S=!$ACTN1$!"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "$IFELSE=1"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH2$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.S=!$ACTN2$!"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "$IFELSE=2"
IF /I NOT "!ACTN3!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH3$!" SET "!$QCLM1$!.I=3"&&SET "!$QCLM1$!.S=!$ACTN3$!"&&SET "!$QCLM1$!.3=!$ACTN3$!"&&SET "$IFELSE=3"
IF /I NOT "!ACTN4!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH4$!" SET "!$QCLM1$!.I=4"&&SET "!$QCLM1$!.S=!$ACTN4$!"&&SET "!$QCLM1$!.4=!$ACTN4$!"&&SET "$IFELSE=4"
IF /I NOT "!ACTN5!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH5$!" SET "!$QCLM1$!.I=5"&&SET "!$QCLM1$!.S=!$ACTN5$!"&&SET "!$QCLM1$!.5=!$ACTN5$!"&&SET "$IFELSE=5"
IF /I NOT "!ACTN6!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH6$!" SET "!$QCLM1$!.I=6"&&SET "!$QCLM1$!.S=!$ACTN6$!"&&SET "!$QCLM1$!.6=!$ACTN6$!"&&SET "$IFELSE=6"
IF /I NOT "!ACTN7!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH7$!" SET "!$QCLM1$!.I=7"&&SET "!$QCLM1$!.S=!$ACTN7$!"&&SET "!$QCLM1$!.7=!$ACTN7$!"&&SET "$IFELSE=7"
IF /I NOT "!ACTN8!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH8$!" SET "!$QCLM1$!.I=8"&&SET "!$QCLM1$!.S=!$ACTN8$!"&&SET "!$QCLM1$!.8=!$ACTN8$!"&&SET "$IFELSE=8"
IF /I NOT "!ACTN9!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH9$!" SET "!$QCLM1$!.I=9"&&SET "!$QCLM1$!.S=!$ACTN9$!"&&SET "!$QCLM1$!.9=!$ACTN9$!"&&SET "$IFELSE=9"
IF NOT DEFINED $QCLM5$ EXIT /B
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM5!"&&SET "$OUTPUT=ELSE"&&CALL:EXPANDOFLEX
IF /I NOT "!ELSE1!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH1$!" SET "!$QCLM1$!.1=!$ELSE1$!"&&IF "!$IFELSE!"=="1" SET "!$QCLM1$!.S=!$ELSE1$!"
IF /I NOT "!ELSE2!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH2$!" SET "!$QCLM1$!.2=!$ELSE2$!"&&IF "!$IFELSE!"=="2" SET "!$QCLM1$!.S=!$ELSE2$!"
IF /I NOT "!ELSE3!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH3$!" SET "!$QCLM1$!.3=!$ELSE3$!"&&IF "!$IFELSE!"=="3" SET "!$QCLM1$!.S=!$ELSE3$!"
IF /I NOT "!ELSE4!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH4$!" SET "!$QCLM1$!.4=!$ELSE4$!"&&IF "!$IFELSE!"=="4" SET "!$QCLM1$!.S=!$ELSE4$!"
IF /I NOT "!ELSE5!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH5$!" SET "!$QCLM1$!.5=!$ELSE5$!"&&IF "!$IFELSE!"=="5" SET "!$QCLM1$!.S=!$ELSE5$!"
IF /I NOT "!ELSE6!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH6$!" SET "!$QCLM1$!.6=!$ELSE6$!"&&IF "!$IFELSE!"=="6" SET "!$QCLM1$!.S=!$ELSE6$!"
IF /I NOT "!ELSE7!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH7$!" SET "!$QCLM1$!.7=!$ELSE7$!"&&IF "!$IFELSE!"=="7" SET "!$QCLM1$!.S=!$ELSE7$!"
IF /I NOT "!ELSE8!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH8$!" SET "!$QCLM1$!.8=!$ELSE8$!"&&IF "!$IFELSE!"=="8" SET "!$QCLM1$!.S=!$ELSE8$!"
IF /I NOT "!ELSE9!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH9$!" SET "!$QCLM1$!.9=!$ELSE9$!"&&IF "!$IFELSE!"=="9" SET "!$QCLM1$!.S=!$ELSE9$!"
EXIT /B
:ROUTINE_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (SPLIT COMMAND) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not SPLIT or COMMAND.&&EXIT /B
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=ROUT"&&CALL:EXPANDOFLEX
IF /I "!$QCLM3$!"=="COMMAND" FOR %%□ IN ($ROUT1$ $ROUT2$) DO (IF NOT DEFINED %%□ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 is not valid. Example: '^<^>❗DIR C:\ /B❗1❗TEST.TXT' or '^<^>❗DIR C:\ /B'&&EXIT /B)
IF /I "!$QCLM3$!"=="SPLIT" FOR %%□ IN ($ROUT1$ $ROUT2$) DO (IF NOT DEFINED %%□ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 is not valid. Example: ':❗A:B:C❗3❗C' or ':❗A:B:C'&&EXIT /B)
SET "$TOKENS=9"&&FOR /F "TOKENS=1 DELIMS=*" %%● IN ("!$QCLM4$!") DO (IF NOT "%%●"=="!$QCLM4$!" SET "$QCLM4$=%%●"&&SET "$TOKENS=%%●"&&SET /A "$TOKENS-=1"&&SET "$TOKENS=!$TOKENS!*")
IF /I "!$QCLM3$!"=="COMMAND" FOR /F "TOKENS=1-%$TOKENS% DELIMS=%$ROUT1$%" %%1 in ('!$ROUT2$! 2^>NUL') DO (
IF NOT DEFINED $ROUT3$ SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.1=%%%$QCLM4$%"&&SET /A "!$QCLM1$!.I=1"
IF DEFINED $ROUT3$ IF /I "!$ROUT4$!"=="%%%$ROUT3$%" SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.1=%%%$QCLM4$%"&&SET "!$QCLM1$!.I=1")
IF /I "!$QCLM3$!"=="SPLIT" FOR /F "TOKENS=1-%$TOKENS% DELIMS=%$ROUT1$%" %%1 in ("!$ROUT2$!") DO (
IF NOT "%%1"=="" SET "!$QCLM1$!.1=%%1"&&IF NOT "%%2"=="" SET "!$QCLM1$!.2=%%2"&&IF NOT "%%3"=="" SET "!$QCLM1$!.3=%%3"&&IF NOT "%%4"=="" SET "!$QCLM1$!.4=%%4"&&IF NOT "%%5"=="" SET "!$QCLM1$!.5=%%5"&&IF NOT "%%6"=="" SET "!$QCLM1$!.6=%%6"&&IF NOT "%%7"=="" SET "!$QCLM1$!.7=%%7"&&IF NOT "%%8"=="" SET "!$QCLM1$!.8=%%8"&&IF NOT "%%9"=="" SET "!$QCLM1$!.9=%%9"
IF NOT DEFINED $ROUT3$ SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET /A "!$QCLM1$!.I=!$QCLM4$!"
IF DEFINED $ROUT3$ IF /I "!$ROUT4$!"=="%%%$ROUT3$%" SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.I=!$QCLM4$!")
EXIT /B
:MATH_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (+ - /) DO (IF "!$QCLM3$!"=="*" SET "$PASS=1"
IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 OPERATION is not *, /, +, or -.&&EXIT /B
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET /A "!$QCLM1$!.I=1"&&SET /A "!$QCLM1$!.S=!$QCLM2$!"&&SET /A "!$QCLM1$!.S!$QCLM3$!=!$QCLM4$!"&&SET /A "!$QCLM1$!.1=!$QCLM1$!.S!"
EXIT /B
:CONDIT_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=COND"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (EXIST NEXIST DEFINED NDEFINED EQ NE LE GE GT LT) DO (IF /I "!$COND2$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 CONDITION is not EQ, NE, LE, GE, GT, LT, EXIST, NEXIST, DEFINED or NDEFINED. Example: 'c:\❗EXIST' or '1❗EQ❗1' or 'CHOICE1❗DEFINED'&&EXIT /B
FOR %%□ IN (EQ NE LE GE GT LT) DO (IF /I "!$COND2$!"=="%%□" IF NOT DEFINED $COND3$ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 3 COMPARE is not specified. Example: '1❗EQ❗1'&&EXIT /B)
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!%U01%!QCLM4!"&&SET "$OUTPUT=ACTN"&&CALL:EXPANDOFLEX
IF DEFINED $ACTN2$ FOR %%□ IN (EQ NE LE GE GT LT) DO (IF /I "!$COND2$"=="%%□" SET /A "$COND1$=!$COND1$!"&&SET /A "$COND3$=!$COND3$!")
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="DEFINED" IF DEFINED !$COND1$! SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="DEFINED" IF NOT DEFINED !$COND1$! SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="NDEFINED" IF NOT DEFINED !$COND1$! SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="NDEFINED" IF DEFINED !$COND1$! SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="EXIST" IF EXIST "!$COND1$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="EXIST" IF NOT EXIST "!$COND1$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="NEXIST" IF NOT EXIST "!$COND1$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="NEXIST" IF EXIST "!$COND1$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="EQ" IF /I "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="EQ" IF /I NOT "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="NE" IF /I NOT "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="NE" IF /I "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="LE" IF "!$COND1$!" LEQ "!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="LE" IF NOT "!$COND1$!" LEQ "!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="GE" IF "!$COND1$!" GEQ "!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="GE" IF NOT "!$COND1$!" GEQ "!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="GT" IF "!$COND1$!" GTR "!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="GT" IF NOT "!$COND1$!" GTR "!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="LT" IF "!$COND1$!" LSS "!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="LT" IF NOT "!$COND1$!" LSS "!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
EXIT /B
:FILEOPER_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$FILE_OBJ="&&SET "$PASS="&&FOR %%□ IN (CREATE DELETE RENAME COPY MOVE TAKEOWN) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not CREATE, DELETE, RENAME, COPY, MOVE, or TAKEOWN.&&EXIT /B
FOR /F "TOKENS=*" %%a in ("!$QCLM3$!") DO (SET "$FILEOPER=%%a"&&SET "$RAS=%%b")
FOR /F "TOKENS=1-4 DELIMS=%U01%" %%a in ("!$QCLM2$!") DO (SET "$OBJONE=%%a"&&SET "$OBJTWO=%%b")
IF /I "%$FILEOPER%"=="COPY" IF NOT DEFINED $OBJTWO ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 OBJ_TAR is not specified.&&EXIT /B
IF /I "%$FILEOPER%"=="MOVE" IF NOT DEFINED $OBJTWO ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 OBJ_TAR is not specified.&&EXIT /B
IF /I "%$FILEOPER%"=="RENAME" IF NOT DEFINED $OBJTWO ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 OBJ_TAR is not specified.&&EXIT /B
SET "$EXIT="&&FOR %%□ IN (DELETE RENAME COPY MOVE TAKEOWN) DO (IF /I "%$FILEOPER%"=="%%□" IF NOT EXIST "!$OBJONE!" SET "$EXIT=1"&&IF NOT DEFINED @QUIET ECHO.%COLOR4%ERROR:%$$% !$OBJONE! doesn't exist.)
IF /I "%$FILEOPER%"=="CREATE" IF EXIST "!$OBJONE!" SET "$EXIT=1"&&IF NOT DEFINED @QUIET ECHO.%COLOR4%ERROR:%$$% !$OBJONE! already exists.
IF DEFINED $EXIT EXIT /B
IF EXIST "!$OBJONE!\*" SET "$FILE_OBJ=FOLD"
IF NOT EXIST "!$OBJONE!\*" SET "$FILE_OBJ=FILE"
IF /I "%$FILEOPER%"=="CREATE" SET "$FILE_OBJ=FOLD"
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF /I "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF /I "!$RAS!"=="RAS" SET "RUN_AS=system"
IF /I "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% !$FILEOPER! !$FILE_OBJ! !$OBJONE! as %##%%RUN_AS%%$$%!
IF /I "%$FILEOPER%"=="CREATE" IF /I "%$FILE_OBJ%"=="FOLD" MD "\\?\!$OBJONE!">NUL 2>&1
IF /I "%$FILEOPER%"=="DELETE" IF /I "%$FILE_OBJ%"=="FOLD" IF EXIST "!$OBJONE!" RD /S /Q "\\?\!$OBJONE!"
IF /I "%$FILEOPER%"=="DELETE" IF /I "%$FILE_OBJ%"=="FILE" IF EXIST "!$OBJONE!" DEL /Q /F "\\?\!$OBJONE!"
IF /I "%$FILEOPER%"=="RENAME" IF /I "%$FILE_OBJ%"=="FILE" REN "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF /I "%$FILEOPER%"=="RENAME" IF /I "%$FILE_OBJ%"=="FOLD" REN "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF /I "%$FILEOPER%"=="COPY" IF /I "%$FILE_OBJ%"=="FILE" XCOPY "!$OBJONE!" "!$OBJTWO!" /C /Y>NUL 2>&1
IF /I "%$FILEOPER%"=="COPY" IF /I "%$FILE_OBJ%"=="FOLD" XCOPY "!$OBJONE!" "!$OBJTWO!\" /E /C /I /Y>NUL 2>&1
IF /I "%$FILEOPER%"=="MOVE" IF /I "%$FILE_OBJ%"=="FILE" MOVE /Y "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF /I "%$FILEOPER%"=="MOVE" IF /I "%$FILE_OBJ%"=="FOLD" MOVE /Y "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF /I "%$FILEOPER%"=="TAKEOWN" IF /I "%$FILE_OBJ%"=="FILE" TAKEOWN /F "!$OBJONE!">NUL 2>&1
IF /I "%$FILEOPER%"=="TAKEOWN" IF /I "%$FILE_OBJ%"=="FOLD" TAKEOWN /F "!$OBJONE!" /R /D Y>NUL 2>&1
IF /I "%$FILEOPER%"=="TAKEOWN" IF DEFINED $FILE_OBJ ICACLS "!$OBJONE!" /grant %USERNAME%:F /T>NUL 2>&1
EXIT /B
:REGISTRY_ITEM
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$REG_OBJ="&&SET "$PASS="&&FOR %%□ IN (CREATE DELETE IMPORT EXPORT IMPORT%U01%RAS IMPORT%U01%RATI EXPORT%U01%RAS EXPORT%U01%RATI CREATE%U01%RAS CREATE%U01%RATI DELETE%U01%RAS DELETE%U01%RATI) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not CREATE, DELETE, IMPORT, EXPORT, CREATE%U01%RAS, CREATE%U01%RATI, DELETE%U01%RAS, or DELETE%U01%RATI.&&EXIT /B
FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$QCLM3$!") DO (SET "$QCLM3$=%%a"&&SET "$REG_OPER=%%a"&&SET "$RAS=%%b")
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=RCLM"&&CALL:EXPANDOFLEX
SET "$REG_KEY=!$RCLM1$!"&&SET "$REG_VAL=!$RCLM2$!"&&SET "$REG_TYPE=!$RCLM4$!"
IF DEFINED RCLM3 SET "$RCLM3$=!RCLM3:%%=％!"&&SET "$RCLM3$=!$RCLM3$:◁=%%!"&&SET "$RCLM3$=!$RCLM3$:▷=%%!"&&SET "$RCLM3$=!$RCLM3$:＄=$!"&&FOR /F "TOKENS=* DELIMS=" %%● in ("!$RCLM3$!") DO (CALL SET "$RCLM3$=%%●"&&SET "$RCLM3$=!$RCLM3$:％=%%!")
IF DEFINED $RCLM3$ SET "$REG_DAT=!$RCLM3$:"=""!"
IF /I "%$REG_OPER%"=="IMPORT" IF DEFINED $REG_KEY IF NOT EXIST "!$REG_KEY!" ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 .reg file does not exist.&&EXIT /B
IF /I "%$REG_OPER%"=="IMPORT" IF NOT DEFINED $REG_KEY ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 .reg file location is not specified.&&EXIT /B
IF /I "%$REG_OPER%"=="EXPORT" IF DEFINED $REG_KEY IF NOT DEFINED $REG_VAL ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 "REG KEY" is not specified.&&EXIT /B
IF /I "%$REG_OPER%"=="EXPORT" IF NOT DEFINED $REG_KEY ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 .reg "file location" is not specified.&&EXIT /B
IF /I "%$REG_OPER%"=="CREATE" IF DEFINED $REG_VAL IF NOT DEFINED $REG_DAT ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 3 "registry value data" is not specified.&&EXIT /B
IF /I "%$REG_OPER%"=="CREATE" IF DEFINED $REG_VAL SET "$PASS="&&FOR %%□ IN (DWORD QWORD BINARY STRING EXPAND MULTI) DO (IF /I "!$REG_TYPE!"=="%%□" SET "$PASS=1")
IF /I "%$REG_OPER%"=="CREATE" IF DEFINED $REG_VAL IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 4 "registry value type" is not DWORD, QWORD, BINARY, STRING, EXPAND, or MULTI.&&EXIT /B
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF /I "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF /I "!$RAS!"=="RAS" SET "RUN_AS=system"
IF /I "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
IF /I "%$REG_OPER%"=="IMPORT" GOTO:REGISTRY_ITEM_END
IF /I "%$REG_OPER%"=="EXPORT" GOTO:REGISTRY_ITEM_END
IF DEFINED $REG_VAL SET "$REG_OBJ=VAL"
IF NOT DEFINED $REG_VAL SET "$REG_OBJ=KEY"
IF /I "%$REG_TYPE%"=="DWORD" SET "$REG_TYPEX=REG_DWORD"
IF /I "%$REG_TYPE%"=="QWORD" SET "$REG_TYPEX=REG_QWORD"
IF /I "%$REG_TYPE%"=="BINARY" SET "$REG_TYPEX=REG_BINARY"
IF /I "%$REG_TYPE%"=="STRING" SET "$REG_TYPEX=REG_SZ"
IF /I "%$REG_TYPE%"=="EXPAND" SET "$REG_TYPEX=REG_EXPAND_SZ"
IF /I "%$REG_TYPE%"=="MULTI" SET "$REG_TYPEX=REG_MULTI_SZ"
IF /I "!$REG_DAT!"=="◁NULL▷" SET "$REG_DAT="
IF /I "!$REG_VAL!"=="◁NULL▷" SET "$REG_VAL="&&SET "$REG_TYPEX=REG_SZ"
IF NOT DEFINED @QUIET IF /I "%$REG_OBJ%"=="KEY" ECHO.Executing %@@%!$QCLM1$!%$$% !$REG_OPER! as %##%%RUN_AS%%$$% key !$REG_KEY!
IF NOT DEFINED @QUIET IF /I "%$REG_OBJ%"=="VAL" ECHO.Executing %@@%!$QCLM1$!%$$% !$REG_OPER! as %##%%RUN_AS%%$$% key !$REG_KEY! value !$REG_VAL!
IF /I "%$REG_OPER%"=="DELETE" IF /I "%$REG_OBJ%"=="KEY" IF NOT DEFINED $RAS %CMD% /C %REG% DELETE "!$REG_KEY!" /f>NUL
IF /I "%$REG_OPER%"=="DELETE" IF /I "%$REG_OBJ%"=="VAL" IF NOT DEFINED $RAS %CMD% /C %REG% DELETE "!$REG_KEY!" /v "!$REG_VAL!" /f>NUL
IF /I "%$REG_OPER%"=="CREATE" IF /I "%$REG_OBJ%"=="KEY" IF NOT DEFINED $RAS %CMD% /C %REG% ADD "!$REG_KEY!" /f>NUL
IF /I "%$REG_OPER%"=="CREATE" IF /I "%$REG_OBJ%"=="VAL" IF NOT DEFINED $RAS %CMD% /C %REG% ADD "!$REG_KEY!" /v "!$REG_VAL!" /t "!$REG_TYPEX!" /d "!$REG_DAT!" /f>NUL
IF /I "%$REG_OPER%"=="DELETE" IF /I "%$REG_OBJ%"=="KEY" IF DEFINED $RAS ECHO.%CMD% /C %REG% DELETE "!$REG_KEY!" /f ^>NUL>"$LIST"
IF /I "%$REG_OPER%"=="DELETE" IF /I "%$REG_OBJ%"=="VAL" IF DEFINED $RAS ECHO.%CMD% /C %REG% DELETE "!$REG_KEY!" /v "!$REG_VAL!" /f ^>NUL>"$LIST"
IF /I "%$REG_OPER%"=="CREATE" IF /I "%$REG_OBJ%"=="KEY" IF DEFINED $RAS ECHO.%CMD% /C %REG% ADD "!$REG_KEY!" /f ^>NUL>"$LIST"
IF /I "%$REG_OPER%"=="CREATE" IF /I "%$REG_OBJ%"=="VAL" IF DEFINED $RAS ECHO.%CMD% /C %REG% ADD "!$REG_KEY!" /v "!$REG_VAL!" /t "!$REG_TYPEX!" /d "!$REG_DAT!" /f ^>NUL>"$LIST"
:REGISTRY_ITEM_END
IF /I "%$REG_OPER%"=="IMPORT" IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% !$REG_OPER! as %##%%RUN_AS%%$$%
IF /I "%$REG_OPER%"=="EXPORT" IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% !$REG_OPER! as %##%%RUN_AS%%$$%
IF /I "%$REG_OPER%"=="IMPORT" IF NOT DEFINED $RAS %CMD% /C %REG% IMPORT "!$REG_KEY!" >NUL 2>&1
IF /I "%$REG_OPER%"=="IMPORT" IF DEFINED $RAS ECHO.%CMD% /C %REG% IMPORT "!$REG_KEY!" ^>NUL>"$LIST"
IF /I "%$REG_OPER%"=="EXPORT" IF NOT DEFINED $RAS %CMD% /C %REG% EXPORT "!$REG_KEY!" "!$REG_VAL!" /Y>NUL 2>&1
IF /I "%$REG_OPER%"=="EXPORT" IF DEFINED $RAS ECHO.%CMD% /C %REG% EXPORT "!$REG_KEY!" "!$REG_VAL!" /Y^>NUL>"$LIST"
IF DEFINED $RAS SET "$QCLM1$=COMMAND"&&SET "$QCLM3$=NORMAL"&&CALL:RASTI_CREATE
EXIT /B
:COMMAND_ITEM
SET "$INPUT=!COLUMN3!"&&SET "$OUTPUT=COLUMN3"&&CALL:EXPAND_INPUT
SET "$PASS="&&FOR %%□ IN (NORMAL NOMOUNT NORMAL%U01%RAU NORMAL%U01%RAS NORMAL%U01%RATI NOMOUNT%U01%RAU NOMOUNT%U01%RAS NOMOUNT%U01%RATI) DO (IF /I "!COLUMN3!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not NORMAL, NOMOUNT, NORMAL%U01%RAU, NORMAL%U01%RAS, NORMAL%U01%RATI, NOMOUNT%U01%RAU, NOMOUNT%U01%RAS, or NOMOUNT%U01%RATI.&&EXIT /B
IF /I "!COLUMN3!"=="NOMOUNT" CALL:IF_LIVE_MIX
IF /I "!COLUMN3!"=="NORMAL" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$QCLM3$!") DO (SET "$QCLM3$=%%a"&&SET "$RAS=%%b")
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF /I "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF /I "!$RAS!"=="RAS" SET "RUN_AS=system"
IF /I "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
IF DEFINED COLUMN0 SET "$COLUMN0=!COLUMN0:%%=％!"&&SET "$COLUMN0=!$COLUMN0:◁=%%!"&&SET "$COLUMN0=!$COLUMN0:▷=%%!"&&SET "$COLUMN0=!$COLUMN0:＄=$!"&&SET "$COLUMN0=!$COLUMN0:％=%%!"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ("!$COLUMN0!") DO (SET "$COLUMN2=%%b")
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% as %##%%RUN_AS%%$$% !$COLUMN2!
IF DEFINED $RAS ECHO.!$COLUMN2!>"$LIST"
IF DEFINED $RAS CALL:RASTI_CREATE
IF NOT DEFINED $RAS %CMD% /C !$COLUMN2!
SET "$COLUMN0="&&SET "$COLUMN2="
EXIT /B
:EXTPACKAGE_ITEM
CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (INSTALL) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not INSTALL.&&EXIT /B
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (SET "EXTPACKAGE=%PackFolder%\%%□"
IF NOT EXIST "%PackFolder%\%%□" ECHO.%COLOR4%ERROR:%$$% %PackFolder%\%%□ doesn't exist.&&EXIT /B)
SET "PACK_GOOD=The operation completed successfully"
FOR %%G in ("%EXTPACKAGE%") DO (SET "PACKFULL=%%~nG%%~xG"&&SET "PACKEXT=%%~xG")
IF /I "%PACKEXT%"==".PKX" CALL %CMD% /C ""%ProgFolder%\gploy.cmd" -IMAGEMGR -RUN -PACK "%$QCLM2$%" -path "%DrvTar%""&EXIT /B
FOR %%G in (APPXBUNDLE MSIXBUNDLE) DO (IF /I "%PACKEXT%"==".%%G" SET "PACKEXT=.APPX")
IF NOT DEFINED @QUIET ECHO.Installing %@@%%PACKFULL%%$$%...
IF /I "%PACKEXT%"==".APPX" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ADD-PROVISIONEDAPPXPACKAGE /PACKAGEPATH:"%EXTPACKAGE%" 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" ECHO.%COLOR5%%PACK_GOOD%.%$$%&&EXIT /B)
IF /I "%PACKEXT%"==".APPX" FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ADD-PROVISIONEDAPPXPACKAGE /PACKAGEPATH:"%EXTPACKAGE%" /SKIPLICENSE 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF "%%1"=="%PACK_GOOD%" EXIT /B)
IF /I "%PACKEXT%"==".APPX" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF /I "%PACKEXT%"==".CAB" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ADD-PACKAGE /PACKAGEPATH:"%EXTPACKAGE%" 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF "%%1"=="%PACK_GOOD%" EXIT /B)
IF /I "%PACKEXT%"==".CAB" GOTO:CAB_EXEC
IF /I "%PACKEXT%"==".MSU" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ADD-PACKAGE /PACKAGEPATH:"%EXTPACKAGE%" 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF "%%1"=="%PACK_GOOD%" EXIT /B)
IF /I "%PACKEXT%"==".MSU" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
EXIT /B
:PKX_EXEC
IF EXIST "%ProgFolder%\$PKX" ECHO.%COLOR4%ERROR:%$$% A package is already in session. Delete the $PKX folder before proceeding.&&EXIT /B
FOR %%G in ("%$PACK_FILE%") DO (SET "PKX_NAME=%%~nG%%~xG")
SET "PkxFolder=%ProgFolder%\$PKX"&&MD "%ProgFolder%\$PKX">NUL 2>&1
FOR /F "TOKENS=*" %%□ IN ("%PKX_NAME%") DO (ECHO.Extracting %@@%%%□%$$%...)
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%$PACK_FILE%" /INDEX:1 /APPLYDIR:"%ProgFolder%\$PKX">NUL 2>&1
IF NOT EXIST "%ProgFolder%\$PKX\package.list" ECHO.%COLOR2%ERROR:%$$% Package is either missing package.list or unable to extract.
SET "ListFolder=%ProgFolder%\$PKX"&&SET "PackFolder=%ProgFolder%\$PKX"&&SET "CacheFolder=%ProgFolder%\$PKX"&&IF EXIST "%ProgFolder%\$PKX\package.list" SET "$LIST_FILE=%ProgFolder%\$PKX\package.list"&&CALL:LIST_EXEC
CD /D "%ProgFolder0%">NUL
FOR %%a in ($PACK_FILE PkxFolder PKX_NAME) DO (SET "%%a=")
IF EXIST "%ProgFolder%\$PKX" SET "FOLDER_DEL=%ProgFolder%\$PKX"&&CALL:FOLDER_DEL
IF EXIST "%ProgFolder%\$PKX" ECHO.%COLOR4%ERROR:%$$% Unable to complete package cleanup as the package is still active. Do not spawn commands asynchronously.
IF NOT EXIST "%ProgFolder%\$PKX" CALL:CLEAN
EXIT /B
:CAB_EXEC
IF EXIST "%ProgFolder%\$CAB" ECHO.%COLOR4%ERROR:%$$% A package is already in session. Delete the $CAB folder before proceeding.&&EXIT /B
IF EXIST "%ProgFolder%\$CAB" SET "FOLDER_DEL=%ProgFolder%\$CAB"&&CALL:FOLDER_DEL
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%PACKFULL%") DO (ECHO.Extracting %@@%%%□%$$%...)
MD "%ProgFolder%\$CAB">NUL 2>&1
EXPAND "%EXTPACKAGE%" -F:* "%ProgFolder%\$CAB">NUL 2>&1
SET "$QCLM2$=%ProgFolder%\$CAB"&&CALL:DRVR_INSTALL
IF EXIST "%ProgFolder%\$CAB" SET "FOLDER_DEL=%ProgFolder%\$CAB"&&CALL:FOLDER_DEL
EXIT /B
:APPX_ITEM
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing AppX %@@%%%□%$$%...)
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%$QCLM2$%"&&CALL:CAPS_SET
IF DEFINED APPX_SKIP SET "CAPS_SET=APPX_SKIPX"&&SET "CAPS_VAR=%APPX_SKIP%"&&CALL:CAPS_SET
IF DEFINED APPX_SKIP FOR %%1 in (%APPX_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" ECHO.%COLOR4%The operation has been skipped.%$$%&&GOTO:APPX_END)
FOR /F "TOKENS=1-1* DELIMS=\" %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications" /F "%$QCLM2$%" 2^>NUL') DO (IF "%%a"=="HKEY_LOCAL_MACHINE" SET "APPX_KEY=%%a\%%b"&&CALL:APPX_NML)
IF NOT DEFINED APPX_KEY FOR /F "TOKENS=1-1* DELIMS=\" %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications" /F "%$QCLM2$%" 2^>NUL') DO (IF "%%a"=="HKEY_LOCAL_MACHINE" SET "APPX_KEY=%%a\%%b"&&CALL:APPX_IBX)
IF NOT DEFINED APPX_KEY IF NOT DEFINED APPX_DONE FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% AppX %%□ doesn't exist.)
IF DEFINED APPX_KEY IF NOT DEFINED APPX_DONE FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR2%ERROR:%$$% AppX %%□ is a stub or unable to remove.)
:APPX_END
FOR %%a in (APPX_DONE APPX_PATH APPX_VER APPX_KEY) DO (SET "%%a=")
EXIT /B
:APPX_NML
FOR /F "TOKENS=1-9 SKIP=2 DELIMS=\ " %%a in ('%REG% QUERY "%APPX_KEY%" /V Path 2^>NUL') DO (IF "%%a"=="Path" SET "APPX_PATH=%DrvTar%\Program Files\WindowsApps\%%g")
FOR /F "TOKENS=1-3* DELIMS=_" %%a IN ("%APPX_KEY%") DO (SET "APPX_VER=%%d")
IF DEFINED APPX_PATH IF DEFINED APPX_VER CALL:IF_LIVE_MIX
IF DEFINED APPX_PATH IF DEFINED APPX_VER FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /REMOVE-Provisionedappxpackage /PACKAGENAME:"%$QCLM2$%_%APPX_VER%" 2^>NUL') DO (
IF "%%1"=="The operation completed successfully" SET "APPX_DONE=1"&&IF NOT DEFINED @QUIET ECHO.%COLOR5%%%1.%$$%
IF "%%1"=="The operation completed successfully" IF EXIST "%APPX_PATH%\*" SET "FOLDER_DEL=%APPX_PATH%"&&CALL:FOLDER_DEL)
IF DEFINED APPX_DONE CALL:IF_LIVE_EXT
IF DEFINED APPX_DONE %REG% ADD "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%$QCLM2$%_%APPX_VER%" /f>NUL 2>&1
EXIT /B
:APPX_IBX
CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-9 SKIP=2 DELIMS=\ " %%a in ('%REG% QUERY "%APPX_KEY%" /V Path 2^>NUL') DO (IF "%%a"=="Path" SET "APPX_PATH=%DrvTar%\Windows\SystemApps\%%f")
FOR /F "TOKENS=1-3* DELIMS=_" %%a IN ("%APPX_KEY%") DO (SET "APPX_VER=%%d")
IF DEFINED APPX_PATH IF DEFINED APPX_VER FOR /F "TOKENS=1 DELIMS=." %%1 in ('%REG% DELETE "%APPX_KEY%" /F 2^>NUL') DO (IF "%%1"=="The operation completed successfully" SET "APPX_DONE=1"&&ECHO. %COLOR5%%%1.%$$%&&IF EXIST "%APPX_PATH%\*" SET "FOLDER_DEL=%APPX_PATH%"&&CALL:FOLDER_DEL&%REG% ADD "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%$QCLM2$%_%APPX_VER%" /f>NUL 2>&1)
EXIT /B
:CAPABILITY_ITEM
CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Capability %@@%%%□%$$%...)
SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /REMOVE-CAPABILITY /CAPABILITYNAME:"%$QCLM2$%" 2^>NUL') DO (IF "%%1"=="The operation completed successfully" CALL ECHO.%COLOR5%%%1.%$$%&&EXIT /B)
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Capability %%□ doesn't exist.)
EXIT /B
:COMPONENT_ITEM
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Component %@@%%%□%$$%...)
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%$QCLM2$%"&&CALL:CAPS_SET
IF DEFINED COMP_SKIP SET "CAPS_SET=COMP_SKIPX"&&SET "CAPS_VAR=%COMP_SKIP%"&&CALL:CAPS_SET
IF DEFINED COMP_SKIP FOR %%1 in (%COMP_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" ECHO.%COLOR4%The operation has been skipped.%$$%&&EXIT /B)
SET "X0Z="&&SET "COMP_XNT="&&SET "FNL_XNT="&&FOR /F "TOKENS=1* DELIMS=:~" %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /F "%$QCLM2$%" 2^>NUL') DO (IF NOT "%%a"=="" CALL SET /A "COMP_XNT+=1"&&CALL SET /A "FNL_XNT+=1"&&CALL SET "TX1=%%a"&&CALL SET "TX2=%%b"&&CALL:COMP_ITEM2)
EXIT /B
:COMP_ITEM2
IF "%X0Z%"=="%TX1%" EXIT /B
IF "%COMP_XNT%" GTR "1" EXIT /B
IF "%TX1%"=="End of search" FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Component %%□ doesn't exist.&&EXIT /B)
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
FOR %%a in (1 2 3 4 5 6 7 8 9) DO (CALL SET "COMP_Z%%a=")
SET "X0Z="&&SET "SUB_XNT="&&SET "COMP_FLAG="&&FOR /F "TOKENS=1* DELIMS=:~" %%1 IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /F "%$QCLM2$%" 2^>NUL') DO (IF NOT "%%1"=="" CALL SET /A "SUB_XNT+=1"&&CALL SET "X1=%%1"&&CALL SET "X2=%%2"&&CALL:COMP_DELETE)
EXIT /B
:COMP_AVOID
IF "%$QCLM2$%~%X2%"=="%COMPX%" SET "COMP_AVD=1"
EXIT /B
:COMP_DELETE
IF "%X1%"=="End of search" EXIT /B
IF "%FNL_XNT%" GTR "9" EXIT /B
IF "%SUB_XNT%" GTR "9" EXIT /B
IF "%X0Z%"=="%$QCLM2$%~%X2%" EXIT /B
SET "COMP_AVD="&&FOR %%a in (1 2 3 4 5 6 7 8 9) DO (CALL SET "COMPX=%%COMP_Z%%a%%"&&CALL:COMP_AVOID)
IF DEFINED COMP_AVD EXIT /B
SET "COMP_ABT=X"&&SET "COMP_ABT1="&&IF "%SAFE_EXCLUDE%"=="ENABLED" FOR /F "TOKENS=1-9 DELIMS=-" %%1 IN ("%$QCLM2$%") DO (IF "%%4"=="FEATURES" SET "COMP_ABT1=1")
SET "COMP_ABT2="&&IF "%SAFE_EXCLUDE%"=="ENABLED" FOR /F "TOKENS=1-9 DELIMS=-" %%1 IN ("%$QCLM2$%") DO (IF "%%5"=="REQUIRED" SET "COMP_ABT2=1")
SET "COMP_Z%FNL_XNT%=%$QCLM2$%~%X2%"&&SET "COMP_ABT3="&&FOR %%1 in (%COMP_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" SET "COMP_ABT3=1")
IF NOT DEFINED COMP_ABT1 IF NOT DEFINED COMP_ABT2 IF NOT DEFINED COMP_ABT3 SET "COMP_ABT="
SET /A "FNL_XNT+=1"&&SET "X0Z=%$QCLM2$%~%X2%"
IF NOT DEFINED COMP_FLAG IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Subcomp %@@%%%□~%X2%%$$%...)
IF DEFINED COMP_ABT IF "%FNL_XNT%"=="2" SET "COMP_FLAG=1"&&FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR2%ERROR:%$$% Component %%□ is required or unable to remove.)
IF DEFINED COMP_ABT EXIT /B
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
%REG% ADD "%X1%~%X2%" /V "Visibility" /T REG_DWORD /D "1" /F>NUL 2>&1
%REG% DELETE "%X1%~%X2%\Owners" /F>NUL 2>&1
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_MIX
SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /REMOVE-PACKAGE /PACKAGENAME:"%$QCLM2$%~%X2%" 2^>NUL') DO (SET "DISMSG="&&IF "%%1"=="The operation completed successfully" CALL SET "DISMSG=%%1.")
IF NOT DEFINED DISMSG FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR2%ERROR:%$$% Component %%□ is a stub or unable to remove.)
IF DEFINED DISMSG IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%DISMSG%") DO (ECHO.%COLOR5%%%□%$$%)
EXIT /B
:DRIVER_ITEM
CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (INSTALL DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not INSTALL or DELETE.&&EXIT /B)
IF /I "%$QCLM1$%:%$QCLM3$%:%$QCLM4$%"=="DRIVER:INSTALL:DX" CALL:DRVR_INSTALL
IF /I "%$QCLM1$%:%$QCLM3$%:%$QCLM4$%"=="DRIVER:DELETE:DX" CALL:DRVR_REMOVE
EXIT /B
:DRVR_INSTALL
SET "PACK_GOOD=The operation completed successfully"&&SET "PACK_BAD=The operation did not complete successfully"
FOR /F "TOKENS=*" %%a in ('DIR/S/B "%$QCLM2$%\*.INF" 2^>NUL') DO (
IF NOT EXIST "%%a\*" FOR %%G in ("%%a") DO (IF NOT DEFINED @QUIET CALL ECHO.Installing %@@%%%~nG.inf%$$%...)
IF NOT EXIST "%%a\*" IF DEFINED LIVE_APPLY SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('pnputil.exe /add-driver "%%a" /install 2^>NUL') DO (IF "%%1"=="Driver package added successfully" CALL SET "DISMSG=%PACK_GOOD%")
IF NOT EXIST "%%a\*" IF NOT DEFINED LIVE_APPLY SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /ADD-DRIVER /DRIVER:"%%a" /ForceUnsigned 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" CALL SET "DISMSG=%PACK_GOOD%")
IF NOT EXIST "%%a\*" IF DEFINED DISMSG IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF NOT EXIST "%%a\*" IF NOT DEFINED DISMSG ECHO.%COLOR2%ERROR:%$$% %PACK_BAD%.)
EXIT /B
:DRVR_REMOVE
SET "FILE_OUTPUT=$DRVR"
IF NOT DEFINED DRVR_QRY IF EXIST "$DRVR" DEL /Q /F "$DRVR">NUL 2>&1
FOR /F "TOKENS=1 DELIMS= " %%# in ("%$QCLM3$%") DO (CALL SET "$QCLM3$=%%#")
IF NOT EXIST "$DRVR" IF NOT DEFINED @QUIET ECHO.Getting driver listing...
IF NOT EXIST "$DRVR" SET "DRVR_QRY=1"&&FOR /F "TOKENS=1-9 DELIMS=|" %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-DRIVERS /FORMAT:TABLE 2^>NUL') DO (FOR /F "TOKENS=1 DELIMS= " %%# in ("%%a") DO (SET "X1=%%#")
FOR /F "TOKENS=1 DELIMS= " %%# in ("%%g") DO (SET "X3=%%#")
FOR /F "TOKENS=1 DELIMS= " %%# in ("%%b") DO (SET "CAPS_SET=X2"&&SET "CAPS_VAR=%%#"&&CALL:CAPS_SET&&CALL:FILE_OUTPUT))
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Driver %@@%%%□%$$%...)
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%$QCLM2$%"&&CALL:CAPS_SET
SET "DISMSG="&&IF EXIST "$DRVR" FOR /F "TOKENS=1-3 DELIMS=%U00%" %%a in ($DRVR) DO (IF NOT DEFINED @QUIET IF "%%b"=="%$QCLM2$%" ECHO.Uninstalling %@@%%%a%$$% v%%c...
IF "%%b"=="%$QCLM2$%" IF DEFINED LIVE_APPLY FOR /F "TOKENS=1 DELIMS=." %%1 in ('PNPUTIL.EXE /DELETE-DRIVER "%%a" /UNINSTALL /FORCE 2^>NUL') DO (IF "%%1"=="Driver package deleted successfully" SET "DISMSG=The operation completed successfully.")
IF "%%b"=="%$QCLM2$%" IF NOT DEFINED LIVE_APPLY FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /REMOVE-DRIVER /DRIVER:"%%a" 2^>NUL') DO (IF "%%1"=="The operation completed successfully" SET "DISMSG=%%1."))
IF NOT DEFINED DISMSG FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Driver %%□ doesn't exist.)
IF DEFINED DISMSG IF NOT DEFINED @QUIET ECHO.%COLOR5%%DISMSG%%$$%
EXIT /B
:FILE_OUTPUT
IF "%FILE_OUTPUT%"=="$FEAT" ECHO.%X1%%U00%%X2%>>"$FEAT"
IF "%FILE_OUTPUT%"=="$DRVR" ECHO.%X1%%U00%%X2%%U00%%X3%>>"$DRVR"
EXIT /B
:FEATURE_ITEM
CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (ENABLE DISABLE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not ENABLE or DISABLE.&&EXIT /B)
SET "FILE_OUTPUT=$FEAT"&&IF NOT DEFINED FEAT_QRY IF EXIST "$FEAT" DEL /Q /F "$FEAT">NUL 2>&1
IF NOT EXIST "$FEAT" IF NOT DEFINED @QUIET ECHO.Getting feature listing...
IF NOT EXIST "$FEAT" SET "FEAT_QRY=1"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS=| " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-FEATURES /FORMAT:TABLE 2^>NUL') DO (FOR %%X in (Enabled Disabled) DO (IF "%%b"=="%%X" SET "CAPS_SET=X1"&&SET "CAPS_VAR=%%a"&&SET "X2=%%b"&&CALL:CAPS_SET&&CALL:FILE_OUTPUT))
IF /I "%$QCLM3$%"=="ENABLE" FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (IF NOT DEFINED @QUIET ECHO.Enabling Feature %@@%%%□%$$%... 
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%%□"&&CALL:CAPS_SET)
IF /I "%$QCLM3$%"=="DISABLE" FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (IF NOT DEFINED @QUIET ECHO.Disabling Feature %@@%%%□%$$%...
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%%□"&&CALL:CAPS_SET)
SET "FEAT="&&IF EXIST "$FEAT" FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ($FEAT) DO (IF "%%a"=="%$QCLM2$%" SET "FEAT=1"&&SET "X1=%%a"&&SET "X2=%%b")
IF NOT DEFINED FEAT FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Feature %%□ doesn't exist.&&EXIT /B)
IF /I "%$QCLM3$%"=="ENABLE" IF "%X2%"=="Enabled" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="ENABLE" IF "%X2%"=="Enabled" EXIT /B
IF /I "%$QCLM3$%"=="DISABLE" IF "%X2%"=="Disabled" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="DISABLE" IF "%X2%"=="Disabled" EXIT /B
IF /I "%$QCLM3$%"=="ENABLE" FOR /F "TOKENS=1 DELIMS=." %%■ in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ENABLE-FEATURE /FEATURENAME:"%$QCLM2$%" /ALL 2^>NUL') DO (
IF "%%■"=="The operation completed successfully" IF NOT DEFINED @QUIET ECHO.%COLOR5%%%■.%$$%
IF "%%■"=="The operation completed successfully" SET "X2=Enabled"&&CALL:FILE_OUTPUT&&EXIT /B)
IF /I "%$QCLM3$%"=="DISABLE" FOR /F "TOKENS=1 DELIMS=." %%■ in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /DISABLE-FEATURE /FEATURENAME:"%$QCLM2$%" /REMOVE 2^>NUL') DO (
IF "%%■"=="The operation completed successfully" IF NOT DEFINED @QUIET ECHO.%COLOR5%%%$.%$$%
IF "%%■"=="The operation completed successfully" SET "X2=Disabled"&&CALL:FILE_OUTPUT&&EXIT /B)
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Feature %%□ is a stub or unable to change.)
EXIT /B
:SERVICE_ITEM
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (AUTO MANUAL DISABLE DELETE) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not AUTO, MANUAL, DISABLE, or DELETE.&&EXIT /B
FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (FOR /F "TOKENS=*" %%■ IN ("%$QCLM2$%") DO (
IF /I "%%□"=="DELETE" IF NOT DEFINED @QUIET ECHO.Removing Service %@@%%%■%$$%...
IF /I NOT "%%□"=="DELETE" IF NOT DEFINED @QUIET ECHO.Changing start to %@@%%%□%$$% for Service %@@%%%■%$$%...
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%%■"&&CALL:CAPS_SET))
IF DEFINED SVC_SKIP SET "CAPS_SET=SVC_SKIPX"&&SET "CAPS_VAR=%SVC_SKIP%"&&CALL:CAPS_SET
IF DEFINED SVC_SKIP FOR %%1 in (%SVC_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" ECHO.%COLOR4%The operation has been skipped.%$$%&&EXIT /B)
SET "$GO="&&FOR /F "TOKENS=1-3 DELIMS= " %%a IN ('%REG% QUERY "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V Start 2^>NUL') DO (
IF "%%a"=="Start" SET "$GO=1"
IF /I "%$QCLM3$%"=="AUTO" IF "%%a"=="Start" IF "%%c"=="0x2" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="AUTO" IF "%%a"=="Start" IF "%%c"=="0x2" EXIT /B
IF /I "%$QCLM3$%"=="MANUAL" IF "%%a"=="Start" IF "%%c"=="0x3" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="MANUAL" IF "%%a"=="Start" IF "%%c"=="0x3" EXIT /B
IF /I "%$QCLM3$%"=="DISABLE" IF "%%a"=="Start" IF "%%c"=="0x4" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="DISABLE" IF "%%a"=="Start" IF "%%c"=="0x4" EXIT /B)
IF NOT DEFINED $GO FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Service %%□ doesn't exist.&&EXIT /B)
IF /I "%$QCLM3$%"=="DELETE" SET "$RAS=RATI"&&CALL:RASTI_CREATE
IF /I NOT "%$QCLM3$%"=="DELETE" SET "$RAS=RAS"&&CALL:RASTI_CREATE
FOR /F "TOKENS=1-3 DELIMS= " %%a IN ('%REG% QUERY "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V Start 2^>NUL') DO (
IF /I "%$QCLM3$%"=="AUTO" IF "%%a"=="Start" IF NOT "%%c"=="0x2" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF /I "%$QCLM3$%"=="MANUAL" IF "%%a"=="Start" IF NOT "%%c"=="0x3" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF /I "%$QCLM3$%"=="DISABLE" IF "%%a"=="Start" IF NOT "%%c"=="0x4" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF /I "%$QCLM3$%"=="DELETE" IF "%%a"=="Start" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B)
IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
EXIT /B
:TASK_ITEM
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Task %@@%%%□%$$%...)
SET "TASKID="&&FOR /F "TOKENS=1-4 DELIMS={} " %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /V Id 2^>NUL') DO (IF "%%a"=="Id" SET "TASKID=%%c")
IF NOT DEFINED TASKID FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Task %%□ doesn't exist.&&EXIT /B)
SET "$RAS=RAS"&&CALL:RASTI_CREATE
FOR /F "TOKENS=1 DELIMS= " %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /V Id 2^>NUL') DO (IF "%%a"=="Id" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B)
IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
EXIT /B
:WINSXS_ITEM
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF DEFINED LIVE_APPLY ECHO.%COLOR4%ERROR:%$$% OFFLINE IMAGE ONLY&&EXIT /B
IF NOT DEFINED SXS_SKIP SET "SXS_SKIP=amd64_microsoft-windows-s..cingstack.resources amd64_microsoft-windows-servicingstack amd64_microsoft.vc80.crt amd64_microsoft.vc90.crt amd64_microsoft.windows.c..-controls.resources amd64_microsoft.windows.common-controls amd64_microsoft.windows.gdiplus x86_microsoft.vc80.crt x86_microsoft.vc90.crt x86_microsoft.windows.c..-controls.resources x86_microsoft.windows.common-controls x86_microsoft.windows.gdiplus"
ECHO.&&ECHO.Removing %@@%WinSxS folder%$$%...&&SET "SUBZ="&&SET "SUBXNT="&&FOR /F "TOKENS=1-2* DELIMS=_" %%a IN ('DIR "%WinTar%\WinSxS" /A: /B /O:GN') DO (IF NOT "%%a"=="" SET "QUERYX=%%a_%%b"&&SET "SUBX=%%c"&&SET /A "SUBXNT+=1"&&CALL:LATERS_WINSXS)
EXIT /B
:LATERS_WINSXS
IF "%QUERYX%_%SUBX%"=="%SUBZ%" EXIT /B
FOR %%1 in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20) DO (IF %SUBXNT% EQU %%1500 CALL ECHO.WinSxS folder queue item %##%%%1500%$$%...
IF "%SUBXNT%"=="%%1000" CALL ECHO.WinSxS folder queue item %##%%%1000%$$%...)
SET "DNTX="&&FOR %%a in (%SXS_SKIP%) DO (IF "%QUERYX%"=="%%a" SET "DNTX=1")
SET "SUBZ=%QUERYX%_%SUBX%"&&SET "DNTX="&&FOR %%a in (%SXS_SKIP%) DO (IF "%QUERYX%"=="%%a" SET "DNTX=1")
IF NOT DEFINED DNTX (TAKEOWN /F "%WinTar%\WinSxS\%QUERYX%_%SUBX%" /R /D Y>NUL 2>&1
ICACLS "%WinTar%\WinSxS\%QUERYX%_%SUBX%" /grant %USERNAME%:F /T>NUL 2>&1
RD /Q /S "\\?\%WinTar%\WinSxS\%QUERYX%_%SUBX%" >NUL 2>&1) ELSE (ECHO.Keeping %@@%%QUERYX%_%SUBX%%$$%)
EXIT /B
:SCRO_CREATE
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
IF /I "%$QCLM4$%"=="SC" SET "SCRO=SetupComplete"
IF /I "%$QCLM4$%"=="RO" SET "SCRO=RunOnce"
IF NOT DEFINED %$QCLM4$%_PREPARE SET "%$QCLM4$%_PREPARE=1"&&CALL:SCRO_PREPARE
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("!$QCLM2$!") DO (ECHO.Scheduling %@@%%%□%$$% for %@@%%SCRO%%$$%...)
CALL:SCRO_DISPATCH
IF /I NOT "!$QCLM1$!"=="EXTPACKAGE" GOTO:SCRO_CREATE_SKIP
FOR /F "TOKENS=*" %%░ in ("!$QCLM2$!") DO (
IF EXIST "%PackFolder%\%%░" IF NOT DEFINED @QUIET ECHO.Copying Package %@@%%%░ for %##%%SCRO%%$$%...
IF EXIST "%PackFolder%\%%░" COPY /Y "%PackFolder%\%%░" "%DrvTar%\$">NUL
IF EXIST "%PackFolder%\%%░" ECHO.%U00%EXTPACKAGE%U00%%%░%U00%INSTALL%U00%DX%U00%>>"%DrvTar%\$\%SCRO%.list"
IF NOT EXIST "%PackFolder%\%%░" ECHO.%COLOR4%ERROR:%$$% %PackFolder%\%%░ doesn't exist.)
EXIT /B
:SCRO_CREATE_SKIP
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ("!COLUMN0!") DO (ECHO.%U00%%%a%U00%%%b%U00%%%c%U00%DX%U00%>>"%DrvTar%\$\%SCRO%.list")
EXIT /B
:SCRO_PREPARE
IF NOT EXIST "%DrvTar%\$" MD "%DrvTar%\$">NUL 2>&1
COPY /Y "%ProgFolder0%\gploy.cmd" "%DrvTar%\$">NUL 2>&1
IF NOT EXIST "%DrvTar%\$\%SCRO%.LIST" ECHO.MENU-SCRIPT>"%DrvTar%\$\%SCRO%.list"
IF "%SCRO%"=="RunOnce" %REG% add "%HiveSoftware%\Microsoft\Windows\CurrentVersion\RunOnce" /v "Runonce" /t REG_EXPAND_SZ /d "%%WINDIR%%\Setup\Scripts\RunOnce.cmd" /f>NUL 2>&1
IF NOT EXIST "%WinTar%\Setup\Scripts" MD "%WinTar%\Setup\Scripts">NUL 2>&1
ECHO.%%SYSTEMDRIVE%%\$\gploy.cmd -imagemgr -run -list %SCRO%.list -live>"%WinTar%\Setup\Scripts\%SCRO%.cmd"
ECHO.EXIT 0 >>"%WinTar%\Setup\Scripts\%SCRO%.cmd"
EXIT /B
:SESSION_CLEAR
SET "SCROXNT="&&CALL:VAR_CLEAR&&FOR %%▓ in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (FOR %%▒ in (SC RO) DO (IF DEFINED SESSION%%▒[%%▓] SET "SESSION%%▒[%%▓]="))
EXIT /B
:SCRO_DISPATCH
FOR %%● in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (
IF DEFINED SESSION%$QCLM4$%[%%●] ECHO.!SESSION%$QCLM4$%[%%●]!>>"%DrvTar%\$\%SCRO%.list"
IF DEFINED SESSION%$QCLM4$%[%%●] SET "SESSION%$QCLM4$%[%%●]=")
EXIT /B
:SCRO_QUEUE
SET /A "SCROXNT+=1"
FOR %%● in (SC RO) DO (SET "SESSION%%●[!SCROXNT!]=!COLUMN0!")
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:IMAGEMGR_BUILDER
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
SET "$BCLM3="&&SET "$BCLM1="&&SET "$BCLM4="&&SET "$HEAD="&&CALL:SETS_HANDLER&&CALL:CLEAN
SET "$HEADERS=                            %U13% List Builder%U01% %U01%                            Select an option"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %U13% Miscellaneous"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" CALL:LIST_MISCELLANEOUS&GOTO:IMAGEMGR_BUILDER
IF NOT DEFINED SELECT EXIT /B
IF NOT DEFINED $PICK GOTO:IMAGEMGR_BUILDER
IF NOT DEFINED ERROR SET "$LIST_FILE=%$PICK%"&&CALL:LIST_VIEWER
GOTO:IMAGEMGR_BUILDER
:LIST_COMBINE
IF EXIST "$LIST" FOR /F "TOKENS=1-1* SKIP=1 DELIMS=%U00%" %%a in ($LIST) DO (IF "%%a"=="GROUP" ECHO.>>"%$LIST_FILE%"
ECHO.%U00%%%a%U00%%%b>>"%$LIST_FILE%")
SET "$LIST_FILE="
EXIT /B
:LIST_MAKE
SET "$HEADERS=                            %U13% List Builder%U01% %U01%                            Create new list%U01% %U01% %U01% %U01%                        Enter name of new .LIST%U01% %U01% "&&SET "$SELECT=$LIST_NAME"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR SET "ERROR=LIST_MAKE"&&CALL:DEBUG&&EXIT /B
SET "$CHOICE=%$LIST_NAME%.list"&&ECHO.MENU-SCRIPT>"%ListFolder%\%$LIST_NAME%.list"
IF EXIST "%ListFolder%\%$CHOICE%" SET "$PICK=%ListFolder%\%$CHOICE%"
EXIT /B
:LIST_MISCELLANEOUS
CLS&&SET "IMAGE_LAST=IMAGE"&&CALL:SETS_MAIN&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP
ECHO.                            %U13% List Builder&&ECHO.&&ECHO.                             Miscellaneous&&ECHO.&&ECHO. (%##% 1 %$$%) %U13% Create Source Base&&ECHO. (%##% 2 %$$%) %U08% Generate Example Base&&ECHO. (%##% 3 %$$%) %U13% Convert Group Base&&ECHO. (%##% 4 %$$%) %U10% External Package Item&&ECHO.
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV
SET "$CHECK=NUMBER❗0-4"&&SET "$VERBOSE=1"&&SET "$SELECT=SELECTX"&&CALL:MENU_SELECT
IF NOT DEFINED SELECTX EXIT /B
IF "%SELECTX%"=="0" CALL:LIST_DIFFERENCER
IF "%SELECTX%"=="1" CALL:LIST_BASE_CREATE
IF "%SELECTX%"=="2" CALL:BASE_TEMPLATE
IF "%SELECTX%"=="3" CALL:LIST_CONVERT
IF "%SELECTX%"=="4" CALL:LIST_PACK_CREATE
GOTO:LIST_MISCELLANEOUS
:BASE_TEMPLATE
IF NOT DEFINED MENU_SKIP SET "$HEADERS= %U01% %U01% %U01% %U01%                        Enter name of new .base%U01% %U01% %U01% "&&SET "$SELECT=NEW_NAME"&&SET "$CHECK=PATH"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%EXAMPLE-BASE START:%$$%  %DATE%  %TIME%&&ECHO.&&ECHO.&&CALL:BASE_EXAMPLE>"%ListFolder%\%NEW_NAME%"
ECHO.                   Example base created successfully.&&ECHO.&&ECHO.&&ECHO.            %@@%EXAMPLE-BASE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:LIST_PACK_CREATE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                           %U13% Miscellaneous&&ECHO.
ECHO.                         External Package Item&&ECHO.&&ECHO.  %@@%AVAILABLE *.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLEs:%$$%&&ECHO.
SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST&&ECHO.&&ECHO.                        Multiples OK ( %##%1 2 3%$$% )
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF DEFINED ERROR EXIT /B
IF "%SELECT%"=="0" SET "FILE_TYPE=PACK"&&CALL:BASIC_FILE&EXIT /B
CALL:LIST_TIME
IF NOT DEFINED $BCLM4 EXIT /B
SET "$BCLM1=ExtPackage"&&SET "$BCLM3=Install"&&SET "LIST_START="&&FOR %%a in (%SELECT%) DO (CALL SET "ITEMX=%%$ITEM%%a%%"&&CALL SET "LIST_WRITE=%U00%%%$ITEM%%a%%%U00%"&&CALL:LIST_WRITE)
IF NOT DEFINED LIST_START SET "ERROR=1"&&EXIT /B
SET "$BCLM1="&&SET "$BCLM3="&&SET "$HEADERS=                            %U04% Append Items%U01% %U01%                             Select a list"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) Create new list"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" CALL:LIST_MAKE
IF NOT DEFINED $PICK EXIT /B
SET "$LIST_FILE=%$PICK%"&&CALL:LIST_COMBINE&&CALL:APPEND_SCREEN
EXIT /B
:LIST_WRITE
IF NOT DEFINED ITEMX EXIT /B
IF NOT DEFINED LIST_START SET "LIST_START=1"&&(ECHO.MENU-SCRIPT)>"$LIST"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 IN ("%LIST_WRITE%") DO (CALL ECHO.%U00%ExtPackage%U00%%%1%U00%%$BCLM3%%U00%%$BCLM4%%U00%>>"$LIST")
EXIT /B
:LIST_CONVERT
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                            Create Base-List%U01% %U01%                       Select a list to convert"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=LIST"&&CALL:BASIC_FILE&GOTO:LIST_CONVERT_END
IF DEFINED $PICK SET "$HEAD_CHECK=%$PICK%"&&CALL:GET_HEADER
IF DEFINED ERROR GOTO:LIST_CONVERT_END
COPY /Y "%$PICK%" "$TEMP">NUL
IF EXIST "$TEMP" SET "ISGROUP="&&FOR /F "TOKENS=1 SKIP=1 DELIMS=%U00%" %%1 in ($TEMP) DO (IF "%%1"=="GROUP" SET "ISGROUP=1"&&GOTO:LIST_CONVERT_SKIP)
:LIST_CONVERT_SKIP
IF NOT DEFINED ISGROUP ECHO.%COLOR4%ERROR:%$$% List does not contain any groups.&&SET "ERROR=1"&&CALL:PAUSED&GOTO:LIST_CONVERT_END
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                            Create Base-List%U01% %U01% %U01% %U01%                        Enter name of new .BASE%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR GOTO:LIST_CONVERT_END
IF DEFINED ISGROUP MOVE /Y "$TEMP" "%ListFolder%\%SELECT%.base">NUL
IF DEFINED ISGROUP CALL:APPEND_SCREEN
:LIST_CONVERT_END
SET "$LIST_FILE="&&CALL:CLEAN
EXIT /B
:LIST_DIFFERENCER
SET "$HEADERS=                          %U13% Base Difference%U01% %U01%                             Select base 1"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF NOT DEFINED $PICK EXIT /B
SET "$LIST1=%$PICK%"&&SET "$HEADERS=                          %U13% Base Difference%U01% %U01%                             Select base 2"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF NOT DEFINED $PICK EXIT /B
SET "$LIST2=%$PICK%"&&CALL:PAD_SAME
IF "%$LIST1%"=="%$LIST2%" EXIT /B
SET "$HEADERS=                          %U13% Base Difference%U01% %U01%                        Enter name of new list"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT DEFINED NEW_NAME EXIT /B
CALL:PAD_LINE&&ECHO.Differencing %$LIST1% and %$LIST2%...&&CALL:PAD_LINE
COPY /Y "%$LIST1%" "$LIST">NUL
COPY /Y "%$LIST2%" "$TEMP">NUL
ECHO.MENU-SCRIPT>"%ListFolder%\%NEW_NAME%.list"
SET "XXX1=IF NOT DEFINED $X0$"&&SET "XXX2=%ListFolder%\%NEW_NAME%.list"
SET "X=%U00%"&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%a in ($LIST) DO (
SET "$X0$="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%1 in ($TEMP) DO (IF "[%%1:%%2]"=="[%%a:%%b]" SET "$X0$=1")
IF "%%a"=="APPX" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%>>"%XXX2%"
IF "%%a"=="COMPONENT" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%>>"%XXX2%"
IF "%%a"=="CAPABILITY" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%>>"%XXX2%"
IF "%%a"=="FEATURE" IF DEFINED $X0$ ECHO.%X%%%a%X%%%b%X%DISABLE%X%DX%X%>>"%XXX2%"
IF "%%a"=="FEATURE" %XXX1% ECHO.%X%%%a%X%%%b%X%ABSENT%X%>>"%XXX2%"
IF "%%a"=="SERVICE" IF DEFINED $X0$ ECHO.%X%%%a%X%%%b%X%%%c%X%DX%X%>>"%XXX2%"
IF "%%a"=="SERVICE" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%>>"%XXX2%"
IF "%%a"=="TASK" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%RAS%X%>>"%XXX2%")
SET "$LIST1="&&SET "$LIST2="&&CALL:CLEAN
CALL:PAUSED
EXIT /B
::XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
:LIST_BASE_CREATE
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                          Create Source Base"&&SET "$ITEMSTOP= ( %##%0%$$% ) All base list items"&&SET "$CHOICE_LIST=Appx%U01%Feature%U01%Component%U01%Capability%U01%Service%U01%Task%U01%Driver"&&SET "$VERBOSE=1"&&SET "$CHECKO=PATH"&&SET "$SELECT=BASE_CHOICE"&&CALL:CHOICE_BOX
IF "%BASE_CHOICE%"=="0" SET "BASE_CHOICE=1 4 2 5 6 7 3"
SET "$GO="&&FOR /F "TOKENS=1" %%a IN ("%BASE_CHOICE%") DO (FOR %%1 IN (1 2 3 4 5 6 7) DO (IF "%%a"=="%%1" SET "$GO=1"))
IF NOT DEFINED $GO EXIT /B
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                          Create Source Base%U01% %U01%                   Select a source to generate base"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %##%Current Environment%$$%"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "LIVE_APPLY=1"
IF NOT DEFINED LIVE_APPLY IF NOT DEFINED $PICK EXIT /B
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                          Create Source Base%U01% %U01% %U01% %U01%                      Enter name of new base list%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT DEFINED NEW_NAME EXIT /B
:LIST_BASE_CREATE_CMD
IF NOT DEFINED LIVE_APPLY SET "INPUT=%$PICK%"&&CALL:GET_FILEEXT
IF NOT DEFINED LIVE_APPLY SET "DISP_NAME=%$FILE_X%.vhdx"
IF DEFINED LIVE_APPLY SET "DISP_NAME=Current Environment"
SET "INPUT=%NEW_NAME%"&&CALL:GET_FILEEXT
IF "%EXT_UPPER%"==".BASE" SET "NEW_NAME=%$FILE_X%"
SET "$BCLM1="&&SET "$BCLM3="&&CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.       %@@%BASE-LIST CREATION START:%$$%  %DATE%  %TIME%&&ECHO.
IF NOT DEFINED LIVE_APPLY SET "$VDISK_FILE=%$PICK%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT DEFINED LIVE_APPLY IF NOT EXIST "%VDISK_LTR%:\WINDOWS" ECHO.&&ECHO.             %##%Vdisk error or Windows not installed on Vdisk.%$$%&&ECHO.&&CALL:VDISK_DETACH&&GOTO:LIST_BASE_CLEANUP
IF NOT DEFINED LIVE_APPLY SET "TARGET_PATH=%VDISK_LTR%:"
IF DEFINED LIVE_APPLY SET "TARGET_PATH=%SYSTEMDRIVE%"
ECHO. %@@%GETTING VERSION%$$%..&&ECHO.&&CALL:IF_LIVE_MIX
SET "INFO_E="&&SET "INFO_V="&&ECHO.MENU-SCRIPT>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-9 DELIMS=: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-CURRENTEDITION 2^>NUL') DO (
IF "%%a %%b"=="Image Version" SET "INFO_V=%%c"
IF "%%a %%b"=="Current Edition" IF NOT "%%c"=="is" SET "INFO_E=%%c")
FOR %%a in (INFO_V INFO_E) DO (IF NOT DEFINED %%a SET "%%a=Unavailable")
ECHO.Version:%@@%%INFO_V%%$$% Edition:%@@%%INFO_E%%$$% Source:%@@%%DISP_NAME%%$$%&&ECHO.Version:%INFO_V% Edition:%INFO_E% Source:%DISP_NAME%>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
IF DEFINED LIVE_APPLY SET "$BASE_GROUP=Current Environment - %DATE% - %TIME%"
IF NOT DEFINED LIVE_APPLY SET "$BASE_GROUP=%$FILE_X%%$EXT_X% - %DATE% - %TIME%"
IF NOT DEFINED BASE_CHOICE SET "BASE_CHOICE=1 4 2 5 6 7 3"
FOR %%■ IN (%BASE_CHOICE%) DO (
IF "%%■"=="1" CALL:GET_BASE_APPX
IF "%%■"=="2" CALL:GET_BASE_FEATURE
IF "%%■"=="3" CALL:GET_BASE_COMPONENT
IF "%%■"=="4" CALL:GET_BASE_CAPABILITY
IF "%%■"=="5" CALL:GET_BASE_SERVICE
IF "%%■"=="6" CALL:GET_BASE_TASK
IF "%%■"=="7" CALL:GET_BASE_DRIVER)
SET "BASE_WRITE="&&SET "BASE_WRITELAST="&&CALL:MOUNT_INT
IF NOT DEFINED LIVE_APPLY CALL:VDISK_DETACH
:LIST_BASE_CLEANUP
ECHO.&&ECHO.        %@@%BASE-LIST CREATION END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:CLEAN&&CALL:PAUSED
EXIT /B
:GET_BASE_APPX
ECHO.&&ECHO. %@@%Getting AppX Listing%$$%..&&ECHO.&&SET "$BCLM1=AppX"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08%AppX❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=9* DELIMS=\" %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
SET "$BCLM3=%U0L%CHOICE0.S%U0R%"&&FOR /F "TOKENS=9* DELIMS=\" %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_FEATURE
ECHO.&&ECHO. %@@%Getting Feature Listing%$$%..&&ECHO.&&SET "$BCLM1=Feature"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Feature❕Scoped❕Select an option❕Enable❗Disable❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-9 DELIMS=|: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-FEATURES /FORMAT:TABLE 2^>NUL') DO (
IF "%%b"=="Enabled" SET "$BASE_CHOICE=Default is ENABLE"&&SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE
IF "%%b"=="Disabled" SET "$BASE_CHOICE=Default is DISABLE"&&SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE)
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_COMPONENT
ECHO.&&ECHO. %@@%Getting Component Listing%$$%..&&ECHO.&&SET "$BCLM1=Component"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Component❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=8* DELIMS=\" %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=~" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_CAPABILITY
ECHO.&&ECHO. %@@%Getting Capability Listing%$$%..&&ECHO.&&SET "$BCLM1=Capability"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Capability❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-2 DELIMS=|: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-CAPABILITIES /FORMAT:TABLE 2^>NUL') DO (
IF "%%b"=="Installed" SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE)
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_SERVICE
ECHO.&&ECHO. %@@%Getting Service Listing%$$%..&&ECHO.&&SET "$BCLM1=Service"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Service❕Scoped❕Select an option❕Auto%U01%Manual%U01%Disable%U01%Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-4* DELIMS=\" %%a in ('%REG% QUERY "%HiveSystem%\ControlSet001\Services" 2^>NUL') DO (FOR /F "TOKENS=1-9 DELIMS= " %%1 in ('%REG% QUERY "%HiveSystem%\ControlSet001\Services\%%e" 2^>NUL') DO (SET "BASE_WRITE=%%e"
IF "%%1"=="Start" IF "%%3"=="0x2" SET "$BASE_CHOICE=Default is Auto"
IF "%%1"=="Start" IF "%%3"=="0x3" SET "$BASE_CHOICE=Default is Manual"
IF "%%1"=="Start" IF "%%3"=="0x4" SET "$BASE_CHOICE=Default is Disable"
IF "%%1"=="Type" IF "%%3"=="0x10" CALL:BASE_WRITE
IF "%%1"=="Type" IF "%%3"=="0x20" CALL:BASE_WRITE
IF "%%1"=="Type" IF "%%3"=="0x60" CALL:BASE_WRITE
IF "%%1"=="Type" IF "%%3"=="0x110" CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_TASK
ECHO.&&ECHO. %@@%Getting Task Listing%$$%..&&ECHO.&&SET "$BCLM1=Task"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Task❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-3* DELIMS= " %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree" /f ID /e /s 2^>NUL') DO (IF "%%b"=="REG_SZ" IF NOT "%%c"=="" FOR /F "TOKENS=2* DELIMS=\ " %%1 in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\%%c" /f PATH /e /s 2^>NUL') DO (IF "%%1"=="REG_SZ" IF NOT "%%2"=="" SET "BASE_WRITE=%%2"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_DRIVER
ECHO.&&ECHO. %@@%Getting Driver Listing%$$%..&&ECHO.&&SET "$BCLM1=Driver"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Driver❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
SET "DRIVER_NAME="&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS=: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-DRIVERS 2^>NUL') DO (
IF "%%a %%b"=="Published Name" SET "DRIVER_INF=%%c"
IF "%%a %%b %%c"=="Original File Name" SET "DRIVER_NAME=%%d"&&SET "BASE_WRITE=%%d"
IF "%%a %%b"=="Class Name" SET "DRIVER_CLS=%%c"
IF "%%a"=="Version" SET "DRIVER_VER=%%b"&&CALL:BASE_WRITE)
IF NOT DEFINED DRIVER_NAME ECHO.No 3rd party drivers installed.
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:BASE_WRITE
IF DEFINED BASE_WRITE IF DEFINED BASE_WRITELAST IF "%BASE_WRITE%"=="%BASE_WRITELAST%" EXIT /B
SET "BASE_WRITELAST=!BASE_WRITE!"
ECHO.%@@%!$BCLM1!%$$% !BASE_WRITE!%$$%
ECHO.%U00%!$BCLM1!%U00%!BASE_WRITE!%U00%!$BCLM3!%U00%DX%U00%!$BASE_CHOICE!>>"%ListFolder%\%NEW_NAME%.base"
EXIT /B
:LIST_TIME
SET "$BCLM4="&&SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                            Time of Action"&&SET "$CHOICE_LIST=Default       %U00%%@@%DX%$$%%U00% Immediate execution%U01%SetupComplete %U00%%@@%SC%$$%%U00% Scheduled execution%U01%RunOnce       %U00%%@@%RO%$$%%U00% Scheduled execution"&&SET "$VERBOSE=1"&&SET "$SELECT=SELECTZ"&&CALL:CHOICE_BOX
IF "%SELECTZ%"=="1" SET "$BCLM4=DX"
IF "%SELECTZ%"=="2" SET "$BCLM4=SC"
IF "%SELECTZ%"=="3" SET "$BCLM4=RO"
EXIT /B
:APPEND_SCREEN
IF DEFINED BASE_EXEC EXIT /B
SET "$HEADERS=                            %U13% List Builder%U01% %U01% %U01% %U01% %U01%               Selected options have been added to list%U01% %U01% %U01% "&&SET "$SELECT=SELECTX1"&&SET "$VERBOSE="&&SET "$CHECK=NONE"&&CALL:PROMPT_BOX
EXIT /B
:PAD_SAME
IF "%$LIST_FILE%"=="%$PICK%" CALL:PAD_LINE&&ECHO.%@@%%$LIST_FILE%%$$% and %@@%%$PICK%%$$% are the same...&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:LIST_ITEMS
SET LIST_ITEMS_EXECUTE=APPX FEATURE COMPONENT CAPABILITY SERVICE TASK WINSXS DRIVER EXTPACKAGE COMMAND SESSION REGISTRY FILEOPER TEXTHOST
SET LIST_ITEMS_BUILDER=ARRAY0 ARRAY1 ARRAY2 ARRAY3 ARRAY4 ARRAY5 ARRAY6 ARRAY7 ARRAY8 ARRAY9 MATH1 MATH2 MATH3 MATH4 MATH5 MATH6 MATH7 MATH8 MATH9 STRING1 STRING2 STRING3 STRING4 STRING5 STRING6 STRING7 STRING8 STRING9 CONDIT1 CONDIT2 CONDIT3 CONDIT4 CONDIT5 CONDIT6 CONDIT7 CONDIT8 CONDIT9 PROMPT1 PROMPT2 PROMPT3 PROMPT4 PROMPT5 PROMPT6 PROMPT7 PROMPT8 PROMPT9 CHOICE1 CHOICE2 CHOICE3 CHOICE4 CHOICE5 CHOICE6 CHOICE7 CHOICE8 CHOICE9 PICKER1 PICKER2 PICKER3 PICKER4 PICKER5 PICKER6 PICKER7 PICKER8 PICKER9 ROUTINE1 ROUTINE2 ROUTINE3 ROUTINE4 ROUTINE5 ROUTINE6 ROUTINE7 ROUTINE8 ROUTINE9 GROUP
EXIT /B
:VAR_ITEMS
SET VAR_ITEMS=PROMPT0.I PROMPT1.I PROMPT2.I PROMPT3.I PROMPT4.I PROMPT5.I PROMPT6.I PROMPT7.I PROMPT8.I PROMPT9.I PROMPT0.S PROMPT1.S PROMPT2.S PROMPT3.S PROMPT4.S PROMPT5.S PROMPT6.S PROMPT7.S PROMPT8.S PROMPT9.S PROMPT0.1 PROMPT1.1 PROMPT2.1 PROMPT3.1 PROMPT4.1 PROMPT5.1 PROMPT6.1 PROMPT7.1 PROMPT8.1 PROMPT9.1 STRING0.I STRING1.I STRING2.I STRING3.I STRING4.I STRING5.I STRING6.I STRING7.I STRING8.I STRING9.I STRING0.S STRING1.S STRING2.S STRING3.S STRING4.S STRING5.S STRING6.S STRING7.S STRING8.S STRING9.S STRING0.1 STRING1.1 STRING2.1 STRING3.1 STRING4.1 STRING5.1 STRING6.1 STRING7.1 STRING8.1 STRING9.1 STRING0.2 STRING1.2 STRING2.2 STRING3.2 STRING4.2 STRING5.2 STRING6.2 STRING7.2 STRING8.2 STRING9.2 STRING0.3 STRING1.3 STRING2.3 STRING3.3 STRING4.3 STRING5.3 STRING6.3 STRING7.3 STRING8.3 STRING9.3 STRING0.4 STRING1.4 STRING2.4 STRING3.4 STRING4.4 STRING5.4 STRING6.4 STRING7.4 STRING8.4 STRING9.4 STRING0.5 STRING1.5 STRING2.5 STRING3.5 STRING4.5 STRING5.5 STRING6.5 STRING7.5 STRING8.5 STRING9.5 STRING0.6 STRING1.6 STRING2.6 STRING3.6 STRING4.6 STRING5.6 STRING6.6 STRING7.6 STRING8.6 STRING9.6 STRING0.7 STRING1.7 STRING2.7 STRING3.7 STRING4.7 STRING5.7 STRING6.7 STRING7.7 STRING8.7 STRING9.7 STRING0.8 STRING1.8 STRING2.8 STRING3.8 STRING4.8 STRING5.8 STRING6.8 STRING7.8 STRING8.8 STRING9.8 STRING0.9 STRING1.9 STRING2.9 STRING3.9 STRING4.9 STRING5.9 STRING6.9 STRING7.9 STRING8.9 STRING9.9 PICKER0.I PICKER1.I PICKER2.I PICKER3.I PICKER4.I PICKER5.I PICKER6.I PICKER7.I PICKER8.I PICKER9.I PICKER0.S PICKER1.S PICKER2.S PICKER3.S PICKER4.S PICKER5.S PICKER6.S PICKER7.S PICKER8.S PICKER9.S PICKER0.1 PICKER1.1 PICKER2.1 PICKER3.1 PICKER4.1 PICKER5.1 PICKER6.1 PICKER7.1 PICKER8.1 PICKER9.1 CHOICE0.I CHOICE1.I CHOICE2.I CHOICE3.I CHOICE4.I CHOICE5.I CHOICE6.I CHOICE7.I CHOICE8.I CHOICE9.I CHOICE0.S CHOICE1.S CHOICE2.S CHOICE3.S CHOICE4.S CHOICE5.S CHOICE6.S CHOICE7.S CHOICE8.S CHOICE9.S CHOICE0.1 CHOICE1.1 CHOICE2.1 CHOICE3.1 CHOICE4.1 CHOICE5.1 CHOICE6.1 CHOICE7.1 CHOICE8.1 CHOICE9.1 CHOICE0.2 CHOICE1.2 CHOICE2.2 CHOICE3.2 CHOICE4.2 CHOICE5.2 CHOICE6.2 CHOICE7.2 CHOICE8.2 CHOICE9.2 CHOICE0.3 CHOICE1.3 CHOICE2.3 CHOICE3.3 CHOICE4.3 CHOICE5.3 CHOICE6.3 CHOICE7.3 CHOICE8.3 CHOICE9.3 CHOICE0.4 CHOICE1.4 CHOICE2.4 CHOICE3.4 CHOICE4.4 CHOICE5.4 CHOICE6.4 CHOICE7.4 CHOICE8.4 CHOICE9.4 CHOICE0.5 CHOICE1.5 CHOICE2.5 CHOICE3.5 CHOICE4.5 CHOICE5.5 CHOICE6.5 CHOICE7.5 CHOICE8.5 CHOICE9.5 CHOICE0.6 CHOICE1.6 CHOICE2.6 CHOICE3.6 CHOICE4.6 CHOICE5.6 CHOICE6.6 CHOICE7.6 CHOICE8.6 CHOICE9.6 CHOICE0.7 CHOICE1.7 CHOICE2.7 CHOICE3.7 CHOICE4.7 CHOICE5.7 CHOICE6.7 CHOICE7.7 CHOICE8.7 CHOICE9.7 CHOICE0.8 CHOICE1.8 CHOICE2.8 CHOICE3.8 CHOICE4.8 CHOICE5.8 CHOICE6.8 CHOICE7.8 CHOICE8.8 CHOICE9.8 CHOICE0.9 CHOICE1.9 CHOICE2.9 CHOICE3.9 CHOICE4.9 CHOICE5.9 CHOICE6.9 CHOICE7.9 CHOICE8.9 CHOICE9.9 CONDIT0.I CONDIT1.I CONDIT2.I CONDIT3.I CONDIT4.I CONDIT5.I CONDIT6.I CONDIT7.I CONDIT8.I CONDIT9.I CONDIT0.S CONDIT1.S CONDIT2.S CONDIT3.S CONDIT4.S CONDIT5.S CONDIT6.S CONDIT7.S CONDIT8.S CONDIT9.S CONDIT0.1 CONDIT1.1 CONDIT2.1 CONDIT3.1 CONDIT4.1 CONDIT5.1 CONDIT6.1 CONDIT7.1 CONDIT8.1 CONDIT9.1 CONDIT0.2 CONDIT1.2 CONDIT2.2 CONDIT3.2 CONDIT4.2 CONDIT5.2 CONDIT6.2 CONDIT7.2 CONDIT8.2 CONDIT9.2 CONDIT0.3 CONDIT1.3 CONDIT2.3 CONDIT3.3 CONDIT4.3 CONDIT5.3 CONDIT6.3 CONDIT7.3 CONDIT8.3 CONDIT9.3 CONDIT0.4 CONDIT1.4 CONDIT2.4 CONDIT3.4 CONDIT4.4 CONDIT5.4 CONDIT6.4 CONDIT7.4 CONDIT8.4 CONDIT9.4 CONDIT0.5 CONDIT1.5 CONDIT2.5 CONDIT3.5 CONDIT4.5 CONDIT5.5 CONDIT6.5 CONDIT7.5 CONDIT8.5 CONDIT9.5 CONDIT0.6 CONDIT1.6 CONDIT2.6 CONDIT3.6 CONDIT4.6 CONDIT5.6 CONDIT6.6 CONDIT7.6 CONDIT8.6 CONDIT9.6 CONDIT0.7 CONDIT1.7 CONDIT2.7 CONDIT3.7 CONDIT4.7 CONDIT5.7 CONDIT6.7 CONDIT7.7 CONDIT8.7 CONDIT9.7 CONDIT0.8 CONDIT1.8 CONDIT2.8 CONDIT3.8 CONDIT4.8 CONDIT5.8 CONDIT6.8 CONDIT7.8 CONDIT8.8 CONDIT9.8 CONDIT0.9 CONDIT1.9 CONDIT2.9 CONDIT3.9 CONDIT4.9 CONDIT5.9 CONDIT6.9 CONDIT7.9 CONDIT8.9 CONDIT9.9 ARRAY0.I ARRAY1.I ARRAY2.I ARRAY3.I ARRAY4.I ARRAY5.I ARRAY6.I ARRAY7.I ARRAY8.I ARRAY9.I ARRAY0.S ARRAY1.S ARRAY2.S ARRAY3.S ARRAY4.S ARRAY5.S ARRAY6.S ARRAY7.S ARRAY8.S ARRAY9.S ARRAY0.1 ARRAY1.1 ARRAY2.1 ARRAY3.1 ARRAY4.1 ARRAY5.1 ARRAY6.1 ARRAY7.1 ARRAY8.1 ARRAY9.1 ARRAY0.2 ARRAY1.2 ARRAY2.2 ARRAY3.2 ARRAY4.2 ARRAY5.2 ARRAY6.2 ARRAY7.2 ARRAY8.2 ARRAY9.2 ARRAY0.3 ARRAY1.3 ARRAY2.3 ARRAY3.3 ARRAY4.3 ARRAY5.3 ARRAY6.3 ARRAY7.3 ARRAY8.3 ARRAY9.3 ARRAY0.4 ARRAY1.4 ARRAY2.4 ARRAY3.4 ARRAY4.4 ARRAY5.4 ARRAY6.4 ARRAY7.4 ARRAY8.4 ARRAY9.4 ARRAY0.5 ARRAY1.5 ARRAY2.5 ARRAY3.5 ARRAY4.5 ARRAY5.5 ARRAY6.5 ARRAY7.5 ARRAY8.5 ARRAY9.5 ARRAY0.6 ARRAY1.6 ARRAY2.6 ARRAY3.6 ARRAY4.6 ARRAY5.6 ARRAY6.6 ARRAY7.6 ARRAY8.6 ARRAY9.6 ARRAY0.7 ARRAY1.7 ARRAY2.7 ARRAY3.7 ARRAY4.7 ARRAY5.7 ARRAY6.7 ARRAY7.7 ARRAY8.7 ARRAY9.7 ARRAY0.8 ARRAY1.8 ARRAY2.8 ARRAY3.8 ARRAY4.8 ARRAY5.8 ARRAY6.8 ARRAY7.8 ARRAY8.8 ARRAY9.8 ARRAY0.9 ARRAY1.9 ARRAY2.9 ARRAY3.9 ARRAY4.9 ARRAY5.9 ARRAY6.9 ARRAY7.9 ARRAY8.9 ARRAY9.9 MATH0.I MATH1.I MATH2.I MATH3.I MATH4.I MATH5.I MATH6.I MATH7.I MATH8.I MATH9.I MATH0.S MATH1.S MATH2.S MATH3.S MATH4.S MATH5.S MATH6.S MATH7.S MATH8.S MATH9.S MATH0.1 MATH1.1 MATH2.1 MATH3.1 MATH4.1 MATH5.1 MATH6.1 MATH7.1 MATH8.1 MATH9.1 ROUTINE0.I ROUTINE1.I ROUTINE2.I ROUTINE3.I ROUTINE4.I ROUTINE5.I ROUTINE6.I ROUTINE7.I ROUTINE8.I ROUTINE9.I ROUTINE0.S ROUTINE1.S ROUTINE2.S ROUTINE3.S ROUTINE4.S ROUTINE5.S ROUTINE6.S ROUTINE7.S ROUTINE8.S ROUTINE9.S ROUTINE0.1 ROUTINE1.1 ROUTINE2.1 ROUTINE3.1 ROUTINE4.1 ROUTINE5.1 ROUTINE6.1 ROUTINE7.1 ROUTINE8.1 ROUTINE9.1 ROUTINE0.2 ROUTINE1.2 ROUTINE2.2 ROUTINE3.2 ROUTINE4.2 ROUTINE5.2 ROUTINE6.2 ROUTINE7.2 ROUTINE8.2 ROUTINE9.2 ROUTINE0.3 ROUTINE1.3 ROUTINE2.3 ROUTINE3.3 ROUTINE4.3 ROUTINE5.3 ROUTINE6.3 ROUTINE7.3 ROUTINE8.3 ROUTINE9.3 ROUTINE0.4 ROUTINE1.4 ROUTINE2.4 ROUTINE3.4 ROUTINE4.4 ROUTINE5.4 ROUTINE6.4 ROUTINE7.4 ROUTINE8.4 ROUTINE9.4 ROUTINE0.5 ROUTINE1.5 ROUTINE2.5 ROUTINE3.5 ROUTINE4.5 ROUTINE5.5 ROUTINE6.5 ROUTINE7.5 ROUTINE8.5 ROUTINE9.5 ROUTINE0.6 ROUTINE1.6 ROUTINE2.6 ROUTINE3.6 ROUTINE4.6 ROUTINE5.6 ROUTINE6.6 ROUTINE7.6 ROUTINE8.6 ROUTINE9.6 ROUTINE0.7 ROUTINE1.7 ROUTINE2.7 ROUTINE3.7 ROUTINE4.7 ROUTINE5.7 ROUTINE6.7 ROUTINE7.7 ROUTINE8.7 ROUTINE9.7 ROUTINE0.8 ROUTINE1.8 ROUTINE2.8 ROUTINE3.8 ROUTINE4.8 ROUTINE5.8 ROUTINE6.8 ROUTINE7.8 ROUTINE8.8 ROUTINE9.8 ROUTINE0.9 ROUTINE1.9 ROUTINE2.9 ROUTINE3.9 ROUTINE4.9 ROUTINE5.9 ROUTINE6.9 ROUTINE7.9 ROUTINE8.9 ROUTINE9.9
EXIT /B
:VAR_CLEAR
IF NOT DEFINED VAR_ITEMS CALL:VAR_ITEMS
FOR %%a in (%VAR_ITEMS%) DO (SET "%%a=")
EXIT /B
:IF_LIVE_EXT
IF DEFINED LIVE_APPLY CALL:MOUNT_INT
IF DEFINED LIVE_APPLY IF NOT DEFINED UsrSid IF "%PROG_MODE%"=="COMMAND" CALL:MOUNT_USR
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
EXIT /B
:IF_LIVE_MIX
IF DEFINED LIVE_APPLY CALL:MOUNT_INT
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_MIX
EXIT /B
:MOUNT_USR
SET "$GO="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKU\AllUsersX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_USERS" SET "$GO=1")
IF NOT DEFINED $GO SET "MOUNT="
IF "%MOUNT%"=="USR" EXIT /B
SET "MOUNT=USR"&&SET "HiveUser=HKEY_USERS\AllUsersX"&&SET "UsrTar=%DrvTar%\Users\Default"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% LOAD HKU\AllUsersX "%DrvTar%\Users\Default\Ntuser.dat">NUL 2>&1
EXIT /B
:MOUNT_INT
FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\SoftwareX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Unmounting external registry hives..)
IF "%MOUNT%"=="INT" EXIT /B
SET "MOUNT=INT"&&SET "HiveUser=HKEY_CURRENT_USER"&&SET "HiveSoftware=HKEY_LOCAL_MACHINE\SOFTWARE"&&SET "HiveSystem=HKEY_LOCAL_MACHINE\SYSTEM"&&SET "ApplyTarget=ONLINE"&&SET "DrvTar=%SYSTEMDRIVE%"&&SET "WinTar=%WINDIR%"&&SET "UsrTar=%USERPROFILE%"
IF DEFINED UsrSid SET "HiveUser=HKEY_USERS\%UsrSid%"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
%REG% UNLOAD HKLM\SystemX>NUL 2>&1
EXIT /B
:MOUNT_EXT
SET "$GO="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\SoftwareX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "$GO=1")
IF NOT DEFINED $GO SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Mounting external registry hives..
IF "%MOUNT%"=="EXT" EXIT /B
SET "MOUNT=EXT"&&SET "HiveUser=HKEY_USERS\AllUsersX"&&SET "HiveSoftware=HKEY_LOCAL_MACHINE\SoftwareX"&&SET "HiveSystem=HKEY_LOCAL_MACHINE\SystemX"&&SET "ApplyTarget=IMAGE:%TARGET_PATH%"&&SET "DrvTar=%TARGET_PATH%"&&SET "WinTar=%TARGET_PATH%\Windows"&&SET "UsrTar=%TARGET_PATH%\Users\Default"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
%REG% UNLOAD HKLM\SystemX>NUL 2>&1
%REG% LOAD HKU\AllUsersX "%TARGET_PATH%\Users\Default\Ntuser.dat">NUL 2>&1
%REG% LOAD HKLM\SoftwareX "%TARGET_PATH%\WINDOWS\SYSTEM32\Config\SOFTWARE">NUL 2>&1
%REG% LOAD HKLM\SystemX "%TARGET_PATH%\WINDOWS\SYSTEM32\Config\SYSTEM">NUL 2>&1
EXIT /B
:MOUNT_MIX
FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\SoftwareX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Unmounting external registry hives..)
IF "%MOUNT%"=="MIX" EXIT /B
SET "MOUNT=MIX"&&SET "HiveUser=HKEY_CURRENT_USER"&&SET "HiveSoftware=HKEY_LOCAL_MACHINE\SOFTWARE"&&SET "HiveSystem=HKEY_LOCAL_MACHINE\SYSTEM"&&SET "ApplyTarget=IMAGE:%TARGET_PATH%"&&SET "DrvTar=%TARGET_PATH%"&&SET "WinTar=%TARGET_PATH%\Windows"&&SET "UsrTar=%TARGET_PATH%\Users\Default"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
%REG% UNLOAD HKLM\SystemX>NUL 2>&1
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:PACKAGE_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "IMAGE_LAST=PACKAGE"&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U05% Image Management&&ECHO.&&ECHO.  %@@%PACKAGE CONTENTS:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%\project"&&SET "$FILT=*.*"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U05%PACK%$$%(%##%X%$$%)LIST%U13%     (%##%R%$$%)un Pack     (%##%E%$$%)dit Pack     (%##%B%$$%)uild Pack&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="E" CALL:PROJ_EDIT&SET "SELECT="
IF "%SELECT%"=="B" GOTO:PACK_BUILDER&SET "SELECT="
IF "%SELECT%"=="X" GOTO:IMAGE_MANAGEMENT&SET "SELECT="
IF "%SELECT%"=="R" SET "IMAGEMGR_TYPE=PACK"&&CALL:IMAGEMGR_EXECUTE&SET "SELECT="
GOTO:PACKAGE_MANAGEMENT
:PACK_BUILDER
SET "$HEADERS=                           %U05% Pack Builder%U01% %U01%                           Select an option"&&SET "$CHOICE_LIST=%U04% Capture Project Folder%U01%%U05% New Package Template%U01%%U05% Restore Package%U01%%U07% Export Drivers"&&SET "$VERBOSE=1"&&CALL:CHOICE_BOX
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:PACKAGE_MANAGEMENT
IF "%SELECT%"=="1" CALL:PROJ_CREATE&SET "SELECT="
IF "%SELECT%"=="2" CALL:PROJ_NEW&SET "SELECT="
IF "%SELECT%"=="3" CALL:PROJ_RESTORE&SET "SELECT="
IF "%SELECT%"=="4" CALL:DRVR_EXPORT&SET "SELECT="
GOTO:PACK_BUILDER
:DRVR_EXPORT
IF DEFINED ERROR EXIT /B
SET "$HEADERS=                             Driver Export%U01% %U01%                   Select a source to export drivers"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %##%Current Environment%$$%"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "LIVE_APPLY=1"
:DRVR_EXPORT_SKIP
IF NOT DEFINED LIVE_APPLY IF NOT DEFINED $PICK EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%DRIVER-EXPORT START:%$$%  %DATE%  %TIME%&&ECHO.
IF DEFINED LIVE_APPLY ECHO.Using live system for driver export.
IF NOT DEFINED LIVE_APPLY SET "$VDISK_FILE=%$PICK%"&&CALL:VDISK_ATTACH
IF NOT DEFINED LIVE_APPLY SET "TARGET_PATH=%VDISK_LTR%:"
IF DEFINED LIVE_APPLY SET "TARGET_PATH=%SYSTEMDRIVE%"
CALL:IF_LIVE_MIX
IF NOT EXIST "%ProgFolder%\project\driver" MD "%ProgFolder%\project\driver">NUL 2>&1
IF EXIST "%ProgFolder%\project\driver" ECHO.Exporting drivers to %ProgFolder%\project\driver...
IF EXIST "%ProgFolder%\project\driver" %DISM% /ENGLISH /%ApplyTarget% /EXPORT-DRIVER /destination:"%ProgFolder%\project\driver"
FOR %%a in (CMD LIST) DO (IF NOT EXIST "%ProgFolder%\project\PACKAGE.%%a" CALL:NEW_PACKAGE%%a)
IF NOT DEFINED LIVE_APPLY CALL:VDISK_DETACH
ECHO.&&ECHO.            %@@%DRIVER-EXPORT END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:PROJ_EDIT
FOR %%a in (package.cmd package.list) DO (IF EXIST "%ProgFolder%\project\%%a" START NOTEPAD.EXE "%ProgFolder%\project\%%a")
EXIT /B
:PROJ_RESTORE
SET "$HEADERS=                          %U05% Package Extract"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %##%File Operation%$$%"&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=PKX"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
CALL:PROJ_CLEAR
IF DEFINED ERROR EXIT /B
CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.          %@@%PACKAGE RESTORE START:%$$%  %DATE%  %TIME%
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%$PICK%" /INDEX:1 /APPLYDIR:"%ProgFolder%\project"
IF NOT EXIST "%ProgFolder%\project\package.list" ECHO.%COLOR2%ERROR:%$$% Package is either missing package.list or unable to extract.&&RD /S /Q "%ProgFolder%\project">NUL 2>&1
ECHO.&&ECHO.           %@@%PACKAGE RESTORE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED
EXIT /B
:PROJ_CREATE
IF NOT EXIST "%ProgFolder%\project\*" ECHO.&&ECHO.%COLOR4%ERROR:%$$% Package folder is empty.&&ECHO.&IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
IF NOT EXIST "%ProgFolder%\project\*" EXIT /B
SET "$HEADERS=                           %U05% Pack Builder%U01% %U01%                        Capture Project Folder%U01% %U01% %U01% %U01%                      Enter new .PKX package name%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=PACKNAME"&&CALL:PROMPT_BOX
IF NOT DEFINED PACKNAME EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%PACKAGE CREATE START:%$$%  %DATE%  %TIME%
%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%ProgFolder%\project" /IMAGEFILE:"%PackFolder%\%PACKNAME%.pkx" /COMPRESS:%COMPRESS% /NAME:"PKX" /CheckIntegrity /Verify
ECHO.&&ECHO.            %@@%PACKAGE CREATE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:PROJ_NEW
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%PACK-TEMPLATE START:%$$%  %DATE%  %TIME%&&ECHO.&&ECHO.
CALL:PROJ_CLEAR
IF DEFINED ERROR EXIT /B
IF NOT EXIST "%ProgFolder%\project\driver" MD "%ProgFolder%\project\driver">NUL 2>&1
CALL:NEW_PACKAGELIST&CALL:NEW_PACKAGECMD
ECHO.               New package template created successfully.&&ECHO.&&ECHO.&&ECHO.            %@@%PACK-TEMPLATE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:NEW_PACKAGELIST
(ECHO.MENU-SCRIPT&&ECHO.&&ECHO.Delete the driver list entry below and driver folder if there aren't drivers included in the package.&&ECHO.%U00%DRIVER%U00%"%%PkxFolder%%\driver"%U00%INSTALL%U00%DX%U00%&&ECHO.&&ECHO.Delete the command list entry below and package.cmd if a script is not needed.&&ECHO.%U00%COMMAND%U00%%CMD% /C "%%PkxFolder%%\package.cmd"%U00%NORMAL%U00%DX%U00%&&ECHO.&&ECHO.Manually add, copy and paste items, or replace this package.list with an existing execution list.&&ECHO.Copy any listed items such as scripts, installers, appx, cab, and msu packages into the project folder before package creation.)>"%ProgFolder%\project\package.list"
EXIT /B
:NEW_PACKAGECMD
(ECHO.::================================================&&ECHO.::These variables are built in and can help&&ECHO.::keep a script consistant throughout the entire&&ECHO.::process, whether applying to a vhdx or live.&&ECHO.::Add any files to package folder before creating.&&ECHO.::================================================&&ECHO.::Windows folder :    %%WinTar%%&&ECHO.::Drive root :        %%DrvTar%%&&ECHO.::User or defuser :   %%UsrTar%%&&ECHO.::HKLM\SOFTWARE :     %%HiveSoftware%%&&ECHO.::HKLM\SYSTEM :       %%HiveSystem%%&&ECHO.::HKCU or defuser :   %%HiveUser%%&&ECHO.::DISM target :       %%ApplyTarget%%&&ECHO.::==================START OF PACK=================&&ECHO.&&ECHO.@ECHO OFF&&ECHO.REM "%%PkxFolder%%\example.msi" /quiet /noprompt&&ECHO.&&ECHO.::===================END OF PACK==================)>"%ProgFolder%\project\package.cmd"
EXIT /B
:PROJ_CLEAR
IF DEFINED MENU_SKIP GOTO:PROJ_CLEAR_SKIP
SET "$HEADERS= %U01% %U01% %U01% %U01%         Project folder will be cleared. Press (%##%X%$$%) to proceed%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" SET "ERROR=PROJ_CLEAR"&&CALL:DEBUG&&EXIT /B
:PROJ_CLEAR_SKIP
IF EXIST "%ProgFolder%\project" SET "FOLDER_DEL=%ProgFolder%\project"&&CALL:FOLDER_DEL
IF NOT EXIST "%ProgFolder%\project" MD "%ProgFolder%\project">NUL 2>&1
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:FILE_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "MISC_LAST=FILE"&&CALL:SETS_HANDLER&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Management&&ECHO.
IF NOT DEFINED FMGR_DUAL SET "FMGR_DUAL=DISABLED"
IF NOT DEFINED FMGR_SOURCE SET "FMGR_SOURCE=%ProgFolder%"&&SET "FMGR_TARGET=%ProgFolder%"
IF NOT EXIST "%FMGR_SOURCE%\*" SET "FMGR_SOURCE=%ProgFolder%"&&SET "FMGR_TARGET=%ProgFolder%"
IF "%FMGR_DUAL%"=="ENABLED" ECHO.                           %@@%SOURCE%$$% (%##%S%$$%) %@@%TARGET%$$%&&ECHO.&&ECHO.  %@@%TARGET FOLDER:%$$% %FMGR_TARGET%&&ECHO.&&SET "$FOLD=%FMGR_TARGET%"&&SET "$FILT=*.*"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.
ECHO.  %@@%SOURCE FOLDER:%$$% %FMGR_SOURCE%&&ECHO.&&ECHO.  (%##%..%$$%)&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U02%FILE%$$%(%##%X%$$%)DISK%U04% (%##%.%$$%) (%##%N%$$%)ew (%##%O%$$%)pen (%##%C%$$%)opy (%##%M%$$%)ove (%##%R%$$%)en (%##%D%$$%)el (%##%#%$$%)Own (%##%V%$$%)&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="S" CALL:FMGR_SWAP&SET "SELECT="
IF "%SELECT%"=="X" GOTO:DISK_MANAGEMENT
IF "%SELECT%"=="N" CALL:FMGR_NEW&SET "SELECT="
IF "%SELECT%"=="." CALL:FMGR_EXPLORE&SET "SELECT="
IF "%SELECT%"=="C" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                 Copy"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_COPY&SET "SELECT="
IF "%SELECT%"=="O" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                 Open"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_OPEN&SET "SELECT="
IF "%SELECT%"=="M" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                 Move"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_MOVE&SET "SELECT="
IF "%SELECT%"=="R" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Rename"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_REN&SET "SELECT="
IF "%SELECT%"=="#" SET "$HEADERS=                          %U02% File Management%U01% %U01%                            Take Ownership"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_OWN&SET "SELECT="
IF "%SELECT%"=="D" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Delete"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_DEL&SET "SELECT="
IF "%SELECT%"=="V" IF "%FMGR_DUAL%"=="DISABLED" SET "FMGR_DUAL=ENABLED"&SET "SELECT="
IF "%SELECT%"=="V" IF "%FMGR_DUAL%"=="ENABLED" SET "FMGR_DUAL=DISABLED"&SET "SELECT="
IF "%SELECT%"==".." CALL SET "FMGR_SOURCE=%%FMGR_SOURCE_%FMS#%%%"&&CALL SET /A "FMS#-=1"
GOTO:FILE_MANAGEMENT
:FMGR_NEW
SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Create"&&SET "$CHOICE_LIST=Folder%U01%File"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_TYPE"&&CALL:CHOICE_BOX
IF DEFINED ERROR EXIT /B
IF "%NEW_TYPE%"=="1" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Create%U01% %U01% %U01% %U01%                         Enter new folder name%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF "%NEW_TYPE%"=="1" SET "NEW_TYPE="&&MD "%FMGR_SOURCE%\%NEW_NAME%">NUL 2>&1
IF "%NEW_TYPE%"=="2" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Create%U01% %U01% %U01% %U01%              Enter new file name including the extension%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF "%NEW_TYPE%"=="2" SET "NEW_TYPE="&&ECHO.>"%FMGR_SOURCE%\%NEW_NAME%"
EXIT /B
:FMGR_REN
IF NOT DEFINED $PICK EXIT /B
IF EXIST "%$PICK%\*" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Rename%U01% %U01% %U01% %U01%                         Enter new folder name%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT EXIST "%$PICK%\*" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Rename%U01% %U01% %U01% %U01%              Enter new file name including the extension%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
ECHO.Renaming %@@%%$PICK%%$$% to %@@%%FMGR_SOURCE%\%NEW_NAME%%$$%.
REN "%$PICK%" "%NEW_NAME%"
EXIT /B
:FMGR_DEL
IF NOT DEFINED $PICK EXIT /B
IF NOT EXIST "%$PICK%\*" DEL /Q /F "\\?\%$PICK%"
IF EXIST "%$PICK%\*" RD /S /Q "\\?\%$PICK%"
IF NOT EXIST "%$PICK%\*" IF NOT EXIST "%$PICK%" ECHO.Deleting %@@%%$PICK%%$$%.
EXIT /B
:FMGR_OPEN
IF NOT DEFINED $PICK EXIT /B
IF NOT EXIST "%$PICK%\*" "%$PICK%"&EXIT /B
IF EXIST "%$PICK%\*" CALL SET /A "FMS#+=1"
CALL SET "FMGR_SOURCE_%FMS#%=%FMGR_SOURCE%"&&CALL SET "FMGR_SOURCE=%$PICK%"
EXIT /B
:FMGR_COPY
IF NOT DEFINED $PICK EXIT /B
IF "%FMGR_SOURCE%"=="%FMGR_TARGET%" CALL:FMGR_SAME&EXIT /B
IF NOT EXIST "%$PICK%\*" ECHO.Copying %@@%%$PICK%%$$% to %@@%%FMGR_TARGET%%$$%...&&XCOPY "%$PICK%" "%FMGR_TARGET%" /C /Y>NUL 2>&1
IF EXIST "%$PICK%\*" ECHO.Copying %@@%%$PICK%%$$% to %@@%%FMGR_TARGET%%$$%...&&XCOPY "%$PICK%" "%FMGR_TARGET%\%$CHOICE%\" /E /C /I /Y>NUL 2>&1
EXIT /B
:FMGR_SYM
IF NOT DEFINED $PICK EXIT /B
IF "%FMGR_SOURCE%"=="%FMGR_TARGET%" CALL:FMGR_SAME&EXIT /B
IF EXIST "%$PICK%\*" MKLINK /J "%FMGR_TARGET%\%$CHOICE%" "%$PICK%"
IF NOT EXIST "%$PICK%\*" MKLINK "%FMGR_TARGET%\%$CHOICE%" "%$PICK%"
EXIT /B
:FMGR_MOVE
IF NOT DEFINED $PICK EXIT /B
IF "%FMGR_SOURCE%"=="%FMGR_TARGET%" CALL:FMGR_SAME&EXIT /B
IF NOT EXIST "%$PICK%\*" ECHO.Moving %@@%%$PICK%%$$% to %@@%%FMGR_TARGET%%$$%...&&MOVE /Y "%$PICK%" "%FMGR_TARGET%">NUL 2>&1
IF EXIST "%$PICK%\*" ECHO.Moving %@@%%$PICK%%$$% to %@@%%FMGR_TARGET%%$$%...&&XCOPY "%$PICK%" "%FMGR_TARGET%\%$CHOICE%\" /E /C /I /Y>NUL 2>&1
IF EXIST "%$PICK%\*" RD /S /Q "\\?\%$PICK%">NUL 2>&1
EXIT /B
:FMGR_OWN
IF NOT DEFINED $PICK EXIT /B
ECHO.
IF NOT EXIST "%$PICK%\*" TAKEOWN /F "%$PICK%"
IF NOT EXIST "%$PICK%\*" ICACLS "%$PICK%" /grant %USERNAME%:F >NUL 2>&1
IF EXIST "%$PICK%\*" TAKEOWN /F "%$PICK%" /R /D Y
IF EXIST "%$PICK%\*" ICACLS "%$PICK%" /grant %USERNAME%:F /T >NUL 2>&1
ECHO.
CALL:PAUSED
EXIT /B
:FMGR_EXPLORE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Management&&ECHO.&&ECHO.                       Enter the PATH to explore&&ECHO.&&ECHO.  %@@%AVAILABLE PATHs:%$$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO. ^( %##%%%G%$$% ^) Volume %%G:)
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF DEFINED SELECT FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%SELECT%"=="%%G" IF EXIST "%%G:\" SET "FMGR_SOURCE=%SELECT%:"&&EXIT /B)
IF DEFINED SELECT SET "INPUT=%SELECT%"&&SET "OUTPUT=FMGR_SOURCE"&&CALL:SLASHER
EXIT /B
:FMGR_SAME
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.                      Source/Target are the same.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:FMGR_SWAP
IF NOT EXIST "%FMGR_SOURCE%" EXIT /B
IF NOT EXIST "%FMGR_TARGET%" EXIT /B
SET "FMGR_SOURCE=%FMGR_TARGET%"&&SET "FMGR_TARGET=%FMGR_SOURCE%"
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:BASIC_FILE
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
IF DEFINED FILE_OPER GOTO:BASIC_FILETYPE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                           Select an option&&ECHO.&&ECHO.&&ECHO.&&ECHO. (%##%1%$$%) Rename&&ECHO. (%##%2%$$%) Delete&&ECHO. (%##%3%$$%) Copy&&IF "%FOLDER_MODE%"=="ISOLATED" FOR %%G in (VHDX MAIN IMAGE) DO (IF "%FILE_TYPE%"=="%%G" ECHO. ^(%##%4%$$%^) Move)
ECHO.&&ECHO.&&ECHO.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=FILE_PROMPT"&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF "%FILE_PROMPT%"=="1" SET "FILE_OPER=Rename"
IF "%FILE_PROMPT%"=="2" SET "FILE_OPER=Delete"
IF "%FILE_PROMPT%"=="3" SET "FILE_OPER=Copy"
IF "%FILE_PROMPT%"=="4" IF "%FOLDER_MODE%"=="ISOLATED" FOR %%G in (VHDX MAIN IMAGE) DO (IF "%FILE_TYPE%"=="%%G" SET "FILE_OPER=MoveVHDX")
IF NOT DEFINED FILE_OPER GOTO:BASIC_ERROR
:BASIC_FILETYPE
IF "%FILE_OPER%"=="MoveVHDX" IF "%FOLDER_MODE%"=="ISOLATED" CALL:VHDX_MOVE&GOTO:BASIC_ERROR
IF DEFINED FILE_SKIP GOTO:BASIC_FILEOPER
:BASIC_FILEPICK
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&SET "$CENTERED_MSG=%FILE_OPER%"&&CALL:TXT_CENTER&&ECHO.
FOR %%X in (WIM VHDX ISO) DO (IF "%%X"=="%FILE_TYPE%" ECHO.  %@@%AVAILABLE %%Xs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.%%X"&&CALL:FILE_LIST)
FOR %%X in (LIST BASE) DO (IF "%%X"=="%FILE_TYPE%" ECHO.  %@@%AVAILABLE %%Xs:%$$%&&ECHO.&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.%%X"&&CALL:FILE_LIST)
FOR %%X in (CAB MSU PKX APPX APPXBUNDLE MSIXBUNDLE) DO (IF "%%X"=="%FILE_TYPE%" ECHO.  %@@%AVAILABLE %%Xs:%$$%&&ECHO.&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.%%X"&&CALL:FILE_LIST)
IF "%FILE_TYPE%"=="WALL" ECHO.  %@@%AVAILABLE JPGs/PNGs:%$$%&&ECHO.&&SET "$FOLD=%CacheFolder%"&&SET "$FILT=*.JPG *.PNG"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="MAIN" ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="IMAGE" ECHO.  %@@%AVAILABLE WIMs/VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM *.VHDX"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="LISTS" ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="PACK" ECHO.  %@@%AVAILABLE PACKAGEs:%$$%&&ECHO.&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED $PICK GOTO:BASIC_ERROR
:BASIC_FILEOPER
IF "%FILE_OPER%"=="Delete" CALL:CONFIRM
IF "%FILE_OPER%"=="Delete" IF "%CONFIRM%"=="X" DEL /Q /F "%$PICK%">NUL
IF "%FILE_OPER%"=="Delete" GOTO:BASIC_ERROR
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&SET "$CENTERED_MSG=%FILE_OPER%"&&CALL:TXT_CENTER&&ECHO.&&ECHO.&&ECHO.&&ECHO.&&SET "$CENTERED_MSG=Enter new name of %$EXT%"&&CALL:TXT_CENTER&&ECHO.&&ECHO.&&ECHO.&&ECHO.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=FILE_PROMPT"&&SET "$CASE=ANY"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&CALL:MENU_SELECT
IF NOT DEFINED FILE_PROMPT GOTO:BASIC_ERROR
IF EXIST "%$PATH%\%FILE_PROMPT%%$EXT%" GOTO:BASIC_ERROR
SET "CASE=LOWER"&&SET "CAPS_SET=$EXT"&&SET "CAPS_VAR=%$EXT%"&&CALL:CAPS_SET
IF "%FILE_OPER%"=="Rename" REN "%$PICK%" "%FILE_PROMPT%%$EXT%">NUL 2>&1
IF "%FILE_OPER%"=="Copy" ECHO.Copying %FILE_PROMPT%%$EXT%...&&COPY /Y "%$PICK%" "%$PATH%%FILE_PROMPT%%$EXT%">NUL 2>&1
:BASIC_ERROR
SET "FILE_OPER="&&SET "FILE_TYPE="&&SET "FILE_NAME="&&SET "FILE_SKIP="&&SET "$PICK="
EXIT /B
:VHDX_MOVE
IF NOT "%FOLDER_MODE%"=="ISOLATED" EXIT /B
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                       Move VHDX between folders&&ECHO.&&ECHO.  %@@%IMAGE FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&ECHO.                               ( %##%-%$$% / %##%+%$$% )&&ECHO.&&ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
IF "%SELECT%"=="-" CALL:MOVE2IMAGE
IF "%SELECT%"=="+" CALL:MOVE2MAIN
GOTO:VHDX_MOVE
:MOVE2IMAGE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                         Move to image folder&&ECHO.&&ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%ImageFolder%\%$CHOICE%" CALL:PAD_LINE&&ECHO. File already exists in IMAGE folder. Press (%##%X%$$%) to overwrite %@@%%$CHOICE%%$$%.&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%ImageFolder%\%$CHOICE%" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED $PICK MOVE /Y "%$PICK%" "%ImageFolder%\">NUL
EXIT /B
:MOVE2MAIN
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                          Move to main folder&&ECHO.&&ECHO.  %@@%IMAGE FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%ProgFolder%\%$CHOICE%" CALL:PAD_LINE&&ECHO. File already exists in MAIN folder. Press (%##%X%$$%) to overwrite %@@%%$CHOICE%%$$%.&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%ProgFolder%\%$CHOICE%" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED $PICK MOVE /Y "%$PICK%" "%ProgFolder%\">NUL
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:DISK_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
::"MOUNTVOL","\\?\Volume{00000000-0000-0000-0000-100000000000}\","\\?\GLOBALROOT\Device\harddisk0\partition1\","\\?\BOOTPARTITION\"
@ECHO OFF&&CLS&&SET "DISK_LETTER="&&SET "DISK_MSG="&&SET "MISC_LAST=DISK"&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U04% Disk Management&&CALL:DISK_LIST_BASIC&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U04%DISK%$$%(%##%X%$$%)FILE%U02%     (%##%I%$$%)nspect    (%##%E%$$%)rase                  (%##%O%$$%)ptions&&CALL:PAD_LINE&&ECHO. [%@@%PART%$$%] (%##%C%$$%)reate     (%##%D%$$%)elete     (%##%F%$$%)ormat     (%##%M%$$%)ount     (%##%U%$$%)nmount&&CALL:PAD_LINE
IF DEFINED ADV_DISK ECHO. [%@@%IMAGE%$$%](%##%N%$$%)ew VHDX      (%##%V%$$%)HDX Mount     (%##%.%$$%)ISO Mount      (%##%U%$$%)nmount&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="X" GOTO:FILE_MANAGEMENT
IF "%SELECT%"=="N" CALL:VHDX_NEW_PROMPT&SET "SELECT="
IF "%SELECT%"=="U" CALL:DISK_UNMOUNT_PROMPT&SET "SELECT="
IF "%SELECT%"=="O" IF DEFINED ADV_DISK SET "ADV_DISK="&SET "SELECT="
IF "%SELECT%"=="O" IF NOT DEFINED ADV_DISK SET "ADV_DISK=1"&SET "SELECT="
IF "%SELECT%"=="." CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.  %@@%AVAILABLE ISOs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.ISO"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT&&CALL:ISO_MOUNT&SET "SELECT="
IF "%SELECT%"=="V" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.  %@@%AVAILABLE VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT&&CALL:VHDX_MOUNT&SET "SELECT="
IF "%SELECT%"=="UID" CALL:DISK_MENU&&CALL:DISK_UID_PROMPT&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="E" CALL:DISK_ERASE_PROMPT&&CALL:DISK_PART_END&&SET "SELECT="
IF "%SELECT%"=="I" SET "QUERY_MSG=                        Select a disk to inspect"&&CALL:DISK_MENU&&CALL:DISKMGR_INSPECT&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="C" SET "QUERY_MSG=                   Select a disk to create partition"&&CALL:DISK_MENU&&CALL:PART_CREATE_PROMPT&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="F" SET "QUERY_MSG=                   %COLOR2%Select a disk to format partition%$$%"&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:CONFIRM&&CALL:DISKMGR_FORMAT&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="D" SET "QUERY_MSG=                   %COLOR2%Select a disk to delete partition%$$%"&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:CONFIRM&&CALL:DISKMGR_DELETE&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="M" SET "QUERY_MSG=                   Select a disk to mount partition"&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:LETTER_GET&&CALL:CONFIRM&&CALL:DISKMGR_MOUNT&SET "SELECT="
GOTO:DISK_MANAGEMENT
:VHDX_NEW_PROMPT
SET "$HEADERS=                          %U04% Disk Management%U01% %U01%                        Enter name of new .VHDX"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=VHDX_NAME"&&CALL:PROMPT_BOX
IF DEFINED VHDX_NAME (SET "VHDX_NAME=%VHDX_NAME%.vhdx") ELSE (EXIT /B)
IF EXIST "%ImageFolder%\%VHDX_NAME%" SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG&&SET "VHDX_NAME="&&ECHO.&&ECHO.ERROR&&EXIT /B
SET "$HEADERS=                          %U04% Disk Management%U01% %U01% %U01% %U01%                       Enter new VHDX size in GB%U01% %U01% %U01% %U01%                 Note: 25GB or greater is recommended"&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER❗1-9999"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF %SELECTX% LSS 1 SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG
IF %SELECTX% GTR 9999 SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG
IF NOT DEFINED ERROR IF %SELECTX% LSS 25 CALL:CONFIRM
IF NOT DEFINED ERROR IF %SELECTX% LSS 25 IF NOT "%CONFIRM%"=="X" SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG
IF NOT DEFINED ERROR SET "VHDX_SIZE=%SELECTX%"
IF DEFINED ERROR EXIT /B
SET "$VDISK_FILE=%ImageFolder%\%VHDX_NAME%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_CREATE
SET "VHDX_NAME="&&EXIT /B
:DISK_UID
FOR %%a in (DISK_X UID_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.uniqueid disk id=%UID_X%&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK"
SET "DISK_X="&&SET "UID_X="&&CALL:DEL_DISK&&EXIT /B
:PART_ASSIGN
FOR %%a in (DISK_X PART_X LETT_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.assign letter=%LETT_X% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:VOL_REMOVE
FOR %%a in (LETT_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select VOLUME %LETT_X%&&ECHO.Remove letter=%LETT_X% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_REMOVE
FOR %%a in (DISK_X PART_X LETT_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.Remove letter=%LETT_X% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_DELETE
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.delete partition override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_FORMAT
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.format quick fs=ntfs override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK"
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_4000
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.gpt attributes=0x4000000000000001&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_8000
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.gpt attributes=0x0000000000000000&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_EFIX
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.set id=c12a7328-f81f-11d2-ba4b-00a0c93ec93b override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_BAS
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.set id=ebd0a0a2-b9e5-4433-87c0-68b6b72699c7 override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:DISK_CLEAN
FOR %%a in (DISK_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.attributes disk clear readonly&&ECHO.clean&&ECHO.convert gpt&&ECHO.select partition 1&&ECHO.delete partition override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:DEL_DISK
IF EXIST "$DISK" DEL /Q /F "$DISK">NUL
EXIT /B
:BOOT_FETCH
SET "$HEADERS= %U01% %U01% %U01% %U01%     File boot.sav doesn't exist. Press (%##%X%$$%) to copy from recovery%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" EXIT /B
CALL:EFI_MOUNT&&CALL:PAD_LINE
ECHO.Copying %@@%boot.sav%$$%...&&COPY /Y "%EFI_LETTER%:\$.WIM" "%CacheFolder%\boot.sav">NUL 2>&1
CALL:EFI_UNMOUNT
EXIT /B
:LETTER_GET
IF DEFINED ERROR EXIT /B
SET "$HEADERS=                          %U04% Disk Management%U01% %U01%                        Enter the drive letter"&&SET "$CHECK=LETTER"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "CAPS_SET=DISK_LETTER"&&SET "CAPS_VAR=%SELECT%"&&CALL:CAPS_SET
EXIT /B
:PART_GET
IF DEFINED ERROR EXIT /B
SET "$HEADERS=                          %U04% Disk Management%U01% %U01%                       Enter the partition number"&&SET "$CHECK=NUMBER"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "PART_NUMBER=%SELECT%"
EXIT /B
:DISK_PART_END
IF DEFINED ERROR EXIT /B
IF DEFINED DISK_MSG ECHO.&&CALL:PAD_LINE&&ECHO.%DISK_MSG%
ECHO.&&CALL:PAD_LINE&&ECHO	                      End of Disk-Part Operation&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PART_CREATE_PROMPT
IF DEFINED ERROR EXIT /B
IF NOT DEFINED DISK_NUMBER EXIT /B
SET "$HEADERS=                          %U04% Disk Management%U01% %U01%            Enter a partition size. (%##%0%$$%) Remainder of space"&&SET "$CHECK=NUMBER"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "PART_SIZE=%SELECT%"&&CALL:CONFIRM&&CALL:DISKMGR_CREATE
EXIT /B
:DISKMGR_CREATE
IF DEFINED ERROR EXIT /B
IF "%PART_SIZE%"=="0" SET "PART_SIZE="
ECHO.Creating partition on disk %DISK_NUMBER%.
SET "DISK_X=%DISK_NUMBER%"&&SET "SIZE_X=%PART_SIZE%"
IF DEFINED SIZE_X SET "SIZE_X= size=%SIZE_X%"
(ECHO.select disk %DISK_X%&&ECHO.create partition primary%SIZE_X%&&ECHO.format quick fs=ntfs&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
EXIT /B
:DISKMGR_DELETE
IF DEFINED ERROR EXIT /B
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&CALL:PART_DELETE
EXIT /B
:DISKMGR_FORMAT
IF DEFINED ERROR EXIT /B
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&CALL:PART_FORMAT
EXIT /B
:DISKMGR_INSPECT
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_NUMBER%&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK"
EXIT /B
:VDISK_CREATE
IF NOT DEFINED $VDISK_FILE EXIT /B
IF NOT DEFINED VDISK_LTR SET "VDISK_LTR=ANY"
IF "%VDISK_LTR%"=="ANY" SET "$GET=VDISK_LTR"&&CALL:LETTER_ANY
FOR %%G in ("%$VDISK_FILE%") DO (SET "VHDX_123=%%~nG%%~xG")
ECHO.Mounting vdisk %VHDX_123% letter %VDISK_LTR%...&&SET "VHDX_123="
IF NOT DEFINED VHDX_SIZE SET "VHDX_SIZE=25"
SET "VHDX_MB=%VHDX_SIZE%"
SET /A "VHDX_MB*=1025"
(ECHO.create vdisk file="%$VDISK_FILE%" maximum=%VHDX_MB% type=expandable&&ECHO.select vdisk file="%$VDISK_FILE%"&&ECHO.attach vdisk&&ECHO.create partition primary&&ECHO.select partition 1&&ECHO.format fs=ntfs quick&&ECHO.assign letter=%VDISK_LTR% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "VHDX_MB="&&IF EXIST "$DISK" DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:VDISK_ATTACH
IF NOT DEFINED $VDISK_FILE EXIT /B
IF NOT DEFINED VDISK_LTR SET "VDISK_LTR=ANY"
IF "%VDISK_LTR%"=="ANY" SET "$GET=VDISK_LTR"&&CALL:LETTER_ANY
FOR %%G in ("%$VDISK_FILE%") DO (SET "VHDX_123=%%~nG%%~xG")
ECHO.Mounting vdisk %VHDX_123% letter %VDISK_LTR%...
:VDISK_RETRY
(ECHO.Select vdisk file="%$VDISK_FILE%"&&ECHO.attach vdisk&&ECHO.list vdisk&&ECHO.Exit)>"$DISK"
IF NOT EXIST "%VDISK_LTR%:\" IF NOT DEFINED VRETRY CALL:VDISK_DETACH>NUL 2>&1
IF NOT EXIST "%VDISK_LTR%:\" FOR /F "TOKENS=1-8* DELIMS=* " %%a IN ('DISKPART /s "$DISK"') DO (SET "DISK_NUM="&&IF "%%a"=="VDisk" IF /I "%%i"=="%$VDISK_FILE%" IF EXIST "%%i" SET "DISK_NUM=%%d"&&SET "VDISK_QRY=%%i"&&CALL:VDISK_ASGN)
IF NOT EXIST "%VDISK_LTR%:\" IF NOT DEFINED VRETRY SET "VRETRY=1"&&GOTO:VDISK_RETRY
SET "VRETRY="&&SET "VHDX_123="&&SET "VDISK_PART="&&SET "VDISK_QRY="&&SET "DISK_NUM="&&IF EXIST "$DISK" DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:VDISK_ASGN
SET "$PASS="&&SET "VDISK=%$VDISK_FILE%"
IF /I "%VDISK_QRY%"=="%$VDISK_FILE%" SET "$PASS=1"
IF NOT DEFINED $PASS EXIT /B
(ECHO.select disk %DISK_NUM%&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-8* DELIMS=* " %%1 IN ('DISKPART /s "$DISK"') DO (IF "%%1"=="Partition" IF NOT "%%2"=="" IF NOT "%%2"=="###" SET "VDISK_PART=%%2")
IF DEFINED VDISK_PART (ECHO.Select vdisk file="%$VDISK_FILE%"&&ECHO.select partition %VDISK_PART%&&ECHO.assign letter=%VDISK_LTR% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
EXIT /B
:VDISK_DETACH
IF NOT DEFINED $VDISK_FILE EXIT /B
FOR %%G in ("%$VDISK_FILE%") DO (SET "VHDX_123=%%~nG%%~xG")
ECHO.Unmounting vdisk %VHDX_123% letter %VDISK_LTR%...&&SET "VHDX_123="
(ECHO.Select vdisk file="%$VDISK_FILE%"&&ECHO.Detach vdisk&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
IF EXIST "$DISK*" DEL /Q /F "$DISK*">NUL 2>&1
EXIT /B
:VDISK_COMPACT
(ECHO.Select vdisk file="%$PICK%"&&ECHO.Attach vdisk readonly&&ECHO.compact vdisk&&ECHO.detach vdisk&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK"&&DEL /F "$DISK">NUL 2>&1
EXIT /B
:VHDX_MOUNT
IF NOT DEFINED $PICK EXIT /B
SET "$VDISK_FILE=%$PICK%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT EXIST "%VDISK_LTR%:\" ECHO.ERROR&&CALL:VDISK_DETACH
EXIT /B
:ISO_MOUNT
IF NOT DEFINED $PICK EXIT /B
"%$PICK%"
EXIT /B
:DISKMGR_MOUNT
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER DISK_LETTER PART_NUMBER) DO (IF NOT DEFINED %%a EXIT /B)
IF EXIST "%DISK_LETTER%:\" ECHO.%COLOR4%ERROR:%$$% Select a different drive letter.&&EXIT /B
IF "%PROG_MODE%"=="RAMDISK" IF "%DISK_LETTER%"=="Z" ECHO.%COLOR4%ERROR:%$$% Select a different drive letter.&&EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" ECHO.&&ECHO.Mounting disk %DISK_NUMBER% partition %PART_NUMBER% to letter %DISK_LETTER%:\...
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&SET "LETT_X=%DISK_LETTER%"&&CALL:PART_ASSIGN
IF NOT EXIST "%DISK_LETTER%:\" SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&SET "LETT_X=%DISK_LETTER%"&&CALL:PART_ASSIGN
IF EXIST "%DISK_LETTER%:\" SET "DISK_MSG=Partition %PART_NUMBER% on Disk %DISK_NUMBER% has been assigned letter %DISK_LETTER%."
IF NOT EXIST "%DISK_LETTER%:\" SET "DISK_MSG=ERROR: Partition %PART_NUMBER% on Disk %DISK_NUMBER% was not assigned letter %DISK_LETTER%."
EXIT /B
:DISK_UNMOUNT_PROMPT
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                            Volume Unmount&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO. ^( %##%%%G%$$% ^) Volume %%G:)
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=$LTR"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF DEFINED $LTR CALL:DISKMGR_UNMOUNT
EXIT /B
:LETTER_ANY
IF NOT DEFINED $GET EXIT /B
FOR %%G in (Z Y X W V U T S R Q P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" SET "%$GET%=%%G")
SET "$GET="&&EXIT /B
:DISKMGR_UNMOUNT
IF NOT EXIST "%$LTR%:\" EXIT /B
SET "$CHECK=LETTER"&&SET "CHECK_VAR=%$LTR%"&&CALL:CHECK
IF DEFINED ERROR GOTO:DISKMGR_UNMOUNT_END
(ECHO.List Volume&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-9 DELIMS= " %%a IN ('DISKPART /s "$DISK"') DO (IF "%%c"=="%$LTR%" SET "$VOL=%%b")
(ECHO.Select Volume %$VOL%&&ECHO.Detail Volume&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-9 DELIMS= " %%a IN ('DISKPART /s "$DISK"') DO (
IF "%%a"=="Disk" IF NOT "%%b"=="###" SET "$DISK=%%b"
IF "%%a"=="*" IF "%%b"=="Disk" SET "$DISK=%%c")
(ECHO.List Vdisk&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-8* DELIMS= " %%a IN ('DISKPART /s "$DISK"') DO (IF "%%a"=="VDisk" IF "%%d"=="%$DISK%" IF EXIST "%%i" SET "$VDISK=%%i"&&FOR %%G in ("%%i") DO (SET "$NAM=%%~nG%%~xG"))
IF NOT DEFINED $VDISK ECHO.Unmounting disk %$DISK% letter %$LTR%...&&(ECHO.Select Volume %$VOL%&&ECHO.Remove letter=%$LTR% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
IF DEFINED $VDISK ECHO.Unmounting vdisk %$NAM% letter %$LTR%...&&(ECHO.Select vdisk file="%$VDISK%"&&ECHO.Detach vdisk&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK" >NUL 2>&1
:DISKMGR_UNMOUNT_END
FOR %%G in ($DISK $VDISK $VOL $NAM $LTR) DO (SET "%%G=")
IF EXIST "$DISK" DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:DISK_ERASE_PROMPT
SET "QUERY_MSG=                         %COLOR2%Select a disk to erase%$$%"&&CALL:DISK_MENU
IF NOT DEFINED ERROR CALL:CONFIRM&&SET "$GET=TST_LETTER"&&CALL:LETTER_ANY&&CALL:DISKMGR_ERASE&SET "TST_LETTER="
EXIT /B
:DISKMGR_ERASE
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER) DO (IF NOT DEFINED %%a EXIT /B)
CALL SET "GET_DISK_ID=%%DISKID_%DISK_NUMBER%%%"
SET "DISK_X=%DISK_NUMBER%"&&CALL:DISK_CLEAN&&SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&SET "LETT_X=%TST_LETTER%"&&CALL:PART_ASSIGN
IF EXIST "%TST_LETTER%:\" SET "DISK_X=%DISK_NUMBER%"&&CALL:DISK_CLEAN
CALL:DISKMGR_CHANGEID>NUL 2>&1
IF NOT EXIST "%TST_LETTER%:\" SET "DISK_MSG=All partitions on Disk %DISK_NUMBER% have been erased."
IF EXIST "%TST_LETTER%:\" SET "DISK_MSG=%##%Disk %DISK_NUMBER% is currently in use - unplug disk - reboot into Windows - replug and try again.%$$%"
IF EXIST "%TST_LETTER%:\" SET "LETT_X=%TST_LETTER%"&&CALL:VOL_REMOVE
IF EXIST "%TST_LETTER%:\" SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&SET "LETT_X=%TST_LETTER%"&&CALL:PART_REMOVE
SET "TEST_X="&&EXIT /B
:DISK_UID_PROMPT
ECHO.                       Enter a new disk UID (%##%#%$$%) &&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT SET "ERROR=DISK_UID_PROMPT"&&CALL:DEBUG&&EXIT /B
IF NOT DEFINED ERROR SET "GET_DISK_ID=%SELECT%"&&CALL:CONFIRM&&CALL:DISKMGR_CHANGEID
EXIT /B
:DISKMGR_CHANGEID
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER GET_DISK_ID) DO (IF NOT DEFINED %%a EXIT /B)
SET "UID_XNT="&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%GET_DISK_ID%^| FIND /V ""') do (CALL SET /A "UID_XNT+=1")
IF NOT "%UID_XNT%"=="36" SET "GET_DISK_ID=00000000-0000-0000-0000-000000000000"
SET "UID_X=%GET_DISK_ID%"&&SET "DISK_X=%DISK_NUMBER%"&&CALL:DISK_UID
EXIT /B
:HOST_HIDE
ECHO.Hiding the vhdx host partition...&&SET /P DISK_TARGET=<"%ProgFolder0%\HOST_TARGET"&&CALL:DISK_DETECT>NUL 2>&1
IF NOT DEFINED DISK_DETECT EXIT /B
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&SET "LETT_X=Z"&&CALL:PART_REMOVE&&SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&CALL:PART_4000
EXIT /B
:HOST_AUTO
SET "HOST_ERROR="&&IF NOT DEFINED ARBIT_FLAG CLS&&ECHO.Querying disks...
IF EXIST "Z:\" (ECHO.select volume Z&&ECHO.remove letter=Z noerr&&ECHO.exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
IF EXIST "%ProgFolder0%\HOST_FOLDER" SET /P HOST_FOLDERX=<"%ProgFolder0%\HOST_FOLDER"
IF NOT DEFINED HOST_FOLDERX SET "HOST_FOLDERX=$"
SET /P HOST_TARGET=<"%ProgFolder0%\HOST_TARGET"
SET "DISK_TARGET=%HOST_TARGET%"
IF DEFINED ARBIT_FLAG CALL:DISK_DETECT>NUL 2>&1
IF NOT DEFINED ARBIT_FLAG SET "QUERY_X=1"&&CALL:DISK_DETECT
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&CALL:PART_8000&&SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&SET "LETT_X=Z"&&CALL:PART_ASSIGN
IF EXIST "Z:\" IF NOT EXIST "Z:\%HOST_FOLDERX%" MD "Z:\%HOST_FOLDERX%">NUL 2>&1
IF EXIST "Z:\%HOST_FOLDERX%" IF NOT EXIST "Z:\%HOST_FOLDERX%\gploy.cmd" COPY /Y "%ProgFolder0%\gploy.cmd" "Z:\%HOST_FOLDERX%">NUL 2>&1
IF EXIST "Z:\%HOST_FOLDERX%\gploy.ini" COPY /Y "Z:\%HOST_FOLDERX%\gploy.ini" "%ProgFolder0%">NUL 2>&1
IF NOT DEFINED SETS_LOAD IF EXIST "%ProgFolder0%\SETTINGS_INI" COPY /Y "%ProgFolder0%\SETTINGS_INI" "%ProgFolder0%\gploy.ini">NUL 2>&1
IF NOT EXIST "Z:\%HOST_FOLDERX%" IF NOT DEFINED ARBIT_FLAG SET "ARBIT_FLAG=1"&&GOTO:HOST_AUTO
SET "ARBIT_FLAG="&&IF EXIST "Z:\%HOST_FOLDERX%" SET "ProgFolder=Z:\%HOST_FOLDERX%"&&SET "HOST_NUMBER=%DISK_DETECT%"
IF NOT DEFINED DISK_DETECT SET "HOST_ERROR=1"&&SET "DISK_TARGET="
EXIT /B
:EFI_MOUNT
IF NOT DEFINED DISK_TARGET SET "EFI_LETTER="&&EXIT /B
SET "$GET=EFI_LETTER"&&CALL:LETTER_ANY
SET /P HOST_TARGET=<"%ProgFolder0%\HOST_TARGET"
SET "DISK_TARGET=%HOST_TARGET%"&&CALL:DISK_DETECT>NUL 2>&1
IF NOT DEFINED DISK_DETECT SET "ERROR=EFI_MOUNT"&&CALL:DEBUG&&ECHO.%COLOR2%ERROR:%$$% EFI target disk could not be found.&&SET "EFI_LETTER="&&EXIT /B
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&CALL:PART_BAS
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&SET "LETT_X=%EFI_LETTER%"&&CALL:PART_ASSIGN
IF NOT EXIST "%EFI_LETTER%:\" SET "ERROR=EFI_MOUNT"&&CALL:DEBUG&&ECHO.%COLOR2%ERROR:%$$% EFI %EFI_LETTER%:\ could not be mounted.&&SET "EFI_LETTER="
EXIT /B
:EFI_UNMOUNT
IF NOT DEFINED DISK_TARGET SET "EFI_LETTER="
IF NOT EXIST "%EFI_LETTER%:\" SET "EFI_LETTER="
IF NOT DEFINED EFI_LETTER EXIT /B
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&SET "LETT_X=%EFI_LETTER%"&&CALL:PART_REMOVE
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&CALL:PART_EFIX
IF EXIST "%EFI_LETTER%:\" SET "ERROR=EFI_UNMOUNT"&&CALL:DEBUG&&ECHO.%COLOR2%ERROR:%$$% EFI %EFI_LETTER%:\ could not dismount.
SET "EFI_LETTER="&&EXIT /B
:DISK_MENU
CLS&&SET "DISK_TARGET="&&CALL:PAD_LINE&&SET "DISK_GET=1"&&CALL:DISK_LIST
CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER"&&SET "$VERBOSE=1"&&SET "$SELECT=DISK_NUMBER"&&CALL:MENU_SELECT
IF NOT DEFINED DISK_%DISK_NUMBER% SET "ERROR=DISK_MENU"&&CALL:DEBUG
IF DEFINED ERROR EXIT /B
CALL SET "DISK_TARGET=%%DISKID_%DISK_NUMBER%%%"
FOR %%G in (DISK_NUMBER DISK_TARGET) DO (IF NOT DEFINED %%G SET "ERROR=DISK_MENU"&&CALL:DEBUG)
IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_NUMBER%"=="%DISK_NUMBER%" SET "ERROR=DISK_MENU"&&CALL:DEBUG
IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_TARGET%"=="%DISK_TARGET%" SET "ERROR=DISK_MENU"&&CALL:DEBUG
EXIT /B
:DISK_LIST
SET "$BOX=RT"&&CALL:BOX_DISP
IF DEFINED QUERY_MSG ECHO.%QUERY_MSG%
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%SystemDrive%") DO (SET "SYS_VOLUME=%%G")
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%ProgFolder%") DO (SET "PROG_VOLUME=%%G")
(ECHO.LIST DISK&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-5 SKIP=8 DELIMS= " %%a in ('DISKPART /s "$DISK"') DO (
IF "%%a"=="Disk" IF NOT "%%b"=="###" SET "DISKVND="&&(ECHO.select disk %%b&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&SET "LTRX=X"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS={}: " %%1 in ('DISKPART /s "$DISK"') DO (
IF "%%1 %%2"=="Disk %%b" ECHO.&&ECHO.   %@@%Disk%$$% ^(%##%%%b%$$%^)
IF NOT "%%1 %%2"=="Disk %%b" IF NOT DEFINED DISKVND SET "DISKVND=$"&&ECHO.   %%1 %%2 %%3 %%4 %%5
IF "%%1"=="Type" ECHO.    %@@%Type%$$% = %%2
IF "%%1 %%2"=="Disk ID" ECHO.    %@@%UID%$$%  = %%3
IF "%%1 %%3"=="Volume %SYS_VOLUME%" ECHO.  %COLOR2%  System Volume%$$%
IF "%%1 %%3"=="Volume %PROG_VOLUME%" ECHO.  %COLOR2%  Program Volume%$$%
IF "%%1 %%2 %%3"=="Pagefile Disk Yes" ECHO.  %COLOR2%  Active Pagefile%$$%
IF "%%1"=="Partition" IF NOT "%%2"=="###" SET "PARTX=%%2"&&SET "SIZEX=%%4 %%5"&&(ECHO.select disk %%b&&ECHO.select partition %%2&&ECHO.detail partition&&ECHO.Exit)>"$DISK"&&SET "LTRX="&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS=* " %%A in ('DISKPART /s "$DISK"') DO (IF "%%A"=="Volume" IF NOT "%%B"=="###" SET "LTRX=%%C"&&CALL:DISK_CHECK)
IF NOT DEFINED LTRX IF NOT "%%2"=="DiskPart..." ECHO.    %@@%Part %%2%$$% Vol * %%4 %%5))
IF DEFINED DISK_GET CALL:DISK_DETECT>NUL 2>&1
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP
FOR %%a in ($GO LTRX PARTX SIZEX QUERY_MSG DISK_GET) DO (SET "%%a=")
DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:DISK_CHECK
SET "$GO="&&FOR %%■ in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%%■"=="%LTRX%" SET "$GO=1"&&ECHO.    %@@%Part %PARTX%%$$% Vol %@@%%LTRX%%$$% %SIZEX%)
IF NOT DEFINED $GO ECHO.    %@@%Part %PARTX%%$$% Vol * %SIZEX%
EXIT /B
:DISK_LIST_BASIC
(ECHO.LIST DISK&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-5 SKIP=8 DELIMS= " %%a in ('DISKPART /s "$DISK"') DO (
IF "%%a"=="Disk" IF NOT "%%b"=="###" ECHO.&&ECHO.   %@@%%%a%$$% %@@%%%b%$$%&&SET "DISKVND="&&(ECHO.select disk %%b&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS={}: " %%1 in ('DISKPART /s "$DISK"') DO (
IF NOT "%%1 %%2"=="Disk %%b" IF NOT DEFINED DISKVND SET "DISKVND=$"&&ECHO.   %%1 %%2 %%3 %%4 %%5
FOR %%■ in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%%1"=="Volume" IF "%%3"=="%%■" ECHO.    Vol %@@%%%■%$$%)))
ECHO.&&DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:DISK_DETECT
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%SystemDrive%") DO (SET "SYS_VOLUME=%%G")
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%ProgFolder%") DO (SET "PROG_VOLUME=%%G")
SET "DISK_DETECT="&&FOR %%a in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30) DO (IF DEFINED DISK_%%a SET "DISK_%%a="&&SET "DISKID_%%a=")
(ECHO.LIST DISK&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1,2,4 SKIP=8 DELIMS= " %%a in ('DISKPART /s "$DISK"') DO (IF "%%a"=="Disk" IF NOT "%%b"=="###" SET "DISK_%%b="&&(ECHO.select disk %%b&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS={}: " %%1 in ('DISKPART /s "$DISK"') DO (
IF "%%1 %%2"=="Disk %%b" SET "DISK_%%b=%%b"
IF "%%1 %%2"=="Disk ID" SET "DISKID_%%b=%%3"&&IF "%%3"=="%DISK_TARGET%" SET "DISK_DETECT=%%b"
IF "%%1 %%2"=="Disk ID" IF DEFINED QUERY_X ECHO.Getting info for disk uid %##%%%3%$$%...
IF "%%1 %%2 %%3"=="Pagefile Disk Yes" SET "DISK_%%b="
IF "%%2 %%3 %%4"=="File Backed Virtual" SET "DISK_%%b=VDISK"
IF "%%1 %%3"=="Volume %SYS_VOLUME%" SET "DISK_%%b="
IF "%%1 %%3"=="Volume %PROG_VOLUME%" SET "DISK_%%b="
IF "%%1 %%3"=="Volume Z" IF "%PROG_MODE%"=="RAMDISK" SET "HOST_VOLUME=%%2"))
IF DEFINED QUERY_X SET "QUERY_X="&&CLS
DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:BOOT_CREATOR
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U04% BootDisk Creator&&ECHO.&&ECHO.  %@@%AVAILABLE VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&ECHO. (%##%O%$$%)ptions                     (%##%C%$$%)reate        (%##%V%$$%)HDX %@@%%VHDX_SLOTX%%$$%&&CALL:PAD_LINE
IF DEFINED ADV_BOOT ECHO. [%@@%OPTIONS%$$%]   (%##%A%$$%)dd File      (%##%E%$$%)xport EFI      (%##%W%$$%)allpaper %@@%%PE_WALLPAPER%%$$%&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="E" CALL:EFI_FETCH
IF "%SELECT%"=="V" SET "$VHDX=X"&&CALL:VHDX_CHECK
IF "%SELECT%"=="O" IF DEFINED ADV_BOOT SET "ADV_BOOT="&SET "SELECT="
IF "%SELECT%"=="O" IF NOT DEFINED ADV_BOOT SET "ADV_BOOT=1"&SET "SELECT="
IF "%SELECT%"=="A" CALL:ADDFILE_MENU
IF "%SELECT%"=="C" CALL:BOOT_CREATOR_PROMPT
IF "%SELECT%"=="W" CALL:PE_WALLPAPER
GOTO:BOOT_CREATOR
:ADDFILE_MENU
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.
FOR %%G in (0 1 2 3 4 5 6 7 8 9) DO (CALL ECHO. File ^(%##%%%G%$$%^) %@@%%%ADDFILE_%%G%%%$$%)
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
FOR %%G in (0 1 2 3 4 5 6 7 8 9) DO (IF "%SELECT%"=="%%G" SET "ADDFILEX=%SELECT%"&&CALL:ADDFILE_CHOOSE)
GOTO:ADDFILE_MENU
:ADDFILE_CHOOSE
CLS&&SET "ADDFILEZ="&&IF "%FOLDER_MODE%"=="UNIFIED" SET "SELECTX=5"&&GOTO:ADDFILE_JUMP
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.&&ECHO. (%##%1%$$%) Package&&ECHO. (%##%2%$$%) List&&CALL ECHO. (%##%3%$$%) Image&&ECHO. (%##%4%$$%) Cache&&ECHO. (%##%5%$$%) Main&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER❗1-5"&&SET "$SELECT=SELECTX"&&CALL:MENU_SELECT
IF NOT "%SELECTX%"=="1" IF NOT "%SELECTX%"=="2" IF NOT "%SELECTX%"=="3" IF NOT "%SELECTX%"=="4" IF NOT "%SELECTX%"=="5" EXIT /B
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.
IF "%SELECTX%"=="1" SET "ADDFILEZ=pack" ECHO.  %@@%AVAILABLE PACKAGEs:%$$%&&ECHO.&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST
IF "%SELECTX%"=="2" SET "ADDFILEZ=list"&&ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.LIST *.BASE"&&CALL:FILE_LIST
IF "%SELECTX%"=="3" SET "ADDFILEZ=image"&&ECHO.  %@@%AVAILABLE IMAGEs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM *.VHDX *.ISO"&&CALL:FILE_LIST
IF "%SELECTX%"=="4" SET "ADDFILEZ=cache"&&ECHO.  %@@%AVAILABLE CACHE FILEs:%$$%&&ECHO.&&SET "$FOLD=%CacheFolder%"&&SET "$FILT=*.*"&&CALL:FILE_LIST
:ADDFILE_JUMP
IF "%SELECTX%"=="5" SET "ADDFILEZ=main"&&ECHO.  %@@%AVAILABLE MAIN FILEs:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.*"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED ADDFILEZ IF DEFINED $PICK IF EXIST "%$PICK%" IF NOT EXIST "%$PICK%\*" SET "ADDFILE_%ADDFILEX%=%ADDFILEZ%\%$CHOICE%"
IF DEFINED ADDFILEZ IF NOT DEFINED $PICK SET "ADDFILE_%ADDFILEX%=SELECT"
EXIT /B
:EFI_FETCH
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.        EFI boot files will be extracted from the boot media.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:CONFIRM
IF NOT "%CONFIRM%"=="X" EXIT /B
CLS&&IF EXIST "%CacheFolder%\boot.sdi" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.         File boot.sdi already exists. Press (%##%X%$$%) to overwrite&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF EXIST "%CacheFolder%\boot.sdi" IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%CacheFolder%\bootmgfw.efi" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.       File bootmgfw.efi already exists. Press (%##%X%$$%) to overwrite&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF EXIST "%CacheFolder%\bootmgfw.efi" IF NOT "%CONFIRM%"=="X" EXIT /B
CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.            %@@%EFI EXPORT START:%$$%  %DATE%  %TIME%&&ECHO.&&CALL:VTEMP_CREATE&ECHO.Extracting boot-media. Using boot.sav located in folder...
SET "$IMAGE_X=%CacheFolder%\boot.sav"&&SET "INDEX_WORD=Setup"&&CALL:GET_WIMINDEX
IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%CacheFolder%\boot.sav" /INDEX:%INDEX_Z% /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF EXIST "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" ECHO.File boot.sdi was found. Copying to folder.&&COPY /Y "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" "%CacheFolder%">NUL 2>&1
IF EXIST "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" ECHO.File bootmgfw.efi was found. Copying to folder.&&COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" "%CacheFolder%">NUL 2>&1
ECHO.&&ECHO.EFI boot files will be used during boot creation when present.&&ECHO.&&CALL:VTEMP_DELETE&&ECHO.&&ECHO.             %@@%EFI EXPORT END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED
EXIT /B
:BOOT_CREATOR_PROMPT
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%CacheFolder%\boot.sav" CALL:BOOT_FETCH
IF NOT EXIST "%CacheFolder%\boot.sav" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.   Import boot media from within image processing before proceeding.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED&&EXIT /B
IF "%VHDX_SLOTX%"=="SELECT" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.&&ECHO.              No virtual hard disk file has been selected.&&ECHO.        Virtual disks can be added to the boot menu in Recovery.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:CONFIRM
IF "%VHDX_SLOTX%"=="SELECT" IF NOT "%CONFIRM%"=="X" EXIT /B
SET "QUERY_MSG=                         %COLOR2%Select a disk to erase%$$%"&&CALL:DISK_MENU
IF DEFINED ERROR EXIT /B
CALL:CONFIRM
IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED DISK_NUMBER CALL:BOOT_CREATOR_START
EXIT /B
:PART_CREATE
IF DEFINED ERROR EXIT /B
CALL:DISKMGR_ERASE
IF NOT DEFINED EFI SET "EFI=efi"
IF NOT DEFINED EFI_SIZE SET "EFI_SIZE=1024"
(ECHO.select disk %DISK_NUMBER%&&ECHO.create partition %EFI% size=%EFI_SIZE%&&ECHO.select partition 1&&ECHO.format quick fs=fat32 label="ESP"&&ECHO.assign letter=%EFI_LETTER% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "TIMER=3"&&CALL:TIMER
IF NOT EXIST "%EFI_LETTER%:\" (ECHO.select disk %DISK_NUMBER%&&ECHO.select partition 1&&ECHO.format quick fs=fat32 label="ESP"&&ECHO.assign letter=%EFI_LETTER% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "TIMER=3"&&CALL:TIMER
IF NOT EXIST "%EFI_LETTER%:\" FOR %%a in (1 2 3) DO (IF NOT DEFINED RETRY_PART%%a SET "RETRY_PART%%a=1"&&SET "EFI=primary"&&GOTO:PART_CREATE)
(ECHO.select disk %DISK_NUMBER%&&ECHO.create partition primary&&ECHO.select partition 2&&ECHO.format quick fs=ntfs&&ECHO.assign letter=%PRI_LETTER% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "TIMER=3"&&CALL:TIMER
IF NOT EXIST "%PRI_LETTER%:\" (ECHO.select disk %DISK_NUMBER%&&ECHO.select partition 2&&ECHO.format quick fs=ntfs&&ECHO.assign letter=%PRI_LETTER% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "TIMER=3"&&CALL:TIMER&&DEL /Q /F "$DISK">NUL 2>&1
SET "RETRY_PART1="&&SET "RETRY_PART2="&&SET "RETRY_PART3="
IF EXIST "%EFI_LETTER%:\" IF EXIST "%PRI_LETTER%:\" SET "EFI="&&EXIT /B
ECHO.                     %COLOR2%The disk is currently in use.%$$%&&ECHO.     A malfunctioning disk, or if a program located on the disk&&ECHO.            is currently in use can also cause an error.&&ECHO.  For best results it is recommended to use an external nvme drive.&&ECHO.    Unplug the USB disk and/or reboot if this continues to occur.&&ECHO.
SET "EFI="&&ECHO.&&SET "ERROR=PART_CREATE"&&CALL:DEBUG&&EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:BOOT_CREATOR_START
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%BOOT CREATOR START:%$$%  %DATE%  %TIME%&&ECHO.&&CALL:GET_SPACE_ENV
SET "DISK_MSG="&&%DISM% /cleanup-MountPoints>NUL 2>&1
SET "CHAR_STR=%VHDX_SLOTX%"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK
IF DEFINED CHAR_FLG ECHO.%COLOR4%ERROR:%$$% Remove the space from the VHDX name, then try again. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_FINISH
FOR %%a in (0 1 2 3 4 5 ERROR) DO (IF "%FREE%"=="%%a" ECHO.%COLOR2%ERROR:%$$% Not enough free space. Clear some space and try again. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_FINISH)
CALL:DISK_DETECT>NUL&CALL SET "DISK_TARGET=%%DISKID_%DISK_NUMBER%%%"&CALL:DISK_DETECT>NUL
SET "UID_XNT="&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%DISK_TARGET%^| FIND /V ""') do (CALL SET /A "UID_XNT+=1")
IF NOT "%UID_XNT%"=="36" (ECHO.Converting to GPT..&&CALL:DISKMGR_ERASE&&CALL:DISK_DETECT>NUL 2>&1
CALL SET "DISK_TARGET=%%DISKID_%DISK_NUMBER%%%"&&CALL ECHO.Assigning new disk uid %%DISKID_%DISK_NUMBER%%%...&&CALL:DISK_DETECT>NUL 2>&1)
SET "UID_XNT="&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%DISK_TARGET%^| FIND /V ""') do (CALL SET /A "UID_XNT+=1")
IF NOT "%UID_XNT%"=="36" ECHO.%COLOR2%ERROR:%$$% Disk could not be converted to GPT. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_FINISH
FOR %%a in (DISK_DETECT DISK_NUMBER DISK_TARGET) DO (IF NOT DEFINED %%a ECHO.%COLOR2%ERROR:%$$% Unable to query disk number or uid.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_FINISH)
SET "EFI_LETTER="&&FOR %%G in (Z Y X W V U T S R Q P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" SET "EFI_LETTER=%%G")
SET "PRI_LETTER="&&FOR %%G in (Z Y X W V U T S R Q P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" IF NOT "%%G"=="%EFI_LETTER%" SET "PRI_LETTER=%%G")
SET "TST_LETTER="&&FOR %%G in (Z Y X W V U T S R Q P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" IF NOT "%%G"=="%EFI_LETTER%" IF NOT "%%G"=="%PRI_LETTER%" SET "TST_LETTER=%%G")
ECHO.Creating partitions on disk uid %DISK_TARGET%...&&CALL:PART_CREATE
IF DEFINED ERROR GOTO:BOOT_CLEANUP
ECHO.Mounting temporary vdisk...&&MD "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
FOR %%a in (%PRI_LETTER%: %PRI_LETTER%:\%HOST_FOLDER%) DO (ICACLS "%%a" /deny everyone:^(DE,WA,WDAC^)>NUL 2>&1)
SET "$VDISK_FILE=%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.vhdx"&&SET "VDISK_LTR=ANY"&&SET "VHDX_SIZE=50"&&CALL:VDISK_CREATE>NUL 2>&1
IF EXIST "%CacheFolder%\BOOT.SAV" ECHO.Extracting boot-media. Using boot.sav located in folder...&&COPY /Y "%CacheFolder%\boot.sav" "%PRI_LETTER%:\%HOST_FOLDER%\boot.wim">NUL 2>&1
SET "$IMAGE_X=%PRI_LETTER%:\%HOST_FOLDER%\boot.wim"&&SET "INDEX_WORD=Setup"&&CALL:GET_WIMINDEX
IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
SET "$IMAGE_X=%PRI_LETTER%:\%HOST_FOLDER%\boot.wim"&&SET "INDEX_X=%INDEX_Z%"&&CALL:GET_IMAGEINFO
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File boot.sav is corrupt. Abort.&&GOTO:BOOT_CLEANUP
ECHO. v%$IMGVER%&&%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%PRI_LETTER%:\%HOST_FOLDER%\boot.wim" /INDEX:%INDEX_Z% /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
MOVE /Y "%PRI_LETTER%:\%HOST_FOLDER%\boot.wim" "%PRI_LETTER%:\%HOST_FOLDER%\boot.sav">NUL 2>&1
IF NOT EXIST "%VDISK_LTR%:\Windows" ECHO.%COLOR2%ERROR:%$$% Files created with boot.sav are corrupt. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
MD "%VDISK_LTR%:\$">NUL 2>&1
ECHO.%DISK_TARGET%>"%VDISK_LTR%:\$\HOST_TARGET"
ECHO.%HOST_FOLDER%>"%VDISK_LTR%:\$\HOST_FOLDER"
COPY /Y "%ProgFolder0%\gploy.cmd" "%VDISK_LTR%:\$">NUL&COPY /Y "%ProgFolder0%\gploy.cmd" "%PRI_LETTER%:\%HOST_FOLDER%">NUL&COPY /Y "%ProgFolder%\gploy.ini" "%PRI_LETTER%:\%HOST_FOLDER%">NUL
FOR %%a in (Boot EFI\Boot EFI\Microsoft\Boot) DO (MD %EFI_LETTER%:\%%a>NUL 2>&1)
IF EXIST "%CacheFolder%\boot.sdi" ECHO.Using boot.sdi located in folder, for efi image boot support.&&COPY /Y "%CacheFolder%\boot.sdi" "%EFI_LETTER%:\Boot">NUL
IF NOT EXIST "%CacheFolder%\boot.sdi" COPY /Y "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" "%EFI_LETTER%:\Boot">NUL 2>&1
IF NOT EXIST "%EFI_LETTER%:\Boot\boot.sdi" ECHO.%COLOR2%ERROR:%$$% boot.sdi missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
IF EXIST "%CacheFolder%\bootmgfw.efi" ECHO.Using bootmgfw.efi located in folder, for the efi bootloader.&&COPY /Y "%CacheFolder%\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL
IF NOT EXIST "%CacheFolder%\bootmgfw.efi" COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL 2>&1
IF NOT EXIST "%EFI_LETTER%:\EFI\Boot\bootx64.efi" ECHO.%COLOR2%ERROR:%$$% bootmgfw.efi missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
IF DEFINED PE_WALLPAPER IF EXIST "%CacheFolder%\%PE_WALLPAPER%" (ECHO.Using %PE_WALLPAPER% for the recovery wallpaper.
TAKEOWN /F "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1
ICACLS "%VDISK_LTR%:\Windows\System32\setup.bmp" /grant %USERNAME%:F>NUL 2>&1
COPY /Y "%CacheFolder%\%PE_WALLPAPER%" "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1)
IF EXIST "%VDISK_LTR%:\setup.exe" DEL /Q /F "\\?\%VDISK_LTR%:\setup.exe">NUL 2>&1
COPY /Y "%VDISK_LTR%:\Windows\System32\config\ELAM" "%TEMP%\BCD">NUL 2>&1
::ECHO."%%SYSTEMDRIVE%%\$\gploy.CMD">"%VDISK_LTR%:\WINDOWS\SYSTEM32\STARTNET.CMD"
(ECHO.[LaunchApp]&&ECHO.AppPath=X:\$\gploy.cmd)>"%VDISK_LTR%:\Windows\System32\winpeshl.ini"
SET "VHDX_SLOTZ=%VHDX_SLOT0%"&&SET "VHDX_SLOT0=%VHDX_SLOTX%"&&SET "HOST_X=%HOST_FOLDER%"&&CALL:BCD_CREATE>NUL 2>&1
SET "VHDX_SLOT0=%VHDX_SLOTZ%"&&SET "VHDX_SLOTZ="&&IF NOT EXIST "%EFI_LETTER%:\EFI\Microsoft\Boot\BCD" ECHO.%COLOR2%ERROR:%$$% BCD missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
::%DISM% /IMAGE:"%VDISK_LTR%:" /SET-SCRATCHSPACE:512 >NUL 2>&1
ECHO.Saving boot-media...&&%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%VDISK_LTR%:" /IMAGEFILE:"%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.wim" /COMPRESS:FAST /NAME:"WindowsPE" /CheckIntegrity /Verify /Bootable&ECHO.
SET "$IMAGE_X=%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.wim"&&SET "INDEX_X=1"&&CALL:GET_IMAGEINFO
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File boot.sav is corrupt. Abort.&&GOTO:BOOT_CLEANUP
SET "GET_BYTES=MB"&&SET "INPUT=%EFI_LETTER%:"&&SET "OUTPUT=EFI_FREE"&&CALL:GET_FREE_SPACE
IF NOT DEFINED ERROR SET "GET_BYTES=MB"&&SET "INPUT=%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.wim"&&SET "OUTPUT=BOOT_X"&&CALL:GET_FILESIZE
IF NOT DEFINED ERROR SET /A "EFI_FREE+=%BOOT_X%"
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% Unable to get file size or free space. Abort.&&GOTO:BOOT_CLEANUP
CALL:GET_SPACE_ENV&&FOR %%a in (EFI_FREE BOOT_X) DO (IF NOT DEFINED %%a SET "%%a=0")
IF %EFI_FREE% LEQ %BOOT_X% ECHO.%COLOR2%ERROR:%$$% File boot.sav %BOOT_X%MB exceeds %EFI_FREE%MB. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
FOR %%a in (0 ERROR) DO (IF "%FREE%"=="%%a" ECHO.%COLOR2%ERROR:%$$% Not enough free space. Clear some space and try again. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP)
IF NOT DEFINED ERROR MOVE /Y "%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.wim" "%EFI_LETTER%:\$.WIM">NUL
:BOOT_CLEANUP
ECHO.Unmounting temporary vdisk...&&SET "$VDISK_FILE=%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.vhdx"&&CALL:VDISK_DETACH>NUL 2>&1
ECHO.Unmounting EFI...&&IF EXIST "%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.vhdx" DEL /Q /F "%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.vhdx">NUL 2>&1
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&SET "LETT_X=%EFI_LETTER%"&&CALL:PART_REMOVE
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&CALL:PART_EFIX
IF NOT DEFINED ERROR (
IF EXIST "%CacheFolder%\boot.sdi" ECHO.Copying boot.sdi...&&COPY /Y "%CacheFolder%\boot.sdi" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
IF EXIST "%CacheFolder%\bootmgfw.efi" ECHO.Copying bootmgfw.efi...&&COPY /Y "%CacheFolder%\bootmgfw.efi" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
IF DEFINED PE_WALLPAPER IF EXIST "%CacheFolder%\%PE_WALLPAPER%" ECHO.Copying %PE_WALLPAPER%... &&COPY /Y "%CacheFolder%\%PE_WALLPAPER%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (CALL SET "ADDFILE_CHK=%%ADDFILE_%%a%%"&&CALL:ADDFILE_COPY)
IF DEFINED VHDX_SLOTX IF EXIST "%ImageFolder%\%VHDX_SLOTX%" IF EXIST "%PRI_LETTER%:\%HOST_FOLDER%" ECHO.Copying %VHDX_SLOTX%......&&COPY /Y "%ImageFolder%\%VHDX_SLOTX%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1)
CALL SET "VDISK_CHK=%%DISK_%DISK_DETECT%%%"
IF "%VDISK_CHK%"=="VDISK" SET "$LTR=%PRI_LETTER%"&&CALL:DISKMGR_UNMOUNT
:BOOT_FINISH
SET "ADDFILE_CHK="&&SET "VDISK_CHK="&&SET "PATH_TEMP="&&SET "PATH_FILE="&&SET "EFI_LETTER="&&SET "PRI_LETTER="&&SET "TST_LETTER="&&IF "%PROG_MODE%"=="RAMDISK" CALL:HOST_AUTO>NUL 2>&1
CALL:DEL_DISK&&ECHO.&&ECHO.            %@@%BOOT CREATOR END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:ADDFILE_COPY
IF "%ADDFILE_CHK%"=="SELECT" EXIT /B
SET "PATH_TEMP="&&SET "PATH_FILE="&&FOR /F "TOKENS=1-9 DELIMS=\" %%a in ("%ADDFILE_CHK%") DO (
IF "%%a"=="pack" SET "PATH_TEMP=%PackFolder%"&&SET "PATH_FILE=%%b"
IF "%%a"=="list" SET "PATH_TEMP=%ListFolder%"&&SET "PATH_FILE=%%b"
IF "%%a"=="image" SET "PATH_TEMP=%ImageFolder%"&&SET "PATH_FILE=%%b"
IF "%%a"=="cache" SET "PATH_TEMP=%CacheFolder%"&&SET "PATH_FILE=%%b"
IF "%%a"=="main" SET "PATH_TEMP=%ProgFolder%"&&SET "PATH_FILE=%%b")
IF DEFINED PATH_TEMP IF DEFINED PATH_FILE IF EXIST "%PATH_TEMP%\%PATH_FILE%" IF NOT EXIST "%PATH_TEMP%\%PATH_FILE%\*" ECHO.Copying %PATH_FILE%...&&COPY /Y "%PATH_TEMP%\%PATH_FILE%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
EXIT /B
:BCD_MENU
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&IF NOT DEFINED BOOT_TIMEOUT SET "BOOT_TIMEOUT=5"
ECHO.                           %U09% Boot Menu Editor&&ECHO.&&ECHO. Time (%##%T%$$%^) %U14% %@@%%BOOT_TIMEOUT%%$$% seconds
IF NOT DEFINED NEXT_BOOT SET "BOOT_TARGET=GET"&&CALL:BOOT_TOGGLE
IF "%NEXT_BOOT%"=="RECOVERY" ECHO. Slot (%##%*%$$%) %U06% %@@%Recovery%$$%
FOR %%G in (0) DO (IF DEFINED VHDX_SLOT%%G IF NOT "%VHDX_SLOT0%"=="SELECT" CALL ECHO. Slot ^(%##%%%G%$$%^) %U06% %@@%%%VHDX_SLOT%%G%%%$$%)
FOR %%G in (1 2 3 4 5) DO (CALL ECHO. Slot ^(%##%%%G%$$%^) %U06% %@@%%%VHDX_SLOT%%G%%%$$%)
FOR %%G in (6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25) DO (IF DEFINED VHDX_SLOT%%G CALL ECHO. Slot ^(%##%%%G%$$%^) %U06% %@@%%%VHDX_SLOT%%G%%%$$%)
IF "%NEXT_BOOT%"=="VHDX" ECHO. Slot (%##%*%$$%) %@@%Recovery%$$%
ECHO.&&ECHO.                Press (%##%X%$$%) to apply boot menu settings&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
IF "%SELECT%"=="T" CALL:BOOT_TIMEOUT&SET "SELECT="
IF "%SELECT%"=="*" IF "%NEXT_BOOT%"=="RECOVERY" SET "NEXT_BOOT=VHDX"&&SET "SELECT="
IF "%SELECT%"=="*" IF "%NEXT_BOOT%"=="VHDX" SET "NEXT_BOOT=RECOVERY"&&SET "SELECT="
IF "%SELECT%"=="X" IF "%PROG_MODE%"=="RAMDISK" CALL:BCD_REBUILD&SET "$HEADERS=                           %U09% Boot Menu Editor%U01% %U01% %U01% %U01% %U01%            Selected options have been applied to boot menu%U01% %U01% %U01% "&&SET "$SELECT=SELECTX1"&&SET "$CHECK=NONE"&&CALL:PROMPT_BOX&SET "SELECT="
FOR %%G in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25) DO (IF "%SELECT%"=="%%G" SET "$VHDX=%%G"&&CALL:VHDX_CHECK&SET "SELECT=")
GOTO:BCD_MENU
:BOOT_TIMEOUT
SET "$HEADERS=                           %U09% Boot Menu Editor%U01% %U01%                  Enter boot menu timeout in seconds"&&SET "$CHECK=NUMBER❗1-9999"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR IF NOT "%SELECT%"=="0" SET "BOOT_TIMEOUT=%SELECT%"
IF DEFINED ERROR SET "BOOT_TIMEOUT="
EXIT /B
:VHDX_CHECK
IF "%$VHDX%"=="X" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             Boot Creator&&ECHO.&&ECHO.  %@@%AVAILABLE VHDXs:%$$%&&ECHO.&&ECHO. ( %##%0%$$% ) File Operation&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHOICEMINO=1"&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF "%$VHDX%"=="X" IF "%SELECT%"=="0" SET "FILE_TYPE=VHDX"&&CALL:BASIC_FILE&SET "ERROR=NONE"&&CALL:DEBUG&EXIT /B
IF NOT "%$VHDX%"=="X" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                           Boot Menu Editor&&ECHO.&&ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&ECHO. ( %##%0%$$% ) File Operation&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHOICEMINO=1"&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF NOT "%$VHDX%"=="X" IF "%SELECT%"=="0" SET "FILE_TYPE=MAIN"&&CALL:BASIC_FILE&SET "ERROR=NONE"&&CALL:DEBUG&EXIT /B
IF NOT DEFINED $PICK SET "VHDX_SLOT%$VHDX%="&&SET "$VHDX="&&EXIT /B
SET "CHAR_STR=%$CHOICE%"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK
IF DEFINED CHAR_FLG ECHO.&&ECHO.%COLOR4%ERROR:%$$% Remove the space from the VHDX name, then try again.&&ECHO.&&SET "VHDX_SLOT%$VHDX%="&&CALL:PAUSED
IF NOT DEFINED CHAR_FLG SET "VHDX_SLOT%$VHDX%=%$CHOICE%"
SET "$VHDX="
EXIT /B
:BOOT_TOGGLE
CALL:GET_NEXTBOOT
IF NOT DEFINED BOOT_OK EXIT /B
IF NOT "%BOOT_TARGET%"=="VHDX" IF NOT "%BOOT_TARGET%"=="RECOVERY" EXIT /B
IF "%BOOT_TARGET%"=="VHDX" SET "NEXT_BOOT=VHDX"&&%BCDEDIT% /displayorder %GUID_TMP% /addlast>NUL 2>&1
IF "%BOOT_TARGET%"=="RECOVERY" SET "NEXT_BOOT=RECOVERY"&&%BCDEDIT% /displayorder %GUID_TMP% /addfirst>NUL 2>&1
CALL:GET_NEXTBOOT&&SET "BOOT_TARGET="
EXIT /B
:BCD_CREATE
IF NOT DEFINED BOOT_TIMEOUT SET "BOOT_TIMEOUT=5"
SET "BCD_KEY=BCD00000001"&&SET "BCD_FILE=%TEMP%\$BCD"
FOR %%a in (BCD BCD1 $BCD) DO (IF EXIST "%TEMP%\%%a" DEL /Q /F "%TEMP%\%%a" >NUL)
%BCDEDIT% /createstore "%BCD_FILE%"
%BCDEDIT% /STORE "%BCD_FILE%" /create {bootmgr}
%BCDEDIT% /STORE "%BCD_FILE%" /SET {bootmgr} description "Boot Manager"
%BCDEDIT% /STORE "%BCD_FILE%" /SET {bootmgr} device boot
%BCDEDIT% /STORE "%BCD_FILE%" /SET {bootmgr} timeout %BOOT_TIMEOUT%
FOR /f "TOKENS=2 DELIMS={}" %%a in ('%BCDEDIT% /STORE "%BCD_FILE%" /create /device') do SET "RAMDISK={%%a}"
%BCDEDIT% /STORE "%BCD_FILE%" /SET %RAMDISK% ramdisksdidevice boot
%BCDEDIT% /STORE "%BCD_FILE%" /SET %RAMDISK% ramdisksdipath \boot\boot.sdi
FOR /f "TOKENS=2 DELIMS={}" %%a in ('%BCDEDIT% /STORE "%BCD_FILE%" /create /application osloader') do SET "BCD_GUID={%%a}"
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% systemroot \Windows
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% detecthal Yes
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% winpe Yes
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% osdevice ramdisk=[boot]\$.WIM,%RAMDISK%
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% device ramdisk=[boot]\$.WIM,%RAMDISK%
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% path \windows\system32\winload.efi
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% description "Recovery"
%BCDEDIT% /STORE "%BCD_FILE%" /displayorder %BCD_GUID% /addlast
FOR %%a in (25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0) DO (CALL SET "BCD_NAME=%%VHDX_SLOT%%a%%"&&CALL:BCD_VHDX)
%REG% UNLOAD HKLM\%BCD_KEY%>NUL 2>&1
%REG% LOAD HKLM\%BCD_KEY% "%TEMP%\$BCD">NUL 2>&1
%REG% EXPORT HKLM\%BCD_KEY% "%TEMP%\BCD1"
%REG% UNLOAD HKLM\%BCD_KEY%>NUL 2>&1
SET "BCD_FILE=%TEMP%\BCD"&&IF NOT EXIST "%TEMP%\BCD" COPY /Y "%WINDIR%\System32\config\ELAM" "%TEMP%\BCD">NUL 2>&1
%REG% LOAD HKLM\%BCD_KEY% "%BCD_FILE%">NUL 2>&1
%REG% IMPORT "%TEMP%\BCD1" >NUL 2>&1
%REG% add "HKLM\%BCD_KEY%\Description" /v "KeyName" /t REG_SZ /d "%BCD_KEY%" /f>NUL 2>&1
%REG% add "HKLM\%BCD_KEY%\Description" /v "System" /t REG_DWORD /d "1" /f>NUL 2>&1
%REG% add "HKLM\%BCD_KEY%\Description" /v "TreatAsSystem" /t REG_DWORD /d "1" /f>NUL 2>&1
%REG% delete "HKLM\%BCD_KEY%" /v "FirmwareModified" /f>NUL 2>&1
%REG% UNLOAD HKLM\%BCD_KEY%>NUL 2>&1
IF EXIST "%BCD_FILE%" COPY /Y "%BCD_FILE%" "%EFI_LETTER%:\EFI\Microsoft\Boot\BCD">NUL 2>&1
FOR %%a in (BCD BCD1 $BCD) DO (IF EXIST "%TEMP%\%%a" DEL /Q /F "%TEMP%\%%a" >NUL)
SET "BCD_GUID="&&SET "BCD_FILE="&&SET "BCD_KEY="&&SET "BCD_NAME="&&EXIT /B
:BCD_VHDX
IF NOT DEFINED BCD_NAME EXIT /B
IF "%BCD_NAME%"=="SELECT" EXIT /B
FOR /f "TOKENS=3" %%a in ('%BCDEDIT% /STORE "%BCD_FILE%" /create /application osloader') do SET "BCD_GUID=%%a"
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% device vhd=[locate]\%HOST_X%\%BCD_NAME%
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% path \Windows\SYSTEM32\winload.efi
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% osdevice vhd=[locate]\%HOST_X%\%BCD_NAME%
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% systemroot \Windows
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% description "%BCD_NAME%"
%BCDEDIT% /STORE "%BCD_FILE%" /displayorder %BCD_GUID% /addfirst
EXIT /B
:BCD_REBUILD
ECHO.Rebuilding BCD store, saving boot menu...&&CALL:EFI_MOUNT
IF NOT DEFINED ERROR SET "HOST_X=%HOST_FOLDERX%"&&CALL:BCD_CREATE>NUL 2>&1
CALL:EFI_UNMOUNT&SET "BOOT_TARGET=%NEXT_BOOT%"&&CALL:BOOT_TOGGLE
EXIT /B
:QUIT
IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="ENABLED" CALL:HOST_HIDE
COLOR&&TITLE C:\Windows\system32\%CMD%&&CD /D "%ORIG_CD%"
IF "%PROG_MODE%"=="RAMDISK" EXIT 0&&EXIT 0
GOTO:END_OF_FILE
#>▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶GUISTART◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS
Add-Type -MemberDefinition @"
[DllImport("kernel32.dll", SetLastError = true)] public static extern IntPtr GetStdHandle(int nStdHandle);
[StructLayout(LayoutKind.Sequential)] public struct COORD {public short X;public short Y;}
public const int STD_OUTPUT_HANDLE = -11;
[DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr handle);
[DllImport("Kernel32.dll")] public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")] public static extern IntPtr GetSystemMenu(IntPtr hWnd, bool bRevert);
[DllImport("user32.dll")] public static extern int GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);
[DllImport("user32.dll")] public static extern bool GetParent(IntPtr hWndChild);
[DllImport("user32.dll")] public static extern bool SetParent(IntPtr hWndChild, IntPtr hWndNewParent);
[DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
[DllImport("user32.dll")] public static extern bool DestroyWindow(IntPtr hWnd);
[DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
"@ -Name "Functions" -Namespace "WinMekanix" -PassThru | Out-Null
Add-Type -TypeDefinition @"
using System;using System.Runtime.InteropServices;public class WinMekanix {
    private const int STD_OUTPUT_HANDLE = -11;
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)] public struct CONSOLE_FONT_INFO_EX
    {public uint cbSize;public uint nFont;public COORD dwFontSize;public int FontFamily;public int FontWeight;[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]public string FaceName;}
    [StructLayout(LayoutKind.Sequential)] public struct COORD
    {public short X;public short Y;}
    [DllImport("kernel32.dll", SetLastError = true)] public static extern IntPtr GetStdHandle(int nStdHandle);
    [DllImport("kernel32.dll", SetLastError = true)] public static extern bool SetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
    [DllImport("kernel32.dll", SetLastError = true)] public static extern bool GetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
    public static bool SetConsoleFont(string fontName, short fontSize)
    {IntPtr consoleOutputHandle = GetStdHandle(STD_OUTPUT_HANDLE);
        if (consoleOutputHandle == IntPtr.Zero)
        {return false;}
        CONSOLE_FONT_INFO_EX fontInfo = new CONSOLE_FONT_INFO_EX();
        fontInfo.cbSize = (uint)Marshal.SizeOf(fontInfo);GetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);fontInfo.dwFontSize.X = 0;fontInfo.dwFontSize.Y = fontSize;fontInfo.FaceName = fontName;return SetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);} }
"@
$PSScriptRootX = "$($PWD.Path)";$ProjectFolder = "$PSScriptRootX\project";
if (Test-Path -Path "$PSScriptRootX\image") {$ImageFolder = "$PSScriptRootX\image"} else {$ImageFolder = "$PSScriptRootX"}
if (Test-Path -Path "$PSScriptRootX\list") {$ListFolder = "$PSScriptRootX\list"} else {$ListFolder = "$PSScriptRootX"}
if (Test-Path -Path "$PSScriptRootX\pack") {$PackFolder = "$PSScriptRootX\pack"} else {$PackFolder = "$PSScriptRootX"}
if (Test-Path -Path "$PSScriptRootX\cache") {$CacheFolder = "$PSScriptRootX\cache"} else {$CacheFolder = "$PSScriptRootX"}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Group-View {$ListItem = "";
if ($partXb -eq "ⓡRoutine1") {$ListItem = "Routine";$global:Routine1 = ""}
if ($partXb -eq "ⓡArray1") {$ListItem = "Array";$global:Array1 = ""}
if ($ListItem -eq "Array") {$ifX = ""
if ($partXc) {if ($partXc -ne "◁Null▷") {$stringX1 = $partXc.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$partXc = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($partXc)) {$partXc = "◁Null▷"}}
}
if ($partXd) {$if1, $if2, $if3, $if4, $if5, $if6, $if7, $if8, $if9, $if10 = $partXd -split "[❗]"
if ($if1) {if ($if1 -ne "◁Null▷") {$stringX1 = $if1.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if1 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if1)) {$if1 = "◁Null▷"}}}
if ($if2) {if ($if2 -ne "◁Null▷") {$stringX1 = $if2.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if2 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if2)) {$if2 = "◁Null▷"}}}
if ($if3) {if ($if3 -ne "◁Null▷") {$stringX1 = $if3.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if3)) {$if3 = "◁Null▷"}}}
if ($if4) {if ($if4 -ne "◁Null▷") {$stringX1 = $if4.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if4 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if4)) {$if4 = "◁Null▷"}}}
if ($if5) {if ($if5 -ne "◁Null▷") {$stringX1 = $if5.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if5 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if5)) {$if5 = "◁Null▷"}}}
if ($if6) {if ($if6 -ne "◁Null▷") {$stringX1 = $if6.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if6 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if6)) {$if6 = "◁Null▷"}}}
if ($if7) {if ($if7 -ne "◁Null▷") {$stringX1 = $if7.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if7 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if7)) {$if7 = "◁Null▷"}}}
if ($if8) {if ($if8 -ne "◁Null▷") {$stringX1 = $if8.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if8 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if8)) {$if8 = "◁Null▷"}}}
if ($if9) {if ($if9 -ne "◁Null▷") {$stringX1 = $if9.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if9 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if9)) {$if9 = "◁Null▷"}}}
}
if ($partXe) {$do1, $do2, $do3, $do4, $do5, $do6, $do7, $do8, $do9, $do10 = $partXe -split "[❗]"
if ($do1) {if ($do1 -ne "◁Null▷") {$stringX1 = $do1.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do1 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if1") {$ArrayX = $do1;$ifX = 1}}}
if ($do2) {if ($do2 -ne "◁Null▷") {$stringX1 = $do2.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do2 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if2") {$ArrayX = $do2;$ifX = 2}}}
if ($do3) {if ($do3 -ne "◁Null▷") {$stringX1 = $do3.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if3") {$ArrayX = $do3;$ifX = 3}}}
if ($do4) {if ($do4 -ne "◁Null▷") {$stringX1 = $do4.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do4 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if4") {$ArrayX = $do4;$ifX = 4}}}
if ($do5) {if ($do5 -ne "◁Null▷") {$stringX1 = $do5.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do5 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if5") {$ArrayX = $do5;$ifX = 5}}}
if ($do6) {if ($do6 -ne "◁Null▷") {$stringX1 = $do6.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do6 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if6") {$ArrayX = $do6;$ifX = 6}}}
if ($do7) {if ($do7 -ne "◁Null▷") {$stringX1 = $do7.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do7 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if7") {$ArrayX = $do7;$ifX = 7}}}
if ($do8) {if ($do8 -ne "◁Null▷") {$stringX1 = $do8.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do8 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if8") {$ArrayX = $do8;$ifX = 8}}}
if ($do9) {if ($do9 -ne "◁Null▷") {$stringX1 = $do9.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do9 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if9") {$ArrayX = $do9;$ifX = 9}}}
}
if ($ifX) {
$global:Array1 = [PSCustomObject]@{
I = "$ifX"
S = "$ArrayX"
$ifX = "$ArrayX"}
}}
if ($ListItem -eq "Routine") {$RoutineX = ""
if ($partXd -eq "Command") {
if ($partXc) {$delims, $command, $columntar, $columnstr = $partXc -split "[❗]"}
$stringX1 = $command.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$command = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$scriptblockX = { cmd.exe /c "@ECHO OFF&FOR /F `"TOKENS=1-9 DELIMS=$delims`" %1 in ('$command 2^>NUL') do (echo %1%2%3%4%5%6%7%8%9)" }
$scriptblockZ = [scriptblock]::create($scriptblockX)
$commandX = Invoke-command $scriptblockZ
#if (-not ($waitX)) {$global:waitX = 1;Start-Sleep -Milliseconds 250}
Foreach ($line in $commandX) {
$Part1g, $Part2g, $Part3g, $Part4g, $Part5g, $Part6g, $Part7g, $Part8g, $Part9g = $line -split "[]"
if ($columntar -eq 1) {if ($Part1g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 2) {if ($Part2g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 3) {if ($Part3g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 4) {if ($Part4g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 5) {if ($Part5g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 6) {if ($Part6g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 7) {if ($Part7g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 8) {if ($Part8g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 9) {if ($Part9g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($RoutineX) {
$stringX1 = $RoutineX.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$RoutineX = $ExecutionContext.InvokeCommand.ExpandString($stringX2)}
$global:Routine1 = [PSCustomObject]@{
I = "1"
S = "$RoutineX"
1 = "$RoutineX"
}}}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MOUNT_INT {
$global:HiveUser = "HKEY_CURRENT_USER"
$global:HiveSoftware = "HKEY_LOCAL_MACHINE\SOFTWARE"
$global:HiveSystem = "HKEY_LOCAL_MACHINE\SYSTEM"
$global:DrvTar = "$env:SystemDrive"
$global:WinTar = "$env:SystemDrive\Windows"
$global:UsrTar = "$env:USERPROFILE";#$global:UsrTar = "$HOME"
$global:ApplyTarget = "ONLINE"
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function VDISK_DETACH {
$scriptblockX = { cmd.exe /c "@ECHO OFF&FOR /F `"TOKENS=1-9 DELIMS=$delims`" %1 in ('cmd.exe /c "$PSScriptRootX\gploy.cmd" -DISKMGR -UNMOUNT -LETTER "$vdiskltr" -HIVE') do (echo %1%2%3%4%5%6%7%8%9)" }
$scriptblockZ = [scriptblock]::create($scriptblockX)
$commandX = Invoke-command $scriptblockZ
Foreach ($line in $commandX) {$Part1mnt, $Part2mnt = $line -split "[]"}
$global:vdiskltr = ""
MOUNT_INT
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MOUNT_EXT {
$global:HiveUser = "HKEY_USERS\AllUsersX"
$global:HiveSoftware = "HKEY_LOCAL_MACHINE\SoftwareX"
$global:HiveSystem = "HKEY_LOCAL_MACHINE\SystemX"
$global:DrvTar = "$vdiskltr`:"
$global:WinTar = "$vdiskltr`:\Windows"
$global:UsrTar = "$vdiskltr`:\Users\Default"
$global:ApplyTarget = "IMAGE:$vdiskltr`:"
}
function VDISK_ATTACH {
$scriptblockX = { cmd.exe /c "@ECHO OFF&FOR /F `"TOKENS=1-9 DELIMS=$delims`" %1 in ('cmd.exe /c "$PSScriptRootX\gploy.cmd" -DISKMGR -MOUNT -VHDX "$REFERENCE" -LETTER ANY -HIVE') do (echo %1%2%3%4%5%6%7%8%9)" }
$scriptblockZ = [scriptblock]::create($scriptblockX)
$commandX = Invoke-command $scriptblockZ
Foreach ($line in $commandX) {$nullX, $global:vdiskltr, $nullY = $line -split "[]"}
MOUNT_EXT
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewPanel {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$C)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object Drawing.Point($XLOC, $YLOC)
$panel.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$panel.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
if ($C) {$panel.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_PAG_COLOR")}
$form.Controls.Add($panel)
return $panel
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewPictureBox {
param([int]$X,[int]$Y,[int]$H,[int]$W)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$pictureBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$pictureDecrypt = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($pictureBase64))
$pictureBox.Image = $pictureDecrypt
$pictureBox.SizeMode = 'StretchImage';#Normal, StretchImage, AutoSize, CenterImage, Zoom
$pictureBox.Visible = $true
$element = $pictureBox;AddElement
return $pictureBox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewTextBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$Check)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$textbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$textbox.Text = "$Text"
$textbox.Visible = $true
$textbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$textbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
if ($Check -eq 'NUMBER') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^0-9]")) {$this.Text = "$textXlastNum"} else {$global:textXlastNum = "$textX"}})}
if ($Check -eq 'LETTER') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z]")) {$this.Text = "$textXlastLtr"} else {$global:textXlastLtr = "$textX"}})}
if ($Check -eq 'ALPHA') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z0-9._-]")) {$this.Text = "$textXlastAlp"} else {$global:textXlastAlp = "$textX"}})}
if ($Check -eq 'PATH') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z0-9._\\: -]")) {$this.Text = "$textXlastPath"} else {$global:textXlastPath = "$textX"}})}
if ($Check -eq 'MENU') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z0-9._@#$+=~*-]")) {$this.Text = "$textXlastMenu"} else {$global:textXlastMenu = "$textX"}})}
if ($Check -eq 'MOST') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z0-9._@#$+=~\\:`/(){}%* -]")) {$this.Text = "$textXlastMost"} else {$global:textXlastMost = "$textX"}})}
$element = $textbox;AddElement
#$textbox.Bounds = New-Object System.Drawing.Rectangle($XLOC, $YLOC, $WSIZ, $HSIZ)
#$textX = $textX.Remove($textX.Length -1, 1)
#$textX.Substring(0, $textX.Length -1)
#$textbox.SelectionColor = 'White'
#$textbox.ReadOnly = $true
#$textBox.Multiline = $true
#$textBox.ScrollBars = "Vertical"
#$textBox.Dock = "Fill"
#$textBox.ReadOnly = $true
#$textBox.AppendText = "Option X"
return $textbox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewRichTextBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$richTextBox = New-Object System.Windows.Forms.RichTextBox
$richTextBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$richTextBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$richTextBox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$richTextBox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$richTextBox.Visible = $true
$element = $richTextBox;AddElement
#$richTextBox.Dock = DockStyle.Fill
#$richTextBox.LoadFile("C:\\xyz.rtf")
#$richTextBox.Find("Text")
#$richTextBox.SelectionColor = Color.Red
#$richTextBox.SaveFile("C:\\xyz.rtf")
return $richTextBox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewListView {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Headers,[string]$Text)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$listview = New-Object System.Windows.Forms.ListView
$listview.Location = New-Object Drawing.Point($XLOC, $YLOC)
$listview.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$listview.View = [System.Windows.Forms.View]::Details
$listview.View = "Details";#$listview.View = "List"
$listview.MultiSelect = $false
$listview.HideSelection = $true
if ($GUI_LVFONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_LVFONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_LVFONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$listview.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
if ($Headers) {$listview.HeaderStyle = "$Headers"} else {$listview.HeaderStyle = 'None'}
$listview.Visible = $true
$listview.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$listview.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$doublebuffer = $listview.GetType().GetProperty("DoubleBuffered", [System.Reflection.BindingFlags] "NonPublic, Instance");$doublebuffer.SetValue($listview, $true, $null)
$element = $listview;AddElement
#$listview.Columns[0].Width = -2
#$listview.Columns[1].Width = -2
#$listview.CheckBoxes = true
#$listview.FullRowSelect = true
#$listview.GridLines = true
#$listview.Sorting = SortOrder.Ascending
#$listview.HeaderStyle = 'Clickable';#NonClickable;#None
#$imageListSmall = New-Object System.Windows.Forms.ImageList
#$listview.SmallImageList = $imageListSmall
#$ListViewSelect = $listView.SelectedItems
#$ListViewFocused = $listView.FocusedItem
return $listview
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewLabel {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Bold,[string]$LabelFont,[string]$TextSize,[string]$TextAlign,[string]$Text)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$label = New-Object Windows.Forms.Label
$label.Location = New-Object Drawing.Point($XLOC, $YLOC)
$label.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$label.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$fontX = [int]($GUI_SCALE / $DpiCur * $TextSize * $ScaleRef);$fontX = [Math]::Floor($fontX);
if ($Bold -eq 'True') {$FontStyle = 'Bold';$LabelFont = 'Consolas'} else {$FontStyle = 'Regular'}
if ($TextSize) {$label.Font = New-Object System.Drawing.Font("$LabelFont", $fontX,[System.Drawing.FontStyle]::$FontStyle)}
$label.AutoSize = $true
if ($TextAlign) {$label.AutoSize = $false
$label.Dock = "None";#None, Top, Bottom, Left, Right, Fill
#$label.TextAlign = "CenterScreen";#MiddleCenter, TopLeft, CenterScreen, Center, Fill"
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter}
$label.Text = "$Text"
$element = $label;AddElement
return $label
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MessageBox {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxChoices,[string]$MessageBoxText,[string]$Check,[string]$TextMin,[string]$TextMax)
if ($MessageBoxType -eq 'Choice') {if ($MessageBoxChoices) {$parta, $partb, $partc, $partd, $parte, $partf, $partg, $parth, $parti, $partj, $partk, $partl, $partm, $partn, $parto = $MessageBoxChoices -split '[❗]'}}

#if ($MessageBoxType -eq 'Picker') {if ($MessageBoxChoices) {$parta1X, $partb1X, $partc1X = $MessageBoxChoices -split '[*]';$parta1 = $parta1X -replace "`"|'", "";$partb1 = $partb1X -replace "`"|'", ""}};#`"
$formbox = New-Object System.Windows.Forms.Form
$formbox.SuspendLayout()
$WSIZ = [int](500 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](250 * $ScaleRef * $GUI_SCALE)
$formbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$formbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formbox.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
$formbox.StartPosition = "CenterScreen"
$formbox.FormBorderStyle = 'FixedDialog'
$formbox.AutoSizeMode = 'GrowAndShrink'
$formbox.WindowState = 'Normal'
$formbox.MaximizeBox = $false
$formbox.MinimizeBox = $true
$formbox.ControlBox = $False
$formbox.AutoScale = $true
$formbox.AutoSize = $true
#$formbox.MdiParent = $form
if ($MessageBoxTitle) {$formbox.Text = "$MessageBoxTitle"}
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formbox.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$WSIZ = [int](475 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](140 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$labelbox = New-Object System.Windows.Forms.Label
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$labelbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$labelbox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelbox.Dock = "None";#None, Top, Bottom, Left, Right, Fill
$labelbox.Text = "$MessageBoxText"
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.DialogResult = "OK"
$okButton.Enabled = $true
$okButton.Cursor = 'Hand'
$okButton.Text = "OK"
if ($MessageBoxType -eq 'YesNo') {
$XLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Text = "Yes"
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$cancelButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$cancelButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$cancelButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$cancelButton.Add_MouseEnter({$cancelButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$cancelButton.Add_MouseLeave({$cancelButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$cancelButton.DialogResult = "CANCEL"
$cancelButton.Cursor = 'Hand'
$cancelButton.Text = "No"
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($cancelButton)
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Info') {
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Prompt') {
$WSIZ = [int](430 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](40 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](135 * $ScaleRef * $GUI_SCALE)
$inputbox = New-Object System.Windows.Forms.TextBox
$inputbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$inputbox.Size = New-Object System.Drawing.Size($WSIZ,$HSIZ)
$inputbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$inputbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$global:textX = "";$global:textXlast = "$textX"
$inputbox.Add_TextChanged({$global:textX = "$($this.Text)";$revert = $false;$okEnable = $true
ForEach ($i in @("NUMBER","LETTER","ALPHA","PATH","MENU","MOST")) {if ($Check -eq "$i") {#"[](){}<>!@#$%^&*|;:,.?_~=+-/``\\[]"
if ($Check -eq 'NUMBER') {$allowed = "0-9"}
if ($Check -eq 'LETTER') {$allowed = "a-zA-Z"}
if ($Check -eq 'ALPHA') {$allowed = "a-zA-Z0-9._-"}
if ($Check -eq 'PATH') {$allowed = "a-zA-Z0-9._\\: -"}
if ($Check -eq 'MENU') {$allowed = "a-zA-Z0-9._@#$+=~*-"}
if ($Check -eq 'MOST') {$allowed = "a-zA-Z0-9._@#$+=~\\:`/(){}%* -"}
if ($Check -eq 'NUMBER') {$inputboxX = [int]($($inputbox.Text));$this.Text = $inputboxX
if ($TextMin) {if ($inputboxX -lt $TextMin) {$okEnable = $false}
if ($TextMax) {if ($inputboxX -gt $TextMax) {$revert = $true}}}}
if ($Check -ne 'NUMBER') {
if ($TextMin) {if ($inputbox.Text.Length -lt $TextMin) {$okEnable = $false}
if ($TextMax) {if ($inputbox.Text.Length -gt $TextMax) {$revert = $true}}}}
if (-not ($this.Text -notmatch "[^$allowed]")) {$revert = $true}}}
if (-not ($inputbox.Text.Length -gt 0)) {$okEnable = $false}
if ($okEnable -eq $true) {$okButton.Enabled = $true} else {$okButton.Enabled = $false}
if ($revert -eq $true) {$this.Text = "$textXlast"} else {$global:textXlast = "$textX"}
})
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Add_Click({$null})
$okButton.Enabled = $false
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($inputbox)
$formbox.Controls.Add($okButton)
$formbox.Controls.Add($cancelButton)}
if ($MessageBoxType -eq 'Choice') {
$WSIZ = [int](430 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](40 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](135 * $ScaleRef * $GUI_SCALE)
$dropbox = New-Object System.Windows.Forms.ComboBox
$dropbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$dropbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$dropbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$dropbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
ForEach ($i in @("$parta","$partb","$partc","$partd","$parte","$partf","$partg","$parth","$parti","$partj","$partk","$partl","$partm","$partn","$parto","$partp","$partq","$partr","$parts","$partt","$partu","$partv","$partw","$partx","$party","$partz")) {if ($i) {$dropbox.Items.Add($i)}}
$dropbox.Add_SelectedIndexChanged({$null})
$dropbox.DisplayMember = "$DisplayMember"
$dropbox.DropDownStyle = 'DropDownList'
$dropbox.FlatStyle = 'Flat'
$dropbox.Text = "$Text"
$dropbox.SelectedIndex = 0
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($dropbox)
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Picker') {$PartMatch = $null
$WSIZ = [int](430 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](40 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](135 * $ScaleRef * $GUI_SCALE)
$dropbox = New-Object System.Windows.Forms.ComboBox
$dropbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$dropbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$dropbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$dropbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$stringX1 = $MessageBoxChoices.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$MessageBoxChoices = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$partPath, $partExt = $MessageBoxChoices -split '[❗]'
if (Test-Path -Path "$partPath\$partExt") {$FilePath = "$partPath\$partExt"} else {$FilePath = "$PSScriptRootX\*.*"}
Get-ChildItem -Path "$FilePath" -Name | ForEach-Object {[void]$dropbox.Items.Add($_)}
$dropbox.Add_SelectedIndexChanged({$null})
$dropbox.DisplayMember = "$DisplayMember"
$dropbox.DropDownStyle = 'DropDownList'
$dropbox.FlatStyle = 'Flat'
$dropbox.Text = "$Text"
$dropbox.SelectedIndex = 0
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($dropbox)
$formbox.Controls.Add($okButton)}
$formbox.Controls.Add($labelbox)
$formbox.ResumeLayout();$global:boxresult = $formbox.ShowDialog()
$global:boxoutput = $null;$global:boxindex = $null;
if ($MessageBoxType -eq 'Prompt') {if ($inputbox.Text) {$global:boxoutput = $inputbox.Text} else {$global:boxresult = $null}}
if ($MessageBoxType -eq 'Choice') {if ($dropbox.SelectedItem) {$global:boxoutput = $dropbox.SelectedItem;$boxindexX = $dropbox.SelectedIndex;$global:boxindex = $boxindexX + 1} else {$global:boxresult = $null}}
if ($MessageBoxType -eq 'Picker') {if ($dropbox.SelectedItem) {$global:boxoutput = $dropbox.SelectedItem;$boxindexX = $dropbox.SelectedIndex;$global:boxindex = $boxindexX + 1} else {$global:boxresult = $null}}
$formbox.Dispose()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MessageBoxAbout {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxText)
$formbox = New-Object System.Windows.Forms.Form
$formbox.SuspendLayout()
$WSIZ = [int](600 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](450 * $ScaleRef * $GUI_SCALE)
$formbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($MessageBoxTitle) {$formbox.Text = "$MessageBoxTitle"}
$formbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formbox.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formbox.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$formbox.StartPosition = "CenterScreen"
$formbox.FormBorderStyle = 'FixedDialog'
$formbox.AutoSizeMode = 'GrowAndShrink'
$formbox.FormBorderStyle = 'FixedDialog';#FixedDialog, FixedSingle, Fixed3D
$formbox.MaximizeBox = $false
$formbox.MinimizeBox = $true
$formbox.ControlBox = $False
$formbox.AutoScale = $true
$formbox.WindowState = 'Normal'
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](225 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](375 * $ScaleRef * $GUI_SCALE)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.DialogResult = "OK"
$okButton.Cursor = 'Hand'
$okButton.Text = "OK"
$WSIZ = [int](600 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](110 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0)
$YLOC = [int](290 * $ScaleRef * $GUI_SCALE)
$labelbox = New-Object System.Windows.Forms.Label
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$labelbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$labelbox.Dock = "None";#None, Top, Bottom, Left, Right, Fill
$labelbox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelbox.Text = "For documentation visit github.com/joshuacline"
$Page = 'x';$pictureBase64 = $logojpgB64;$PictureBox1_PageSP = NewPictureBox -X '125' -Y '15' -W '350' -H '310';$formbox.Controls.Add($PictureBox1_PageSP);
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($okButton)
$formbox.Controls.Add($labelbox)
$formbox.ResumeLayout()
$formbox.ShowDialog()
$formbox.Dispose()
}
function MessageBoxListView {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxText)
$formboxX = New-Object System.Windows.Forms.Form
$formboxX.SuspendLayout()
$WSIZ = [int](700 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](450 * $ScaleRef * $GUI_SCALE)
$formboxX.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($MessageBoxTitle) {$formboxX.Text = "$MessageBoxTitle"}
$formboxX.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formboxX.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formboxX.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formboxX.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$formboxX.StartPosition = "CenterScreen"
$formboxX.FormBorderStyle = 'FixedDialog'
$formboxX.AutoSizeMode = 'GrowAndShrink'
$formboxX.FormBorderStyle = 'FixedDialog';#FixedDialog, FixedSingle, Fixed3D
$formboxX.MaximizeBox = $false
$formboxX.MinimizeBox = $true
$formboxX.ControlBox = $False
$formboxX.AutoScale = $true
$formboxX.WindowState = 'Normal'
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](285 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](375 * $ScaleRef * $GUI_SCALE)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.Add_Click({
$global:checkedItemsX = $ListViewBox.CheckedItems | ForEach-Object {$ListWriteX = 0
$partaa, $ListViewCheckedX, $partcc = $_ -split '[{}]'
Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partYa, $partYb, $partYc, $partYd, $partYe, $partYf, $partYg, $partYh, $partYi, $partYj, $partYk, $partYl, $partYm, $partYn = $_ -split "[❕]"
if ($partYc -eq $ListViewCheckedX) {Add-Content -Path "$ListFolder\`$LIST" -Value "$_" -Encoding UTF8;}}}})
$okButton.DialogResult = "OK"
$okButton.Cursor = 'Hand'
$okButton.Text = "OK"
$WSIZ = [int](645 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](325 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$ListViewBox = New-Object System.Windows.Forms.ListView
$ListViewBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$ListViewBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$listview.View = [System.Windows.Forms.View]::Details
$ListViewBox.View = "Details";#$listview.View = "List"
$ListViewBox.MultiSelect = $false
$ListViewBox.HideSelection = $true
if ($GUI_LVFONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_LVFONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_LVFONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$ListViewBox.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
if ($Headers) {$ListViewBox.HeaderStyle = "$Headers"} else {$ListViewBox.HeaderStyle = 'None'}
$ListViewBox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$ListViewBox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$ListViewBox.Visible = $true
$doublebufferX = $ListViewBox.GetType().GetProperty("DoubleBuffered", [System.Reflection.BindingFlags] "NonPublic, Instance");$doublebufferX.SetValue($ListViewBox, $true, $null)
$WSIZ = [int](542 * $ScaleRef * $GUI_SCALE);[void]$ListViewBox.Columns.Add("X", $WSIZ);$formboxX.Controls.Add($ListViewBox)
$ListViewBox.GridLines = $false;$ListViewBox.CheckBoxes = $true;$ListViewBox.FullRowSelect = $true
$wtfbbq = Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partZa, $partZb, $partZc, $partZd, $partZe, $partZf, $partZg, $partZh, $partZi, $partZj, $partZk, $partZl, $partZm, $partZn = $_ -split "[❕]"
if ($partZb -eq 'GROUP') {if ($partZc -ne $ListViewChoiceS3) {$gogogo = 0}}
if ($partZb -eq 'GROUP') {if ($partZd -ne $ListViewChecked) {$gogogo = 0}}
if ($partZb -eq 'GROUP') {if ($partZc -eq $ListViewChoiceS3) {if ($partZd -eq $ListViewChecked) {$gogogo = 1}}}
if ($gogogo -eq 1) {
if ($partZb -ne 'GROUP') {if ($_ -ne "") {[void]$ListViewBox.Items.Add("$partZc")}}}}
$formboxX.AcceptButton = $okButton
$formboxX.Controls.Add($okButton)
#$formboxX.Controls.Add($labelbox)
$formboxX.ResumeLayout()
$formboxX.ShowDialog()
$formboxX.Dispose()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function GetTextInfo {
param ([Parameter(Mandatory=$true)]
[string]$TextFile)
$stream = [System.IO.File]::OpenRead($TextFile)
$bytes = New-Object byte[] 3
$readBytes = $stream.Read($bytes, 0, 3)
if ($readBytes -eq 3) {return ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)}
$stream.Close();$stream.Dispose()
return $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickFolder {
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowserDialog.RootFolder = 'Desktop'
#$FolderBrowserDialog.InitialDirectory = "$Pick"
$FolderBrowserDialog.ShowNewFolderButton = $true
$FolderBrowserDialog.Description = 'Description'
$FolderBrowserDialog.ShowDialog() | Out-Null
$Pick = $FolderBrowserDialog.FileName
Write-Host "Selected file: $Pick"
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickFolderx {
$shell = New-Object -ComObject Shell.Application
$FolderPicker = $shell.BrowseForFolder(0, "Select a folder:", 0, $null)
$Pick = $FolderPicker.Self.Path
Write-Host "Selected folder: $Pick"}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickFile {
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.InitialDirectory = "$FilePath"
$OpenFileDialog.RestoreDirectory = $true
$OpenFileDialog.Filter = $FileFilt
$OpenFileDialog.ShowDialog() | Out-Null
$global:Pick = $OpenFileDialog.FileName
Write-Host "Selected file: $Pick"
#$OpenFileDialog.Filter = "WIM files (*.wim)|*.wim"
#$OpenFileDialog.Filter = "Text files (*.txt;*.zip)|*.txt;*.zip"
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewRadioButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$GroupName)
$radio = New-Object System.Windows.Forms.RadioButton
$radio.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$radio.Text = "$Text"
$radio.Add_CheckedChanged($Add_CheckedChanged)
$radio.AutoSize = $false
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$radio.Location = New-Object Drawing.Point($XLOC, $YLOC)
$radio.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($GroupBoxName -eq 'Group1') {$GroupBox1_PageSC.Controls.Add($radio)}
if ($GroupBoxName -eq 'Group2') {$GroupBox2_PageSC.Controls.Add($radio)}
#$radio.Checked = "$false"
return $radio
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewGroupBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$Checked)
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$groupBox.Text = "$Text"
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$groupBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$groupBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$element = $groupBox;AddElement
#$groupBox.Checked = "$false"
return $groupBox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewSlider {
param([int]$X,[int]$Y,[int]$H,[int]$W,[int]$Value)
$slider = New-Object System.Windows.Forms.TrackBar
$slider.Minimum = 50
$slider.Maximum = 150
$slider.TickFrequency = 10
$slider.LargeChange = 10
$slider.SmallChange = 5
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$slider.Width = $WSIZ
$slider.Location = New-Object Drawing.Point($XLOC, $YLOC)
$slider.Value = "$Value"
$slider.Add_MouseWheel({
#$slider.FocusedItem()
$ScrollAmt = $_.Delta / 120;
$SliderValuePlus = $($Slider1_PageSC.Value) + 7
$SliderValueMinus = $($Slider1_PageSC.Value) - 7
if ($ScrollAmt -gt 0) {$Slider1_PageSC.Value = $SliderValuePlus}
if ($ScrollAmt -lt 0) {$Slider1_PageSC.Value = $SliderValueMinus}
if ($Slider1_PageSC.Value -lt $Slider1_PageSC.Minimum) {$Slider1_PageSC.Value = $Slider1_PageSC.Minimum}
if ($Slider1_PageSC.Value -gt $Slider1_PageSC.Maximum) {$Slider1_PageSC.Value = $Slider1_PageSC.Maximum}})
$slider.Add_Scroll({
$ScaleJ = $($Slider1_PageSC.Value) / 100
$LabelX_PageSC.Text = "GUI Scale Factor $($Slider1_PageSC.Value)%"
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
ForEach ($i in @("","GUI_SCALE=$ScaleJ")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
if ($boxresult -eq "OK") {Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\gploy.cmd";$NoExitPrompt = 1;$form.Close()}
})
#$slider.Add_MouseUp({$null})
#$slider.Add_MouseDown({$null})
#$slider.Add_ValueChanged({$null})
$element = $slider;AddElement
return $slider
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewToggle {
param ([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$toggle = New-Object System.Windows.Forms.CheckBox
$toggle.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$toggle.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$toggle.Text = "$Text"
$toggle.Add_CheckedChanged($Add_CheckedChanged)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$toggle.Location = New-Object Drawing.Point($XLOC, $YLOC)
$toggle.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$element = $toggle;AddElement
return $toggle
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewDropBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[int]$C,[string]$Text,[string]$DisplayMember)
$dropbox = New-Object System.Windows.Forms.ComboBox
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
#$dropbox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::Simple
$dropbox.DropDownStyle = 'DropDownList'#ReadOnly
$dropbox.FlatStyle = 'Flat'# Flat, Popup, System
$dropbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$dropbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$dropbox.DisplayMember = $DisplayMember
$dropbox.Text = "$Text"
$dropbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$dropbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$dropbox.Add_SelectedIndexChanged({
$DropBox1_PageW2V.Tag = 'Disable'
$DropBox2_PageW2V.Tag = 'Disable'
$DropBox1_PageV2W.Tag = 'Disable'
$DropBox2_PageV2W.Tag = 'Disable'
$DropBox3_PageV2W.Tag = 'Disable'
$DropBox1_PageLB.Tag = 'Disable'
$DropBox1_PageBC.Tag = 'Disable'
$DropBox2_PageBC.Tag = 'Disable'
$DropBox3_PageBC.Tag = 'Disable'
$DropBox1_PageSC.Tag = 'Disable'
$DropBox2_PageSC.Tag = 'Disable'
$DropBox3_PageSC.Tag = 'Disable'
$DropBox4_PageSC.Tag = 'Disable'
$DropBox5_PageSC.Tag = 'Disable'
$this.Tag = 'Enable'
if ($DropBox1_PageW2V.Tag -eq 'Enable') {if ($DropBox1_PageW2V.SelectedItem -eq 'Import Installation Media') {ImportWim}
if ($DropBox1_PageW2V.SelectedItem) {if ($DropBox1_PageW2V.SelectedItem -ne 'Import Installation Media') {DropBox1W2V}}}
if ($DropBox2_PageBC.Tag -eq 'Enable') {if ($DropBox2_PageBC.SelectedItem -eq 'Import Wallpaper') {ImportWallpaper}}
if ($DropBox3_PageBC.Tag -eq 'Enable') {if ($DropBox3_PageBC.SelectedItem -eq 'Refresh') {DropBox3BC}}
if ($DropBox1_PageV2W.Tag -eq 'Enable') {DropBox1V2W}
if ($DropBox1_PageSC.Tag -eq 'Enable') {DropBox1SC}
if ($DropBox2_PageSC.Tag -eq 'Enable') {DropBox2SC}
if ($DropBox3_PageSC.Tag -eq 'Enable') {DropBox3SC}
if ($DropBox4_PageSC.Tag -eq 'Enable') {DropBox4SC}
if ($DropBox5_PageSC.Tag -eq 'Enable') {DropBox5SC}
if ($DropBox1_PageLB.Tag -eq 'Enable') {DropBox1LB}
})
$element = $dropbox;AddElement
#$dropbox.IsEditable = $false
#$dropbox.IsReadOnly = $true
#$dropbox.Add_TextChanged({Write-Host "X"})
return $dropbox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$Hover_Text,[scriptblock]$Add_Click)
$button = New-Object Windows.Forms.Button
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$button.Location = New-Object Drawing.Point($XLOC, $YLOC)
$button.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$button.Add_Click($Add_Click)
$button.Text = $Text
$button.Cursor = 'Hand'
$button.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$button.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$button.Add_MouseEnter({$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$button.Add_MouseLeave({$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$hovertext = New-Object System.Windows.Forms.ToolTip
$hovertext.SetToolTip($button, $Hover_Text)
#$button.FlatStyle = 'Flat'
#$button.FlatAppearance.BorderSize = '3'
#$paint = $button;$global:shape = 'Rectangle';Add_Paint
#$colorHex1 = [Convert]::ToInt32($GUI_BTN_COLOR.Substring(0, 2), 16);#$colorHex2 = [Convert]::ToInt32($GUI_BTN_COLOR.Substring(2, 2), 16)
$element = $button;AddElement
return $button
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$global:Mswitch = 1;$global:Pswitch = 1
function NewPageButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$button = New-Object Windows.Forms.Button
$button.Location = New-Object Drawing.Point($XLOC, $YLOC)
$button.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$button.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$button.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
#$button.FlatAppearance.BorderSize = '3'
#$button.FlatStyle = 'Flat'
$button.Text = $Text
$button.Cursor = 'Hand'
$button.Add_Click({
$Button_V2W.Tag = 'Disable'
$Button_W2V.Tag = 'Disable'
$Button_LB.Tag = 'Disable'
$Button_PB.Tag = 'Disable'
$Button_BC.Tag = 'Disable'
$Button_SC.Tag = 'Disable'
$Button_SP.Tag = 'Disable'
$this.Tag = 'Enable'
if (-not ($Button_W2V.Tag -eq 'Enable')) {if (-not ($Button_V2W.Tag -eq 'Enable')) {$global:Pswitch = 1}}
if (-not ($Button_LB.Tag -eq 'Enable')) {if (-not ($Button_PB.Tag -eq 'Enable')) {$global:Mswitch = 1}}
if ($Button_W2V.Tag -eq 'Enable') {if ($Pswitch -eq 1) {$Button_W2V.Tag = 'Disable';$Button_V2W.Tag = 'Enable';$global:Pswitch = ""}}
if ($Button_V2W.Tag -eq 'Enable') {if ($Pswitch -eq 1) {$Button_W2V.Tag = 'Enable';$Button_V2W.Tag = 'Disable';$global:Pswitch = ""}}
if ($Button_LB.Tag -eq 'Enable') {if ($Mswitch -eq 1) {$Button_LB.Tag = 'Disable';$Button_PB.Tag = 'Enable';$global:Mswitch = ""}}
if ($Button_PB.Tag -eq 'Enable') {if ($Mswitch -eq 1) {$Button_LB.Tag = 'Enable';$Button_PB.Tag = 'Disable';$global:Mswitch = ""}}
if ($Button_W2V.Tag -eq 'Enable') {Button_PageW2V}
if ($Button_V2W.Tag -eq 'Enable') {Button_PageV2W}
if ($Button_LB.Tag -eq 'Enable') {Button_PageLB}
if ($Button_PB.Tag -eq 'Enable') {Button_PagePB}
if ($Button_BC.Tag -eq 'Enable') {Button_PageBC}
if ($Button_SC.Tag -eq 'Enable') {Button_PageSC}
if ($Button_SP.Tag -eq 'Enable') {Button_PageSP;if ($SplashX -eq 5) {$global:SplashChange = 1};$global:SplashX += 1}
if ($Button_W2V.Tag -ne 'Enable') {$PageW2V.Visible = $false}
if ($Button_V2W.Tag -ne 'Enable') {$PageV2W.Visible = $false}
if ($Button_LB.Tag -ne 'Enable') {$PageLB.Visible = $false}
if ($Button_PB.Tag -ne 'Enable') {$PagePB.Visible = $false}
if ($Button_BC.Tag -ne 'Enable') {$PageBC.Visible = $false}
if ($Button_SC.Tag -ne 'Enable') {$PageSC.Visible = $false}
if ($Button_SP.Tag -ne 'Enable') {$PageSP.Visible = $false;$scrolltimer.Enabled = $false}
$Button_W2V.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_V2W.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_LB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_PB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_BC.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_SC.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
if ($this.Tag -eq 'Enable') {$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_V2W.Tag -eq 'Enable') {$Button_W2V.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_W2V.Tag -eq 'Enable') {$Button_V2W.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_LB.Tag -eq 'Enable') {$Button_PB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_PB.Tag -eq 'Enable') {$Button_LB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}
if (Test-Path -Path "$PSScriptRootX\`$TEMP") {Remove-Item -Path "$PSScriptRootX\`$TEMP" -Force}
})
$button.Add_MouseEnter({$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$button.Add_MouseLeave({if ($this.Tag -eq 'Enable') {$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")} else {$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")}
if ($Button_V2W.Tag -eq 'Enable') {$Button_W2V.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_W2V.Tag -eq 'Enable') {$Button_V2W.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_LB.Tag -eq 'Enable') {$Button_PB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_PB.Tag -eq 'Enable') {$Button_LB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
})
$PageMain.Controls.Add($button)
return $button
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function SplashChange {
if ($SplashChange) {$NextSplash = Get-Random -Minimum 1 -Maximum 2;
if ($NextSplash -eq 1) {$Label0_PageSP.Text = "The World Is Yours"}}
if (-not ($Label0_PageSP.Text)) {$Label0_PageSP.Text = "Welcome to gploy. Granular Windows Deployment Re-envisioned."}
$ScrollLength = $Label0_PageSP.Text.Length
$global:Label0_PageSPL = ($GUI_SCALE / $DpiCur * -16 * $ScaleRef * $ScrollLength * 3.333);
$global:Label0_PageSPL = [Math]::Floor($Label0_PageSPL)
New-Object System.Drawing.Point($Label0_PageSPX, $Label0_PageSPY)
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Add_Paint {$paint.Add_Paint({param([object]$sender, [System.Windows.Forms.PaintEventArgs]$e);$graphics = $e.Graphics
$pen = New-Object System.Drawing.Pen([System.Drawing.Color]::Red, 10);$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Green);#$graphics.CloseFigure();#$graphics.AddEllipse($WSIZ, $HSIZ, $XLOC, $YLOC);#$graphics.FillRectangle($brush, $rectangle);#$graphics.AddLine($WSIZ, $HSIZ, $XLOC, $YLOC);
if ($shape -eq 'Rectangle') {$drawX = New-Object System.Drawing.Rectangle($XLOC, $YLOC, $WSIZ, $HSIZ);$graphics.DrawRectangle($pen, $drawX)};if ($shape -eq 'Ellipse') {$drawX = New-Object System.Drawing.Ellipse($XLOC, $YLOC, $WSIZ, $HSIZ);$graphics.DrawEllipse($pen, $drawX)};if ($shape -eq 'Line') {$drawX = New-Object System.Drawing.Line($XLOC, $YLOC, $WSIZ, $HSIZ);$graphics.DrawLine($pen, $drawX)}
$pen.Dispose();$brush.Dispose()})
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Get-ChildProcesses ($ParentProcessId) {$filter = "parentprocessid = '$($ParentProcessId)'"
Get-CIMInstance -ClassName win32_process -filter $filter | Foreach-Object {$_
if ($_.ParentProcessId -ne $_.ProcessId) {Get-ChildProcesses $_.ProcessId}}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageW2V {
$global:GUI_RESUME = "ImageProcessingW2V"
if (Test-Path -Path $ImageFolder\$($DropBox1_PageW2V.SelectedItem)) {$null} else {$DropBox1_PageW2V.SelectedItem = $null}
$ListView1_PageW2V.Items.Clear();#$ListView1_PageW2V.Columns[0].Width = -2
$DropBox1_PageW2V.ResetText();$DropBox1_PageW2V.Items.Clear()
$DropBox2_PageW2V.ResetText();$DropBox2_PageW2V.Items.Clear()
Get-ChildItem -Path "$ImageFolder\*.wim" -Name | ForEach-Object {[void]$DropBox1_PageW2V.Items.Add($_)}
Get-ChildItem -Path "$ImageFolder\*.wim" -Name | ForEach-Object {[void]$ListView1_PageW2V.Items.Add($_)}
[void]$DropBox1_PageW2V.Items.Add("Import Installation Media")
if ($($TextBox1_PageW2V.Text)) {$null} else {$TextBox1_PageW2V.Text = 'NewFile.vhdx'}
if ($($TextBox2_PageW2V.Text)) {$null} else {$TextBox2_PageW2V.Text = '25'}
$PageW2V.Visible = $true;$PageW2V.BringToFront();$Button_V2W.Visible = $true;$Button_W2V.Visible = $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageV2W {
$global:GUI_RESUME = "ImageProcessingV2W"
if (Test-Path -Path $ImageFolder\$($DropBox1_PageV2W.SelectedItem)) {$null} else {$DropBox1_PageV2W.SelectedItem = $null}
$ListView1_PageV2W.Items.Clear();#$ListView1_PageW2V.Columns[0].Width = -2
$DropBox1_PageV2W.ResetText();$DropBox1_PageV2W.Items.Clear()
$DropBox2_PageV2W.ResetText();$DropBox2_PageV2W.Items.Clear()
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageV2W.Items.Add($_)}
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageV2W.Items.Add($_)}
if ($($TextBox1_PageV2W.Text)) {$null} else {$TextBox1_PageV2W.Text = 'NewFile.wim'}
if ($($DropBox3_PageV2W.SelectedItem)) {$null} else {$DropBox3_PageV2W.Items.Clear();$DropBox3_PageV2W.Items.Add("Fast");$DropBox3_PageV2W.Items.Add("Max");$DropBox3_PageV2W.SelectedItem = "Fast";}
$PageV2W.Visible = $true;$PageV2W.BringToFront();$Button_W2V.Visible = $true;$Button_V2W.Visible = $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageLB {
$global:GUI_RESUME = "ImageManagementList"
$ListView1_PageLB.Items.Clear();$ListView2_PageLB.Items.Clear()
Get-ChildItem -Path "$ListFolder\*.base" -Name | ForEach-Object {[void]$ListView1_PageLB.Items.Add($_)}
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView2_PageLB.Items.Add($_)}
if ($DropBox1_PageLB.SelectedItem) {$null} else {$DropBox1_PageLB.Items.Clear();[void]$DropBox1_PageLB.Items.Add("🪟 Current Environment");[void]$DropBox1_PageLB.Items.Add("Disabled");Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageLB.Items.Add($_)}
[void]$DropBox1_PageLB.Items.Add("Refresh");$DropBox1_PageLB.SelectedItem = "$REFERENCE";}
if ($REFERENCE -eq "LIVE") {if (-not ($DropBox1_PageLB.SelectedItem -eq "🪟 Current Environment")) {$DropBox1_PageLB.SelectedItem = "🪟 Current Environment";}}
$PageMain.Visible = $true;$PageLEWiz.Visible = $false;$PageLBWiz.Visible = $false;$PageLB.Visible = $true;$PageLB.BringToFront();$Button_PB.Visible = $true;$Button_LB.Visible = $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PagePB {
$global:GUI_RESUME = "ImageManagementPack"
$ListView1_PagePB.Items.Clear();$ListView2_PagePB.Items.Clear()
Get-ChildItem -Path "$PackFolder\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePB.Items.Add($_)}
if (Test-Path -Path $ProjectFolder) {
Get-ChildItem -Path "$ProjectFolder" -Name | ForEach-Object {[void]$ListView2_PagePB.Items.Add($_)}}
$PageMain.Visible = $true;$PagePEWiz.Visible = $false;$PagePBWiz.Visible = $false;$PagePB.Visible = $true;$PagePB.BringToFront();$Button_LB.Visible = $true;$Button_PB.Visible = $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageBC {
$global:GUI_RESUME = "BootDiskCreator"
$DropBox3_PageBC.Items.Clear();$DropBox3_PageBC.Items.Add("Refresh");$DropBox3_PageBC.Text = "Select Disk"
if (Test-Path -Path $ImageFolder\$($DropBox1_PageBC.SelectedItem)) {$null} else {$DropBox1_PageBC.SelectedItem = $null}
$ListView1_PageBC.Items.Clear();Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageBC.Items.Add($_)}
$DropBox1_PageBC.ResetText();$DropBox1_PageBC.Items.Clear();$DropBox1_PageBC.Text = "Select .vhdx"
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageBC.Items.Add($_)}
if (Test-Path -Path $CacheFolder\$($DropBox2_PageBC.SelectedItem)) {$null} else {$DropBox2_PageBC.SelectedItem = $null}
$empty = $true;
$DropBox2_PageBC.ResetText();$DropBox2_PageBC.Items.Clear()
Get-ChildItem -Path "$CacheFolder\*.jpg" -Name | ForEach-Object {$empty = $false;[void]$DropBox2_PageBC.Items.Add($_)}
Get-ChildItem -Path "$CacheFolder\*.png" -Name | ForEach-Object {$empty = $false;[void]$DropBox2_PageBC.Items.Add($_)}
[void]$DropBox2_PageBC.Items.Add("Import Wallpaper")
$PageBC.Visible = $true;$PageBC.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageSC {
$global:GUI_RESUME = "Settings"
if ($($DropBox1_PageSC.SelectedItem)) {$null} else {$DropBox1_PageSC.ResetText();$DropBox1_PageSC.Items.Clear();
$key = Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont"
#$key.GetValueNames() | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}
$key.GetValueNames() | ForEach-Object {$key.GetValue($_) | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}}
$DropBox1_PageSC.SelectedItem = "$GUI_CONFONT"}
if ($($DropBox2_PageSC.SelectedItem)) {$null} else {$DropBox2_PageSC.ResetText();$DropBox2_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36','40','44','48','52','56','60','64','68','72')) {[void]$DropBox2_PageSC.Items.Add($i)}
$DropBox2_PageSC.SelectedItem = "$GUI_CONFONTSIZE"}
if ($($DropBox3_PageSC.SelectedItem)) {$null} else {$DropBox3_PageSC.ResetText();$DropBox3_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36')) {[void]$DropBox3_PageSC.Items.Add($i)}
$DropBox3_PageSC.SelectedItem = "$GUI_LVFONTSIZE"}
if ($($DropBox4_PageSC.SelectedItem)) {$null} else {$DropBox4_PageSC.ResetText();$DropBox4_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36')) {[void]$DropBox4_PageSC.Items.Add($i)}
$DropBox4_PageSC.SelectedItem = "$GUI_FONTSIZE"}
if ($($DropBox5_PageSC.SelectedItem)) {$null} else {
$DropBox5_PageSC.ResetText();$DropBox5_PageSC.Items.Clear();
[void]$DropBox5_PageSC.Items.Add("🎨 Theme");[void]$DropBox5_PageSC.Items.Add("Button");[void]$DropBox5_PageSC.Items.Add("Highlight");[void]$DropBox5_PageSC.Items.Add("Text Color");[void]$DropBox5_PageSC.Items.Add("Text Canvas");[void]$DropBox5_PageSC.Items.Add("Side Panel");[void]$DropBox5_PageSC.Items.Add("Background")}
$DropBox5_PageSC.SelectedItem = ""
$PageSC.Visible = $true;$PageSC.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageSP {$scrolltimer.Enabled = $true
$global:GUI_RESUME = "Splash";$PageSP.Visible = $true;$PageSP.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function GUI_Resume {
ForEach ($i in @('ImageProcessingW2V','ImageProcessingV2W','ImageManagementList','ImageManagementPack','BootDiskCreator','Settings','Splash')) {if ($GUI_RESUME -eq "$i") {$GUI_RESUME_PASS = 1}}
if ($GUI_RESUME_PASS) {$null} else {$GUI_RESUME = 'Splash'}
if ($GUI_RESUME -eq 'ImageProcessingW2V') {$Button_W2V.Tag = 'Enable';Button_PageW2V;$global:Pswitch = ""}
if ($GUI_RESUME -eq 'ImageProcessingV2W') {$Button_V2W.Tag = 'Enable';Button_PageV2W;$global:Pswitch = ""}
if ($GUI_RESUME -eq 'ImageManagementList') {$Button_LB.Tag = 'Enable';Button_PageLB;$global:Mswitch = ""}
if ($GUI_RESUME -eq 'ImageManagementPack') {$Button_PB.Tag = 'Enable';Button_PagePB;$global:Mswitch = ""}
if ($GUI_RESUME -eq 'BootDiskCreator') {$Button_BC.Tag = 'Enable';Button_PageBC}
if ($GUI_RESUME -eq 'Settings') {$Button_SC.Tag = 'Enable';Button_PageSC}
if ($GUI_RESUME -eq 'Splash') {$Button_SP.Tag = 'Enable';Button_PageSP}
$ColorFill = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")
if ($Button_W2V.Tag -eq 'Enable') {$Button_V2W.BackColor = $ColorFill}
if ($Button_V2W.Tag -eq 'Enable') {$Button_W2V.BackColor = $ColorFill}
if ($Button_LB.Tag -eq 'Enable') {$Button_PB.BackColor = $ColorFill}
if ($Button_PB.Tag -eq 'Enable') {$Button_LB.BackColor = $ColorFill}
if ($Button_BC.Tag -eq 'Enable') {$Button_BC.BackColor = $ColorFill}
if ($Button_SC.Tag -eq 'Enable') {$Button_SC.BackColor = $ColorFill}
if ($Button_SP.Tag -eq 'Enable') {$Button_SP.BackColor = $ColorFill}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportBoot {
if (Test-Path -Path $CacheFolder\boot.sav) {$result = [System.Windows.Forms.MessageBox]::Show("Boot media already exists.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)} else {
$FilePath = "$CacheFolder";$FileFilt = "ISO files (*.iso)|*.iso";PickFile
if ($Pick) {
$Image = Mount-DiskImage -ImagePath "$Pick" -PassThru
$drvLetter = ($Image | Get-Volume).DriveLetter
if (Test-Path -Path "$drvLetter`:\sources\boot.wim") {
$source = "$drvLetter`:\sources\boot.wim";$target = "$CacheFolder"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Rename-Item -Path "$CacheFolder\boot.wim" -NewName "boot.sav"}
Dismount-DiskImage -DevicePath $Image.DevicePath} else {$null}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportWim {
$FilePath = "$ImageFolder";$FileFilt = "ISO files (*.iso)|*.iso";PickFile
if ($Pick) {
$Image = Mount-DiskImage -ImagePath "$Pick" -PassThru
$drvLetter = ($Image | Get-Volume).DriveLetter
$source = "$drvLetter`:\sources\install.wim";$target = "$FilePath"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Dismount-DiskImage -DevicePath $Image.DevicePath}
Button_PageW2V
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportWallpaper {
$DropBox2_PageBC.SelectedItem = $null
$FilePath = $HOME;$FileFilt = "Picture files (*.jpg;*.png)|*.jpg;*.png";PickFile
if ($Pick) {
$source = "$Pick";$target = "$CacheFolder"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Dismount-DiskImage -DevicePath $Image.DevicePath}
Button_PageBC
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox1LB {
if ($DropBox1LBChanged -eq '1') {
$global:REFERENCE = "$($DropBox1_PageLB.SelectedItem)";if ($REFERENCE -eq "🪟 Current Environment") {$global:REFERENCE = "LIVE"}
if ($REFERENCE -eq "Refresh") {$DropBox1_PageLB.Items.Clear();[void]$DropBox1_PageLB.Items.Add("🪟 Current Environment");[void]$DropBox1_PageLB.Items.Add("Disabled");Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageLB.Items.Add($_)}
[void]$DropBox1_PageLB.Items.Add("Refresh");$DropBox1_PageLB.SelectedItem = "🪟 Current Environment";} else {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "REFERENCE=$REFERENCE" -Encoding UTF8}}
if ($REFERENCE -eq "LIVE") {if (-not ($DropBox1_PageLB.SelectedItem -eq "🪟 Current Environment")) {$DropBox1_PageLB.SelectedItem = "🪟 Current Environment";}}
$global:DropBox1LBChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Dropbox3BC {
$ListView1_PageBC.Items.Clear();[void]$ListView1_PageBC.Items.Add("Querying disks...")
$DropBox3_PageBC.Items.Clear();
$disks = Get-Disk | Sort-Object -Property Number
$ListView1_PageBC.Items.Clear();foreach ($disk in $disks) {
#$diskModel = $disk.Model;#$diskID = $disk.UniqueID;#$diskSerialNumber = $disk.SerialNumber
$diskNumber = $disk.Number;$diskSize = $disk.Size / 1073741824;$diskSize = [Math]::Floor($diskSize)
if (Test-Path -Path "$PSScriptRootX\`$DISK") {Remove-Item -Path "$PSScriptRootX\`$DISK" -Force}
Add-Content -Path "$PSScriptRootX\`$DISK" -Value "select disk $diskNumber" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$DISK" -Value "detail disk" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$DISK" -Value "exit" -Encoding UTF8
$diskpart = DISKPART /S "$PSScriptRootX\`$DISK";Remove-Item -Path "$PSScriptRootX\`$DISK" -Force
$ltr = $null;$vols = $null;$pagefile = 0;$sysdrive = 0;$progdrive = 0;$diskreason = $null;
Foreach ($line in $diskpart) {$parta, $partb, $partc, $partd, $parte, $partf, $partg, $parth, $parti, $partj, $partk, $partl, $partm, $partn = $line -split '[{}:. 	 ]'
if ($start -eq 'y') {$name = $line;$start = $null};if ($start -eq 'x') {$start = 'y'};if ($partg -eq 'disk') {$start = 'x'}
if ($parta -eq 'Disk') {if ($partb -eq 'ID') {if ($parte) {$diskid = $parte} else {$diskid = $partd}}}
if ($parta -eq 'Pagefile') {if ($partb -eq 'Disk') {if ($partf -eq 'Yes') {$pagefile = 1}}}
if ($partc -eq 'Volume') {if (-not ($partd -eq '###')) {
if ($parti -eq '') {$vols = "*, $vols"};if ($parti -eq $null) {$vols = "*, $vols"}
if ($parti -ne $null) {if ($parti -ne '') {$vols = "$parti, $vols"}}
if ($parti -eq "$sysltr") {$sysdrive = 1}
if ($parti -eq "$progltr") {$progdrive = 1}
}}}
if ($pagefile -eq '1') {$diskreason = "$diskreason PageFile"}
if ($sysdrive -eq '1') {$diskreason = "$diskreason SysDrive"}
if ($progdrive -eq '1') {$diskreason = "$diskreason ProgDrive"}
if ($diskreason) {$diskreason = "`|$diskreason"} else {[void]$DropBox3_PageBC.Items.Add("Disk $diskNumber `| $name `| $vols`| $diskSize GB")}
[void]$ListView1_PageBC.Items.Add("Disk $diskNumber `| $name `| $vols`| $diskSize GB $diskreason")}
[void]$DropBox3_PageBC.Items.Add("Refresh");}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Dropbox1W2V {
if ($DropBox1_PageW2V.SelectedItem) {if ($DropBox1_PageW2V.SelectedItem -ne 'Import Installation Media') {
$DropBox2_PageW2V.Items.Clear()
$ListView1_PageW2V.Items.Clear()
$command = DISM.EXE /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"$ImageFolder\$($DropBox1_PageW2V.SelectedItem)"
Foreach ($line in $command) {
if ($line -match "Index :") {
[void]$ListView1_PageW2V.Items.Add($line)
$parts = $line.Split(":", 9)
$column2 = $parts[1].Trim()
[void]$DropBox2_PageW2V.Items.Add($column2)}
if ($line -match "Name :") {
$parts = $line.Split(":", 9)
$column1 = $parts[0].Trim()
$column2 = $parts[1].Trim()
#$item = New-Object System.Windows.Forms.ListViewItem
#$item.Text = $file.Name
#[void]$item.SubItems.Add($file.Length)
#[void]$item.SubItems.Add($file.Extension)
#[void]$listView.Items.Add($item)
[void]$ListView1_PageW2V.Items.Add($column2)
}}
if ($column2) {$null} else {[void]$DropBox2_PageW2V.Items.Add("1");[void]$ListView1_PageW2V.Items.Add("Index : 1");[void]$ListView1_PageW2V.Items.Add("<no information>")}
$DropBox2_PageW2V.SelectedItem = "1"
}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Dropbox1V2W {
$DropBox2_PageV2W.Items.Clear()
$ListView1_PageV2W.Items.Clear();#$DropBox2_PageV2W.Text = '1'
$command = DISM.EXE /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"$ImageFolder\$($DropBox1_PageV2W.SelectedItem)" /INDEX:1
Foreach ($line in $command) {
if ($line -match "Index :") {
[void]$ListView1_PageV2W.Items.Add($line)
$parts = $line.Split(":", 9)
$column2 = $parts[1].Trim()
[void]$DropBox2_PageV2W.Items.Add($column2)}
if ($line -match "Name :") {
$parts = $line.Split(":", 9)
$column1 = $parts[0].Trim()
$column2 = $parts[1].Trim()
[void]$ListView1_PageV2W.Items.Add($column2)
}}
if ($column2) {$null} else {[void]$DropBox2_PageV2W.Items.Add("1");[void]$ListView1_PageV2W.Items.Add("Index : 1");[void]$ListView1_PageV2W.Items.Add("<no information>")}
$DropBox2_PageV2W.SelectedItem = "1"
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox1SC {
if ($DropBox1SCChanged -eq '1') {
$global:GUI_CONFONT = "$($DropBox1_PageSC.SelectedItem)";[VOID][WinMekanix]::SetConsoleFont("$GUI_CONFONT", "$CFSIZEX")
Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_CONFONT=$($DropBox1_PageSC.SelectedItem)" -Encoding UTF8}
$global:DropBox1SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox2SC {
if ($DropBox2SCChanged -eq '1') {
$global:GUI_CONFONTSIZE = "$($DropBox2_PageSC.SelectedItem)"
if ($GUI_CONFONTSIZE -eq 'Auto') {$global:CFSIZE0 = 28} else {$global:CFSIZE0 = $GUI_CONFONTSIZE}
#$ScaleFont = $CFSIZE0 * $ScaleRef * $GUI_SCALE
$ScaleFont = $GUI_SCALE / $DpiCur * $CFSIZE0 * $ScaleRef
$ScaleFontX = [Math]::Floor($ScaleFont);$global:CFSIZEX = $ScaleFontX
[VOID][WinMekanix]::SetConsoleFont("$GUI_CONFONT", "$CFSIZEX")
Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_CONFONTSIZE=$($DropBox2_PageSC.SelectedItem)" -Encoding UTF8}
$global:DropBox2SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox3SC {
#$global:GUI_LVFONTSIZE = "$($DropBox3_PageSC.SelectedItem)"
if ($DropBox3SCChanged -eq '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_LVFONTSIZE=$($DropBox3_PageSC.SelectedItem)" -Encoding UTF8
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\gploy.cmd";$NoExitPrompt = 1;$form.Close()}}
$global:DropBox3SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox4SC {
#$global:GUI_FONTSIZE = "$($DropBox4_PageSC.SelectedItem)"
if ($DropBox4SCChanged -eq '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_FONTSIZE=$($DropBox4_PageSC.SelectedItem)" -Encoding UTF8
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\gploy.cmd";$NoExitPrompt = 1;$form.Close()}}
$global:DropBox4SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox5SC {
if ($($DropBox5_PageSC.SelectedItem) -eq '🎨 Theme') {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Theme' -MessageBoxText 'Select a theme' -MessageBoxChoices "Dark❗DarkRed❗DarkGreen❗DarkBlue❗Light❗LightRed❗LightGreen❗LightBlue"
if ($boxoutput -eq "Dark") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF151515';$GUI_BTN_COLORX = 'FF404040';$GUI_HLT_COLORX = 'FF777777';$GUI_BG_COLORX = 'FF252525';$GUI_PAG_COLORX = 'FF151515'}
if ($boxoutput -eq "DarkRed") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF150000';$GUI_BTN_COLORX = 'FF400000';$GUI_HLT_COLORX = 'FF770000';$GUI_BG_COLORX = 'FF250000';$GUI_PAG_COLORX = 'FF150000'}
if ($boxoutput -eq "DarkGreen") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF001500';$GUI_BTN_COLORX = 'FF004000';$GUI_HLT_COLORX = 'FF007700';$GUI_BG_COLORX = 'FF002500';$GUI_PAG_COLORX = 'FF001500'}
if ($boxoutput -eq "DarkBlue") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF000015';$GUI_BTN_COLORX = 'FF000040';$GUI_HLT_COLORX = 'FF000077';$GUI_BG_COLORX = 'FF000025';$GUI_PAG_COLORX = 'FF000015'}
if ($boxoutput -eq "Light") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFFFFFFF';$GUI_BTN_COLORX = 'FFC0C0C0';$GUI_HLT_COLORX = 'FFD5D5D5';$GUI_BG_COLORX = 'FFA0A0A0';$GUI_PAG_COLORX = 'FF555555'}
if ($boxoutput -eq "LightRed") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFFFD0D0';$GUI_BTN_COLORX = 'FFFF8888';$GUI_HLT_COLORX = 'FFFFACAC';$GUI_BG_COLORX = 'FFE06C6C';$GUI_PAG_COLORX = 'FF990000'}
if ($boxoutput -eq "LightGreen") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFD0FFD0';$GUI_BTN_COLORX = 'FF88FF88';$GUI_HLT_COLORX = 'FFACFFAC';$GUI_BG_COLORX = 'FF6CE06C';$GUI_PAG_COLORX = 'FF009900'}
if ($boxoutput -eq "LightBlue") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFD0D0FF';$GUI_BTN_COLORX = 'FF8888FF';$GUI_HLT_COLORX = 'FFACACFF';$GUI_BG_COLORX = 'FF6C6CE0';$GUI_PAG_COLORX = 'FF000099'}
ForEach ($i in @("","GUI_TXT_FORE=$GUI_TXT_FOREX","GUI_TXT_BACK=$GUI_TXT_BACKX","GUI_BTN_COLOR=$GUI_BTN_COLORX","GUI_HLT_COLOR=$GUI_HLT_COLORX","GUI_BG_COLOR=$GUI_BG_COLORX","GUI_PAG_COLOR=$GUI_PAG_COLORX")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\gploy.cmd";$NoExitPrompt = 1;$form.Close()}
}
if ($($DropBox5_PageSC.SelectedItem) -ne '🎨 Theme') {$colorDialog = New-Object System.Windows.Forms.ColorDialog;$boxresultX = $colorDialog.ShowDialog()}
If ($boxresultX -eq [System.Windows.Forms.DialogResult]::OK) {
$colorSelect = $colorDialog.Color;$colorHex = $($colorSelect.ToArgb().ToString('X'))
if ($($DropBox5_PageSC.SelectedItem) -eq 'Text Color') {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_TXT_FORE=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Text Canvas') {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_TXT_BACK=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Button') {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_BTN_COLOR=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Highlight') {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_HLT_COLOR=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Background') {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_BG_COLOR=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Side Panel') {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_PAG_COLOR=$colorHex" -Encoding UTF8}
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\gploy.cmd";$NoExitPrompt = 1;$form.Close()}
}
$DropBox5_PageSC.ResetText();$DropBox5_PageSC.Items.Clear();
[void]$DropBox5_PageSC.Items.Add("🎨 Theme");[void]$DropBox5_PageSC.Items.Add("Button");[void]$DropBox5_PageSC.Items.Add("Highlight");[void]$DropBox5_PageSC.Items.Add("Text Color");[void]$DropBox5_PageSC.Items.Add("Text Canvas");[void]$DropBox5_PageSC.Items.Add("Side Panel");[void]$DropBox5_PageSC.Items.Add("Background")
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PBWiz_Stage1 {$global:PBWiz_Stage = 1
$Label1_PagePBWiz.Text = "🗳 Pack Builder"
$Label2_PagePBWiz.Text = "Select an option"
$ListView1_PagePBWiz.GridLines = $false
$ListView1_PagePBWiz.CheckBoxes = $false
$ListView1_PagePBWiz.FullRowSelect = $true
$ListView1_PagePBWiz.Items.Clear();
$item1 = New-Object System.Windows.Forms.ListViewItem("💾 Capture Project Folder")
[void]$ListView1_PagePBWiz.Items.Add($item1)
$item1 = New-Object System.Windows.Forms.ListViewItem("🗳 New Package Template")
[void]$ListView1_PagePBWiz.Items.Add($item1)
$item1 = New-Object System.Windows.Forms.ListViewItem("🗳 Restore Package")
[void]$ListView1_PagePBWiz.Items.Add($item1)
$item1 = New-Object System.Windows.Forms.ListViewItem("🔄 Export Drivers")
[void]$ListView1_PagePBWiz.Items.Add($item1)
$PagePBWiz.Visible = $true;$PageMain.Visible = $false;$PagePB.Visible = $false;$PagePBWiz.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PBWiz_Stage2 {$global:PBWiz_Stage = 2;
if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {$global:ListViewSelectS2 = $ListView1_PagePBWiz.FocusedItem}
$ListView1_PagePBWiz.GridLines = $false;$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]'

if ($ListViewChoiceS2 -eq "💾 Capture Project Folder") {
$Label1_PagePBWiz.Text = "🗳 Pack Builder"
$Label2_PagePBWiz.Text = "Capture Project Folder"
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Package' -MessageBoxText 'Enter new .pkx package name' -Check 'PATH'

if ($boxresult -ne "OK") {$global:PBWiz_Stage = 1;$Label1_PagePBWiz.Text = "🗳 Pack Builder";$Label2_PagePBWiz.Text = "Select an option"}
if ($boxresult -eq "OK") {$ListView1_PagePBWiz.Items.Clear();
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}
$command = @"
DISM /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"$PSScriptRootX\project" /IMAGEFILE:"$PackFolder\$boxoutput.pkx" /COMPRESS:Fast /NAME:"PKX" /CheckIntegrity /Verify
"@
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-CUSTOM","ARG4=`$LIST","ARG5=-LIVE")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
ForEach ($i in @("MENU-SCRIPT","`❕ⓠCommand`❕ECHO.           %@@%PACKAGE CREATE START`:%`$`$%  %DATE%  %TIME%`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕$command`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕ECHO.`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕ECHO.            %@@%PACKAGE CREATE END`:%`$`$%  %DATE%  %TIME%`❕NORMAL`❕DX`❕")) {Add-Content -Path "$ListFolder\`$LIST" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB;
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

if ($ListViewChoiceS2 -eq "🗳 New Package Template") {
$Label1_PagePBWiz.Text = "🗳 Pack Builder"
$Label2_PagePBWiz.Text = "New Package Template"
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Delete' -MessageBoxText 'This will empty the contents of the project folder. Are you sure?'
if ($boxresult -ne "OK") {$global:PBWiz_Stage = 1;$Label1_PagePBWiz.Text = "🗳 Pack Builder";$Label2_PagePBWiz.Text = "Select an option"}
if ($boxresult -eq "OK") {if (Test-Path -Path $ProjectFolder) {Remove-Item -Path "$ProjectFolder" -Recurse -Force}
ForEach ($i in @("ARG1=-IMAGEMGR","ARG2=-NEWPACK")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB;
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

if ($ListViewChoiceS2 -eq "🗳 Restore Package") {
$Label1_PagePBWiz.Text = "🗳 Restore Package"
$Label2_PagePBWiz.Text = "Select a package"
$ListView1_PagePBWiz.Items.Clear()
Get-ChildItem -Path "$PackFolder\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePBWiz.Items.Add($_)}
}
if ($ListViewChoiceS2 -eq "🔄 Export Drivers") {
$Label1_PagePBWiz.Text = "🔄 Export Drivers"
$Label2_PagePBWiz.Text = "Select a source"
$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.Items.Clear();
[void]$ListView1_PagePBWiz.Items.Add("🪟 Current Environment")
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PagePBWiz.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PBWiz_Stage3 {$global:PBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PagePBWiz.FocusedItem}
$ListView1_PagePBWiz.GridLines = $false;$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
if ($ListViewChoiceS2 -eq "🔄 Export Drivers") {
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-EXPORT","ARG3=-DRIVERS")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
If ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "ARG4=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG4=-VHDX","ARG5=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB;
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}

if ($ListViewChoiceS2 -eq "🗳 Restore Package") {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Delete' -MessageBoxText 'This will empty the contents of the project folder. Are you sure?'
if ($boxresult -ne "OK") {$global:PBWiz_Stage = 2;}
if ($boxresult -eq "OK") {
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}
if (Test-Path -Path "$ProjectFolder") {Remove-Item -Path "$ProjectFolder" -Recurse -Force}
New-Item -ItemType Directory -Path "$PSScriptRootX\project"
$command = @"
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"$PackFolder\$ListViewChoiceS3" /INDEX:1 /APPLYDIR:"$ProjectFolder"
"@
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-CUSTOM","ARG4=`$LIST","ARG5=-LIVE")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
ForEach ($i in @("MENU-SCRIPT","`❕ⓠCommand`❕ECHO.           %@@%PACKAGE EXTRACT START`:%`$`$%  %DATE%  %TIME%`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕$command`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕ECHO.`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕ECHO.            %@@%PACKAGE EXTRACT END`:%`$`$%  %DATE%  %TIME%`❕NORMAL`❕DX`❕")) {Add-Content -Path "$ListFolder\`$LIST" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage1 {$global:LEWiz_Stage = 1;$global:ListMode = 'Execute'
$Label1_PageLEWiz.Text = "🧾 List Execute"
$Label2_PageLEWiz.Text = "Select an option"
$ListView1_PageLEWiz.GridLines = $false
$ListView1_PageLEWiz.CheckBoxes = $false
$ListView1_PageLEWiz.FullRowSelect = $true
$ListView1_PageLEWiz.Items.Clear();
Get-ChildItem -Path "$ListFolder\*.base" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
$PageLEWiz.Visible = $true;$PageMain.Visible = $false;$PageLB.Visible = $false;$PageLEWiz.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage2 {$global:LEWiz_Stage = 2;$global:marked = $null;$global:boxresult = $null
$global:ListViewSelectS2 = $ListView1_PageLEWiz.FocusedItem
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]';
$LBWiz_TypeZ = Get-Content -Path "$ListFolder\$ListViewChoiceS2" -TotalCount 1
$global:LBWiz_TypeX, $partbxyz = $LBWiz_TypeZ -split '[ ]';

if ($LBWiz_TypeX -ne 'MENU-SCRIPT') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'Header is not MENU-SCRIPT, check file.';LEWiz_Stage1;$global:LBWiz_Stage = $null;$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront();return}
$LBWiz_TypeEXT = [System.IO.Path]::GetExtension("$ListFolder\$ListViewChoiceS2").ToUpper()

if ($LBWiz_TypeEXT -eq ".BASE") {$PageLBWiz.Visible = $true;$PageLEWiz.Visible = $false;$PageLBWiz.BringToFront();LBWiz_Stage2}
$Label1_PageLEWiz.Text = "🧾 List Execute"
$Label2_PageLEWiz.Text = "Select a target"
$ListView1_PageLEWiz.GridLines = $false;$ListView1_PageLEWiz.CheckBoxes = $false;$ListView1_PageLEWiz.FullRowSelect = $true
if ($LBWiz_TypeEXT -eq ".BASE") {$global:ListViewChoiceS2 = "`$LIST"}
$ListView1_PageLEWiz.Items.Clear();
[void]$ListView1_PageLEWiz.Items.Add("🪟 Current Environment")
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage3 {$global:LEWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLEWiz.FocusedItem}
$ListView1_PageLEWiz.GridLines = $false;$ListView1_PageLEWiz.CheckBoxes = $false;$ListView1_PageLEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-LIST","ARG4=$ListViewChoiceS2")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "ARG5=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}}
$global:LEWiz_Stage = $null;$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLEWiz.Visible = $false;Button_PageLB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
$PictureBoxConsole.Visible = $true;$PictureBoxConsole.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage1 {$global:PEWiz_Stage = 1;
$Label1_PagePEWiz.Text = "🗳 Pack Execute"
$Label2_PagePEWiz.Text = "Select a package"
$ListView1_PagePEWiz.GridLines = $false
$ListView1_PagePEWiz.CheckBoxes = $false
$ListView1_PagePEWiz.FullRowSelect = $true
$ListView1_PagePEWiz.Items.Clear();
Get-ChildItem -Path "$PackFolder\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePEWiz.Items.Add($_)}
$PagePEWiz.Visible = $true;$PageMain.Visible = $false;$PagePB.Visible = $false;$PagePEWiz.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage2 {$global:PEWiz_Stage = 2;
$Label1_PagePEWiz.Text = "🗳 Pack Execute"
$Label2_PagePEWiz.Text = "Select a target"
if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {$global:ListViewSelectS2 = $ListView1_PagePEWiz.FocusedItem}
$ListView1_PagePEWiz.GridLines = $false;$ListView1_PagePEWiz.CheckBoxes = $false;$ListView1_PagePEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]'
$ListView1_PagePEWiz.Items.Clear();
[void]$ListView1_PagePEWiz.Items.Add("🪟 Current Environment")
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PagePEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage3 {$global:PEWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PagePEWiz.FocusedItem}
$ListView1_PagePEWiz.GridLines = $false;$ListView1_PagePEWiz.CheckBoxes = $false;$ListView1_PagePEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-PACK","ARG4=$ListViewChoiceS2")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "ARG5=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}}
$global:PEWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePEWiz.Visible = $false;Button_PagePB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
$PictureBoxConsole.Visible = $true;$PictureBoxConsole.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage1 {$global:LBWiz_Stage = 1;$global:ListMode = 'Builder'
$Label1_PageLBWiz.Text = "🧾 List Builder"
$Label2_PageLBWiz.Text = "Select an option"
$ListView1_PageLBWiz.GridLines = $false
$ListView1_PageLBWiz.CheckBoxes = $false
$ListView1_PageLBWiz.FullRowSelect = $true
$ListView1_PageLBWiz.Items.Clear();
$item1 = New-Object System.Windows.Forms.ListViewItem("🧾 Miscellaneous")
#[void]$item1.SubItems.Add("Description for X")
[void]$ListView1_PageLBWiz.Items.Add($item1)
Get-ChildItem -Path "$ListFolder\*.base" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
$PageLBWiz.Visible = $true;$PageMain.Visible = $false;$PageLB.Visible = $false;$PageLBWiz.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage2 {$global:LBWiz_Stage = 2;
$GRP = $null;if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {
if ($ListMode -eq "Builder") {$global:ListViewSelectS2 = $ListView1_PageLBWiz.FocusedItem}}
$parta, $global:BaseFile, $partc = $ListViewSelectS2 -split '[{}]';

if ($BaseFile -eq "🧾 Miscellaneous") {$global:LBWiz_Type = 'MISC';}
if ($BaseFile -ne "🧾 Miscellaneous") {
$LBWiz_TypeZ = Get-Content -Path "$ListFolder\\$BaseFile" -TotalCount 1
$global:LBWiz_Type, $partbxyz = $LBWiz_TypeZ -split '[ ]'
if ($LBWiz_Type -ne 'MENU-SCRIPT') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'Header is not MENU-SCRIPT, check file.';LBWiz_Stage1;return}}

$ListView1_PageLBWiz.Items.Clear()
$ListView1_PageLBWiz.GridLines = $false
$ListView1_PageLBWiz.CheckBoxes = $false
$ListView1_PageLBWiz.FullRowSelect = $true

if ($LBWiz_Type -eq 'MISC') {
$Label1_PageLBWiz.Text = "🧾 List $ListMode"
$Label2_PageLBWiz.Text = "Miscellaneous"
ForEach ($i in @("🧾 Create Source Base","🧾 Generate Example Base","🧾 Convert Group Base","✒ External Package Item")) {[void]$ListView1_PageLBWiz.Items.Add("$i")}
}
if ($LBWiz_Type -eq 'MENU-SCRIPT') {
if ($REFERENCE -ne 'DISABLED') {
if ($REFERENCE -eq 'LIVE') {MOUNT_INT}
if ($REFERENCE -ne 'LIVE') {if (-not ($vdiskltr)) {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Mounting Reference Image...";VDISK_ATTACH}}}

$Label1_PageLBWiz.Text = "🧾 List $ListMode"
$Label2_PageLBWiz.Text = "$BaseFile"
Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh = $_ -split "[❕]"
if ($partXb -eq 'GROUP') {if (-not ($partXc -eq $GRP)) {
$GRP = "$partXc";#$item1.SubItems.Add("$partXf")
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXc")
[void]$ListView1_PageLBWiz.Items.Add($item1)}}}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage3MISC {$global:LBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLBWiz.FocusedItem}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'

if ($ListViewChoiceS3 -eq "🧾 Create Source Base") {
$Label1_PageLBWiz.Text = "🧾 Miscellaneous"
$Label2_PageLBWiz.Text = "Create Source Base"
$ListView1_PageLBWiz.Items.Clear()
ForEach ($i in @("All source items","AppX","Capability","Feature","Service","Task","Component","Driver")) {[void]$ListView1_PageLBWiz.Items.Add("$i")}}

if ($ListViewChoiceS3 -eq "🧾 Generate Example Base") {
$Label1_PageLBWiz.Text = "🧾 Miscellaneous"
$Label2_PageLBWiz.Text = "Generate Example Base"
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Generate Example Base' -MessageBoxText 'Enter new base name' -Check 'PATH'
if ($boxresult -eq "OK") {$BaseName = "$boxoutput";
ForEach ($i in @("ARG1=-IMAGEMGR","ARG2=-EXAMPLE","ARG3=$boxoutput.base")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
return}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "✒ External Package Item") {
$Label1_PageLBWiz.Text = "🧾 Miscellaneous";
$Label2_PageLBWiz.Text = "Select a package"
$ListView1_PageLBWiz.Items.Clear()
Get-ChildItem -Path "$PackFolder\*.appx" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.appxbundle" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.cab" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.msixbundle" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.msu" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.pkx" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}

if ($ListViewChoiceS3 -eq "🧾 Convert Group Base") {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();
$Label1_PageLBWiz.Text = "🧾 Convert Group Base";
$Label2_PageLBWiz.Text = "Select a list to convert"
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4MISC {$global:LBWiz_Stage = 4;
if ($marked -ne $null) {$global:ListViewSelectS4 = $marked} else { $global:ListViewSelectS4 = $ListView1_PageLBWiz.FocusedItem}
$parta, $global:ListViewChoiceS4, $partc = $ListViewSelectS4 -split '[{}]'
if ($ListViewChoiceS3 -eq "🧾 Create Source Base") {
if ($ListViewChoiceS4 -eq 'All source items') {$global:ListViewBase = '1 4 2 5 6 7 3'}
if ($ListViewChoiceS4 -eq 'AppX') {$global:ListViewBase = 1}
if ($ListViewChoiceS4 -eq 'Feature') {$global:ListViewBase = 2}
if ($ListViewChoiceS4 -eq 'Component') {$global:ListViewBase = 3}
if ($ListViewChoiceS4 -eq 'Capability') {$global:ListViewBase = 4}
if ($ListViewChoiceS4 -eq 'Service') {$global:ListViewBase = 5}
if ($ListViewChoiceS4 -eq 'Task') {$global:ListViewBase = 6}
if ($ListViewChoiceS4 -eq 'Driver') {$global:ListViewBase = 7}
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Source Base' -MessageBoxText 'Enter new .base name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$global:ListName = "$boxoutput.base";$ListTarget = "$ListFolder\$boxoutput.base";if (Test-Path -Path $ListTarget) {Remove-Item -Path "$ListTarget" -Force}
PickEnvironment
$Label1_PageLBWiz.Text = "🧾 Create Source Base"
$Label2_PageLBWiz.Text = "Select a source"
}}

if ($ListViewChoiceS3 -eq "🧾 Convert Group Base") {$is_group = $null
$LBWiz_TypeZ = Get-Content -Path "$ListFolder\$ListViewChoiceS4" -TotalCount 1
$LBWiz_TypeY, $partbxyz = $LBWiz_TypeZ -split '[ ]';

if ($LBWiz_TypeY -ne 'MENU-SCRIPT') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'Header is not MENU-SCRIPT, check file.';$global:marked = $ListViewSelectS3;LBWiz_Stage3MISC;return}
Get-Content "$ListFolder\$ListViewChoiceS4" -Encoding UTF8 | ForEach-Object {$partXa, $partXb, $partXc = $_ -split "[❕]";if ($partXb -eq 'GROUP') {$is_group = 1}}
if ($is_group -eq $null) {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText "List does not contain any groups.";$global:marked = $ListViewSelectS3;LBWiz_Stage3MISC;return}
if ($is_group -eq 1) {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Group Base' -MessageBoxText 'Enter new .base name' -Check 'PATH'
$ListName = "$boxoutput.base";$ListTarget = "$ListFolder\$boxoutput.base";
if (Test-Path -Path $ListTarget) {Remove-Item -Path "$ListTarget" -Force}
Copy-Item -Path "$ListFolder\$ListViewChoiceS4" -Destination "$ListFolder\$boxoutput.base" -Force}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "✒ External Package Item") {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Time of Action' -MessageBoxText 'Select a run time' -MessageBoxChoices "❕DX❕ Default - Immediate execution❗❕SC❕ SetupComplete - Scheduled execution❗❕RO❕ RunOnce - Scheduled execution"
if ($boxoutput -eq "❕DX❕ Default - Immediate execution") {$global:ExecuteTime = "DX"}
if ($boxoutput -eq "❕SC❕ SetupComplete - Scheduled execution") {$global:ExecuteTime = "SC"}
if ($boxoutput -eq "❕RO❕ RunOnce - Scheduled execution") {$global:ExecuteTime = "RO"}
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$Label1_PageLBWiz.Text = "💾 Append Items";$Label2_PageLBWiz.Text = "Select a list"
[void]$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5MISC {
if ($marked -ne $null) {$global:ListViewSelectS5 = $marked} else { $global:ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem}
$parta, $ListViewChoiceS5, $partc = $ListViewSelectS5 -split '[{}]'
if ($ListViewChoiceS3 -eq "🧾 Create Source Base") {ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-CREATE","ARG3=-BASE","ARG4=$ListName")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS5 -eq "🪟 Current Environment") {ForEach ($i in @("ARG5=-LIVE","ARG6=$ListViewBase")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}}
if ($ListViewChoiceS5 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS5","ARG7=$ListViewBase")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
return}
if ($ListViewChoiceS5 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 4;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$ListFolder\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "MENU-SCRIPT" -Encoding UTF8}}}
if ($ListViewChoiceS5 -ne "🧾 Create New List") {$global:LBWiz_Stage = 4;$ListName = "$ListViewChoiceS5";$ListTarget = "$ListFolder\$ListViewChoiceS5"}
Add-Content -Path "$ListTarget" -Value "`❕ExtPackage`❕$ListViewChoiceS4`❕Install`❕$ExecuteTime`❕" -Encoding UTF8
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage3GRP {$global:LBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLBWiz.FocusedItem}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.CheckBoxes = $true;$Label1_PageLBWiz.Text = "🧾 $BaseFile";
$Label2_PageLBWiz.Text = "Loading $ListViewChoiceS3..."
$global:SubGroupLast = "";$ReadGroup = "";Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[❕]"
if ($partXb -eq 'GROUP') {if ($partXc -eq $ListViewChoiceS3) {$ReadGroup = 1} else {$ReadGroup = ""}}
if ($ReadGroup) {
if ($partXb) {$GrpViewChk1, $GrpViewChk2 = $partXb -split "[ⓡ]";if (-not ("$GrpViewChk1$GrpViewChk2" -eq "$partXb")) {if ($REFERENCE -ne 'DISABLED') {Group-View}}}
if ($partXb -eq 'GROUP') {
if ($partXc -eq $ListViewChoiceS3) {
if ($SubGroupLast) {$SubGroupLastOG = $SubGroupLast
$stringX1 = $SubGroupLast.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$stringX3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$item1 = New-Object System.Windows.Forms.ListViewItem("$stringX3")
$item1.SubItems.Add("$SubGroupLastOG")
[void]$ListView1_PageLBWiz.Items.Add($item1)
}
$global:GroupLast = $partXc;$global:SubGroupLast = $partXd}
$global:Array1 = "";$global:Routine1 = "";$global:Condit1 = ""}
}}
if ($SubGroupLast) {$SubGroupLastOG = $SubGroupLast
$stringX1 = $SubGroupLast.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$stringX3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$item1 = New-Object System.Windows.Forms.ListViewItem("$stringX3")
$item1.SubItems.Add("$SubGroupLastOG")
[void]$ListView1_PageLBWiz.Items.Add($item1)}
$global:Condit1 = "";$global:Array1 = "";$global:Routine1 = ""
$Label2_PageLBWiz.Text = "$ListViewChoiceS3";
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4GRP {$global:LBWiz_Stage = 4;
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}
if ($ListMode -eq 'Execute') {Add-Content -Path "$ListFolder\`$LIST" -Value "MENU-SCRIPT" -Encoding UTF8}
ForEach ($checkedItem in $ListView1_PageLBWiz.CheckedItems) {$ListWrite = 0
$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250
if ($partXb) {$GrpViewChk1, $GrpViewChk2 = $partXb -split "[ⓡ]";if (-not ("$GrpViewChk1$GrpViewChk2" -eq "$partXb")) {if ($REFERENCE -ne 'DISABLED') {Group-View}}}
$ListViewChecked = $checkedItem.SubItems[1].Text;$ListViewCheckedExpand = $checkedItem.SubItems[0].Text
Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[❕]";if ($partXb) {$partXb = $partXb.Replace("ⓠ", "")}

if ($partXb -eq 'GROUP') {if ($partXc -ne $ListViewChoiceS3) {$ListWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXd -ne $ListViewChecked) {$ListWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXc -eq $ListViewChoiceS3) {if ($partXd -eq $ListViewChecked) {$ListWrite = 1}}}
if ($partXb -eq 'GROUP') {if ($partXe -eq "SCOPED") {if ($partXc -eq $ListViewChoiceS3) {if ($partXd -eq $ListViewChecked) {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle "$ListViewCheckedX" -MessageBoxText "$partXf" -MessageBoxChoices "$partXg"
Add-Content -Path "$ListFolder\`$LIST" -Value "`❕$partXb`❕$partXc`❕$partXd`❕$partXe`❕$partXf`❕$partXg`❕$boxindex`❕" -Encoding UTF8
$ListWrite = 0;MessageBoxListView;return}}}}
if ($ListWrite -eq '1') {$ListPrompt = $null;
ForEach ($i in @("PROMPT0","PROMPT1","PROMPT2","PROMPT3","PROMPT4","PROMPT5","PROMPT6","PROMPT7","PROMPT8","PROMPT9")) {if ($i -eq "$partXb") {$ListPrompt = 1;$Label1_PageLBWiz.Text = "$ListViewChoiceS3";$Label2_PageLBWiz.Text = "$ListViewCheckedExpand";$partw1, $partx1 = $partXd -split "❗";$party1, $partz1 = $partx1 -split "-";MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxText "$partXc" -Check "$partw1" -TextMin "$party1" -TextMax "$partz1";$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250;Add-Content -Path "$ListFolder\`$LIST" -Value "`❕ⓠ$partXb`❕$partXc`❕$partXd`❕$boxoutput`❕" -Encoding UTF8}}
ForEach ($i in @("CHOICE0","CHOICE1","CHOICE2","CHOICE3","CHOICE4","CHOICE5","CHOICE6","CHOICE7","CHOICE8","CHOICE9")) {if ($i -eq "$partXb") {$ListPrompt = 2;$Label1_PageLBWiz.Text = "$ListViewChoiceS3";$Label2_PageLBWiz.Text = "$ListViewCheckedExpand";MessageBox -MessageBoxType 'Choice' -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxText "$partXc" -MessageBoxChoices "$partXd";$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250;Add-Content -Path "$ListFolder\`$LIST" -Value "`❕ⓠ$partXb`❕$partXc`❕$partXd`❕$boxindex`❕" -Encoding UTF8}}
ForEach ($i in @("PICKER0","PICKER1","PICKER2","PICKER3","PICKER4","PICKER5","PICKER6","PICKER7","PICKER8","PICKER9")) {if ($i -eq "$partXb") {$ListPrompt = 3;$Label1_PageLBWiz.Text = "$ListViewChoiceS3";$Label2_PageLBWiz.Text = "$ListViewCheckedExpand";MessageBox -MessageBoxType 'Picker' -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxText "$partXc" -MessageBoxChoices "$partXd";$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250;Add-Content -Path "$ListFolder\`$LIST" -Value "`❕ⓠ$partXb`❕$partXc`❕$partXd`❕$boxoutput`❕" -Encoding UTF8}}
if ($ListPrompt -eq $null) {Add-Content -Path "$ListFolder\`$LIST" -Value "$_" -Encoding UTF8}
}}}

if ($ListMode -eq 'Builder') {
$Label1_PageLBWiz.Text = "💾 Append Items"
$Label2_PageLBWiz.Text = "Select a list"
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();[void]$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($ListMode -eq 'Execute') {if ($REFERENCE -ne 'LIVE') {if ($REFERENCE -ne "Disabled") {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Unmounting Reference Image...";VDISK_DETACH}}
$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront()}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5GRP {
if ($REFERENCE -ne 'LIVE') {if ($REFERENCE -ne "Disabled") {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Unmounting Reference Image...";VDISK_DETACH}}
$Label1_PageLBWiz.Text = "💾 Append Items";$Label2_PageLBWiz.Text = "Select a list"
$ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem
$parta, $partb, $partc = $ListViewSelectS5 -split '[{}]'
if ($partb -eq "🧾 Create New List") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";}
if ($boxresult -eq "OK") {
$ListName = "$boxoutput.list";$ListTarget = "$ListFolder\$boxoutput.list";
if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "MENU-SCRIPT" -Encoding UTF8}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
if ($partb -ne "🧾 Create New List") {$ListName = "$partb";$ListTarget = "$ListFolder\$partb"}
Get-Content "$ListFolder\`$LIST" -Encoding UTF8 | ForEach-Object {
$partxxx, $partyyy, $partzzz = $_ -split '[❕]';if ($partyyy -eq "GROUP") {Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8}
if ($_ -ne "") {Add-Content -Path "$ListTarget" -Value "$_" -Encoding UTF8}}
#Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}

if ($ListName -ne "$null") {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName"
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickEnvironment {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();
[void]$ListView1_PageLBWiz.Items.Add("🪟 Current Environment")
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function AddElement {
if ($Page -eq 'PageW2V') {$PageW2V.Controls.Add($element)}
if ($Page -eq 'PageV2W') {$PageV2W.Controls.Add($element)}
if ($Page -eq 'PageLB') {$PageLB.Controls.Add($element)}
if ($Page -eq 'PagePB') {$PagePB.Controls.Add($element)}
if ($Page -eq 'PageBC') {$PageBC.Controls.Add($element)}
if ($Page -eq 'PageSC') {$PageSC.Controls.Add($element)}
if ($Page -eq 'PageSP') {$PageSP.Controls.Add($element)}
if ($Page -eq 'PageConsole') {$PageConsole.Controls.Add($element)}
if ($Page -eq 'PageDebug') {$PageDebug.Controls.Add($element)}
if ($Page -eq 'PagePBWiz') {$PagePBWiz.Controls.Add($element)}
if ($Page -eq 'PagePEWiz') {$PagePEWiz.Controls.Add($element)}
if ($Page -eq 'PageLBWiz') {$PageLBWiz.Controls.Add($element)}
if ($Page -eq 'PageLEWiz') {$PageLEWiz.Controls.Add($element)}
if ($Page -eq 'PageMain') {$PageMain.Controls.Add($element)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LoadSettings {
$LoadINI = Get-Content -Path "$PSScriptRootX\gploy.ini" | Select-Object -Skip 1
$Settings = $LoadINI | ConvertFrom-StringData
$global:REFERENCE = $Settings.REFERENCE
if ($REFERENCE -eq "DISABLED") {$global:REFERENCE = "Disabled"}
$global:GUI_SCALE = $Settings.GUI_SCALE
$global:GUI_RESUME = $Settings.GUI_RESUME
$global:GUI_CONFONT = $Settings.GUI_CONFONT
$global:GUI_CONTYPE = $Settings.GUI_CONTYPE
$global:GUI_FONTSIZE = $Settings.GUI_FONTSIZE
$global:GUI_CONFONTSIZE = $Settings.GUI_CONFONTSIZE
$global:GUI_LVFONTSIZE = $Settings.GUI_LVFONTSIZE
$global:GUI_HLT_COLOR = $Settings.GUI_HLT_COLOR
$global:GUI_BTN_COLOR = $Settings.GUI_BTN_COLOR
$global:GUI_BG_COLOR = $Settings.GUI_BG_COLOR
$global:GUI_PAG_COLOR = $Settings.GUI_PAG_COLOR
$global:GUI_TXT_FORE = $Settings.GUI_TXT_FORE
$global:GUI_TXT_BACK = $Settings.GUI_TXT_BACK
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Launch-CMD {
param([int]$X,[int]$Y,[int]$H,[int]$W)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$PageMain.Visible = $false;$PageBlank.Visible = $true;$PageBlank.BringToFront()
if (Test-Path -Path "$PSScriptRootX\`$CON") {Remove-Item -Path "$PSScriptRootX\`$CON" -Force -Recurse}
if (Test-Path -Path "$PSScriptRootX\`$PKX") {Remove-Item -Path "$PSScriptRootX\`$PKX" -Force -Recurse}
if (Test-Path -Path "$PSScriptRootX\`$CAB") {Remove-Item -Path "$PSScriptRootX\`$CAB" -Force -Recurse}
if (Test-Path -Path "$PSScriptRootX\`$DISK") {Remove-Item -Path "$PSScriptRootX\`$DISK" -Force -Recurse}
Add-Content -Path "$PSScriptRootX\`$CON" -Value "$PSScriptRootX" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$CON" -Value "GUI_CONFONT=$($DropBox1_PageSC.SelectedItem)" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$CON" -Value "GUI_CONFONTSIZE=$($DropBox2_PageSC.SelectedItem)" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$CON" -Value "GUI_SCALE=$GUI_SCALE" -Encoding UTF8
if ($ButtonRadio1_Group1.Checked -eq $true) {$GUI_CONTYPE = 'Embed'} else {$GUI_CONTYPE = 'Spawn'}
$CMDWindow = Start-Process "PowerShell" -PassThru -ArgumentList "-noprofile", "-WindowStyle", "Hidden", "-Command", {
Add-Type -TypeDefinition @'
using System;using System.Runtime.InteropServices;public class WinMekanix {
    private const int STD_OUTPUT_HANDLE = -11;
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)] public struct CONSOLE_FONT_INFO_EX
    {public uint cbSize;public uint nFont;public COORD dwFontSize;public int FontFamily;public int FontWeight;[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]public string FaceName;}
    [StructLayout(LayoutKind.Sequential)] public struct COORD
    {public short X;public short Y;}
    [DllImport(\"kernel32.dll\", SetLastError = true)] public static extern IntPtr GetStdHandle(int nStdHandle);
    [DllImport(\"kernel32.dll\", SetLastError = true)] public static extern bool SetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
    [DllImport(\"kernel32.dll\", SetLastError = true)] public static extern bool GetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
    public static bool SetConsoleFont(string fontName, short fontSize)
    {IntPtr consoleOutputHandle = GetStdHandle(STD_OUTPUT_HANDLE);
        if (consoleOutputHandle == IntPtr.Zero)
        {return false;}
        CONSOLE_FONT_INFO_EX fontInfo = new CONSOLE_FONT_INFO_EX();
        fontInfo.cbSize = (uint)Marshal.SizeOf(fontInfo);GetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);fontInfo.dwFontSize.X = 0;fontInfo.dwFontSize.Y = fontSize;fontInfo.FaceName = fontName;return SetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);} }
'@
Add-Type -AssemblyName System.Windows.Forms
[VOID][System.Text.Encoding]::Unicode;CLS
[VOID][WinMekanix]::SetConsoleFont('Consolas', 1)
$PSScriptRootX = "$($PWD.Path)";#$PSScriptRootX = Get-Content -Path \"$env:temp\`$CON\" -TotalCount 1
$LoadINI = Get-Content -Path \"$PSScriptRootX\`$CON\" | Select-Object -Skip 1
$Settings = $LoadINI | ConvertFrom-StringData
$GUI_SCALE = $Settings.GUI_SCALE
$GUI_CONFONT = $Settings.GUI_CONFONT
$GUI_CONFONTSIZE = $Settings.GUI_CONFONTSIZE
$DimensionX = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$DimensionY = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$GetCurDpi = [System.Drawing.Graphics]::FromHwnd(0)
$DpiX = $GetCurDpi.DpiX;$DpiCur = $DpiX / 96
$RefX = 1000;$DimScaleX = $DimensionX / $RefX
$RefY = 1000;$DimScaleY = $DimensionY / $RefY
if ($DimScaleX -ge $DimScaleY) {$ScaleRef = $DimScaleY}
if ($DimScaleY -ge $DimScaleX) {$ScaleRef = $DimScaleX}
if ($GUI_SCALE) {$null} else {$GUI_SCALE = 1.00}
if ($GUI_CONFONT) {$null} else {$GUI_CONFONT = 'Consolas'}
if ($GUI_CONFONTSIZE) {$null} else {$GUI_CONFONTSIZE = 'Auto'}
if ($GUI_CONFONTSIZE -eq 'Auto') {$CFSIZE0 = 28} else {$CFSIZE0 = $GUI_CONFONTSIZE}
#$ScaleFont = $CFSIZE0 * $ScaleRef * $GUI_SCALE
$ScaleFont = $GUI_SCALE / $DpiCur * $CFSIZE0 * $ScaleRef
$ScaleFontX = [Math]::Floor($ScaleFont);$CFSIZEX = $ScaleFontX
[VOID][WinMekanix]::SetConsoleFont("$GUI_CONFONT", "$CFSIZEX")
CLS;Write-Host "Console Virtual Dimensions: $DimensionX x $DimensionY"
Start-Process \"$env:comspec\" -Wait -NoNewWindow -ArgumentList "/c", \"$PSScriptRootX\gploy.cmd\", "-EXTERNAL"
$PathCheck = \"$PSScriptRootX\\`$CON\";if (Test-Path -Path $PathCheck) {Remove-Item -Path \"$PSScriptRootX\`$CON\" -Force}
if ($PAUSE_END -eq '1') {pause}}
$CMDHandle = $CMDWindow.MainWindowHandle;#$CMDHandleX = $CMDWindow.Handle;
do {$CMDHandle = $CMDWindow.MainWindowHandle;Start-Sleep -Milliseconds 100} until ($CMDHandle -ne 0)
$global:CMDProcessId = $CMDWindow.Id;$PanelHandle = $PageConsole.Handle
$getproc = Get-ChildProcesses $CMDProcessId | Select ProcessId, Name, ParentProcessId
$part1, $part2, $part3 = $getproc -split ";";$part4 = $part1 -split ";";$global:SubProcessId = $part4 -Split "@{ProcessId="
Write-Host "Starting console PID: $CMDProcessId conhost PID:$SubProcessId"
if ($GUI_CONTYPE -eq 'Embed') {[VOID][WinMekanix.Functions]::SetParent($CMDHandle, $PanelHandle)}
do {Start-Sleep -Milliseconds 100} until (-not (Test-Path -Path "$PSScriptRootX\`$CON"))
if ($GUI_CONTYPE -eq 'Embed') {[VOID][WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 1);[VOID][WinMekanix.Functions]::MoveWindow($CMDHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)}
$PageBlank.Visible = $false;$PageConsole.Visible = $true;$PageConsole.BringToFront()
[VOID][WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 3)}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
[string]$SplashLogo=@"
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
"@
function SplashScreen {
$SplashForm = New-Object System.Windows.Forms.Form
$SplashForm.Size = New-Object System.Drawing.Size($SplashSize, $SplashSize)
$SplashForm.StartPosition = "CenterScreen"
$SplashForm.ShowInTaskbar = $false
$SplashForm.ControlBox = $false
$PictureBoxSplash = New-Object System.Windows.Forms.PictureBox
$PictureBoxSplash.Dock = "Fill"
$PictureBoxSplash.SizeMode = 'StretchImage'
$PictureBoxSplash.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($SplashLogo))
$SplashForm.Controls.Add($PictureBoxSplash)
$PictureBoxSplash.Visible = $true;$PictureBoxSplash.BringToFront()
$SplashForm.Show()
Start-Sleep -Milliseconds 350
return $SplashForm
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$PSHandle = [WinMekanix.Functions]::GetConsoleWindow()
[VOID][WinMekanix.Functions]::SetForegroundWindow($PSHandle)
[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 0)
[VOID][System.Text.Encoding]::Unicode;LoadSettings
[VOID][WinMekanix.Functions]::SetProcessDPIAware()
[VOID][System.Windows.Forms.Application]::EnableVisualStyles()
[VOID][System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)
$sysltr, $nullx = $env:SystemDrive -split '[:]';$progltr, $nullx = $PSScriptRootX -split '[:]'
$STDOutputHandle = [WinMekanix.Functions]::GetStdHandle([WinMekanix.Functions]::STD_OUTPUT_HANDLE)
$getproc = Get-ChildProcesses $PID | Select ProcessId, Name, ParentProcessId
$part1, $part2, $part3 = $getproc -split ";";$part4 = $part1 -split ";";
$ConhostPID = $part4 -Split "@{ProcessId=";Write-Host "Main thread PID: $PID conhost PID:$ConhostPID"
$RawUIMAX = $host.UI.RawUI.MaxWindowSize
$DimensionX = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$DimensionY = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$DimensionVX = [System.Windows.Forms.SystemInformation]::VirtualScreen.Width
$DimensionVY = [System.Windows.Forms.SystemInformation]::VirtualScreen.Height
$GetCurDpi = [System.Drawing.Graphics]::FromHwnd(0)
$DpiX = $GetCurDpi.DpiX;$DpiCur = $DpiX / 96
$RefX = 1000;$DimScaleX = $DimensionX / $RefX
$RefY = 1000;$DimScaleY = $DimensionY / $RefY
if ($DimScaleX -ge $DimScaleY) {$ScaleRef = $DimScaleY;$SplashSize = $DimScaleY}
if ($DimScaleY -ge $DimScaleX) {$ScaleRef = $DimScaleX;$SplashSize = $DimScaleY}
$SplashSize = [int]($ScaleRef / 2 * 1000);$SplashSize = [Math]::Floor($SplashSize);
$SplashScreen = SplashScreen
if ($GUI_SCALE) {$null} else {$global:GUI_SCALE = 1.00}
if ($GUI_CONFONT) {$null} else {$global:GUI_CONFONT = 'Consolas'}
if ($GUI_FONTSIZE) {$null} else {$global:GUI_FONTSIZE = 'Auto'}
if ($GUI_LVFONTSIZE) {$null} else {$global:GUI_LVFONTSIZE = 'Auto'}
if ($GUI_CONFONTSIZE) {$null} else {$global:GUI_CONFONTSIZE = 'Auto'}
if ($GUI_CONFONTSIZE -eq 'Auto') {$global:CFSIZE0 = 28} else {$global:CFSIZE0 = $GUI_CONFONTSIZE}
#$ScaleFont = $CFSIZE0 * $ScaleRef * $GUI_SCALE
$ScaleFont = $GUI_SCALE / $DpiCur * $CFSIZE0 * $ScaleRef
$ScaleFontX = [Math]::Floor($ScaleFont);$global:CFSIZEX = $ScaleFontX
[VOID][WinMekanix]::SetConsoleFont("$GUI_CONFONT", "$CFSIZEX")
if ($GUI_BG_COLOR.Length -ne 8) {$GUI_BG_COLOR = 'FF252525'}
if ($GUI_BTN_COLOR.Length -ne 8) {$GUI_BTN_COLOR = 'FF404040'}
if ($GUI_HLT_COLOR.Length -ne 8) {$GUI_HLT_COLOR = 'FF777777'}
if ($GUI_TXT_FORE.Length -ne 8) {$GUI_TXT_FORE = 'FFFFFFFF'}
if ($GUI_PAG_COLOR.Length -ne 8) {$GUI_PAG_COLOR = 'FF151515'}
if ($GUI_TXT_BACK.Length -ne 8) {$GUI_TXT_BACK = 'FF151515'}
$Splash = [Int32]"0x$GUI_TXT_BACK";if ($Splash -ge '-10000000') {$BGIMG = 'Light'} else {$BGIMG = 'Dark'}
ForEach ($i in @("$PSScriptRootX\`$PKX","$PSScriptRootX\`$CAB","$ListFolder\`$LIST","$PSScriptRootX\`$LIST","$PSScriptRootX\`$DISK")) {if (Test-Path -Path "$i") {Remove-Item -Path "$i" -Recurse -Force}}
if (Test-Path -Path "$PSScriptRootX\`$CON") {Remove-Item -Path "$PSScriptRootX\`$CON" -Force}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$form = New-Object Windows.Forms.Form
$form.SuspendLayout()
$version = Get-Content -Path "gploy.cmd" -TotalCount 1;
$part1, $part2 = $version -split " v ";$part3, $part4 = $part2 -split " ";
$form.Text = "gploy v$part3"
$WSIZ = [int]($RefX * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($RefY * $ScaleRef * $GUI_SCALE)
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$form.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$form.ClientSize = New-Object System.Drawing.Size($WSIZ,$HSIZ)
$form.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_PAG_COLOR")
$form.StartPosition = 'CenterScreen'
$form.MaximizeBox = $false
$form.MinimizeBox = $true
$form.add_FormClosing({$action = $_
if ($NoExitPrompt) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_RESUME=$GUI_RESUME" -Encoding UTF8}
if (-not ($NoExitPrompt)) {MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Close' -MessageBoxText 'Are you sure you want to close?'
if ($boxresult -ne "OK") {$action.Cancel = $true}
if ($boxresult -eq "OK") {Stop-Process -Id $SubProcessId -Force -ErrorAction SilentlyContinue;Stop-Process -Id $CMDProcessId -Force -ErrorAction SilentlyContinue
Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "GUI_RESUME=$GUI_RESUME" -Encoding UTF8}}})
$form.FormBorderStyle = 'FixedDialog';#FixedDialog, FixedSingle, Fixed3D
$form.AutoSize = $true
$form.AutoSizeMode = 'GrowAndShrink';#AutoSizeMode: GrowAndShrink, GrowOnly, and ShrinkOnly.
$form.AutoScale = $true
$form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
$form.WindowState = 'Normal'
;#$form.IsMdiContainer = $true
$PageMain = NewPanel -X '0' -Y '0' -W '1000' -H '666' -C 'Yes'
$PageDebug = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageDebug);$PageDebug.Visible = $false;[VOID][WinMekanix.Functions]::SetParent($PSHandle, $PageDebug.Handle)
$PageSP = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageSP);$PageSP.Visible = $false
$PageW2V = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageW2V);$PageW2V.Visible = $false
$PageV2W = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageV2W);$PageV2W.Visible = $false
$PageLB = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageLB);$PageLB.Visible = $false
$PageLBWiz = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageLBWiz);$PageLBWiz.Visible = $false;
$PageLEWiz = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageLEWiz);$PageLEWiz.Visible = $false;
$PagePB = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PagePB);$PagePB.Visible = $false
$PagePBWiz = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PagePBWiz);$PagePBWiz.Visible = $false;
$PagePEWiz = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PagePEWiz);$PagePEWiz.Visible = $false;
$PageBC = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageBC);$PageBC.Visible = $false
$PageSC = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageSC);$PageSC.Visible = $false
$PageBlank = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageBlank);$PageBlank.Visible = $false
$PageConsole = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageConsole);$PageConsole.Visible = $false;
$WSIZ = [int](1000 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](666 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$Button_W2V = NewPageButton -X '10' -Y '70' -W '230' -H '70' -C '0' -Text 'Image Processing';$Button_W2V.Visible = $false
$Button_V2W = NewPageButton -X '10' -Y '70' -W '230' -H '70' -C '0' -Text 'Image Processing'
$Button_LB = NewPageButton -X '10' -Y '225' -W '230' -H '70' -C '0' -Text 'Image Management';$Button_LB.Visible = $false
$Button_PB = NewPageButton -X '10' -Y '225' -W '230' -H '70' -C '0' -Text 'Image Management'
$Button_BC = NewPageButton -X '10' -Y '380' -W '230' -H '70' -C '0' -Text 'BootDisk Creator'
$Button_SC = NewPageButton -X '10' -Y '535' -W '230' -H '70' -C '0' -Text 'Settings'
#$form.ControlBox = $False
#$form.UseLayoutRounding = $true
#$form.AutoScaleMode = 'DPI';#DPI, Font, and None.
#$form.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$form.AutoScaleDimensions =  New-Object System.Drawing.SizeF(96, 96)
#$form.AutoScaleMode = System.Windows.Forms.AutoScaleMode.DPI
#$form.Add_Resize({[WinMekanix.Functions]::MoveWindow($PanelHandle, 0, 0, $Panel.Width, $Panel.Height, $true) | Out-Null})
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageSP';$Label0_PageSP = NewLabel -X '1000' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text '';$Label0_PageSPX = [int](750 * $ScaleRef * $GUI_SCALE);$Label0_PageSPY = [int](5 * $ScaleRef * $GUI_SCALE);SplashChange
$scrolltimer = New-Object System.Windows.Forms.Timer;$scrolltimer.Interval = 25;$scrolltimer.Enabled = $false
$scrolltimer.Add_Tick({$Label0_PageSP.Left -= 2;if ($Label0_PageSP.Location.X -le $Label0_PageSPL) {$Label0_PageSP.Location = New-Object System.Drawing.Point($Label0_PageSPX, $Label0_PageSPY);
SplashChange}})

$Button2_PageSP = NewButton -X '225' -Y '585' -W '300' -H '60' -Text 'About' -Hover_Text 'About' -Add_Click {MessageBoxAbout}
#$ButtonTest_PageSP = NewButton -X '50' -Y '585' -W '150' -H '60' -Text 'TEST' -Hover_Text 'About' -Add_Click {$null}
#$ButtonReload_PageSP = NewButton -X '550' -Y '585' -W '150' -H '60' -Text 'RELOAD' -Hover_Text '' -Add_Click {Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\gploy.cmd";$NoExitPrompt = 1;$form.Close()}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageW2V';$Label0_PageW2V = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🔄 Image Processing|WIM" -TextAlign 'X'
$ListView1_PageW2V = NewListView -X '25' -Y '90' -W '700' -H '300';$WSIZ = [int](690 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageW2V.Columns.Add("X", $WSIZ)
$Button1_PageW2V = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🏁 Convert' -Hover_Text 'Start Image Conversion' -Add_Click {$halt = $null
if ($($DropBox1_PageW2V.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No wim selected.'}
if ($halt -ne '1') {
ForEach ($i in @("","ARG1=-IMAGEPROC","ARG2=-WIM","ARG3=$($DropBox1_PageW2V.SelectedItem)","ARG4=-INDEX","ARG5=$($DropBox2_PageW2V.SelectedItem)","ARG6=-VHDX","ARG7=$($TextBox1_PageW2V.Text)","ARG8=-SIZE","ARG9=$($TextBox2_PageW2V.Text)")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

$Label1_PageW2V = NewLabel -X '100' -Y '410' -W '175' -H '30' -Text 'Source Image'
$DropBox1_PageW2V = NewDropBox -X '25' -Y '445' -W '300' -H '40' -C '0' -DisplayMember 'Name' -Text 'Page 1'
$Label2_PageW2V = NewLabel -X '500' -Y '410' -W '175' -H '30' -Text 'Source Index'
$DropBox2_PageW2V = NewDropBox -X '425' -Y '445' -W '300' -H '40' -C '0' -DisplayMember 'Description'
$Label3_PageW2V = NewLabel -X '100' -Y '490' -W '175' -H '30' -Text 'Target Image'
$TextBox1_PageW2V = NewTextBox -X '25' -Y '525' -W '300' -H '40' -Check 'PATH'
$Label4_PageW2V = NewLabel -X '485' -Y '490' -W '205' -H '30' -Text 'VHDX Size (GB)'
$TextBox2_PageW2V = NewTextBox -X '425' -Y '525' -W '300' -H '40' -Check 'NUMBER'
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageV2W';$Label0_PageV2W = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🔄 Image Processing|VHD" -TextAlign 'X'
$ListView1_PageV2W = NewListView -X '25' -Y '90' -W '700' -H '300';$WSIZ = [int](690 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageV2W.Columns.Add("X", $WSIZ)
$Button1_PageV2W = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🏁 Convert' -Hover_Text 'Start Image Conversion' -Add_Click {$halt = $null
if ($($DropBox1_PageV2W.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No vhdx selected.'}
if ($halt -ne '1') {ForEach ($i in @("","ARG1=-IMAGEPROC","ARG2=-VHDX","ARG3=$($DropBox1_PageV2W.SelectedItem)","ARG4=-INDEX","ARG5=$($DropBox2_PageV2W.SelectedItem)","ARG6=-WIM","ARG7=$($TextBox1_PageV2W.Text)","ARG8=-XLVL","ARG9=$($DropBox3_PageV2W.SelectedItem)")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

$Label1_PageV2W = NewLabel -X '100' -Y '410' -W '175' -H '30' -Text 'Source Image'
$DropBox1_PageV2W = NewDropBox -X '25' -Y '445' -W '300' -H '40' -C '0' -DisplayMember 'Name'
$Label2_PageV2W = NewLabel -X '500' -Y '410' -W '175' -H '30' -Text 'Source Index'
$DropBox2_PageV2W = NewDropBox -X '425' -Y '445' -W '300' -H '40' -DisplayMember 'Description'
$Label3_PageV2W = NewLabel -X '100' -Y '490' -W '175' -H '30' -Text 'Target Image'
$TextBox1_PageV2W = NewTextBox -X '25' -Y '525' -W '300' -H '40' -Check 'PATH'
$Label4_PageV2W = NewLabel -X '485' -Y '490' -W '205' -H '30' -Text '   Compression'
$DropBox3_PageV2W = NewDropBox -X '425' -Y '525' -W '300' -H '40' -C '0' -DisplayMember 'Description'
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageLB';$Label0_PageLB = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🧾 Image Management" -TextAlign 'X'
$Label1_PageLB = NewLabel -X '85' -Y '535' -W '175' -H '30' -Text 'Reference'
$DropBox1_PageLB = NewDropBox -X '215' -Y '530' -W '325' -H '40' -C '0' -DisplayMember 'Name'
$ListView1_PageLB = NewListView -X '390' -Y '90' -W '335' -H '420';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageLB.Columns.Add("X", $WSIZ)
$ListView2_PageLB = NewListView -X '25' -Y '90' -W '335' -H '420';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView2_PageLB.Columns.Add("X", $WSIZ)
$Button1_PageLB = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🏁 List Execute' -Hover_Text 'List Execute' -Add_Click {LEWiz_Stage1}
$Button2_PageLB = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🏗 List Builder' -Hover_Text 'List Builder' -Add_Click {LBWiz_Stage1}

$Button3_PageLB = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '✏ Edit List' -Hover_Text 'Edit List' -Add_Click {
$FilePath = "$ListFolder"
$FileFilt = "List files (*.base;*.list)|*.base;*.list";PickFile
if ($Pick) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$Pick"}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PagePB';$Label0_PagePB = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🗳 Image Management" -TextAlign 'X'
$ListView1_PagePB = NewListView -X '25' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PagePB.Columns.Add("X", $WSIZ)
$ListView2_PagePB = NewListView -X '390' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView2_PagePB.Columns.Add("X", $WSIZ)
$Button0_PagePB = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🏁 Pack Execute' -Hover_Text 'Pack Execute' -Add_Click {PEWiz_Stage1}
$Button3_PagePB = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🏗 Pack Builder' -Hover_Text 'Pack Builder' -Add_Click {PBWiz_Stage1}
$Button4_PagePB = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '✏ Edit Pack' -Hover_Text 'Edit Pack' -Add_Click {
if (Test-Path -Path "$PSScriptRootX\project\package.list") {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PSScriptRootX\project\package.list"}
if (Test-Path -Path "$PSScriptRootX\project\package.cmd") {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PSScriptRootX\project\package.cmd"}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageBC';$Label0_PageBC = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "💾 BootDisk Creator" -TextAlign 'X'

$ListView1_PageBC = NewListView -X '25' -Y '90' -W '700' -H '300';$WSIZ = [int](690 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageBC.Columns.Add("X", $WSIZ)
$Button1_PageBC = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🏁 Create' -Hover_Text 'Start BootDisk Creation' -Add_Click {$halt = $null;$nullx, $disknum, $nully = $($DropBox3_PageBC.SelectedItem) -split '[| ]'
if (-not (Test-Path -Path "$CacheFolder\boot.sav")) {
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Import Boot Media' -MessageBoxText 'Boot media needs to be imported from a windows .iso before proceeding.';if ($boxresult -eq "OK") {ImportBoot}}
if (-not (Test-Path -Path "$CacheFolder\boot.sav")) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No boot media.'}
if ($($DropBox1_PageBC.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No vhdx selected.'}
if ($disknum -eq 'Disk') {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No disk selected.'}
if ($disknum -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No disk selected.'}
if ($halt -ne '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Erase' -MessageBoxText "This will erase Disk $disknum. If you've inserted or removed any disks, refresh before proceeding. Are you sure?"
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {ForEach ($i in @("","ARG1=-BOOTMAKER","ARG2=-CREATE","ARG3=-DISK","ARG4=$disknum","ARG5=-VHDX","ARG6=$($DropBox1_PageBC.SelectedItem)","PE_WALLPAPER=$($DropBox2_PageBC.SelectedItem)")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}}

$Label1_PageBC = NewLabel -X '100' -Y '410' -W '175' -H '30' -Text 'Active VHDX'
$DropBox1_PageBC = NewDropBox -X '25' -Y '445' -W '300' -H '40' -C '0' -DisplayMember 'Name'
$Label2_PageBC = NewLabel -X '500' -Y '410' -W '210' -H '30' -Text 'PE Wallpaper'
$DropBox2_PageBC = NewDropBox -X '425' -Y '445' -W '300' -H '40' -DisplayMember 'Description'
$Label3_PageBC = NewLabel -X '315' -Y '490' -W '175' -H '30' -Text 'Target Disk'
$DropBox3_PageBC = NewDropBox -X '25' -Y '525' -W '700' -H '40' -Text 'Select Disk'
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageSC';$Label0_PageSC = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🛠 Settings" -TextAlign 'X'
$GUI_SLIDE = [int](100 * $GUI_SCALE);
$Slider1_PageSC = NewSlider -X '300' -Y '120' -W '225' -H '60' -Value "$GUI_SLIDE"
$LabelX_PageSC = NewLabel -X '290' -Y '85' -W '585' -H '35' -Text "GUI Scale Factor $($Slider1_PageSC.Value)%"

$Button1_PageSC = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🛠 Console Settings' -Hover_Text 'Console Settings' -Add_Click {ForEach ($i in @("","ARG1=-INTERNAL","ARG2=-SETTINGS")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
#$TextPath = "$PSScriptRootX\`$CON";$TextWrite = [System.IO.StreamWriter]::new($TextPath, $false, [System.Text.Encoding]::UTF8);#$TextWrite.WriteLine("x");$TextWrite.Close()
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}

$Button2_PageSC = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🐜 Debug' -Hover_Text 'Debug' -Add_Click {
[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 2);[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 1);#0=Hidden,1=Normal,2=Minimized,3=Maximized
$WSIZ = [int](1000 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](575 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE);$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$PageDebug.Visible = $true;$PageMain.Visible = $false;$PageSC.Visible = $false;$PageDebug.BringToFront()
[VOID][WinMekanix.Functions]::MoveWindow($PSHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)}
$Button3_PageSC = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🔄 Switch to CMD' -Hover_Text 'Switch to CMD' -Add_Click {ForEach ($i in @("","GUI_LAUNCH=DISABLED")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\gploy.cmd";$NoExitPrompt = 1;$form.Close()}

$GroupBoxName = 'Group1';$GroupBox1_PageSC = NewGroupBox -X '20' -Y '85' -W '260' -H '75' -Text 'Console Window'
#if ($Button_SC.Tag -eq 'Enable') 
$Add_CheckedChanged = {if ($ButtonGroup1Changed -eq '1') {if ($ButtonRadio1_Group1.Checked) {
ForEach ($i in @("","GUI_CONTYPE=Embed")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}}}
$global:ButtonGroup1Changed = '1';}
$ButtonRadio1_Group1 = NewRadioButton -X '15' -Y '30' -W '120' -H '35' -Text 'Embed' -GroupName 'Group1'
$Add_CheckedChanged = {if ($ButtonGroup1Changed -eq '1') {if ($ButtonRadio2_Group1.Checked) {
ForEach ($i in @("","GUI_CONTYPE=Spawn")) {Add-Content -Path "$PSScriptRootX\gploy.ini" -Value "$i" -Encoding UTF8}}}
$global:ButtonGroup1Changed = '1';}
$ButtonRadio2_Group1 = NewRadioButton -X '135' -Y '30' -W '120' -H '35' -Text 'Spawn' -GroupName 'Group1'
if ($GUI_CONTYPE) {$null} else {$GUI_CONTYPE = 'Embed'}
if ($GUI_CONTYPE -eq 'Embed') {$ButtonRadio1_Group1.Checked = $true}
if ($GUI_CONTYPE -eq 'Spawn') {$ButtonRadio2_Group1.Checked = $true}

$Label2_PageSC = NewLabel -X '25' -Y '165' -W '585' -H '35' -Text 'Console Font'
$DropBox1_PageSC = NewDropBox -X '25' -Y '200' -W '190' -H '40' -C '0' -Text "$GUI_CONFONT"
$Label3_PageSC = NewLabel -X '25' -Y '250' -W '585' -H '35' -Text 'Console FontSize'
$DropBox2_PageSC = NewDropBox -X '25' -Y '285' -W '190' -H '40' -C '0' -Text "$GUI_CONFONTSIZE"
$Label4_PageSC = NewLabel -X '25' -Y '420' -W '585' -H '35' -Text 'ListView FontSize'
$DropBox3_PageSC = NewDropBox -X '25' -Y '455' -W '190' -H '40' -C '0' -Text "$GUI_LVFONTSIZE"
$Label5_PageSC = NewLabel -X '25' -Y '335' -W '585' -H '35' -Text 'GUI FontSize'
$DropBox4_PageSC = NewDropBox -X '25' -Y '370' -W '190' -H '40' -C '0' -Text "$GUI_FONTSIZE"
$Label6_PageSC = NewLabel -X '25' -Y '505' -W '585' -H '35' -Text 'GUI Appearance'
$DropBox5_PageSC = NewDropBox -X '25' -Y '540' -W '190' -H '40' -C '0' -Text ""
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageConsole';$Button1_PageConsole = NewButton -X '350' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
$PageMain.Visible = $true;$PictureBoxConsole.SendToBack();$PictureBoxConsole.Visible = $false;$PageConsole.Visible = $false
if ($Button_LB.Tag -eq 'Enable') {Button_PageLB}
if ($Button_PB.Tag -eq 'Enable') {Button_PagePB}
if ($Button_BC.Tag -eq 'Enable') {Button_PageBC}
if ($Button_SC.Tag -eq 'Enable') {Button_PageSC}
if ($Button_V2W.Tag -eq 'Enable') {Button_PageV2W}
if ($Button_W2V.Tag -eq 'Enable') {Button_PageW2V}
Write-Host "Stopping console PID: $CMDProcessId conhost PID:$SubProcessId";Stop-Process -Id $SubProcessId -Force -ErrorAction SilentlyContinue;Stop-Process -Id $CMDProcessId -Force -ErrorAction SilentlyContinue}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageDebug';$Button1_PageDebug = NewButton -X '350' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {$PageMain.Visible = $true;$PageSC.Visible = $true;$PageDebug.Visible = $false}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageLBWiz';$Label1_PageLBWiz = NewLabel -X '0' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "" -TextAlign 'X'

$Label2_PageLBWiz = NewLabel -X '0' -Y '70' -W '1000' -H '50' -TextSize '24' -Text "" -TextAlign 'X'
$Button1_PageLBWiz = NewButton -X '180' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
if ($LBWiz_Stage -eq '1') {$global:LBWiz_Stage = $null;$global:marked = $null;Button_PageLB}
if ($LBWiz_Stage -eq '2') {
if ($LBWiz_Type -eq 'MENU-SCRIPT') {if ($REFERENCE -ne 'LIVE') {if ($REFERENCE -ne "Disabled") {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Unmounting Reference Image...";VDISK_DETACH}}}
if ($ListMode -eq 'Builder') {LBWiz_Stage1}
if ($ListMode -eq 'Execute') {LEWiz_Stage1;$global:LBWiz_Stage = $null;$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront();return}}
if ($LBWiz_Stage -eq '3') {$global:marked = $ListViewSelectS2;LBWiz_Stage2}

if ($LBWiz_Type -eq 'MENU-SCRIPT') {if ($LBWiz_Stage -eq '4') {$global:marked = $ListViewSelectS3;LBWiz_Stage3GRP}
if ($LBWiz_Stage -eq '5') {LBWiz_Stage4GRP}}
if ($LBWiz_Type -eq 'MISC') {if ($LBWiz_Stage -eq '4') {$global:marked = $ListViewSelectS3;LBWiz_Stage3MISC}
if ($LBWiz_Stage -eq '5') {LBWiz_Stage4MISC}}}

$Button2_PageLBWiz = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next ▶' -Hover_Text 'Next' -Add_Click {
if ($LBWiz_Type -eq 'MISC') {
if ($LBWiz_Stage -eq '4') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage5MISC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '3') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage4MISC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '2') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage3MISC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
if ($LBWiz_Type -eq 'MENU-SCRIPT') {
if ($LBWiz_Stage -eq '4') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage5GRP} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '3') {if ($ListView1_PageLBWiz.CheckedItems) {$global:marked = $null;LBWiz_Stage4GRP} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '2') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage3GRP} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
if ($LBWiz_Stage -eq '1') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}

$ListView1_PageLBWiz = NewListView -X '25' -Y '135' -W '950' -H '425';
$WSIZ = [int](940 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageLBWiz.Columns.Add("X", $WSIZ)
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageLEWiz';$Label1_PageLEWiz = NewLabel -X '0' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🧾 List Execute" -TextAlign 'X'
$Label2_PageLEWiz = NewLabel -X '0' -Y '70' -W '1000' -H '50' -TextSize '24' -Text "" -TextAlign 'X'

$Button1_PageLEWiz = NewButton -X '180' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
if ($LEWiz_Stage -eq '1') {$global:LEWiz_Stage = $null;$global:marked = $null;Button_PageLB}
if ($LEWiz_Stage -eq '2') {LEWiz_Stage1}
if ($LEWiz_Stage -eq '3') {$global:marked = $ListViewSelectS2;LEWiz_Stage2}
if ($LEWiz_Stage -eq '4') {$global:marked = $ListViewSelectS3;LEWiz_Stage3}
}
$Button2_PageLEWiz = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next ▶' -Hover_Text 'Next' -Add_Click {
if ($LEWiz_Stage -eq '2') {if ($ListView1_PageLEWiz.SelectedItems) {$global:marked = $null;LEWiz_Stage3} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LEWiz_Stage -eq '1') {if ($ListView1_PageLEWiz.SelectedItems) {$global:marked = $null;LEWiz_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
$ListView1_PageLEWiz = NewListView -X '25' -Y '135' -W '950' -H '425';$WSIZ = [int](940 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageLEWiz.Columns.Add("X", $WSIZ)
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PagePBWiz';$Label1_PagePBWiz = NewLabel -X '0' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text '' -TextAlign 'X'
$Label2_PagePBWiz = NewLabel -X '0' -Y '70' -W '1000' -H '50' -TextSize '24' -Text "" -TextAlign 'X'

$Button1_PagePBWiz = NewButton -X '180' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
if ($PBWiz_Stage -eq '1') {$global:PBWiz_Stage = $null;$global:marked = $null;Button_PagePB}
if ($PBWiz_Stage -eq '2') {PBWiz_Stage1}
if ($PBWiz_Stage -eq '3') {$global:marked = $ListViewSelectS2;PBWiz_Stage2}}
$Button2_PagePBWiz = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next ▶' -Hover_Text 'Next' -Add_Click {
if ($PBWiz_Stage -eq '3') {if ($ListView1_PagePBWiz.SelectedItems) {$global:marked = $null;PBWiz_Stage4} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($PBWiz_Stage -eq '2') {if ($ListView1_PagePBWiz.SelectedItems) {$global:marked = $null;PBWiz_Stage3} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($PBWiz_Stage -eq '1') {if ($ListView1_PagePBWiz.SelectedItems) {$global:marked = $null;PBWiz_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}

$ListView1_PagePBWiz = NewListView -X '25' -Y '135' -W '950' -H '425';# -Headers 'NonClickable';#$WSIZ = [int](470 * $ScaleRef * $GUI_SCALE);#$ListView1_PagePBWiz.Columns.Add("Item Name", $WSIZ);#$ListView1_PagePBWiz.Columns.Add("Description", $WSIZ)
$WSIZ = [int](940 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PagePBWiz.Columns.Add("X", $WSIZ)
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PagePEWiz';$Label1_PagePEWiz = NewLabel -X '0' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🗳 Pack Execute" -TextAlign 'X'
$Label2_PagePEWiz = NewLabel -X '0' -Y '70' -W '1000' -H '50' -TextSize '24' -Text "" -TextAlign 'X'

$Button1_PagePEWiz = NewButton -X '180' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
if ($PEWiz_Stage -eq '1') {$global:PEWiz_Stage = $null;$global:marked = $null;Button_PagePB}
if ($PEWiz_Stage -eq '2') {PEWiz_Stage1}
if ($PEWiz_Stage -eq '3') {$global:marked = $ListViewSelectS2;PEWiz_Stage2}}

$Button2_PagePEWiz = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next ▶' -Hover_Text 'Next' -Add_Click {
if ($PEWiz_Stage -eq '2') {if ($ListView1_PagePEWiz.SelectedItems) {$global:marked = $null;PEWiz_Stage3} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($PEWiz_Stage -eq '1') {if ($ListView1_PagePEWiz.SelectedItems) {$global:marked = $null;PEWiz_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
$ListView1_PagePEWiz = NewListView -X '25' -Y '135' -W '950' -H '425';$WSIZ = [int](940 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PagePEWiz.Columns.Add("X", $WSIZ)
#$FilePath = "C:\gif.gif";$FileContent = Get-Content -Path "$FilePath" -Encoding Byte;$Base64Out = [System.Convert]::ToBase64String($FileContent);Write-Host "$Base64Out"#Convert
#77u/RVhFQy1MSVNU
#$NewBlankList = [Convert]::FromBase64String($EmptyNoneList);[System.IO.File]::WriteAllBytes($ListTar, $NewBlankList)
[string]$EmptyList=@"
77u/
"@
[string]$logobar=@"
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
"@
[string]$splashjpg1=@"
/9j/4gIoSUNDX1BST0ZJTEUAAQEAAAIYAAAAAAQwAABtbnRyUkdCIFhZWiAAAAAAAAAAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAAHRyWFlaAAABZAAAABRnWFlaAAABeAAAABRiWFlaAAABjAAAABRyVFJDAAABoAAAAChnVFJDAAABoAAAAChiVFJDAAABoAAAACh3dHB0AAAByAAAABRjcHJ0AAAB3AAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAFgAAAAcAHMAUgBHAEIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAAAABvogAAOPUAAAOQWFlaIAAAAAAAAGKZAAC3hQAAGNpYWVogAAAAAAAAJKAAAA+EAAC2z3BhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABYWVogAAAAAAAA9tYAAQAAAADTLW1sdWMAAAAAAAAAAQAAAAxlblVTAAAAIAAAABwARwBvAG8AZwBsAGUAIABJAG4AYwAuACAAMgAwADEANv/bAEMADQkKCwoIDQsLCw8ODRAUIRUUEhIUKB0eGCEwKjIxLyouLTQ7S0A0OEc5LS5CWUJHTlBUVVQzP11jXFJiS1NUUf/bAEMBDg8PFBEUJxUVJ1E2LjZRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUf/AABEIAiwBoAMBIgACEQEDEQH/xAAcAAEAAQUBAQAAAAAAAAAAAAAABAECAwUGBwj/xAA9EAABBAEDAwIEBQQABQEJAAABAAIDBBEFEiETMUEGURQiMmEjQlJxgQcVkaEWJDNiwbElNDVDU9Hh8PH/xAAZAQEBAQEBAQAAAAAAAAAAAAAAAQIDBAX/xAApEQEBAAICAgICAgIBBQAAAAAAAQIRAyESMUFRInEEE2GRIzIzQmKB/9oADAMBAAIRAxEAPwDzBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERARFXCCiKvZUQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQFstPZZqxvuNrB7WjhzxwPutcO62dnWp59PZTDWsjaMHHlS7+Gct/DXSyOlkc931OOSrERVoREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBVVEQdJpDtGr6a6Wzh85zlpWlFd9uy/wCFhcWk8ADsoy6jTNfo6dp7GMrkzY+Yrnd49ztwymWG7j3a5iRjo3ljhhwOCFas9yf4m1JNjG85wsC6O0EREUREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQFkgjMszIxwXHCxq+J5jka8d2nKFdda9MRQ6O50YL7AGcrlLFaas4NmjLCRkZXc6P6jj1CeOs6PadnJJ7laz1s+u50LWOaZR3x4XDDLOZeOTwcPJy48n9fJHJoiLu94iIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiINnpGjWNUeemMRju4rJrmiu0ox5kDw9ZNE19+lQvi6Qka457qJqurWNTlDpcBo+lo8LH5eX+HD/k/s/9UKKR8Tw+Nxa4eQqPe+Rxc9xcT5Ko0FxAAySt9pXpue1iSx+FH357lXLKY910zzxwm8mhwcZxwqLuL1KhW0mWFkYALMiQ+SuIPdMcvKbZ4+Sck3FERFp1EREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBEWx0Wky7d2SZ2tG4geUt0lupuqaPXllvxPbGXNa4F3sF1mtak3TWMDsvefmYBwMfdSq8UFSItga0N2Zwfp/krR+sZGyRVCHNcSO7ey83l/ZnHz/Oc3LNzpoL2o2Lr8yvO3w0dgoiIvTrT6EknUEREUREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERARXxxvkcGsaXE+At/p3pp8xIsv6bi3LW+Vm5Se2M+THD/qrnVO0q42lbEjwTGQWuA9lGswur2Hwu7tOFiV9tdZR0P8AxJsd0Y4B8KARsPcrVX777rm5aGsYMNaPAUNEmMnpnHjxx7kERFWxERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBVaNzgB5KostZwbYjc7sHAlCu003TIKlB0nSBcGZLh9WVlkvPY6vZLxFWDfmD/qKtbqb4nTPc1jawZlhz3OFx1mzYvWfmcXFxw0Lz44XK7yfO4+LLkytzU1GcWb80zeznEhRV0+nemxtbNcOQTjaD2/daz1BQbQ1B0cYxGRlq6zKW6j14cuFvhi1aIrmMc9wa0Ek+Atuy1VwVvaHp+R0ZsWyWRt5LR9RWyv6VC/QXSRV+k5hyM9yFi8kl04Xnwl049FVUW3cREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERBkdNI5oa55LR2GV0np3RmOdFbncefmaAOP5XLrqKeoMOn1XusiMQHD2fqCxnvWo480y8dYtzdfWn0yRxsBoifl3T/9Fx2sXxfsh7QQ1o2jPdSL+p/E769KHZFI7JA7uWaj6bnnZvmeI+MhvlYwxmE3XHiwx4ZvOtJGzqSNYO5OF2emafFWlEbK30jL5nft4XIgGrdAcOY3rsYnvfqENx9pra7mja0nz+yvJvXTf8i3x6SKUZEVr4cyOkcOHv8AJ+y1Ysy0KNoX7AdLMMNjzkhZ2zWqmoS2rlhrYQCGtz3H2C5G1KZrEkhcTucSMrGGG725cPFu2310xHklURF6HuEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQFc3kge5VqyVwDOwO7bhlCu30nS4qhhcyJrtzQ5z3f+FPriPqTOEL9vbe7uf2UKS9WqX4Ig2SSRwAHs0LG5s1XVfirtwNjz8kfuD9l48pbe3yMplne/lo/VNVsV/qxj5Hj/a0vUfx85wO3PZdD6vc4yQ7hgHJBHkLm16cO8Y+jwW3jm2SWeWY5ke5x+5WNEW3YREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQFUHByqK5jXPdtaCSfAQddBbnl0aGep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
"@
[string]$splashjpg2=@"
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
"@
[string]$shazzam_img=@"
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
"@
[string]$logojpgB64=@"
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
"@
$Page = 'PageConsole';$pictureBase64 = $shazzam_img;$PictureBoxConsole = NewPictureBox -X '940' -Y '606' -W '60' -H '60';$PictureBoxConsole.Visible = $false
$Page = 'PageSP';if ($BGIMG -eq 'Dark') {$pictureBase64 = $splashjpg1} else {$pictureBase64 = $splashjpg2}
$PictureBox1_PageMain = NewPictureBox -X '120' -Y '75' -W '500' -H '500';
$Page = 'PageMain';$Button_SP = NewPageButton -X '-5' -Y '630' -W '50' -H '40' -C '0' -Text '';$Button_SPImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($logobar));$Button_SP.Image = $Button_SPImage
$form.ResumeLayout()
$form.Add_Shown({$form.Activate()})
GUI_Resume
$SplashScreen.Close()
$SplashScreen.Dispose()
$form.ShowDialog()
$form.Dispose()
#$form.Refresh()
#$currentTime = (Get-Date);$part1Time, $part2Time , $currentSeconds = $currentTime -split '[:]'
#if ($CMDWindow) {$CMDHandle = $CMDWindow.MainWindowHandle;$processId = 0;$threadId = [WinMekanix.Functions]::GetWindowThreadProcessId($CMDHandle, [ref]$processId)
#$process.Handle = $explorer.HWND;#$CurDir =  $PWD.Path
#if ($processId -gt 0) {$null} else {$null}} else {$null}
#$process = Get-ProcessNull xyz.exe;Wait-Process -Id $process.Id
#REGNull ADD "HKCU\Console" /V "FontSize" /T REG_DWORD /D "$ScaleFont" /F
#Set-ItemProperty -Path "HKCU:\Console" -Name "FontSize" -Value "$ScaleFont"
#$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(100, 1000)
#$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(30, 34)
#Write-Error "ERROR: $([System.Runtime.InteropServices.Marshal]::GetLastWin32Error())"
#ForEachNull ($i in Get-Content "c:\txt.txt") {[void]$listview.Items.Add($i)}
#ForEachNull ($line in $command) {$textBox.AppendText("$line`r`n")}  
#Get-ContentNull "$PSScriptRootX\ini.ini" | ForEach-Object {[void]$ListView1_PageSC.Items.Add($_)}
#Get-ItemNull -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Property | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}
#Get-ItemNull | Select-Object Name, Length, Extension
#Get-ItemNull -Path "$FilePath\*.*" -Name | ForEach-Object {[void]$DropBox1_PagePB.Items.Add($_)}
#GetProcessNull | Select-Object -Property Name, WorkingSet, PeakWorkingSet | Sort-Object -Property WorkingSet -Descending | Out-GridView
#InvokeCommandNull -ComputerName S1, S2, S3 -ScriptBlock {Get-Culture} | Out-GridView
#$Rnd = Get-Random -Minimum 1 -Maximum 100
#If ([string]::IsNullOrEmpty($InitialDirectory) -eq $False) { $FolderBrowserDialog.SelectedPath = $InitialDirectory }
#If ($FolderBrowserDialog.ShowDialog($MainForm) -eq [System.Windows.Forms.DialogResult]::OK) { $return = $($FolderBrowserDialog.SelectedPath) }
#Try { $FolderBrowserDialog.Dispose() } Catch {}
:END_OF_FILE
::#🗃\🗂\🧾\💾\🗳\🏗\🛠\🪛\✂\🗜\✒\✏\🥾\🪟\🛜\🔄\🌐\🛡\🪪\✅\❎\🚫\⏳\🏁\🎨\❗\🛳\🚽\💥\🚥\🚦\🕸\🐜\🛤\🏞\🌕\🌑\◀\▶\❕#