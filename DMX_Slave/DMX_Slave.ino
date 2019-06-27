#include <Conceptinetics.h>

DMX_Slave dmx_slave(9, 2);

const int ledPin = 13;

void setup() {
  dmx_slave.enable();

  dmx_slave.setStartAddress(20);

  pinMode(ledPin, OUTPUT);
}

void loop() {
  if (dmx_slave.getChannelValue(1) > 127)
    digitalWrite(ledPin, HIGH);
  else
    digitalWrite(ledPin, LOW);
}
