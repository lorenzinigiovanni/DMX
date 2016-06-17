import controlP5.*; //<>//
import processing.serial.*;

Serial arduino;
ControlP5 cp5;
Slider[] sliders = new Slider[25];
Numberbox[] numberboxes = new Numberbox[20];
Slider2D[] sliders2D = new Slider2D[2];
RadioButton r1;
RadioButton r2;
RadioButton r3;
CheckBox c1;
Chart[] charts = new Chart[3];

int red = 0;
int green = 0;
int blue = 0;
int white = 0;

int[][] pans = {
  {0, 25, 50, 75, 5100, 125, 150, 175, 200, 225, 255, 225, 200, 175, 150, 125, 100, 75, 50, 25}, 
  {0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255}, 
  {0, 0, 127, 127, 127, 127, 255, 255, 255, 127, 127, 127, 0, 0, 0, 255, 255, 255, 0, 0}, 
  //{0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0},
  //{127, 233, 242, 144, 30, 5, 91, 210, 252, 179, 57, 0, 58, 180, 252, 209, 90, 4, 31, 146}, 
  {127, 168, 204, 233, 250, 253, 243, 220, 188, 148, 106, 67, 34, 11, 0, 3, 19, 47, 84, 125}, 
};

int[][] tilts = {
  {0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255}, 
  {0, 25, 50, 75, 100, 125, 150, 175, 200, 225, 255, 225, 200, 175, 150, 125, 100, 75, 50, 25}, 
  {0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255}, 
  //{0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255},
  //{0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 140, 150, 160, 170, 180, 190, 200}, 
  {254, 247, 227, 196, 158, 116, 76, 41, 15, 1, 1, 14, 40, 74, 115, 156, 195, 226, 246, 253}, 
};

int[][] gobos = {
  {1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4}, 
  {1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4}, 
  {1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4}, 
  {1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4}, 
};

int j = 0;
int previousMillis = 0;

int[] canali = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
int canaleMacchinaFumo = 20;
int canaleStrobo1 = 25;
int canaleStrobo2 = 30;
int canaleBarraLed = 40;
int canaleScanner = 50;

//--------------------------------------------------------------------------------

void setup() {
  size(1010, 650);
  cp5 = new ControlP5(this);

  background(0);

  cp5.addTab("address");
  cp5.addTab("macro");
  cp5.addTab("setup");

  cp5.getTab("default")
    .activateEvent(true)
    .setLabel("Program")
    .setId(1)
    ;

  cp5.getTab("address")
    .setLabel("Setup Address")
    .activateEvent(true)
    .setId(2)
    ;

  cp5.getTab("macro")
    .setLabel("Setup Macro")
    .activateEvent(true)
    .setId(3)
    ;

  cp5.getTab("setup")
    .setLabel("Setup")
    .activateEvent(true)
    .setId(4)
    ;

  cp5.addColorWheel("color", 10, 40, 260);

  sliders[10] = cp5.addSlider("dimmer")
    .setPosition(280, 10)
    .setSize(50, 290)
    .setColorValue(color(0))
    .setRange(0, 255)
    ;

  sliders[11] = cp5.addSlider("strobe effect")
    .setPosition(340, 10)
    .setSize(50, 290)
    .setColorValue(color(0))
    .setRange(0, 255)
    ;

  for (int i = 0; i < 10; i++)
    sliders[i] = cp5.addSlider("slider " + char(65 + i))
      .setPosition(410 + 60*i, 10)
      .setSize(50, 290)
      .setColorValue(color(0))
      .setRange(0, 255)
      ;

  sliders[12] = cp5.addSlider("strobo")
    .setPosition(150, 320)
    .setSize(50, 310)
    .setColorValue(color(0))
    .setRange(0, 255)
    ;

  sliders[13] = cp5.addSlider("brightness")
    .setPosition(210, 320)
    .setSize(50, 310)
    .setColorValue(color(0))
    .setRange(0, 255)
    .setValue(255)
    ;

  sliders[14] = cp5.addSlider("strobo 2")
    .setPosition(280, 320)
    .setSize(50, 310)
    .setColorValue(color(0))
    .setRange(0, 255)
    ;

  sliders[15] = cp5.addSlider("brightness 2")
    .setPosition(340, 320)
    .setSize(50, 310)
    .setColorValue(color(0))
    .setRange(0, 255)
    .setValue(255)
    ;

  numberboxes[18] = cp5.addNumberbox("time")
    .setPosition(410, 520)
    .setSize(170, 30)
    .setRange(0, 5000)
    .setScrollSensitivity(1)
    .setValue(200)
    .setDirection(Controller.HORIZONTAL)
    ; 

  sliders[18] = cp5.addSlider("gobos")
    .setPosition(590, 320)
    .setSize(50, 310)
    .setColorValue(color(0))
    .setRange(0, 255)
    ;

  sliders2D[0] = cp5.addSlider2D("tilt-pan")
    .setPosition(410, 320)
    .setSize(170, 170)
    .setMinMax(0, 255, 255, 0)
    .setValue(127, 127)
    ;

  sliders2D[1] = cp5.addSlider2D("tilt-pan-macro")
    .setPosition(40, 50)
    .setSize(310, 310)
    .setMinMax(0, 255, 255, 0)
    .setValue(127, 127)
    ;

  sliders2D[1].moveTo("macro");

  numberboxes[15] = cp5.addNumberbox("numero-macro")
    .setPosition(370, 50)
    .setSize(65, 30)
    .setRange(0, 3)
    .setScrollSensitivity(1)
    .setDirection(Controller.HORIZONTAL)
    ; 

  numberboxes[15].moveTo("macro");

  numberboxes[16] = cp5.addNumberbox("j-macro")
    .setPosition(370, 100)
    .setSize(65, 30)
    .setRange(0, 19)
    .setScrollSensitivity(1)
    .setDirection(Controller.HORIZONTAL)
    ; 

  numberboxes[16].moveTo("macro");

  numberboxes[17] = cp5.addNumberbox("gobos-macro")
    .setPosition(370, 150)
    .setSize(65, 30)
    .setRange(0, 15)
    .setScrollSensitivity(1)
    .setDirection(Controller.HORIZONTAL)
    ; 

  numberboxes[17].moveTo("macro");

  cp5.addButton("updateMacro")
    .setPosition(370, 200)
    .setSize(65, 30)
    .setLabel("update macro")
    ;

  cp5.getController("updateMacro").moveTo("macro");

  charts[0] = cp5.addChart("pans-chart")
    .setPosition(450, 50)
    .setSize(400, 100)
    .setRange(0, 255)
    .setView(Chart.BAR_CENTERED)
    .setStrokeWeight(1.5)
    ;

  charts[1] = cp5.addChart("tilts-chart")
    .setPosition(450, 160)
    .setSize(400, 100)
    .setRange(0, 255)
    .setView(Chart.BAR_CENTERED)
    .setStrokeWeight(1.5)
    ;

  charts[2] = cp5.addChart("gobos-chart")
    .setPosition(450, 270)
    .setSize(400, 100)
    .setRange(0, 15)
    .setView(Chart.BAR_CENTERED)
    .setStrokeWeight(1.5)
    ;

  charts[0].addDataSet("pans");
  charts[0].setData("pans", new float[20]);

  charts[1].addDataSet("tilts");
  charts[1].setData("tilts", new float[20]);

  charts[2].addDataSet("gobos");
  charts[2].setData("gobos", new float[20]);

  for (int i = 0; i < 3; i++)
    charts[i].moveTo("macro");

  r1 = cp5.addRadioButton("r1")
    .setPosition(650, 320)
    .setSize(40, 40)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(3)
    .setSpacingColumn(80)
    .setSpacingRow(5)
    .addItem("open", 9)
    .addItem("gobo 1", 14)
    .addItem("gobo 2", 21)
    .addItem("gobo 3", 26)
    .addItem("gobo 4", 32)
    .addItem("gobo 5", 38)
    .addItem("gobo 6", 45)
    .addItem("gobo 7", 50)
    .addItem("gobo 8", 56)
    .addItem("gobo 1 - gobo 2", 62)
    .addItem("gobo 2 - gobo 3", 68)
    .addItem("gobo 3 - gobo 4", 76)
    .addItem("gobo 4 - gobo 5", 80)
    .addItem("gobo 5 - gobo 6", 86)
    .addItem("gobo 6 - gobo 7", 92)
    .addItem("gobo 7 - gobo 8", 98)
    .addItem("rainbow", 102)
    .addItem("strobe", 172)
    ;

  r2 = cp5.addRadioButton("r2")
    .setPosition(650, 590)
    .setSize(40, 40)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(3)
    .setSpacingColumn(80)
    .addItem("lamp", 150)
    ;

  r3 = cp5.addRadioButton("r3")
    .setPosition(770, 590)
    .setSize(40, 40)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(4)
    .setSpacingColumn(20)
    .addItem("1", 0)
    .addItem("2", 1)
    .addItem("3", 2)
    .addItem("4", 3)
    .deactivateAll()
    ;

  c1 = cp5.addCheckBox("c1")
    .setPosition(10, 320)
    .setSize(40, 40)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(1)
    .setSpacingRow(5)
    .addItem("Fog Machine", 150)
    .addItem("All On", 150)
    .addItem("All Off", 150)
    .addItem("Auto Gobos", 150)
    ;

  for (int i = 0; i < 10; i++)
    numberboxes[i] = cp5.addNumberbox("canale slider " + char(65 + i))
      .setPosition(10, 50 + 50*i)
      .setSize(150, 30)
      .setRange(1, 512)
      .setScrollSensitivity(1)
      .setDirection(Controller.HORIZONTAL)
      .setValue(canali[i])
      ;

  numberboxes[10] = cp5.addNumberbox("canale macchina fumo")
    .setPosition(250, 50)
    .setSize(150, 30)
    .setRange(1, 512)
    .setScrollSensitivity(1)
    .setDirection(Controller.HORIZONTAL)
    .setValue(canaleMacchinaFumo)
    ; 

  numberboxes[11] = cp5.addNumberbox("canale strobo 1")
    .setPosition(250, 100)
    .setSize(150, 30)
    .setRange(1, 512)
    .setScrollSensitivity(1)
    .setDirection(Controller.HORIZONTAL)
    .setValue(canaleStrobo1)
    ; 

  numberboxes[12] = cp5.addNumberbox("canale strobo 2")
    .setPosition(250, 150)
    .setSize(150, 30)
    .setRange(1, 512)
    .setScrollSensitivity(1)
    .setDirection(Controller.HORIZONTAL)
    .setValue(canaleStrobo2)
    ; 

  numberboxes[13] = cp5.addNumberbox("canale barra led")
    .setPosition(250, 200)
    .setSize(150, 30)
    .setRange(1, 512)
    .setScrollSensitivity(1)
    .setDirection(Controller.HORIZONTAL)
    .setValue(canaleBarraLed)
    ; 

  numberboxes[14] = cp5.addNumberbox("canale scanner")
    .setPosition(250, 250)
    .setSize(150, 30)
    .setRange(1, 512)
    .setScrollSensitivity(1)
    .setDirection(Controller.HORIZONTAL)
    .setValue(canaleScanner)
    ; 

  for (int i = 0; i < 15; i++)
    numberboxes[i].moveTo("address");

  cp5.addButton("updateAddress")
    .setPosition(10, 610)
    .setSize(65, 30)
    .setLabel("update address")
    ;

  cp5.getController("updateAddress").moveTo("address");

  cp5.addScrollableList("serialPort")
    .setPosition(10, 50)
    .setSize(200, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(Serial.list())
    .setType(ScrollableList.LIST)
    ;

  cp5.getController("serialPort").moveTo("setup");
}

//--------------------------------------------------------------------------------

void draw() {
  if (cp5.getTab("macro").isActive())
    for (int i = 0; i < 20; i++) {
      charts[0].push("pans", pans[int(numberboxes[15].getValue())][i]);
      charts[1].push("tilts", tilts[int(numberboxes[15].getValue())][i]);
      charts[2].push("gobos", gobos[int(numberboxes[15].getValue())][i]);
    }

  getColor(); 

  if (r1.getValue() == 102)
    sliders[18].setRange(102, 171); 
  else if (r1.getValue() == 172)
    sliders[18].setRange(172, 251); 
  else {
    sliders[18].setRange(0, 255); 
    sliders[18].setValue(r1.getValue());
  }

  if (r3.getValue() != -1) {
    sliders2D[0].setValue(pans[int(r3.getValue())][j], tilts[int(r3.getValue())][j]);
    if (c1.getArrayValue(3) > 0)
      r1.activate(gobos[int(r3.getValue())][j]); 
    if (millis() - previousMillis > numberboxes[18].getValue()) {
      previousMillis = millis(); 
      j += 1;
    }
    if (j > 19)
      j = 0;
  }

  if (c1.getArrayValue(2) > 0) {
    barraLed(canaleBarraLed, red, green, blue, 0, int(sliders[11].getValue())); 
    strobo(canaleStrobo1, 0, 0); 
    strobo(canaleStrobo2, 0, 0);
    scanner(canaleScanner, int(sliders2D[0].getArrayValue(0)), int(sliders2D[0].getArrayValue(1)), int(sliders[18].getValue()), 0); 
    scanner(canaleScanner+4, int(sliders2D[0].getArrayValue(0)), int(sliders[9].getValue()), int(sliders[18].getValue()), 0);
    for (int i = 0; i < 9; i++)
      slider(canali[i], 0);
  } else if (c1.getArrayValue(1) > 0) {
    barraLed(canaleBarraLed, red, green, blue, 255, int(sliders[11].getValue())); 
    strobo(canaleStrobo1, 255, 255); 
    strobo(canaleStrobo2, 255, 255);
    scanner(canaleScanner, int(sliders2D[0].getArrayValue(0)), int(sliders2D[0].getArrayValue(1)), int(sliders[18].getValue()), 255); 
    scanner(canaleScanner+4, int(sliders2D[0].getArrayValue(0)), int(sliders[9].getValue()), int(sliders[18].getValue()), 255);
    for (int i = 0; i < 9; i++)
      slider(canali[i], 255);
  } else {
    barraLed(canaleBarraLed, red, green, blue, int(sliders[10].getValue()), int(sliders[11].getValue())); 
    strobo(canaleStrobo1, int(sliders[12].getValue()), int(sliders[13].getValue())); 
    strobo(canaleStrobo2, int(sliders[14].getValue()), int(sliders[15].getValue())); 
    scanner(canaleScanner, int(sliders2D[0].getArrayValue(0)), int(sliders2D[0].getArrayValue(1)), int(sliders[18].getValue()), int(r2.getValue())); 
    scanner(canaleScanner+4, int(sliders2D[0].getArrayValue(0)), int(sliders[9].getValue()), int(sliders[18].getValue()), int(r2.getValue())); 
    for (int i = 0; i < 9; i++)
      slider(canali[i], int(sliders[i].getValue()));
  }

  macchinaFumo(canaleMacchinaFumo, int(c1.getArrayValue(0)) * 200); 

  background(0);
}

//--------------------------------------------------------------------------------

public void updateAddress() {
  for (int i = 0; i < 10; i++)
    canali[i] = int(numberboxes[i].getValue());

  canaleMacchinaFumo = int(numberboxes[10].getValue());
  canaleStrobo1 = int(numberboxes[11].getValue());
  canaleStrobo2 = int(numberboxes[12].getValue());
  canaleBarraLed = int(numberboxes[13].getValue());
  canaleScanner = int(numberboxes[14].getValue());
}

//--------------------------------------------------------------------------------

public void serialPort(int n) {
  try {
    arduino = new Serial(this, Serial.list()[n], 115200);
  }
  catch(Exception ex) {
    print(ex);
  }
}

//--------------------------------------------------------------------------------

public void updateMacro() {
  int numero = int(numberboxes[15].getValue());
  int j = int(numberboxes[16].getValue());
  gobos[numero][j] = int(numberboxes[17].getValue());
  pans[numero][j] = int(sliders2D[1].getArrayValue(0));
  tilts[numero][j] = int(sliders2D[1].getArrayValue(1));
}

//--------------------------------------------------------------------------------

void keyPressed() {
  switch(key) {
    case('a') : 
    sliders[12].setValue(255); 
    break; 
    case('s') : 
    sliders[12].setValue(0); 
    break; 
    case('q') : 
    sliders[11].setValue(255); 
    break; 
    case('w') : 
    sliders[11].setValue(0); 
    break; 
    case('z') : 
    sliders[14].setValue(255); 
    break; 
    case('x') : 
    sliders[14].setValue(0); 
    break; 
    case('c') : 
    r2.activate(0); 
    break; 
    case('v') : 
    r2.deactivateAll(); 
    break; 
    case('b') : 
    c1.activate(0); 
    break; 
    case('n') : 
    c1.deactivate(0); 
    break;
  }
}

//--------------------------------------------------------------------------------

void getColor() {
  color argb = cp5.get(ColorWheel.class, "color").getRGB(); 
  red = (argb >> 16) & 0xFF; 
  green = (argb >> 8) & 0xFF; 
  blue = argb & 0xFF; 
  white = (red + green + blue) / 3;
}

//--------------------------------------------------------------------------------

void strobo(int indirizzo, int strobo, int dimmer) {
  serial(indirizzo, strobo); 
  serial(indirizzo + 1, dimmer);
}

//--------------------------------------------------------------------------------

void slider(int indirizzo, int valore) {
  serial(indirizzo, valore);
}

//--------------------------------------------------------------------------------

void barraLed(int indirizzo, int red, int green, int blue, int dimmer, int strobo) {
  serial(indirizzo, red); 
  serial(indirizzo + 1, green); 
  serial(indirizzo + 2, blue); 
  serial(indirizzo + 3, dimmer); 
  serial(indirizzo + 4, strobo);
}

//--------------------------------------------------------------------------------

void scanner(int indirizzo, int pan, int tilt, int gobos, int controllo) {
  serial(indirizzo, pan); 
  serial(indirizzo + 1, tilt); 
  serial(indirizzo + 2, gobos); 
  serial(indirizzo + 3, controllo);
}

//--------------------------------------------------------------------------------

void macchinaFumo(int indirizzo, int fog) {
  serial(indirizzo, fog);
}

//--------------------------------------------------------------------------------

void serial(int canale, int valore) {
  valore = constrain(valore, 0, 255); 

  String data = "c" + str(canale) + 'v' + str(valore) + '\n'; 
  print(data); 

  try {
    arduino.write(data);
  }
  catch(Exception ex) {
  }
}