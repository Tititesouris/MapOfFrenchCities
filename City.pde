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
  
  public boolean contains(float x, float y) {
    return dist(this.normX * width, this.normY * height, x, y) <= getRadius();
  }
  
  /*
  Idea:
  Take every pair of cities, calculate the distance between them and the middle point
  then place a thing there with interesting stuff:
    density difference over distance
    population difference over distance
  */
  
  public void draw(boolean selected) {
    int x = (int) (this.normX * width);
    int y = (int) (this.normY * height);
    float size = getRadius() * 2;
    float gradient = this.altitude / Stats.maxAltitude;
    color c = lerpColor(color(20, 255, 20), color(255, 20, 20), gradient);
    fill(c);
    if (selected) {
      stroke(2);
    }
    else {
      noStroke();
    }
    ellipse(x, y, size, size);
  }
  
}
