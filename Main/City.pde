public class City implements Comparable<City> {
  int postalCode;
  float x;
  float normX;
  float y;
  float normY;
  String name;
  int population; // inhabitants
  float surface; // km^2
  int altitude; // m
  float density; // inhabitants / km^2
  
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
    this.density = (this.surface > 0) ? this.population / this.surface : 0;
    
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
  
  public String[][] getDescription(City comparedCity) {
    color[] colors = {color(255, 20, 20, 255), color(20, 20, 255, 255), color(20, 255, 20, 255)};
    color populationColor = (comparedCity != null) ? colors[1 + (int)(constrain(this.population - comparedCity.population, -1, 1))] : color(0, 0, 0, 0);
    color surfaceColor = (comparedCity != null) ? colors[1 + (int)(constrain(this.surface - comparedCity.surface, -1, 1))] : color(0, 0, 0, 0);
    color altitudeColor = (comparedCity != null) ? colors[1 + (int)(constrain(this.altitude - comparedCity.altitude, -1, 1))] : color(0, 0, 0, 0);
    color densityColor = (comparedCity != null) ? colors[1 + (int)(constrain(this.density - comparedCity.density, -1, 1))] : color(0, 0, 0, 0);
    String[][] description = {
      {"Name:", this.name, hex(color(0, 0, 0, 0))},
      {"Postal Code:", "" + this.postalCode, hex(color(0, 0, 0, 0))},
      {"Population:", "" + this.population, hex(populationColor)},
      {"Surface:", this.surface + " km²", hex(surfaceColor)},
      {"Altitude:", this.altitude + " m", hex(altitudeColor)},
      {"Density:", this.density + " / km²", hex(densityColor)}
    };
    return description;
  }
  
  @Override
  public int compareTo(City city) {
    if (city.population > this.population) {
      return 1;
    }
    if (city.population < this.population) {
      return -1;
    }
    return 0;
  }
  
  private float getRadius() {
    return max(0.75, sqrt(this.population / 1000.0));
  }
  
  private color getColor() {
    float gradient = log(1 + this.density) / log(1 + Stats.maxDensity);
    return lerpColor(color(20, 255, 20, 180), color(255, 20, 20, 180), gradient);
  }
  
  public void draw(int x, int y, float zoom, int importance) {
    float size = this.getRadius() * 2 * zoom;
    fill(this.getColor());
    if (importance > 0) {
      stroke(50, 50, 220);
      strokeWeight(1 + (importance - 1) * 2);
    }
    rectMode(CENTER);
    ellipse(x, y, size, size);
    rectMode(CORNER);
    if (importance > 0) {
      noStroke();
      float textWidth = textWidth(this.name) + 5;
      fill(255, 255, 255, 150);
      rect(x - textWidth / 2, y - 30, textWidth, 15);
      fill(0, 0, 0);
      textSize(12);
      textAlign(CENTER);
      text(this.name, x, y - 18);
    }
  }
  
}
