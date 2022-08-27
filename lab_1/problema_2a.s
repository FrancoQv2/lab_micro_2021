    .cpu cortex-m4          // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data           // Define la sección de variables (RAM)
vector:
    .hword 4                // Base aqui guardo la cantidad de elementos del vector
    .space 8,0xFF           // Base+2 lleno 8 bytes de espacio con 0xFF (2*[base])

/* Programa principal *****************************************************/
    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Indica al depurador el inicio de una funcion
reset:
    LDR     R0,=vector          // Apunto R0 a vector (direccion base)
    LDRH    R1,=0x55            // Guardo en R2 el valor 0x55 
    LDRH    R2,=0               // Uso R3 como contador
loop:
    CMP     R2,0x4             // Comparo si es contador R2 es igual a 4 cant elementos 
    BEQ     stop                // Termino el programa si llego al final del vector
    ADD     R2,R2,#1            // Incremento uno al contador
    STRH    R1,[R0,#2]!         // Guardo el valor de R2 en la direccion R1+2
    B       loop

stop:
    B       stop                //Lazo infinito para detener

    .pool                       // Almacenar las constantes de código
    .endfunc
