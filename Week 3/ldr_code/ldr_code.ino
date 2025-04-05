#define LDR_PIN 32  // Use any ADC-capable pin, e.g., GPIO 32-39 (VP)

void setup() {
  Serial.begin(115200);        
  analogReadResolution(12);    // Set ADC resolution to 12 bits (0-4095)
}

void loop() {
  int ldrValue = analogRead(LDR_PIN);  // Read analog value from LDR
  Serial.println(ldrValue);            // Print the raw value
  delay(500);                          // Delay for readability
}