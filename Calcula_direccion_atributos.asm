; -----------------------------------------------------------------------------------------
;
;   04/11/22
;
;   Entrega una dirección de ATRIBUTOS de pantalla en HL a partir de una dirección de pantalla, dada en HL.
;
;   INPUT: HL contiene la dirección de memoria de pantalla.
;   OUTPUT: HL contiene la dirección de ATRIBUTOS de pantalla de la dirección que contenía HL.
;
;   DESTRUYE: HL y A. !!!!! 

Calcula_direccion_atributos call calcula_tercio
    ld h,$58
    add h
    ld h,a
    ret