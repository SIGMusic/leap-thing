// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// PBox2D example

// A fixed boundary class

class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  
  // But we also have to make a body for box2d to know about it
  Body b;

  Boundary(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

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
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(b);
    // Get its angle of rotation
    float a = b.getAngle();
    
    fill(0);
    stroke(0);
    rectMode(CENTER);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-1*this.b.getAngle());
    rect(0,0,w,h);
    popMatrix();
  }

  void move(float x_, float y_, float angle){
     this.b.setTransform(box2d.coordPixelsToWorld(x_, y_), angle);
  }
  
  void move(float x_, float y_){
     this.move(x_, y_, this.b.getAngle()); 
  }
}


