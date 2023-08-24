@echo off
setlocal EnableDelayedExpansion

set "binary=%~1"

set "hex="
for /L %%i in (0,4,12) do (
    set "chunk=!binary:~%%i,4!"
    if "!chunk!" equ "0000" (set "hex=!hex!0") else (
        if "!chunk!" equ "0001" (set "hex=!hex!1") else (
        if "!chunk!" equ "0010" (set "hex=!hex!2") else (
        if "!chunk!" equ "0011" (set "hex=!hex!3") else (
        if "!chunk!" equ "0100" (set "hex=!hex!4") else (
        if "!chunk!" equ "0101" (set "hex=!hex!5") else (
        if "!chunk!" equ "0110" (set "hex=!hex!6") else (
        if "!chunk!" equ "0111" (set "hex=!hex!7") else (
        if "!chunk!" equ "1000" (set "hex=!hex!8") else (
        if "!chunk!" equ "1001" (set "hex=!hex!9") else (
        if "!chunk!" equ "1010" (set "hex=!hex!a") else (
        if "!chunk!" equ "1011" (set "hex=!hex!b") else (
        if "!chunk!" equ "1100" (set "hex=!hex!c") else (
        if "!chunk!" equ "1101" (set "hex=!hex!d") else (
        if "!chunk!" equ "1110" (set "hex=!hex!e") else (
        if "!chunk!" equ "1111" (set "hex=!hex!f")
    )))))))))))))))
)

echo !hex!
