abstract class Nagon {
  
  abstract void display();
  abstract void applyGravity();
  abstract void killBody();
  abstract void makeBody(Vec2 center, float w_, float h_, int n);
  abstract boolean done();
  abstract int getHue();
  abstract void sendOSC();
}
