import java.util.Collections;

ArrayList<City> cities = new ArrayList<City>();
City selectedCity = null;
Map map = null;
Histogram populationHistogram = null;
Slider maxPopulationSlider = null;
Slider minPopulationSlider = null;
Histogram densityHistogram = null;
Slider maxDensitySlider = null;
Slider minDensitySlider = null;
TextPanel selectedCityPanel = null;
TextPanel focusedCityPanel = null;
int padding = 10;
int[] filterZone = null;

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
  map = new Map(padding, padding, 700, 700, cities);
}

void readData() {
  String[] lines = loadStrings("cities.tsv");
  parseHeader(lines[0]);
  parseCities(lines);
  Collections.sort(cities);
}

void setupHistograms() {
  int nbBins = 100;
  float[] populations = new float[nbBins];
  float[] densities = new float[nbBins];
  for (int i = cities.size() - 1; i >= 0; i--) {
    City city = cities.get(i);
    populations[floor((nbBins - 1) * log(1 + city.population) / log(1 + Stats.maxPopulation))] += 1;
    densities[floor((nbBins - 1) * log(1 + city.density) / log(1 + Stats.maxDensity))] += 1;
  }
  populationHistogram = new Histogram(filterZone[0], filterZone[1], filterZone[2], filterZone[3], populations);
  densityHistogram = new Histogram(filterZone[0] + filterZone[2] + padding, filterZone[1], filterZone[2], filterZone[3], densities);
}

void setupSliders() {
  maxPopulationSlider = new Slider(filterZone[0], filterZone[1], filterZone[2], 25, 10, 25, 1, Stats.minPopulation, Stats.maxPopulation, false);
  minPopulationSlider = new Slider(filterZone[0], filterZone[1] + 50, filterZone[2], 25, 10, 25, 0.25, Stats.minPopulation, Stats.maxPopulation, false);
  maxDensitySlider = new Slider(filterZone[0] + filterZone[2] + padding, filterZone[1], filterZone[2], 25, 10, 25, 1, Stats.minDensity, Stats.maxDensity, true);
  minDensitySlider = new Slider(filterZone[0] + filterZone[2] + padding, filterZone[1] + 50, filterZone[2], 25, 10, 25, 0.1, Stats.minDensity, Stats.maxDensity, true);
}

void setupPanels() {
  String[][] emptyPanel = {};
  selectedCityPanel = new TextPanel(950, 20, 250, 200, "Selected City", emptyPanel);
  focusedCityPanel = new TextPanel(1200, 20, 250, 200, "Compared City", emptyPanel);
}

void setup() {
  readData();
  size(1600, 900);
  int[] zone = {padding, height - 100 - padding, width / 2 - 2 * padding, 100};
  filterZone = zone;
  setupHistograms();
  setupSliders();
  setupPanels();
}

void mouseMoved() {
  City focusedCity = map.mouseMoved(minPopulationSlider.getRealValue(), maxPopulationSlider.getRealValue(), minDensitySlider.getRealValue(), maxDensitySlider.getRealValue());
  String[][] emptyPanel = {};
  if (focusedCity != null)
      focusedCityPanel.setText(focusedCity.getDescription(map.selectedCity));
  else
    focusedCityPanel.setText(emptyPanel);
}

void mousePressed() {
  City selectedCity = map.mousePressed(minPopulationSlider.getRealValue(), maxPopulationSlider.getRealValue(), minDensitySlider.getRealValue(), maxDensitySlider.getRealValue());
  String[][] emptyPanel = {};
  if (selectedCity != null) {
    selectedCityPanel.setText(selectedCity.getDescription(null));
    focusedCityPanel.setText(selectedCity.getDescription(selectedCity));
  }
  else
    selectedCityPanel.setText(emptyPanel);
  maxPopulationSlider.mousePressed();
  minPopulationSlider.mousePressed();
  maxDensitySlider.mousePressed();
  minDensitySlider.mousePressed();
}

void mouseDragged() {
  maxPopulationSlider.mouseDragged();
  minPopulationSlider.mouseDragged();
  maxDensitySlider.mouseDragged();
  minDensitySlider.mouseDragged();
}

void mouseReleased() {
  maxPopulationSlider.mouseReleased();
  minPopulationSlider.mouseReleased();
  maxDensitySlider.mouseReleased();
  minDensitySlider.mouseReleased();
}

void mouseWheel(MouseEvent event) {
  float scroll = event.getCount();
  map.zoom(-scroll);
}

void draw() {
  background(255, 255, 255);

  map.draw(minPopulationSlider.getRealValue(), maxPopulationSlider.getRealValue(), minDensitySlider.getRealValue(), maxDensitySlider.getRealValue());
  
  fill(0, 0, 0);
  textAlign(CENTER);
  
  textSize(20);
  text("Number of cities by population (inhabitants) (log scale)", filterZone[0] + filterZone[2] / 2, filterZone[1] - 25);
  populationHistogram.draw(minPopulationSlider.getValue(), maxPopulationSlider.getValue());
  maxPopulationSlider.draw();
  minPopulationSlider.draw();
  
  textSize(20);
  text("Number of cities by density (inhabitants / km²) (log scale)", filterZone[0] + filterZone[2] + filterZone[2] / 2 + padding, filterZone[1] - 25);
  densityHistogram.draw(minDensitySlider.getValue(), maxDensitySlider.getValue());
  maxDensitySlider.draw();
  minDensitySlider.draw();
  
  selectedCityPanel.draw();
  focusedCityPanel.draw();
}
