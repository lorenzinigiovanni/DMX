#include <Conceptinetics.h>

#define DMX_SLAVE_CHANNELS   1

DMX_Slave dmx_slave(DMX_SLAVE_CHANNELS);

#define pin 10

void setup() {
  dmx_slave.enable();

  dmx_slave.setStartAddress(20);

  pinMode(pin, OUTPUT);
}

void loop() {
  if (dmx_slave.getChannelValue(1) > 127)
    digitalWrite(pin, LOW);
  else
    digitalWrite(pin, HIGH);
}
