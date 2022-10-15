;; https://wiremask.eu/articles/hello-world-assembly-x86-64/

format PE64 GUI

entry start
section '.text' code readable executable

start:
    push rbp
    mov rbp, rsp

    xor rcx, rcx
    lea rdx, [szText]
    lea r8, [szCaption]
    xor r9d, r9d
    call [MessageBoxA]

    xor rax, rax
    leave
    ret

section '.idata' import data readable
dd 0, 0, 0, RVA user32, RVA user_table
dd 0, 0, 0, 0, 0

user_table:
    MessageBoxA dq RVA _MessageBoxA
    dq 0

user32 db 'USER32.DLL', 0

_MessageBoxA dw 0
db 'MessageBoxA', 0

section '.rdata' data readable
szCaption db 'win64 fasm', 0
szText db 'Hello, World!' , 0x0d, 0x0a, '2nd line',0