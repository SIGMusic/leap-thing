import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.lang.Math.*;
import de.voidplus.leapmotion.*;

float hand_pitch_Noleap = 0;
LeapMotion leap;

PBox2D box2d;
ArrayList<Boundary> boundaries;
ArrayList<Shape> shapes;
ArrayList<Shape> queue;
ArrayList<OscHand> hands;

final boolean FULLSCREEN = false;

DebugOverlay debug = new DebugOverlay();
boolean debugFlag = false;

boolean sketchFullScreen() {
  return FULLSCREEN;
}

void setup() {
  // Setup Processing
  if (FULLSCREEN)
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
  queue = new ArrayList<Shape>();
  box2d.listenForCollisions();

  // Setup Leap
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(mouseX, mouseY, -1));
  leap = new LeapMotion(this); //<>//
  hands = new ArrayList<OscHand>();

  // Setup oscP5
  setupOsc();
}

// contact handler
void beginContact(Contact contact) {
  sendContact(contact);
}

void draw() {
  synchronized (shapes) {
    //background(360, 0, 100);
    setBackground();

    //clear hands arraylist
    hands = new ArrayList<OscHand>();

    // step physics world
    box2d.step();

    // give all of the existing shapes gravity
    for (Shape s : shapes) {
      s.applyGravity();
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

      if (debugFlag) debug.draw();
    }

    //NO LEAP MODE
    if (keyPressed) {
      if (key == 'a' || key == 'A') {
        hand_pitch_Noleap = hand_pitch_Noleap + 1;
      }
      if (key == 'd' || key == 'D') {
        hand_pitch_Noleap = hand_pitch_Noleap - 1;
      }
      if (key == 'o' || key == 'O') {
        debugFlag = true;
      }
      if (key == 'p' || key == 'P') {
        debugFlag = false;
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
          boundaries.add(new Boundary(hand_position.x, hand_position.y, angle, hand_id));
        }
      }

      ArrayList<Finger> fingers = hand.getFingers();
      hands.add(new OscHand(hand, fingers));

      // FINGERS
      for (Finger finger : fingers) {

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
}

