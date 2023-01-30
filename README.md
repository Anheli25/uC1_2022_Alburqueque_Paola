# uC1_2022_Alburqueque_Paola
**Ing. Electrónica y telecomunicaciones**

 - [ ] ***Curso:*** Microcontroladores I

 - [ ] ***Autor:*** Anheli Paola Alburqueque Sernaque

 - [ ] ***Modelo de Tarjeta:*** Curiosity Nano PIC18F57Q84
 - [ ] ***Entorno:*** MPLAB X IDE
 - [ ] ***Lenguaje:*** ASM - C 

    

`P R A C T I C A S`



> **TE1:**
*"Delay Library"*
*Librería de retardos - APA*
Esta librería implementa una variedad de retardos tanto en microsegundos(μs) como en milisegundos(ms); con la finalidad de ser la base para la implementación de futuros proyectos que requieran de la misma y así ser más eficientes tanto en simulación como en práctica.

> **TE2:**
*"Práctica de Puertos"* 
>  - [ ] P1-Corrimiento_Leds
 Este programa permite realizar un corrimiento (par e impar) de  8 leds conectados al puerto C de la PIC <7:0>. 
  > - Especificaciones:
Los retardos para el corrimiento par es de 500 ms y para el impar es de 250 ms. 
El corrimiento inicia cuando se pulsa el botón y al ser pulsado nuevamente, se detiene.
 > - [ ] P2-Display_7SEG 
Este programa permite mostrar en un display de 7 segmentos (ánodo común) los valores alfanuméricos en conteo hexadecimal (0-F).
> - Especificaciones:
La conexión hacia los pines será utilizando el puerto D <7:0>.
Si el botón de la placa no está presionado muestra los valores del 0-9, pero si se mantiene presionado muestra las letras A-F.
El retardo entre cada transición es de 1 segundo.

> **PARCIAL 2**
*"EP_EJERCICIO_2"* 
>  - [ ] E2-Corrimiento_Leds
 Este programa permite  ejecutar una secuencia de leds, desde los bits que se encuentran en los extremos hasta el centro y viceversa, contando cada par de estos como 1 repetición de secuencia. Para activarla se debe presionar el pulsador RA3, para capturar el momento el pulsador RB4 y para apagar la secuencia y reiniciarla se utiliza el pulsador RF2. Además mientras no se ejecute ninguna interrupción el led de la placa (RF3) tendrá un toggle de 500ms y la secuencia en caso de no ser apagada tendrá su fin al contar cinco repeticiones de la secuencia antes mencionada.
  > - Especificaciones:
  RA3: Interrupción de baja prioridad.
  RB4: Interrupción de baja prioridad.
  RF2: Interrupción de alta prioridad.
--------------------------------------------------------------
**Universidad Nacional De Piura**
