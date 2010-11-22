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

void setup () {
    Serial.begin(57600);
    Serial.println("\n[gvsControl]");
    rf12_initialize(MASTERID, RF12_868MHZ, 33);
    rf12_encrypt(RF12_EEPROM_EKEY);
    
}

void loop () {
    rf12_recvDone();
    byte event = blink.buttonCheck();
    switch (event) {
        
    case BlinkPlug::ON1:
        Serial.println("Left"); 
        payload[0]=LEFT;
        break;
    
    case BlinkPlug::OFF1:
        Serial.println("Off"); 
        payload[0]=CENTER;
        break;
    
    case BlinkPlug::ON2:
        Serial.println("Right"); 
        payload[0]=RIGHT;
        break;
    
    case BlinkPlug::OFF2:
        Serial.println("Off"); 
        payload[0]=CENTER;
        break;
        
    default:
        payload[0]=NULL;
        break; 
    
    }
    
    if (rf12_canSend() && payload[0]!=NULL) {
        // send out a new packet every 3 seconds
        Serial.print("  send ");
        Serial.println((int) sendSize);
        // send as broadcast, payload will be encrypted
        rf12_sendStart(SLAVEID, payload, sendSize);

    }
    

    
}
