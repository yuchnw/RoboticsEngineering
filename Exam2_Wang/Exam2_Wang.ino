#include <LiquidCrystal.h>

#define LED1 64
#define LED2 65
#define LED3 66
#define LED4 67
#define LED5 68
#define LED6 69
#define PIN_RIGHT_BUTTON 2
#define PIN_LEFT_BUTTON 3
#define PIN_CONTRAST_ANALOG A8
#define PIN_HORZ_ANALOG 0
#define PIN_VERT_ANALOG 1
#define FLAG_INTERRUPT_0 0x01
#define FLAG_INTERRUPT_1 0x02
#define FLAG_INTERRUPT_2 0x04

int horz = analogRead(PIN_HORZ_ANALOG);
int vert = analogRead(PIN_VERT_ANALOG);
unsigned long horzTotal = 0;
unsigned long vertTotal = 0;
int horzCount = 0;
int vertCount = 0;
unsigned long before = 0;
unsigned long after = 0;
volatile int mainEventFlags = 0;
LiquidCrystal lcd(14, 15, 16, 17, 18, 19, 20);

void setup() {
  Serial.begin(9600);
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(LED4, OUTPUT);
  pinMode(LED5, OUTPUT);
  pinMode(LED6, OUTPUT);
  pinMode(PIN_LEFT_BUTTON, INPUT_PULLUP);
  pinMode(PIN_RIGHT_BUTTON, INPUT_PULLUP);
  lcd.begin(16, 2);
  lcd.clear();
  attachInterrupt(0, int0_isr, FALLING);
  attachInterrupt(1, int1_isr, FALLING);
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar <= '4' && inChar >= '0') {
      digitalWrite(LED1, HIGH);
      digitalWrite(LED2, HIGH);
      digitalWrite(LED3, HIGH);
      digitalWrite(LED4, LOW);
      digitalWrite(LED5, LOW);
      digitalWrite(LED6, LOW);
    } else if (inChar <= '9' && inChar >= '5') {
      digitalWrite(LED1, HIGH);
      digitalWrite(LED2, HIGH);
      digitalWrite(LED3, HIGH);
      digitalWrite(LED4, HIGH);
      digitalWrite(LED5, HIGH);
      digitalWrite(LED6, HIGH);
    } else if (inChar == '\n') {

    } else {
      digitalWrite(LED1, LOW);
      digitalWrite(LED2, LOW);
      digitalWrite(LED3, LOW);
      digitalWrite(LED4, LOW);
      digitalWrite(LED5, LOW);
      digitalWrite(LED6, LOW);
    }
  }
}

void loop() {
  horz = analogRead(PIN_HORZ_ANALOG);
  vert = analogRead(PIN_VERT_ANALOG);
  if (mainEventFlags & FLAG_INTERRUPT_0) {
    delay(20);
    mainEventFlags &= ~FLAG_INTERRUPT_0;
    if (!digitalRead(PIN_RIGHT_BUTTON)) {
      horzCount++;
      horzTotal+=horz;
      lcd.setCursor(0,0);
      lcd.print(horz);
      lcd.print("   ");
      lcd.setCursor(6,0);
      lcd.print(horzCount);
      lcd.print("   ");
      lcd.setCursor(10,0);
      lcd.print(horzTotal/horzCount);
      lcd.print("   ");
    }
  }
  if (mainEventFlags & FLAG_INTERRUPT_1) {
    mainEventFlags &= ~FLAG_INTERRUPT_1;
    delay(20);
    if (!digitalRead(PIN_LEFT_BUTTON)) {
      vertCount++;
      vertTotal+=vert;
      lcd.setCursor(0,1);
      lcd.print(vert);
      lcd.print("   ");
      lcd.setCursor(6,1);
      lcd.print(vertCount);
      lcd.print("   ");
      lcd.setCursor(10,1);
      lcd.print(vertTotal/vertCount);
      lcd.print("   ");
    }
  }
  after = millis();
  if(after - before == 3000){ 
    Serial.println(after/3000);
    before = after;
  }
}

void int0_isr() {
  mainEventFlags |= FLAG_INTERRUPT_0;
}

void int1_isr() {
  mainEventFlags |= FLAG_INTERRUPT_1;
}
