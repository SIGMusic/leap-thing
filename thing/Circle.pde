class Circle extends Shape {
  int rad;
  int c;
  Body b;
  int currentAura;

  // Constructor
 Circle(float x, float y, int radius, int boundaryHue, float _a, int num, int len){
    numShadows = num;
    shadowLength = len;
    rad = radius;
    this.a = _a;
    
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
    int hue = (int)(boundaryHue + 180 + random(-20,20));
    hue = hue % 360;
    c = color(hue, 100, 70);
    
        currentAura = 0;
    for(int z = 0; z < shadowLength; z ++)
    {
      this.sX[z] = -100; 
      this.sY[z] = -100;
    }
    
    this.hue = hue;
    this.id = shapeCounter ++;
    
    //Sets up evenly spaced shadows to display
    for (int i = 0; i< numShadows; i++)
    {
      validShadows[i] = (i * (shadowLength/numShadows) + 1) % shadowLength;
    }
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
    for(int j = 0; j < numShadows; j ++)
    {
      //t holds the valid position relative to the shapes current
      //location.
    int t = (currentAura + validShadows[j]) % shadowLength;
    ellipseMode(CENTER);
    fill(this.c, 100);
    stroke(0, 0);
    ellipse(this.sX[t], this.sY[t], 2 * rad, 2 * rad);
    }
    
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
    float f = forceMag * body.getMass() * -9.81;
    float f_x = f * cos(rad);
    float f_y = -1*f * sin(rad);
    currentAura = currentAura+1;
    currentAura = currentAura%shadowLength;
    Vec2 curPos = box2d.getBodyPixelCoord(body);
    this.sX[currentAura] = curPos.x;
    this.sY[currentAura] = curPos.y;
    body.applyForce(new Vec2(f_x, f_y), body.getPosition()); 
  }

  
  void applyBoundaryField(Boundary b) {
     // Give it gravity
    Vec2 pos_boundry = b.getBody().getPosition();
    Vec2 pos_this = body.getPosition();
    float f_x = 0.0;
    float f_y = 0.0;
    if(pow(-pos_boundry.x+pos_this.x,2) + pow(-pos_boundry.y+pos_this.y,2) < field_size)
    {
    if(pos_boundry.x-pos_this.x > 0)
    {
      if ((pow(-pos_boundry.x+pos_this.x,2)* forceMag * body.getMass())/force_scale > max_force)
      {
        f_x = -max_force;  
      }
      else{
        f_x = (-max_force+pow(-pos_boundry.x+pos_this.x,2)* forceMag * body.getMass())/force_scale;
      }
    }
    else{
      if ((pow(-pos_boundry.x+pos_this.x,2)* forceMag * body.getMass())/force_scale > max_force)
      {
        f_x = max_force;
      } 
      else{
        f_x = (max_force-pow(-pos_boundry.x+pos_this.x,2)* forceMag * body.getMass())/force_scale;
      }
    }
    if(pos_boundry.y-pos_this.y > 0)
    {
      if ((pow(-pos_boundry.y+pos_this.y,2)* forceMag * body.getMass())/force_scale > max_force)
      {
        f_y = -max_force;  
      }
      else{
        f_y = (-max_force+pow(-pos_boundry.y+pos_this.y,2)* forceMag * body.getMass())/force_scale;
      }
    }
    else{
      if ((pow(-pos_boundry.y+pos_this.y,2)* forceMag * body.getMass())/force_scale > max_force)
      {
        f_y = max_force;
      } 
      else{
        f_y = (max_force-pow(-pos_boundry.y+pos_this.y,2)* forceMag * body.getMass())/force_scale;
      }
    }
   
    body.applyForce(new Vec2(f_x, f_y), body.getPosition()); 
  }
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
    fd.restitution = this.restitution;

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
  
  float getX(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    return pos.x;
  }
  
  void sendOSC(){
    OscMessage msg = new OscMessage("/shape");
    msg.add("Circle");
    msg.add(this.getId());
    msg.add(2 * this.rad);
    msg.add(2 * this.rad);
    msg.add(-1); // infinity sides
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    msg.add(pos.x);
    msg.add(pos.y);
    
    Vec2 linVel = body.getLinearVelocity();

    msg.add(linVel.x);
    msg.add(linVel.y);

    float angVel = body.getAngularVelocity();
    msg.add(angVel);
    
    // ...
    sendOSCMessage(msg);
  }
  
  boolean hasBody(Body b){
      return this.body.equals(b);
  }
}
