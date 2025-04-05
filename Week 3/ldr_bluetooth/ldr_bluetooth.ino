#include "BluetoothSerial.h"

#define LDR_PIN 32  // Use any ADC-capable pin (GPIO 32–39)

BluetoothSerial SerialBT;

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32_BT");  // Set Bluetooth device name
  Serial.println("Bluetooth Started! Connect to 'ESP32_BT'");

  analogReadResolution(12);    // Set ADC resolution to 12 bits (0–4095)
}

void loop() {
  int ldrValue = analogRead(LDR_PIN);  // Read LDR sensor value

  // Print and send the value via Bluetooth
  Serial.print("LDR Value: ");
  Serial.println(ldrValue);

  SerialBT.println(ldrValue);  // Send to connected Bluetooth device

  delay(500);  // Delay for readability
}
