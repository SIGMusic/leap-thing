int shapeCounter = 0;
float forceMag = 1.0;

abstract class Shape {
  Body body;
  int hue; // color of the shape
  float a; // angle that gravity is applied at
  int id; // unique id for this shape
  int shadowLength;
  float[] sY;
  float[] sX;
  float[] sAng;
  int[] sHue;
  int numShadows;
  int[] validShadows;
  final float restitution = 1.25;
  
  abstract void display();
  abstract void displayShadow();
  abstract void applyGravity();
  abstract void killBody();
  abstract boolean done();
  abstract int getHue();
  abstract void sendOSC();
  abstract boolean hasBody(Body b);
  abstract int getId();
  abstract float getY();
}
