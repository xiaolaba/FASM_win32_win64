# FASM_win32_win64
batch file to build the testing program, hello world

numbers of project for testing

### win_hello
basic to the build and easy step

### download FASM
https://flatassembler.net/download.php    

### decompress to default folder as you like
mine was E:\FASM\


### download this project folder
[my_project/win_hello/](my_project/win_hello/)  


### Edit batch file for your FASM and path stored   
[my_project/win_hello/build.bat](my_project/win_hello/build.bat)  
```
SET FASM=E:\FASM  
```

初次用 FASM 列出 LISTING, 看了一陣子 HELP, 寫了一個 build.bat, 方便編譯不用每次手動輸入指令.   
build.bat, 編譯源碼用,   
例如把 a.asm 拖到這個 build.bat, 就會執行編譯動作, 產生 a.asm.exe.   
如果用 command prompt 手工輸入, 等同以下指令,  
fasm a.asm a.asm.exe
  
  
### drag the asm file and then drop to build.bat  
job done, ie. hello_win32.asm.exe will be generated.

### win32 XP testing
![my_project/win_hello/in32_test.JPG](my_project/win_hello/win32_test.JPG)


