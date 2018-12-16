public class Slider extends RectElement {
  int cursorWidth;
  int cursorHeight;
  float value;
  float realMinValue;
  float realMaxValue;
  boolean logarithmic;
  boolean focused;
  
  public Slider(int x, int y, int width, int height, int cursorWidth, int cursorHeight, float defaultValue, float realMinValue, float realMaxValue, boolean logarithmic) {
    super(x, y, width, height);
    this.cursorWidth = cursorWidth;
    this.cursorHeight = cursorHeight;
    this.value = defaultValue;
    this.realMinValue = realMinValue;
    this.realMaxValue = realMaxValue;
    this.logarithmic = logarithmic;
    this.focused = false;
  }
  
  public float getValue() {
    return this.value;
  }
  
  public float getRealValue() {
    if (logarithmic) {
      return pow(2, log(this.realMinValue) + this.value * (log(this.realMaxValue) - log(this.realMinValue)));
    }
    return this.realMinValue + this.value * (this.realMaxValue - this.realMinValue);
  }
  
  private boolean isMouseOver() {
    return this.x - (this.cursorWidth / 2) <= mouseX && mouseX <= this.x + this.width + (this.cursorWidth / 2) && this.y <= mouseY && mouseY <= this.y + this.height;
  }
  
  private void updateValue() {
    this.value = constrain((mouseX - this.x) / (float)this.width, 0, 1);
  }
  
  public void mousePressed() {
    if (isMouseOver()) {
      this.focused = true;
      this.updateValue();
    }
  }
  
  public void mouseDragged() {
    if (this.focused) {
      this.updateValue();
    }
  }
  
  public void mouseReleased() {
    this.focused = false;
  }
  
  public void draw() {
    textSize(12);
    stroke(0, 0, 0, 50);
    strokeWeight(1);
    line(this.x, this.y + this.height / 2, this.x + this.width, this.y + this.height / 2);
    noFill();
    stroke(0, 0, 0, 255);
    float cursorX = this.x + this.value * this.width - this.cursorWidth / 2;
    float cursorY = this.y + (this.height - this.cursorHeight) / 2;
    rect(cursorX, cursorY, this.cursorWidth, this.cursorHeight);
    fill(0, 0, 0);
    textAlign(CENTER);
    text(this.getRealValue(), cursorX, cursorY - 5);
  }
  
}
