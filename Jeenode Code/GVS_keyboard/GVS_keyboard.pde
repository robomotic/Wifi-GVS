// Show how the BlinkPlug's buttonCheck function works
// 2010-08-23 <jcw@equi4.com> http://opensource.org/licenses/mit-license.php
// $Id: button_demo.pde 5961 2010-08-23 15:50:03Z jcw $

#include <Ports.h>
#include <RF12.h> // needed to avoid a linker error :(
#include "Commands.h"

BlinkPlug blink (1);
MilliTimer everySecond;
MilliTimer sendTimer;
byte sendSize=1;
char payload[]={CENTER};
byte inByte=CENTER;
void setup () {
    Serial.begin(57600);
    Serial.println("\n[gvsControl]");
    rf12_initialize(MASTERID, RF12_868MHZ, 33);
    rf12_encrypt(RF12_EEPROM_EKEY);
    
}

void loop () {
    rf12_recvDone();
 // if we get a valid byte, read analog ins:
    if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    
    switch(inByte){
      case 'R':
        payload[0]=RIGHT; 
      Serial.print("R");
      break;
      case 'L':
     payload[0]=LEFT; 
     Serial.println("L");
      break;
      case 'C':
     payload[0]=CENTER; 
     Serial.println("C");
      break;
    }      
    }
    
    if (rf12_canSend() && payload[0]!=NULL) {
        // send out a new packet every 3 seconds
        //Serial.print("  send ");
        //Serial.println((int) sendSize);
        // send as broadcast, payload will be encrypted
        rf12_sendStart(SLAVEID, payload, sendSize);

    }
    

    
}
