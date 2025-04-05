#include "BluetoothSerial.h"

BluetoothSerial SerialBT;

void setup() {
  Serial.begin(115200);            
  SerialBT.begin("ESP32_BT");      
  Serial.println("Bluetooth Started! Connect to 'ESP32_BT'");
}

void loop() {
  if (Serial.available()) {
    String input = Serial.readStringUntil('\n');
    
    SerialBT.println(input);
    
    Serial.print("Sent via Bluetooth: ");
    Serial.println(input);
  }

  if (SerialBT.available()) {
    String btInput = SerialBT.readStringUntil('\n');
    Serial.print("Received from BT: ");
    Serial.println(btInput);
  }
}