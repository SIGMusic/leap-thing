

float cur_bkgrnd_hue = 0;
int avg_hue = 0;
float dhue = .2; //how fast background changes
int savedTime; //used for pulsing

final int BACKGROUND_SATURATION = 100;
final int BACKGROUND_BRIGHTNESS = 60;

void setBackground() {  
  int total_hue = 0;
  //avg_hue;
  if (shapes.size() > 0) {
    for (Shape box : shapes) {
      total_hue += box.getHue();
    }
    avg_hue = total_hue/shapes.size();
  }
  
  if (avg_hue - cur_bkgrnd_hue < 0)
  {
    cur_bkgrnd_hue -= dhue;
  }
  else
  {
    cur_bkgrnd_hue += dhue;
  }
  while(cur_bkgrnd_hue < 0) cur_bkgrnd_hue += 360;
  background((cur_bkgrnd_hue)%360, BACKGROUND_SATURATION, BACKGROUND_BRIGHTNESS);
}

void pulseBackground()  //for the boundary+shape contact background pulse
{
 if(millis() - savedTime > 500)  //change back to original dhue after .5 seconds from collision
 {
     dhue = .2;
     //savedTime = millis();
 }
}

void sendBackgroundOSC() {
  // HSB
  OscMessage msg = new OscMessage("/background");
  synchronized(this) {
    msg.add(this.cur_bkgrnd_hue);
  }
  synchronized(this) {
    msg.add(this.avg_hue);
  }
  sendOSCMessage(msg);

  //RGB
  OscBundle bundle = new OscBundle();
  float[] rgb = HSBtoRGB(cur_bkgrnd_hue, BACKGROUND_SATURATION, BACKGROUND_BRIGHTNESS);
  msg = new OscMessage("/bgrgb/red");
  msg.add(rgb[0]);
  bundle.add(msg);
  msg = new OscMessage("/bgrgb/green");
  msg.add(rgb[1]);
  bundle.add(msg);
  msg = new OscMessage("/bgrgb/blue");
  msg.add(rgb[2]);
  bundle.add(msg);
  for (NetAddress address : addresses){
    oscP5.send(bundle,address); 
  }
}
