ArrayList<City> cities = new ArrayList<City>();
City selectedCity = null;
Map map = null;
Histogram surfaceHistogram = null;
Slider maxSurfaceSlider = null;
Slider minSurfaceSlider = null;

void parseHeader(String line) {
  String infoString = line.substring(2); // remove the #
  String[] data = split(infoString, ',');
  Stats.nbCities = int(data[0]);
  Stats.minX = float(data[1]);
  Stats.maxX = float(data[2]);
  Stats.minY = float(data[3]);
  Stats.maxY = float(data[4]);
  Stats.minPopulation = int(data[5]);
  Stats.maxPopulation = int(data[6]);
  Stats.minSurface = float(data[7]);
  Stats.maxSurface = float(data[8]);
  Stats.minAltitude = int(data[9]);
  Stats.maxAltitude = int(data[10]);
  Stats.minNormX = 1;
  Stats.maxNormX = 0;
  Stats.minNormY = 1;
  Stats.maxNormY = 0;
  Stats.minDensity = 999999;
  Stats.maxDensity = 0;
}

City parseCity(String line) {
  String[] data = split(line, TAB);
  return new City(int(data[0]), float(data[1]), float(data[2]), data[4], int(data[5]), float(data[6]), int(data[7]));
}

void parseCities(String[] lines) {
  for (int i = lines.length - Stats.nbCities; i < Stats.nbCities; i++) {
    City city = parseCity(lines[i]);
    cities.add(city);
  }
  map = new Map(50, 50, 800, 800, cities);
}

void readData() {
  String[] lines = loadStrings("cities.tsv");
  parseHeader(lines[0]);
  parseCities(lines);
}

void setupHistograms() {
  int nbBins = 500;
  float[] surfaces = new float[nbBins];
  for (int i = cities.size() - 1; i >= 0; i--) {
    City city = cities.get(i);
    surfaces[floor((nbBins - 1) * city.surface / Stats.maxSurface)] += 1;
  }
  surfaceHistogram = new Histogram(20, height - 110, width - 40, 100, surfaces);
}

void setupSliders() {
  maxSurfaceSlider = new Slider(20, height - 100, width - 40, 25, 10, 25, 1, Stats.minSurface, Stats.maxSurface);
  minSurfaceSlider = new Slider(20, height - 45, width - 40, 25, 10, 25, 0.2, Stats.minSurface, Stats.maxSurface);
}

void setup() {
  readData();
  size(1792, 1008);
  setupHistograms();
  setupSliders();
}

void mouseMoved() {
  map.mouseMoved();
}

void mousePressed() {
  map.mousePressed();
  maxSurfaceSlider.mousePressed();
  minSurfaceSlider.mousePressed();
}

void mouseDragged() {
  maxSurfaceSlider.mouseDragged();
  minSurfaceSlider.mouseDragged();
}

void mouseReleased() {
  maxSurfaceSlider.mouseReleased();
  minSurfaceSlider.mouseReleased();
}

void draw() {
  background(255, 255, 255);

  float maxSurfaceToDisplay = maxSurfaceSlider.getRealValue();
  float minSurfaceToDisplay = minSurfaceSlider.getRealValue();
  map.draw(minSurfaceToDisplay, maxSurfaceToDisplay);
  
  surfaceHistogram.draw(minSurfaceToDisplay, maxSurfaceToDisplay);
  maxSurfaceSlider.draw();
  minSurfaceSlider.draw();
  
  textSize(13);
  fill(0, 0, 0);
  textAlign(LEFT);
  text("Number of cities by surface (km²)", 20, height - 115);
}
