
bool change0 = true; // did the note status changed?
bool on0 = false; // what is the note status?

bool change1 = true; // did the note status changed?
bool on1 = false; // what is the note status?

bool change2 = true; // did the note status changed?
bool on2 = false; // what is the note status?

void setup() {
  Serial.begin(9600); // initializing serial port

  // Digital sensors - configure as input
  pinMode(0, INPUT); // configuring digital pin 0 as an input
  pinMode(1, INPUT); // configuring digital pin 1 as an input
  pinMode(2, INPUT); // configuring digital pin 2 as an input

}

void loop() {
  int midiChannel = 0;
  
  // accelerometer data
  int sensorValueA0 = analogRead(A9); //originally 0// retrieving sensor value on Analog pin 0
  int sensorValueA1 = analogRead(A8); //originally 1
  int sensorValueA2 = analogRead(A7); //originally 2
  
  // FSR data
  int sensorValueA6 = analogRead(A0); //originally 6
  int sensorValueA5 = analogRead(A1); //originally 5
  int sensorValueA4 = analogRead(A2); //originally 4


  int midiCCA0 = 0; //control number- if we had 3 sensors, we could have midiCC = 0, midiCC2 = 1, etc.
  int midiCCA1 = 1;
  int midiCCA2 = 2;
  //int midiCCA7 = 6;
  int midiCCA6 = 5;
  int midiCCA5 = 4;
  int midiCCA4 = 3;
 

  int midiValueA0 = sensorValueA0 * 127 / 1024; // value between 0-127
  int midiValueA1 = sensorValueA1 * 127 / 1024;
  int midiValueA2 = sensorValueA2 * 127 / 1024; // value between 0-127

  int midiValueA6 = sensorValueA6 * 127 / 1024; // value between 0-127
  int midiValueA5 = sensorValueA5 * 127 / 1024; // value between 0-127
  int midiValueA4 = sensorValueA4 * 127 / 1024; // value between 0-127


  // Debug
  /**/
    //Serial.print(midiValueA7);
   // Serial.print(", ");
    Serial.print(midiValueA6);
    Serial.print(", ");
    Serial.print(midiValueA5);
    Serial.print(", ");
    Serial.print(midiValueA4);
    Serial.print(", ");
    Serial.print(midiValueA0);
    Serial.print(", ");
    Serial.print(midiValueA1);
    Serial.print(", ");
    Serial.println(midiValueA2); // prints high as default



  usbMIDI.sendControlChange(midiCCA0, midiValueA0, midiChannel); // sending on CC 0
  delay(10);
  usbMIDI.sendControlChange(midiCCA1, midiValueA1, midiChannel); // sending on CC 0
  delay(10);
  usbMIDI.sendControlChange(midiCCA2, midiValueA2, midiChannel); // sending on CC 0
  delay(10);
  usbMIDI.sendControlChange(midiCCA6, midiValueA6, midiChannel); // sending on CC 0
  delay(10);
  usbMIDI.sendControlChange(midiCCA5, midiValueA5, midiChannel); // sending on CC 0
  delay(10);
  usbMIDI.sendControlChange(midiCCA4, midiValueA4, midiChannel); // sending on CC 0
  delay(10);

  // digital button reading
  
  if (digitalRead(0)) { // button is pressed
    if(!on0) change0 = true; // did the status of the button changed
    on0 = true;
  } 
  else {
    if(on0) change0 = true; // did the status of the button change?
    on0 = false;
  }

  if(change0){ // if the status of the button changed
    if(on0){ // if the button is pressed
      usbMIDI.sendControlChange(7,127,0); // set "gate" to 1
     Serial.println("digital 0 is on");
    }
    else{
      usbMIDI.sendControlChange(7,0,0); // set "gate" to 0
    }
    change0 = false; // status changed
  }

  if (digitalRead(1)) { // button is pressed
    if(!on1) change1 = true; // did the status of the button changed
    on1 = true;
  } 
  else {
    if(on1) change1 = true; // did the status of the button change?
    on1 = false;
  }

  if(change1){ // if the status of the button changed
    if(on1){ // if the button is pressed
     usbMIDI.sendControlChange(8,127,0); // set "gate" to 1
     Serial.println("digital 1 is on");
    }
    else{
      usbMIDI.sendControlChange(8,0,0); // set "gate" to 0
    }
    change1 = false; // status changed
  }

  
  if (digitalRead(2)) { // button is pressed
    if(!on2) change2 = true; // did the status of the button changed
    on2 = true;
  } 
  else {
    if(on2) change2 = true; // did the status of the button change?
    on2 = false;
  }

  if(change2){ // if the status of the button changed
    if(on2){ // if the button is pressed
      usbMIDI.sendControlChange(9,127,0); // set "gate" to 1
     Serial.println("digital 2 is on");
    }
    else{
      usbMIDI.sendControlChange(9,0,0); // set "gate" to 0
    }
    change2 = false; // status changed
  }

}
