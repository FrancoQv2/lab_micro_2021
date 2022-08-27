    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Inclusion de las funciones para configurar los teminales GPIO del procesador
/****************************************************************************/

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Declaraciones de macros para acceso simbolico a los recursos             */
/****************************************************************************/
//----------------------------------------------LED 1 de placa EDU-CIAA----------------------------------------------//

    .equ LED_1_PORT,    2
    .equ LED_1_PIN,     10
    .equ LED_1_BIT,     14
    .equ LED_1_MASK,    (1 << LED_1_BIT)

    .equ LED_1_GPIO,    0
    .equ LED_1_OFFSET,  (LED_1_GPIO << 2)

//----------------------------------------------SEGMENTOS del display del PONCHO----------------------------------------------//

 // Segmento A de los display 7 segmentos (horizontal)      // Trabajan en MODO 0
    .equ SEG_A_PORT,    4
    .equ SEG_A_PIN,     0
    .equ SEG_A_BIT,     0
    .equ SEG_A_MASK,    (1 << SEG_A_BIT)

 // Segmento B de los display 7 segmentos (vertical)
    .equ SEG_B_PORT,    4
    .equ SEG_B_PIN,     1
    .equ SEG_B_BIT,     1
    .equ SEG_B_MASK,    (1 << SEG_B_BIT)
    
    // Segmento C de los display 7 segmentos (vertical)
    .equ SEG_C_PORT,    4
    .equ SEG_C_PIN,     2
    .equ SEG_C_BIT,     2
    .equ SEG_C_MASK,    (1 << SEG_C_BIT)

    // Segmento D de los display 7 segmentos (horizontal)
    .equ SEG_D_PORT,    4
    .equ SEG_D_PIN,     3
    .equ SEG_D_BIT,     3
    .equ SEG_D_MASK,    (1 << SEG_D_BIT)

    // Segmento E de los display 7 segmentos (vertical)
    .equ SEG_E_PORT,    4
    .equ SEG_E_PIN,     4
    .equ SEG_E_BIT,     4
    .equ SEG_E_MASK,    (1 << SEG_E_BIT)
    
    // Segmento F de los display 7 segmentos (vertical)
    .equ SEG_F_PORT,    4
    .equ SEG_F_PIN,     5
    .equ SEG_F_BIT,     5
    .equ SEG_F_MASK,    (1 << SEG_F_BIT)

    // Segmento G de los display 7 segmentos (horizontal)
    .equ SEG_G_PORT,    4
    .equ SEG_G_PIN,     6
    .equ SEG_G_BIT,     6
    .equ SEG_G_MASK,    (1 << SEG_G_BIT)

    // Recursos utilizados por TODOS los segmentos
    .equ SEG_GPIO,      2
    .equ SEG_OFFSET,    ( SEG_GPIO << 2 )
    .equ SEG_MASK,      ( SEG_A_MASK |SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )


//----------------------------------------------DÍGITOS del display del PONCHO----------------------------------------------//

    .equ DIG_1_PORT,    0                   //DÍGITO 1 -> DERECHA       (TRABAJAN EN MODO 0)
    .equ DIG_1_PIN,     0
    .equ DIG_1_BIT,     0
    .equ DIG_1_MASK,    (1 << DIG_1_BIT)
    
    .equ DIG_2_PORT,    0                   //DÍGITO 2
    .equ DIG_2_PIN,     1
    .equ DIG_2_BIT,     1
    .equ DIG_2_MASK,    (1 << DIG_2_BIT)
    
    .equ DIG_3_PORT,    1                   //DÍGITO 3
    .equ DIG_3_PIN,     15
    .equ DIG_3_BIT,     2
    .equ DIG_3_MASK,    (1 << DIG_3_BIT)
    
    .equ DIG_4_PORT,    1                   //DÍGITO 4 -> IZQUEIRDA
    .equ DIG_4_PIN,     17
    .equ DIG_4_BIT,     3
    .equ DIG_4_MASK,    (1 << DIG_4_BIT)

    // Recursos utilizados por TODOS los DÍGITOS
    .equ DIG_GPIO,      0
    .equ DIG_OFFSET,    ( DIG_GPIO << 2 )
    .equ DIG_MASK,      ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK )

//----------------------------------------------PUNTO del display del PONCHO----------------------------------------------//

    // Punto del display de 7 segmentos         (RECORDAR QUE UTILIZA MODO 4)
    .equ PUNTO_PORT,    6
    .equ PUNTO_PIN,     8
    .equ PUNTO_BIT,     16
    .equ PUNTO_MASK,    (1 << PUNTO_BIT)

    .equ PUNTO_GPIO,      5
    .equ PUNTO_OFFSET,    ( PUNTO_GPIO << 2 )

//----------------------------------------------------BOTONES del PONCHO----------------------------------------------------//

    // Recursos utilizados por el 1er boton del poncho
    .equ BOTON_1_PORT,    4                             // -> (DERECHA)        (FUNCIONAN EN MODO 4)
    .equ BOTON_1_PIN,     8
    .equ BOTON_1_BIT,     12
    .equ BOTON_1_MASK,    (1 << BOTON_1_BIT)

    // Recursos utilizados por el 2do boton del poncho
    .equ BOTON_2_PORT,    4
    .equ BOTON_2_PIN,     9
    .equ BOTON_2_BIT,     13
    .equ BOTON_2_MASK,    (1 << BOTON_2_BIT)

    // Recursos utilizados por el 3er boton del poncho
    .equ BOTON_3_PORT,    4
    .equ BOTON_3_PIN,     10
    .equ BOTON_3_BIT,     14
    .equ BOTON_3_MASK,    (1 << BOTON_3_BIT)

    // Recursos utilizados por el 4to boton del poncho
    .equ BOTON_4_PORT,    6                             // -> (IZQUIERDA)
    .equ BOTON_4_PIN,     7
    .equ BOTON_4_BIT,     15
    .equ BOTON_4_MASK,    (1 << BOTON_4_BIT)

    // Recursos utilizados por el botón ACEPTAR
    .equ BOTON_ACEPTAR_PORT,    3
    .equ BOTON_ACEPTAR_PIN,     2
    .equ BOTON_ACEPTAR_BIT,     9
    .equ BOTON_ACEPTAR_MASK,    (1 << BOTON_ACEPTAR_BIT)

    // Recursos utilizados por el botón CANCELAR
    .equ BOTON_CANCELAR_PORT,    3
    .equ BOTON_CANCELAR_PIN,     1
    .equ BOTON_CANCELAR_BIT,     8
    .equ BOTON_CANCELAR_MASK,    (1 << BOTON_CANCELAR_BIT)

    // Recursos utilizados por los 4 botones del poncho
    .equ BOTON_GPIO,      5
    .equ BOTON_OFFSET,    ( BOTON_GPIO << 2 )
    .equ BOTON_MASK,      ( BOTON_1_MASK | BOTON_2_MASK | BOTON_3_MASK | BOTON_4_MASK | BOTON_ACEPTAR_MASK | BOTON_CANCELAR_MASK )

/****************************************************************************/
/*                        Vector de interrupciones                          */
/****************************************************************************/
    .section .isr            // Define una seccion especial para el vector
    .word   stack           // 0: Initial SP Stack Pointer value
    .word   reset+1         // 1: Initial PC Program Counter value
    .word   handler+1       // 2: Non mascarable ISR Interrupt Service Routine
    .word   handler+1       // 3: Hard fault System Trap Service Routine
    .word   handler+1       // 4: Memory manager System Trap Service Routine
    .word   handler+1       // 5: Bus fault System Trap Service Routine
    .word   handler+1       // 6: Usage fault System Trap Service Routine
    .word   0               // 7: Reserved entry
    .word   0               // 8: Reserved entry
    .word   0               // 9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call Trap Service Routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service System Trap Service Routine
    .word   systick_isr+1   // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine


/****************************************************************************/
/*                     Definición de variables globales                     */
/****************************************************************************/

    .section .data          // Define la seccion de variables (RAM)

espera:
    .zero   1                       // Variable compartida con el tiempo de espera

horaActual:
        .byte 0x00                  // Hora en horaActual 
        .byte 0x00                  // Minuto en horaActual+1 

segundos:
        .byte 0x00                  // Unidades de segundo actual

destino:
        .space 4                    // Resultado de conversión

digito:
        .byte 0x08                  // Variable para elegir el dígito a encender

indice:
        .byte 0x00                  // Índice para recorrer los dígitos  

contando:
        .byte 0x00                  // Bandera para saber si el está contando o en pausa


/****************************************************************************/
/*                            Programa Principal                            */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion

reset:
    // Mueve el Vector de Interrupciones al principio de la 2da RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina para configurar el systick
    //BL  systick_init

    LDR R1,=SCU_BASE

    // Configura el pin del led 1 como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(LED_1_PORT << 7 | LED_1_PIN << 2)]
    
    // Configura los los DIGITOS del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]     //P0_0
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]     //P0_1
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]     //P1_15
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]     //P1_17
    
    // Configura los segmentos de los 7 segmentos del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]     //P4_0
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]     //P4_1
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]     //P4_2
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]     //P4_3
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]     //P4_4
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]     //P4_5
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]     //P4_6
    
    // Configura el punto de los segmentos del poncho como GPIO s/pull-up F4
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(PUNTO_PORT << 7 | PUNTO_PIN << 2)]     //P6_8
      
    // Configura los pines de los botones del poncho como GPIO F4 c/pull-up
    MOV R0,#(SCU_MODE_PULLDOWN | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(BOTON_1_PORT << 7 | BOTON_1_PIN << 2)]                 //P4_8
    STR R0,[R1,#(BOTON_2_PORT << 7 | BOTON_2_PIN << 2)]                 //P4_9
    STR R0,[R1,#(BOTON_3_PORT << 7 | BOTON_3_PIN << 2)]                 //P4_10
    STR R0,[R1,#(BOTON_4_PORT << 7 | BOTON_4_PIN << 2)]                 //P6_7
    STR R0,[R1,#(BOTON_ACEPTAR_PORT << 7 | BOTON_ACEPTAR_PIN << 2)]     //P3_1
    STR R0,[R1,#(BOTON_CANCELAR_PORT << 7 | BOTON_CANCELAR_PIN << 2)]   //P3_2

    LDR R1,=GPIO_CLR0
    // Se apagan los bits GPIO del led 1
    LDR R0,=LED_1_MASK
    STR R0,[R1,#LED_1_OFFSET]
    // Se apagan los bits GPIO de los Digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]
    // Se apagan los bits GPIO de todos los segmentos
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    // Se apagan los bits GPIO del punto
    LDR R0,=PUNTO_MASK
    STR R0,[R1,#PUNTO_OFFSET]

    LDR R1,=GPIO_DIR0
    // Configuro los bits GPIO del led 1 como salida
    LDR R0,=LED_1_MASK
    STR R0,[R1,#LED_1_OFFSET]
    // Configuro los bits GPIO de los Digitos como salidas
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]
    // Configuro los bits GPIO de los segmentos como salidas
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    // Configuro los bits GPIO del punto como salidas

    LDR R0,[R1,#PUNTO_OFFSET]
    ORR R0,#PUNTO_MASK
    STR R0,[R1,#PUNTO_OFFSET]

    @ LDR R0,=PUNTO_MASK
    @ STR R0,[R1,#PUNTO_OFFSET]


    // Configuro los bits GPIO de los botones como entradas
    LDR R0,[R1,#BOTON_GPIO]
    BIC R0,#BOTON_MASK
    STR R0,[R1,#BOTON_OFFSET]

    BL prender_punto

/*--------------------------------Termina la configuración-------------------------------- */

bucle3:
    
    B bucle3


// Defino los punteros para usar el programa
    LDR R3,=GPIO_PIN0
    LDR R5,=contando                    // Referencia a la bandera
    MOV R6,#0                           // Registro usado para reiniciar cronómetro
    LDR R7,=horaActual                  // Puntero a la variable de hora 

// Verifico por polling si se tocó algún botón
refrescar:
    LDR     R0,[R3,#BOTON_OFFSET]       // Carga el estado actual de los botones

    TST     R0,#BOTON_CANCELAR_MASK     // Verifica el estado del bit correspondiente al botón CANCELAR
    ITT     NE                          // Si la tecla está apretada
    STRBNE  R6,[R7]
    STRBNE  R6,[R7,#1]                  // Reinicio el cronómetro 
    // FALTA PONER EN CERO LOS SEGUNDOS

    TST     R0,#BOTON_ACEPTAR_MASK      // Verifica el estado del bit correspondiente al botón ACEPTAR
    BEQ     terminar                    // Si la tecla está apretada sigo
    LDRB    R4,[R5]                     // Guardo la bandera para ver si está contando
    CMP     R4,#0                       // Si bandera=0 entonces está contando                  
    ITE     EQ 
    MOVEQ   R4,#1
    MOVNE   R4,#0
    STRB    R4,[R5]
    BL      demora
terminar:
    B       refrescar
stop:
    B stop
    
    .pool                   // Almacenar las constantes de codigo
    .endfunc


/****************************************************************************/
/*                          INICIO DE SUBRUTINAS                            */
/****************************************************************************/


/* Rutina de inicialización de Systick *********************************************/
    .func systick_init
systick_init:
    CPSID I                 // Se deshabilitan globalmente las interrupciones

    // Se configura la prioridad de la interrupcion
    LDR R1,=SHPR3           // Se apunta al registro de prioridades
    LDR R0,[R1]             // Se cargan las prioridades actuales
    MOV R2,#2               // Se fija la prioridad en 2
    BFI R0,R2,#29,#3        // Se inserta el valor en el campo correspondiente
    STR R0,[R1]             // Se actualizan las prioridades

    // Se deshabilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]             // Se quita el bit ENABLE

    // Se configura el desborde para un periodo de 100ms
    // EL SysTick cuando desborda (vuelve a 0) produce la interrupcion
    LDR R1,=SYST_RVR
    LDR R0,=#(4800-1)       //(DEBERÏA SER 480000-1 PERO UTILIZO ASÍ PARA PROBAR)
    STR R0,[R1]             // Se especifica el valor de RELOAD

    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0               // Escribir cualquier valor limpia el contador
    STR R0,[R1]             // Se limpia COUNTER y flag COUNT

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07            // 0000.0111
    STR R0,[R1]             // Se fijan ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                 // Se habilitan globalmente las interrupciones
    BX  LR                  // Se retorna al programa principa
    .pool                   // Almacenar las constantes de codigo
    .endfunc

/* Rutina de servicio para la interrupcion del Systick *********************************************/
    .func systick_isr
systick_isr:
    PUSH {LR}
    BL   actualizar_digitos
    LDR  R0,=espera             // Se apunta R0 a la variable global espera
    LDRB R1,[R0]                // Se carga el valor de espera
    SUBS R1,#1                  // Se decrementa el valor de espera con flag
    BHI  systick_exit           // Si espera > 0 entonces no pasaron 1000 iteraciones
    LDR  R2,=contando
    LDRB R3,[R2]                // Controlo la bandera de contar o pausa
    MOV  R1,#1000               // Se recarga la espera con 1000S iteraciones
    CMP  R3,#1  
    BEQ  systick_exit
    BL   actualizar_reloj
    MOV  R1,#1000               // Se recarga la espera con 1000S iteraciones

systick_exit:
    LDR  R0,=espera             // Se apunta R0 a la variable global espera
    STRB R1,[R0]                // Se actualiza la variable espera
    POP  {PC}                   // Se retorna al programa principal
    .pool                       // Almacenar las constantes de codigo
    .endfunc

/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa           */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/
    .func handler
handler:
    MOV R0,#8
    MOV R1,#0x08
    LDR R2,=GPIO_PIN0
    STR R0,[R2,#SEG_OFFSET]
    STR R1,[R2,#DIG_OFFSET]
    B handler                   // Lazo infinito para detener la ejecucion
    .pool                       // Se almacenan las constantes de codigo
    .endfunc

/****************************************************************************/
/* Subrutina para prender punto
/****************************************************************************/
    .func prender_punto
prender_punto:
    
    LDR     R0,=GPIO_SET0
    MOV     R1, #DIG_MASK
    STR     R1, [R0,#DIG_OFFSET]
    MOV     R2,#PUNTO_MASK
    STR     R2,[R0,#PUNTO_OFFSET]
    MOV     R2,#SEG_D_MASK
    STR     R2,[R0,#SEG_OFFSET]
    BX      LR

    .pool                       // Se almacenan las constantes de codigo
    .endfunc

/****************************************************************************/
/* Subrutina para actualizar digitos
/****************************************************************************/
    .func actualizar_digitos
actualizar_digitos:
    PUSH    {LR}
    PUSH    {R4,R5}
    LDR     R0, =horaActual         //  Guardo la dirección de horaActual
    LDR     R1, =destino            //  Dirección destino   
    BL      hora
    LDR     R2,=digito              //  Guardo la posición del dígito que quiero prender en R1
    LDR     R3,=indice              //  Guardo la posición del índice
    LDR     R5,=destino             //  Dirección del resultado
    LDRB    R4, [R3]                //  índice para prender dígitos
    LDRB    R1, [R2]                //  Guardo el dígito que quiero prender
    LDRB    R0,[R5,R4]              //  Cargo el dígito N
    BL      mostrar                 //  Llamo a la subrutina mostrar
    LSR     R1,#1                   //  Divido en 2 a R5
    ADD     R4,#1                   //  Incremento el índice
    CMP     R4,#0x03                //  Controlo si ya pasé por todos los displays
    ITT     GT
    MOVGT   R4,#0
    MOVGT   R1,#0x08
    LDR     R2,=digito              //  Guardo la posición del dígito que quiero prender en R1
    LDR     R3,=indice              //  Guardo la posición del índice
    STRB    R4, [R3]             
    STRB    R1, [R2]
    POP     {R4,R5}
    POP     {PC}
    .pool                   // Se almacenan las constantes de codigo
    .endfunc

/************************************************************************************/
/*                      Rutinas para actualizar el reloj                             */
/************************************************************************************/

    .func actualizar_reloj
actualizar_reloj:

    PUSH    {LR}                // Conservo la dirección de retorno
    LDR     R1,=segundos
    LDRB    R2,[R1]
    LDR     R1,=horaActual
    LDRB    R3,[R1]             // Leo las horas
    LDRB    R0,[R1,#1]          // Leo los minutos
    ADD     R2,#1
    CMP     R2,#0x3C
    BLO     fin_actualizar
    MOV     R2,#0
    ADD     R0,#0x01            // Incremento los minutos
    CMP     R0,#0x3C            // Controlo si llegó a 60
    BLO     fin_actualizar      // Si no llegó a 60 salgo
    MOV     R0,#0x00
    ADD     R3,#0x01            // Incremento la hora
    STRB    R3,[R1]             // Guardo la hora
    CMP     R3,#0x18            // Controlo si llegó a 24
    BLO     fin_actualizar      // Si no llegó a 24 salgo
    MOV     R3,#0x00
fin_actualizar:
    STRB    R3,[R1]             // Guardo la hora
    STRB    R0,[R1,#1]          // Guardo los minutos
    LDR     R1,=segundos
    STRB    R2,[R1]
    POP   {PC}                  // Retornar recuperando PC de la pila
    .pool                       // Almacenar las constantes de codigo
    .endfunc

/****************************************************************************/
/*Rutina de incremento de segundos                                         */    
/*Recibe en R0 el valor numérico 1 (bandera de incremento)                  */
/*Recibe en R1 la direccion de los datos                                    */
/****************************************************************************/
.func incrementar                   // (AL FINAL NO LA USO)
incrementar:
    PUSH    {R4-R5}
    LDRB    R4, [R1]                //  Busca el valor menos significativo
    ADD     R4, R0                  //  Se incrementa en R0 cantidad (en 1)      
    MOV     R0, #0                  //  Setea el valor de retorno por defecto

    CMP     R4, #9                  
    BLS     final_incrementar       //  Salta si es menor o igual que 9

    SUB     R4, #9                  //  Calcula la cantidad que desbordó
    LDRB    R5, [R1, #1]            //  Busca el valor más significativo
    ADD     R5, R4                  //  Se incrementa en la cantidad de desborde
    MOV     R4, #0                  //  Resetea el menos significativo

    CMP     R5, #5                  
    BLS     salto_incrementar       //  Salta si es menor o igual que 5

    MOV     R5, #0                  //  Resetea el más significativo
    MOV     R0, #1                  //  Setea el valor de retorno por desborde

salto_incrementar:
    STRB    R5, [R1, #1]            //  Almacena el nuevo valor más significativo

final_incrementar:
    STRB    R4, [R1]                //  Almacena el nuevo valor menos significativo
    POP     {R4-R5}
    BX      LR                      //  Retorna al programa principal

    .pool                           //  Almacena las constantes de código
    .endfunc

/****************************************************************************/
/* Subrutina para mostrar un mapa de bits en un digito del poncho
/****************************************************************************/

    .func mostrar

mostrar:
    
    /*
        Recibe en :
            R0-> el mapa de bits de 7 segmentos correspondiente al número.
            R1-> 0x01,0x02,0x04 o 0x08 según el display a mostrar
     */

    // Se escribe en los segmentos el mapa de bits a mostrar
    LDR R2,=GPIO_PIN0
    STR R0,[R2,#SEG_OFFSET]

    // Se escribe la mascara con los digitos que se deben encender
    STR R1,[R2,#DIG_OFFSET]

    // Retorno al programa llamador
    BX LR

    .pool
    .endfunc

/****************************************************************************/
/* Subrutina para convertir un número BCD en 7 segmentos
/****************************************************************************/

    /*
        Recibe en :
            R0-> valor BCD a convertir.

        Devuelve en :
            R0-> valor convertido.
    
     */

    .func segmentos

segmentos:
        PUSH    {R4}                    //  Guardo en la pila R4
        LDR     R4, =tabla              //  Apunta R4 al bloque con la tabla
        LDRB    R0,[R4, R0]             //  Carga en R0 el elemento convertido
        POP     {R4}                    //  Saco el dato de la pila
        BX      LR
        .pool                           //  Almacenar las constantes de código

tabla:
        .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66
        .byte 0x6D, 0x7D, 0x07, 0x7F, 0x6F
        .endfunc

/****************************************************************************/
/* Subrutina para convertir un número entero en dos unidades en direcciones
   de memoria contiguas
/****************************************************************************/

    /*
        Recibe en :
            R0-> Dirección de memoria donde está almacenado el número de un byte
            menor a 99
            R1-> Dirección donde debe guardar el resultado

        Devuelve en :
            Resultado -> decena
            Resultado+1 -> unidad
    
     */

     .func conversion

conversion:
        PUSH    {R4,R5,R6,R7}           //  Guardo los registros que usaré en la pila
        LDRB    R4, [R0]                //  Guardo el número en R4
        MOV     R5, R4                  //  Muevo R4 a R5
        MOV     R6, #0                  //  Uso R6 como contador de las decenas

restasSucesivas:   
        SUB     R5, #10                 //  Resto 10 al número
        CMP     R5, #0                  //  Comparo R5 con cero
        BLT     final
        ADD     R6, #1                  //  Incremento contador en 1
        B       restasSucesivas

final:
        MOV     R7, #10                 //  Uso R7 como constante para usar la instrucción MUL
        MUL     R5, R6, R7              //  Guardo las decenas en R5
        SUB     R4, R5                  //  Guardo las unidades de R4
        STRB    R6, [R1]                //  Cargo las decenas en destino
        STRB    R4, [R1, #1]            //  Cargo las unidades en destino+1
        POP     {R4,R5,R6,R7}
        BX      LR

        .pool
        .endfunc

/****************************************************************************/
/* Subrutina transparente que recibe una hora y la almacena como horas 
   y minutos en direcciones de memoria contiguas
/****************************************************************************/

    /*
        Recibe en :
            R0-> Dirección de memoria de la hora
            R1-> Dirección de destino

        Devuelve en :
            Resultado -> decena hora
            Resultado+1 -> unidad hora
            Resultado+2 -> decena minuto
            Resultado+3 -> unidad minuto
    
     */

        .func hora

hora:  
        PUSH    {LR}                    //  Guardo LR        
        BL      conversion              //  Llamo a la subrutina conversión
        ADD     R0,#1                   //  Incremento R0 para leer las horas
        ADD     R1,#2                   //  Incremento R1 para guardar los datos de las horas
        BL      conversion
        LDR     R1, =destino            //  R1 apunta al destino de conversión
        MOV     R3, #0                  //  Uso R4 como contador

lazo:           
        LDRB    R0, [R1, R3]            //  Guardo el primer dígito de la hora
        BL      segmentos               //  Llamo a la subrutina segmentos
        STRB    R0, [R1, R3]            //  Guardo el código BCD del dígito en destino
        ADD     R3, #1                  //  Incremento el contador
        CMP     R3, #4                  //  Controlo si ya cargó todos los segmentos
        BLO     lazo
        POP     {PC}

        .pool
        .endfunc

/****************************************************************************/
/* Subrutina para una demora
/****************************************************************************/
    .func demora
demora:
    LDR R0, =250000     // Se carga el valor inicial de demora
lazo_demora:
    SUBS R0, #1         // Se decrementa el valor de espera
    BNE lazo_demora     // Si se llego a cero se termina la espera

    BX LR
    .pool
    .endfunc