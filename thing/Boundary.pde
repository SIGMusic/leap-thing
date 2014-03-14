// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// PBox2D example

// A fixed boundary class
class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float w;
  float h;
  int shadowLength = 20;
  float[] sY = new float[shadowLength];
  float[] sX = new float[shadowLength];
  float[] sAng = new float[shadowLength];
  int[] sHue = new int[shadowLength];
  int saturation = 100;
  int brightness = 100;
  int currentAura = 0;

  // But we also have to make a body for box2d to know about it
  Body b;

  // id associated with hand ID from Leap
  int id;

  Boundary(float x_, float y_, int id_) {
    w = 200;
    h = 25;
    id = id_;

    for(int z = 0; z < shadowLength; z ++)
    {
      this.sX[z] = -100; 
      this.sY[z] = -100;  
      this.sAng[z] = 0;
    }
    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.KINEMATIC;
    bd.position.set(box2d.coordPixelsToWorld(x_, y_));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd, 1);
  }

  Boundary(float x_, float y_, float a_, int id_) {
    this(x_, y_, id_);
    this.move(x_, y_, a_);
  }

  int getId() {
    return this.id;
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    
     for(int t = 0; t < shadowLength; t ++)
    {
        Vec2 pos = box2d.getBodyPixelCoord(b);

    fill(color(this.sHue[t], this.saturation, this.brightness), 100);
    stroke(0, 0);
    rectMode(CENTER);

    pushMatrix();
    translate(this.sX[t], this.sY[t]);
    rotate(-1*this.sAng[t]);
    rect(0, 0, w, h);
    popMatrix();
    }
    
    Vec2 pos = box2d.getBodyPixelCoord(b);

    fill(color(this.getHue(), this.saturation, this.brightness));
    stroke(color(this.getHue(), this.saturation, this.brightness));
    rectMode(CENTER);

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-1*this.b.getAngle());
    rect(0, 0, w, h);
    popMatrix();
  }

  // return the color of the boundry
  int getColor() {

    int h = this.getHue();
    int s = 100;
    int b = 100;

    return color(h, s, b);
  }

  int getHue() {
    Vec2 pos = box2d.getBodyPixelCoord(b);

    float distance = sqrt(pow(pos.x - width / 2.0, 2) + pow(pos.y - height / 2.0, 2));
    int hue = (int) ((distance / width) * 360 * 3);
    return hue % 360;
  }
  
  float getAngle() {
    return this.b.getAngle();
  }
  
  int getSaturation(){
     return this.saturation; 
  }
     
  void setSaturation(int sat){
    this.saturation = sat; 
  }

  int getBrightness(){
     return this.brightness; 
  }
     
  void setBrightness(int bri){
    this.brightness = bri; 
  }
  
  void move(float x_, float y_, float angle) {
    this.b.setTransform(box2d.coordPixelsToWorld(x_, y_), angle);
    
    currentAura = currentAura+1;
    currentAura = currentAura%shadowLength;
    this.sX[currentAura] = x_;
    this.sY[currentAura] = y_;
    this.sAng[currentAura] = angle;
    this.sHue[currentAura] = this.getHue();
  }

  void move(float x_, float y_) {
    this.move(x_, y_, this.b.getAngle());
  }

  void destroy() {
    box2d.destroyBody(this.b);
  }

  void sendOSC() {
    OscMessage msg = new OscMessage("/boundary");
    msg.add(id);
    msg.add(w);
    msg.add(h);
    msg.add(this.getHue());
    msg.add(this.getAngle());
    // ...
    sendOSCMessage(msg);
  }
    
  Body getBody()
  {
    return this.b; 
  }
  
  boolean hasBody(Body _b){
    return this.b.equals(_b);
  }
}
