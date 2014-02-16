// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example



// A rectangular box
class Box extends Shape {
  
  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  int c;
  int myHue;
  SpawnLocation l;

  // Constructor
  Box(float x, float y, int boundaryHue, SpawnLocation location, int n) {
    w = random(20, 50);
    h = random(5, 30);
    l = location;
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h, n);
    
    int hue = (boundaryHue + 180);
    
    switch (location){
       case TOP:
          hue += 20;
       case BOTTOM:
          hue -= 20;
    }
    hue = hue % 360;
    c = color(hue, 100, 100);
    
    myHue = hue;
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h || pos.y < -30) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(this.c);
    stroke(0);
    beginShape();
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  void applyGravity() {
     // Give it gravity
    float f = body.getMass() * -9.81;
    if (this.l == SpawnLocation.BOTTOM){
       f = f * -1; 
    }
    body.applyForce(new Vec2(0, f), body.getPosition()); 
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_, int n) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    
    float deg = 360 / n;
    Vec2[] vertices = new Vec2[n];
   
    for(int i = 0; i < n; i++)
    {
      vertices[i] = box2d.vectorPixelsToWorld(new Vec2(cos(radians(deg * (n - i))) * (w_/2), sin(radians(deg * (n - i))) * (w_/2)));//Change 2nd w_ to h_ to get non-symetric objects
    } 


    sd.set(vertices, vertices.length);


    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
  
  int getHue(){
     return myHue; 
  }
  
  void sendOSC(){
    OscMessage msg = new OscMessage("/shape/box");
    msg.add(this.w);
    msg.add(this.h);
    sendOSCMessage(msg);
  }
}

