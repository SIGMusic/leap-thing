abstract class Shape {  
  float a; // angle that gravity is applied at
  
  abstract void display();
  abstract void applyGravity();
  abstract void killBody();
  abstract boolean done();
  abstract int getHue();
  abstract void sendOSC();
}
