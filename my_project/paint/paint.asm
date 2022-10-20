;http://www.informit.com/articles/article.aspx?p=328647&seqNum=3
;https://board.flatassembler.net/topic.php?p=993
; FASM 1.71.60
 
format PE GUI 4.0
entry start
 
include 'win32a.inc'
 
 
 
section '.data' data readable writeable
wHMain         dd   ?
wHInstance     dd   ?
 
wTitle         db   'FASM - Experiment 01, FASM 1.71.60, 2017-MAR-20 xiaolaba',0
wClsName       db   'EXP01',0
 
wMsg      MSG
wCls      WNDCLASS
 
expDc     dd   ?
expTxt    db   'Win32 assembly with FASM is great and easy',0xd,0xa
myTxt     db   'xiaolaba, paint lines, test, 2017-mar-20',0
expPs     PAINTSTRUCT
expRect   RECT
 
 
section '.code' code readable executable
start:
; +------------------------------+
; | registering the window class |
; +------------------------------+
invoke    GetModuleHandle,NULL
mov  [wHInstance],eax
mov  [wCls.hInstance],eax
mov  [wCls.lpfnWndProc],window_procedure
mov  [wCls.lpszClassName],wClsName
mov  [wCls.hbrBackground],COLOR_BTNFACE+1
invoke    LoadIcon,0,IDI_APPLICATION
mov  [wCls.hIcon],eax
invoke    LoadCursor,0,IDC_ARROW
mov  [wCls.hCursor],eax
invoke    RegisterClass,wCls
 
; +--------------------------+
; | creating the main window |
; +--------------------------+
invoke    CreateWindowEx,\
0,\
wClsName,\
wTitle,\
WS_VISIBLE+WS_DLGFRAME+WS_SYSMENU,\
128,\
128,\
512,\
256,\
0,\
0,\
[wHInstance],\
0
mov  [wHMain],eax
 
; +---------------------------+
; | entering the message loop |
; +---------------------------+
window_message_loop_start:
invoke    GetMessage,wMsg,NULL,0,0
or   eax,eax
je   window_message_loop_end
invoke    TranslateMessage,wMsg
invoke    DispatchMessage,wMsg
jmp  window_message_loop_start
 
window_message_loop_end:
invoke    ExitProcess,0
 
; +----------------------+
; | the window procedure |
; +----------------------+
proc window_procedure,hWnd,uMsg,wParam,lParam
push ebx esi edi    ;even the API would preserved, but play safe :p
cmp  [uMsg],WM_DESTROY
je   wmDESTROY
cmp  [uMsg],WM_PAINT
je   wmPAINT
 
wmDEFAULT:
invoke    DefWindowProc,[hWnd],[uMsg],[wParam],[lParam]
jmp  wmBYE
wmPAINT:
invoke    BeginPaint,[hWnd],expPs
mov  [expDc],eax
invoke    GetClientRect,[hWnd],expRect
 
;; drawing single line text to window, ignore line change (0x0d, 0x0a)
;; https://msdn.microsoft.com/en-us/library/windows/desktop/dd162498(v=vs.85).aspx
;                    invoke    DrawText,\
;                                   [expDc],\
;                                   expTxt,\
;                                   -1,\
;                                   expRect,\
;                                   DT_CENTER or DT_VCENTER or DT_SINGLELINE
 
;; drawing multi lines text to window
invoke    DrawText,\
[expDc],\
expTxt,\
-1,\
expRect,\
DT_CENTER or DT_VCENTER
 
;; draw lines
;http://www.informit.com/articles/article.aspx?p=328647&seqNum=3
invoke MoveToEx,[expDc], 0, 0, 0
;                      X,   Y
invoke LineTo,[expDc], 20,  226
invoke LineTo,[expDc], 130, 20
invoke LineTo,[expDc], 240, 100
invoke LineTo,[expDc], 350, 50
 
invoke    EndPaint,[hWnd],expPs
jmp  wmBYE
 
wmDESTROY:
invoke    PostQuitMessage,0
wmBYE:
pop  edi esi ebx
ret
endp
 
 
 
section '.idata' import data readable writable
library   KERNEL32, 'KERNEL32.DLL',\
USER32,   'USER32.DLL',\
gdi32,    'GDI32.DLL'       ; include to draw lines
 
include 'api\gdi32.inc' ;include to draw lines
 
import    KERNEL32,\
GetModuleHandle,    'GetModuleHandleA',\
ExitProcess,        'ExitProcess'
 
import    USER32,\
RegisterClass,      'RegisterClassA',\
CreateWindowEx,     'CreateWindowExA',\
DefWindowProc,      'DefWindowProcA',\
LoadCursor,         'LoadCursorA',\
LoadIcon,           'LoadIconA',\
GetMessage,         'GetMessageA',\
TranslateMessage,   'TranslateMessage',\
DispatchMessage,    'DispatchMessageA',\
BeginPaint,         'BeginPaint',\
GetClientRect,      'GetClientRect',\
DrawText,           'DrawTextA',\
EndPaint,           'EndPaint',\
PostQuitMessage,    'PostQuitMessage'