public class Map extends RectElement {
  ArrayList<City> cities;
  City focusedCity;
  City selectedCity;
  
  public Map(int x, int y, int width, int height, ArrayList<City> cities) {
    super(x, y, width, height);
    this.cities = cities;
    this.focusedCity = null;
    this.selectedCity = null;
  }
  
  private boolean isMouseOnCity(City city) {
    return dist(this.x + city.normX * this.width, this.y + city.normY * this.height, mouseX, mouseY) <= city.getRadius();
  }
  
  private City getCityMouseIsOn() {
    for (int i = cities.size() - 1; i >= 0; i--) {
      City city = cities.get(i);
      if (isMouseOnCity(city)) {
        return city;
      }
    }
    return null;
  }
  
  public void mouseMoved() {
    this.focusedCity = getCityMouseIsOn();
  }
  
  public void mousePressed() {
    this.selectedCity = getCityMouseIsOn();
  }
  
  /*
  Idea:
  Take every pair of cities, calculate the distance between them and the middle point
  then place a thing there with interesting stuff:
    density difference over distance
    population difference over distance
  */
  
  public void draw(float minSurfaceToDisplay, float maxSurfaceToDisplay) {
    for (City city : this.cities) {
      if (city != this.focusedCity) {
        if (minSurfaceToDisplay <= city.surface && city.surface <= maxSurfaceToDisplay) {
          city.draw(this.x, this.y, this.width, this.height, 0);
        }
      }
    }
    if (this.focusedCity != null)
      this.focusedCity.draw(this.x, this.y, this.width, this.height, 1);
    if (this.selectedCity != null)
      this.selectedCity.draw(this.x, this.y, this.width, this.height, 2);
  }
  
}
