public class Map extends RectElement {
  ArrayList<City> cities;
  City focusedCity;
  City selectedCity;
  
  private float zoom;
  private float zoomSpeed;
  private float centerX;
  private float centerY;
  
  public Map(int x, int y, int width, int height, ArrayList<City> cities) {
    super(x, y, width, height);
    this.cities = cities;
    this.focusedCity = null;
    this.selectedCity = null;
    this.zoom = 1;
    this.zoomSpeed = 0.1;
    this.centerX = 0.5;
    this.centerY = 0.5;
  }
  
  private boolean isMouseOnCity(City city) {
    int[] position = convertPosition(city.normX, city.normY);
    return dist(position[0], position[1], mouseX, mouseY) <= city.getRadius() * this.zoom;
  }
  
  private City getCityMouseIsOn(float minPopulationToDisplay, float maxPopulationToDisplay, float minDensityToDisplay, float maxDensityToDisplay) {
    for (int i = cities.size() - 1; i >= 0; i--) {
      City city = cities.get(i);
      if (minPopulationToDisplay <= city.population && city.population <= maxPopulationToDisplay && minDensityToDisplay <= city.density && city.density <= maxDensityToDisplay) {
        if (isMouseOnCity(city)) {
          return city;
        }
      }
    }
    return null;
  }
  
  public City mouseMoved(float minPopulationToDisplay, float maxPopulationToDisplay, float minDensityToDisplay, float maxDensityToDisplay) {
    this.focusedCity = getCityMouseIsOn(minPopulationToDisplay, maxPopulationToDisplay, minDensityToDisplay, maxDensityToDisplay);
    return this.focusedCity;
  }
  
  public City mousePressed(float minPopulationToDisplay, float maxPopulationToDisplay, float minDensityToDisplay, float maxDensityToDisplay) {
    if (this.selectedCity != null && isMouseOnCity(this.selectedCity)) {
      this.selectedCity = null;
    }
    else {
      City clickedCity = getCityMouseIsOn(minPopulationToDisplay, maxPopulationToDisplay, minDensityToDisplay, maxDensityToDisplay);
      if (clickedCity != null)
        this.selectedCity = clickedCity;
    }
    return this.selectedCity;
  }
  
  public void keyPressed() {
    if (key == ENTER || key == RETURN) {
      if (this.selectedCity != null)
        link("https://fr.wikipedia.org/wiki/" + this.selectedCity.name);
    }
  }
  
  public void zoom(float amount) {
    float mouseNormX = ((mouseX - this.x) / (float)this.width);
    float mouseNormY = ((mouseY - this.y) / (float)this.height);
    if (0 < mouseNormX && mouseNormX < 1 && 0 < mouseNormY && mouseNormY < 1) {
      float[] test = convertZoom(mouseNormX, mouseNormY, this.zoom);
      float x = this.centerX + (test[0] - this.centerX) / this.zoom;
      float y = this.centerY + (test[1] - this.centerY) / this.zoom;
      this.zoom = constrain(this.zoom + amount * this.zoomSpeed, 1, 10);
      this.centerX = x;
      this.centerY = y;
    }
  }
  
  private float[] convertZoom(float normX, float normY, float zoom) {
    float x = this.centerX + (normX - this.centerX) * zoom;
    float y = this.centerY + (normY - this.centerY) * zoom;
    float[] position = {x, y};
    return position;
  }
  
  private int[] convertPosition(float normX, float normY) {
    float[] zoomedNorm = convertZoom(normX, normY, this.zoom);
    float x = this.x + 10 + zoomedNorm[0] * (this.width - 20);
    float y = this.y + 10 + zoomedNorm[1] * (this.height - 20);
    int[] position = {(int)x, (int)y};
    return position;
  }
  
  public int draw(float minPopulationToDisplay, float maxPopulationToDisplay, float minDensityToDisplay, float maxDensityToDisplay) {
    ArrayList<City> visibleCities = new ArrayList<City>();
    ArrayList<int[]> visibleCitiesParams = new ArrayList<int[]>();
    drawBorder(5);
    for (City city : this.cities) {
      if (city != this.focusedCity && city != this.selectedCity) {
        if (minPopulationToDisplay <= city.population && city.population <= maxPopulationToDisplay && minDensityToDisplay <= city.density && city.density <= maxDensityToDisplay) {
          int[] position = convertPosition(city.normX, city.normY);
          if (this.x < position[0] - city.getRadius() * this.zoom && position[0] + city.getRadius() * this.zoom < this.x + this.width &&
          this.y < position[1] - city.getRadius() * this.zoom && position[1] + city.getRadius() * this.zoom < this.y + this.height) {
            visibleCities.add(city);
            int[] params = new int[]{position[0], position[1], 0};
            visibleCitiesParams.add(params);
          }
        }
      }
    }
    if (this.selectedCity != null) {
      int[] position = convertPosition(this.selectedCity.normX, this.selectedCity.normY);
      this.selectedCity.draw(position[0], position[1], this.zoom, 2);
      visibleCities.add(this.selectedCity);
      int[] params = new int[]{position[0], position[1], 2};
      visibleCitiesParams.add(params);
    }
    if (this.focusedCity != null && this.selectedCity != this.focusedCity &&
    minPopulationToDisplay <= this.focusedCity.population && this.focusedCity.population <= maxPopulationToDisplay &&
    minDensityToDisplay <= this.focusedCity.density && this.focusedCity.density <= maxDensityToDisplay) {
      int[] position = convertPosition(this.focusedCity.normX, this.focusedCity.normY);
      visibleCities.add(this.focusedCity);
      int[] params = new int[]{position[0], position[1], 1};
      visibleCitiesParams.add(params);
    }
    
    noStroke();
    for (int i = 0; i < visibleCitiesParams.size(); i++) {
      float altitudeFactor = log(1 + visibleCities.get(i).altitude) / log(1 + Stats.maxAltitude);
      color lowAltitude = color(130, 130, 130);
      color highAltitude = color(230, 230, 230);
      fill(lerpColor(lowAltitude, highAltitude, altitudeFactor));
      ellipse(visibleCitiesParams.get(i)[0], visibleCitiesParams.get(i)[1], 10 * zoom, 10 * zoom);
    }
    for (int i = 0; i < visibleCities.size(); i++) {
      visibleCities.get(i).draw(visibleCitiesParams.get(i)[0], visibleCitiesParams.get(i)[1], this.zoom, visibleCitiesParams.get(i)[2]);
    }
    
    return visibleCities.size();
  }
  
}
