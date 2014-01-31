public class Mouse {
  private PApplet parent;

  public Mouse(PApplet parent) {
    this.parent = parent;
  }

  public void draw(float radius) {
    this.parent.ellipse(mouseX, mouseY, radius, radius);
  }

  public void draw() {
    this.draw(5.0);
  }
} 

