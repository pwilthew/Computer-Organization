#################################################################################
#SOLO PARA CORRER En Linux Mint, KATE																				# 
# Universidad Simón Bolívar														# 
# CI-3815 Organización del Computador											# 
# Trimestre Septiembre-Diciembre 2012											# 
# 																				# 
# Proyecto 2 -Implementación del juego PAC-MAN en SPIM mediante la 				# 
# programación de un manejador de interrupciones 								# 
# 																				# 
# Hecho por: 																	# 
# -Patricia Wilthew. Carnet: 09-10910											# 
# -Abelardo Valino. Carnet: 10-10738											# 
#																				# 
# Archivo: proyecto2Grupo24.s -manejador de instrucciones						# 
# 																				# 
#################################################################################

# SPIM S20 MIPS simulator.
# The default exception handler for spim.
#
# Copyright (c) 1990-2010, James R. Larus.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# Neither the name of the James R. Larus nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# Define the exception handling code.  This must go first!

	.kdata
__m1_:	.asciiz "  Exception "
__m2_:	.asciiz " occurred and ignored\n"
__e0_:	.asciiz "  [Interrupt] "
__e1_:	.asciiz	"  [TLB]"
__e2_:	.asciiz	"  [TLB]"
__e3_:	.asciiz	"  [TLB]"
__e4_:	.asciiz	"  [Address error in inst/data fetch] "
__e5_:	.asciiz	"  [Address error in store] "
__e6_:	.asciiz	"  [Bad instruction address] "
__e7_:	.asciiz	"  [Bad data address] "
__e8_:	.asciiz	"  [Error in syscall] "
__e9_:	.asciiz	"  [Breakpoint] "
__e10_:	.asciiz	"  [Reserved instruction] "
__e11_:	.asciiz	""
__e12_:	.asciiz	"  [Arithmetic overflow] "
__e13_:	.asciiz	"  [Trap] "
__e14_:	.asciiz	""
__e15_:	.asciiz	"  [Floating point] "
__e16_:	.asciiz	""
__e17_:	.asciiz	""
__e18_:	.asciiz	"  [Coproc 2]"
__e19_:	.asciiz	""
__e20_:	.asciiz	""
__e21_:	.asciiz	""
__e22_:	.asciiz	"  [MDMX]"
__e23_:	.asciiz	"  [Watch]"
__e24_:	.asciiz	"  [Machine check]"
__e25_:	.asciiz	""
__e26_:	.asciiz	""
__e27_:	.asciiz	""
__e28_:	.asciiz	""
__e29_:	.asciiz	""
__e30_:	.asciiz	"  [Cache]"
__e31_:	.asciiz	""
__excp:	.word __e0_, __e1_, __e2_, __e3_, __e4_, __e5_, __e6_, __e7_, __e8_, __e9_
	.word __e10_, __e11_, __e12_, __e13_, __e14_, __e15_, __e16_, __e17_, __e18_,
	.word __e19_, __e20_, __e21_, __e22_, __e23_, __e24_, __e25_, __e26_, __e27_,
	.word __e28_, __e29_, __e30_, __e31_
	
#############################################################
# Declaracion de las etiquetas de memoria donde se preservan# 
#los registros usados en el manejador                 	#
#############################################################

s0:	.word 0	
s1:	.word 0
s2:	.word 0
s3:	.word 0
s4:	.word 0
s5:	.word 0
s6:	.word 0
s7:	.word 0

t0:	.word 0
t1:	.word 0
t2:	.word 0
t3:	.word 0
t4:	.word 0
t5:	.word 0
t6:	.word 0
t7:	.word 0
t8:	.word 0
t9:	.word 0

####################################################
# Declaracion de los mensajes para el juego	      #
####################################################

NoArchivo:		.asciiz "No se cumplen las especificaciones de los niveles"
EscribaArchivo:		.asciiz "Escriba el nombre del archivo donde se encuentran los niveles: "
ArchivoDefault:		.asciiz "pac.txt"
texto_NoMasNiveles:	.asciiz "No existen mas niveles"
nulo:			.asciiz ""
msjEmpezar:		.asciiz "Pulse enter para comenzar el juego: "
texto_pedirArchivo:	.asciiz "ESCRIBA NOMBRE DE AbrirArchivo CONTENERDOR DE CargarNivelES: "
texto_finJuego:		.asciiz "GAME OVER"
texto_puntaje:		.asciiz "Puntaje: "
texto_nivel:		.asciiz "Nivel "
texto_vida:		.asciiz " Vidas: "
texto_puntajeFinal:	.asciiz "PUNTUACION FINAL: "
endl:			.asciiz "\n"
endl2:			.asciiz "\n\n\n\n"
pagblanco:		.asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
texto_bienvenida:	.asciiz "\n#######################################\n" 
texto_bienv2:		.asciiz "BIENVENIDO A PAC-MAN                                   \n" 
texto_bienv3:		.asciiz " UTILIZA 'w' O 's' PARA DESPLAZARTE EN DIR NORTE O SUR  \n" 
texto_bienv4:		.asciiz "Y 'k' O 'l' PARA DIR OESTE O ESTE                     \n" 
texto_bienv5:		.asciiz "#######################################\n\n" 
texto_perdiste:		.asciiz "\n\n\tHAS PERDIDO :( \n\n" 
texto_ganaste: 		.asciiz "\n\n\tFELICIDADES, ERES GANADOR\n\n" 
texto_adios: 		.asciiz "\n\n\t FIN DEL JUEGO\n\n" 
				.align 2

####################################################
# Declaracion de los '.space' para el juego	      #
####################################################

matriz:			.space 1000				
NombreArchivo:		.space 200
NombreArchivoAux:	.space 200
Buffer:			.space 2000
BufferAux:		.space 2000	
				.align 2

####################################################
# Declaracion de los '.word' para el juego	      #
####################################################

fin:			.word 1
pos_inicial_pacman:	.word 0
pos_inicial_blinky:	.word 0
pos_inicial_pinky:	.word 0
pos_inicial_inky:	.word 0
pos_actual_pacman:	.word 0
nro_vidas:		.word 2
cantidad_cerezas:	.word 0
cantidad_comida:	.word 0
nro_columnas:		.word 0	
nro_niveles:		.word 0
puntuacion:		.word 0
puntuacion_actual:	.word 0
puntuacion_max:	.word 0
timer:			.word 0
				.align 2


# This is the exception handler code that the processor runs when
# an exception occurs. It only prints some information about the
# exception, but can server as a model of how to write a handler.
#
# Because we are running in the kernel, we can use $k0/$k1 without
# saving their old values.

# This is the exception vector address for MIPS-1 (R2000):
#	.ktext 0x80000080
# This is the exception vector address for MIPS32:
	.ktext 0x80000180
# Select the appropriate one for the mode in which SPIM is compiled.
	.set noat
	move $k1 $at		# Save $at
	.set at
	sw $v0 s1		# Not re-entrant and we can't trust $sp
	sw $a0 s2		# But we need to use these registers


####################################################
# PRESERVO LOS REGISTROS                          #
####################################################
	
	sw $s0, s0			
	sw $s3, s3	
	sw $s4, s4	
	sw $s5, s5	
	sw $s6, s6	
	sw $s7, s7	
	
	sw $t0, t0			
	sw $t1, t1	
	sw $t2, t2	
	sw $t3, t3	
	sw $t4, t4	
	sw $t5, t5	
	sw $t6, t6	
	sw $t7, t7
	sw $t8, t8	
	sw $t9, t9	
	
####################################################
#           INICIO DE LOS EXCEPTIONS               #
####################################################

	mfc0 $t9, $12
	andi $t9, $t9, 0xfffe  ### Se desactivan todas las interrupciones 
	mtc0 $t9, $12	       ### para que no se aniden

	mfc0 $k0 $13		# Cause register
	srl $a0 $k0 2		# Extract ExcCode Field
	andi $a0 $a0 0x1f

### Después de desplazar y hacer el and en $a0 solo 
### tengo el Exception Code 

	beqz $a0,interrupt 	### Sí es 0, por la tabla de Exception Code  
				### se que es de hardware y la trato 


	# Print information about exception.
	#
	li $v0 4		# syscall 4 (print_str)
	la $a0 __m1_
	syscall

	li $v0 1		# syscall 1 (print_int)
	srl $a0 $k0 2		# Extract ExcCode Field
	andi $a0 $a0 0x1f
	syscall

	li $v0 4		# syscall 4 (print_str)
	andi $a0 $k0 0x3c
	lw $a0 __excp($a0)
	nop
	syscall

	bne $k0 0x18 ok_pc	# Bad PC exception requires special checks
	nop

	mfc0 $a0 $14		# EPC
	andi $a0 $a0 0x3	# Is EPC word-aligned?
	beq $a0 0 ok_pc
	nop

	li $v0 10		# Exit on really bad PC
	syscall

ok_pc:
	li $v0 4		# syscall 4 (print_str)
	la $a0 __m2_
	syscall

	srl $a0 $k0 2		# Extract ExcCode Field
	andi $a0 $a0 0x1f
	bne $a0 0 ret		# 0 means exception was an interrupt
	nop

# Interrupt-specific code goes here!
# Don't skip instruction at EPC since it has not executed.

interrupt:

	andi $t8, $k0, 0x8000		
	li $s7, 0x8000
	beq $t8, $s7, ActualizarPantalla  ###Verifica el timer

	lw 	$t3, 0xffff0004
	li 	$t5, 0x000000ff 	 ###Leer Tecla
	and $t5, $t5, $t3

	#Verificamos cual es la tecla que se presiono

	beq $t5, 0x6B, izq
	beq $t5, 0x4B, izq
	beq $t5, 0x6C, der
	beq $t5, 0x4C, der
	beq $t5, 0x77, arriba
	beq $t5, 0x57, arriba
	beq $t5, 0x73, abajo
	beq $t5, 0x53, abajo
	beq $t5, 0x71, salir
	beq $t5, 0x51, salir

	b ActualizarPantalla

####################################################
#                 Movimientos                      #
####################################################

izq: 

	lw $t6, pos_actual_pacman
	move $t5, $t6
	addi $t6, -1
	lb $t7, matriz($t6)
	
	beq $t7, 0x58, ActualizarPantalla
	beq $t7, 0x61, UnPunto
	beq $t7, 0x2A, CienPunto
	beq $t7, 0x24, Ghost
	beq $t7, 0x6F, Nada
	
der:

	lw $t6, pos_actual_pacman
	move $t5, $t6
	addi $t6, 1
	lb $t7, matriz($t6)
	
	beq $t7, 0x58, ActualizarPantalla
	beq $t7, 0x61, UnPunto
	beq $t7, 0x2A, CienPunto
	beq $t7, 0x24, Ghost
	beq $t7, 0x6F, Nada
	
arriba:

	lw $t8, nro_columnas 
	neg $t8, $t8
	
	lw $t6, pos_actual_pacman
	move $t5, $t6
	add $t6, $t6, $t8
	lb $t7, matriz($t6)
	
	beq $t7, 0x58, ActualizarPantalla
	beq $t7, 0x61, UnPunto
	beq $t7, 0x2A, CienPunto
	beq $t7, 0x24, Ghost
	beq $t7, 0x6F, Nada
	
abajo:


	lw $t8, nro_columnas 
	
	lw $t6, pos_actual_pacman
	move $t5, $t6
	add $t6, $t6, $t8
	lb $t7, matriz($t6)
	
	beq $t7, 0x58, ActualizarPantalla
	beq $t7, 0x61, UnPunto
	beq $t7, 0x2A, CienPunto
	beq $t7, 0x24, Ghost
	beq $t7, 0x6F, Nada
	
Ghost:

	lw $t7, nro_vidas
	addi $t7, -1
	sw $t7, nro_vidas
	
	beqz $t7, ActualizarPantalla
	
	lw $t7, pos_actual_pacman
	li $t8, 0x6F
	sb $t8, matriz($t7)
	
	lw $t7, pos_inicial_pacman
	li $t8, 0x3C
	sb $t8, matriz($t7)
	sw $t7, pos_actual_pacman
	
	b ActualizarPantalla
	
UnPunto:

	lw $t7, cantidad_comida
	addi $t7, -1
	sw $t7, cantidad_comida

	lw $t7, puntuacion_actual
	addi $t7, 1
	sw $t7, puntuacion_actual
	
	b Nada
	
	
	b ActualizarPantalla

CienPunto:	


	lw $t7, cantidad_cerezas
	addi $t7, -1
	sw $t7, cantidad_cerezas

	lw $t7, puntuacion_actual
	addi $t7, 100
	sw $t7, puntuacion_actual
	
	b Nada
	
	
	b ActualizarPantalla
	
salir:

      sw $0, fin
      
      b ActualizarPantalla
	
Nada:

	li $t7, 0x6F
	sb $t7, matriz($t5)
	
	li $t7, 0x3C
	sb $t7, matriz($t6) 
	sw $t6, pos_actual_pacman
	

ActualizarPantalla:

	sw $0, timer

	la $a0, pagblanco			 
	li $v0, 4			
	syscall
	
	la $a0, texto_nivel          
	li $v0, 4			
	syscall	
	
	lw $a0, nro_niveles			 
	li $v0, 1			
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	la $a0, matriz			 
	li $v0, 4			
	syscall
	
	la $a0, texto_puntaje			 
	li $v0, 4			
	syscall	
	
	lw $a0, puntuacion_actual			 
	li $v0, 1			
	syscall
	
	la $a0, texto_vida			 
	li $v0, 4			
	syscall	
	
	lw $a0, nro_vidas			 
	li $v0, 1			
	syscall


####################################################
# RESTAURAR LOS REGISTROS                          #
####################################################

	lw $v0, s1
	lw $a0, s2

	lw $s0, s0			
	lw $s3, s3	
	lw $s4, s4	
	lw $s5, s5	
	lw $s6, s6	
	lw $s7, s7	
	
	lw $t0, t0			
	lw $t1, t1	
	lw $t2, t2	
	lw $t3, t3	
	lw $t4, t4	
	lw $t5, t5	
	lw $t6, t6	
	lw $t7, t7
	lw $t8, t8	
	lw $t9, t9
	
	
	.set noat
	move $at, $k1     #Restore $at
	
	.set at
	mtc0 $0, $13	  #Clear Cause register

	mfc0 $k0 $12 			### Habilitamos interrupciones en Status 
	ori $k0  0x01 
	mtc0 $k0 $12 

	mtc0 $0, $9 			### Inicializamos el registro timer en 0

	
# Return from exception on MIPS32:
	eret

# Return sequence for MIPS-I (R2000):

#	rfe					# Return from exception handler
						# Should be in jr's delay slot
#	jr $k0
#	nop
# Standard startup code.  Invoke the routine "main" with arguments:
# main(argc, argv, envp)
#

	.data
	.text
	.globl __start
	
	
	
__start:
	lw $a0 0($sp)		# argc
	addiu $a1 $sp 4		# argv
	addiu $a2 $a1 4		# envp
	sll $v0 $a0 2
	addu $a2 $a2 $v0




#################################################################################
# Bienvenida 									 								#
# Se imprime un mensaje de bienvenida											#
#################################################################################

	li $v0, 4
	la $a0, texto_bienvenida 
	syscall 

	la $a0, texto_bienv2 
	syscall 

	la $a0, texto_bienv3 
	syscall 

	la $a0, texto_bienv4 
	syscall 

	la $a0, texto_bienv5 
	syscall 
		
	mfc0  $t1, $12		###Activar las interrupciones
	ori $t1, $t1, 0x8401
	mtc0 $t1, $12

	lw $t1, 0xffff0000	###Habilitar las interrupciones por teclado
	ori $t1, $t1, 0x2
	sw $t1, 0xffff0000


	mtc0 $0, $9		###Inicializar timer y compare 
	li $t2, 100
	mtc0 $t2, $11 	

#################################################################################
# Lectura de Archivo										# 
#################################################################################

	
	la $a0, endl			 
	li $v0, 4			
	syscall
 	la $a0, EscribaArchivo		###Pedir Nombre de Archivo
 	li $v0, 4
	syscall
	
 	la $a0, NombreArchivo	
 	li $a1, 200
	li $v0, 8
	syscall

	li $t1, 0
	
	lw $t0, NombreArchivo($t1)
	
	beq $t0, 0xA, Default
	
Limpieza:				###Se limpia la direccion del archivo
      
	lb $t2, NombreArchivo($t1)
      
        beq $t2, 0xA, AbrirArchivo
        
        sb $t2, NombreArchivoAux($t1)
        
        addi $t1, 1

	b Limpieza
		
AbrirArchivo:
     
	la	$a0, NombreArchivoAux       	###Nombre del archivo en:
	li	$a1, 0x100	            	###Flag 0x100 
	li	$a2, 0x1FF	   	    	###Modo 0x1FF

	li $v0, 13		   	    	###Llamada syscall para abrir el archivo
	syscall				    	###Se guarda el file descriptor en $v0

	move $s6, $v0 
	
	b Leer
	
Default:
      
	la	$a0, ArchivoDefault          	###Nombre del archivo en 
	li	$a1, 0x100	            	###Flag 0x100 
	li	$a2, 0x1FF	   	    	###Modo 0x1FF

	li $v0, 13		   	    	###Llamada syscall para abrir el archivo
	syscall				    	###Se guarda el file descriptor en $v0

	move $s6, $v0 
	
	b Leer

Leer:

	move	$a0, $s6		    	###Se pasa el file descriptor a $a0 

	la $a1, Buffer			    	###Se guarda todo el archivo en el Buffer
	li $a2, 1000				###Se dice la cantidad que se va a leer del archivo
	li $v0, 14				###Se hace la llamada al sistema para leer
	syscall

	
	li $t3, 0				###Contador del buffer
	li $t1, 0
	li $t2, 0
	lb $t4, nulo($t3) 
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 1
	
LimpiarBuffer:					###Se quita del Buffer los 0xD

    
	lb $t2, Buffer($t1)
      
        beq $t2, 0xD, Next
                
        sb $t2, BufferAux($t3)
        
        beq $t2, 0xA, Revisar
 
LimpiarBuffer2:        
 
        addi $t3, 1
        addi $t1, 1
        
	b LimpiarBuffer	

Revisar:	
	
        add $t6, $t1, 1
	lb $t5, Buffer($t6)			###Verifico si hay otro salto de linea 
	beq $t5, 0xA, ContarColumnas
	beq $t5, $t4, ContarColumnas
	
	b LimpiarBuffer2
Next:

	addi $t1, 1
	
	b LimpiarBuffer
      
	
ContarColumnas:

	lb $t0, BufferAux($t7)

	beq $t0, 0xA, CargarNivel		 
	addi $t8, 1
	addi $t7, 1
	
	b ContarColumnas

CargarNivel:	

	sw $t8, nro_columnas	        ###Guardo cuantas columnas hay

	li $t3, 0			###Inicializar contador Buffer
	
Inicializacion:

	li $t0, 0
	li $t1, 0	
	li $t4, 0
	li $t5, 0	
	li $t6, 0	
	li $s6, 0
	li $t7, 1			###Contador de fantasmas (1: Blinky, 2: Pinky, 3: Inky)
	li $t8, 0
	li $t9, 1
	
	lb $s1, nulo($0) 
	li $s2, 0

	lw $s7, nro_niveles
	addi $s7, $s7, 1 
	sw $s7, nro_niveles
	
					###Analisis de matriz

AnalisisMatriz:	
  
	lb $t0, BufferAux($t3)
	
	sb $t0, matriz($s2)
	
	beq $t0, $s1, FinAnalisis
	
	beq $t0, 0xA, Fila		 
	beq $t0, 0x58, Sig		
	beq $t0, 0x61, Comida		
	beq $t0, 0x2A, Cerezas		
	beq $t0, 0x3C, Pacman		
	beq $t0, 0x24, Fantasmas	        
	
	b ErrorArchivo

Fantasmas:
    
 	beq $t7, 1, Blinky	
 	beq $t7, 2, Pinky	
 	beq $t7, 3, Inky	
    b ErrorArchivo

Blinky:

	sw $t1, pos_inicial_blinky

	addi $t7, 1
	b Sig
Pinky:

	sw $t1, pos_inicial_pinky
	
	addi $t7, 1
	b Sig
Inky:

	sw $t1, pos_inicial_inky
	
	addi $t7, 1
	b Sig	

Pacman:
  
	sw $t1, pos_inicial_pacman
	sw $t1, pos_actual_pacman
	
	b Sig
	
Cerezas: 
  
	addi $t6, 1
	sw $t6, cantidad_cerezas		
	
	b Sig
	
Comida:

	addi $s6, 1
	sw $s6, cantidad_comida 		
	
	b Sig

Fila:
	
	add $t5, $t3, 1
	lb $t4, BufferAux($t5)	
	beq $t4, 0xA, FinAnalisis
	
	b Sig
	
ErrorArchivo:

	add $t5, $t3, 1
	lb $t4, BufferAux($t5)			###Verifico si hay otro salto de linea 
	beq $t4, 0x0, Ganaste

	la $a0, NoArchivo			 
	li $v0, 4			
	syscall

	b FinJuego
       
Sig:

	addi $t1, 1
	addi $s2, 1
	addi $t3, 1

	b AnalisisMatriz
	
FinAnalisis:

	li $s7, 100
	
	mul $s7, $s7, $t6
	add $s7, $s7, $s6
	
	sw $s7, puntuacion_max
	
#################################################################################
# Loop infinito para que el juego este activo 									#
#################################################################################

loop_Infinito: 

	lw $t4, nro_vidas
	beqz $t4, FinJuego
	lw $t4, fin
	beqz $t4, FinJuego
	
	lw $t4, puntuacion_max
	lw $t5, puntuacion_actual
	beq $t5, $t4, Sig_nivel

	b loop_Infinito 
	
#################################################################################
# Siguiente nivel 									#
#################################################################################
	
Sig_nivel:

	  addi $t3, 1
	  	  
	  lw $s4, puntuacion_actual
	  lw $s5, puntuacion
	  add $s4, $s5, $s4
	  sw $s4, puntuacion
	  
	  sw $0, puntuacion_actual  
	  
	  addi $t3, 1
	  
	  b Inicializacion
  
Ganaste:

	la $a0, endl
	li $v0, 4
	syscall	  

	la $a0, texto_ganaste
	li $v0, 4
	syscall	  
	
	b ActualizarPunt  
	  
#################################################################################
# Fin del juego. Se ejecutara main.s											#
#################################################################################

FinJuego:

	lw $a0, nro_niveles
	
	bne $a0, 1, ActualizarPunt

	lw $a0, puntuacion_actual
	sw $a0, puntuacion
	b FinJuego2
	
ActualizarPunt:
  
	lw $a0, puntuacion_actual
	lw $a1, puntuacion
	add $a0, $a1, $a0
	sw $a0, puntuacion
	
FinJuego2:  

	la $a0, endl
	li $v0, 4
	syscall
	
	la $a0, texto_finJuego
	syscall
	
	la $a0, endl
	syscall
	
	la $a0, texto_puntajeFinal
	syscall
	
	lw $a0, puntuacion
	li $v0, 1
	syscall
	
	la $a0, endl2
	li $v0, 4
	syscall
	

	jal main
	nop

	li $v0 10
	syscall				# syscall 10 (exit)

	.globl __eoth
__eoth:

