    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/ciaa.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

//Primero debo definir los recursos utilizados por los SEGMENTOS
    //Segmento A
    .equ SEG_A_PORT,         4
    .equ SEG_A_PIN,          0
    .equ SEG_A_BIT,          0    
    .equ SEG_A_MASK,         (1 << SEG_A_BIT)

    //Segmento B
    .equ SEG_B_PORT,         4
    .equ SEG_B_PIN,          1
    .equ SEG_B_BIT,          1
    .equ SEG_B_MASK,         (1 << SEG_B_BIT)

    //Segmento C
    .equ SEG_C_PORT,         4
    .equ SEG_C_PIN,          2
    .equ SEG_C_BIT,          2
    .equ SEG_C_MASK,        (1 << SEG_C_BIT)

    //Segmento D
    .equ SEG_D_PORT,         4
    .equ SEG_D_PIN,          3
    .equ SEG_D_BIT,          3
    .equ SEG_D_MASK,        (1 << SEG_D_BIT)

    //Segmento E
    .equ SEG_E_PORT,         4
    .equ SEG_E_PIN,          4
    .equ SEG_E_BIT,          4
    .equ SEG_E_MASK,        (1 << SEG_E_BIT)

    //Segmento F
    .equ SEG_F_PORT,         4
    .equ SEG_F_PIN,          5
    .equ SEG_F_BIT,          5
    .equ SEG_F_MASK,        (1 << SEG_F_BIT)

    //Segmento G
    .equ SEG_G_PORT,         4
    .equ SEG_G_PIN,          6
    .equ SEG_G_BIT,          6
    .equ SEG_G_MASK,        (1 << SEG_G_BIT)

    //GPIO PARA SEGMENTOS A-G
    .equ    SEG_X_GPIO,      2
    .equ    SEG_X_OFFSET,    (SEG_X_GPIO << 2)
    .equ    SEG_X_MASK,      (SEG_A_MASK|SEG_B_MASK|SEG_C_MASK|SEG_D_MASK|SEG_E_MASK|SEG_F_MASK|SEG_G_MASK)
    
    //Segmento DP
    .equ SEG_DP_PORT,         4
    .equ SEG_DP_PIN,          8
    .equ SEG_DP_BIT,          8
    .equ SEG_DP_MASK,         (1 << SEG_DP_BIT)

    .equ SEG_DP_GPIO,          5
    .equ SEG_DP_OFFSET,       (SEG_DP_GPIO << 2)

//Recursos para los digitos
    //Dígito 1
    .equ DIG_1_PORT,            0
    .equ DIG_1_PIN,             0
    .equ DIG_1_BIT,             0
    .equ DIG_1_MASK,            (1 << DIG_1_BIT)

    //Digito 2
    .equ DIG_2_PORT,            0
    .equ DIG_2_PIN,             1
    .equ DIG_2_BIT,             1
    .equ DIG_2_MASK,            (1 << DIG_2_BIT)

    //Digito 3
    .equ DIG_3_PORT,            1
    .equ DIG_3_PIN,             15
    .equ DIG_3_BIT,             2
    .equ DIG_3_MASK,            (1 << DIG_3_BIT)

    //Digito 4
    .equ DIG_4_PORT,            1
    .equ DIG_4_PIN,             17
    .equ DIG_4_BIT,             3
    .equ DIG_4_MASK,            (1 << DIG_4_BIT)

    .equ DIG_GPIO,              0               
    .equ DIG_OFFSET,            (DIG_GPIO << 2)
    .equ DIG_MASK,               (DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK)

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
divisor:
    .space 4                 // Variable compartida con el tiempo de espera

tabla_refresco:
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK       //0
    .word SEG_B_MASK + SEG_C_MASK                                                           //1
    .word SEG_A_MASK + SEG_B_MASK + SEG_G_MASK + SEG_E_MASK + SEG_D_MASK                    //2
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_G_MASK                    //3
    .word SEG_B_MASK + SEG_C_MASK + SEG_F_MASK + SEG_G_MASK                                 //4
    .word SEG_A_MASK + SEG_F_MASK + SEG_G_MASK + SEG_C_MASK + SEG_D_MASK                    //5
    .word SEG_A_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK + SEG_G_MASK       //6
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK                                              //7
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK + SEG_G_MASK //8
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_F_MASK + SEG_E_MASK       //9

digito:
    .space 16           //para guardar el dígito en cada pantalla

hora:
    .space          //Primer byte para la decena de la hora
    .space          //Segundo byte para unidad de la hora #1
    .space          //tercer byte para decena de minutos #2
    .space          //cuarto byte para unidad de los minutos #3
    .space          //5to byte dice los segundos. #4

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

    BL systick_init

    puntero .req R0
    config  .req R1

    LDR  puntero, =SCU_BASE
    //Configuro todos los segmentos como GPIO sin resistencia de pullup
    MOV  config, #(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR  config, [puntero, #(4 * (32 * SEG_A_PORT + SEG_A_PIN))]
    STR  config, [puntero, #(4 * (32 * SEG_B_PORT + SEG_B_PIN))]
    STR  config, [puntero, #(4 * (32 * SEG_C_PORT + SEG_C_PIN))]
    STR  config, [puntero, #(4 * (32 * SEG_D_PORT + SEG_D_PIN))]
    STR  config, [puntero, #(4 * (32 * SEG_E_PORT + SEG_E_PIN))]
    STR  config, [puntero, #(4 * (32 * SEG_F_PORT + SEG_F_PIN))]
    STR  config, [puntero, #(4 * (32 * SEG_G_PORT + SEG_G_PIN))]
    STR  config, [puntero, #(4 * (32 * SEG_DP_PORT + SEG_DP_PIN))]

    //Congiguro todos los digitos como GPIO sin resistencia de pullup
    STR  config, [puntero, #(4 * (32 * DIG_1_PORT + DIG_1_PIN))]
    STR  config, [puntero, #(4 * (32 * DIG_2_PORT + DIG_2_PIN))]
    STR  config, [puntero, #(4 * (32 * DIG_3_PORT + DIG_3_PIN))]
    STR  config, [puntero, #(4 * (32 * DIG_4_PORT + DIG_4_PIN))]

    //Ahora debo apagar todos los segmentos por si acaso.
    LDR puntero, =GPIO_CLR0
    LDR config, =SEG_X_MASK
    STR config, [puntero, #DIG_OFFSET]
    LDR config, =SEG_DP_MASK
    STR config, [puntero, #SEG_DP_OFFSET]

    //Ahora configuro los segmentos como salida
    LDR puntero, =GPIO_DIR0
    LDR config, =SEG_X_MASK
    STR config, [puntero, #SEG_X_OFFSET]
    LDR config, =SEG_DP_MASK
    STR config, [puntero, #SEG_DP_OFFSET]

    LDR config, =DIG_MASK
    STR config, [puntero, #DIG_OFFSET]

    //LISTAS LAS CONFIGURACIONES DE LOS SEGMENTOS
    //Ahora configuro registros que usaré en el programa

    MOV R3, #0

    //Por último, configuro el display y la hora para que arranque en 0000
    LDR R4, =hora
    MOV R5, #0
    STRB R5, [R4]       //Decenas hora --> 0
    STRB R5, [R4, #1]   //Unidades hora --> 0
    STRB R5, [R4, #2]   //Decenas min --> 0
    STRB R5, [R4, #3]   //Undades min --> 0
    STRB R5, [R4, #4]   //Segundos --> 0  

    //Pongo los valores del display en cero
    LDR R4, =digito
    LDR R5, =tabla_refresco
    LDR R5, [R5]
    STR R5, [R4]        //Segmentos del digito 1 en cero
    STR R5, [R4, #1]    //Segmentos del digito 2 en cero
    STR R5, [R4, #2]    //Segmentos didito 3 en cero
    STR R5, [R4, #3]    //Segmentos digito 4 en cero

    //Configuro el divisor en 100
    LDR R4, =divisor
    LDR R5, =#1000
    STR R5, [R4]
  
refrescar:
    //Primero apago todos los SEGMENTOS y DIGITOS
    LDR puntero, =GPIO_CLR0
    MOV config, #DIG_MASK
    STR config, [puntero, #DIG_OFFSET]

    MOV config, #SEG_X_MASK
    STR config, [puntero, #SEG_X_OFFSET]

    //Calculamos cual será el led que se enciende ahora como (posicion + 1) mod 4
    ADD R3, #1
    AND R3, #3

    //Recupero la imagen correspondiente a la posición
    LDR puntero, =digito
    LDR config, [puntero, R3, LSL #2]

    //Se prenden los segmentos del numero actual
    LDR puntero, =GPIO_SET0
    STR config, [puntero, #SEG_X_OFFSET]

    //Se prende el enable de la posición actual
    LDR puntero, =posiciones
    LDR config, [puntero, R3, LSL #2]
    LDR puntero, =GPIO_SET0
    STR config, [puntero, #DIG_OFFSET]

    MOV config, #0x100000

demora:
    SUBS config, #1
    BNE demora

    B refrescar

stop:
    B stop

    .pool
    .endfunc

posiciones:
    .word DIG_1_MASK
    .word DIG_2_MASK
    .word DIG_3_MASK
    .word DIG_4_MASK

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
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

    // Quiero que se haga una interrupción cada 1ms.     
    //Se configura el desborde para un periodo de 1 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(48000 - 1)
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

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
    .func systick_isr
systick_isr:
    LDR     R0, =divisor            //Apunto R0 a divisor
    LDR     R1, [R0]                //Cargo el valor del divisor
    SUBS    R1, #1                  //Aumento el divisor
    BHI     systick_exit            //No necesito hacer nada más si no llegué a 1000
    
    PUSH    {R0, LR}                //Guardo los registros que uso
    BL      actualiza_reloj         //Voy a la rutina de actualización del reloj. 
    POP     {R0, LR}                //Recupero los registros

    LDR     R1, =#1000              //Reincio la cuenta

systick_exit:
    STR     R1, [R0]                // Se actualiza la variable espera
    BX   LR                         // Se retorna al programa principal
    .pool                           // Se almacenan las constantes de codigo
    .endfunc

/************************************************************************************/
/* Rutina Actualización de la Hora                                                  */
/************************************************************************************/

    .func actualiza_reloj

actualiza_reloj:
    
    LDR     R0, =hora               //Apunto R0 al vector de la hora
    LDRB    R1, [R0,#4]             //R1 tiene el valor de los segundos 
    CMP     R1, #59
    ITTT    NE                      //Si el valor de ls segundos no es igual al máximo
    ADDNE   R1, R1, #1
    STRBNE  R1, [R0, #4]            //Vuelvo a guardar el valor de los segundos
    BNE     actualiza_digitos       //Termine con la actualización de la hora

    //Ahora, si estaba en 59 segundos:
    MOV     R1, #0                  //Pongo los segundos en cero
    STRB    R1, [R0, #4]            // Guardo el nuevo valor de los segundos

    //Ahora tengo que aumentar los minutos:
    LDRB    R1, [R0, #3]            //Cargo el valor de las unidades de los minutos
    CMP     R1, #9                  //Valor máximo de las unidades de los minutos
    ITTT    NE                      // Si la unidad no es 9
    ADDNE   R1, R1, #1              
    STRBNE  R1, [R0, #3]            //Actualizo el nuevo valor de las unidades de los segundos
    BNE     actualiza_digitos       //Termine con la actualización de la hora

    //Si estaba en 9 en las unidades de los minutos
    MOV     R1, #0                  //Unidades en cero
    STRB    R1, [R0,#3]

    //Aumento decenas de los minutos
    LDRB    R1, [R0, #2]            //Valor de las decenas de los minutos
    CMP     R1, #5
    ITTT    NE
    ADDNE   R1, R1, #1
    STRBNE  R1, [R0, #2]
    BNE     actualiza_digitos

    //Si había llegado a 59 minutos
    MOV     R1, #0
    STRB    R1, [R0,#2]

    //Ahora aumento la hora. Primero tengo que fijarme si las decenas no eran 2
    LDRB    R1, [R0]                //Valor de las decenas de los minutos
    CMP     R1, #2
    IT      EQ
    BEQ     actualiza_hora

    //Si no esta en los 20s entonces sigo como lo venia haciando
    LDRB    R1, [R0,#1]             //Valor de las unidades de los minutos
    CMP     R1, #9
    ITTT    NE
    ADDNE   R1, R1, #1
    STRBNE  R1, [R0, #1]
    BNE     actualiza_digitos

    //Si habia llegado a 9 unidades en la hora:
    MOV     R1, #0
    STRB    R1, [R0, #1]

    LDRB    R1, [R0]
    ADD     R1, R1, #1
    STRB    R1, [R0]

actualiza_hora:
    //Valor de las unidades de los minutos
    LDRB    R1, [R0, #1]
    CMP     R1, #3
    ITTT    NE
    ADDNE   R1, R1, #1
    STRBNE  R1, [R0, #1]
    BNE     actualiza_digitos

    //Sino todo los registros en cero
    MOV     R1, #0
    STRB    R1, [R0,#1]
    STRB    R1, [R0]

actualiza_digitos:
    //Actualizo los segmentos con las máscaras correspondientes
    PUSH    {R4}
    LDR     R1, =digito
    LDR     R2, =tabla_refresco

    LDRB    R3, [R0]        //Decenas d la hora
    LDR     R4, [R2, R3]    //Cargo la máscara
    STR     R4, [R1]        //Guardo en los dígitos

    LDRB    R3, [R0, #1]    //Unidades de la hora
    LDR     R4, [R2, R3]    //Cargo la máscara
    STR     R4, [R1, #1]

    LDRB    R3, [R0, #2]    //Decenas de los minutos
    LDR     R4, [R2, R3]    //Cargo la máscara
    STR     R4, [R1, #2]

    LDRB    R3, [R0, #3]    //Unidades de los minutos
    LDR     R4, [R2, R3]
    STR     R4, [R1, #3]

salida_funcion:
    POP     {R4}
    BX      LR

    .pool
    .endfunc
