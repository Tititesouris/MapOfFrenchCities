public class Histogram {
  int x;
  int y;
  int width;
  int height;
  float[] values;
  
  public Histogram(int x, int y, int width, int height, float[] values) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.values = values;
  }
  
  protected void drawBar(float leftX, float rightX, float bottomY, float value) {
    fill(255, 50, 50);
    rect(leftX, bottomY - (value * this.height), rightX, bottomY);
  }
  
  public void draw() {
    stroke(0, 0, 0);
    fill(200, 200, 200);
    rect(this.x, this.y, this.x + this.width, this.y + this.height);
    float barWidth = this.width / (float)this.values.length;
    for (int i = 0; i < this.values.length; i++) {
      drawBar(this.x + i * barWidth, this.x + min(this.width, (i + 1) * barWidth), this.y + this.height, values[i]);
    }
  }
  
}
