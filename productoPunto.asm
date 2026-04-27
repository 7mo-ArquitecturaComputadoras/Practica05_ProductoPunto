; ============================================================
; Autor: Edson Joel Carrera Avila
; productoPunto.asm
; ============================================================

.586
.model flat, c

; ============================================================
; SECCIÓN DE CÓDIGO (.code)
; ============================================================
.code
; --- Inicio del programa ---

; Parámetros: [EBP+8]  = puntero a vec1 (double*)
;             [EBP+12] = puntero a vec2 (double*)
;             [EBP+16] = N (int)
productoPunto PROC
    PUSH    EBP                     ; Guardamos el marco de pila actual
    MOV     EBP, ESP                ; Establecemos el nuevo marco de pila
    PUSH    ESI                     ; Preservamos ESI según la convención cdecl
    PUSH    EDI                     ; Preservamos EDI según la convención cdecl
    MOV     ESI, [EBP+8]            ; ESI apunta al inicio de vec1
    MOV     EDI, [EBP+12]           ; EDI apunta al inicio de vec2
    MOV     ECX, [EBP+16]           ; ECX almacena la dimensión N (contador del ciclo)
    FLDZ                            ; Cargamos 0.0 en la pila de la FPU. ST(0) = acumulador
    TEST    ECX, ECX                ; Comparamos N con 0
    JLE     fin                     ; Si N <= 0, saltamos al final (retorna 0.0)

; --- Bucle que multiplica los elementos de los vectores ---
bucle:
    FLD     QWORD PTR [ESI]         ; Cargamos vec1[i] en ST(0). El acumulador baja a ST(1)
    FMUL    QWORD PTR [EDI]         ; Multiplicamos ST(0) por vec2[i]. ST(0) = vec1[i] * vec2[i]
    FADDP   ST(1), ST(0)            ; Sumamos ST(0) al acumulador en ST(1) y desapilamos. ST(0) = acumulador
    ADD     ESI, 8                  ; Avanzamos 8 bytes en vec1 (tamaño de un double)
    ADD     EDI, 8                  ; Avanzamos 8 bytes en vec2 (tamaño de un double)
    DEC     ECX                     ; Disminuimos el contador N
    JNZ     bucle                   ; Si ECX no es 0, repetimos el ciclo

; --- Fin del programa ---
fin:
    POP     EDI           
    POP     ESI           
    MOV     ESP, EBP      
    POP     EBP           
    RET                   
productoPunto ENDP

END
