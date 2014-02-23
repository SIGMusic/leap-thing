import oscP5.*;
import netP5.*;

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
        // ...
      }
    }
  }
}

void oscEvent(OscMessage msg) {
  synchronized(shapes) {
    if (msg.checkAddrPattern("/percussion")) {
     // shapes.add(new NagonObject(width/2, height/2, boundaries.get(boundaries.size() - 1).getHue(), random(0, 180), int(random(5))+3));
    } 
    else if (msg.checkAddrPattern("/minstruments")) {
      float midi = msg.get(1).floatValue();
      if (midi != 0.0)
        shapes.add(new Circle(random(0,width), random(0,height), Math.min(Math.max(int(90-midi)*2,5),30), boundaries.get(boundaries.size() - 1).getHue(), random(0, 180)));
    } 
    System.out.println("### received OscMessage with pattern " + msg.addrPattern());
  }
}
