

float cur_bkgrnd_hue = 0;
int avg_hue = 0;

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
    cur_bkgrnd_hue -= .2;
  else
    cur_bkgrnd_hue += .2;
  //System.out.println(cur_bkgrnd_hue%360);
  background((cur_bkgrnd_hue)%360, BACKGROUND_SATURATION, BACKGROUND_BRIGHTNESS);
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
  msg = new OscMessage("/backgroundrgb");
  float[] rgb = HSBtoRGB(cur_bkgrnd_hue, BACKGROUND_SATURATION, BACKGROUND_BRIGHTNESS);
  msg.add(rgb[0]);
  msg.add(rgb[1]);
  msg.add(rgb[2]);
  rgb = HSBtoRGB(avg_hue, BACKGROUND_SATURATION, BACKGROUND_BRIGHTNESS);
  msg.add(rgb[0]);
  msg.add(rgb[1]);
  msg.add(rgb[2]);
  sendOSCMessage(msg);
}

