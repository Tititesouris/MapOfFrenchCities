public class Histogram extends RectElement {
  float[] values;
  float[] normalizedValues;
  float barWidth;
  
  public Histogram(int x, int y, int width, int height, float[] values) {
    super(x, y, width, height);
    this.values = values;
    this.normalizedValues = new float[this.values.length];
    for (int i = 0; i < this.values.length; i++) {
      println(this.height * this.values[i] / max(this.values));
      this.normalizedValues[i] = this.values[i] / max(this.values);
    }
    this.barWidth = this.width / (float)(this.values.length);
  }
  
  protected void drawBar(int i) {
    rect(this.x + i * barWidth, this.y + this.height * (1 - this.normalizedValues[i]) , barWidth, this.height * this.normalizedValues[i]);
  }
  
  public void draw(float minThreshold, float maxThreshold) {
    stroke(0, 0, 0);
    strokeWeight(1);
    fill(200, 200, 200);
    rectMode(CORNER);
    rect(this.x, this.y, this.width, this.height);
    for (int i = 0; i < this.values.length; i++) {
      if (i <= minThreshold) {
        fill(50, 255, 50);
      }
      else if (i <= maxThreshold) {
        fill(50, 50, 255);
      }
      else {
        fill(255, 50, 50);
      }
      drawBar(i);
    }
  }
  
}
