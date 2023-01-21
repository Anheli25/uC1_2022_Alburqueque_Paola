;--------------------------------------------------------------------------------
    ;@file     P2_Display_7SEG
    ;@brief    Este programa permite ostrar en un display de 7 segmentos 
    ;          (ánodo común) los valores alfanuméricos en conteo hexadecimal (0-F).
    ;Especificaciones:
    ;          La conexión hacia los pines será utilizando el puerto D <7:0>.
    ;          Si el botón de la placa no está presionado muestra los valores del
    ;          0-9, pero si se mantiene presionado muestra las letras A-F.
    ;          El retardo entre cada transición es de 1 segundo.
    ;@Date     15/01/2023
    ;@Author   Anheli Paola Alburqueque Sernaque 
;-------------------------------------------------------------------------------- 
    
PROCESSOR 18F57Q84
#include "Bit_Configuration.inc" /* config statements should precede project file includes. */
#include <xc.inc>
#include "Delay_library.inc"
PSECT P2, class=CODE, reloc=2
P2: 
    GOTO Main

PSECT CODE
Main:
    CALL CONFIGURATION_OSC_P2,1
    CALL CONFIGURATION_PORT_P2,1
    
Button:
    BTFSC   PORTA,3,0
    GOTO    V_numbers
V_letters:
 
  Letra_A:
    MOVLW   00001000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0         ; Corroboramos el estado del botón
    GOTO    V_numbers
  Letra_B:
    MOVLW   00000011B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0           ; Corroboramos el estado del botón
    GOTO    V_numbers
  Letra_C:
    MOVLW   01000110B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0           ; Corroboramos el estado del botón
    GOTO    V_numbers
  Letra_D:
    MOVLW   00100001B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0          ; Corroboramos el estado del botón
    GOTO    V_numbers 
  Letra_E:
    MOVLW   00000110B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0           ; Corroboramos el estado del botón
    GOTO    V_numbers
  Letra_F:
    MOVLW   00001110B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1 
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0            ; Corroboramos el estado del botón
    GOTO    V_numbers
    GOTO    Letra_A
  
V_numbers:
 
  Numero_0:
    MOVLW   11000000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0            ; Corroboramos el estado del botón
    GOTO    V_letters
  Numero_1:
    MOVLW   11111001B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0          ; Corroboramos el estado del botón
    GOTO    V_letters
  Numero_2:
    MOVLW   10100100B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0          ; Corroboramos el estado del botón
    GOTO   V_letters
  Numero_3:
    MOVLW   10110000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0         ; Corroboramos el estado del botón
    GOTO    V_letters
  Numero_4:
    MOVLW   10011001B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0         ; Corroboramos el estado del botón
    GOTO    V_letters
  Numero_5:
    MOVLW   10010010B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0         ; Corroboramos el estado del botón
    GOTO    V_letters
  Numero_6:
    MOVLW   10000010B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0         ; Corroboramos el estado del botón
    GOTO    V_letters
  Numero_7:
    MOVLW   11111000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0        ; Corroboramos el estado del botón
    GOTO    V_letters
  Numero_8:
    MOVLW   10000000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0          ; Corroboramos el estado del botón
    GOTO    V_letters
  Numero_9:
    MOVLW   10011000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0        ; Corroboramos el estado del botón
    GOTO    V_letters        ; seguirá esta línea si el estado del botón es 0
    GOTO    Numero_0         ; seguirá esta línea si el estado del botón es 1
    
CONFIGURATION_OSC_P2:  
    BANKSEL OSCCON1
    MOVLW   0x60        ; 01100000B // 0x60  - Seleccionamos el bloque del osc interno con un div:1
    MOVWF   OSCCON1,1
    MOVLW   0x02        ; Configuramos una frecuencia de 4Mhz para hacer efectiva la librería de retardos
    MOVWF   OSCFRQ,1
    RETURN
    
CONFIGURATION_PORT_P2:
    ; Config. de puertos para los leds del display
    BANKSEL PORTD   
    CLRF    PORTD,1	;PORTC <7:0> = 0
    CLRF    LATD,1	;LATC<7:0> = 0, Leds apagado
    CLRF    ANSELD,1	;ANSELC <7:0> = 0 ,Digital
    CLRF    TRISD,1     ;Puerto  D como salidas
    ;Config. button
    BANKSEL PORTA
    CLRF    PORTA,1	;PORTA <7:0> = 0
    CLRF    ANSELA,1	;ANSELA=0, Digital
    BSF	    TRISA,3,1	;TRISA=1 -> entrada
    BSF	    WPUA,3,1	;Activamos la resistencia Pull-up del pin RA3
    RETURN      
    
END P2
   

