;; https://board.flatassembler.net/topic.php?t=10427
;; a small snippet demonstrating how to make a screenshot and save it to JPEG file with the GDI+ library (available
;; since XP, though you can get a redistributable for ealier versions of Windows, too).
;; It displays no error messages in case of any failure, however it does free the resources appropriately in each case,
;; so it's easy to modify it to get the full and proper error handling.

;; modified, save different type of image file
;; xiaolaba

format PE GUI 4.0

include 'win32w.inc'

struct GdiplusStartupInput
  GdiplusVersion     dd ?
  DebugEventCallback	dd ?
  SuppressBackgroundThread dd ? 
  SuppressExternalCodecs   dd ?
ends

struct ImageCodecInfo
  Clsid 	db 16 dup ?
  FormatID	db 16 dup ?
  CodecName	dd ?
  DllName	dd ?
  FormatDescription dd ?
  FilenameExtension dd ?
  MimeType	dd ?
  Flags 	dd ?
  Version	dd ?
  SigCount	dd ?
  SizeSize	dd ?
  SigPattern	dd ?
  SigMask	dd ?
ends

section '.text' code readable executable

entry $

  invoke  GdiplusStartup,token,input,NULL
  test	  eax,eax
  jnz	  exit

  invoke  GdipGetImageEncodersSize,encoders_count,encoders_size
  test	  eax,eax
  jnz	  gdiplus_shutdown
  invoke  VirtualAlloc,0,[encoders_size],MEM_COMMIT,PAGE_READWRITE
  test	  eax,eax
  jz	  gdiplus_shutdown
  mov	  ebx,eax
  invoke  GdipGetImageEncoders,[encoders_count],[encoders_size],ebx
  test	  eax,eax
  jnz	  gdiplus_shutdown

scan_encoders:
  mov	  esi,[ebx+ImageCodecInfo.MimeType]
  mov	  edi,encoder_mimetype_str

  ;invoke MessageBox,0,esi,0,0	 ;show what image type available

  ;; see https://board.flatassembler.net/topic.php?t=10427
  ;; ecx = strlen(encoder_mimetype)+1
  ;;   image/tiff or image/jpeg = 11 bytes of ASCII
  ;;   image/bmp or image/gif or image/png = 10 bytes of ASCII
  ;mov	   ecx,10
  ;mov	   ecx,11
  mov	  ecx, encoder_mimetype_str_size

  ;invoke MessageBox,0,ecx, encoder_mimetype_str,0
  repe	  cmpsw
  je	  encoder_found

  add	  ebx,sizeof.ImageCodecInfo
  dec	  [encoders_count]
  jnz	  scan_encoders

; no encoder found
  jmp	  gdiplus_shutdown

encoder_found:
  lea	  esi,[ebx+ImageCodecInfo.Clsid]
  mov	  edi,encoder_clsid
  mov	  ecx,4
  rep	  movsd
  invoke  VirtualFree,ebx,0,MEM_RELEASE

  invoke  GetDC,HWND_DESKTOP
  test	  eax,eax
  jz	  gdiplus_shutdown
  mov	  esi,eax
  invoke  GetSystemMetrics,SM_CYSCREEN
  mov	  [screen_height],eax
  invoke  GetSystemMetrics,SM_CXSCREEN
  mov	  [screen_width],eax
  invoke  CreateCompatibleBitmap,esi,[screen_width],[screen_height]
  test	  eax,eax
  jz	  release_desktop_dc
  mov	  ebx,eax
  invoke  CreateCompatibleDC,esi
  test	  eax,eax
  jz	  delete_bitmap
  mov	  edi,eax
  invoke  SelectObject,edi,ebx
  test	  eax,eax
  jz	  delete_dc
  invoke  BitBlt,edi,0,0,[screen_width],[screen_height],esi,0,0,SRCCOPY
  test	  eax,eax
  jz	  delete_dc

  invoke  GdipCreateBitmapFromHBITMAP,ebx,NULL,gdip_bitmap
  test	  eax,eax
  jnz	  delete_dc

  invoke  GdipSaveImageToFile,[gdip_bitmap],file_name,encoder_clsid,NULL

  invoke  GdipDisposeImage,[gdip_bitmap]

delete_dc:
  invoke  DeleteObject,edi

delete_bitmap:
  invoke  DeleteObject,ebx

release_desktop_dc:
  invoke  ReleaseDC,HWND_DESKTOP,esi

gdiplus_shutdown:
  invoke  GdiplusShutdown,[token]

exit:
  invoke  ExitProcess,0


section '.data' data readable writeable

;; different image file could be saved
;; ----------------

;  file_name du 'test.bmp',0
;  encoder_mimetype_str du 'image/bmp',0  ; 10byte ASCII string, du, encoded 20bytes with delimiter 00, such as 69 00 6D 00 61 00 67 00 65 00 2F 00 70 00 6E 00 67 00 00, 00
;  encoder_mimetype_str_size = ($-encoder_mimetype_str) /2	; du 'image/bmp', lenght = 20/2 = 10

  file_name du 'test.jpg',0
  encoder_mimetype_str du 'image/jpeg',0
  encoder_mimetype_str_size = ($-encoder_mimetype_str) /2      ; du 'image/jpeg', lenght = 22/2 = 11

;  file_name du 'test.gif',0
;  encoder_mimetype_str du 'image/gif',0
;  encoder_mimetype_str_size = ($-encoder_mimetype_str) /2

;  file_name du 'test.tif',0
;  encoder_mimetype_str du 'image/tiff',0
;  encoder_mimetype_str_size = ($-encoder_mimetype_str) /2

;  file_name du 'test.png',0
;  encoder_mimetype_str du 'image/png',0
;  encoder_mimetype_str_size = ($-encoder_mimetype_str) /2

;; ----------------
;; different image file could be saved


  encoder_clsid db 16 dup ?

  input GdiplusStartupInput 1
  token dd ?
  memdc dd ?
  gdip_bitmap dd ?

  encoders_count dd ?
  encoders_size dd ?

  screen_width dd ?
  screen_height dd ?

section '.rdata' data readable

data import

  library kernel32,'KERNEL32.DLL',\
  user32,'USER32.DLL',\
  gdi32,'GDI32.DLL',\
  gdiplus, 'GDIPLUS.DLL'

  include 'api\kernel32.inc'
  include 'api\user32.inc'
  include 'api\gdi32.inc'

  import gdiplus,\
	 GdiplusStartup,'GdiplusStartup',\
	 GdiplusShutdown,'GdiplusShutdown',\
	 GdipGetImageEncodersSize,'GdipGetImageEncodersSize',\
	 GdipGetImageEncoders,'GdipGetImageEncoders',\
	 GdipSaveImageToFile,'GdipSaveImageToFile',\
	 GdipDisposeImage,'GdipDisposeImage',\
	 GdipCreateBitmapFromHBITMAP,'GdipCreateBitmapFromHBITMAP'

end data