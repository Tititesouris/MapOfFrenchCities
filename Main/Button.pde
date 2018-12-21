abstract class Button extends RectElement {
  String text;
  boolean hover;
  
  public Button(int x, int y, int width, int height, String text) {
    super(x, y, width, height);
    this.text = text;
    this.hover = false;
  }
  
  public abstract void onClick();
  
  private boolean isMouseOnButton() {
    return this.x < mouseX && mouseX < this.x + this.width && this.y < mouseY && mouseY < this.y + this.height;
  }
  
  public void mouseMoved() {
    this.hover = isMouseOnButton();
  }
  
  public void mouseReleased() {
    if (isMouseOnButton())
      onClick();
  }
  
  
  public void draw() {
    if (this.hover) {
      drawBackground(color(200, 255, 200));
    }
    drawBorder(3);
    
    fill(0, 0, 0);
    textAlign(CENTER);
    textSize(22);
    text(this.text, this.x + this.width / 2, this.y + this.height / 2 + 8);
  }
  
}
