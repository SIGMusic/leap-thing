import oscP5.*;
import netP5.*;

OscP5 oscP5;
ArrayList<NetAddress> addresses;

void setupOsc() {
  oscP5 = new OscP5(this, 13371);
  addresses = new ArrayList<NetAddress>();
  addresses.add(new NetAddress("127.0.0.1", 9433));
  addresses.add(new NetAddress("127.0.0.1", 9434));
}

void sendOSCMessage(OscMessage message) {
  for (NetAddress address : addresses) {
    oscP5.send(message, address);
  }
}

