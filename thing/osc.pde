import oscP5.*;
import netP5.*;

OscP5 oscP5;
ArrayList<NetAddress> addresses;

void setupOsc() {
  oscP5 = new OscP5(this, 13371);
  addresses = new ArrayList<NetAddress>();
}

void sendOSCMessage(OscMessage message){
   for (NetAddress address : addresses){
      oscP5.send(message, address);
   } 
}
