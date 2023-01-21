PROCESSOR 18F57Q84
#include "Bit_Configuration.inc" // config statements should precede project file includes.
#include <xc.inc>
#include "Delay_library.inc"
        
PSECT udata_acs
 offset: DS 1
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT CODE
 Main:  
    
  CALL Config_osc,1
  CALL Config_port,1
 Loop:
    M


