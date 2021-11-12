/*Author: Tony San Piano / Tony SAO / tonehrk (github)
  
  WS2812B/Arduino
*/

import themidibus.*; //Import the library
import processing.serial.*;
import static javax.swing.JOptionPane.*;
import controlP5.*;

ControlP5 controlP5;

PFont f;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int ascii=0;
int channel = 0;
int note = 0;
int velocity = 0;
int state = 0; // Note on/off

// note color
int rVal = 0;
int gVal = 0;
int bVal = 0;
int brVal = 0;

// background color
int bgrVal = 0;
int bggVal = 0;
int bgbVal = 0;
int bgbrVal = 0; // brightness   - 10 recomended (255)

Button sendButton;
Button sendbgButton;

final boolean debug = true;
MidiBus myBus; // The MidiBus
public void settings(){ size(340,360);}
void setup() 
{

  f = createFont("Verdana", 10, true);
  myBus = new MidiBus(this, 0, 0);

  myPort = new Serial(this, Serial.list()[32], 115200); // usually Linux "32" - Win is "1" 
  

     // myPort.bufferUntil('\n'); // buffer until CR/LF appears, but not required..
   /*} else {
      showMessageDialog(frame, "Device is not connected to the PC");
      //exit();
    }
  }
  catch (Exception e)
  { //Print the type of error
    showMessageDialog(frame, "COM port is not available (may\nbe in use by another program)");
    println("Error:", e);
    // exit();
  }*/
  
  controlP5 = new ControlP5(this);
  ControlFont font = new ControlFont(f);
    
  // notecolors sliders 
  controlP5.setFont(font);
  controlP5.addSlider("Red").setMin(0).setMax(255).setValue(255).setPosition(20,60).setSize(200,20).setSliderMode(0).setId(1).setColorForeground(color(150,0,0)).setColorBackground(color(50,0,0)).setColorActive(color(255,0,0));
  controlP5.addSlider("Green").setMin(0).setMax(255).setValue(255).setPosition(20,90).setSize(200,20).setSliderMode(0).setId(2).setColorForeground(color(0,150,0)).setColorBackground(color(0,50,0)).setColorActive(color(0,255,0));
  controlP5.addSlider("Blue").setMin(0).setMax(255).setValue(255).setPosition(20,120).setSize(200,20).setSliderMode(0).setId(3).setColorForeground(color(0,0,150)).setColorBackground(color(0,0,50)).setColorActive(color(0,0,255));
  controlP5.addSlider("Bn").setMin(0).setMax(100).setValue(25).setPosition(280,60).setSize(20,80).setColorForeground(color(150,150,150)).setColorBackground(color(50,50,50)).setColorActive(color(255,255,255));
  
  sendButton = controlP5.addButton("Send").setPosition(180, 150).setSize(40,20); 
   
  // backgroundcolors sliders
  
  controlP5.setFont(font);
  controlP5.addSlider("BRed").setMin(0).setMax(255).setValue(0).setPosition(20,220).setSize(200,20).setSliderMode(0).setId(1).setColorForeground(color(150,0,0)).setColorBackground(color(50,0,0)).setColorActive(color(255,0,0));
  controlP5.addSlider("BGreen").setMin(0).setMax(255).setValue(0).setPosition(20,250).setSize(200,20).setSliderMode(0).setId(2).setColorForeground(color(0,150,0)).setColorBackground(color(0,50,0)).setColorActive(color(0,255,0));
  controlP5.addSlider("BBlue").setMin(0).setMax(255).setValue(0).setPosition(20,280).setSize(200,20).setSliderMode(0).setId(3).setColorForeground(color(0,0,150)).setColorBackground(color(0,0,50)).setColorActive(color(0,0,255));
  controlP5.addSlider("BBn").setMin(0).setMax(100).setValue(5).setPosition(280,220).setSize(20,80).setColorForeground(color(150,150,150)).setColorBackground(color(50,50,50)).setColorActive(color(255,255,255));
  
  sendbgButton = controlP5.addButton("BSend").setPosition(180, 320).setSize(40,20); 
  
  
 
  
}

void draw()
{

  background(100);
  fill(255);                         
  textFont(f, 10);
  text("Conectado " + ascii, 20, 20);  
  fill(255);
  textFont(f, 10);
  text("Note color", 20, 50);
  text("Background color",20,210 );
  
}

void noteOn(int channel, int note, int velocity) {

  delay(10);  // This seems to resolve Ws2812b
  state = 144;
  myPort.write(state);    // send midi signal  note on
  myPort.write(note);
  myPort.write(velocity);
  
  ascii = note;

}

void noteOff(int channel, int note, int velocity) {

  delay(10);  // :;
  state = 128;
  myPort.write(state);  // send  midi signal note off
  myPort.write(note);
  myPort.write(velocity);

  ascii = note;
  
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  myBus.sendControllerChange(channel, number, value);
}

// notecolor (Slide int value)
public void Red(int value){ rVal=value; }  
public void Green(int value){ gVal=value; }    
public void Blue(int value){ bVal=value; }
public void Bn(int value){ brVal=value;}

// bgColor (Slide int value)
public void BRed(int value){ bgrVal=value; }  
public void BGreen(int value){ bggVal=value; }    
public void BBlue(int value){ bgbVal=value; }
public void BBn(int value){ bgbrVal=value;}

public void Send(){  
  
  // send midi note 109 to indicate color change of notes   (can be changued... need to modify arduino code too. (line 67))
    
  int r = rVal*brVal/100;
  int g = gVal*brVal/100;
  int b = bVal*brVal/100;

  myPort.write(144);
  myPort.write(109);
  myPort.write(64);
  myPort.write(r);
  myPort.write(g);
  myPort.write(b);
  
}

public void BSend(){

  // send midi note 110 to indicate color change of notes can be changued... need to modify arduino code too. (line 86))
  
  int r = bgrVal*bgbrVal/100;
  int g = bggVal*bgbrVal/100;
  int b = bgbVal*bgbrVal/100;

  myPort.write(144);
  myPort.write(110);
  myPort.write(64);
  myPort.write(r);
  myPort.write(g);
  myPort.write(b);
  
}

void controlEvent(ControlEvent theEvent) {
  

     if(theEvent.getController().getName()=="Red" || theEvent.getController().getName()=="Green" || theEvent.getController().getName() == "Blue") {
       
       sendButton.setColorBackground(color(rVal, gVal, bVal)); 
 }
     
   
     if(theEvent.getController().getName()=="BRed" || theEvent.getController().getName()=="BGreen" || theEvent.getController().getName() == "BBlue") {
       
       sendbgButton.setColorBackground(color(bgrVal, bggVal, bgbVal)); 
 }
}
