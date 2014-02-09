abstract class Shape {
  
  abstract void display();
  abstract void applyGravity();
  abstract void killBody();
  abstract void makeBody(Vec2 center, float w_, float h_);
  abstract boolean done();
  abstract int getHue();
}
