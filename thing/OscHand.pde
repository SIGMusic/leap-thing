class OscHand {
  Hand hand;
  ArrayList<Finger> fingers;

  OscHand(Hand _hand, ArrayList<Finger> _fingers) {
    this.hand = _hand;
    this.fingers = _fingers;
  }

  void sendOSC() {
    // hand
    OscMessage msg = new OscMessage("/hand");
    msg.add(this.hand.getId());
    msg.add(this.hand.getPosition().x);
    msg.add(this.hand.getPosition().y);
    msg.add(this.hand.getStabilizedPosition().x); 
    msg.add(this.hand.getStabilizedPosition().y);   
    msg.add(this.hand.getDirection().x);
    msg.add(this.hand.getDirection().y);
    msg.add(this.hand.getRoll());
    msg.add(this.hand.getPitch());
    msg.add(this.hand.getYaw());
    msg.add(this.hand.getTimeVisible());
    msg.add(this.hand.getSpherePosition().x);
    msg.add(this.hand.getSpherePosition().y);
    msg.add(this.hand.getSphereRadius());
    
    sendOSCMessage(msg);
    
    // fingers
    for (Finger finger : this.fingers){
       msg = new OscMessage("/finger");
       msg.add(this.hand.getId());
       msg.add(finger.getId());
       msg.add(finger.getPosition().x);
       msg.add(finger.getPosition().y);
       // ...
       sendOSCMessage(msg);
    }
  }
}
