/* Evaluación del Laboratorio Número 1
APELLIDO Y NOMBRE: Bardin, Pablo Mauricio
DNI: 42221424

Ejercicio a resolver:
1a)Escriba un programa que modifique los elementos del bloque para quedar almacenados en
codificación complemento a 2. Los elementos deben quedar almacenados en las mismas
direcciones de memoria en que se encontraban originalmente.
 */

     .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM


.section .data                  // Define la sección de variables (RAM)
vector:
    .byte  0x06,0x85,0x78,0xF8,0xE0,0x80       // Vector
/**
* Programa principal, siempre debe ir al principio del archivo
*/
    .section .text              // Define la seccion de codigo (FLASH)
    .global reset               // Define el punto de entrada del codigo
    .func main

reset:
    LDR R0,=vector      //puntero a la estructura

lazo:
    LDRB R1,[R0]    //carga en R1 el valor al que apunta R0
    CMP R1,0x80         //determina si es el fin de la conversion     
    BEQ final
    LDRB R2,[R0]   //carga en R2 el valor al que apunta R0
    LSL R2,#1       //pasa al carry el bit más significativo
    ITT CS
    EORCS R1, R1, 0x7F    //paso el bloque a complemento a 1(invierto todos sus bits excepto el MSB)
    ADDCS R1, R1, 0x1     //convierto el código a complemento a 2 (le sumo 1 al complemento a 1)
    
    @ BCS conversion  //si el carry=1, osea el numero es negativo, entonces se procede a convertir
    STRB R1,[R0],#1    // Guardar el numero ya convertido en su dirección original eincremento R0
    @ ADD R0, R0, #1  //incremento en 1 la dirección de memoria, para seguir el lazo
    B lazo

final:
    B final


