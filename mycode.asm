;Cojoc Lorena 332AA

.model small
.stack 100h
.data

menu db "Please select a choice:",13,10
     db "1. Moving Car Animation",13,10
     db "2. Change Background Color",13,10
     db "3. Moving Square on Screen",13,10
     db "4. Exit",13,10,'$'
     

 tik dw ?           ;moving car data
 a db 05h
 b db 05h
 c db 08h
 d db 0fh
 e db 06h
 f db 12h
 str db '   0     0 ','$'    ;the wheels
 ctr db 00
     
 color db 10h         ;background data
 
    

.code
start:

;initialize data segment
  mov  ax, @data
  mov  ds, ax

  call clear_screen      
  call display_menu
  call getnum
  call start   

;wait for any key 
getnum:  
  mov  ah, 7
  int  21h 
  
;verify input keys 
  cmp al, '1'
  je Animation
  cmp al, '2'
  je ChangeBgColor
  cmp al, '3'
  je MoveSquareAroundScreen
  cmp al, '4'
  je sound
  je Exit
  
  
  sound:
  ;play incorrect key sound
  
  mov ah, 02
  mov dl, 07h  ; 07h is the value to produce the beep tone
  int 21h      ; produce the sound 
  
  
  

display_menu proc
  mov  dx, offset menu
  mov  ah, 9
  int  21h
  ret
display_menu endp

clear_screen proc
  mov  ah, 0
  mov  al, 3
  int  10H
  ret
clear_screen endp 

;finish program
Exit:
  mov  ax, 4c00h
  int  21h


;moving car animation   
Animation:

 main proc far 
 
 mov ax,@data
 mov ds,ax
    
 road:     
 mov ah, 00h
 mov al, 03h
 int 10h      ;video BIOS interrupt
  
 inc ctr
 mov ah, 02h
 mov bh, 00h
 mov dh, 09h
 mov dl, b
 int 10h
 
 ;the wheels
 mov ah, 09h
 lea dx, str

 int 21h 
 
 ;the road pavement        
 mov ax, 600h
 mov bh, 61h
 mov cx, 0a00h
 mov dx, 0aaah 
 int 10h
 
 ;the body of the car
 mov ax, 600h
 mov bh, 30h     ;set color 
 mov ch, a
 mov cl, b  
 mov dh, c   
 mov dl, d   
 int 10h
 
 
 ;the front of the car
 mov ch, 07h
 mov cl, e 
 mov dl, f 
 int 10h
 
 
 inc b       
 inc d       ;increment the position of the wheels and of the car
 inc e
 inc f

 call delay
 cmp ctr, 60
 jne road    ;simulate movement
 je clear_screen
 main endp
 
  
delay proc near 
    
 mov ah, 00h
 int 1ah       ;add a delay
 mov tik, dx
 add tik, 1h
 
 b10:
 mov ah, 00h
 int 1ah
 cmp tik, dx
 jge b10

 ret
 delay endp 

 
  

 
 ChangeBgColor:
 
 proc bg

 mov ax,@data
 mov ds,ax

 mov ax,3h           ;clear screen
 int 10h

 a10:
 mov ax,0600h        ;set disply
 mov bh,color
 mov cx,0000h        ;x1,y1
 mov dx,184fh        ;x2,y2
 int 10h
 add color,10h       ;change background color

 mov ah,8h           ;keyboard input
 int 21h
 cmp al,'1'          ;if 1 press then color change otherwise 
 je a10              ;display_menu
 cmp al,'7'
 je display_menu

 endp
 
 
 
MoveSquareAroundScreen: 

proc begin

lea ax, data
mov ds, ax
mov es, ax
; setting video mode
mov ah, 0
mov al, 03h
int 10h

mov al, 0             
mov ah, 6   

mov bh, 0h ;changing the color to black
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79  
int 10h     

mov dh, 8
mov dl, 20
mov bh, 0ffh ;changing the color to white
int 10h     

choose:
mov ah, 1
int 21h
cmp al, 'e'
je Exit
cmp al, 'r'
je right 


square MACRO
 mov bh, 0h 
 mov ch, 0
 mov cl, 0
 mov dh, 24
 mov dl, 79  
 int 10h
 ENDM  

right:
mov al, 0  ;where the square starts           
mov ah, 6   

;move square on the second position to the right
square
  
mov bh, 0ffh
mov ch, 0
mov cl, 20
mov dh, 8
mov dl, 40   ;horizontal move with the given position
int 10h


;move square on the third position to the right  


mov bh, 0ffh
mov ch, 0
mov cl, 40
mov dh, 8
mov dl, 60
int 10h    


;move square on the fourth position to the right
square

mov bh, 0ffh
mov ch, 0
mov cl, 60
mov dh, 8
mov dl, 79
int 10h     


;move square down with one position
square 

mov bh, 0ffh
mov ch, 8
mov cl, 60
mov dh, 16
mov dl, 79
int 10h   


;move square down on the right corner
square   

mov bh, 0ffh
mov ch, 16
mov cl, 60
mov dh, 24
mov dl, 79
int 10h


;move square to the left with one position
square 

mov bh, 0ffh
mov ch, 16
mov cl, 40  ;horizontal move to the left with given position
mov dh, 24
mov dl, 60
int 10h


;move square to the left with one position
square

mov bh, 0ffh
mov ch, 16
mov cl, 20
mov dh, 24
mov dl, 40
int 10h

;move square to the left with one position
square 

mov bh, 0ffh
mov ch, 16
mov cl, 0
mov dh, 24
mov dl, 20
int 10h  


;move square to the left with one position
square

mov bh, 0ffh
mov ch, 8
mov cl, 0
mov dh, 16
mov dl, 20
int 10h 


;move square to the left with one position
square

mov bh, 0ffh
mov ch, 0
mov cl, 0
mov dh, 8
mov dl, 20
int 10h



jmp choose

ends

endp
 




end start
