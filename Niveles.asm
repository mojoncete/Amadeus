; 19/1/24

Indice_de_niveles

	defw Nivel_1
	defw Nivel_2

;	...
;	...
;	+ Niveles ...

	defw 0
	defw 0

Nivel_1 db 4									; Nº de entidades.
	db 1,1,1,1	                                ; Velocidades. Vel_left, Vel_right, Vel_up, Vel_downa. (1, 2, 4 u 8 px). 
	db 1,1,1,1									; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.		

Nivel_2 db 12									; Nº de entidades.
	db 1,1,1,2									; Velocidades. Vel_left, Vel_right, Vel_up, Vel_downa. (1, 2, 4 u 8 px). 
	db 2,1,1,1,1,2								; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.			
	db 2,1,1,1,1,2

