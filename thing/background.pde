float cur_bkgrnd_hue = 0;

void setBackground() {  
  int total_hue = 0;
  int avg_hue = 0;
  if(boxes.size() > 0){
    for(Box box : boxes){
        total_hue += box.getHue();
    }
    avg_hue = total_hue/boxes.size();
  }
  if(avg_hue - cur_bkgrnd_hue < 0)
     cur_bkgrnd_hue -= .2;
  else
     cur_bkgrnd_hue += .2;
  //System.out.println(cur_bkgrnd_hue%360);
  background((cur_bkgrnd_hue)%360, 100, 60);
}
