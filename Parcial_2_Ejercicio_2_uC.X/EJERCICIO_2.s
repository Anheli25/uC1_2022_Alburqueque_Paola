//--------------------------------------------------------------------------------
    ;@file     EJERCICIO_2
    ;@brief    Este programa permite ejecutar una secuencia de leds, con 
    ;          interrupciones de baja y alta prioridad utilizando pulsadores
    ;          externos:
    ;Especificaciones:
    ;          - RA3 Interrupción de baja prioridad (INT0)
    ;          - RB4: Interrupción de baja prioridad (INT1)
    ;          - RF2: Interrupción de alta prioridad (INT2)
    ;@Date     27/01/2023
    ;@Author   Anheli Paola Alburqueque Sernaque 
//--------------------------------------------------------------------------------  

PROCESSOR 18F57Q84
#include "Bit_Configuration.inc"    
#include <xc.inc>
;#include "Delay_library.inc"
    
PSECT resetVect,class=CODE,reloc=2
    resetVect: 
    GOTO Main

 PSECT ISRVectLowPriority,class=CODE,reloc=2
    ISRVectLowPriority:
        BTFSS    PIR1,0,0       ; Si PIR1 ==1 salta (Será 1 si se pulsa RA3 de la placa)
        GOTO     Way_out        ; Si PIR1==0 Continuará hacia la etiqueta "Way_out"
      Start_seq:
        BCF      PIR1,0,0       ; Limpiamos la bandera de PIR1 
	GOTO     Load           ; Salta hacia la carga inicial
    Way_out:
        RETFIE
	
 PSECT ISRVectHighPriority,class=CODE,reloc=2
    ISRVectHighPriority:
        BTFSS    PIR6,0,0      ;Si PIR6 == 1 salta (Será uno si se pulsa el botón RB4)
	GOTO     PIR10_RF2     ;PIR6==0 (Redirecciona hacia el reset general)
      Start_Toggle:
        BCF      PIR6,0,0      ; Limpiamos la bandera de PIR6
	GOTO     Toggle_RF2    ; Salta hacia la etiqueta "Toggle_RF2"
    Way_out1:
        RETFIE
    
  PSECT udata_acs
 ;  Reservamos 1 byte para cada etiqueta de los contadores en el delay de 250ms
    Count1:   DS 1
    Count2:   DS 1     
 ; Reservamos para las ejecuciones únicamente dentro del programa
    Offset:    DS 1     ;Reservamos un byte en la etiqueta de Offset
    Counter:   DS 1     ;Contador de los valores para la tabla de búsqueda (offset)
    counter1:  DS 1     ;Contador para las repeticiones de la secuencia
    
    
  PSECT CODE
    Main:
      ;Configuraciones generales
       CALL   Configuration_OSC,1       
       CALL   CONFIG_PORTS,1
       CALL   CONFIG_PPS,1
       CALL   CONFIG_INTS,1
       GOTO   Toggle_RF2
       
    Load:      
    MOVLW 5               
    MOVWF counter1,0       ;Cargamos la variable counter1 con el valor de 5
    MOVLW 0
    MOVWF Offset,0         ; Cargamos al offset con el valor de 0
    GOTO  Recharge         ; Salta hacia la etiqueta "Recarga"
    
    L5T:                   ;Después de 5 turnos
    DECFSZ  counter1,1,0   ;Decrementa el counter1 en 1 y si llega a cero "salta"
    GOTO    Recharge       ;Continúa a esta instrucción si counter1>0 y salta hacia la etiqueta "Recharge"
    GOTO    Way_out        ;Salta si counter1==0, y se dirige hacia la etiqueta "Way_out"
    
    Total_wipe:          
    SETF    LATC,0         ;Setea el puerto C  (Apaga los leds)
    CALL    Delay_250ms,1  
    CALL    Delay_250ms,1
    GOTO    Out            ;Salta hacia la etiqueta "Out"
 
     Loop_seq:
      BSF     LATF,3,0              ;Setea el bit 3 del PORTF (apaga el led de la placa)
      BANKSEL PCLATU                
      MOVLW   low highword(TABLE_G) 
      MOVWF   PCLATU,1
      MOVLW   high(TABLE_G)
      MOVWF   PCLATH,1
      RLNCF   Offset,0,0
      CALL    TABLE_G
      MOVWF   LATC,0                ; 
      CALL    Delay_250ms,1
      DECFSZ  Counter,1,0           ;Decrementa el Counter (Vo=10 debido a los valores de la tabla)
      GOTO    Next_Seq              ;Si Counter>0, salta hacia la etiqueta "Next_seq"
      GOTO    L5T                   ;Si Counter == 0 salta hacia la etiqueta "L5T"
    
        Next_Seq:
             INCF    Offset,1,0     ; Incrementa el valor del Offset en 1 
	     GOTO    Loop_seq       ; Salta hacia la etiqueta "Loop_seq"
	     
     Recharge:
             MOVLW   10
             MOVWF   Counter,0	; carga el contador con el numero de offsets
             MOVLW   0x00	
             MOVWF   Offset,0	; definimos el valor del offset inicial
             GOTO    Loop_seq
	     
    PIR10_RF2:
       BTFSS   PIR10,0,0     ;Verifica si PIR10==1, si lo es, salta hacia la etiqueta "Stop"
       GOTO    Way_out1      ;Continúa con esta instrucción si PIR10==0 y salta hacia la etiqueta "Way_out"
    Stop:
       BCF    PIR10,0,0      ;Limpia la bandera del PIR10 
       GOTO   Total_wipe     ;Salta hacia la etiqueta "Total_wipe"
	   
   Toggle_RF2:
    BTFSC   PORTF,2,0        ; Verifica si el botón RF2 ha sido presionado, si PORTF<2>==0 "SALTA"
    BTG     LATF,3,0         ; 
    BTFSC   PORTF,2,0        ; Vuelve a verificar a PORTF<2>
     CALL   Delay_250ms,1    ; Continúa a esta instrucción si PORTF<2>==1 *wait 250ms
    BTFSC   PORTF,2,0        ; Vuelve a verificar a PORTF<2>
     CALL   Delay_250ms,1    ; Continúa a esta instrucción si PORTF<2>==1 *wait 250ms
    BTFSC   PORTF,2,0        ; Vuelve a verificar a PORTF<2> 
    GOTO    Toggle_RF2       ; Continúa a esta instrucción si PORTF<2>==1  **Regresa al principio de esa misma secuencia
    GOTO    PIR10_RF2        ; Salta a esta instrución Si PORTF<2>==0   **Salta hacia la etiqueta PIR10_RF2
 
    ////////////////////////////////////////////////////////////
     /////// CONFIGURACIONES [OSCILADOR-PUERTOS-PPS-INT]//////
    ////////////////////////////////////////////////////////////
    
    Configuration_OSC:
    // Configuración del oscilador a una freq interna de 4MHz 
    BANKSEL  OSCCON1     ; Seleccionamos el registro de control de oscilador 1
    MOVLW    0x60        ; Seleccionamos el bloque del osc interno con DIV = 1
    MOVWF    OSCCON1,1   
    MOVLW    0x02        ; Seleccionamos la frecuencia 4MHz
    MOVWF    OSCFRQ,1    ; Registro de selección de frecuencia HFINTOSC
    RETURN 
   
    CONFIG_PORTS:
      // Configuración del led de la placa [RF3]
    BANKSEL PORTF
    CLRF    PORTF,1
    BSF     LATF,3,1 
    CLRF    ANSELF,1
    BCF     TRISF,3,1
    
      //Configuración del pulsador de la placa [RA3]
    BANKSEL PORTA       
    CLRF    PORTA,1	 ;PORTA         = 0 --> 
    CLRF    ANSELA,1	 ;ANSELA        = 0 --> Digital
    BSF     TRISA,3,1	 ;TRISA<3>      = 1 --> Entrada
    BSF     WPUA,3,1    ;WPUA<3>       = 1 --> R pull-up enable
    
       //Configuración del pulsador externo 1 [RB4]
    BANKSEL PORTB
    CLRF    PORTB,1	
    CLRF    ANSELB,1	
    BSF     TRISB,4,1	
    BSF     WPUB,4,1

       //Configuración del pulsador externo 2 [RF2]
    BANKSEL PORTF
    CLRF    PORTF,1	
    CLRF    ANSELF,1	
    BSF     TRISF,2,1	
    BSF     WPUF,2,1

       //Configuracion del puerto C [7:0]
    BANKSEL PORTC
    SETF    PORTC,1	
    SETF    LATC,1	
    CLRF    ANSELC,1	
    CLRF    TRISC,1
    RETURN
     
    CONFIG_PPS:
        //Configuración INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	   ; INT0 --> RA3 --> low prioirity
     
       //Configuración INT1
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	 ; INT1 --> RB4 --> high priority
    
       // Configuración INT2
    BANKSEL INT2PPS
    MOVLW 0X2A
    MOVWF INT2PPS,1      ; INT2 --> RF2 -->high priority
    RETURN
     
   ;   Secuencia para configurar interrupcion:
   ;    1. Definir prioridades
   ;    2. Configurar interrupcion
   ;    3. Limpiar el flag
   ;    4. Habilitar la interrupcion
   ;    5. Habilitar las interrupciones globales
   
   CONFIG_INTS:
        //Configuracion de prioridades 
    BSF	INTCON0,5,0  ; INTCON0<IPEN> = 1 -- Habilitamos todas las prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1     ; IPR1<INT0IP> = 0 -- INT0 de baja prioridad
    BSF	IPR6,0,1     ; IPR6<INT1IP> = 1 -- INT1 de alta prioridad
    BSF IPR10,0,1    ; IPR10<INT2P> = 1 -- INT2 de alta prioridad
        
        //Configuracion INT0
    BCF	INTCON0,0,0  ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0     ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0     ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0	
    
        //Configuracion INT1
    BCF	INTCON0,1,0  ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0     ; PIR6<INT0IF>     = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0     ; PIE6<INT0IE>     = 1 -- habilitamos la interrupcion ext1
    
        //Configuracion INT2
    BCF	INTCON0,2,0  ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR10,0,0    ; PIR10<INT0IF>   = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE10<INT0IE>   = 1 -- habilitamos la interrupcion ext2
     
        //Global Interrupt Enable -- Global Low Interrupt Enable
    BSF	INTCON0,7,0   ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0   ; INTCON0<GIEL>      = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
    
    ////////////////////////////////////////////////////////////////////////
    /////////TABLA DE BÚSQUEDA//////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////
    
    TABLE_G:
      ADDWF   PCL,1,0
      RETLW   01111110B	; offset: 0
      RETLW   00111100B	; offset: 1
      RETLW   00011000B	; offset: 2
      RETLW   00000000B	; offset: 3
      RETLW   11111111B	; offset: 4
      RETLW   11100111B	; offset: 5
      RETLW   11000011B	; offset: 6
      RETLW   10000001B	; offset: 7
      RETLW   00000000B	; offset: 8
      RETLW   11111111B	; offset: 9
      
      ///DELAY///
      
 Delay_250ms:                          ;  1 Call ---> 2 TCY
         MOVLW  250                    ;  MOVLW  ---> 1 TCY --->k2
         MOVWF  Count2,0               ;  MOVWF  ---> 1 TCY
         ; t = (6+4k1)us
         Con_ext_250ms:  
             MOVLW  249                ;  k2*TCY -->k1
             MOVWF  Count1,0           ;  k2*TCY
         Con_int_250ms:
             Nop                       ;  k2*k1*TCY
             DECFSZ Count1,1,0         ;  k2*((k1-1) + 3*Tcy)
             GOTO   Con_int_250ms      ;  k2((k1-1)*2TCY)
             DECFSZ Count2,1,0         ;  (k2-1) + 3*TCY
             GOTO   Con_ext_250ms      ;  (k2-1)*2TCY
             RETURN                    ;  2*TCY
Out:
   END resetVect