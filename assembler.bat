:: *********************************************************
:: *     Assembler program for Heza 1 16-bit Processor     *
:: *                                                       *
:: *              Developed by <franzageek>                *
:: *                                                       *
:: * This assembler was developed for the Heza 1 CPU only, *
:: *      and will not work with other processors.         *
:: *                                                       *
:: *  This code is licensed to you under the terms of the  *
:: * MIT License, for further details see the GitHub repo. *
:: *                                                       *
:: *  Discover Heza 1 at "github.com/franzageek/heza-cpu"  *
:: *********************************************************

@echo off
@chcp 65001>nul 2>&1
set binconv=%~dp0lib\binconv.bat
set hexconv=%~dp0lib\hexconv.bat
title CUPRA Heza 1 Assembler v1.00
echo.
echo     ╔═══════════════════════════════════════════╗
echo     ║       CUPRA Heza 1 16-bit Processor       ║
echo     ║                                           ║
echo     ║          Assembler Program v1.00          ║
echo     ╠═══════════════════════════════════════════╣
echo     ║         Developed by ^<franzageek^>         ║
echo     ╚═══════════════════════════════════════════╝
echo.
if "%~1"=="" (
	echo     FATAL ERROR! No input file specified, halting.
	exit /b
)
if "%~1"==" " (
	echo     FATAL ERROR! No input file specified, halting.
	exit /b
)
if not exist "%~dpnx1" (
	echo     FATAL ERROR! The specified input file does not exist, halting
	exit /b
)
echo     Reading "%~dpnx1" file...
for /l %%a in (0,1,20000) do (
	rem Waiting
)
echo     Preparing to assemble the program...
for /l %%a in (0,1,27500) do (
	rem Waiting
)
echo v2.0 raw>"heza_assembler.hez"
echo.>>"heza_assembler.hez"
echo     Compiling...

::  **********************************************
::  **       Instruction identifying part       **
::  **********************************************

set /a cnt=0
for /F "tokens=1-30 delims=,+-./: " %%a in ('type "%~dpnx1"') do (
	set /a cnt=%cnt%+1
	rem General purpose instructions
	if /i "%%a"=="mov" (
		set "srcreg=%%b"
		set "dstreg=%%c"
		call :mov_decode 
		set srcreg=
		set dstreg=
	)
	if /i "%%a"=="data" (
		set "data=%%b"
		set "dstreg=%%c"
		call :data_decode 
		set data=
		set dstreg=
	)
	if /i "%%a"=="ld" (
		set "srcaddr=%%b"
		set "dstreg=%%c"
		call :ld_decode
		set srcaddr=
		set dstreg=
	)
	if /i "%%a"=="str" (
		set "srcreg=%%b"
		set "dstaddr=%%c"
		call :str_decode
		set srcreg=
		set dstaddr=
	)
	
	rem ALU operations
	if /i "%%a"=="add" (
		set "first_input_reg=%%b"
		set "second_input_reg=%%c"
		call :add_decode 
		set first_input_reg=
		set second_input_reg=
	)
	if /i "%%a"=="sub" (
		set "first_input_reg=%%b"
		set "second_input_reg=%%c"
		call :sub_decode 
		set first_input_reg=
		set second_input_reg=
	)
	if /i "%%a"=="mul" (
		set "first_input_reg=%%b"
		set "second_input_reg=%%c"
		call :mul_decode 
		set first_input_reg=
		set second_input_reg=
	)
	if /i "%%a"=="div" (
		set "first_input_reg=%%b"
		set "second_input_reg=%%c"
		call :div_decode 
		set first_input_reg=
		set second_input_reg=
	)
	if /i "%%a"=="shl" (
		set "selreg=%%b"
		call :shl_decode 
		set selreg=
	)
	if /i "%%a"=="shr" (
		set "selreg=%%b"
		call :shr_decode 
		set selreg=
	)
	if /i "%%a"=="not" (
		set "selreg=%%b"
		call :not_decode 
		set selreg=
	)
	if /i "%%a"=="and" (
		set "first_input_reg=%%b"
		set "second_input_reg=%%c"
		call :and_decode 
		set first_input_reg=
		set second_input_reg=
	)
	if /i "%%a"=="or" (
		set "first_input_reg=%%b"
		set "second_input_reg=%%c"
		call :or_decode 
		set first_input_reg=
		set second_input_reg=
	)
	if /i "%%a"=="xor" (
		set "first_input_reg=%%b"
		set "second_input_reg=%%c"
		call :xor_decode 
		set first_input_reg=
		set second_input_reg=
	)
	
	rem Circuit management instructions
	if /i "%%a"=="clreg" (
		set "selreg=%%b"
		call :clreg_decode 
		set selreg=
	)
	if /i "%%a"=="end" (
		call :end_decode 
	)
	
	rem Exceptions
	if /i "%%a"==";" (
		rem Skip
	)
)
echo     Done assembling the program.
for /l %%a in (0,1,20000) do (
	rem Waiting
)
echo     Saving program to output file "%~n1.hez"...
rename "heza_assembler.hez" "%~n1.hez"
echo     Done!
set cnt=
exit /b


::  *********************************************
::  ** Instruction decoding and compiling part **
::  *********************************************


rem General purpose instructions decoding section 
:mov_decode
	if /i "%srcreg%"=="R0" (
		set "binsrc=00"
	)
	if /i "%srcreg%"=="R1" (
		set "binsrc=01"
	)
	if /i "%srcreg%"=="R2" (
		set "binsrc=10"
	)
	if /i "%srcreg%"=="R3" (
		set "binsrc=11"
	)

	if /i "%dstreg%"=="R0" (
		set "bindst=00"
	)
	if /i "%dstreg%"=="R1" (
		set "bindst=01"
	)
	if /i "%dstreg%"=="R2" (
		set "bindst=10"
	)
	if /i "%dstreg%"=="R3" (
		set "bindst=11"
	)

	set "bininstr=000000000000%binsrc%%bindst%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof

:data_decode
	set hexdata=%data%

	if /i "%dstreg%"=="R0" (
		set "bindst=00"
	)
	if /i "%dstreg%"=="R1" (
		set "bindst=01"
	)
	if /i "%dstreg%"=="R2" (
		set "bindst=10"
	)
	if /i "%dstreg%"=="R3" (
		set "bindst=11"
	)

	set "bininstr=000000000000%bindst%%bindst%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	echo %hexdata%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set hexdata=
	set bindst=
	goto :eof

:ld_decode
	if /i "%srcaddr%"=="R0" (
		set "binsrc=00"
	)
	if /i "%srcaddr%"=="R1" (
		set "binsrc=01"
	)
	if /i "%srcaddr%"=="R2" (
		set "binsrc=10"
	)
	if /i "%srcaddr%"=="R3" (
		set "binsrc=11"
	)

	if /i "%dstreg%"=="R0" (
		set "bindst=00"
	)
	if /i "%dstreg%"=="R1" (
		set "bindst=01"
	)
	if /i "%dstreg%"=="R2" (
		set "bindst=10"
	)
	if /i "%dstreg%"=="R3" (
		set "bindst=11"
	)

	set "bininstr=000000100000%binsrc%%bindst%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof

:str_decode
	if /i "%srcreg%"=="R0" (
		set "binsrc=00"
	)
	if /i "%srcreg%"=="R1" (
		set "binsrc=01"
	)
	if /i "%srcreg%"=="R2" (
		set "binsrc=10"
	)
	if /i "%srcreg%"=="R3" (
		set "binsrc=11"
	)

	if /i "%dstaddr%"=="R0" (
		set "bindst=00"
	)
	if /i "%dstaddr%"=="R1" (
		set "bindst=01"
	)
	if /i "%dstaddr%"=="R2" (
		set "bindst=10"
	)
	if /i "%dstaddr%"=="R3" (
		set "bindst=11"
	)

	set "bininstr=000000110000%binsrc%%bindst%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof

rem ALU operations decoding section
:add_decode
	if /i "%first_input_reg%"=="R0" (
		set "bindst=00"
	)
	if /i "%first_input_reg%"=="R1" (
		set "bindst=01"
	)
	if /i "%first_input_reg%"=="R2" (
		set "bindst=10"
	)
	if /i "%first_input_reg%"=="R3" (
		set "bindst=11"
	)

	if /i "%second_input_reg%"=="R0" (
		set "binsrc=00"
	)
	if /i "%second_input_reg%"=="R1" (
		set "binsrc=01"
	)
	if /i "%second_input_reg%"=="R2" (
		set "binsrc=10"
	)
	if /i "%second_input_reg%"=="R3" (
		set "binsrc=11"
	)

	set "bininstr=000001000000%bindst%%binsrc%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
:sub_decode
	if /i "%first_input_reg%"=="R0" (
		set "bindst=00"
	)
	if /i "%first_input_reg%"=="R1" (
		set "bindst=01"
	)
	if /i "%first_input_reg%"=="R2" (
		set "bindst=10"
	)
	if /i "%first_input_reg%"=="R3" (
		set "bindst=11"
	)

	if /i "%second_input_reg%"=="R0" (
		set "binsrc=00"
	)
	if /i "%second_input_reg%"=="R1" (
		set "binsrc=01"
	)
	if /i "%second_input_reg%"=="R2" (
		set "binsrc=10"
	)
	if /i "%second_input_reg%"=="R3" (
		set "binsrc=11"
	)

	set "bininstr=000001000001%bindst%%binsrc%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
:mul_decode
	if /i "%first_input_reg%"=="R0" (
		set "bindst=00"
	)
	if /i "%first_input_reg%"=="R1" (
		set "bindst=01"
	)
	if /i "%first_input_reg%"=="R2" (
		set "bindst=10"
	)
	if /i "%first_input_reg%"=="R3" (
		set "bindst=11"
	)

	if /i "%second_input_reg%"=="R0" (
		set "binsrc=00"
	)
	if /i "%second_input_reg%"=="R1" (
		set "binsrc=01"
	)
	if /i "%second_input_reg%"=="R2" (
		set "binsrc=10"
	)
	if /i "%second_input_reg%"=="R3" (
		set "binsrc=11"
	)

	set "bininstr=000001000010%bindst%%binsrc%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
:div_decode
	if /i "%first_input_reg%"=="R0" (
		set "bindst=00"
	)
	if /i "%first_input_reg%"=="R1" (
		set "bindst=01"
	)
	if /i "%first_input_reg%"=="R2" (
		set "bindst=10"
	)
	if /i "%first_input_reg%"=="R3" (
		set "bindst=11"
	)

	if /i "%second_input_reg%"=="R0" (
		set "binsrc=00"
	)
	if /i "%second_input_reg%"=="R1" (
		set "binsrc=01"
	)
	if /i "%second_input_reg%"=="R2" (
		set "binsrc=10"
	)
	if /i "%second_input_reg%"=="R3" (
		set "binsrc=11"
	)

	set "bininstr=000001000011%bindst%%binsrc%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
:shl_decode
	if /i "%selreg%"=="R0" (
		set "bindst=00"
	)
	if /i "%selreg%"=="R1" (
		set "bindst=01"
	)
	if /i "%selreg%"=="R2" (
		set "bindst=10"
	)
	if /i "%selreg%"=="R3" (
		set "bindst=11"
	)


	set "bininstr=000001000100%bindst%00"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
:shr_decode
	if /i "%selreg%"=="R0" (
		set "bindst=00"
	)
	if /i "%selreg%"=="R1" (
		set "bindst=01"
	)
	if /i "%selreg%"=="R2" (
		set "bindst=10"
	)
	if /i "%selreg%"=="R3" (
		set "bindst=11"
	)


	set "bininstr=000001000101%bindst%00"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
:not_decode
	if /i "%selreg%"=="R0" (
		set "bindst=00"
	)
	if /i "%selreg%"=="R1" (
		set "bindst=01"
	)
	if /i "%selreg%"=="R2" (
		set "bindst=10"
	)
	if /i "%selreg%"=="R3" (
		set "bindst=11"
	)


	set "bininstr=000001000110%bindst%00"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
:and_decode
	if /i "%first_input_reg%"=="R0" (
		set "bindst=00"
	)
	if /i "%first_input_reg%"=="R1" (
		set "bindst=01"
	)
	if /i "%first_input_reg%"=="R2" (
		set "bindst=10"
	)
	if /i "%first_input_reg%"=="R3" (
		set "bindst=11"
	)

	if /i "%second_input_reg%"=="R0" (
		set "binsrc=00"
	)
	if /i "%second_input_reg%"=="R1" (
		set "binsrc=01"
	)
	if /i "%second_input_reg%"=="R2" (
		set "binsrc=10"
	)
	if /i "%second_input_reg%"=="R3" (
		set "binsrc=11"
	)

	set "bininstr=000001000111%bindst%%binsrc%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
:or_decode
	if /i "%first_input_reg%"=="R0" (
		set "bindst=00"
	)
	if /i "%first_input_reg%"=="R1" (
		set "bindst=01"
	)
	if /i "%first_input_reg%"=="R2" (
		set "bindst=10"
	)
	if /i "%first_input_reg%"=="R3" (
		set "bindst=11"
	)

	if /i "%second_input_reg%"=="R0" (
		set "binsrc=00"
	)
	if /i "%second_input_reg%"=="R1" (
		set "binsrc=01"
	)
	if /i "%second_input_reg%"=="R2" (
		set "binsrc=10"
	)
	if /i "%second_input_reg%"=="R3" (
		set "binsrc=11"
	)

	set "bininstr=000001001000%bindst%%binsrc%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
:xor_decode
	if /i "%first_input_reg%"=="R0" (
		set "bindst=00"
	)
	if /i "%first_input_reg%"=="R1" (
		set "bindst=01"
	)
	if /i "%first_input_reg%"=="R2" (
		set "bindst=10"
	)
	if /i "%first_input_reg%"=="R3" (
		set "bindst=11"
	)

	if /i "%second_input_reg%"=="R0" (
		set "binsrc=00"
	)
	if /i "%second_input_reg%"=="R1" (
		set "binsrc=01"
	)
	if /i "%second_input_reg%"=="R2" (
		set "binsrc=10"
	)
	if /i "%second_input_reg%"=="R3" (
		set "binsrc=11"
	)

	set "bininstr=000001001001%bindst%%binsrc%"
	for /f %%a in ('%hexconv% %bininstr%') do (
		set "hexinstr=%%a"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set bininstr=
	set hexinstr=
	set binsrc=
	set bindst=
	goto :eof
	
rem Circuit management instructions
:clreg_decode
	if /i "%selreg%"=="R0" (
		set "hexinstr=0700"
	)
	if /i "%selreg%"=="R1" (
		set "hexinstr=0701"
	)
	if /i "%selreg%"=="R2" (
		set "hexinstr=0702"
	)
	if /i "%selreg%"=="R3" (
		set "hexinstr=0703"
	)
	echo %hexinstr%>>"heza_assembler.hez"
	set hexinstr=
	goto :eof
	
:end_decode
	echo aaaa>>"heza_assembler.hez"
	goto :eof