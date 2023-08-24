@echo off
setlocal EnableDelayedExpansion

set "decimal=%~1"

set "binary="
for /l %%i in (15,-1,0) do (
    set /a "bit=decimal >> %%i & 1"
    set "binary=!binary!!bit!"
)

echo %binary%
