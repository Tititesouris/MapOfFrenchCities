public class RectElement {
  int x;
  int y;
  int width;
  int height;
  
  public RectElement(int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
  
  protected void drawBorder(int thickness) {
    stroke(0, 0, 0);
    strokeWeight(thickness);
    noFill();
    rectMode(CORNER);
    rect(this.x, this.y, this.width, this.height);
  }
  
  protected void drawBackground(color c) {
    noStroke();
    fill(c);
    rectMode(CORNER);
    rect(this.x, this.y, this.width, this.height);
  }
  
}
