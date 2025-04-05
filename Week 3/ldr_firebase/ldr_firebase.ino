#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// WiFi credentials
#define WIFI_SSID ""         // Fill your WiFi SSID
#define WIFI_PASSWORD ""     // Fill your WiFi password
#define FIREBASE_PROJECT_ID ""  // Fill your Firebase project ID

// Firebase Project API Key and Firestore URL
#define API_KEY ""  // Fill your Firebase Web API Key
#define FIREBASE_URL "https://firestore.googleapis.com/v1/projects/" FIREBASE_PROJECT_ID "/databases/(default)/documents/esp32/doc1"

// LDR pin
#define LDR_PIN 32  // Use ADC-capable GPIO pin (e.g., 32-39)

void setup() {
  Serial.begin(115200);
  delay(1000);

  // Set ADC resolution
  analogReadResolution(12);  // 12-bit resolution (0–4095)

  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(1000);
  }
  Serial.println("\nConnected to WiFi!");
}

void loop() {
  int ldrValue = analogRead(LDR_PIN);  // Read from LDR
  Serial.print("LDR Value: ");
  Serial.println(ldrValue);

  // Send to Firebase
  pushData(ldrValue);

  delay(100);  // Wait for 100 ms
}

void pushData(int value) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String url = String(FIREBASE_URL) + "?key=" + String(API_KEY);
    http.begin(url);
    http.addHeader("Content-Type", "application/json");

    StaticJsonDocument<200> jsonDoc;
    jsonDoc["fields"]["ldr"]["integerValue"] = value;

    String requestBody;
    serializeJson(jsonDoc, requestBody);

    int httpResponseCode = http.PATCH(requestBody);  // PATCH to update existing document

    if (httpResponseCode > 0) {
      Serial.println("Data sent to Firebase!");
      Serial.println("Response: " + http.getString());
    } else {
      Serial.print("Error sending data: ");
      Serial.println(http.errorToString(httpResponseCode));
    }

    http.end();
  } else {
    Serial.println("WiFi not connected!");
  }
}
