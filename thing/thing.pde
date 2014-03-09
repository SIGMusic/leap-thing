import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.lang.Math.*;
import de.voidplus.leapmotion.*;

//No Leap Stuff
//Enter mouse mode with "m" <- short for mouse
//Exit mouse mode with "n" <- short for no mouse
float hand_pitch_Noleap = 0;
boolean mouseMode = false;

LeapMotion leap;

PBox2D box2d;
ArrayList<Boundary> boundaries;
ArrayList<Shape> shapes;
ArrayList<OscHand> hands;

final boolean FULLSCREEN = true;

DebugOverlay debug = new DebugOverlay();
boolean debugFlag = false;

final int H_MAX = 360;
final int S_MAX = 100;
final int B_MAX = 100;

//shadows on shapes
//Change numShadows with 0-9 keys
//Change shadowLength with "+" and "-"
int numShadows=2;
int shadowLength=10;


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
  savedTime = millis();

  smooth(); 
  colorMode(HSB, H_MAX, S_MAX, B_MAX);

  // Setup Box2d
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  shapes = new ArrayList<Shape>();
  box2d.listenForCollisions();

  // Setup Leap
  boundaries = new ArrayList<Boundary>();
  //boundaries.add(new Boundary(mouseX, mouseY, -1));
  leap = new LeapMotion(this); //<>//
  hands = new ArrayList<OscHand>();

  // Setup oscP5
  setupOsc();
}


// contact handler
void beginContact(Contact contact) {
  sendContact(contact); //osc
  //if(!isPulsing) pulseBackground(); //background change on contact
  for (Boundary a: boundaries)
  {
    if (contact.getFixtureA() ==  a.b.getFixtureList() || contact.getFixtureB() ==  a.b.getFixtureList())  //if one of the fixtures is the boundary
    {

      savedTime = millis();  //used for timing, switch back to original dhue
      dhue = 1;     
      if (avg_hue - cur_bkgrnd_hue < 0)  //the value of dhue is how fast color will change, the different signs are just for effect; too lazy to actually figure out why it does stuff cool
      {
        dhue *= -1;  //these can be changed to change the intensity of change
      }
      else
      {
        dhue *= -1;
      }
    }
  }
}

void draw() {
  synchronized (shapes) {
    //background(360, 0, 100);
    setBackground();
    pulseBackground();

    //Add Shapes Without PureData
    if (random(1) < 0.02 && boundaries.size() > 0) {
      Shape s;
      s = new NagonObject(width/2 + random(-100, 100), height+10, boundaries.get(boundaries.size() - 1).getHue(), random(0, 180), int(random(5))+3, numShadows, shadowLength);
      shapes.add(s);
    }

    //clear hands arraylist
    hands = new ArrayList<OscHand>();

    // step physics world
    box2d.step();

    // give all of the existing shapes gravity
    for (Shape s : shapes) {
      s.applyGravity();
    }

    // Display all shapes and shadows
    for (Shape b : shapes) {
      b.displayShadow();
    }

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
          if (hand.getPosition().z <=20) 
            delete =true;
          }
        } 
        if (delete) {
          boundary.destroy();
          boundaries.remove(i);
        }
      }

      if (debugFlag) debug.draw();
    }


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
      //keys 0-9
      if (key >=48 && key <= 57) {
        numShadows = (int) key - 48;
      }
      if (key == '-' || key == '_') shadowLength --;
      if (key == '=' || key == '+') shadowLength ++;
      if (key == 'm' || key == 'M' && !mouseMode)
      {
        mouseMode = true;
        boundaries.add(new Boundary(mouseX, mouseY, -1));
      }
      if (key == 'n' || key == 'N' && mouseMode)
      {
        mouseMode = false;
        for (Boundary b : boundaries)
          if (b.getId() == -1) {
            b.destroy();
            boundaries.remove(boundaries.indexOf(b));
            return;
          }
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
            boundary.move(hand_position.x, hand_position.y+80, angle); 
            created = true;
          }
        }
        if (!created) {
          boundaries.add(new Boundary(hand_position.x, hand_position.y+80, angle, hand_id));
        }
      }

      ArrayList<Finger> fingers = hand.getFingers();
      hands.add(new OscHand(hand, fingers));

      // FINGERS
      for (Finger finger : fingers) {

        // Basics
        finger.getPosition().z +=80;
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

      if (fingers.size() > 1) {
        PVector p1 = fingers.get(0).getPosition();
        PVector p2 = fingers.get(fingers.size() - 1).getPosition();

        forceMag = PVector.dist(p1, p2) / (width / 6.0);
      }
    }
  }
}

void leapOnInit(){
  // println("Leap Motion Init");
}
void leapOnConnect(){
  // println("Leap Motion Connect");
}
void leapOnFrame(){
  // println("Leap Motion Frame");
}
void leapOnDisconnect(){
  // println("Leap Motion Disconnect");
}
void leapOnExit(){
  // println("Leap Motion Exit");
}
