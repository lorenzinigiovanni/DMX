#include <DmxSimple.h> //libreria per la comunicazione con dispositivi DMX

void setup() {
  Serial.begin(115200); //inizializzazione seriale a 115200 baud
}

void loop() {
}

void serialEvent() {
  String received = Serial.readStringUntil(10); //leggo la stringa da processing fino ad \n
  DmxSimple.write(received.substring(received.indexOf('c') + 1, received.indexOf('v')).toInt(), received.substring(received.indexOf('v') + 1).toInt()); //invio i dati su bus DMX
}
