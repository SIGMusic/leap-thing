int shapeCounter = 0;

abstract class Shape {
  Body body;
  int hue; // color of the shape
  float a; // angle that gravity is applied at
  int id; // unique id for this shape
  
  abstract void display();
  abstract void applyGravity();
  abstract void killBody();
  abstract boolean done();
  abstract int getHue();
  abstract void sendOSC();
  abstract boolean hasBody(Body b);
  abstract int getId();
}
