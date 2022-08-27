    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/edu_ciaa.s"
    .include "configuraciones/poncho.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

    // Todo está definido en edu_ciaa.s y poncho.s

/****************************************************************************/
/* Vector de interrupciones                                                 */
/****************************************************************************/

    .section .isr           // Define una seccion especial para el vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value
    .word   handler+1       //  2: Non mascarable interrupt service routine
    .word   handler+1       //  3: Hard fault system trap service routine
    .word   handler+1       //  4: Memory manager system trap service routine
    .word   handler+1       //  5: Bus fault system trap service routine
    .word   handler+1       //  6: Usage fault system tram service routine
    .word   0               //  7: Reserved entry
    .word   0               //  8: Reserved entry
    .word   0               //  9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call trap service routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service system trap service routine
    .word   systick_isr+1   // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM)
espera:
    .zero 1                 // Variable compartida con el tiempo de espera
    .zero 1                 // Variable compartida con el tiempo de espera

conversor:
    .word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK )               // 0
	.word ( SEG_B_MASK | SEG_C_MASK )										                            // 1
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_D_MASK | SEG_E_MASK | SEG_G_MASK )	                        // 2
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_G_MASK )	                        // 3
	.word ( SEG_B_MASK | SEG_C_MASK | SEG_F_MASK | SEG_G_MASK )				                            // 4
	.word ( SEG_A_MASK | SEG_C_MASK | SEG_D_MASK | SEG_F_MASK | SEG_G_MASK ) 	                        // 5
	.word ( SEG_A_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )	            // 6
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK )				 				                        // 7
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK)   // 8
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_F_MASK | SEG_G_MASK )               // 9

data_segundos:
	.byte 0x0
	.byte 0x0

data_minutos:
	.byte 0x0
	.byte 0x0

data_hora:
	.byte 0x0
	.byte 0x0

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina para configurar el systick
    BL systick_init

    // Configura los pines de los digitos
    LDR R1,=SCU_BASE

    // Configura los DIGITOS del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]     //P0_0
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]     //P0_1
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]     //P1_15
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]     //P1_17

    // Configura los segmentos de los displays del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]     //P4_0
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]     //P4_1
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]     //P4_2
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]     //P4_3
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]     //P4_4
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]     //P4_5
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]     //P4_6
    STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]   //P6_8

    LDR R1,=GPIO_CLR0
    // Apaga todos los bits gpio de los 7 segmentos
    LDR R0,=SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]
    // Se apagan los bits gpio correspondientes a los digitos.
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    LDR R1,=GPIO_DIR0
    // Configura los bits gpio de los 7 segmentos como salidas
    LDR R0,[R1,#SEG_N_OFFSET]
    ORR R0,#SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]
    // Se configuran los digitos como salida.
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0

refrescar:
	puntero			.req R0
    valor 			.req R2
    display_activo 	.req R3
	io_pines		.req R4

    MOV R0,#0x1000              // Utilizo una demora de 1000 para refrescar los digitos
    demora:
        SUBS R0,#1
        BNE demora

    // Define el estado actual de los 7seg y los digitos como todos apagados
    MOV   valor, #0x00
    STR   valor, [io_pines, #DIG_OFFSET]
    STR   valor, [io_pines, #SEG_N_OFFSET]

	//Defino con cual display vamos a molestar (display + 1 modulo 4)
	ADD display_activo, #1
	AND display_activo, #3

	//Actualizo el segmento con los datos
	LDR		puntero, =data_segundos
	LDRB	valor, [puntero, display_activo]		//traigo el minuto u hora. 
	LDR		puntero, =conversor
	LDR		valor, [puntero, valor, LSL #2]			//convierto asi le hago el display
    
	STR     valor, [io_pines, #SEG_N_OFFSET]
    
    // Prende el digito n
	LDR		puntero, =mostrar_display
	LDR		valor, [puntero, display_activo, LSL #2]	//traigo la mascara de mi digito
    STR     valor, [io_pines, #DIG_OFFSET]		//escribo mi digito
    
    B     refrescar
    
stop:
    B stop
    .pool                   // Almacenar las constantes de código

    .endfunc

/************************************************************************************/
/* Rutina de inicialización del SysTick                                             */
/************************************************************************************/
.func systick_init
systick_init:
    CPSID I                     // Se deshabilitan globalmente las interrupciones

    // Se sonfigura prioridad de la interrupcion
    LDR R1,=SHPR3               // Se apunta al registro de prioridades
    LDR R0,[R1]                 // Se cargan las prioridades actuales
    MOV R2,#2                   // Se fija la prioridad en 2
    BFI R0,R2,#29,#3            // Se inserta el valor en el campo
    STR R0,[R1]                 // Se actualizan las prioridades

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]                 // Se quita el bit ENABLE

    // Se configura el desborde para un periodo de 100 ms
    LDR R1,=SYST_RVR
    @ LDR R0,=#(48000000 - 1)
    LDR R0,=#(480000 - 1)
    STR R0,[R1]                 // Se especifica el valor de RELOAD

    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    // Escribir cualquier valor limpia el contador
    STR R0,[R1]                 // Se limpia COUNTER y flag COUNT

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1]                 // Se fijan ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                     // Se habilitan globalmente las interrupciones
    BX  LR                      // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de código
.endfunc


/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
    .func systick_isr
systick_isr:
	@ PUSH {LR}
	@ BL	actualizar_digitos
	@ POP {LR}

    LDR  R0,=espera             // Se apunta R0 a la variable espera
    LDRB R1,[R0]                // Se carga el valor de la variable espera

    @ LDRB R2,[R0,#1]                // Se carga el valor de la variable espera
    @ ADD  R2,#1
    @ CMP  R2,#10
    @ BEQ actualizar_digitos

	@ PUSH {R0, LR}               // El push al LR es necesario para que ande
	@ BL	actualizar_digitos
	@ POP {R0, LR}



    SUBS R1,#1                  // Se decrementa el valor de espera
    BHI  systick_exit           // Si Espera > 0 entonces NO pasaron 500 iteraciones

	PUSH {R0, LR}               // El push al LR es necesario para que ande
	BL	actualizar_reloj
	POP {R0, LR}

    MOV  R1,#500                // Se recarga la espera con 500 iteraciones

systick_exit:
    STRB R1,[R0]                // Se actualiza la variable espera

    BX   LR                     // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de codigo
    .endfunc


/************************************************************************************/
/* Rutina de para actualizar los digitos                                            */
/************************************************************************************/
    .func actualizar_digitos
actualizar_digitos:
    PUSH {LR}
    PUSH {R0-R4}
    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0

	puntero			.req R0
    valor 			.req R2
    display_activo 	.req R3
	io_pines		.req R4

    @ MOV R0,#0x1000

    @ demora:
    @ SUBS R0,#1
    @ BNE demora

    // Define el estado actual de los 7seg y los digitos como todos apagados
    MOV   valor, #0x00
    STR   valor, [io_pines, #DIG_OFFSET]
    STR   valor, [io_pines, #SEG_N_OFFSET]

	//Defino con cual display vamos a molestar (display + 1 modulo 4)
	ADD display_activo, #0
	ORR display_activo, #1
	ORR display_activo, #2
	ORR display_activo, #3

	//Actualizo el segmento con los datos
	LDR		puntero, =data_segundos
	LDRB	valor, [puntero, display_activo]		//traigo el minuto u hora. 
	LDR		puntero, =conversor
	LDR		valor, [puntero, valor, LSL #2]			//convierto asi le hago el display
    
	STR     valor, [io_pines, #SEG_N_OFFSET]
    
    // Prende el digito n
	LDR		puntero, =mostrar_display
	LDR		valor, [puntero, display_activo, LSL #2]	//traigo la mascara de mi digito
    STR     valor, [io_pines, #DIG_OFFSET]		//escribo mi digito

    POP {R0-R4}


    @ PUSH  {R0}
    @ PUSH  {R4-R5}

    @ // Define los punteros para usar el programa
    @ LDR     R4,=GPIO_PIN0
    @ LDR     R5,=conversor

    @ MOV     R0,#0x00                // Define el estado actual de los DIGITOS y SEGMENTOS a todos apagados
    @ STR     R0,[R4,#DIG_OFFSET]
    @ STR     R0,[R4,#SEG_N_OFFSET]

    @ LDR     R0,=DIG_MASK
    @ STR     R0,[R4,#DIG_OFFSET]

    @ LDR     R1,=data_segundos
    @ LDRB    R0,[R1]
    @ LDRB    R0,[R5,R0]
    @ STR     R0,[R4,#SEG_N_OFFSET]
    
    @ LDRB    R0,[R1,#1]
    @ LDRB    R0,[R5,R0]
    @ STR     R0,[R4,#SEG_N_OFFSET]
    
    @ LDR     R1,=data_minutos
    @ LDRB    R0,[R1]
    @ LDRB    R0,[R5,R0]
    @ STR     R0,[R4,#SEG_N_OFFSET]
    
    @ LDRB    R0,[R1,#1]
    @ LDRB    R0,[R5,R0]
    @ STR     R0,[R4,#SEG_N_OFFSET]

    @ POP   {R4-R5}
    @ POP   {R0}


    @ BX LR                    // Retorna al programa principal
    POP {PC}
    .pool                       // Se almacenan las constantes de codigo

mostrar_display:
    .word DIG_1_MASK
	.word DIG_2_MASK
	.word DIG_3_MASK
	.word DIG_4_MASK

    .endfunc



/************************************************************************************/
/* Rutina de para actualizar el reloj                                               */
/************************************************************************************/
    .func actualizar_reloj
actualizar_reloj:
    PUSH  {LR}                   // Conservar la dirección de retorno
    MOV   R0,#1                  // Setea R0 en 1
    LDR   R1,=data_segundos      // Guardo direccion del LSB es decir del seg0
    BL    incrementar            // Llamo a la incrementar
    CMP   R0,#1                  // Comparo R0 con 1
    ITT   EQ 
    ADDEQ R1,#2                  // Salto si R0 = 1 (si hay desbordamiento de seg)
    BLEQ  incrementar            // Salto si R0 = 1 (si hay desbordamiento de seg)
    POP   {PC}                   // Retornar recuperando PC de la pila

incrementar:
    PUSH  {R4-R5}
    LDRB  R4,[R1]                // Busca el valor menos significativo
    ADD   R4,R0                  // Se incrementa en R0 cantidad
    MOV   R0,#0                  // Setea el valor de retorno por defecto
    CMP   R4,#9
    BLS   final_incrementar      // Salta si es menor o igual que 9
    SUB   R4,#9                  // Calcula la cantidad que se desbordo
    LDRB  R5,[R1, #1]            // Busca el valor mas significativo
    ADD   R5,R4                  // Se incrementa en la cantidad de desborde
    MOV   R4,#0                  // Resetea el menos significatico
    CMP   R5,#5
    BLS   salto_incrementar      // Salta si es menor o igual que 5
    MOV   R5,#0                  // Resetea el mas significatico
    MOV   R0,#1                  // Setea el valor de retorno por desborde

salto_incrementar:
    STRB  R5,[R1, #1]            // Almacena el nuevo valor menos significativo

final_incrementar:
    STRB  R4,[R1]                // Almacena el nuevo valor mas significativo
    POP   {R4-R5}
    BX    LR                     // Retorna al programa principal
    .pool                        // Se almacenan las constantes de codigo
    .endfunc

/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.          */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/
    .func handler
handler:
    LDR R1,=GPIO_SET0           // Se apunta a la base de registros SET
    MOV R0,#LED_1_MASK          // Se carga la mascara para el LED 1
    STR R0,[R1,#LED_1_OFFSET]   // Se activa el bit GPIO del LED 1
    B handler                   // Lazo infinito para detener la ejecucion
    .pool                       // Se almacenan las constantes de codigo
    .endfunc
