;; https://wiremask.eu/articles/hello-world-assembly-x86-64/


format PE GUI

entry start
section '.text' code readable executable

start:
    push ebp
    mov ebp, esp

    push 0
    push szCaption
    push szText
    push 0
    call [MessageBoxA]

    xor eax, eax
    leave
    ret

section '.idata' import data readable
dd 0, 0, 0, RVA user32, RVA user_table
dd 0, 0, 0, 0, 0

user_table:
    MessageBoxA dd RVA _MessageBoxA
    dd 0

user32 db 'USER32.DLL', 0

_MessageBoxA dw 0
db 'MessageBoxA', 0

section '.rdata' data readable
szCaption db 'win32 fasm', 0
szText db 'Hello, World!' , 0x0d, 0x0a, '2nd line',0