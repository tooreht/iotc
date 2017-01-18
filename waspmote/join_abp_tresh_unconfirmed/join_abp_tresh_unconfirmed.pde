/*  
 *  ------ LoRaWAN Code Example -------- 
 *  
 *  Explanation: This example shows how to configure the module
 *  and send packets to a LoRaWAN gateway without ACK after join a network
 *  using ABP
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify  
 *  it under the terms of the GNU General Public License as published by  
 *  the Free Software Foundation, either version 3 of the License, or  
 *  (at your option) any later version.  
 *   
 *  This program is distributed in the hope that it will be useful,  
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of  
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
 *  GNU General Public License for more details.  
 *   
 *  You should have received a copy of the GNU General Public License  
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.  
 *  
 *  Version:           0.1
 *  Design:            David Gascon 
 *  Implementation:    Luismi Marti  
 */

#include <WaspLoRaWAN.h>

// socket to use
//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// Device parameters for registration on LRWNS
////////////////////////////////////////////////////////////
char DEVICE_EUI[]  = "00000000000000000";                     // <- enter DevEUI here
char DEVICE_ADDR[] = "00000000";                              // <- enter DevAddr here
char NWK_SESSION_KEY[] = "00000000000000000000000000000000";  // <- enter NwkSk here
char APP_SESSION_KEY[] = "00000000000000000000000000000000";  // <- enter AppSk here
////////////////////////////////////////////////////////////

// Define port to use in Back-End: from 1 to 223
uint8_t PORT = 3;

// Sensor values
uint16_t soc; // State of Charge
uint16_t temperature; // Temperature

// Define data payload to send (maximum is up to data rate)
//char data[] = "1A00";
const int DATA_LEN = sizeof(soc) + sizeof(temperature) + 1;
char data[DATA_LEN];

// variable
uint8_t error;



void setup() 
{
  PWR.ifHibernate(); // Checks if we come from a normal reset or an hibernate reset
  PWR.setSensorPower(SENS_5V, SENS_ON);
  delay(200);

  RTC.ON();
  USB.ON();
  USB.println(F("LoRaWAN example - Send Unconfirmed packets (no ACK)\n"));


  USB.println(F("------------------------------------"));
  USB.println(F("Module configuration"));
  USB.println(F("------------------------------------\n"));


  //////////////////////////////////////////////
  // 1. Switch on
  //////////////////////////////////////////////

  error = LoRaWAN.ON(socket);
  // Check status
  if( error == 0 ) 
  {
    USB.println(F("1. Switch ON OK"));     
  }
  else 
  {
    USB.print(F("1. Switch ON error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 2. Set Device EUI
  //////////////////////////////////////////////

  error = LoRaWAN.setDeviceEUI(DEVICE_EUI);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("2. Device EUI set OK"));     
  }
  else 
  {
    USB.print(F("2. Device EUI set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 3. Set Device Address
  //////////////////////////////////////////////

  error = LoRaWAN.setDeviceAddr(DEVICE_ADDR);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("3. Device address set OK"));     
  }
  else 
  {
    USB.print(F("3. Device address set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 4. Set Network Session Key
  //////////////////////////////////////////////

  error = LoRaWAN.setNwkSessionKey(NWK_SESSION_KEY);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("4. Network Session Key set OK"));     
  }
  else 
  {
    USB.print(F("4. Network Session Key set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 5. Set Application Session Key
  //////////////////////////////////////////////

  error = LoRaWAN.setAppSessionKey(APP_SESSION_KEY);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5. Application Session Key set OK"));     
  }
  else 
  {
    USB.print(F("5. Application Session Key set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 6. Save configuration
  //////////////////////////////////////////////

  error = LoRaWAN.saveConfig();

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("6. Save configuration OK"));     
  }
  else 
  {
    USB.print(F("6. Save configuration error = ")); 
    USB.println(error, DEC);
  }


  USB.println(F("\n------------------------------------"));
  USB.println(F("Module configured"));
  USB.println(F("------------------------------------\n"));

  LoRaWAN.getDeviceEUI();
  USB.print(F("Device EUI: "));
  USB.println(LoRaWAN._devEUI);  

  LoRaWAN.getDeviceAddr();
  USB.print(F("Device Address: "));
  USB.println(LoRaWAN._devAddr);  

  USB.println();  
  
  USB.printf("%s\n", "Enabling PWR_5V");
  PWR.setSensorPower(SENS_5V, SENS_ON);
  delay(200);
   
  pinMode(DIGITAL7,OUTPUT); // Trigger for Ultrasonic Sensor
  pinMode(DIGITAL6,INPUT); // Receiver for Ultrasonic Sensor

  delay(200);
  
}



void loop() 
{
   long duration;
  uint16_t dist = 0; // Distance
  int distMin = 0;
  int distMax = 0;
  int distCount = 0;
  int distMinCnt = 0;
  int distMaxCnt = 0;
  
  uint16_t batt=0; // Battery
  int battMin = 0;
  int battMax = 0; 
  int battCount = 0;
  int battMinCnt = 0;
  int battMaxCnt = 0;

  uint16_t temp = 0; // Temperature

  int distance[10];
  int battery[10];
  
  USB.println("Measuring");
  for (int i=0; i <= 9; i++){       
      // initiate measurement
      digitalWrite(DIGITAL7, LOW);
      delayMicroseconds(10);
      digitalWrite(DIGITAL7, HIGH);
      delayMicroseconds(10);
      digitalWrite(DIGITAL7, LOW);
      // measure echo
      duration = pulseIn(DIGITAL6, HIGH);
  
      // calculate & show distance in cm
      distance[i] = duration / 29 / 2;
      //delay(100);
      battery[i] = PWR.getBatteryLevel();
   }
   
   distMax = distance[0];
   distMin = distance[0];
   
   battMax = battery[0];
   battMin = battery[0];
   
   for (int i=0; i <= 9; i++){ // read 10 times the Distance and batery
     if ( distance[i] > distMax) {
       distMax = distance[i];
     } else if ( distance[i] < distMin) {
       distMin = distance[i];
     }
     if ( battery[i] > battMax) {
       battMax = battery[i];
     } else if ( battery[i] < battMin) {
       battMin = battery[i];
     }
    }
    
    for (int i=0; i <= 9; i++){ // evaluate the min and max of the 10 measurements
     if ( distance[i] < distMax && distance[i] > distMin) {
      distCount++;
      dist = dist + distance[i];
     } else if (distance[i] == distMax) {
       distMaxCnt++; 
     } else if (distance[i] == distMin)
       distMinCnt++;
     
     if ( battery[i] < battMax && battery[i] > battMin) {
      battCount++;
      batt = batt + battery[i];
     } else if (battery[i] == battMax) {
       battMaxCnt++; 
     } else if (battery[i] == battMin) {
       battMinCnt++;
     }  
   }
    
    

    if (distCount > 0 && distMax - distMin > 1) { // substract min and max values if there are values in between
      dist = dist / distCount;
    } else {
      if (distMaxCnt > distMinCnt && distMaxCnt > 2) {
        dist = distMax;
      } else if (distMinCnt > distMaxCnt && distMinCnt > 2) {
       dist = distMin; 
      } else {
       dist = distMin + distMax / 2; 
      }
    }
    
    if (battCount > 0 && battMax - battMin > 1) {
      batt = batt / battCount;
    } else {
      if (battMaxCnt > battMinCnt && battMaxCnt > 2) {
        batt = battMax;
      } else if (battMinCnt > battMaxCnt && battMinCnt > 2) {
       batt = battMin; 
      } else {
       batt = battMin + battMax / 2; 
      }
    }

//     SX1272 Temperature - always 12
//     e = sx1272.getTemp();
//    if( e == 0 ) 
//    { 
//     temp = sx1272._temp;
//    }

    temp = RTC.getTemperature();
        
    char res[48];
    sprintf(res, "\"distance\": %d, \"battery\": %d, \"temp\": %d", dist, batt, temp);
  
    USB.printf(res);
    USB.println();

  char bts[10]; //bytes to send
  
  int i;
    i = snprintf(bts, 12, "%02x%02x%02x", dist, batt, temp);
  //i += snprintf(bts + i, 4, "%02x", batt);
  //i += snprintf(bts + i, 4, "%02x", temp);


//    // Split 16 bit int in 2 8 bit int  
//    bts[0] = dist & 0xFF;
//    bts[1] = (dist >> 8);
//    bts[2] = batt & 0xFF;
//    bts[3] = (batt >> 8);
//    bts[4] = temp & 0xFF;
//    bts[5] = (temp >> 8);
//    bts[6] = '0';
  
  
  
  //////////////////////////////////////////////
  // 1. Switch on
  //////////////////////////////////////////////

  error = LoRaWAN.ON(socket);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("1. Switch ON OK"));     
  }
  else 
  {
    USB.print(F("1. Switch ON error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 2. Join network
  //////////////////////////////////////////////

  error = LoRaWAN.joinABP();

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("2. Join network OK"));   

    //////////////////////////////////////////////
    // 3. Send unconfirmed packet 
    //////////////////////////////////////////////

    error = LoRaWAN.sendUnconfirmed( PORT, bts);

    // Error messages:
    /*
     * '6' : Module hasn't joined a network
     * '5' : Sending error
     * '4' : Error with data length	  
     * '2' : Module didn't response
     * '1' : Module communication error   
     */
    // Check status
    if( error == 0 ) 
    {
      USB.println(F("3. Send Unconfirmed packet OK")); 
      if (LoRaWAN._dataReceived == true)
      { 
        USB.print(F("   There's data on port number "));
        USB.print(LoRaWAN._port,DEC);
        USB.print(F(".\r\n   Data: "));
        USB.println(LoRaWAN._data);
      }
    }
    else 
    {
      USB.print(F("3. Send Unconfirmed packet error = ")); 
      USB.println(error, DEC);
    }
  }
  else 
  {
    USB.print(F("2. Join network error = ")); 
    USB.println(error, DEC);
  }



  //////////////////////////////////////////////
  // 4. Switch off
  //////////////////////////////////////////////

  error = LoRaWAN.OFF(socket);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("4. Switch OFF OK"));     
  }
  else 
  {
    USB.print(F("4. Switch OFF error = ")); 
    USB.println(error, DEC);
  }

  USB.println("Going to sleep for 20s");
  USB.println();
  USB.OFF();

  PWR.setSensorPower(SENS_5V, SENS_OFF);
  PWR.hibernate("00:00:00:05", RTC_OFFSET, RTC_ALM1_MODE2);
}

