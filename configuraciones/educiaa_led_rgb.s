/****************************************************************************/
/* Archivo con la configuracion para utilizar el led RGB                    */
/* que está en la EDU-CIAA                                                  */
/****************************************************************************/ 

    // Recursos utilizados por el canal Rojo del Led RGB
    .equ LED_R_PORT,    2                   // N° de puerto de entrada/salida utilizado en el Led Rojo
    .equ LED_R_PIN,     0                   // N° de terminal dentro del puerto de E/S utilizado en el Led Rojo
    .equ LED_R_BIT,     0                   // N° de bit GPIO utilizado en el Led Rojo
    .equ LED_R_MASK,    (1 << LED_R_BIT)    // Mascara de 32 bits con un 1 en el bit correspondiente al Led Roj 
    // Recursos utilizados por el canal Verde del Led RGB
    .equ LED_G_PORT,    2
    .equ LED_G_PIN,     1
    .equ LED_G_BIT,     1
    .equ LED_G_MASK,    (1 << LED_G_BIT)
    //Recursos utilizados por el canal Azul del Led RGB
    .equ LED_B_PORT,    2
    .equ LED_B_PIN,     2
    .equ LED_B_BIT,     2
    .equ LED_B_MASK,    (1 << LED_B_BIT)

    // Recursos utilizados por el Led RGB
    .equ LED_GPIO,      5                   // N° de puerto GPIO utilizado por todos los leds
    .equ LED_OFFSET,    ( 4 * LED_GPIO )    // Desplazamiento para acceder a los registros GPIO de los leds
    // Mascara de 32 bits con un 1 en los bits correspondientes a cada led
    .equ LED_MASK,      ( LED_R_MASK | LED_G_MASK | LED_B_MASK )


/****************************************************************************/
/* Esto iría en el reset:                                                   */
/****************************************************************************/
/*
    // Configura los pines de los leds RGB como GPIO s/pull-up F4
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(4 * (32 * LED_R_PORT + LED_R_PIN))]
    STR R0,[R1,#(4 * (32 * LED_G_PORT + LED_G_PIN))]
    STR R0,[R1,#(4 * (32 * LED_B_PORT + LED_B_PIN))]

    // Apaga todos los bits GPIO de los led RGB
    LDR R1,=GPIO_CLR0
    LDR R0,=LED_MASK
    STR R0,[R1,#LED_OFFSET]

    // Configuro los bits GPIO de los leds RGB como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#LED_OFFSET]
    ORR R0,#LED_MASK
    STR R0,[R1,#LED_OFFSET]

*/
