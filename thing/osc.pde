import oscP5.*;
import netP5.*;

float BPM = 120.0;

OscP5 oscP5;
ArrayList<NetAddress> addresses;
OSCThread oscthread;

void setupOsc() {
  oscthread = new OSCThread();

  oscP5 = new OscP5(this, 13371);
  addresses = new ArrayList<NetAddress>();
  addresses.add(new NetAddress("127.0.0.1", 9433));
  addresses.add(new NetAddress("127.0.0.1", 9434));

  oscthread.start();
}

void sendOSCMessage(OscMessage message) {
  for (NetAddress address : addresses) {
    oscP5.send(message, address);
  }
}

class OSCThread extends Thread {
  public void run() {
    while (true) {
      // Send shapes
      ArrayList<Shape> clonedShapes;
      synchronized (shapes) {
        clonedShapes =  (ArrayList<Shape>)shapes.clone();
      }
      for (Shape shape : clonedShapes) {
        shape.sendOSC();
      }

      // Send boundaries
      ArrayList<Boundary> clonedBoundaries;
      synchronized(boundaries) {
        clonedBoundaries = (ArrayList<Boundary>)boundaries.clone();
      }
      for (Boundary boundary : clonedBoundaries) {
        boundary.sendOSC();
      }

      // send hands
      ArrayList<OscHand> clonedHands;
      synchronized(hands) {
        clonedHands = (ArrayList<OscHand>)hands.clone();
      }
      for (OscHand hand : clonedHands) {
        hand.sendOSC();
      }

      sendBackgroundOSC();

      try { 
        Thread.sleep(100L);
      } 
      catch (Exception e) {
      }
    }
  }
}

void sendContact(Contact contact) {
  OscMessage msg = new OscMessage("/contact");
  Fixture a = contact.getFixtureA();
  addFixture(msg, a);
  Fixture b = contact.getFixtureB();
  addFixture(msg, b);
  sendOSCMessage(msg);
}

void addFixture(OscMessage msg, Fixture f) {
  Body b = f.getBody();
  BodyType t = b.m_type;
  if (t == BodyType.KINEMATIC) {
    msg.add("Boundary");
    // find boundary
    for (Boundary boundary : boundaries) {
      if (boundary.hasBody(b)) {
        msg.add(boundary.id);
        // ...
      }
    }
  } 
  else {
    msg.add("Shape");
    // find shape
    for (Shape shape : shapes) {
      if (shape.hasBody(b)) {
        msg.add(shape.getId());
        shape.setSaturation(100);
        shape.setBrightness(100);
        // ...
      }
    }
  }
}

void oscEvent(OscMessage msg) {
  synchronized (this) {
    try {
      if (!(frameRate > 58.0 && shapes.size() < 10) && (frameRate < 50.0 || random(1) > 1 / 5.0))
        return;
      int channel = msg.get(0).intValue();
      int midi = msg.get(1).intValue();
      int velocity = msg.get(2).intValue();
      float bpm = msg.get(3).floatValue();
      BPM = max(50.0, bpm);
      if (midi != 0) {
        Shape s;
        float width_height = max(40, min(4 * (80 - midi), 100));
        if (boundaries.size() > 0)
          s = new NagonObject(width_height,width_height,random(0, width), height+5, boundaries.get(boundaries.size() - 1).getHue(), random(0, 180), int(random(5))+3, numShadows, shadowLength, BPM / 14.0);
        else
          s = new NagonObject(width_height,width_height,random(0, width), height+5, color(0, 0, 255), random(0, 180), int(random(5))+3, numShadows, shadowLength, BPM / 14.0);

        synchronized (shapes) {
          shapes.add(s);
        }
      }
    } 
    catch (Exception e) {
      // don't worry about it
    }
  }
  println(msg);
}

