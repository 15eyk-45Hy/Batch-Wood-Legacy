echo off
if "%~2"=="mrupg" goto :RENDER_TABLE
if "%~1"=="UpBal" goto :Update_Balance
if "%~1"=="CleanFlag" goto :Cleaner_Flags

setlocal enabledelayedexpansion
chcp 65001 >nul
set "space=                                                            "

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
set "c4=%ESC%[91m"
set "c2=%ESC%[32m"
set "c0=%ESC%[0m"
set "c1=%ESC%[90m"
set "c3=%ESC%[96m"
set "c5=%ESC%[94m"
set "c6=%ESC%[95m"
set "c7=%ESC%[93m"
set "c8=%ESC%[33m"
set "tb=%ESC%[1m"

for /l %%q in (1,1,3) do (
    if exist "BWLSaveSlot%%q.bat" (
        for %%a in ("BWLSaveSlot%%q.bat") do set "date%%q=[ %%~ta ]"
    ) else (
        set "date%%q=[Empty]"
    )
)
set "ic1=·"
set "ic2=▫"
set "ic3=•"
set "ic4=♦"
set "ic5=✵"

set "NS="
if exist BWLData-Storage.bat (
    call BWLData-Storage.bat
) else (
    echo !!CRITICAL ERROR!!The data folder is corrupted or mising
)
if exist BWLBase-Data-Crafts.bat (
    call BWLBase-Data-Crafts.bat
) else (
    echo !!CRITICAL ERROR!!The data folder is corrupted or mising
)
goto :HOME_setting

:Update_Balance

set "balance_player=%c2%!money!$%c0%!space!"
set "balance_player=!balance_player:~0,16!"
exit /b

:cleancr
set "res1="
set "res2="
set "m1="
set "m2="
set "m3="
set "m1count=0"
set "m2count=0"
set "m3count=0"
exit /b

:CLEANER_MARKET

set "res_mr="
set "total_price="
set "mr_count="
set "mr_product="

exit /b


:Cleaner_Flags

for /l %%q in (1, 1, 15) do (
    set "flag_%%q="
)

exit /b


:Render_Msg

set "begin_msg=%~5"
set "msg=%~1"
set "char="

if not "%~2"=="0" (
    for /l %%q in (1, 1, %~2) do (
        <nul set /p "=!ESC![1C"
    )
)

if "%~4"=="BeginTxt-true" (
    for /l %%q in (0, 1, 99) do (
        set "char=!begin_msg:~%%q,1!"
        <nul set /p "=!char!"
    )
    for /l %%q in (0, 1, %~6) do (
        <nul set /p "=!ESC![1C"
    )
)

for /l %%q in (0, 1, 99) do (

    set "flag_1=0"
    set "ping=1000"
    set "char=!msg:~%%q,1!"
    
    if "!char!"==" " (
        if "%~3"=="SpaceDelay-true" set "ping=10000"
        set "flag_1=1"
    )

    if "!char!"=="" (
        exit /b
    ) else (
        if "!flag_1!"=="1" (
            <nul set /p "=!ESC![1C"    
        ) else (
            <nul set /p "=!char!"
        )
    )
    for /l %%j in (1, 1, !ping!) do set "idln=1"
)

:craftsystem
call :Cleaner_Flags

set "return_workshop=Workshop_Hub" 

if "%~4" NEQ "" (
    if "%~4"=="FNmod" (
        set "return_workshop=workshop4"
    )
)

if "%~4" NEQ "" set "flag_1=FN"

if "!craft%flag_1%_%recipe%!" NEQ "" (
    set result=!craft%flag_1%_%recipe%!
) else (
    echo %c4%Craft is not defined^^!%c0%
    timeout /t 2 /nobreak >nul
    cls
    goto !return_workshop!
)

for %%i in (1/100 2/200 3/300 4/1000 5/2000) do (
    for /f "tokens=1,2 delims=/" %%a in (
            "%%i"
        ) do (    
        if "!rarity_%result%!"=="%%a" set "TRCRAFT=%%b"
    )
)

call :Engine_Anim_Progress_Bar "  C R A F T I N G" "I T E M  C R E A T E D" !TRCRAFT! 500

if "%~1" NEQ "" set /a "count_!res3!-=m3count"
if "%~2" NEQ "" set /a "count_!res4!-=m4count"
if "%~3" NEQ "" set /a "count_!res5!-=m5count"

set /a count_%res1% -=%m1count%
set /a count_%res2% -=%m2count%

set "chance2="
set "chance1="
set /a "chance1=(%RANDOM% %% 100) + 1"

if !rarity_%result%! EQU 1 set "chance2=10"
if !rarity_%result%! EQU 2 set "chance2=15"
if !rarity_%result%! EQU 3 set "chance2=20"
if !rarity_%result%! EQU 4 set "chance2=5"
if !rarity_%result%! EQU 5 set "chance2=0"

if %chance1% LEQ %chance2% (
    cls
    echo.
    echo       ╔═════════════════════════════════════════════╗
    echo     --║    %c4%C  R  A  F  T    F  A  I  L  E  D   ^^!%c0%    ║--
    echo       ╚═══╤═════════════════════════════════════╤═══╝
    echo           │                                     │
    echo           │           b a d   l u c k . . .     │
    echo           ├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤
    echo           │        Resources were wasted        │
    echo           │           for nothing...            │
    echo           └─────────────────────────────────────┘   
    echo                     %c1%[Any key]► Exit%c0%
    echo.

    pause >nul

    goto !return_workshop!
)

set /a count_%result% +=1
set "current_rarity_item=!rarity_%result%!"
for /f "delims=" %%i in ("!rar%current_rarity_item%!") do set "RARITY_item=%%i"

if "!rarity_%result%!"=="1" (
    set "NAME_item=!ic1! !name_%result%!!space!"
    set "RARITY_item=!ic1! !RARITY_item!!space!"
)
if "!rarity_%result%!"=="2" (
    set "NAME_item=%c3%!ic2! !name_%result%!%c0%!space!"
    set "RARITY_item=%c3%!ic2! !RARITY_item!%c0%!space!"
)
if "!rarity_%result%!"=="3" (
    set "NAME_item=%c5%!ic3! !name_%result%!%c0%!space!"
    set "RARITY_item=%c5%!ic3! !RARITY_item!%c0%!space!"
)
if "!rarity_%result%!"=="4" (
    set "NAME_item=%c6%!ic4! !name_%result%!%c0%!space!"
    set "RARITY_item=%c6%!ic4! !RARITY_item!%c0%!space!"
)
if "!rarity_%result%!"=="5" (
    set "NAME_item=%c7%!ic5! !name_%result%!%c0%!space!"
    set "RARITY_item=%c7%!ic5! !RARITY_item!%c0%!space!"
)

set "pad=25"

if !rarity_%result%! GTR 1 set /a "pad+=9"

set "RARITY_item=!RARITY_item:~0,%pad%!"
set "PRICE_item=!price_%result%!$!space!"
set "PRICE_item=!PRICE_item:~0,26!"
set "COUNT_item=!count_%result%!!space!"
set "COUNT_item=!COUNT_item:~0,19!"
set "pad=27"

if !rarity_%result%! GTR 1 set /a "pad+=9"
set "NAME_item=!NAME_item:~0,%pad%!"

echo.
echo       ╔═══════════════════════════════════════════╗
echo     --║   %c2%C  R  A  F  T    S  U  C  C  E  S  S  ^!%c0%  ║--
echo       ╚═══╤═══════════════════════════════════╤═══╝
echo           │                                   │                                   
echo           │      i t e m   c r e a t e d ^!     │
echo           ├───────────────────────────────────┤
echo           │             You have              │
echo           │• Name: !NAME_item!│
echo           ├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤       
echo           │• Rarity: !RARITY_item!│
echo           │• Price: %c2%!PRICE_item!%c0%│ 
echo           │• In Inventory: !COUNT_item!│
echo           └───────────────────────────────────┘
echo                    %c1%[Any key]► Exit%c0%
echo.

pause >nul
cls

goto !return_workshop!
exit /b

:CACPHA_input_item_amount

if "!%~1!"=="" (
    set "enter_player=*Void*!space!"
    goto render_error_window_amount
)

set "check_num_tmp="
for /f "delims=0987654321" %%v in ("!%~1!") do set "check_num_tmp=1"

if "!check_num_tmp!"=="1" (
    set "long_enter_player=0"
    set "enter_player=!%~1!"
) else (
    goto NEXT_STEP_%~2_%~3
)

call :PARSER_LONG_ENTER
set "enter_player="!%~1!""

:render_error_window_amount
call :PARSER_PART_TEXT
call :RENDER_ERROR_HUB "invalid_amount"

goto %~4
::---------------------------

:System_Validation_Mr

::Protocol validation #001
if /i "!%~1!"=="m" (
    if !mr_current_page! GEQ !max_mr_page! (
        set "mr_current_page=!min_mr_page!"
    ) else (
        set /a "mr_current_page+=1"
    )
)
::Protocol validation #002
if /i "!%~1!"=="n" (
    if !mr_current_page! LEQ !min_mr_page! (
        set "mr_current_page=!max_mr_page!"
    ) else (
        set /a "mr_current_page-=1"
    )
)

::Cleaning old VAR
call :CLEANER_MARKET

::Rerendering table market
goto SELL_ITEMS
::---------------------------

:Universal_Engine_For_Market

::Capcha on system validation 
if "%~1"=="sell" (
    set "validation_system=1" 
) else (
    set "validation_system=0"
)
call :CLEANER_MARKET
set "arrow1="
set "arrow2="


call :RENDER_TABLE_MARKET "%~1" "%~2"
set /p "mr_product=Select resource: "
if "!validation_system!"=="1" (
    if /i "!mr_product!"=="m" call :System_Validation_Mr "mr_product"
    if /i "!mr_product!"=="n" call :System_Validation_Mr "mr_product" 
)

if /i "!mr_product!"=="B" goto market
cls

call :RENDER_TABLE_MARKET "%~1" "%~2"
set /p "mr_count=Enter amount: "
if "!validation_system!"=="1" (
    if /i "!mr_count!"=="m" call :System_Validation_Mr "mr_count" 
    if /i "!mr_count!"=="n" call :System_Validation_Mr "mr_count" 
)

if /i "!mr_count!"=="B" goto market

::===============================
for %%i in (!MARKET_%~1_LIST_%~2!) do (
    for /f "tokens=1,2 delims=/" %%a in ("%%i") do (
        if "!mr_product!"=="%%b" set "res_mr=%%a"
    )
)

exit /b
::-------------------------------------------------------
:RENDER_TABLE_MARKET
if "%~1"=="pay" (
    set "tool_tip=                     %c1%[B]► Exit%c0%"
    set "gap= "
) else (
    set "tool_tip=%c1%[N]► Previous Page   •   [M]► Next Page   •   [B]► Exit%c0%"
    set "gap="
)
call :Update_Balance
cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo                    [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0%]
echo                    ╔══════════════════════════════════╗
echo                    ║         M  A  R  K  E  T         ║
echo                    ╚══════════════════════════════════╝
echo     ╔═══════╦═══════════════════════════════╦═══════════╦═════════════╗
echo     ║       ║                               ║           ║             ║
echo     ║ R E S ║          N  A  M  E           ║ C O U N T ║  P R I C E  ║
echo     ║   #   ║                               ║           ║   %c1%[%~1]%c0% !gap!   ║
echo     ╠═══════╬═══════════════════════════════╬═══════════╬═════════════╣

call :RENDER_TABLE "!MARKET_%~1_LIST_%~2!" "mr%~1" "%~2"
echo           !tool_tip!         

exit /b
::-------------------------------------
:CACPHA_input_item_number

if "%~1"=="" (
    set "enter_player=*Void*!space!"
    goto render_error_window_number
)

if not defined %~5 (
    set "long_enter_player=0"
    set "enter_player=%~1"
) else (
    goto NEXT_STEP_%~2_%~3
)

call :PARSER_LONG_ENTER
set "enter_player="%~1""

:render_error_window_number

call :PARSER_PART_TEXT
call :RENDER_ERROR_HUB "invalid_number_item"

goto %~4

::=============
:PARSER_LONG_ENTER

for /l %%v in (1, 1, 200) do (
    set "check_word=!enter_player:~%%v,1!"
    if "!check_word!"=="" (
            
        set "long_enter_player=%%v"
        exit /b
    )  
)
exit /b
::======================

:RENDER_ERROR_HUB

if "%~1"=="invalid_amount" (
    set "hint1=│ TIP: Use only positive number.    │"
    set "hint2="
)

if "%~1"=="invalid_number_item" (
    set "hint1=│ TIP: Select an item number.       │"
    set "hint2="
)
if "%~1"=="invalid_long_name_save" (
    if "!enter_player!"=="*Void*" (
        set "hint1=│ TIP: The name cannot be empty^!    │"
        set "hint2="
    ) else (
        set "hint1=│ TIP: Name is too long  [max 30]   │"
        set "hint2=echo.          │      Please enter a shorter name. │"
    )
)
cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo       ╔═══════════════════════════════════════════╗
echo       ║               %c4%E  R  R  O  R  ^!%c0%             ║
echo       ╚═══════════════════════════════════════════╝
echo           ┌───────────────────────────────────┐                                         
echo           │       w r o n g   i n p u t ^!      │
echo           ├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤       
echo           │ Your input:                       │
echo           │ !part1!│
echo           │ !part2!│
echo           │ !part3!│            
echo           ├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤       
echo.          !hint1!
!hint2! 
echo           └───────────────────────────────────┘
echo                    %c1%[Any key]► Exit%c0%
pause >nul

set "long_enter_player="
exit /b

::==============
:PARSER_PART_TEXT

set "arrow1="
set "arrow1="

if !long_enter_player! GEQ 90 goto HIDDEN_ACCESS

for %%v in (1/30 2/60) do (
    for /f "tokens=1,2 delims=/" %%a in ("%%v") do (
        if !long_enter_player! GTR %%b (
            set "arrow%%a=>"
        )
    )
)

set "part1=!enter_player:~0,30!!arrow1!!space!"
set "part2=!arrow1!!enter_player:~30,30!!arrow2!!space!"
set "part3=!arrow2!!enter_player:~60,30!!space!"


set "part1=!part1:~0,34!"
set "part2=!part2:~0,34!"
set "part3=!part3:~0,34!"
exit /b

::==============================================

:CR_ALL
cls
if "%3"=="1" (
    set "amount_crafts=5"
    set "RES_LIST_CR=!RES_LIST:~0,37!"
)
if "%3"=="2" (
    set "amount_crafts=8"
    set "RES_LIST_CR=!RES_LIST:~0,65!"
)
if "%3"=="3" (
    set "amount_crafts=12"
    set "RES_LIST_CR=!RES_LIST:~0,133!"
)
if "%3"=="4" (
    set "amount_crafts=17"
    set "RES_LIST_CR=!RES_LIST!"
)
if "%3"=="5" (
    set "amount_crafts=5"
    set "RES_LIST_CR=!RES_LIST_FOR_FL!"
)

::Cleaning VAR for crafts
set "m%1="
set "m%1count="
set "res%1="
set "arrow1="
set "arrow2="

set "return_workshop=Workshop_Hub" 
set "workshop_header=║       W  O  R  K  S  H  O  P       ║"

if "%~4" NEQ "" (
    if "%~4"=="FNmod" (
        set "return_workshop=workshop4"
        set "workshop_header=║  A  S  S  E  M  B  L  Y   B  A  Y  ║"
    )
)

set "current_component=%1"
goto CR_ALL_BEGIN
::-----------------------------------------------
:RENDERING_RES_LIST

::Rendering list-resources
call :Update_Balance
cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo           [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0%]
echo           ╔════════════════════════════════════╗
echo           !workshop_header!
echo           ╚════════════════════════════════════╝
echo     ╔═══════╦═══════════════════════════════╦═══════════╗
echo     ║       ║                               ║           ║
echo     ║ R E S ║          N  A  M  E           ║ C O U N T ║
echo     ║   #   ║                               ║           ║
echo     ╠═══════╬═══════════════════════════════╬═══════════╣

:RENDER_TABLE

for %%i in (%~1) do (
    for /f "tokens=1,2 delims=/" %%a in ("%%i") do (
        
        set "num_item_tmp=%%b"
        set /a "num_item_tmp+=1000"
        set "num_item_txt=!num_item_tmp:~1,3!"            

        set "pad1=30"
        if !rarity_%%a! GTR 1 (
            set /a "pad1+=9"
        )

        ::►1►VAL NAME
        if "!rarity_%%a!"=="1" set "item_name_tmp=!ic1! !name_%%a!!space!"
        if "!rarity_%%a!"=="2" set "item_name_tmp=%c3%!ic2! !name_%%a!%c0%!space!"
        if "!rarity_%%a!"=="3" set "item_name_tmp=%c5%!ic3! !name_%%a!%c0%!space!"
        if "!rarity_%%a!"=="4" set "item_name_tmp=%c6%!ic4! !name_%%a!%c0%!space!"
        
        set "show_it=1"
        if "%~2"=="mrpay" set "show_it="
        if "%~2"=="mrupg" set "show_it="
        if "%~2"=="cr" (
            if defined begin_M_%%a set "show_it="
        )

        if defined show_it (

            set "is_revealed="
            if "!have_%%a!"=="1" set "is_revealed=1"
            if !count_%%a! GTR 0 set "is_revealed=1"

            if defined is_revealed (
                set "item_name_tmp=!item_name_tmp!"
                set "have_%%a=1"
            ) else (

                set "item_name_tmp="
                set "list_noise=░▒▓█▄▌▐▀"

                for /l %%q in (0, 1, 10) do (
                    set /a "noise_rdm=!random! %% 8"
                    for %%v in (!noise_rdm!) do set "item_name_tmp=!item_name_tmp!!list_noise:~%%v,1!"
                )
                set "item_name_tmp=!item_name_tmp!!space!"
                set "pad1=30"
            )
        )

        for %%v in (!pad1!) do set "item_name_txt=!item_name_tmp:~0,%%v!"     
        
        if !count_%%a! GTR 0 (
            set "item_count_tmp=%c7%!count_%%a!!space!"
            set "item_count_txt=!item_count_tmp:~0,14!%c0%"
        ) else (
            set "item_count_tmp=!count_%%a!!space!"
            set "item_count_txt=!item_count_tmp:~0,9!%c0%"
        )


        for %%j in (cr:amount_crafts mrpay:amount_products_pay mrsell:amount_products_sell) do (
            for /f "tokens=1,2 delims=:" %%v in ("%%j") do (
                if "%~2"=="%%v" set "amount_anything=!%%w!"
            ) 
        )
        
        if "%~2"=="cr" (
            set "amount_anything=!amount_crafts!"
            set "UI_line=echo     │ #!num_item_txt!  │ !item_name_txt!│ !item_count_txt! │"
            set "render_line=echo     ├ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ┤" 
        )

        set "is_revealed="
        if "%~2"=="mrsell" set "is_revealed=1"
        if "%~2"=="mrpay" set "is_revealed=1"

        if defined is_revealed (
            set "amount_anything=!amount_products_%~2_%~3!"

            set "price_item_tmp=!price_%%a!$!space!"
            set "price_item_txt=%c2%!price_item_tmp:~0,10!%c0%"

            set "UI_line=echo     │ #!num_item_txt!  │ !item_name_txt!│ !item_count_txt! │  !price_item_txt! │"
            set "render_line=echo     ├ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ─ ┤"
        )

        if "%~2"=="mrupg" (
            

            set "amount_anything=!count_needs_res_%~3!"
            
            set "flag_2=%%b"
            set "flag_1=0"
            set "curr_need_res_%%b="

            for %%j in (!needs_res_%~3!) do (
                set /a "flag_1+=1"
                if "!flag_1!"=="!flag_2!" (
                    set "curr_need_res_%%b=%%j"
                )
            )
            
            if !count_%%a! LSS !curr_need_res_%%b! (
                set "item_count_txt=!count_%%a!!space!"
                set "item_count_txt=%c4%!item_count_txt:~0,9!%c0%"
            )
            set "curr_need_res=!curr_need_res_%%b!!space!"
            set "curr_need_res=!curr_need_res:~0,11!"

            set "UI_line=echo     │ #!num_item_txt!  │ !item_name_txt!│ !item_count_txt! │ !curr_need_res! │"
            set "render_line=echo     ├ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ─ ┤"
        )
        if "!amount_anything!"=="%%b" set "render_line="
        
        !UI_line!
        !render_line!
    )
)
if "%~2"=="cr" (
    echo     └───────┴───────────────────────────────┴───────────┘    
) else (
    echo     └───────┴───────────────────────────────┴───────────┴─────────────┘
)
call :Cleaner_Flags
exit /b

:CR_ALL_BEGIN

call :RENDERING_RES_LIST "!RES_LIST_CR!" "cr" "%~4"
echo                         %c1%[B]► Exit%c0%
set /p "m%1=Select a %~2 material: "
if /i "!m%1!"=="B" goto !return_workshop!

call :RENDERING_RES_LIST "!RES_LIST_CR!" "cr" "%~4"
echo                         %c1%[B]► Exit%c0%
set /p "m%1count=Select amount: "
if /i "!m%1count!"=="B" goto !return_workshop!

for %%i in (!RES_LIST_CR!) do (
    for /f "tokens=1,2 delims=/" %%a in ("%%i") do (
        if "!m%1!"=="%%b" set "res%1=%%a"
    )
)
::If player enter wrong input [wrong number item] ►
call :CACPHA_input_item_number "!m%1!" "CR" 1 "!return_workshop!" "res%1"
::-------------------------------------------------

::If player enter wrong input [wrong amount item] ►
:NEXT_STEP_CR_1
call :CACPHA_input_item_amount "m!current_component!count" "CR" 2 "!return_workshop!"
::-------------------------------------------------

:NEXT_STEP_CR_2
set "current_res=!res%current_component%!"
set "selected_item="

::Capcha item ► count
if !count_%current_res%! LSS !m%1count! (

    if !count_%current_res%! GTR 0 (
        set "selected_item=!name_%current_res%!"
    ) else (
        for /l %%q in (0, 1, 10) do (
            set /a "noise_rdm=!random! %% 8"
            for %%v in (!noise_rdm!) do set "selected_item=!selected_item!!list_noise:~%%v,1!"
        )
    )
    
    echo %c4%Not enough !selected_item!  ^(!count_%current_res%!/!m%current_component%count!^)%c0%
    timeout /t 2 /nobreak >nul
    goto !return_workshop!
)
exit /b
::==================================================================
:HIDDEN_ACCESS
cls

echo ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
for /l %%v in (1, 1, 1000) do (
    set /a "hide_num=!RANDOM! %% 2"
    set /a "hide_num2=!RANDOM! %% 2026"

    set "active=%c4%error%c0%"
    if "!hide_num!"=="1" set "active=%c2%true%c0%"

    echo Protocol [#!RANDOM!.%%vAPI-^> !active! ◄^@!hide_num2!
)
echo txt.errorhigh ^>^> Nice try... Don't get ahead of yourself^!^!^!
pause
for /l %%q in (1, 1, 3) do (
    for %%v in (/ ── \ │) do (
        echo.
        echo [LOAD MODUL{-menu}=^> %%v  ]
        timeout /t 1 /nobreak >nul
        cls
    )
)
goto menu

:RECIPE_LISTS_DATA
call :Cleaner_Flags

set "current_page=1"

::=========================
set "flag_1=Workshop_Hub"
if "%~1" NEQ "" set "flag_1=market"
:page1
call :RECIPE_LIST 1 72 30
goto !flag_1!
:page2
call :RECIPE_LIST 2 72 30
goto !flag_1!
:page3
call :RECIPE_LIST 3 72 30
goto !flag_1!
:page4
call :RECIPE_LIST 4 72 30
goto !flag_1!

:RECIPE_LIST

call :Update_Balance
cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo                                               [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0%]
echo                                         ╔══════════════════════════════════════════════╗
echo                                         ║       R  E  C  I  P  E    B  O  O  K         ║
echo                                         ╚══════════════════════════════════════════════╝
echo    ╔═════════════════════════════════════════════════════════════════════╦═════════════════════════════╦═════════════════════╗
echo    ║                                                                     ║                             ║                     ╠═════════╗
echo    ║                         R  E  C  I  P  E  S                         ║     R  E  S  U  L  T  S     ║    P  R  I  C  E    ║ PAGE %1  ║
echo    ║                                                                     ║                             ║                     ╠═════════╝
echo    ╠═════════════════════════════════════════════════════════════════════╬═════════════════════════════╬═════════════════════╣

for /l %%q in (1, 1, !amount_CR%1!) do (
    for /f "tokens=1,2 delims==" %%a in ('set nameCR%1_') do (
        set "full_name=%%a"
        set "full_value=%%b"
        for /f "tokens=1,2 delims=/" %%k in ("!full_value!") do (
            set "visual_craft=%%k"
            set "capcha_number=%%l"
        )
        if "!capcha_number!"=="%%q" (
            for /f "tokens=1,2 delims=_" %%i in ("!full_name!") do (
                set "craft_id=%%j"
            )

            set "pad=%3"

            set "linedelims=echo    ├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┼ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤"
            set "nameitem_id=craft_!craft_id!"

                    
            for /f "delims=" %%v in ("!nameitem_id!") do set "itemH=!%%v!"

            for /f "delims=" %%v in ("price_!itemH!") do set "price_item=!%%v!"

            for /f "delims=" %%v in ("name_!itemH!") do set "item_name_tmp=!%%v!"
            
            set "rarity_id=rarity_!itemH!"
            for /f "delims=" %%v in ("!rarity_id!") do set "rarity_item=!%%v!"

            for /f %%v in ("have_!itemH!") do set "have_item=!%%v!"
            for /f %%v in ("count_!itemH!") do set "count_item=!%%v!"


            if "!rarity_item!"=="1" set "item_name_tmp=!ic1! !item_name_tmp!"
            if "!rarity_item!"=="2" set "item_name_tmp=%c3%!ic2! !item_name_tmp!%c0%"
            if "!rarity_item!"=="3" set "item_name_tmp=%c5%!ic3! !item_name_tmp!%c0%"
            if "!rarity_item!"=="4" set "item_name_tmp=%c6%!ic4! !item_name_tmp!%c0%"
            
            if !rarity_item! GTR 1 set /a "pad+=9"


            set "is_revealed="
            if "!have_item!"=="1" set "is_revealed=1"
            if !count_item! GTR 0 set "is_revealed=1"

            if defined is_revealed (
                set "item_name_tmp=!item_name_tmp!"
                set "have_item=1"
            ) else (

                set "item_name_tmp="
                set "list_noise=░▒▓█▄▌▐▀"

                for /l %%q in (0, 1, 10) do (
                    set /a "noise_rdm=!random! %% 8"
                    for %%v in (!noise_rdm!) do set "item_name_tmp=!item_name_tmp!!list_noise:~%%v,1!"
                )
                set "item_name_tmp=!item_name_tmp!!space!"
                set "pad=30"
            )

            
            ::RENDERING
            set "txt_1halfrecipe=   │ !visual_craft!!space!"
            set "txt_1halfrecipe=!txt_1halfrecipe:~0,%2!"

            set "txt_2halfrecipe= │ !item_name_tmp!!space!"
            for /f "tokens=1" %%v in ("!pad!") do set "txt_2halfrecipe=!txt_2halfrecipe:~0,%%v!"
            

            set "txt_3halfrecipe=  !price_item!$!space!"
            set "txt_3halfrecipe=!txt_3halfrecipe:~0,20!"
            
            if "%%q"=="!amount_CR%1!" set "linedelims="

            echo !txt_1halfrecipe!!txt_2halfrecipe! │%c2%!txt_3halfrecipe!%c0% │
            !linedelims!
        )
    )
)
echo    └─────────────────────────────────────────────────────────────────────┴─────────────────────────────┴─────────────────────┘
::==================================================================
echo                                    %c1%[N]► Previous Page   •   [M]► Next Page   •   [B]► Exit%c0%
echo.

choice /c nmbтьийцукенгшщзхъфывапролджэячсмбюqwertyuiopasdfghjklzxcv1234567890 /n

if errorlevel 7 call :END_COMM "%c4%Invalid Option%c0%" 1000 "page!current_page!"

if errorlevel 6 exit /b
if errorlevel 5 goto next_page
if errorlevel 4 goto prev_page

if errorlevel 3 exit /b
if errorlevel 2 goto next_page
if errorlevel 1 goto prev_page

:next_page
if !current_page! GEQ 4 (
    set "current_page=1"
    goto page!current_page!
)
if !lvlWH! GTR !current_page! (
    set /a "current_page+=1"
    goto page!current_page!
) else (
    echo LOCKED^^^!
    timeout /t 1 /nobreak >nul
    goto page!current_page!
)
::========================================
:prev_page
if !current_page! GTR 1 (
    set /a "current_page-=1"
    goto page!current_page!
) else (
    if !lvlWH! GEQ 3 (
        set "current_page=4"
        goto page!current_page!
    ) else (
        echo LOCKED^^^!
        timeout /t 1 /nobreak >nul
        goto page!current_page!
    )
)

:END_COMM
echo %~1
ping -n 1 -w %~2 127.255.255.255 >nul
goto %~3
exit /b

:Render_Saves_Slots

set "number_display_slot=0"
set "number_display_slot="

for /l %%q in (1, 1, 3) do (
    if exist BWLSaveSlot%%q.bat (
        call "BWLSaveSlot%%q.bat"

        set /a "number_display_slot+=1"
        set "number_system_slot=%%q"

        set "current_name_slot="
        for /f "usebackq delims=" %%v in ("BWLSaveSlot%%q.bat") do (
            if not defined current_name_slot (
                set "current_name_slot=%%v"
                set "current_name_slot=!current_name_slot:~2!"
            )
        )

        if not "!number_system_slot!"=="!number_display_slot!" (
            
            ren "BWLSaveSlot!number_system_slot!.bat" "BWLSaveSlot!number_display_slot!.bat"
            
            (
                chcp 65001 > nul
                echo ::!current_name_slot!
                
                for %%i in (!INV_LIST! rocket) do (

                    echo set "slot!number_display_slot!_%%i=!slot%%q_%%i!"
                    echo set "slot!number_display_slot!_have_%%i=!slot%%q_have_%%i!"
                )

                for %%i in (lvlWH lvlWHvisual upwh menuupgrade money) do (
                
                    echo set "slot!number_display_slot!_%%i=!slot%%q_%%i!"
                )

                echo exit /b
            ) > "BWLSaveSlot!number_display_slot!.bat"
        )

        set /a "current_slot=number_display_slot + 1000"
        set "current_slot=!current_slot:~1,3!"
        
        for /f "delims=" %%v in ("slot!number_display_slot!_money") do (
            set "flag1=!%%v!"
        )
        set "balance_player_curr_save=!flag1!$!space!"
        set "balance_player_curr_save=%c2%!balance_player_curr_save:~0,16!%c0%"
        
        set "current_name_slot=!current_name_slot!!space!"
        set "current_name_slot=%c7%!current_name_slot:~0,30!%c0%"

        set "current_date_slot=!date%%q!!space!"
        set "current_date_slot=!current_date_slot:~0,25!"

        echo     ╔═══════════════════════════════════════╗
        echo     ║ Name: !current_name_slot!  ║         
        echo     ║ Last save: !current_date_slot!  ║
        echo     ┡═══════════════════════╤═══════════════┩
        echo     │ Cash: !balance_player_curr_save!│   SLOT #!current_slot!   │
        echo     └───────────────────────┴───────────────┘
        echo    ◄ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ►
    )
)

exit /b

:Engine_Anim_Progress_Bar

set "bar1=│ "
set "bar2=░░░░░░░░░░░░░░░░░░░░"
set "stageloadanim=0"
set "curr_tick=0"
set "last_tick=0"
set "accumulator_time=0"
set /a "tip_id=(%RANDOM% %% 6) + 1" 

::Times
set "hh=!time:~0,2!"
set "mm=!time:~3,2!"
set "ss=!time:~6,2!"
set "hh=!hh: =0!"

set /a "last_tick=(1!hh! - 100) * 3600 + (1!mm! - 100) * 60 + (1!ss! - 100)"


set "curr_tip=TIP!tip_id!"
for /f "delims=" %%r in ("!curr_tip!") do (
    set "curr_tip=!%%r!"
)

cls
for /l %%q in (0, 1, 2) do (
    for %%v in (. .. ...) do (

        set "flag1=%%v"
        
        set "bar2=!bar2:~0,-2!"
        for /f "delims=" %%a in ("!bar1!") do set "bar1=!bar1!▓▓" 
        
        set "final_bar=!bar1!!bar2!"
        
        set /a "stageloadanim+=10"
        set "stageloadanim=!stageloadanim!!space!"
        set "stageloadanim=!stageloadanim:~0,3!"

        echo.
        echo                                 %~1!flag1!
        echo                               ┌───────────────────────────┐
        echo                               !final_bar! !stageloadanim!%% │
        echo                               └───────────────────────────┘
        echo     !curr_tip!
        
        ping -n 1 -w %~3 127.255.255.255 >nul
        
        ::Times
        set "hh=!time:~0,2!"
        set "mm=!time:~3,2!"
        set "ss=!time:~6,2!"
        set "hh=!hh: =0!"

        
        set /a "curr_tick=(1!hh! - 100) * 3600 + (1!mm! - 100) * 60 + (1!ss! - 100)"
        
        set /a "passed_time=curr_tick - last_tick"

        if !passed_time! LSS 0 set /a "passed_time+=86400"
        
        set /a "accumulator_time+=passed_time"
        
        if !accumulator_time! GEQ 3 (
            set /a "tip_id=(!RANDOM! %% 6) + 1"
            set "curr_tip=TIP!tip_id!"

            for /f "delims=" %%r in ("!curr_tip!") do (
                set "curr_tip=!%%r!"
            )
            set "accumulator_time=0"
        )
        set "last_tick=!curr_tick!"
        cls
    )
)
set "final_bar=│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo.
echo                                   %c2%%~2%c0%    
echo                               ┌───────────────────────────┐
echo                               !final_bar! 100%% │
echo                               └───────────────────────────┘


ping -n 1 -w %~4 127.255.255.255 >nul

cls
call :Cleaner_Flags
exit /b

:Engine_Render_Data_Management

set "return_DM=SAVE_GAME_HUB"

if "%~1"=="save" (
    set "flag3=Save_System"
    set "flag2=║   C  R  E  A  T  E    S  A  V  E   ║"
)
if "%~1"=="del/save" (
    set "flag3=Del_System"
    set "flag2=║   D  E  L  E  T  E    S  A  V  E   ║"
)
if "%~1"=="load/save" (
    set "flag3=Load_System"
    set "flag2=║      L  O  A  D    G  A  M  E      ║"
    set "return_DM=HOME_setting"
)

:re_enter_slot

call :Update_Balance

cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo       [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0%]
echo      ╔════════════════════════════════════╗
echo      !flag2!
echo      ╚════════════════════════════════════╝
echo.

call :Render_Saves_Slots
call :Cleaner_Flags

echo                   %c1%[B]► exit%c0%
set "current_name_slot="

if "%~1"=="save" (
    if !number_display_slot! LSS 3 (
        set /a "next_number_display_slot=number_display_slot + 1"

        echo           [!next_number_display_slot!]► Create a new save...
        echo.
    )
)

set "save_slot="

::---Player enter slot---
set /p "save_number=⠀             Select a slot: "

if /i "!save_number!"=="b" goto !return_DM!


for %%i in (1 2 3) do (
    if "!save_number!"=="%%i" (
        set "flag_1=1"
    )
)
if not defined flag_1 (
    call :Cleaner_Flags
    echo %c4%⠀             Invalid Choice^!%c0%
    timeout /t 1 /nobreak >nul
    goto :re_enter_slot
)

exit /b

:SAVE_GAME_HUB
call :Update_Balance

cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo           [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0% ]
echo           ╔═══════════════════════════════════╗
echo           ║      S  A  V  E   G  A  M  E      ║
echo           ╚═══════════════════════════════════╝
echo.
echo.                    
echo            [ Save Game ......... 'S' ]
echo            [ Delete Save ....... 'D' ]
echo.
echo            ^< ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ^>
echo            [ Home .............. 'H' ]                 
echo.

choice /c sdhqwertyuiopafgjklzxcvbnm /n

if errorlevel 4 (
    echo                   %c4%Invalid Choice^^!%c0%            
    timeout /t 1 /nobreak >nul
    goto :SAVE_GAME_HUB
)
if "%errorlevel%"=="3" goto :HOME_setting
if "%errorlevel%"=="2" (
    goto Del_System
)
if "%errorlevel%"=="1" (
    goto Save_System
)


:Save_System

call :Engine_Render_Data_Management "save"

:Save_Logic

if not exist "BWLSaveSlot!save_number!.bat" goto :Change_Save_Name

echo                      ▼
choice /c yn /n /m "⠀         Rename this save? [Y/N]: "

if %errorlevel%==2 goto :Read_Save_Name
if %errorlevel%==1 goto :Change_Save_Name

:Change_Save_Name

call :Cleaner_Flags
set "name_slot_!save_number!="
echo                      ▼
set /p "name_slot_!save_number!=⠀             Enter slot name ^<^< "

set "enter_player=!name_slot_%save_number%!"
    
if "!enter_player!"=="" (
    set "enter_player=*Void*"
    set "flag_1=1"
) else (
    
    call :PARSER_LONG_ENTER
    if !long_enter_player! GEQ 30 (
        set "enter_player="!name_slot_%save_number%!""
        set "flag_1=1"
    )
)
    
    if defined flag_1 (
    call :PARSER_PART_TEXT
    call :RENDER_ERROR_HUB "invalid_long_name_save"
    goto SAVE_GAME_HUB
)

for /f "delims=" %%v in ("name_slot_!save_number!") do (
    set "name_slot_!save_number!=::!%%v!"
)

call :Cleaner_Flags
goto :Assign_Name_Slot


:Read_Save_Name

for /f "usebackq eol= delims=" %%v in ("BWLSaveSlot!save_number!.bat") do (
    if not defined name_slot_!save_number! (
        set "name_slot_!save_number!=%%v"
    )
)
goto :Assign_Name_Slot

:Assign_Name_Slot
for /f "delims=" %%v in ("name_slot_!save_number!") do (
    set "current_name_slot=!%%v:~2!"
)

::---Record in save-fail---
(
    chcp 65001 > nul
    echo ::!current_name_slot!
    set "save!save_number!=1"
    for %%i in (!INV_LIST! rocket) do (
        echo set "slot!save_number!_%%i=!count_%%i!"
        echo set "slot!save_number!_have_%%i=!have_%%i!"
    )

    for %%i in (lvlWH lvlWHvisual upwh menuupgrade money) do (
        echo set "slot!save_number!_%%i=!%%i!"
    )
    echo exit /b
) >BWLSaveSlot!save_number!.bat

for %%a in ("BWLSaveSlot!save_number!.bat") do (
    set "date!save_number!=[ %%~ta ]"
)
call :Engine_Anim_Progress_Bar "S A V I N G    G A M E" "G A M E   S A V E D^!" 1000 2000
goto SAVE_GAME_HUB
::=======================================================

:Del_System
cls

call :Engine_Render_Data_Management "del/save"

:Del_Logic

if exist BWLSaveSlot!save_number!.bat (
    del /f /q "BWLSaveSlot!save_number!.bat"
    call :END_COMM "%c2%⠀           Successfully Deleted%c0%" 1000 "SAVE_GAME_HUB"    
)
call :END_COMM "%c4%⠀             Slot is empty^!%c0%" 1000 "SAVE_GAME_HUB"


:Load_System
cls

call :Engine_Render_Data_Management "load/save"

:Load_Logic

if exist BWLSaveSlot!save_number!.bat (
    call BWLSaveSlot!save_number!.bat

    for %%i in (!INV_LIST! rocket) do (
        set "count_%%i=!slot%save_number%_%%i!"
        set "have_%%i=!slot%save_number%_have_%%i!"
    )

    for %%i in (lvlWH lvlWHvisual upwh menuupgrade money) do (
        set "%%i=!slot%save_number%_%%i!"
    )

    call :END_COMM "%c2%⠀               Game Loaded^!%c0%" 1000 "HOME_setting"
)
call :END_COMM "%c4%⠀              Slot is empty^!%c0%" 1000 "Load_System"

::========================================================


:Render_UpgradeMenu_UI
call :Cleaner_Flags

echo  !flag_1!

call :Update_Balance

cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo                    [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0%]
echo                    ╔══════════════════════════════════╗
echo                    ║ U P G R A D E    W O R K S H O P ║
echo                    ╚══════════════════════════════════╝
echo     ╔═══════╦═══════════════════════════════╦═══════════╦═════════════╗
echo     ║       ║                               ║           ║             ║
echo     ║ R E S ║          N  A  M  E           ║ C O U N T ║    Y O U    ║
echo     ║   #   ║                               ║           ║   N E E D   ║
echo     ╠═══════╬═══════════════════════════════╬═══════════╬═════════════╣

call :RENDER_TABLE "!UPG_LIST_%~1!" "mrupg" "%~1"

echo                               %c1%[B]► Exit%c0%
echo                        Upgrade Workshop to LVL %c7%%nextlvlWH%%c0%

if "!lvlWH!"=="1" set "flag_1=echo. %c4%^!^!WARNING^!^!:%c1% Upgrading the Workshop to level 2 disables the manual Clicker^!%c0%"
!flag_1!
echo.
echo                    %c2%Confirm %c0%[Y]            %c4%Cancel %c0%[N]
exit /b

:Logic_UpgradeSystem

choice /c yn /n

if errorlevel 2 exit /b
if errorlevel 1 (
    set "flag_1="
    set "flag_2=0"
    for %%v in (!UPG_LIST_%~1!) do (
        for /f "delims=/ tokens=1,2" %%a in ("%%v") do (
            if !count_%%a! GEQ !curr_need_res_%%b! set /a "flag_2+=1"
        )
    )
    
    if "!flag_2!"=="!count_needs_res_%~1!" (
        set "flag_1=1"
    ) else (
        cls
        echo %c1%!current_version! ░ !time:~0,5!%c0%
        echo.
        echo        ┌───────────────────────────────────────┐
        echo        │ %c4%N O T  E N O U G H  R E S O U R C E S%c0% │
        echo        └───────────────────────────────────────┘
        echo                  %c1%[any key]► Exit%c0%
        echo.

        pause >nul
        exit /b
    )
    
    if defined flag_1 (
            
        for %%v in (!UPG_LIST_%~1!) do (
            for /f "delims=/ tokens=1,2" %%a in ("%%v") do (
                set /a "count_%%a-=curr_need_res_%%b"
            )
        )
        

        if "!lvlWH!"=="2" set /a "lvlWH+=1"

        set /a "lvlWH+=1"
        set /a "nextlvlWH+=1"

        call :Engine_Anim_Progress_Bar " U  P  G  R  A  D  I N G" "U  P  G  R  A  D  E  D" "1500" "1000"

        for /l %%q in (1, 1, !count_needs_res_%~1!) do (
            set "curr_need_res_%%q="
        )
        exit /b
    )
)

call :Cleaner_Flags
exit /b

:Upgrade_Clicker_UI_succes

set "price_CL_curr=%c4%$!price_CL_%~1!.00%c0%"
set "price_CL_curr_txt=!price_CL_curr!!space!"
set "price_CL_curr_txt=!price_CL_curr_txt:~0,20!"

set "flag_1=$!money!.00!space!"
set "flag_1=%c2%!flag_1:~0,11!%c0%"

cls
echo     ₎────────────────────────────────────────────₎
echo     (        -Level Upgrade Contract-            (
echo      )  Dear User,                                )
echo     │                                            │
echo     │      This document confirms that your      │    
echo     │  capital investment has been successfully  │
echo     │                processed.                  │
echo     │                                            │
echo     │  Funds Debited ............. !price_CL_curr_txt!   │ 
echo     │  Remaining Funds ........... !flag_1!   │
echo     │                                            │
echo     │        Thank you for optimizing            │
echo     │          corporate throughput.             │
echo     )                                            )
echo    (                                            (
echo    _) wₑₓᵧₛ ꜀ₒᵣₚ.                               _)
echo   ⁽─────────────────────────────────────────────⁽
echo.
call :Cleaner_Flags
pause >nul

exit /b

:Upgrade_Clicker_UI_error

set "price_CL_curr=%c2%$!price_CL_%~1!.00%c0%"
set "price_CL_curr_txt=!price_CL_curr!!space!"
set "price_CL_curr_txt=!price_CL_curr_txt:~0,20!"

set "flag_1=$!money!.00!space!"
set "flag_1=%c4%!flag_1:~0,11!%c0%"

cls
echo     ₎────────────────────────────────────────────₎
echo     (        -Level Upgrade Contract-            (
echo      )  Dear User,                                )
echo     │                                            │
echo     │  Transaction Declined: Insufficient Funds  │    
echo     │                                            │
echo     │  Investment Amount ......... !price_CL_curr_txt!   │
echo     │  Allocated Funds ........... !flag_1!   │
echo     )                                            )
echo    (                                            (
echo    _) wₑₓᵧₛ ꜀ₒᵣₚ.                                _)
echo   ⁽─────────────────────────────────────────────⁽
echo.
call :Cleaner_Flags
pause >nul

exit /b

:Upgrade_Clicker_UI_menu
call :Cleaner_Flags 

set "price_CL_curr=%c2%$!price_CL_%~1!.00%c0%"
set "price_CL_curr_txt=!price_CL_curr!!space!"
set "price_CL_curr_txt=!price_CL_curr_txt:~0,20!"

cls
echo.
echo     ₎──────────────────────────────────────────₎
echo     (        -Level Upgrade Contract-          (
echo      )                                          )
echo     (     The Signee agrees to outhorize a     (
echo     │      one-time capital investment of      │
echo     │       !price_CL_curr! for immediate asset        │ 
echo     │              optimization.               │
echo     │                                          │
echo     │  Investment Amount ......... !price_CL_curr_txt! │
echo     │                                          │
echo     │  Current Production Tier: [0!lvlCL!]           │
echo     │  Target Production Tier: [0!nextlvlCL!]            │
echo     │                                          │
echo     │  I agree to invest available funds into  │
echo     (       maximizing output efficiency.      (
echo     _)                                         _)
echo   (                          Sign Here: ☐    (
echo    ) wₑₓᵧₛ ꜀ₒᵣₚ.                               )
echo   ⁽───────────────────────────────────────────⁽
echo   %c1%TIP: Upgrading the Workshop to level 2 disables the manual Clicker^!%c0%
echo.
exit /b

:Upgrade_Clicker_Logic

set "curr_price_upgradeCL=!price_CL_%~1!"

choice /c yn /n /m "⠀         Execute this Contract? [Y/N]: "

if errorlevel 2 exit /b
if errorlevel 1 rem -

if !money! GEQ !curr_price_upgradeCL! (
    
    set /a "money-=curr_price_upgradeCL"
    set /a "lvlCL+=1" 
    set /a "nextlvlCL+=1"
    set /a "flag_5=lvlCL %% 2"
    if "!flag_5!"=="0" (
        set /a "click+=1" 
    ) else (
        set /a "ping_click-=500"
    )

    call :Upgrade_Clicker_UI_succes "%~1"
    goto :UPGRADER
) else (
    call :Upgrade_Clicker_UI_error "%~1"
    exit /b
)

:Workshop_UI_menu

call :Cleaner_Flags

if "!lvlWH!"=="4" (
    set "flag_2=f"
    set "flag_4=³"
    set "flag_1=echo            [ 3-Phase Forge ..... 'F' ]"
) else (
    set "flag_3=f"
)

if "!lvlWH!"=="2" set "flag_4=²"
if "!lvlWH!"=="1" set "flag_4=¹"

call :Update_Balance

cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo           [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0% ]
echo           ╔════════════════════════════════════╗
echo           ║       W  O  R  K  S  H  O  P       ║
echo           ╚════════════════════════════════════╝
echo                           ˡᵛˡ !flag_4!
echo.                    
echo            [ Workshop .......... 'W' ]
!flag_1!
echo.
echo            ^< ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ^>   
echo            [ Inventory ......... 'E' ]
echo            [ Recipe Book ....... 'R' ]
echo            [ Menu .............. 'H' ]                 
echo.

choice /c w!flag_2!erhqtyuiopasd!flag_3!gjklzxcvbnm /n

for /l %%q in (4, 1, 7) do (
    set /a "flag_%%q=%%q - 1"
)

set "flag_8="
if defined flag_2 (
    set "flag_8=1"
) else (

    for /l %%q in (4, 1, 7) do (
        set /a "flag_%%q-=1"
    )
)

if errorlevel !flag_7! (
    echo                   %c4%Invalid Choice^^!%c0%            
    timeout /t 1 /nobreak >nul
    goto :Workshop_UI_menu
)   
if errorlevel !flag_6! goto :menu
if errorlevel !flag_5! goto :RECIPE_LISTS_DATA
if errorlevel !flag_4! (
    call :storage
    goto Workshop_UI_menu
)
if defined flag_8 (
    if errorlevel 2 (
        set "flag_4=SpecialCraft"
        exit /b
    )
)
if errorlevel 1 exit /b

:HOME_setting

call :Cleaner_Flags
call :Update_Balance

set "curr_option=4"
set "flag_4=◄"

:HOME

cls
echo.
echo             █████╗  ██╗    ██╗ ██╗     
echo             █╔══██╗ ██║    ██║ ██║     
echo             █████╔╝ ██║ █╗ ██║ ██║     
echo             █╔══██╗ ██║███╗██║ ██║     
echo             █████╔╝ ╚███╔███╔╝ ███████╗
echo             ═════╝   ╚══╝╚══╝  ╚══════╝
echo    ─━═══════════════════════════════════════━─ ─
echo     - B A T C H   W O O D   L E G A C Y v1.2 -
echo.
echo.       
echo        P L A Y !flag_4!
echo.
echo        S A V E  G A M E !flag_3!
echo.
echo        L O A D  G A M E !flag_2!
echo.
echo        E X I T !flag_1!
echo.
echo    %c1%[W] ^& [S]► Up ^& Down  •  [E]► Select Option %c0%
echo.

choice /c ews /n

if "%errorlevel%"=="3" (
    if !curr_option! GTR 1 (
        set /a "curr_option-=1"
    ) else (
        set "curr_option=4"
    )
)
if "%errorlevel%"=="2" (
    if !curr_option! LSS 4 (
        set /a "curr_option+=1"
    ) else (
        set "curr_option=1"
    )
)
if "%errorlevel%"=="1" (
    !execute_%curr_option%!
)



for /l %%q in (1, 1, 4) do (
    if "!curr_option!"=="%%q" (
        set "flag_%%q=◄"
    ) else (
        set "flag_%%q="
    )
)

goto :HOME

:menu
call :Cleaner_Flags

if %lvlWH% LSS 4 (
    set "flag_3=f"
    set "flag_1=[ -LOCKED- .......... '☒' ]"
) else (
    set "flag_2=f"
    set "flag_1=[ Space Center ...... 'F' ]"
)

call :Update_Balance

cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo         [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0% ]
echo           ╔═══════════════════════════════╗
echo           ║         M   E   N   U         ║
echo           ╚═══════════════════════════════╝
echo.                           
echo.                    
echo            [ Workshop .......... 'W' ]
echo            !flag_1!
echo            [ Upgrader .......... 'U' ]
echo.
echo            ^< ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ^>
echo            [ Inventory ......... 'E' ]
echo            [ Clicker ........... 'C' ]
echo            [ Market ............ 'M' ]
echo.
echo            ^< ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ^>
echo            [ Home .............. 'H' ]                 
echo.

choice /c w!flag_2!uecmhqrtyiopasdgjklzxvbn!flag_3! /n

for /l %%q in (4, 1, 9) do (
    set /a "flag_%%q=%%q - 1"
)

set "flag_11="
if not defined flag_2 (
    for /l %%q in (4, 1, 9) do (
        set /a "flag_%%q-=1"
    )
)
if errorlevel !flag_9! (
    echo                   %c4%Invalid Choice^^!%c0%            
    timeout /t 1 /nobreak >nul
    goto :menu
)
if errorlevel !flag_8! (
    goto :HOME_setting
)
if errorlevel !flag_7! goto :market
if errorlevel !flag_6! goto :clicker
if errorlevel !flag_5! (
    call :storage
    goto :menu
)
if errorlevel !flag_4! goto :UPGRADER
if defined flag_2 (
    if errorlevel 2 goto :workshop4
)
if errorlevel 1 goto :Workshop_Hub


:clicker

if !lvlWH! GTR 1 (
    echo                      %c4%LOCKED^^!%c0%
    timeout /t 1 /nobreak >nul
    goto :menu
)

call :Update_Balance

cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo           [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0% ]
echo           ╔═══════════════════════════════╗
echo           ║      C  L  I  C  K  E  R      ║
echo           ╚═══════════════════════════════╝
echo                      ╔═════════╗          
echo                      ║ %c4%┏━━━━━┓%c0% ║
echo                      ║ %c4%┃  %c7%●%c0%  %c4%┃%c0% ║
echo                      ║ %c4%┗━━━━━┛%c0% ║
echo                      ╚═════════╝            
echo                %c1%[B]► Exit • [G]► Click%c0%

choice /c gb /n

if errorlevel 2 (
    cls
    goto :menu
)
if errorlevel 1 (
    set /a money +=%click%
    ping -n 1 -w !ping_click! 127.255.255.255 >nul
    goto clicker
)

:market
call :Update_Balance
set "mr_current_page=1"

cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo           [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0% ]
echo           ╔════════════════════════════════════╗
echo           ║          M  A  R  K  E  T          ║
echo           ╚════════════════════════════════════╝
echo.
echo.               
echo            [ Purchase Resources  'P' ]
echo            [ Sell Items ........ 'S' ]
echo.
echo            ^< ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ^>   
echo            [ Inventory ......... 'E' ]
echo            [ Recipe Book ....... 'R' ]
echo            [ Menu .............. 'H' ]                 
echo.

choice /c pserhqwtyuioadfgjklzxcvbnm /n 
if errorlevel 6 (
    echo                  %c4%Invalid Option^^!%c0%
    timeout /t 1 /nobreak >nul
    goto market
)
if errorlevel 5 goto menu
if errorlevel 4 goto :RECIPE_LISTS_DATA "1"
if errorlevel 3 (
    call :storage
    goto market
)
if errorlevel 2 goto SELL_ITEMS
if errorlevel 1 goto BUY_ITEMS

::----------------------------------------------------------------------------------

:BUY_ITEMS

call :Universal_Engine_For_Market "pay" "1"


::---If player enter wrong input [wrong number item] ►---
call :CACPHA_input_item_number "!mr_product!" "MR/P" 1 "market" "res_mr"

::---If player enter wrong input [wrong amount item] ►---
:NEXT_STEP_MR/P_1

call :CACPHA_input_item_amount "mr_count" "MR/P" 2 "market"

::---Here basic mathematics ►---
:NEXT_STEP_MR/P_2

set /a total_price=!price_%res_mr%! * !mr_count!

if !money! GEQ !total_price! (
    set /a money -= total_price
    set /a count_!res_mr! += mr_count
    
    call :END_COMM "%c2%Purchase successful^!%c0%" 2000 "market"
    ) else (
        call :END_COMM "%c4%Not enough money^!  ^(!money!/!total_price!^)%c0%" 2000 "market"
    )
::------------------------------
:SELL_ITEMS

call :Universal_Engine_For_Market "sell" "!mr_current_page!"


::---If player enter wrong input [wrong number item] ►---
call :CACPHA_input_item_number "!mr_product!" "MR/S" 1 "market" "res_mr"


::---If player enter wrong input [wrong amount item] ►---
:NEXT_STEP_MR/S_1

call :CACPHA_input_item_amount "mr_count" "MR/S" 2 "market"

::---Here basic mathematics ►---
:NEXT_STEP_MR/S_2

set /a total_price=!price_%res_mr%! * !mr_count!

if !count_%res_mr%! GEQ !mr_count! (
    set /a count_%res_mr%-=mr_count
    set /a money+=total_price
    echo %c2%Sale Successful^^!%c0%
    timeout /t 2 /nobreak >nul
    goto market
)

set "selected_item="

if !count_%res_mr%! GTR 0 (
    set "selected_item=!name_%res_mr%!"
) else (
    for /l %%q in (0, 1, 10) do (
        set /a "noise_rdm=!random! %% 8"
        for %%v in (!noise_rdm!) do set "selected_item=!selected_item!!list_noise:~%%v,1!"
    )
)

echo %c4%Not enough !selected_item!  ^(!count_%res_mr%!/!mr_count!^)%c0% 
timeout /t 2 /nobreak >nul
goto market


:UPGRADER

call :Cleaner_Flags

set "idx_flag=0"
for %%i in ("WH/4/[ Upgrade Workshop .. 'W' ]" "CL/4/[ Upgrade Clicker ... 'C' ]") do (
    for /f "delims=/ tokens=1,2,3" %%a in ("%%~i") do (
        set /a "idx_flag+=1"
        
        if "!lvl%%a!"=="%%b" (
            set "flag_!idx_flag!=[ MAX. level ........ '☒' ]"
        ) else (
            set "flag_!idx_flag!=%%c"
        )
    )
)
if not "!lvlCL!"=="4" (
    if !lvlWH! GTR 1 set "flag_2=[ -LOCKED- .......... '☒' ]" 
)


cls
call :Update_Balance

cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo               [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0%]
echo              ╔════════════════════════════════════╗
echo              ║       U  P  G  R  A  D  E  S       ║
echo              ╚════════════════════════════════════╝
echo.
echo               !flag_1!
echo               !flag_2!
echo.
echo               ^< ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ^>   
echo               [ Menu .............. 'H' ]                 
echo.

call :Cleaner_Flags

choice /c wch /n
if errorlevel 3 goto menu
if errorlevel 2 goto :UPGRADER_CL
if errorlevel 1 rem -

::---Upgrade Hub---

if "!lvlWH!"=="4" goto :MAXLVLWH

call :Render_UpgradeMenu_UI "!lvlWH!"

call :Logic_UpgradeSystem "!lvlWH!"

goto :UPGRADER

:MAXLVLWH
echo                        %c4%MAX LEVEL^!%c0%

timeout /t 1 /nobreak >nul
goto UPGRADER

::----------------------------------------
:UPGRADER_CL
call :Cleaner_Flags

if "!lvlCL!"=="4" set "flag_1=MAX LEVEL^!"
if !lvlWH! GTR 1 set "flag_1= LOCKED^!"

if defined flag_1 goto :MAXLVLCL

call :Upgrade_Clicker_UI_menu !lvlCL!

call :Upgrade_Clicker_Logic !lvlCL!

goto :UPGRADER

:MAXLVLCL
echo                        %c4%!flag_1!%c0%

timeout /t 1 /nobreak >nul
goto :UPGRADER

:storage
cls
setlocal enabledelayedexpansion

for %%a in (%INV_LIST%) do (
    if !count_%%a! GTR 0 (

        set "rar=!rarity_%%a!"
        set /a "count_items_!rar!+=1"
        for /f %%v in ("!rar!") do set "index_tmp=!count_items_%%v!"
        set storage=1

        set "pad1=37"
        if !rarity_%%a! GTR 1 (
            set /a "pad1+=9"
        )
        
        if "!rar!"=="1" set "item_name_tmp=!ic1! !name_%%a!"
        if "!rar!"=="2" set "item_name_tmp=%c3%!ic2! !name_%%a!%c0%"
        if "!rar!"=="3" set "item_name_tmp=%c5%!ic3! !name_%%a!%c0%"
        if "!rar!"=="4" set "item_name_tmp=%c6%!ic4! !name_%%a!%c0%"
        
        set "item=!item_name_tmp!: %c7%!count_%%a!!space!"
        for /f "delims=" %%v in ("!pad1!") do set "txtitem_!index_tmp!_!rar!=!item:~0,%%v!%c0%"
    )
)

for /l %%q in (1, 1, 4) do (
    set "max_index=!count_items_%%q!"

    if not "!max_index!"=="" (
        for /l %%n in (1, 1, !max_index!) do (
            set /a "global_index+=1"
            set "global_item_!global_index!=!txtitem_%%n_%%q!"
        )
    )
)

if "!storage!"=="1" (
    call :Update_Balance
    cls
    echo %c1%!current_version! ░ !time:~0,5!%c0%
    echo.
    echo                    [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0%]
    echo              ╔══════════════════════════════════════════════╗
    echo              ║       I   N   V   E   N   T   O   R   Y      ║
    echo              ╚══════════════════════════════════════════════╝

    for /l %%i in (1, 2, !global_index!) do (
        
        set line1=!global_item_%%i!
        set /a next_counter=%%i+1        

        if !next_counter! LEQ !global_index! (
        
            for %%v in (!next_counter!) do set "line2=│ !global_item_%%v!"
            set "flag_3=┌─────────────────────────────────┐"
            set "flag_4=└─────────────────────────────────┘"
            set "OP=│"
        
        ) else (
            set "flag_3="
            set "flag_4="
            set "line2=!space:~0,30!"
            set "OP="
        )

        if defined line2 set "line2=!line2:"=!"
        echo     ┌─────────────────────────────────┐!flag_3!
        echo     │ !line1:"=!│!line2!!OP!
        echo     └─────────────────────────────────┘!flag_4!
    )
) else (
    echo Zero signals in this sector...
)
call :Cleaner_Flags

echo                               %c1%[Any key]► Exit%c0%
pause >nul

endlocal
exit /b

:Workshop_Hub
call :Cleaner_Flags

call :Workshop_UI_menu

::---System Craft---

if "!flag_4!"=="SpecialCraft" (
    set "flag_1=1"
    set "flag_3= !res3!!m3count!"
    set "flag_2=!lvlWH!"
) else (
    if "!lvlWH!"=="4" (
        set "flag_2=3"
    ) else (
        set "flag_2=!lvlWH!"
    )
)

call :CR_ALL 1 "first" !flag_2!
call :CR_ALL 2 "second" !flag_2!

if defined flag_1 call :CR_ALL 3 "third" !flag_2!

if !lvlWH! GEQ 3 (
    set "unsorted=!res1!!m1count! !res2!!m2count!!flag_3!"

    set "recipe="
    (
        for %%j in (!unsorted!) do echo %%j
    ) > "%temp%\unsorted_craft.tmp"

    for /f "delims=" %%a in ('sort "%temp%\unsorted_craft.tmp"') do (
        set "recipe=!recipe!%%a"
    )

    del "%temp%\unsorted_craft.tmp" >nul 2>nul
) else (
    set "recipe=%res1%%m1count%%res2%%m2count%"
)

cls
call :craftsystem !flag_1!

::----------------------------------------

:buy_flashdrive
cls
call :Cleaner_Flags

if !money! GEQ 5000 (
    set "flag_1=true"
    set /a "money-=5000"
    set "have_flashdrive=1"
) else (
    set "flag_1=false"
)

echo.
call :Render_Msg "!txt_node_buyFD_%flag_1%!" "4" "SpaceDelay-true" "BeginTxt-true" "%c7%GABE%c0%:" "1"

echo.
echo.
echo     [any key]► Exit
echo.

pause >nul

goto :menu

:buy_flashdrive_dialogue
cls

set "curr_txt=!txt_node_%curr_node%!"
set "curr_ans1=!ans1_node_%curr_node%!"
set "curr_ans2=!ans2_node_%curr_node%!"

echo.
call :Render_Msg "!curr_txt!" "4" "SpaceDelay-true" "BeginTxt-true" "%c7%GABE%c0%:" "1"
echo.
echo.
echo     [1]► !curr_ans1!
echo   ◄ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ►
echo     [2]► !curr_ans2!
echo.

choice /c 12 /n

if errorlevel 2 (
    if defined execute2_node_!curr_node! (
        !execute2_node_%curr_node%!
    ) else (
        set "curr_node=!goto2_node_%curr_node%!"
    )
) else (
    if errorlevel 1 (
        if defined execute1_node_!curr_node! (
        !execute1_node_%curr_node%!
        ) else (
            set "curr_node=!goto1_node_%curr_node%!"
        )
    )
)

goto :buy_flashdrive_dialogue


:workshop4


if !lvlWH! LSS 4 (
    echo                     %c4%LOCKED^^!%c0%            
    timeout /t 1 /nobreak >nul
    goto :menu
)

call :Cleaner_Flags
call :Update_Balance

cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo               [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0% ]
echo           ╔═══════════════════════════════════════════╗
echo           ║     S  P  A  C  E    C  E  N  T  E  R     ║
echo           ╚═══════════════════════════════════════════╝
echo.
echo.                    
echo            [ Assembly Bay ...... 'A' ]
echo            [ LaunchPad ......... 'L' ]
echo.
echo            ^< ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ^>   
echo            [ Use flash Drive ... 'R' ]
echo            [ Inventory ......... 'E' ]
echo            [ Menu .............. 'H' ]                 
echo.

choice /c alrehqwtyuiopsdfgjkzxcvbnm /n

if errorlevel 6 (
    echo                   %c4%Invalid Choice^^!%c0%            
    timeout /t 1 /nobreak >nul
    goto :workshop4
)
if errorlevel 5 goto :menu
if errorlevel 4 (
    call :storage
    goto :workshop4
)
if errorlevel 3 goto :recipe_rocket
if errorlevel 2 goto :LAUNCH_ROCKET
if errorlevel 1 goto :crFINAL


:recipe_rocket

cls
if !count_flashdrive! GTR 0 (
    set "flag_2=>"
    set "flag_1=!RANDOM!"

    echo. 
    echo TECH.Protocol #00!flag_1! = "item.Rocket.DisplayRecipe"
    echo GAME.DATA.ENGINE !flag_2! R E C I P E   R O C K E T.txt
    echo Protocol #00!flag_1! !flag_2! GAME.DATA.Engine
    echo.
    echo.
    echo.
    echo                                  R E C I P E   R O C K E T
    echo.
    echo        -!nameCR5_rocketengine1fueltank2rockethull1controlpanel1solarpanel1!-
    echo        ---------------------------------------------------------------------------------------
    echo                                 %c1%[any key]► Eject Flash Drive%c0%
    pause >nul
) else (
    echo.
    echo                        %c4%RECIPE IS NOT DEFINED^^!%c0%
    echo.
    echo        Rumor has it there's a craftable recipe on a flash drive...
    echo        -----------------------------------------------------------
    echo            %c1%[any key]► Back  •  [P]► Buy Flash Drive recipe%c0%

    set /p "flag_3= "

    if /i "!flag_3!"=="P" (
        set "curr_node=1"
        goto :buy_flashdrive_dialogue 
    )
)
goto :workshop4


:crFINAL
call :CR_ALL 1 "first" 5 "FNmod"
call :CR_ALL 2 "second" 5 "FNmod"
call :CR_ALL 3 "third" 5 "FNmod"
call :CR_ALL 4 "fourth" 5 "FNmod"
call :CR_ALL 5 "fifth" 5 "FNmod"


set "recipe=!res1!!m1count!!res2!!m2count!!res3!!m3count!!res4!!m4count!!res5!!m5count!"

call :craftsystem 1 1 1 "FNmod"
::============================================= ○●
:LAUNCH_ROCKET
if "!count_rocket!"=="0" (

    echo                     %c4%LOCKED^^!
    echo                  Build a rocket^^!%c0%

    timeout /t 1 /nobreak >nul
    goto workshop4
)

set "flag_2=0"
for /l %%q in (1, 1, 5) do (
    if "!button%%q!"=="1" (
        set /a "flag_2+=1"
        set "display_button%%q=%c2%●%c0%"
    ) else (
        set "display_button%%q=%c4%●%c0%"
    )
)

call :Update_Balance
cls
echo %c1%!current_version! ░ !time:~0,5!%c0%
echo.
echo              [ BALANCE: !balance_player! ] [ STATUS: %c3%USER%c0% ]
echo           ╔═══════════════════════════════════════════╗
echo           ║   C  O  N  T  R  O  L    P  A  N  E  L    ║
echo           ╚══╤═════════════════════════════════════╤══╝
echo              │                                     │
for %%i in ("1/Fuel Propulsion System" "2/Test Main Engines" "3/Calibrate Control Panel" "4/Check Hull Integrity" "5/Boot Navigation Matrix") do (
    for /f "delims=/ tokens=1,2" %%a in ("%%~i") do (
    
    set "launch_status_msg=%%b!space!"
    set "launch_status_msg=!launch_status_msg:~0,23!"

    echo              │  !display_button%%a!  [ %%a ]► !launch_status_msg!  │
    echo              │                                     │
    )
)
echo              │             [L]► LAUNCH             │
echo              └─────────────────────────────────────┘
echo.     


choice /c 12345l /n

if errorlevel 6 (
    if "!flag_2!"=="5" (
        goto :Anim_Launch_Rocket
    ) else (
        echo                           %c4%LAUNCH DENIED
        echo                         ˢʸˢᵗᵉᵐˢ ⁱⁿᶜᵒᵐˡᵉᵗᵉ%c0%
        timeout /t 2 /nobreak >nul
        goto :LAUNCH_ROCKET
    ) 
) 
for %%i in ("5/ M  A  P  P  I  N  G/  M  A  P  P  E  D/500" "4/I N S P E C T I N G/ I N S P E C T E D/750" "3/C A L I B R A T I N G/C A L I B R A T E D/300" "2/ P  U  R  G  I  N  G/  P  U  R  G  E  D/400" "1/  F  U  E  L  I  N  G/   F  U  E  L  E  D/1000") do (
    for /f "delims=/ tokens=1-4" %%a in ("%%~i") do (
        if errorlevel %%a (
            call :Engine_Anim_Progress_Bar "%%b" "%%c" "%%d" 1500
            set "button%%a=1"
            goto :LAUNCH_ROCKET
        )        
    )
)

:Anim_Launch_Rocket



for /l %%q in (10, -1, 0) do (
    
    if not "%%q"=="0" (
        set "flag_1=   %%q!space!"
        set "flag_1=!flag_1:~0,8!"        
    ) else (
        set "flag_1=LIFTOFF^!"
    )


    echo                   │    │
    echo                 ╔═╧════╧═╗
    echo                 ║!flag_1!║
    echo                 ╚════════╝
    echo.                         
    echo                     ╭│╮
    echo                     ╱│╲  
    echo                    ╱ ● ╲
    echo                   ╱_____╲
    echo                  ╱       ╲  
    echo                  │   ○   │
    echo                  │   ○   │   
    echo                  │   ○   │
    echo                  │       │
    echo                  │       │
    echo                 /│       │\
    echo                 █│       │█
    echo                ▲▼╰───┰───╯▼▲
    echo                █     ▲     █
    echo                ▼           ▼
    echo       ╔═══════════════════════════════╗
    echo       ╚═╤══╤════════╤═══╤════════╤══╤═╝
    echo        ╱  ╱         │   │         ╲  ╲
    echo       ╱  ╱          │   │          ╲  ╲
    echo  ▀▐░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▌▄

    timeout /t 1 /nobreak >nul
    cls
)

set "base_height=35"
set "flag_1="
set "flag_4=0"
set "flag_3=1000"

for /l %%a in (!base_height!, -1, 0) do (
    
    if %%a GTR 0 (
        for /l %%c in (1, 1, %%a) do echo.
    )
    if defined flag_1 (
        set "flag_2=0"
        set /a "flag_2=%%a %% 2"
        if "!flag_2!"=="0" (
            set "fire_engine_2=echo                     /▒\"
            set "fire_engine_3=echo                     ▒▓▒"
            set "fire_engine_4=echo                     ▼▓▼"
        ) else (
            set "fire_engine_2=echo                     ◄▒►"
            set "fire_engine_3=echo                     ▒▓▒"
            set "fire_engine_4=echo                     \▓/"
        )
    ) else (
        if "%%a"=="35" (
            set "fire_engine_1=echo                ▼           ▼"
        )

        if "%%a"=="34" (
            set "fire_engine_1=echo         ░ ░    ▼     ▓     ▼    ░ ░"
            set "fire_engine_2=echo             ▒▒►_____◄╩►_____◄▒▒"       
        )

        if "%%a"=="33" (
            set "fire_engine_1=echo                ▼     ▓     ▼"
            set "fire_engine_2=echo                     /╩\"
            set "fire_engine_3=echo               ░►__◄▄▓▓▓▄►__◄░"
        )
        if "%%a"=="32" (
            set "fire_engine_1=echo                ▼     ▓     ▼"
            set "fire_engine_2=echo                     /╩\ "
            set "fire_engine_3=echo                     ▓▓▓"
            set "fire_engine_4=echo                  \_◄▓▓▓►_/"
            set "flag_1=1"
        )
    )

    if %%a LSS 31 (
        set /a "flag_4=%%a %% 10"
        if "!flag_4!"=="0" set /a "flag_3-=200"
    )
    
    echo                     ╭│╮
    echo                     ╱│╲  
    echo                    ╱ ● ╲
    echo                   ╱_____╲
    echo                  ╱       ╲  
    echo                  │   ○   │
    echo                  │   ○   │   
    echo                  │   ○   │
    echo                  │       │
    echo                  │       │
    echo                 /│       │\
    echo                 █│       │█
    echo                ▲▼╰───┰───╯▼▲
    echo                █     ▲     █
    !fire_engine_1!
    !fire_engine_2!
    !fire_engine_3!
    !fire_engine_4!

    set /a "RDO=base_height - %%a"
    if !RDO! GTR 3 (
        for /l %%b in (1, 1, !RDO!) do echo.
    )
    echo       ╔═══════════════════════════════╗
    echo       ╚═╤══╤════════╤═══╤════════╤══╤═╝
    echo        ╱  ╱         │   │         ╲  ╲
    echo       ╱  ╱          │   │          ╲  ╲
    echo  ▀▐░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▌▄

    ping -n 1 -w !flag_3! 127.255.255.255 >nul
    echo %ESC%[H%ESC%[2J

    if %%a==0 goto :CREDITS
)

:CREDITS

cls
echo.
echo     ┌───────────────────────────────────────┐
echo     │   T H A N K S  F O R  P L A Y I N G   │
echo     └───────────────────────────────────────┘
echo.
call :Render_Msg "The rocket sailed far beyond the stars..." "4" "SpaceDelay-true" "BeginTxt-false" 
echo.
pause >nul
    
cls
echo.
echo     ┌─────────────────────┐
echo     │  D E V E L O P E R  │
echo     └─────────────────────┘
echo.       
echo      -Game design ^& -Logic ^[15eyk_45Hy^]
echo      -Proramming ^[15eyk_45Hy^]
echo      -Story ^& -Lore ^[15eyk_45Hy^]:)
echo.
echo      Engine of game - Windows^[10^] Batch
echo.
echo.
echo      Press any key to release the ship to the distant stars...
pause >nul

cls
echo      15eyk_45Hy....This is not.. the end...
pause >nul
exit
