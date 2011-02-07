/*
 * OTOduinoSimpleClient.pde - software modem simple client sketch for Arduino
 * Copyright (C) 2010-2011 REINFORCE Lab. All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the MIT license.
 *
 */

#include <SoftwareModem.h>
#include "OTOduinoTypes.h"

// ****
// Variables
// ****
#define NumOfAnalogPins  6
#define NumOfDigitalPins 14

uint8_t rcvBuf[MAX_PACKET_SIZE];
uint8_t rcvLength;
uint8_t sendBuf[MAX_PACKET_SIZE];
bool analogPinEnabled[NumOfAnalogPins];
OTOduinoPinModeType digitalPinModes[NumOfDigitalPins];
uint16_t digitalPortValue;
bool shouldReportAnalogValue;
uint8_t reportingAnalogPin;
bool shouldSendInitializedMessage;
// ****
// Definitions
// ****

// ****
// methods
// ****

// packet receiver method
void packetReceivedCallback(const uint8_t *buf, uint8_t length)
{
 // packetDump(rcvBuf, length); // DEBUG
  
  if(length == 0 || rcvLength != 0) return;
  // copy buffer
  for(int i=0; i < length; i++) {
    rcvBuf[i] = buf[i];
  }
  rcvLength = length;
}
// packet dump 
void packetDump(const uint8_t *buf, uint8_t length)
{  
  Serial.print("Packet(len:");
  Serial.print(length, DEC);
  Serial.print(")");
  
  for(int i=0; i < length; i++) {
    Serial.print(", ");
    Serial.print(buf[i], HEX);
  }
  Serial.println("");
}
// read a packet and do somethins
void processPacket()
{
  if(rcvLength == 0) return;

//packetDump(rcvBuf, rcvLength); // DEBUG

  switch(rcvBuf[0] )  {
   case digitalIOMessage:
     pk_digitalIOMessage();
   break;
    // analog pin command
  case setAnalogPinEnabled: 
    pk_setAnalogPinEnabled();
    break;
  case requestAnalogPinEnabled: 
    pk_requestAnalogPinEnabled();
    break;
    //Digital pin commands
  case setDigitalPinMode: 
    pk_setDigitalPinMode();
    break;
  case requestDigitalPinMode: 
    pk_requestDigitalPinMode();
    break;
  case clientInitConfirmedMessage:
  //Serial.println("received initialization confirmed message.");
    shouldSendInitializedMessage = false;
    break;
  default: 
//    packetDump(rcvBuf, rcvLength);
Serial.println("^- unknown packet");
  }
  rcvLength = 0;
}
// set digital pin value
void pk_digitalIOMessage()
{
  if(rcvLength != 4 || rcvBuf[1] != 0) return;  
  digitalPortValue = rcvBuf[2] | (rcvBuf[3] << 8); 
  uint16_t mask  = 0x04;
  for(int i=2; i < NumOfDigitalPins; i++) {
    if(i != MODEM_DOUT_PIN && digitalPinModes[i] == Output) {
      uint8_t pinval = ((digitalPortValue & mask) == 0) ? 0 : 1;
      digitalWrite(i, pinval);
    }
    mask <<= 1;
  }
}
void pk_setAnalogPinEnabled()
{
  /*
   Serial.print("pk_setAnalogPinEnabled() pinnum:");
  Serial.print((int)rcvBuf[1]);
  Serial.print(", enabled:");
  Serial.println((int)rcvBuf[2]);
  */
  // <setAnalogPiEnabled, pin#, disable/enable(0/1)>  
  uint8_t pinnum = rcvBuf[1];
  bool enabled   = (rcvBuf[2] != 0);
  if(pinnum > 0 && pinnum < NumOfAnalogPins) {
    analogPinEnabled[pinnum] = enabled;    
  }
}
void pk_requestAnalogPinEnabled()
{
/*  
  Serial.print("pk_requestAnalogPinEnabled() pinum:");
  Serial.println((int)rcvBuf[1], DEC);
*/  
  // <requestAnalogPinEnabled, pin#>
  uint8_t pinnum = rcvBuf[1];
  if(pinnum >= NumOfAnalogPins) return;
  
  // <analogPinEnabledMessage,   pin#,   enable(1)/disable(0)>  
  sendBuf[0] = analogPinEnabledMessage;
  sendBuf[1] = pinnum;
  sendBuf[2] = analogPinEnabled[pinnum];
  SoftwareModem.write(sendBuf, 3);
}
void pk_setDigitalPinMode()
{
  /*
  Serial.print("pk_setDigitalPinMode() pinum:");
  Serial.print((int)rcvBuf[1], DEC);
  Serial.print(",");
  Serial.println((int)rcvBuf[2], HEX); 
  */
  //<setDigitalPinMode, pin#, pinmode>
  uint8_t pinnum = rcvBuf[1];
  if(pinnum > 1 && pinnum < NumOfDigitalPins) {
    digitalPinModes[pinnum] = (OTOduinoPinModeType) rcvBuf[2];
  } 
}
void pk_requestDigitalPinMode()
{ 
  /*
  Serial.print("pk_requestDigitalPinEnabled() pinum:");
  Serial.println((int)rcvBuf[1], DEC);
  */
  //<requestDigitalPinMode, pin#>
  uint8_t pinnum = rcvBuf[1];
  //<digitalPinModeMessage, pin#, pinmode>
  sendBuf[0] = digitalPinModeMessage;
  sendBuf[1] = pinnum;
  sendBuf[2] = digitalPinModes[pinnum];
  SoftwareModem.write(sendBuf, 3);
}
void sendDigitalPortMessage(uint16_t value)
{
  //<digitalIOMessage, port#, lsb<7:0>, msb<15:8>>
  sendBuf[0] = digitalIOMessage;
  sendBuf[1] = 0;
  sendBuf[2] = 0x0ff & value;
  sendBuf[3] = (value >> 8);
  SoftwareModem.write(sendBuf, 4);
}
void sendAnalogIOMessage(uint8_t pinnum, uint16_t value)
{
  //(analogIOMessage, pin#, lsb<7:0>, msb<15:8>)
  sendBuf[0] = analogIOMessage;
  sendBuf[1] = pinnum;
  sendBuf[2] = value;
  sendBuf[3] = value >> 8; 
  SoftwareModem.write(sendBuf, 4);  
}

void setup()
{
  Serial.begin(115200);
  Serial.println("start");
  SoftwareModem.begin();
  SoftwareModem.attach(packetReceivedCallback);

  reportingAnalogPin = 1;
  shouldSendInitializedMessage = true;
  
  for(int i = 0; i < NumOfDigitalPins; i++) {
   digitalPinModes[i] = Input;
   digitalRead(i);
  }
}
void loop()
{ 
  // receive packet and reply to it
  if(!SoftwareModem.writeAvailable()) return;  
  processPacket();
  
  if(!SoftwareModem.writeAvailable()) return;
  if(shouldSendInitializedMessage) {
  //  Serial.println("sending initialized message.");
    sendBuf[0] = clientInitMessage;
    SoftwareModem.write(sendBuf, 1);  
  }
 
  // report digital/analog port value only when modem buffer is available.
  if(!SoftwareModem.writeAvailable()) return;
  if(shouldReportAnalogValue) {
    // read analog port
    if(analogPinEnabled[reportingAnalogPin]) {
      SoftwareModem.startADConversion(reportingAnalogPin);
      uint8_t pinnum;
      uint16_t value;
      if( SoftwareModem.readAnalogPin(&pinnum, &value)) {
       sendAnalogIOMessage(pinnum, value);
       reportingAnalogPin++;
      }
    } else {
      reportingAnalogPin++;
    }
  if(reportingAnalogPin >= NumOfAnalogPins) {
    reportingAnalogPin = 1;
  }
 } else {
 // read digital port 
 uint16_t mask = 0x04;
 for(int i = 2; i < NumOfDigitalPins; i++) {
   if(digitalPinModes[i] == Input) {
     if(digitalRead(i)) {
        digitalPortValue |= mask;
      } else {
        digitalPortValue &= ~mask;
      }
    }
    mask <<= 1;
  }
  sendDigitalPortMessage(digitalPortValue);
 }
 shouldReportAnalogValue = ! shouldReportAnalogValue;
}

