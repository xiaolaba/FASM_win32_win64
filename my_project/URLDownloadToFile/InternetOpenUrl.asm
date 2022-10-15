;; https://wiremask.eu/articles/download-execute-assembly-x86/
;; InternetOpenUrl
;; xiaolaba, testing, 2022-OCT-15

format PE GUI 4.0
entry main

;include 'include/win32a.inc'
include 'win32a.inc'

section '.code' code readable executable
main:
    ; Initialize internal data structures
    invoke InternetOpen, szURL, 0, 0, 0, 0
    mov dword [hInternet], eax
    test eax, eax
    jz exit

    ; Open a resource specified by szURL
    invoke InternetOpenUrl, dword [hInternet], szURL, 0, 0, 0, 0
    mov dword [hUrl], eax
    test eax, eax
    jz exit

    ; Create a file stream
    invoke CreateFile, szFileName, GENERIC_WRITE,FILE_SHARE_WRITE, 0, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, 0
    mov dword [hFile], eax
    test eax, eax
    jz exit

readnextbytes:
    ; Read data from hUrl opened by the InternetOpenUrl
    invoke InternetReadFile, dword [hUrl], lpBuffer, dwNumberOfBytesToRead, lpdwNumberOfBytesRead
    invoke CloseHandle, dword [hUrl]

    ; Write data to szFileName
    invoke WriteFile, dword [hFile], lpBuffer, dword [lpdwNumberOfBytesRead], lpNumberOfBytesWritten, 0

    cmp dword [lpdwNumberOfBytesRead], 0
    jnz readnextbytes

downloadcomplete:
    invoke CloseHandle, dword [hFile]
    invoke InternetCloseHandle, dword [hUrl]
    invoke InternetCloseHandle, dword [hInternet]
    invoke ShellExecute, 0, 0, szFileName, 0, 0, SW_SHOW

exit:
    invoke ExitProcess, 0

section '.idata' import data readable
library kernel, 'kernel32.dll',\
        wininet, 'wininet.dll',\
        shell32, 'shell32.dll'

import kernel,\
    WriteFile, 'WriteFile',\
    CreateFile, 'CreateFileA',\
    CloseHandle, 'CloseHandle',\
    ExitProcess, 'ExitProcess'

import wininet,\
    InternetOpen, 'InternetOpenA',\
    InternetOpenUrl, 'InternetOpenUrlA',\
    InternetReadFile, 'InternetReadFile',\
    InternetCloseHandle, 'InternetCloseHandle'

import shell32,\
    ShellExecute, 'ShellExecuteA'

section '.data' data readable writeable
;;szFileName db 'index.htm', 0
;;szURL      db 'http://wiremask.eu/', 0

;; change to test google web
szFileName db 'index.html', 0
szURL      db 'https://www.google.com/', 0

    hInternet              dd ?
    hUrl                   dd ?
    hFile                  dd ?
    lpdwNumberOfBytesRead  dd ?
    lpBuffer               rb 400h
    dwNumberOfBytesToRead = $ - lpBuffer
    lpNumberOfBytesWritten dd ?
	
	
