import java.util.ArrayList;

public class DebugOverlay {
  private PFont f;
  
  public DebugOverlay()
  {
    f = createFont("Arial",16,true);
  }
  //private LeapMotionP5 leap;
//  public DebugOverlay(ProcessingThing pt, LeapMotionP5 leap) {
//    this.pt = pt;
//    this.leap = leap;
//  }

void draw() {
  textFont(f,16);
  fill(100, 120, 70);
  text("FPS: " + frameRate, 15, 15);
  text("Frames: " + frameCount, 15, 30);
  //text("Hand Information: \n" + getHandInfo(), 15, 45);
}
  
  public String getHandInfo() {
    StringBuilder sb = new StringBuilder();
    //ArrayList<Hand> hands = leap.getHandList();
//    for(Hand h : hands) {
//      sb.append("Hand " + h.id() + ":\n");
//      for(Finger f : h.fingers()) {
//        sb.append("\tFinger " + f.id() + "@ (" + f.tipPosition().getX() + "," + f.tipPosition().getY() + ")\n");
//      }
    //}
    return sb.toString();
  }
}
