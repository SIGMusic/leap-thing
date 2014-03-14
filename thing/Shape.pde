int shapeCounter = 0;
float forceMag = 1.0;
float max_force = 100.0;
float force_scale = 17.0;
float field_size = 1000.0;

abstract class Shape {
  Body body;
  int hue; // color of the shape
  int saturation;//saturation of the shape
  int brightness;//brightness of the shape
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
  abstract int getSaturation();
  abstract void setSaturation(int sat);
  abstract int getBrightness();
  abstract void setBrightness(int bri);
  abstract void sendOSC();
  abstract boolean hasBody(Body b);
  abstract int getId();
  abstract void applyBoundaryField(Boundary b);
  abstract float getX();
}
