#include "BluetoothSerial.h"
#include "Stepper.h"


#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` and enable it
#endif

BluetoothSerial SerialBT;  
const int stepsPerRevolution = 200;  
Stepper myStepper(stepsPerRevolution, 12, 14);  // pins 12 and 14 esp32!

int baseSpeed = 50;  
float multiplier = 5;  // Multiplier to adjust speed based on received data
int currentSpeed = baseSpeed;  // Variable to keep track of the current motor speed

void setup() {
  Serial.begin(115200);  /
  SerialBT.begin("Smartrainbow7.0");  
  Serial.println("The device started, now you can pair it with Bluetooth!");
  myStepper.setSpeed(baseSpeed);  

void adjustSpeedGradually(int targetSpeed) {
    int stepSize = (abs(currentSpeed - targetSpeed) > 100) ? 50 : 10; 
    while (currentSpeed != targetSpeed) {
        if (currentSpeed < targetSpeed) {
            currentSpeed += stepSize;
        } else {
            currentSpeed -= stepSize;
        }
        currentSpeed = max(1, min(currentSpeed, targetSpeed));  
        myStepper.setSpeed(currentSpeed);  
        Serial.print("Adjusting speed to ");
        Serial.print(currentSpeed);
        Serial.println(" RPM.");
        delay(100);
    }
}

void loop() {
  if (SerialBT.available()) {  
    String message = SerialBT.readStringUntil('\n');  
    message.trim();  
    Serial.print("Received message: ");
    Serial.println(message);

    int colonPosition = message.indexOf(':');  
    if (colonPosition != -1) {
        String tempDifferenceStr = message.substring(colonPosition + 2);
        tempDifferenceStr.trim();
        if (!tempDifferenceStr.toFloat()) {  
            Serial.println("Invalid data received. Please send a valid number.");
            return;
        }
        float tempDifference = tempDifferenceStr.toFloat(); 
        if (tempDifference <= 0) {
            int minSpeed = 100;  
            myStepper.setSpeed(minSpeed); 
            currentSpeed = minSpeed;  
            Serial.println("Climate cooler than historical data. Motor set to a faster minimum speed.");
        } else {
            int newSpeed = baseSpeed + (int)(multiplier * tempDifference * 50);  
            newSpeed = min(newSpeed, 2000);  
            Serial.print("Climate warmer than historical data. Setting motor speed to ");
            Serial.print(newSpeed);
            Serial.println(" RPM.");
            adjustSpeedGradually(newSpeed); 
        }
    }
  }

  
  static unsigned long lastStepTime = 0;
  unsigned long currentMillis = millis();
  if (currentSpeed > 0 && (currentMillis - lastStepTime >= 10)) {
    lastStepTime = currentMillis;
    myStepper.step(stepsPerRevolution / 100);  
}
