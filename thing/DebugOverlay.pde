import java.util.ArrayList;

public class DebugOverlay {
  private PFont f;
  
  public DebugOverlay()
  {
    f = createFont("Arial",16,true);
  }

  void draw() {
    textFont(f,16);
    fill(0, 100, 0);
    text("FPS: " + frameRate, 15, 15);
    text("Frames: " + frameCount, 15, 30);
    text("BPM: " + BPM, 15, 45);
  }
}
