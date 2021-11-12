
/*Author: Tony San Piano
  
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

// color testos
int rVal = 0;
int gVal = 0;
int bVal = 0;
int portR =0;

Button sendButton;


final boolean debug = true;
MidiBus myBus; // The MidiBus
public void settings(){ size(320,160);}
void setup() 
{

  f = createFont("Verdana", 10, true);
  myBus = new MidiBus(this, 0, 0);

  myPort = new Serial(this, Serial.list()[32], 115200); // Linux 32 - Win 1
  

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
  
  controlP5.setFont(font);
  controlP5.addSlider("Red").setMin(0).setMax(255).setValue(255).setPosition(20,60).setSize(200,20).setSliderMode(0).setId(1).setColorForeground(color(150,0,0)).setColorBackground(color(50,0,0)).setColorActive(color(255,0,0));
  controlP5.addSlider("Green").setMin(0).setMax(255).setValue(255).setPosition(20,90).setSize(200,20).setSliderMode(0).setId(2).setColorForeground(color(0,150,0)).setColorBackground(color(0,50,0)).setColorActive(color(0,255,0));
  controlP5.addSlider("Blue").setMin(0).setMax(255).setValue(255).setPosition(20,120).setSize(200,20).setSliderMode(0).setId(3).setColorForeground(color(0,0,150)).setColorBackground(color(0,0,50)).setColorActive(color(0,0,255));
  
  sendButton = controlP5.addButton("Send").setPosition(270, 85).setSize(30,30); 
  
 
  
}

void draw()
{

  background(100);
  fill(255);                         
  textFont(f, 20);
  text("Conectado " + ascii, 20, 40);  
  
}

void noteOn(int channel, int note, int velocity) {

  delay(10);  // This seems to resolve Ws2812b
  state = 144;
  myPort.write(state);
  myPort.write(note);
  myPort.write(velocity);
  
  ascii = note;

}

void noteOff(int channel, int note, int velocity) {

  delay(10);  // :;
  state = 128;
  myPort.write(state);
  myPort.write(note);
  myPort.write(velocity);

  ascii = note;
  
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  myBus.sendControllerChange(channel, number, value);
}

public void Red(int value){ rVal=value; }  
public void Green(int value){ gVal=value; }    
public void Blue(int value){ bVal=value; }

public void Send(){
  
  delay(10);
  myPort.write(144);
  myPort.write(109);
  myPort.write(64);
  myPort.write(rVal);
  myPort.write(gVal);
  myPort.write(bVal);
  
}
