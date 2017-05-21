########### (PARA CORRER EN WINDOWS) ###########
#-Grupo 24
#-Integrantes: 
#-Abelardo Valino 10-10738
#-Patricia Wilthew 09-10910
################## PROYECTO-1 ##################
################################################

			.data
			
msj1: 		.asciiz "--MASTERMIND--

 Escriba su nombre: "
msj2:		.asciiz "Introduzca un numero de 4 cifras (No presione Enter): "
msj3:		.asciiz "FIN DE LA PARTIDA. \n"
msj4:		.asciiz "El codigo correcto era: "
msj5:		.asciiz "Su intento: "
msj6:		.asciiz "Patron de control: "
msj7:		.asciiz "-Intento #"
msj8:		.asciiz "HA DESCIFRADO EL CODIGO! "
msj9:		.asciiz "----PARTIDA #"
msj10:		.asciiz "----"
msj11:		.asciiz "----PUNTAJE : "
msj12:		.asciiz "Desea jugar otra vez? (s/n): "
msj13:		.asciiz "FIN DEL JUEGO."
msj14:		.asciiz "JUGADOR: "
msj15:		.asciiz "Puntuacion Total: "
prueba:		.asciiz "prueba"
endl: 		.asciiz "\n"
nombre:		.space 10
A:			.space 5
Z:			.space 5
C:			.space 4
NombreArchivo:	.asciiz	"aci.txt" 				#Para Windows solo va el nombre del archivo, para Linux la ubicacion
NoNumero:		.asciiz "En el archivo solo pueden haber numeros"
NoRango:		.asciiz "Problema con el rango del numero de intentos. Debe estar entre 3 y 15"
uno:			.asciiz "1"
				.align 2
NumInt: 		.space 8						#Para guardar el numero de intentos de la partida
NroPartidas:	.space 8						#Para guardar el numero de partidas
Buffer:			.space 200						#Para guardar el texto del archivo
BufferAux:		.space 200 						#Para guardar la cantidad de partidas
				.align 2

				.text



################### - INICIO ###################

main:		
		la $a0, msj1
		li $v0, 4
		syscall									#Se imprime el msj1: "--MASTERMIND-- Escriba su nombre: "

		la $a0, nombre
		li $v0, 8							
		syscall									#En 'nombre' queda almacenado el nombre del usuario
	
		lb $v0, nombre
		li $a0, 0x71
		beq $v0, $a0, fin						#Si el usuario introdujo una 'q', fin del juego
	
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		
		
#################### - ABRIR ###################

abrir:
		la	$a0, NombreArchivo
		li	$a1, 0x100	            			#Flag 0x100 
		li	$a2, 0x1FF	   	    				#Modo 0x1FF

		li $v0, 13		   	    				#Llamada syscall para abrir el archivo
		syscall				    				#Se guarda el file descriptor en $v0

		move $s6, $v0 			    			#Se guarda el file descriptor en $s6
	
	

################## - LEER - ###################

		move	$a0, $s6		    			#Se pasa el file descriptor a $a0 

		la $a1, Buffer			    			#Archivo queda en Buffer
		li $a2, 1000           		    		#La cantidad que se va a leer del archivo
		li $v0, 14
		syscall

	
	
######### - INICIALIZACION PARA LECTURA ########

		li $s2, 0								#Contador del Buffer
		li $s5, 0
		li $t0, 0
		li $t1, 0
		li $t4, 0
		li $t9, 2
		li $t8, 1
		neg $t8, $t8
	
		lb $t2, uno
		li $s7, 0x30							#$s7=0
		li $t3, 0x39							#$t3=9
		li $s4, 0xA								#$s4=Salto de linea			
		li $t5, 10								#$t5=10
		li $t6, 3								#$t6=3 min para numero de intentos
		li $t7, 15								#$t7=15 max para numero de intentos

		

########### - LEER NUMERO DE INTENTOS ########## 

NumIntentos:		
	
		lb $s3, Buffer($s2)						#$s3 = Lo que este en la posicion $s2 del Buffer

		beq $s3, $s4, Sig						#Si $s3 es salto de linea, ir a la Siguiente linea
		beq $s2, $t9, FueraRango				#Verificar si el primer numero del archivo tiene mas de dos digitos
		
		blt $s3, $s7, NoEsNumero     			#Si $s3 es menor a 0, el elemento no esta en rango
		bgt $s3, $t3, NoEsNumero     			#Si $s3 es mayor a 9, el elemento no esta en rango
	
		beq $s3, $t2, EsUno						#Ver si el num del buffer es un 1 para sumarle 9 en EsUno
		bne $s3, $t2, NoEsUno					#De lo contrario saltar a NoEsUno
	  
EsUno:
		bgtz $t4, NoEsUno						#Si el contador es mayor a cero es porque ya se agrego la decena y ahora tocaria agregar la unidad

		add $t0, $s3, -0x30 					#Se resta 30 para cambiar el caracter tomado del buffer por un entero
	  
		addi $t0, 9       						#Se le suma 9 para cambiarlo a 10 y queda en $t0 el resultado para sumarlo despues
		addi $s2, 1	
		addi  $t4, 1 
 
		b NumIntentos							#Se hace un brico a NumIntentos para calcular el segundo digito del numero
		
NoEsUno: 
		add $t1, $s3, -0x30 					#Se resta 30 para transformar el numero en entero
 
		add $s3, $t1, $t0   					#Se suma lo que se calculo en $t0 y $t1
	 
		blt $s3, $t6, FueraRango     			#Se verifica si el numero es >= 3
		bgt $s3, $t7, FueraRango	 			#Se verifica si el numero es <= 15
	 	
		sw $s3, NumInt($s5)						#Se guarda en NumInt el numero de intentos
	
		addi $s2, 1
		addi $s5, 1
		addi $t4, 1
	
		b NumIntentos
	
Sig:
		li $t0, 0								#Limpiar variables
		li $t1, 0
		li $s5, 0
		li $t4, 0
		li $t9, 0
		li $t6, 0
		li $t7, 0
		
		b copiarbuff

copiarbuff:
		addi $s2, 1

		lb $s3, Buffer($s2)						#Se lee del buffer el caracter
	
		blez $s3, fin							#Se verifica si es fin de archivo
		beq $s3, $s4, ObtenerCantPartidas		#Se verifica si es salto de linea
	
		blt $s3, $s7, NoEsNumero    			#Se verifica si es un numero
		bgt $s3, $t3, NoEsNumero     
	
		sb $s3, BufferAux($s5)					#Se guarda en un buffer auxiliar
	
		addi $t4, 1								#Se lleva un conteo de la cantidad de caracteres que se estan agregando en el buffer auxiliar 
		addi $s5, 1
	
		b copiarbuff

		
		
##### - MSJS DE INCONSISTENCIA DE ARCHIVOS #####
 
NoEsNumero:
		la $a0, NoNumero 						#Se imprime el mensaje NoNumero: "No es numero lo que esta en el archivo"
		li $v0, 4			
		syscall	
	
		b fin
	
FueraRango:										#Se imprime el mensaje NoRango: "El numero de intentos no esta entre 3 y 15"
		la $a0, NoRango 
		li $v0, 4			
		syscall	
	
		b fin
		
		
		
############ - LEER NUMERO DE PARTIDAS #########
	
ObtenerCantPartidas:
		lb $s3, BufferAux($t1)					#Se saca del buffer auxiliar los caracteres

		add $t4, $t4, $t8						#Se le resta 1 al contador de caracteres del buffer auxiliar 

		move $t6, $t4 							#Se copia en $t6 para utilizarlo de contador en exp (exponente del 10)
		li $t0, 1
		add $t6, $t6, $t8 
	
exp:
		bltz $t6, multiplicar					#Mientras el contador sea distinto de cero se hace la multiplicacion
		mul $t0, $t0, $t5						#Se hace la siguiente operacion $t0 = $t0*10
		add $t6, $t6, $t8 						#Se le resta uno al contador de exponente
		
		b exp

multiplicar:
		add $s3, $s3, -0x30   					#Se le resta 30 al caracter para volverlo entero
		mul $t0, $t0, $s3						#Se multiplica por la cantidad que se obtuvo en exp 
		add $t7, $t7, $t0 						#Se guarda en una variable auxiliar 
		addi $t1, 1
	
		bgtz $t4, ObtenerCantPartidas			#Mientras el contador de caracteres sea mayor a cero se sigue haciendo el procedimiento

		move $s3, $t7
	
		li $s5, 0
		sw $s3, NroPartidas($s5)				#Se guarda la variable auxiliar que lleva la suma del numero

		b inicializacionRegsPerm
	


############### - REGS PERMANENTES #############

inicializacionRegsPerm:
		li $s1, 0								#$s1=0 Iterador de numero de partidas
		li $t9, 0								#$t9=0 Puntaje
		
		
		
############ - INICIALIZACION DE REG ###########

inicializacionPartida:
		li $t0, 0								#$t0=0 Para recorrer arreglos
		li $t1, 0								#$t1=0 Para recorrer arreglos
		li $t2, 0								#$t2=0 Para recorrer arreglos
		li $t3, 0								#$t3=0 Para almacenar contenido de posicion de un arreglo
		li $t4, 0								#$t4=0 Para almacenar contenido de posicion de un arreglo
		li $t5, 0								#$t5=0 Iterador de numero de intentos

		li $t8, 0								#$t8=0 Contador de veces que los numeros estan en la misma pos
		li $s0, 0								#$s0=0 Para almacenar X, N y B
		li $s5, 0
		lw $t6, NumInt							#$t6 Numero de intentos
		lw $t7, NroPartidas						#$t7 Numero de partidas
		
		
		
############# - INICIO DE PARTIDA ##############	
		
partida:
		la $a0, msj9
		li $v0, 4
		syscall									#Se imprime el msj9: "----PARTIDA #"
		
		li $v0, 1
		move $a0, $s1
		syscall									#Se imprime el nro de partida
		move $s1, $a0

		addi $s1, 1
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		
		la $a0, msj10
		li $v0, 4
		syscall									#Se imprime el msj10: "----"
		
		la $a0, msj14
		li $v0, 4
		syscall									#Se imprime el msj14: "JUGADOR: "
		
		la $a0, nombre
		li $v0, 4
		syscall									#Se imprime el nombre
		
		la $a0, msj11
		li $v0, 4
		syscall									#Se imprime el msj11: "PUNTAJE : "
		
		li $v0, 1
		move $a0, $t9
		syscall									#Se imprime el puntaje $t9
		move $t9, $a0
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		li $t3, 0x39
		
		
		
############# - INICIALIZACION DE A ############
								
obtenerPartida:									#Inicializacion del codigo a romper
		addi $s2, 1
		
		lb $s3, Buffer($s2)						#Se obtiene el codigo

		blez $s3, inicializacionC				#Se verifica si es el final de archivo
		beq $s3, $s4, inicializacionC			#Una vez que se termina el ciclo de obtener el codigo se brinca a inicializar el arreglo de control C
		
		blt $s3, $s7, NoEsNumero
		bgt $s3, $t3, NoEsNumero

		sb $s3, A($s5)							#Se guarda en el .space A 
		
		addi $s5, 1
		
		b obtenerPartida

		
		
############ - INICIALIZACION DE C #############

inicializacionC:								#Inicializacion del arreglo de control C, todo en X
		li $s0, 0x58							#$s0=X
		sb $s0, C($t0)
		addi $t0, 1
		ble $t0, 0x3, inicializacionC


		
############## - INICIO DE INTENTO #############
		
Intento:
		la $a0, msj7
		li $v0, 4
		syscall									#Se imprime el msj7: "-Intento #"
		
		li $v0, 1
		move $a0, $t5
		syscall									#Se imprime el nro de intento
		
		move $t5, $a0
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		li $t0, 0
		li $t1, 0
		li $t2, 0
		li $t3, 0
		li $t4, 0
		
		b inicializacionZ
		
		
		
############# - PEDIR NUMEROS DE Z #############
		
inicializacionZ:								#Inicializacion del posible rompecodigo
		la $a0, msj2
		li $v0, 4
		syscall									#Se imprime el msj2: "Introduzca un numero: "

		la $a0, Z
		li $a1, 5
		li $v0, 8							
		syscall									#Se lee el numero de 4 digitos introducido
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		lb $v0, Z($0)
		li $a0, 0x71
		beq $v0, $a0, fin						#Si el usuario introdujo una 'q', fin del juego
		
		addi $t5, 1								#Iterador de intentos aumenta
		
		li $t0, 0
		li $t1, 0
		li $t2, 0								#Nuevo contador
		
		
		
##### - VER SI LOS NUMEROS DE Z ESTAN EN A #####

compararNum:
		beq $t1, 0x4, inicializarV				#Si t1 llega a 4 (Ya se comparo con todos los nums de A), seguir con el resto del prog
		lb $t3, A($t2)							#Se guarda en $t3 para poder usar en beq
		lb $t4, Z($t1)							#Se guarda en $t4 para poder usar en beq	
		beq $t3, $t4, iguales					#Si el numero en la posicion t2 de Z es igual al num en la posicion t1 de A => iguales
		bne $t3, $t4, diferentes				#Si el numero en la posicion t2 de Z es dist al num en la posicion t1 de A => diferentes
		
iguales:
		li $s0, 0x42							#$s0=B
		sb $s0, C($t1)							#En C(t1) guardo B (Que significa que Z(t1) esta en A(t2))
		addi $t1, 1								#Aumento t1 para probar con el prox num de Z
		li $t2, 0								#Reinicio t2 para empezar a comparar con el primer num de A
		b compararNum							#Seguir con la comparacion
		
diferentes:	
		beq $t2, 0x3, noSeEncontroIgualdad		#Si Z(t1) se comparo con todos los nums de A => noSeEncontroIgualdad
		addi $t2, 1								#Aumento t2 para probar con el prox num de A
		b compararNum							#Seguir con la comparacion
		
noSeEncontroIgualdad:
		addi $t1, 1								#Aumento t1 para pribar con el prox num de Z
		li $t2, 0								#Reinicio t2 para empezar a comparar con el primer num de A
		b compararNum							#Seguir con la comparacion
	
		
		
############# - COMPARAR POSICIONES ############
	
inicializarV:
		li $t1, 0
		li $t2, 0
		li $t3, 0
		li $t4, 0
		li $t8, 0
		
compararPos:
		beq $t1, 0x4, finIntento				#Si el iterador es menor o igual a 3, sigue la operacion
		lb $t3, A($t1)
		lb $t4, Z($t1)
	
		beq $t3, $t4, mismaPos					#Si A(t1)=Z(t1), estan en la misma posicion
		addi $t1, 1	
		b compararPos

mismaPos:
		addi $t8, 1								#Contador de veces que los numeros estan en la misma pos
		li $s0, 0x4E							#$s0=N
		sb $s0, C($t1)							#En C sustituyo lo que haya por una N (misma posicion)
		addi $t1, 1								#Aumento t1 para revisar la proxima casilla
		b compararPos
		

		
################ - FIN DE INTENTO ##############

finIntento:
		la $a0, msj6
		li $v0, 4
		syscall									#Se imprime el msj6: "Patron de control: "
		
loopImprimir:									#Se imprime el arreglo de control
		li $v0, 11
		lb $t3, C($t2)
		move $a0, $t3
		syscall
		addi $t2, 1
		blt $t2, 4, loopImprimir
		b inicializacion2C
		
inicializacion2C:								#Inicializacion del arreglo de control C, todo en X
		li $s0, 0x58							#$s0=X
		sb $s0, C($t0)
		addi $t0, 1
		ble $t0, 0x3, inicializacion2C
		b verificar
		
verificar:
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		beq $t8, 0x4, adivinado					#Si se adivino el codigo
		beq $t5, $t6, finDePartida				#Si se acabaron los intentos, fin de partida
		bne $t5, $t6, Intento					#Si quedan intentos, volver a Intento.

adivinado:		
		blt $t5, $t6, dosPuntos					#El jugador adivino y quedan intentos
		beq $t5, $t6, unPunto					#Adivino pero se acabaron los intentos

		
dosPuntos:										#Se suman 2 puntos a la puntuacion
		addi $t9, 2
		b finDePartidaExitosa
		
unPunto:										#Se suma 1 punto a la puntuacion
		addi $t9, 1
		b finDePartidaExitosa
		
		
		
################ - FIN DE PARTIDA ##############

finDePartidaExitosa:
		li $t1, 0

		la $a0, msj3
		li $v0, 4
		syscall									#Se imprime el msj3: "FIN DE LA PARTIDA. \n"
		
		la $a0, msj8
		li $v0, 4
		syscall									#Se imprime el msj8: "HA DESCIFRADO EL CODIGO! "
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		b jugarDeNuevo

finDePartida:
		li $t1, 0

		la $a0, msj3
		li $v0, 4
		syscall									#Se imprime el msj3: "FIN DE LA PARTIDA. \n"
		
		la $a0, msj4
		li $v0, 4
		syscall									#Se imprime el msj4: "El codigo correcto era: "

		li $v0, 4
		la $t3, A								
		move $a0, $t3
		syscall									#Se imprime A, el codigo secreto
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		b jugarDeNuevo
	
jugarDeNuevo:
		beq $s1, $t7, fin 						#Si el contador de partidas es igual al numero de partidas, fin	
		
		la $a0, msj12
		li $v0, 4
		syscall									#Se imprime el msj12: "Desea jugar otra vez? (s/n): "
		
		li $v0, 12							
		syscall									#En $v0 queda almacenado la respuesta
		
		move $t0, $v0							#Se pasa a $t0 para poder usar $v0 el paso que viene
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea

		beq $t0, 0x73, inicializacionPartida	#Jugador presiono s
		beq $t0, 0x6E, fin						#Jugador presiono n
		beq $t0, 0x71, fin						#Si el usuario introdujo una 'q', fin del juego
		
fin:	
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		la $a0, msj15
		li $v0, 4
		syscall									#Se imprime el msj13:"Puntuacion Total: "

		move $a0, $t9
		li $v0, 1
		syscall									#Se imprime la puntuacion final
		
		la $a0, endl
		li $v0, 4
		syscall									#Salto de linea
		
		la $a0, msj13
		li $v0, 4
		syscall									#Se imprime el msj13:"FIN DEL JUEGO."
		
		li $v0 10
		syscall