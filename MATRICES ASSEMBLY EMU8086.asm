INCLUDE emu8086.inc     ;biblioteca standard, contine functiile PRINT / PRINTN, SCAN_NUM si PRINT_NUM care ajuta la crearea interfeti grafice prin intermediul consolei

ORG 100H

.DATA                   ;zona unde declar variabilele

MATRICE     DW  1024 DUP(?)
NR_LINII    DW  ?
NR_COLOANE  DW  ?
NR_ELEMENTE DW  ?
SUMA_NR_NEG DW  0
SUMA_NR_POZ DW  0
CNT_NR_NEG  DW  0
CNT_NR_POZ  DW  0
CMMDC       DW  ?
                                           
.CODE                   ;zona unde se afla instructiunile / codul sursa                                      

; --- CITIRE NUMAR DE LINII ---

PRINTN  'INTRODUCETI NUMARUL DE LINII:'   
CALL    SCAN_NUM        ;functia SCAN_NUM citeste din consola un numar si il pune in registrul CX                   
MOV     NR_LINII, CX    ;mutam din registrul CX in variabile NR_LINII                   
PRINTN  ''              ;PRINTN = Printeaza in consola '...' adaugand la final caracterul new-line                                 

; --- / ---

PRINTN  ''              ;new-line                                 


; --- CITIRE NUMAR DE COLOANE ---

PRINTN  'INTRODUCETI NUMARUL DE COLOANE:'  
CALL    SCAN_NUM        ;citeste un numar din consola                  
MOV     NR_COLOANE, CX                     
PRINTN  ''              ;new-line

; --- / ---

; --- AFLAREA NUMARUL DE ELEMENTE ALE MATRICII ---

MOV     AX, 1           ;instructiunea MUL inmulteste registrul AX cu un numar, 1 fiind element neutru al inmultirii                              
MUL     NR_LINII        ;                   
MUL     NR_COLOANE      ;                   
MOV     NR_ELEMENTE, AX ;NR_ELEMENTE = NR_LINII * NR_COLOANE

; --- / ---                    

; --- CITIRE ELEMENTE MATRICE ---
                                           
PRINTN  ''              ;new-line                   
PRINTN  'INTRODUCETI ELEMENTELE MATRICEI:' 

MOV     BX, OFFSET MATRICE ;in registrul BX voi retine adresa de unde incepe zona de memorie a matricei                

MOV     SI, 0           ;voi folosi registrul SI pe post de iterator, MATRICE[i] = [BX + 2*i] = [BX + SI] => SI = 2*i                              
MOV     AX, 0           ;AX va fi folosit drept contor pentru structura repetiva FOR_0 (vom citi numere de la tastatura pana cand AX == NR_ELEMETE)                     
FOR_0:                                     
    CALL    SCAN_NUM    ;citim un nou numar                   
    MOV     [BX+SI], CX ;il introduce in matrice                   
    PRINTN  ''          ;new-line                   
                                           
    ADD     SI, 2       ;incrementez iteratorul matricei                   
    INC     AX          ;incrementez contorul
    
    ;conditie de comparare pentru a repeta ciclul                   
    CMP     AX, NR_ELEMENTE                
    JL      FOR_0       ;repet ciclul
    
; --- / ---                          

; --- PARCURGERE MATRICE SI SELECTAREA ELEMENTELOR NEGATIVE SI POZITIVE ---
    
MOV     SI, 0           ;iteratorul matricei                              
MOV     CX, NR_ELEMENTE ;instructiunea LOOP foloseste registrul CX pe post de contor                   
FOR_1:                                     
    MOV     AX, [BX+SI] ;in AX voi retine pe rand fiecare element al matricei                  
    
    CMP     AX, 0       ;compar AX cu 0 pentru a determina daca numarul este negativ sau pozitiv                       
    JL      NR_NEG      ;AX < 0               
    JG      NR_POZ      ;AX > 0                   
    JE      CONTINUE    ;AX = 0 (elementele care sunt 0 nu vor fi prelucrate, deoarece 0 nu este nici pozitiv, nici negativ)                   
    
NR_NEG:                                    
    ADD     SUMA_NR_NEG, AX ;adun numerele negative in variabila SUMA_NR_NEG               
    INC     CNT_NR_NEG  ;retin numarul de numere negative in CNT_NR_NEG (MA = SUMA_NR_NEG / CNT_NR_NEG)  
    JMP     CONTINUE                       
    
NR_POZ:                                    
    ADD     SUMA_NR_POZ, AX ;adun numerele pozitive in variabila SUMA_NR_POZ               
    INC     CNT_NR_POZ  ;retin numarul de numere pozitive in CNT_NR_NEG (MA = SUMA_NR_POZ / CNT_NR_POZ)                     

CONTINUE:                                  
    ADD     SI, 2       ;incrementez iteratoru;                   
    LOOP    FOR_1       ;repet ciclul
    
; --- / ---
                              
    
;MOV     AX, SUMA_NR_NEG
;CALL    PRINT_NUM
;PRINTN  ''

;MOV     AX, SUMA_NR_POZ
;CALL    PRINT_NUM
;PRINTN  ''

;MOV     AX, CNT_NR_NEG
;CALL    PRINT_NUM
;PRINTN  ''

;MOV     AX, CNT_NR_POZ
;CALL    PRINT_NUM
;PRINTN  ''

; --- CALCULEZ CMMMDC ---

MOV     AX, SUMA_NR_NEG ;FAC MODUL DIN SUMA_NR_NEG PENTRU A PUTEA REALIZA CMMDC              
MOV     CX,-1                              
IMUL    CX                                 
MOV     SUMA_NR_NEG, AX                    
MOV     BX, CNT_NR_NEG                    

FOR_NEG:                ;CALCULEZ CMMDC DINTRE SUMA_NR_NEG SI CNT_NR_NEG              
    CMP     BX, 0                          
    JE      OUTSIDE_NEG                    
    
    MOV     CX, AX                         
    
    MOD_NEG:            ;CALCULEZ MODULUL                   
        CMP     CX, BX                     
        JGE     SCADERE_NEG                
        JMP     NEXT_NEG                   
    
    SCADERE_NEG:                           
        SUB     CX, BX                     
        JMP     MOD_NEG                    
    
    NEXT_NEG:                              
        MOV     AX, BX                     
        MOV     BX, CX                     
        JMP     FOR_NEG
        
; --- / ---
 
 
; --- AFISEZ MEDIA ARITMETICA A NUMERELOR NEGATIVE ---                    
    
OUTSIDE_NEG:                               
    PRINTN  ''                             
    PRINTN  'MEDIA ARITMETICA A NUMERELOR NEGATIVE DIN MATRICE ESTE:'
    MOV     CMMDC, AX                      
                                           
    MOV     AX, SUMA_NR_NEG             
    DIV     CMMDC                          
    PRINT   '-'                            
    CALL    PRINT_NUM   ;AFISEZ NUMARATORUL                      
      
    PRINT   '/'                        
    
    MOV     AX, CNT_NR_NEG             
    IDIV    CMMDC                      
    CALL    PRINT_NUM   ;AFISEZ NUMITORUL                  
    
    PRINTN  ''                         

; --- / ---
 
 
; --- CALCULEZ CMMMDC ---
                     
MOV     AX, SUMA_NR_POZ                    
MOV     BX, CNT_NR_POZ

FOR_POZ:                ;CALCULEZ CMMDC DINTRE SUMA_NR_POZ SI CNT_NR_POZ                        
    CMP     BX, 0                         
    JE      OUTSIDE_POZ                    
    
    MOV     CX, AX                         
    
    MOD_POZ:                               
        CMP     CX, BX  ;CALCULEZ MODULUL                       
        JGE     SCADERE_POZ                
        JMP     NEXT_POZ                   
    
    SCADERE_POZ:                           
        SUB     CX, BX                     
        JMP     MOD_POZ                    
    
    NEXT_POZ:                              
        MOV     AX, BX                     
        MOV     BX, CX                     
        JMP     FOR_POZ
        
; --- / ---


; --- AFISEZ MEDIA ARITMETICA A NUMERELOR POZITIVE ---                      
    
OUTSIDE_POZ:                               
    PRINTN  ''                             
    PRINTN  'MEDIA ARITMETICA A NUMERELOR POZITIVE DIN MATRICE ESTE:'
    MOV     CMMDC, AX                      
    
    MOV     AX, SUMA_NR_POZ                
    DIV     CMMDC                          
    CALL    PRINT_NUM   ;AFISEZ NUMARATORUL                       
      
    PRINT   '/'                        
    
    MOV     AX, CNT_NR_POZ             
    IDIV    CMMDC                      
    CALL    PRINT_NUM   ;AFISEZ NUMITORUL                  
    
    PRINTN  ''
    
; --- / ---                         

RET

;INCLUD FUNCTIILE DE CITIRE SI AFISARE A NUMERELOR DIN CONSOLA
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

END




