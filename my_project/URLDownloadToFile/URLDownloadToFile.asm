
;; https://wiremask.eu/articles/download-execute-assembly-x86/
;; xiaolaba, testing, 2022-OCT-15

format PE GUI 4.0
entry main

;include 'include/win32a.inc'
include 'win32a.inc'

section '.text' code readable executable
main:
    invoke URLDownloadToFile, 0, szURL, szFileName, 0, 0
    invoke ShellExecute, 0, 0, szFileName, 0, 0, SW_SHOW
    invoke ExitProcess, 0

section '.idata' import data readable
library kernel32, 'kernel32.dll',\
        urlmon, 'urlmon.dll',\
        shell32, 'shell32.dll'

import  kernel32,\
    ExitProcess, 'ExitProcess'
import  urlmon,\
    URLDownloadToFile, 'URLDownloadToFileA'
import  shell32,\
    ShellExecute, 'ShellExecuteA'

section '.rdata' data readable
;;szFileName db 'index.htm', 0
;;szURL      db 'http://wiremask.eu/', 0

;; change to test google web
szFileName db 'index.html', 0
szURL      db 'https://www.google.com/', 0