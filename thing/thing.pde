import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

import de.voidplus.leapmotion.*;

float hand_pitch_Noleap = 0;
LeapMotion leap;
PBox2D box2d;
ArrayList<Boundary> boundaries;

ArrayList<Box> boxes;

void setup() {
  // Setup Processing
  size(800, 600, P3D);
  background(360, 0, 100);
  smooth(); 
  colorMode(HSB, 360, 100, 100);

  // Setup Box2d
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  boxes = new ArrayList<Box>();

  // Setup Leap
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(mouseX, mouseY, 100, 10, -1));
  leap = new LeapMotion(this); //<>//
}

//changes background based on the avg hue value of all the boxes
void setBackground() {  
  int total_hue = 0;
  int avg_hue = 0;
  if(boxes.size() > 0){
    for(int i = 0; i < boxes.size(); i++){
        total_hue += boxes.get(i).getHue();
    }
    avg_hue = total_hue/boxes.size();
  }
  //System.out.println(((avg_hue)%360));
  background((avg_hue)%360, 100, 60);
}

void draw() {
  //background(360, 0, 100);
  setBackground();
  
  // step physics world
  box2d.step();

  // give all of the existing boxes gravity
  for (Box b : boxes) {
    b.applyGravity();
  }

  // Spawn boxes
  if (random(1) < 0.2 && boundaries.size() > 0) {
    Box p;
    if (random(1) < 0.5) {
      p = new Box(width/2 + random(-100, 100), -10, boundaries.get(boundaries.size() - 1).getHue(), SpawnLocation.TOP);
    } 
    else {
      p = new Box(width/2 + random(-100, 100), height+10, boundaries.get(boundaries.size() - 1).getHue(), SpawnLocation.BOTTOM);
    }

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
  for (Boundary boundary : boundaries) {
    boundary.display();
  }

  // Delete hands that leave the simulation
  for (int i = 0; i < boundaries.size(); i++){
    Boundary boundary = boundaries.get(i);
    if (boundary.getId() != -1){
       boolean delete = true;
       for (Hand hand : leap.getHands()){
          if (hand.getId() == boundary.getId()){
             delete = false; 
          }
       } 
       if (delete){
          boundary.destroy();
          boundaries.remove(i); 
       }
    }
  }

  System.out.println(boundaries.size());

  //NO LEAP MODE
  if (keyPressed) {
    if (key == 'a' || key == 'A') {
      hand_pitch_Noleap = hand_pitch_Noleap + 1;
    }
    if (key == 'd' || key == 'D') {
      hand_pitch_Noleap = hand_pitch_Noleap - 1;
    }
  }
  float angle2 = -1 * hand_pitch_Noleap * 3.14 / 180.0;
  for (Boundary boundary : boundaries) {
    if (boundary.getId() == -1) {
      boundary.move(mouseX, mouseY, angle2);
    }
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
    boolean created = false;
    if (hand_position.z>20)
    {
      for (Boundary boundary : boundaries) {
        if  (boundary.getId() == hand_id) {
          boundary.move(hand_position.x, hand_position.y, angle); 
          created = true;
        }
      }
      if (!created) {
        boundaries.add(new Boundary(hand_position.x, hand_position.y, 100, 10, angle, hand_id));
      }
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

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}

