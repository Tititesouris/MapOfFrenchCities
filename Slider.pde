public class Slider {
  int x;
  int y;
  int width;
  int height;
  float value;
  boolean focused;
  int cursorWidth;
  int cursorHeight;
  
  public Slider(int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.focused = false;
    this.cursorWidth = 10;
    this.cursorHeight = this.height;
  }
  
  public float getValue() {
    return this.value;
  }
  
  private boolean isMouseOver() {
    return this.x - (this.cursorWidth / 2) <= mouseX && mouseX <= this.x + this.width + (this.cursorWidth / 2) && this.y <= mouseY && mouseY <= this.y + this.height;
  }
  
  private void updateValue() {
    this.value = min(1, max(0, (mouseX - this.x) / (float)this.width));
  }
  
  void mousePressed() {
    if (isMouseOver()) {
      this.focused = true;
      this.updateValue();
    }
  }
  
  void mouseDragged() {
    if (this.focused) {
      this.updateValue();
    }
  }
  
  void mouseReleased() {
    this.focused = false;
  }
  
  public void draw() {
    stroke(0, 0, 0);
    line(this.x, this.y + this.height / 2, this.x + this.width, this.y + this.height / 2);
    fill(200, 200, 200);
    rect(this.x + this.value * this.width - this.cursorWidth / 2, this.y + (this.height - this.cursorHeight) / 2, this.cursorWidth, this.cursorHeight);
  }
  
}
