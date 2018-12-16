public class TextPanel extends RectElement {
  String title;
  String[][] text;
  
  
  public TextPanel(int x, int y, int width, int height, String title, String[][] text) {
    super(x, y, width, height);
    this.title = title;
    this.text = text;
  }
  
  public void setText(String[][] text) {
    this.text = text;
  }
  
  public void draw() {
    drawBorder(2);
    textSize(20);
    textAlign(CENTER);
    fill(0, 0, 0);
    text(this.title, this.x + this.width / 2, this.y + 20);
    textSize(14);
    for (int i = 0; i < this.text.length; i++) {
      fill(0, 0, 0);
      textAlign(LEFT);
      text(this.text[i][0], this.x + 5, this.y + 22 * (i + 2));
      textAlign(RIGHT);
      fill(unhex(this.text[i][2]));
      println();
      text(this.text[i][1], this.x + this.width - 5, this.y + 22 * (i + 2));
    }
  }
  
}
