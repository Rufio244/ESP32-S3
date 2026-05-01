#include <Arduino.h>
#include "DolaAudio.h"
#include "DictionaryManager.h"

// สถานะการทำงาน
enum DeviceState { PASSIVE_LEARNING, ACTIVE_QUERY, TRANSLATION };
DeviceState currentState = PASSIVE_LEARNING;

void setup() {
    Serial.begin(115200);
    DolaAudio::init();        // เริ่มต้นระบบเสียง I2S
    Dictionary::init();       // ตรวจสอบฐานข้อมูลใน SD Card
    
    // โหลดจุดเรียนล่าสุด
    int lastWordIndex = Dictionary::getLastProgress();
    Serial.printf("Welcome back! Resuming from word index: %d\n", lastWordIndex);
}

void loop() {
    // 1. ตรวจสอบคำสั่งเสียง (Wake Word)
    if (DolaAudio::listenForWakeWord("Hey Dola")) {
        currentState = ACTIVE_QUERY;
        handleQuery();
    }

    // 2. ถ้าอยู่ในโหมดสอนต่อเนื่อง
    if (currentState == PASSIVE_LEARNING) {
        Dictionary::Entry word = Dictionary::getNextWord();
        DolaAudio::speak(word.english);
        delay(500);
        DolaAudio::speak(word.thai_meaning);
        DolaAudio::speak("Example: " + word.example_sentence);
        
        // บันทึกความคืบหน้าทุกๆ 1 คำ
        Dictionary::saveProgress();
        delay(3000); // เว้นจังหวะให้ผู้เรียนพูดตาม
    }
}

void handleQuery() {
    DolaAudio::speak("I'm listening. What do you want to know?");
    String userVoice = DolaAudio::recordAndSTT(); // แปลเสียงเป็นข้อความ
    
    if (userVoice.contains("แปลว่าอะไร")) {
        // Logic การแปลภาษา
    } else if (userVoice.contains("เปลี่ยนโหมด")) {
        currentState = PASSIVE_LEARNING;
    }
}
