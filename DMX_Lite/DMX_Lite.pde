import controlP5.*; //libreria interfaccia grafica //<>//
import processing.serial.*; //libreria per la comunicazione seriale

Serial arduino; //oggetto per la comunicazione seriale
ControlP5 cp5; //oggetto della libreria dell'interfaccia grafica
Slider m; //slider 1
Slider n; //slider 2

int indirizzo = 100; //canale a cui è impostato il PAR

int red = 0; //intensità rosso
int green = 0; //intensità verde
int blue = 0; //intensità blu
int white = 0; //intensità bianco

//--------------------------------------------------------------------------------

void setup() {
  size(580, 420); //grandezza finestra
  cp5 = new ControlP5(this); //inizializzazione oggetto per interfaccia grafica

  background(0); //colore sfondo

  cp5.addColorWheel("color", 10, 10, 400) //ruota per la scelta dei colori
    .setColorLabel(color(0)) //nascondo nome componente
    ;

  m = cp5.addSlider("m") //slider per la scelta della luminosità
    .setPosition(450, 10) //setto la posizione
    .setSize(50, 400) //setto la grandezza
    .setColorLabel(color(0)) //nascondo nome componente
    .setColorValue(color(0)) //nascondo valore componente
    .setRange(0, 255) //range tra 0 e 255
    ;

  n = cp5.addSlider("n") //slider per la scelta della frequenza di lampeggio
    .setPosition(520, 10) //setto la posizione
    .setSize(50, 400) //setto la grandezza
    .setColorLabel(color(0)) //nascondo nome componente
    .setColorValue(color(0)) //nascondo valore componente
    .setRange(0, 255) //range tra 0 e 255
    ;

  try {
    String portName = Serial.list()[0];
    arduino = new Serial(this, portName, 115200);
  }
  catch(Exception ex) {
    println(ex);
  }
}

//--------------------------------------------------------------------------------

void draw() {
  getColor(); //leggo i colori
  par(indirizzo, int(m.getValue()), red, green, blue, white, int(n.getValue()), 0); //comando il par in base ai parametri selezioneti
}

//--------------------------------------------------------------------------------

void getColor() {
  color argb = cp5.get(ColorWheel.class, "color").getRGB(); //leggo dalla ruota dei colori il colore selezionato
  red = (argb >> 16) & 0xFF; //estraggo il rosso
  green = (argb >> 8) & 0xFF; //estraggo il verde
  blue = argb & 0xFF; //estraggo il blue
  white = (red + green + blue) / 3; //calcolo il bianco
}

//--------------------------------------------------------------------------------

void par(int indirizzo, int dimmer, int red, int green, int blue, int white, int strobo, int macro) {
  serial(indirizzo, dimmer); //al primo canale invio la potenza del par
  serial(indirizzo + 1, red); //al secondo canale invio l'intensità del rosso
  serial(indirizzo + 2, green); //al terzo canale invio l'intensità del verde
  serial(indirizzo + 3, blue); //al quarto canale invio l'intensità del blu
  serial(indirizzo + 4, white); //al quinto canale invio l'intensità del bianco
  serial(indirizzo + 5, strobo); //al sesto canale invio la frequenza di lampeggio del par
  serial(indirizzo + 6, macro); //al settimo canale invio la scelta delle macro
}

//--------------------------------------------------------------------------------

void serial(int canale, int valore) {
  canale = constrain(canale, 1, 511); //il canale da inviare deve essere compreso tra 1 e 511
  valore = constrain(valore, 0, 255); //il valore da inviare deve essere compreso tra 0 e 255

  String data = "c" + str(canale) + 'v' + str(valore) + '\n'; //compongo una string, ad esempio: c100v255\n imposta il canale 100 a 255
  println(data);

  try {
    arduino.write(data); //invio i dati ad arduino
  }
  catch(Exception ex) {
  }
}