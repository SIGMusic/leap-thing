int NagonCounter = 0;

class NagonObject extends Shape {
  float w;
  float h;
  int c;
  int id;
  int sides;

  // Constructor
  NagonObject(float x, float y, int boundaryHue, float _a, int n) {
    w = random(50, 100);
    h = random(50, 100);
    this.a = _a;
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h, n);
    
    int hue = (int)(boundaryHue + 180 + random(-20,20));
    hue = hue % 360;
    c = color(hue, 100, 100);
    
    this.hue = hue;
    this.id = NagonCounter ++;
    this.sides = n;
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
    if (pos.y > height+w*h || pos.y < -30 || pos.x > width+w*h || pos.x < -30) {
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
    float rad = a * 3.14 / 180.0;
    float f = body.getMass() * -9.81;
    float f_x = f * cos(rad);
    float f_y = -1*f * sin(rad);
    body.applyForce(new Vec2(f_x, f_y), body.getPosition()); 
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
    fd.restitution = 1.05;

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
     return this.hue; 
  }
  
  int getId(){
     return this.id; 
  }
  
  void sendOSC(){
    OscMessage msg = new OscMessage("/shape");
    msg.add("Nagon");
    msg.add(this.id);
    msg.add(this.w);
    msg.add(this.h);
    msg.add(this.sides);
    sendOSCMessage(msg);
  }
}
