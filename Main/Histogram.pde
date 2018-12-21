public class Histogram extends RectElement {
  float[] values;
  float[] normalizedValues;
  float barWidth;
  
  public Histogram(int x, int y, int width, int height, float[] values) {
    super(x, y, width, height);
    this.values = values;
    this.normalizedValues = new float[this.values.length];
    for (int i = 0; i < this.values.length; i++) {
      this.normalizedValues[i] = this.values[i] / max(this.values);
    }
    this.barWidth = this.width / (float)(this.values.length);
  }
  
  protected void drawBar(int i) {
    rect(this.x + i * barWidth, this.y + this.height * (1 - this.normalizedValues[i]) , barWidth, this.height * this.normalizedValues[i]);
  }
  
  public void draw(float minThreshold, float maxThreshold) {
    drawBorder(1);
    for (int i = 0; i < this.values.length; i++) {
      if (i <= minThreshold * this.values.length) {
        fill(180, 180, 180);
      }
      else if (i < maxThreshold * this.values.length) {
        fill(90, 220, 90);
      }
      else {
        fill(180, 180, 180);
      }
      drawBar(i);
    }
  }
  
}
