public class City {
  int postalCode;
  float x;
  float normX;
  float y;
  float normY;
  String name;
  int population; // inhabitants
  float surface; // km^2
  int altitude; // m
  float density; // inhabitants / m^2
  
  public City(int postalCode, float x, float y, String name, int population, float surface, int altitude) {
    this.postalCode = postalCode;
    
    this.x = x;
    this.normX = map(x, Stats.minX, Stats.maxX, 0, 1);
    this.y = y;
    this.normY = map(y, Stats.minY, Stats.maxY, 1, 0);
    
    this.name = name;
    this.population = population;
    this.surface = surface;
    this.altitude = altitude;
    this.density = this.population / this.surface;
    
    if (this.normX < Stats.minNormX)
      Stats.minNormX = this.normX;
    if (this.normX > Stats.maxNormX)
      Stats.maxNormX = this.normX;
    if (this.normY < Stats.minNormY)
      Stats.minNormY = this.normY;
    if (this.normY > Stats.maxNormY)
      Stats.maxNormY = this.normY;
    if (this.density < Stats.minDensity)
      Stats.minDensity = this.density;
    if (this.density > Stats.maxDensity)
      Stats.maxDensity = this.density;
  }
  
  private float getRadius() {
    return this.density / 250.0;
  }
  
  private color getColor() {
    float gradient = this.altitude / Stats.maxAltitude;
    return lerpColor(color(20, 255, 20, 200), color(255, 20, 20, 200), gradient);
  }
  
  public void draw(int mapX, int mapY, int mapWidth, int mapHeight, int importance) {
    int x = (int) (mapX + this.normX * mapWidth);
    int y = (int) (mapY + this.normY * mapHeight);
    float size = this.getRadius() * 2;
    fill(this.getColor());
    if (importance == 0) {
      stroke(0, 0, 0);
      strokeWeight(1);
    }
    else if (importance == 1) {
      stroke(255, 0, 0);
      strokeWeight(2);
    }
    else if (importance == 2) {
      stroke(0, 0, 255);
      strokeWeight(4);
    }
    ellipse(x, y, size, size);
  }
  
}
