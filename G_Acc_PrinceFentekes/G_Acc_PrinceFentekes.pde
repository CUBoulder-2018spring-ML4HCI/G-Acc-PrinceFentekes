//Adapted form color demo
//4 outputs required
//Output 1 continuous between -1 and 1,linked to only input 1
//output 2 classification between 2 classes, linked only to input 1
//output 3 continuous between -1 and 1, linked only to inputs 2 & 3
//output 4 classification between 2 classes, linked only to inputs 2 & 3

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

//Parameters of sketch
float myHue;
PFont myFont;
float curX,curY,accX,accY,velX,velY,theta,lTime;

void setup() {
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  colorMode(HSB);
  size(800,800, P3D);
  smooth();
  background(255);

  //Initialize appearance
  curX=390;
  curY=390;
  accX=0;
  accY=0;
  velX=0;
  velY=0;
  myHue = 255;
  sendOscNames();
  myFont = createFont("Arial", 14);
}

void draw() {
  background(myHue, 255, 255);
  
  
  rect(curX,curY,20,20);
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
     if(theOscMessage.checkTypetag("ffff")) { // looking for 1 control value
        float receivedHue = theOscMessage.get(0).floatValue();
        float dtheta = theOscMessage.get(0).floatValue();
        float ctheta = theOscMessage.get(1).floatValue();
        if(ctheta==1){
          theta= (theta + dtheta)%TWO_PI;
        }
        float acc = theOscMessage.get(2).floatValue();
        float cacc = theOscMessage.get(3).floatValue();
        if(cacc==1 && accX + acc/10<2 && accX + acc/10>-2){
          accX = accX + acc/10;
        }
        velX = velX + (accX*((millis()/1000)-lTime));
        if((curX + (cos(theta)*(velX*((millis()/1000)-lTime)))>=0)&&curX + (cos(theta)*(velX*((millis()/1000)-lTime)))<=780){
          curX = curX + (cos(theta)*(velX*((millis()/1000)-lTime)));
        }
        if(curY + (sin(theta)*(velX*((millis()/1000)-lTime)))>=0 && curY + (sin(theta)*(velX*((millis()/1000)-lTime)))<=780){
          curY = curY + (sin(theta)*(velX*((millis()/1000)-lTime)));
        }
        lTime = millis()/1000;
     } else {
        println("Error: unexpected OSC message received by Processing: ");
        theOscMessage.print();
      }
 }
}

//Sends current parameter (hue) to Wekinator
void sendOscNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setOutputNames");
  msg.add("hue"); //Now send all 5 names
  oscP5.send(msg, dest);
}

//Write instructions to screen.
void drawtext() {
    stroke(0);
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(0, 0, 255);
    text("Receiving 1 continuous parameter: hue, in range 0-1", 10, 10);
    text("Listening for /wek/outputs on port 12000", 10, 40);
}