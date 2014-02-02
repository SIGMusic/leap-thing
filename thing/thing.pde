import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

import de.voidplus.leapmotion.*;


LeapMotion leap;
PBox2D box2d;
float hand_pitch_Noleap = 0;
boolean leap_connected = false;
ArrayList<Boundary> dHand;

ArrayList<Box> boxes;

void setup() {
  // Setup Processing
  size(800, 500, P3D);
  background(255);
  noStroke();
  smooth(); 
  fill(50);

  // Setup Box2d
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);
  boxes = new ArrayList<Box>();

  // Setup Leap
  dHand = new ArrayList<Boundary>();
  leap = new LeapMotion(this); //<>//
}

void draw() {
  if(leap_connected){
    HaveLeap();
  }
  else{
    NoLeap();
  }
}

void HaveLeap(){
  background(255);

  // step physics world
  box2d.step();

  // ...
  int fps = leap.getFrameRate();

  // Spawn boxes
  if (random(1) < 0.2) {
    Box p = new Box(width/2, 30);
    boxes.add(p);
  }

  // Display all boxes
  for (Box b : boxes) {
    b.display();
  }

  // Delete boxes that leave the screen
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
  
  // Display hands
  for (int i = 0; i<dHand.size(); i++)
  {
    dHand.get(i).display();
    box2d.destroyBody(dHand.get(i).b);
    dHand.remove(i);
  }

  // HANDS
  for (Hand hand : leap.getHands()) {

    int     hand_id          = hand.getId();
    PVector hand_position    = hand.getPosition();
    PVector hand_stabilized  = hand.getStabilizedPosition();
    PVector hand_direction   = hand.getDirection();
    PVector hand_dynamics    = hand.getDynamics();
    float   hand_roll        = hand.getRoll();
    float   hand_pitch       = hand.getPitch();
    float   hand_yaw         = hand.getYaw();
    float   hand_time        = hand.getTimeVisible();
    PVector sphere_position  = hand.getSpherePosition();
    float   sphere_radius    = hand.getSphereRadius();

    float angle = -1 * hand_pitch * 3.14 / 180.0;
      if(hand_position.z>20)
      {
        dHand.add(new Boundary(hand_position.x, hand_position.y,100,10,angle));
      }

    // FINGERS
    for (Finger finger : hand.getFingers()) {

      // Basics
      finger.draw();
      int     finger_id         = finger.getId();
      PVector finger_position   = finger.getPosition();
      PVector finger_stabilized = finger.getStabilizedPosition();
      PVector finger_velocity   = finger.getVelocity();
      PVector finger_direction  = finger.getDirection();
      float   finger_time       = finger.getTimeVisible();

      // Touch Emulation
      int     touch_zone        = finger.getTouchZone();
      float   touch_distance    = finger.getTouchDistance();

      switch(touch_zone) {
      case -1: // None
        break;
      case 0: // Hovering
        // println("Hovering (#"+finger_id+"): "+touch_distance);
        break;
      case 1: // Touching
        // println("Touching (#"+finger_id+")");
        break;
      }
    }

    // TOOLS
    for (Tool tool : hand.getTools()) {

      // Basics
      tool.draw();
      int     tool_id           = tool.getId();
      PVector tool_position     = tool.getPosition();
      PVector tool_stabilized   = tool.getStabilizedPosition();
      PVector tool_velocity     = tool.getVelocity();
      PVector tool_direction    = tool.getDirection();
      float   tool_time         = tool.getTimeVisible();

      // Touch Emulation
      int     touch_zone        = tool.getTouchZone();
      float   touch_distance    = tool.getTouchDistance();

      switch(touch_zone) {
      case -1: // None
        break;
      case 0: // Hovering
        // println("Hovering (#"+tool_id+"): "+touch_distance);
        break;
      case 1: // Touching
        // println("Touching (#"+tool_id+")");
        break;
      }
    }
  }

  // DEVICES
  // for(Device device : leap.getDevices()){
  //   float device_horizontal_view_angle = device.getHorizontalViewAngle();
  //   float device_verical_view_angle = device.getVerticalViewAngle();
  //   float device_range = device.getRange();
  // }

  // MOUSE
  ellipse(mouseX, mouseY, 5.0, 5.0);
}

void NoLeap()
{
  background(255);

  // step physics world
  box2d.step();

  // ...
  int fps = 60;
  // Spawn boxes
  if (random(1) < 0.2) {
    Box p = new Box(width/2, 30);
    boxes.add(p);
  }

  // Display all boxes
  for (Box b : boxes) {
    b.display();
  }

  // Delete boxes that leave the screen
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
  
  // Display hands
  dHand.display();

  if(keyPressed){
    if(key == 'a' || key == 'A'){
      hand_pitch_Noleap = hand_pitch_Noleap + 1;
    }
    if(key == 'd' || key == 'D'){
      hand_pitch_Noleap = hand_pitch_Noleap - 1;
    }
  }  
  
  float angle = -1 * hand_pitch_Noleap * 3.14 / 180.0;
  dHand.move(mouseX, mouseY, angle);
}

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
    leap_connected = true;
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
    leap_connected = false;
}
void leapOnExit() {
    leap_connected = false;
}
