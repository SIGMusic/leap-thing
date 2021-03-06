

class NagonObject extends Shape {
  float w;
  float h;
  Body body;
  int c;
  int sides;
  int currentAura;

  // Constructor
  NagonObject(float w, float h, float x, float y, int boundaryHue, float _a, int n, int num, int len, float v0) {
    numShadows = num;
    shadowLength = len;
    sY = new float[shadowLength];
    sX = new float[shadowLength];
    sAng = new float[shadowLength];
    sHue = new int[shadowLength];
    validShadows = new int[numShadows];
    this.w = w;
    this.h = h;
    this.a = _a;
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h, n, v0);
    
    int hue = (int)(boundaryHue + 180 + random(-20,20));
    hue = hue % 360;
    int saturation = 100;
    int brightness = 70;
    
    c = color(hue, saturation, brightness);
    
    currentAura = 0;
    for(int z = 0; z < shadowLength; z ++)
    {
      this.sX[z] = -100; 
      this.sY[z] = -100;  
      this.sAng[z] = 0;
    }
   
    this.hue = hue;
    this.saturation = saturation;
    this.brightness = brightness;
    this.id = shapeCounter ++;
    this.sides = n;
    
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
    if (pos.y > height+30 || pos.y < -30 || pos.x > width+30 || pos.x < -30) {
      killBody();
      return true;
    }
    return false;
  }

  
  void displayShadow(){
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();

    for(int j = 0; j < numShadows; j ++)
    {
      int t = (currentAura + validShadows[j]) % shadowLength;
    rectMode(CENTER);
    pushMatrix();
    translate(this.sX[t], this.sY[t]);
    rotate(-this.sAng[t]);
    fill(color(this.hue, this.saturation, 70), 100);
    stroke(0, 0);
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
    fill(color(this.hue, this.saturation, 70));
    stroke((hue + 20)%360, 100, 100);
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
    float f = forceMag * body.getMass() * -9.81;
    float f_x = f * cos(rad);
    float f_y = -1*f * sin(rad);
    currentAura = currentAura+1;
    currentAura = currentAura%shadowLength;
    Vec2 curPos = box2d.getBodyPixelCoord(body);
    this.sX[currentAura] = curPos.x;
    this.sY[currentAura] = curPos.y;
    this.sAng[currentAura] = body.getAngle();
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
  void makeBody(Vec2 center, float w_, float h_, int n, float v0) {

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
    fd.restitution = this.restitution;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    this.body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(2, 5), 10*v0));
    body.setAngularVelocity(random(-5, 5));
  }
  
  int getHue(){
     return this.hue; 
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
  
  int getId(){
     return this.id; 
  }
  
  float getX(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    return pos.x;
  }
  
  void sendOSC(){
    OscMessage msg = new OscMessage("/shape");
    msg.add("Nagon");
    msg.add(this.id);
    msg.add(this.w);
    msg.add(this.h);
    msg.add(this.sides);
    
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
      return body.equals(b);
  }
}
