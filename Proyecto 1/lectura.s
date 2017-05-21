			 .data

			      
NombreArchivo:		.asciiz	"/home/abe/Descargas/aci.txt" #####
NoNumero:		.asciiz "No es numero lo que esta en el archivo"
NoRango:		.asciiz "El numeros de intentos no esta entre 3 y 15"
endl:			.asciiz "\n"
uno:			.asciiz "1"

			.align 2

NumInt: 		.space 8	#Se guardara el numero de intentos leidos del archivo
NroPartidas:	        .space 8	#Se guardara el numero de partidas leidos del archivo
A:			.space 8	#Se guardara el codigo a romper leido del archivo		
Buffer:			.space 200	#Buffer donde se guardara todo lo que tiene el archivo
BufferAux:		.space 200 	#Buffer auxiliar donde se guardara la cantidad de partidas
			.align 2
				
			.text

				
				
#################### - ABRIR ###################
main:
	la	$a0, NombreArchivo          #Nombre del archivo en 
	li	$a1, 0x100	            #Flag 0x100 
	li	$a2, 0x1FF	   	    #Modo 0x1FF

	li $v0, 13		   	    #Llamada syscall para abrir el archivo
	syscall				    #Se guarda el file descriptor en $v0

	move $s6, $v0 			    #Se guarda el file descriptor en $s6 No se debe borrar 
	

################## - LEER - ###################

	move	$a0, $s6		    #Se pasa el file descriptor a $a0 

	la $a1, Buffer			    #Se guarda todo el archivo en el Buffer
	li $a2, 1000           		    #Se dice la cantidad que se va a leer del archivo
	li $v0, 14			    #Se hace la llamada al sistema para leer
	syscall

	la $a0, Buffer			###OJO es para imprimir lo que esta en el buffer###
	li $v0, 4			
	syscall
	
	
	
######### - INICIALIZACION PARA LECTURA ########

	li $s2, 0		#Contador del Buffer (NO SE PUEDE BORRAR)
	li $s5, 0
	li $t0, 0
	li $t1, 0
	li $t4, 0
	li $t9, 2
	li $t8, 1		#Se guarda 1 en $t8 
	neg $t8, $t8		#Se cambia el 1 de $t8 por -1
	
	lb $t2, uno		# se guarda el caracter "1" en $t2
	li $s7, 0x30		#$s7 tiene el valor de 30 porque todo lo que esta por debajo de dicho valor no debe entrar
				#en el programa
	li $t3, 0x39		#$t3 tiene el valor de 39 porque todo lo que esta por arriba de  dicho valor no debe entrar
				#en el programa
	li $s4, 0xA		# se guarda en $s4 el salto de linea			
	li $t5, 10		#Se inicializa en 10 porque esta es la variable que va a multiplicar en la parte de 
				#ObtenerCantPartidas en el ciclo exp
	li $t6, 3		#Se guarda el valor 3 en $t6 porque todos los numeros de intentos que esten por debajo de 
				#dicha cantidad no deben entrar
	li $t7, 15		#Se guarda el valor 15 en $t7 porque todos los numeros de intentos que esten por arriba de 
				#dicha cantidad no deben entrar

	
########### - LEER NUMERO DE INTENTOS ########## 

NumIntentos:		
	
	lb $s3, Buffer($s2)		#Se saca de del Buffer lo que este en la posicion $s2 y se guarda en $s3

	beq $s3, $s4, Sig		#Si $s3 es un salto de linea se salta a leer la Siguiente linea del archivo en Sig
	beq $s2, $t9, NOESTA		#Verifica si el primer numero del archivo tiene mas de dos digitos
	
	blt $s3, $s7, NoEstaEnRango     #Si $s3 es menor a 0x30 en asciiz, el elemento no esta en rango
	bgt $s3, $t3, NoEstaEnRango     #Si $s3 es mayor a 0x39 en asciiz, el elemento no esta en rango
	
	beq $s3, $t2, EsUno		#Compara si el primer numero que se toma del Buffer es un 1 para sumarle 9 en EsUno 
	bne $s3, $t2, NoEsUno		#Compara si el primer numero que se toma del Buffer NO es un 1 y por lo tanto se salta a NoEsUno
	  
EsUno:
	bgtz $t4, NoEsUno		#Si el contador es mayor a cero es porque ya se agrego la decena y ahora tocaria agregar la unidad

	add $t0, $s3, -0x30 		#Se resta 30 para cambiar el caracter tomado del buffer por un entero
	  
	addi $t0, 9       		#Se le suma 9 para cambiarlo a 10 y queda en $t0 el resultado para sumarlo despues
	addi $s2, 1	
	addi  $t4, 1 
 
	b NumIntentos			#Se hace un brico a NumIntentos para calcular el segundo digito del numero
	  
NoEsUno: 

	add $t1, $s3, -0x30 		#Se resta 30 para transformar el numero en entero
 
	add $s3, $t1, $t0   		#Se suma lo que se calculo en $t0 y $t1
	 
	blt $s3, $t6, NOESTA     	# Se verifica si el numero es menor a 3
	bgt $s3, $t7, NOESTA	 	#Se verifica si el numero es mayor a 15
	 	
	sw $s3, NumInt($s5)		#Se guarda en NumInt el numero de intentos
	
	addi $s2, 1
	addi $s5, 1
	addi $t4, 1
	
	b NumIntentos
	
Sig:
	li $t0, 0
	li $t1, 0
        li $s5, 0
	li $t4, 0
	li $t9, 0
	li $t6, 0
	li $t7, 0

	b copiarbuff

copiarbuff:

	addi $s2, 1

	lb $s3, Buffer($s2)			#Se saca del buffer el caracter
	
	blez $s3, fin				#Se verifica si es fin de archivo
	beq $s3, $s4, ObtenerCantPartidas	#Se verifica si es salto de linea
	
	blt $s3, $s7, NoEstaEnRango    		#Se verifica si el caracter que se saco del buffer es un numero
	bgt $s3, $t3, NoEstaEnRango     
	
	
	sb $s3, BufferAux($s5)			#Se guarda el caracter en un buffer auxiliar
	
	addi $t4, 1				#Se lleva un conteo de la cantidad de caracteres que se estan agregando en el buffer auxiliar 
	addi $s5, 1
	
	b copiarbuff

ObtenerCantPartidas:

	lb $s3, BufferAux($t1)			#Se saca del buffer auxiliar los caracteres

	add $t4, $t4, $t8			#Se le resta 1 al contador de caracteres del buffer auxiliar 

	move $t6, $t4 				#Se copia en $t6 para utilizarlo de contador en exp (exponente del 10)
	li $t0, 1
	add $t6, $t6, $t8 
exp:

	bltz $t6, multiplicar			#Mientras el contador sea distinto de cero se hace la multiplicacion

	mul $t0, $t0, $t5			#Se hace la siguiente operacion $t0 = $t0*10

	add $t6, $t6, $t8 			#Se le resta uno al contador de exponente

	b exp

multiplicar:

		
	add $s3, $s3, -0x30   			#Se le resta 30 al caracter para volverlo entero
	
	mul $t0, $t0, $s3			#Se multiplica por la cantidad que se obtuvo en exp 

	add $t7, $t7, $t0 			#Se guarda en una variable auxiliar 
	addi $t1, 1
	
	bgtz $t4, ObtenerCantPartidas		#Mientras el contador de caracteres sea mayor a cero se sigue haciendo el procedimiento

	move $s3, $t7
	
	li $s5, 0

	sw $s3, NroPartidas($s5)		#Se guarda la variable auxiliar que lleva la suma del numero

	b sig2
	
sig2:
	li $t0, 0
	li $t1, 0
        li $s5, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	
	
partida:
	addi $s2, 1

	lb $s3, Buffer($s2)			#Se obtiene el codigo

	blez $s3, fin				#Se verifica si es el final de archivo
	beq $s3, $s4, fin ##OJO cambiar fin por la etiqueta donde se intenta adivinar el codigo	#Una vez que se termina el ciclo de obtener el codigo se brinca a intentar adivinar el codigo

	blt $s3, $s7, NoEstaEnRango     	#Se verifica si son numeros lo que se esta sacando del buffer
	bgt $s3, $t3, NoEstaEnRango     
	
	sb $s3, A($s5)				#Se guarda en el .space A 
		
	addi $s5, 1
	
	b partida

################################################
NoEstaEnRango:

	la $a0, NoNumero 			#Se imprime el mensaje si los caracteres que se sacaron del buffer no estan dentro del rango de los numeros
	li $v0, 4			
	syscall	
	b fin

NOESTA:						#Se imprime un mensaje si los numeros de intentos no esta dentro del rango 3<=X<=15

	la $a0, NoRango 
	li $v0, 4			
	syscall	
	b fin

    

################################################
fin:
	li $t5, 0
	la $a0, endl 				##OJO solo se imprime para verificar hay que quitarlo!
	li $v0, 4			
	syscall	

	lw $a0, NumInt 
	li $v0, 1			
	syscall	
	
	la $a0, endl 
	li $v0, 4			
	syscall	
	
	lw $a0, NroPartidas 
	li $v0, 1			
	syscall	
	
	la $a0, endl 
	li $v0, 4			
	syscall	
	
	la $a0, A
	li $v0, 4			
	syscall

	move $a0, $s6
	li $v0, 16			# Se cierra el archivo
	syscall
	  
	li $v0, 10
	syscall
