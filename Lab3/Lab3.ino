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
#define PIN_SELECT_BUTTON 21
#define PIN_HORZ_ANALOG 0
#define PIN_VERT_ANALOG 1
#define FLAG_INTERRUPT_0 0x01
#define FLAG_INTERRUPT_1 0x02
#define FLAG_INTERRUPT_2 0x04

int horz = analogRead(PIN_HORZ_ANALOG);
int vert = analogRead(PIN_VERT_ANALOG);
volatile int mainEventFlags = 0;
int joints[6] = {90, 90, 90, 90, 90, 90};
int current = 0;
LiquidCrystal lcd(14, 15, 16, 17, 18, 19, 20);

void setup() {
  delay(1000);
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(LED4, OUTPUT);
  pinMode(LED5, OUTPUT);
  pinMode(LED6, OUTPUT);
  pinMode(PIN_LEFT_BUTTON, INPUT_PULLUP);
  pinMode(PIN_RIGHT_BUTTON, INPUT_PULLUP);
  lcd.begin(16, 2);
  Serial.begin(9600);
  attachInterrupt(0, int0_isr, FALLING);
  attachInterrupt(1, int1_isr, FALLING);
  attachInterrupt(2, int2_isr, FALLING);
}

void loop() {
  horz = analogRead(PIN_HORZ_ANALOG);
  vert = analogRead(PIN_VERT_ANALOG);
  lcd.setCursor(0, 0);
  lcd.print(joints[0]);
  lcd.print("  ");
  lcd.setCursor(4, 0);
  lcd.print(joints[1]);
  lcd.print("  ");
  lcd.setCursor(8, 0);
  lcd.print(joints[2]);
  lcd.print("  ");
  lcd.setCursor(0, 1);
  lcd.print(joints[3]);
  lcd.print("  ");
  lcd.setCursor(4, 1);
  lcd.print(joints[4]);
  lcd.print("  ");
  lcd.setCursor(8, 1);
  lcd.print(joints[5]);
  lcd.print("  ");
  if (mainEventFlags & FLAG_INTERRUPT_0) {
    delay(20);
    mainEventFlags &= ~FLAG_INTERRUPT_0;
    if (!digitalRead(PIN_RIGHT_BUTTON)) {
      if (current == 5) {
        current = 0;
      } else {
        current++;
      }
    }
  }
  if (mainEventFlags & FLAG_INTERRUPT_1) {
    delay(20);
    mainEventFlags &= ~FLAG_INTERRUPT_1;
    if (!digitalRead(PIN_LEFT_BUTTON)) {
      if (current == 0) {
        current = 5;
      } else {
        current --;
      }
    }
  }
  if (mainEventFlags & FLAG_INTERRUPT_2) {
    delay(20);
    mainEventFlags &= ~FLAG_INTERRUPT_2;
    if (!digitalRead(PIN_SELECT_BUTTON)) {
      joints[current] = 90;
    }
  }

  LEDx(current);
  if (vert > 900) {
    if (joints[current] + 4 > 180) {
      joints[current] = 180;
    } else {
      joints[current] += 4;
    }
  } else if (vert < 100) {
    if (joints[current] - 4 < 0) {
      joints[current] = 0;
    } else {
      joints[current] -= 4;
    }
  }
  if (horz > 900) {
    if (joints[current] < 180) {
      joints[current] += 1;
    }
  } else if (horz < 100) {
    if (joints[current] > 0) {
      joints[current] -= 1;
    }
  }
  delay(40);
}

void LEDx(int index) {
  if (index == 0) digitalWrite(LED1, HIGH); else digitalWrite(LED1, LOW);
  if (index == 1) digitalWrite(LED2, HIGH); else digitalWrite(LED2, LOW);
  if (index == 2) digitalWrite(LED3, HIGH); else digitalWrite(LED3, LOW);
  if (index == 3) digitalWrite(LED4, HIGH); else digitalWrite(LED4, LOW);
  if (index == 4) digitalWrite(LED5, HIGH); else digitalWrite(LED5, LOW);
  if (index == 5) digitalWrite(LED6, HIGH); else digitalWrite(LED6, LOW);
}

void int0_isr() {
  mainEventFlags |= FLAG_INTERRUPT_0;
}
void int1_isr() {
  mainEventFlags |= FLAG_INTERRUPT_1;
}
void int2_isr() {
  mainEventFlags |= FLAG_INTERRUPT_2;
}


