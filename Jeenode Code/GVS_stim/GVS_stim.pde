// Test encrypted communication, receiver side
// 2010-02-21 <jcw@equi4.com> http://opensource.org/licenses/mit-license.php
// $Id: crypRecv.pde 4833 2010-02-21 21:44:24Z jcw $

#include <RF12.h>
#include <Ports.h>
#include "Commands.h"

byte recvCount;
//Convention: Port 1 goes to left electrode
Port left(1);
//Convention: Port 4 goes to right electrode
Port right(4);


void setup () {
    //Ports in output mode
    left.mode(OUTPUT);
    right.mode(OUTPUT);
    //set both off
    left.digiWrite(0);
    right.digiWrite(0);
    //initialize the serial port for debugging
    Serial.begin(57600);
    Serial.println("\n[gvsStim]");
    //initialize the radio module with encryption
    rf12_initialize(SLAVEID, RF12_868MHZ, 33);
    rf12_encrypt(RF12_EEPROM_EKEY);
}

// Receive commands from the Command node and interpret them

void loop () {
    if (rf12_recvDone() && rf12_crc == 0) {
        // good packet received
        if (recvCount < CMD_LEN)
            Serial.print(' ');
        Serial.print((int) recvCount);
        // report whether incoming was treated as encoded
        Serial.print(recvCount < CMD_LEN? " (enc)" : "      ");
        Serial.print(" seq ");
        Serial.print(rf12_seq);
        Serial.print(" =");
        for (byte i = 0; i < rf12_len; ++i) {
            Serial.print(' ');
            Serial.print(rf12_data[i], HEX);
        }
        Serial.println();
        //now do a switch to control
        switch (rf12_data[0]) {
              
          case LEFT:
              Serial.println("Left"); 
              left.digiWrite(1);
              right.digiWrite(0);
              break;
          
          case CENTER:
              Serial.println("Off"); 
              left.digiWrite(0);
              right.digiWrite(0);
              break;
          
          case RIGHT:
              Serial.println("Right"); 
              left.digiWrite(0);
              right.digiWrite(1);
              break;
 
          default:
              break; 
        }
        // set encryption for receiving (0..9 encrypted, 10..19 plaintext)
        rf12_encrypt(RF12_EEPROM_EKEY);
    }
}
