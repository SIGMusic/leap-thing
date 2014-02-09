// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// PBox2D example

// A fixed boundary class
class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float w;
  float h;
  
  // But we also have to make a body for box2d to know about it
  Body b;
  
  // id associated with hand ID from Leap
  int id;

  Boundary(float x_,float y_, float w_, float h_, int id_) {
    w = w_;
    h = h_;
    id = id_;

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
    bd.position.set(box2d.coordPixelsToWorld(x_,y_));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
  }

  Boundary(float x_,float y_, float w_, float h_, float a_, int id_) {
    this(x_, y_, w_, h_, id_);
    this.move(x_, y_, a_);
  }
  
  int getId() {
     return this.id; 
  }
  
  // Draw the boundary, if it were at an angle we'd have to do something fancier
 void display() {
    Vec2 pos = box2d.getBodyPixelCoord(b);
    
    fill(this.getColor());
    stroke(0);
    rectMode(CENTER);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-1*this.b.getAngle());
    rect(0,0,w,h);
    popMatrix();
  }
  
  // return the color of the boundry
  int getColor(){
    
    int h = this.getHue();
    int s = 100;
    int b = 100;
        
    return color(h,s,b);
  }
  
  int getHue(){
    Vec2 pos = box2d.getBodyPixelCoord(b);
    
    float distance = sqrt(pow(pos.x - width / 2.0, 2) + pow(pos.y - height / 2.0, 2));
    int hue = (int) ((distance / width) * 360 * 3);
    return hue % 360;
  }

  void move(float x_, float y_, float angle){
     this.b.setTransform(box2d.coordPixelsToWorld(x_, y_), angle);
  }
  
  void move(float x_, float y_){
     this.move(x_, y_, this.b.getAngle()); 
  }
}


