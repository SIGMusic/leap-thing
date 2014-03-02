class Circle extends Shape {
  int rad;
  int c;
  Body b;
  

  // Constructor
 Circle(float x, float y, int radius, int boundaryHue, float _a){
    rad = radius;
    this.a = _a;
    
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
    int hue = (int)(boundaryHue + 180 + random(-20,20));
    hue = hue % 360;
    c = color(hue, 100, 100);
    
    this.hue = hue;
    this.id = shapeCounter ++;
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
    if (pos.y > height+rad || pos.y < -30) {
      killBody();
      return true;
    }
    return false;
  }
  
  
  void displayShadow(){
    
    
    }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float rotation = body.getAngle();

    ellipseMode(CENTER);
    fill(this.c);
    stroke(0);
    ellipse(pos.x, pos.y, 2 * rad, 2 * rad);
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
  void makeBody(Vec2 center) {

    // Define a polygon (this is what we use for a rectangle)
    CircleShape sd = new CircleShape();
    sd.m_radius = box2d.scalarPixelsToWorld(rad);

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

    this.body = box2d.createBody(bd);
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
    msg.add("Circle");
    msg.add(this.getId());
    msg.add(2 * this.rad);
    msg.add(2 * this.rad);
    msg.add(-1); // infinity sides
    // ...
    sendOSCMessage(msg);
  }
  
  boolean hasBody(Body b){
      return this.body.equals(b);
  }
}
