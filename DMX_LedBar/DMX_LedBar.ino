#include <Conceptinetics.h>

#define DMX_SLAVE_CHANNELS   2

DMX_Slave dmx_slave(DMX_SLAVE_CHANNELS);

#define pin 10

int previousMillis = 0;

void setup() {
  dmx_slave.enable();

  dmx_slave.setStartAddress(30);

  pinMode(pin, OUTPUT);
}

void loop() {
  if ((millis() - previousMillis) > (256 - dmx_slave.getChannelValue(1))) {
    analogWrite(pin, dmx_slave.getChannelValue(2));
    previousMillis = millis();
    while ((millis() - previousMillis) < (256 - dmx_slave.getChannelValue(1)));
    analogWrite(pin, 0);
    previousMillis = millis();
  }
}
