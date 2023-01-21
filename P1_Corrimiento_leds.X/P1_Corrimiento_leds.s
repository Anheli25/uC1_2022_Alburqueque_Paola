;--------------------------------------------------------------------------------
    ;@file     P1_Corrimiento_leds
    ;@brief    Este programa permite realizar un corrimiento (par e impar) de 
    ;          8 leds conectados al puerto C de la PIC <7:0>. 
    ;Especificaciones:
    ;          Los retardos para el corrimiento par es de 500 ms y para el
    ;          impar es de 250 ms. 
    ;          El corrimiento inicia cuando se pulsa el botón y al ser pulsado
    ;          nuevamente, se detiene.
    ;@Date     15/01/2023
    ;@Author   Anheli Paola Alburqueque Sernaque 
;--------------------------------------------------------------------------------  
    
PROCESSOR 18F57Q84
#include"Bit_Configuration.inc"  /* config statements should precede project file includes. */
#include <xc.inc>
#include"Delay_library.inc"
PSECT P1, class=CODE, reloc=2
P1: 
    GOTO Main

PSECT CODE
Main:
  CALL CONFIGURATION_OSCC,1
  CALL CONFIGURATION_PORTS,1 

Testeo:
    BTFSC   PORTA,3,0          ; si se pulsa PORTA == 0
    GOTO    APAGADO_TT
     ;PORTA == 0 -> salta para iniciar  
ON_Leds_pares:               ; Designamos un registro para el corrimiento de leds pares.
    BCF     LATE,0,1         
    MOVLW   1
    MOVWF   0X503,a
 Loop:                       ; loop que designa los corrimientos y el tiempo de espera de 50ms
    ;BANKSEL 0X5h
    RLNCF   0x504,f,a
    MOVF    0X504,w,a
    BANKSEL PORTC
    MOVWF   PORTC,1
    BSF     LATE,1,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0         ; si se pulsa PORTA == 0
    GOTO    PAR_0             ; salta a PAR_0
    GOTO    STOP_a            ; salta a STOP_a
 PAR_0:
    BTFSC   0x504,7,0         ;Si el bit 7 del registro es 0 salta, pero si no continúa y como es un corrimiento par, debe estar en 0, por tanto saltará
    GOTO    ON_Leds_impar
    RLNCF   0x504,f,a
    MOVF    0X504,w,a
    ;BTFSC  PORTA,3,0        ; si se pulsa PORTA == 0
    GOTO    Loop
    ;GOTO   STOP_a
      
ON_Leds_impar:
    BCF     LATE,1,1
    MOVLW   1
    MOVWF   0X504,a
Loop_a:
    BANKSEL PORTC
    MOVWF   PORTC,1
    BSF     LATE,0,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0         ; si se pulsa PORTA == 0
    GOTO    IMPAR_1
    GOTO    STOP_b
IMPAR_1:
    BTFSC   0x504,6,0
    GOTO    ON_Leds_pares
    RLNCF   0x504,f,a
    RLNCF   0x504,f,a
    MOVF    0X504,w,a
    ;BTFSC  PORTA,3,0        ; si se pulsa PORTA == 0
    GOTO    Loop_a
    ;GOTO   STOP_b

; El fin de esta etiqueta es que se ecuentre en un loop constante
APAGADO_TT: 
    CLRF    PORTC,1
    GOTO    Testeo
 
STOP_a:
  Delay_a:
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
; Capturamos el dato en el mismo registro
CAPTURA_a:
    MOVF    0X504,w,a
    BANKSEL PORTC
    MOVWF   PORTC,1
    BSF     LATE,1,1
    BTFSC   PORTA,3,0             ; si se pulsa PORTA == 0
    GOTO    CAPTURA_a            
    GOTO    PAR_0
   
STOP_b:
  Delay_b:
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
  CAPTURA_b: 
    MOVF    0X504,w,a
    BANKSEL PORTC
    MOVWF   PORTC,1
    BSF     LATE,0,1
    BTFSC   PORTA,3,0             ; si se pulsa PORTA == 0
    GOTO    CAPTURA_b
    GOTO    IMPAR_1
    
  
CONFIGURATION_OSCC:  
    BANKSEL OSCCON1
    MOVLW   0x60            ; 01100000B // 0x60  - Seleccionamos el bloque del osc interno con un div:1    
    MOVWF   OSCCON1,1
    MOVLW   0x02            ; Configuramos una frecuencia de 4Mhz para hacer efectiva la librería de retardos
    MOVWF   OSCFRQ,1
    RETURN
    
CONFIGURATION_PORTS:
    ; Config. de puertos para los leds de ambos corrimiento
    BANKSEL PORTC   
    CLRF    PORTC,1	;PORTC <7:0> = 0
    CLRF    LATC,1	;LATC<7:0> = 0 
    CLRF    ANSELC,1	;ANSELC <7:0> = 0 ,Digital
    CLRF    TRISC,1	;Configuramos los pines del puerto C como salidas
    ; Config. de leds para visualizar cuando se da el corrimiento par o impar.
    BANKSEL PORTE   
    CLRF    PORTE,1	;PORTC = 0
    BCF     LATE,0,1	;LATC = 0, Leds apagado
    BCF     LATE,1,1
    CLRF    ANSELE,1	;ANSELC <7:0> = 0 ,Digital
    CLRF    TRISE,1	;Todos salidas 
    ; Config. buttom
    BANKSEL PORTA
    CLRF    PORTA,1	;PORTA <7:0> = 0
    CLRF    ANSELA,1	;ANSELA = 0 ,Digital
    BSF	    TRISA,3,1	;TRISA = 1 -> entrada
    BSF	    WPUA,3,1	;Activamos la resistencia Pull-up del pin RA3
    RETURN
    END P1