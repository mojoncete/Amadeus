; ****************************************************************************************************************************************************************************************** 

; Construyo un nº aleatorio. Método: "DERIVANDO."

Derivando_RND 

;    ld hl,attr_msg         ;o          ; En el caso de que queramos generar más de un nº aleatorio partiendo de la misma semilla:::. HL apuntará a la dirección_
;                                       ; _de memoria donde se va a almacenar el 1er byte, (nº aleatorio).     
;    ld b,attr_msg-msg-1    ;o          ; En el caso de que queramos generar más de un nº aleatorio partiendo de la misma semilla:::.

    jr $


7 ld a,r      			                ; La semilla inicial de nuestro nº aleatorio la proporciona el registro `R´. Cargamos A con R.
;                                       ; El registro R, es un registro de 8 bits que actúa como contador de refresco de la memoria dinámica. ($00 - $ff).
    ld bc,$0700                         ; C contendrá nuestro nº aleatorio: $0 - $ff. Inicialmente está a "0".
;                                       ; B actuará como contador de bits. Requerimos de 1 byte, ($ff).

;    push bc                            ;o                     
                             
6 and a                                 ; Carry a "0".
    srl a                               ; Desplazamiento a la derecha.
    jr nc,1F

    set 0,c    

1 ld d,a                                ; D contiene la copia de nuestra semilla después del DESPLAZAMIENTO.
    and %00000001                       ; Extraigo el último bit de A y lo guardamos en E.
    ld e,a
 
    ld a,d
    and %00000010                       ; Extraigo el penúltimo bit de A y lo `traslado´ al último bit de A. El objetivo es implementar una función XOR_ 
    jr z,2F                             ; _con el último y penúltimo bit de nuestra semilla.
 
    ld a,1

2 xor e                                 ; XOR entre el último y penúltimo bit de A.

    ld a,d                              ; A vuelve a contener la copia de nuestra semilla después del DESPLAZAMIENTO.
    jr z,4F

    set 7,a
    jr 5F
4 res 7,a
5 sla c
    djnz 6B
    ld a,c                              ; Nº aleatorio (1 Byte) en A.

; Ejemplos de cribado:

;    and %01111000       ; o            ; No quiero que los attr. tengan FLASH. La tinta siempre en NEGRO.

; Esta parte es opcional. Permite seguir generando X nº aleatorios partiendo de la misma semilla. En este caso, almacenaré esos nº en un espacio de memoria_
; _reservado para este fin, (attr_msg).

    ld (hl),a     ; o
    inc hl        ; o
    pop bc        ; o
    djnz 7B       ; o
    
    ret

    
