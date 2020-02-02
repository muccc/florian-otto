
void setup() {
    pinMode(PIN7, INPUT);
    pinMode(PIN3, OUTPUT);
    pinMode(LED_BUILTIN, OUTPUT);
    
}

void loop() {

    if (digitalRead(PIN7)) {
        digitalWrite(LED_BUILTIN, 1);
        digitalWrite(PIN3, 1);
    } else {
        digitalWrite(LED_BUILTIN, 0);
        digitalWrite(PIN3, 0);
    }

}
