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
  sendOSCMessage(msg);
}
