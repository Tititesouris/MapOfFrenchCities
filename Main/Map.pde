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
    this.zoomSpeed = 0.05;
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
  
  public void zoom(float amount) {
    float mouseNormX = ((mouseX - this.x) / (float)this.width);
    float mouseNormY = ((mouseY - this.y) / (float)this.height);
    if (0 < mouseNormX && mouseNormX < 1 && 0 < mouseNormY && mouseNormY < 1) {
      float[] test = convertZoom(mouseNormX, mouseNormY, this.zoom);
      float x = this.centerX + (test[0] - this.centerX) / this.zoom;
      float y = this.centerY + (test[1] - this.centerY) / this.zoom;
      //println(x, y); TODO: fix zoom
      this.zoom = constrain(this.zoom + amount * this.zoomSpeed, 1, 5);
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
    float x = this.x + zoomedNorm[0] * this.width;
    float y = this.y + zoomedNorm[1] * this.height;
    int[] position = {(int)x, (int)y};
    return position;
  }
  
  public void draw(float minPopulationToDisplay, float maxPopulationToDisplay, float minDensityToDisplay, float maxDensityToDisplay) {
    drawBorder(5);
    for (City city : this.cities) {
      if (city != this.focusedCity && city != this.selectedCity) {
        if (minPopulationToDisplay <= city.population && city.population <= maxPopulationToDisplay && minDensityToDisplay <= city.density && city.density <= maxDensityToDisplay) {
          int[] position = convertPosition(city.normX, city.normY);
          if (this.x < position[0] - city.getRadius() * this.zoom && position[0] + city.getRadius() * this.zoom < this.x + this.width &&
          this.y < position[1] - city.getRadius() * this.zoom && position[1] + city.getRadius() * this.zoom < this.y + this.height)
            city.draw(position[0], position[1], this.zoom, 0);
        }
      }
    }
    if (this.focusedCity != null &&
    minPopulationToDisplay <= this.focusedCity.population && this.focusedCity.population <= maxPopulationToDisplay &&
    minDensityToDisplay <= this.focusedCity.density && this.focusedCity.density <= maxDensityToDisplay) {
      int[] position = convertPosition(this.focusedCity.normX, this.focusedCity.normY);
      this.focusedCity.draw(position[0], position[1], this.zoom, 1);
    }
    if (this.selectedCity != null) {
      int[] position = convertPosition(this.selectedCity.normX, this.selectedCity.normY);
      this.selectedCity.draw(position[0], position[1], this.zoom, 2);
    }
  }
  
}
