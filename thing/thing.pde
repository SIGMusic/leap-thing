import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

import de.voidplus.leapmotion.*;

float hand_pitch_Noleap = 0;
LeapMotion leap;

PBox2D box2d;
ArrayList<Boundary> boundaries;
ArrayList<Shape> shapes;

final boolean FULLSCREEN = false;

boolean sketchFullScreen(){
  return FULLSCREEN;
}

void setup() {
  // Setup Processing
  if(FULLSCREEN)
  {
    size(displayWidth, displayHeight);
  }
  else
  {
    size(800, 600, P3D);
  }
  background(360, 0, 100);
  smooth(); 
  colorMode(HSB, 360, 100, 100);

  // Setup Box2d
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  shapes = new ArrayList<Shape>();

  // Setup Leap
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(mouseX, mouseY, 100, 10, -1));
  leap = new LeapMotion(this); //<>//

  // Setup oscP5
  setupOsc();
}


void draw() {
  //background(360, 0, 100);
  setBackground();

  // step physics world
  box2d.step();

  // give all of the existing shapes gravity
  for (Shape s : shapes) {
    s.applyGravity();
  }

  // Spawn shapes

  if (random(1) < 0.2 && boundaries.size() > 0) {
    Box p;
    if (random(1) < 0.5) {
      p = new Box(width/2 + random(-100, 100), -10, boundaries.get(boundaries.size() - 1).getHue(), SpawnLocation.TOP, int(random(7)) + 3);
    } 
    else {
      p = new Box(width/2 + random(-100, 100), height+10, boundaries.get(boundaries.size() - 1).getHue(), SpawnLocation.BOTTOM,  int(random(7)) + 3);
    }

    shapes.add(p);
  }

  // Display all shapes
  for (Shape b : shapes) {
    b.display();
  }

  // Delete shapes that leave the screen
  for (int i = shapes.size()-1; i >= 0; i--) {
    Shape b = shapes.get(i);
    if (b.done()) {
      shapes.remove(i);
    }
  }

  // Display hands
  for (Boundary boundary : boundaries) {
    boundary.display();
  }

  // Delete hands that leave the simulation
  for (int i = 0; i < boundaries.size(); i++) {
    Boundary boundary = boundaries.get(i);
    if (boundary.getId() != -1) {
      boolean delete = true;
      for (Hand hand : leap.getHands()) {
        if (hand.getId() == boundary.getId()) {
          delete = false;
        }
      } 
      if (delete) {
        boundary.destroy();
        boundaries.remove(i);
      }
    }
  }

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
  }
}

