/*
 * OTOduinoSimpleClient.pde - software modem simple client sketch for Arduino
 * Copyright (C) 2010-2011 REINFORCE Lab. All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the MIT license.
 *
 */

#include <OTOplug1200.h>
#include "OTOduinoTypes.h"

// ****
// Definitions
// ****
#define SERIAL_DEBUG 0
#if SERIAL_DEBUG
#endif

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
// methods
// ****

// packet receiver method
void packetReceivedCallback(const uint8_t *buf, uint8_t length)
{
#if SERIAL_DEBUG
 packetDump(rcvBuf, length);
#endif

  if(length == 0 || rcvLength != 0) return;
  // copy buffer
  for(int i=0; i < length; i++) {
    rcvBuf[i] = buf[i];
  }
  rcvLength = length;
}

// packet dump 
#if SERIAL_DEBUG
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
#endif

// read a packet and do somethins
void processPacket()
{
  if(rcvLength == 0) return;

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
    shouldSendInitializedMessage = false;
    break;
  default: break;
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
#if SERIAL_DEBUG
  Serial.print("pk_setAnalogPinEnabled() pinnum:");
  Serial.print((int)rcvBuf[1]);
  Serial.print(", enabled:");
  Serial.println((int)rcvBuf[2]);
#endif
  // <setAnalogPiEnabled, pin#, disable/enable(0/1)>  
  uint8_t pinnum = rcvBuf[1];
  bool enabled   = (rcvBuf[2] != 0);
  if(pinnum > 0 && pinnum < NumOfAnalogPins) {
    analogPinEnabled[pinnum] = enabled;    
  }
}
void pk_requestAnalogPinEnabled()
{
#if SERIAL_DEBUG
  Serial.print("pk_requestAnalogPinEnabled() pinum:");
  Serial.println((int)rcvBuf[1], DEC);
#endif

  // <requestAnalogPinEnabled, pin#>
  uint8_t pinnum = rcvBuf[1];
  if(pinnum >= NumOfAnalogPins) return;
  
  // <analogPinEnabledMessage,   pin#,   enable(1)/disable(0)>  
  sendBuf[0] = analogPinEnabledMessage;
  sendBuf[1] = pinnum;
  sendBuf[2] = analogPinEnabled[pinnum];
  OTOplug1200.write(sendBuf, 3);
}
void pk_setDigitalPinMode()
{
#if SERIAL_DEBUG
  Serial.print("pk_setDigitalPinMode() pinum:");
  Serial.print((int)rcvBuf[1], DEC);
  Serial.print(",");
  Serial.println((int)rcvBuf[2], HEX); 
#endif

  //<setDigitalPinMode, pin#, pinmode>
  uint8_t pinnum = rcvBuf[1];
  if(pinnum > 1 && pinnum < NumOfDigitalPins && pinnum != MODEM_DOUT_PIN) {
    OTOduinoPinModeType pinModeType = (OTOduinoPinModeType)rcvBuf[2];
    digitalPinModes[pinnum] = pinModeType;
    boolean isOutput = (pinModeType == Output);
    pinMode(pinnum, isOutput);
  } 
}
void pk_requestDigitalPinMode()
{ 
#if SERIAL_DEBUG
  Serial.print("pk_requestDigitalPinEnabled() pinum:");
  Serial.println((int)rcvBuf[1], DEC);
#endif

  //<requestDigitalPinMode, pin#>
  uint8_t pinnum = rcvBuf[1];
  //<digitalPinModeMessage, pin#, pinmode>
  sendBuf[0] = digitalPinModeMessage;
  sendBuf[1] = pinnum;
  sendBuf[2] = digitalPinModes[pinnum];
  OTOplug1200.write(sendBuf, 3);
}
void sendDigitalPortMessage(uint16_t value)
{
  //<digitalIOMessage, port#, lsb<7:0>, msb<15:8>>
  sendBuf[0] = digitalIOMessage;
  sendBuf[1] = 0;
  sendBuf[2] = 0x0ff & value;
  sendBuf[3] = (value >> 8);
  OTOplug1200.write(sendBuf, 4);
}
void sendAnalogIOMessage(uint8_t pinnum, uint16_t value)
{
  //(analogIOMessage, pin#, lsb<7:0>, msb<15:8>)
  sendBuf[0] = analogIOMessage;
  sendBuf[1] = pinnum;
  sendBuf[2] = value;
  sendBuf[3] = value >> 8; 
  OTOplug1200.write(sendBuf, 4);  
}

void setup()
{
#if SERIAL_DEBUG
  Serial.begin(115200);
#endif
  for(int i = 2; i < NumOfDigitalPins; i++) {
   digitalPinModes[i] = Input;
   pinMode(i, INPUT);
   digitalRead(i);
  }
  
  reportingAnalogPin = 1;
  shouldSendInitializedMessage = true;
  
  OTOplug1200.begin();
  OTOplug1200.attach(packetReceivedCallback);
}
void loop()
{ 
  // receive packet and reply to it
  if(!OTOplug1200.writeAvailable()) return;  
  processPacket();
  
  if(!OTOplug1200.writeAvailable()) return;
  if(shouldSendInitializedMessage) {
  //  Serial.println("sending initialized message.");
    sendBuf[0] = clientInitMessage;
    OTOplug1200.write(sendBuf, 1);  
  }
 
  // report digital/analog port value only when modem buffer is available.
  if(!OTOplug1200.writeAvailable()) return;
  if(shouldReportAnalogValue) {
    // read analog port
    if(analogPinEnabled[reportingAnalogPin]) {
      OTOplug1200.startADConversion(reportingAnalogPin);
      uint8_t pinnum;
      uint16_t value;
      if( OTOplug1200.readAnalogPin(&pinnum, &value)) {
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

