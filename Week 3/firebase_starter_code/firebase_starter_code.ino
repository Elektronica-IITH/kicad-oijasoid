#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// WiFi credentials
#define WIFI_SSID ""
#define WIFI_PASSWORD ""
#define FIREBASE_PROJECT_ID ""

// Firebase Project API Key and Firestore URL
#define API_KEY ""
#define FIREBASE_URL "https://firestore.googleapis.com/v1/projects/" FIREBASE_PROJECT_ID "/databases/(default)/documents/esp32/doc1"

void setup() {
    Serial.begin(115200);
    delay(1000);

    // Connect to WiFi
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to WiFi");
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(1000);
    }
    Serial.println("\nConnected to WiFi!");

    Serial.println("Enter any message to send to Firestore:");
}

void loop() {
    if (Serial.available()) {
        String input = Serial.readStringUntil('\n');
        input.trim();  // Remove extra whitespace

        if (input.length() > 0) {
            Serial.println("Sending message: " + input);
            pushData(input);
        }
    }
}

void pushData(String message) {
    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient http;
        String url = String(FIREBASE_URL) + "?key=" + String(API_KEY);
        http.begin(url);
        http.addHeader("Content-Type", "application/json");

        StaticJsonDocument<200> jsonDoc;
        jsonDoc["fields"]["message"]["stringValue"] = message;

        String requestBody;
        serializeJson(jsonDoc, requestBody);

        int httpResponseCode = http.PATCH(requestBody);

        if (httpResponseCode > 0) {
            Serial.println("Message sent!");
            Serial.println("Response: " + http.getString());
        } else {
            Serial.println("Failed to send. Error: " + http.errorToString(httpResponseCode));
        }

        http.end();
    } else {
        Serial.println("WiFi not connected!");
    }
}
