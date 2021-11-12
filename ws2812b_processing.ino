/* Based on a David Madison  sketch
By Tony SAO / tonehrk (github)
 */


#include <FastLED.h>


// ---- Settings --------------------------
#define DATAPIN 5
#define NUMLEDS 176 // for 88 key piano
#define BRIGHTNESS 255  // max default... can be "controlled" by ArduinoWS2812B processing sketch
#define BAUDRATE 115200 // processing synchro
#define NOTESTART 20 // roland FP-2
#define NOTERANGE 88 
// ----------------------------------------


static const uint8_t
  Pin = DATAPIN,
  NumLEDs = NUMLEDS,
  minNote = NOTESTART,
  maxNote = minNote + NOTERANGE,
  maxBright = BRIGHTNESS;
 
// LED Color Values
uint8_t
  rVal = 255,
  gVal = 255,
  bVal = 255;

CRGB leds[NumLEDs];

#include <MIDI.h>
struct CustomBaud : public midi::DefaultSettings{
    static const long BaudRate = BAUDRATE;
};
MIDI_CREATE_CUSTOM_INSTANCE(HardwareSerial, Serial, MIDI, CustomBaud);
 
void setup(){
  
  FastLED.addLeds<WS2812B, Pin, GRB>(leds, NumLEDs);
  FastLED.setBrightness(maxBright);
  FastLED.show();    
  
  MIDI.setHandleNoteOn(handleNoteOn);
  MIDI.setHandleNoteOff(handleNoteOff);
  MIDI.begin(0);
}
 
void loop(){
  
  MIDI.read(); 
  
}
 
void handleNoteOn(byte channel, byte note, byte velocity){
     
   if (note==109){  //Note signal to change color
     for(int i=0; i<3; i++){
        while(Serial.available()==0){};
        int inByte = Serial.read();     
           switch (i) {
                    case 0:
                        rVal = inByte;                  
                        break;
                    case 1:
                        gVal = inByte;
                        break;
                    case 2:
                        bVal = inByte;
                   }

     }
     return;
   }
  
  if(note < minNote || note > maxNote){
    return;
  }

  ledON(note - minNote);
  show();
}
 
void handleNoteOff(byte channel, byte note, byte velocity){

  if(note < minNote || note > maxNote){
    return;
  }

  ledOFF(note - minNote);
  show();
}
 

void ledON(uint8_t index){

  setLED(index, rVal, gVal, bVal);

}
 
void ledOFF(uint8_t index){

  setLED(index, 0, 0, 0);
}
 
void setLED(uint8_t index, uint8_t r, uint8_t g, uint8_t b){
  
   index=NumLEDs-((index*2));  // only skip leds "index*=2"  ... NUMLEDS-((index*2)) to invert ledstrip (i have connected my ledstrip from right to left lol)
   if (index <= 71){index+=1;}  // im skipped 1 blank led to fil correct led+pianoboard
   leds[index] = CRGB (r,g,b);
   

}

void show(){
  
   FastLED.show();

}
