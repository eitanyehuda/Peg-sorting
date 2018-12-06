%include "asm_io.inc"

extern rconf
extern printf

SECTION .data

strInitial: db " initial configuration",0
strFinal: db "  final configuration",0

array: dd 0,0,0,0,0,0,0,0,0
size: dd 0
temp: dd 0

peg1: db "          o|o",0
peg2: db "         oo|oo",0
peg3: db "        ooo|ooo",0
peg4: db "       oooo|oooo",0
peg5: db "      ooooo|ooooo",0
peg6: db "     oooooo|oooooo",0
peg7: db "    ooooooo|ooooooo",0
peg8: db "   oooooooo|oooooooo",0
peg9: db "  ooooooooo|ooooooooo",0
base: db "XXXXXXXXXXXXXXXXXXXXXXX",0
pegEmpty: db "",0

msg1: db "incorrect number of command line arguments",0
msg2: db "command line argument must be unsigned int between 2 and 9",0

SECTION .bss

SECTION .text
   global  asm_main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;              subroutine showp              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


showp:
      enter 0,0          ;Setup routine
      pusha              ;

      mov ecx, [ebp+8]   ;Save array adress into ecx
      mov ebx, 10        ;counter

Print_structure:
      
     cmp ebx, 1          ;Waits until end of array to print base
     je strBase

     sub ebx, 1
     mov eax, dword [ecx + (ebx-1)*4]

       ;;Finds and prints the correct str that corresponds to the num in array
       ;;This is done by calling corresponding print flag (jumping I mean)

     cmp eax, 0          ;
     je strEmpty         ;Print an empty row where the value in array is 0

     cmp eax, 1
     je str1

     cmp eax, 2
     je str2

     cmp eax, 3
     je str3

     cmp eax, 4
     je str4

     cmp eax, 5
     je str5

     cmp eax, 6
     je str6

     cmp eax, 7
     je str7

     cmp eax, 8
     je str8

     cmp eax, 9
     je str9

    

       ;;These are print statements for each row


str1:
     mov eax,peg1
     call print_string
     call print_nl
     jmp Print_structure


str2:
     mov eax,peg2
     call print_string
     call print_nl
     jmp Print_structure


str3:
     mov eax,peg3
     call print_string
     call print_nl
     jmp Print_structure


str4:
     mov eax,peg4
     call print_string
     call print_nl
     jmp Print_structure


str5:
     mov eax,peg5
     call print_string
     call print_nl
     jmp Print_structure


str6:
     mov eax,peg6
     call print_string
     call print_nl
     jmp Print_structure


str7:
     mov eax,peg7
     call print_string
     call print_nl
     jmp Print_structure


str8:
     mov eax,peg8
     call print_string
     call print_nl
     jmp Print_structure


str9:
     mov eax,peg9
     call print_string
     call print_nl
     jmp Print_structure


strEmpty:
     mov eax,pegEmpty    ;
     call print_string   ;Empty row
     jmp Print_structure ;


strBase:
     mov eax,base        ;
     call print_string   ;Base printing
     call print_nl       ;


     call read_char      ;checks if enter is pressed and only then continues

showp_end:
     popa                ;
     leave               ;Exit routine
     ret                 ; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;            subroutine showp end            ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;             subroutine sorthem             ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sorthem:
     enter 0,0       ;Setup routine
     pusha           ;

     mov ecx, dword [ebp+8]   ;Store array and size into registers
     mov edx, dword [ebp+12]  ;

     cmp edx, 1      ;Jump to end when size indexer is 1 
     je sorthem_end  ; 

     sub edx, 1      ;decrement size indexer    
     push edx         
     add edx, 1       
     add ecx, 4
     push ecx
     sub ecx, 4     
     call sorthem    ;call sorthem recursively
     add esp, 8

     mov ebx, 0      ;counter
     jmp loop1

loop1:
     sub edx, 1
     cmp ebx, edx
     je loop_end
     add edx,1

     mov eax, [ebx * 4 + ecx]
     cmp eax, [4 + ecx + ebx * 4]
     ja loop_end

     mov eax, [ebx * 4 + ecx]
     cmp eax, [4 + ecx + ebx * 4]
     jb loop2

loop2:
       ;;swapping elements

     mov eax, dword[ebx * 4 + ecx]
     mov [temp], eax          ;Store eax in temperary var

     mov eax, dword[4 + ecx + ebx * 4]
     mov [ecx+ebx*4], eax

     mov eax, dword [temp]
     mov [4 + ecx + ebx * 4], eax

     inc ebx         ;increment counter

     jmp loop1

loop_end:
     push dword [size]  ;Push values onto stack for showp function
     push array         ;
     call showp         ;Show configuration after each step
     add esp, 8         ;Realign stack pointer

sorthem_end:
   popa                 ;
   leave                ;Exit routine
   ret                  ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;           subroutine sorthem end           ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;            subroutine asm_main             ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm_main:
   enter 0,0           ;setup routine

     ;;check argc, must be 2
   mov eax,[ebp+8]     ;argc
   cmp eax,2
   je Check_length     ;check length of argv[1]
   mov eax,msg1        ;display argc error message
   call print_string
   call print_nl
   jmp asm_main_end

Check_length:  
   mov ebx,[ebp+12]    ;address of argv[]
   mov ecx, [ebx+4]    ;address of argv[1]
     ;;first letter should not be NULL
   cmp byte [ecx],byte 0
   je Bad_length
     ;;the second letter should not be NULL
   cmp byte [ecx+1], byte 0
   jne Bad_length
   jmp Length_ok

Bad_length:
   mov eax, msg2       ;
   call print_string   ;Print error message
   call print_nl       ;
   jmp asm_main_end

Length_ok:
   cmp byte[ecx],'2'   ;
   jb Invalid_argument ;Confirm that argument entered is a number between 2 and 9
   cmp byte[ecx],'9'   ;
   ja Invalid_argument ;
   jmp Set_size

Set_size:
   mov al, byte [ecx]  ;
   sub eax, dword '0'  ;Convert size argument to int
   mov ecx, eax        ;
   jmp Arg_ok

Invalid_argument:
   mov eax,msg2        ;
   call print_string   ;Print error message
   call print_nl       ;
   jmp asm_main_end

Arg_ok:
   mov [size], ecx
   jmp Randomize_array

Randomize_array:
   push dword [size]   ;push values for rconf
   push array          ;
   call rconf
   add esp, 8
   jmp Show_tower_initial

Show_tower_initial:
   mov eax, strInitial ;Print Initial phrase
   call print_string   ; 
   call print_nl
   
   push dword [size]   ;push values again since they get poped by reconf c func
   push array          ;
   call showp          ;print peg function
   add esp, 8          ;reallign stack pointer to correct position 
   jmp Sort_tower

Sort_tower:
   push dword [size]    ;push values for sorthem since they got poped by showp
   push array           ;
   call sorthem
   add esp, 8           ;reallign stack pointer to correct position

   mov eax, strFinal    ;Print Final phrase
   call print_string    ; 
   call print_nl   

   push dword [size]    ;push values again for final showp displaying final configuration
   push array           ;
   call showp
   add esp,8            ;reallign stack pointer to correct position
   jmp asm_main_end

asm_main_end:
   leave                ;Exit routine
   ret                  ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;          subroutine asm_main end           ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

