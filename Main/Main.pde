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
TextPanel infoPanel = null;
TextPanel selectedCityPanel = null;
TextPanel focusedCityPanel = null;
TextPanel interactionPanel = null;
Button villagesBtn = null;
Button ghostTownsBtn = null;
Button denseCitiesBtn = null;
Button chillBigCitiesBtn = null;
int padding = 10;

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
  map = new Map(padding, padding, height - 2 * padding, height - 2 * padding, cities);
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
    populations[floor((nbBins - 1) * log(1 + city.population - Stats.minPopulation) / log(1 + Stats.maxPopulation))] += 1;
    densities[floor((nbBins - 1) * log(1 + city.density - Stats.minDensity) / log(1 + Stats.maxDensity))] += 1;
  }
  int w = width - height - 4 * padding;
  int h = 150;
  int x = height + padding;
  int y = height - padding;
  populationHistogram = new Histogram(x, y - 2 * h - padding - 30, w, h, populations);
  densityHistogram = new Histogram(x, y - h, w, h, densities);
}

void setupSliders() {
  int w = width - height - 4 * padding;
  int h = 150;
  int x = height + padding;
  int y = height - padding;
  int cursorWidth = 10;
  int cursorHeight = 25;
  int cursorCenterOffset = 30;
  maxPopulationSlider = new Slider(x, y - (h + h / 2 + padding + 30) - cursorCenterOffset - cursorHeight / 2, w, cursorHeight, cursorWidth, cursorHeight, 1, Stats.minPopulation, Stats.maxPopulation, true);
  minPopulationSlider = new Slider(x, y - (h + h / 2 + padding + 30) + cursorCenterOffset + cursorHeight / 2, w, cursorHeight, cursorWidth, cursorHeight, 0.55, Stats.minPopulation, Stats.maxPopulation, true);
  maxDensitySlider = new Slider(x, y - h / 2 - cursorCenterOffset - cursorHeight / 2, w, cursorHeight, cursorWidth, cursorHeight, 1, Stats.minDensity, Stats.maxDensity, true);
  minDensitySlider = new Slider(x, y - h / 2 + cursorCenterOffset + cursorHeight / 2, w, cursorHeight, cursorWidth, cursorHeight, 0, Stats.minDensity, Stats.maxDensity, true);
}

void setupPanels() {
  String[][] emptyPanel = {};
  int x = height + padding;
  int y = padding;
  int w = (width - height - 5 * padding) / 2;
  int h = 170;
  selectedCityPanel = new TextPanel(x, y, w, h, "Selected City", emptyPanel);
  focusedCityPanel = new TextPanel(x + w + padding, y, w, h, "Compared City", emptyPanel);
  infoPanel = new TextPanel(x, y + h + padding, w, h, "Information", emptyPanel);
  String textColor = hex(color(0, 0, 0));
  String[][] interactionText = {
    {"Select/deselect city", "Left click on city", textColor},
    {"Compare city", "Hover mouse over city", textColor},
    {"Open city's wiki", "Press Enter", textColor},
    {"Zoom in/out", "Scroll wheel on map", textColor},
    {"Filter cities", "Drag cursors on histogram", textColor},
    {"Use preset filters", "Click on buttons below", textColor}
  };
  interactionPanel = new TextPanel(x + w + padding, y + h + padding, w, h, "Interactions", interactionText);
}

void setupButtons() {
  int x = height + padding;
  int y = height / 2 - 5 * padding;
  int w = (width - height - 5 * padding) / 2;
  int h = 40;
  villagesBtn = new Button(x, y, w, h, "Villages") {
    @Override
    public void onClick() {
      minPopulationSlider.value = 0;
      maxPopulationSlider.value = log(1 + Stats.minPopulation + 100.0) / log(1 + Stats.maxPopulation);
      minDensitySlider.value = 0;
      maxDensitySlider.value = 1;
    }
  };
  ghostTownsBtn = new Button(x + w + padding, y, w, h, "Ghost towns") {
    @Override
    public void onClick() {
      minPopulationSlider.value = 0;
      maxPopulationSlider.value = 0;
      minDensitySlider.value = 0;
      maxDensitySlider.value = 1;
    }
  };
  denseCitiesBtn = new Button(x, y + h + padding, w, h, "Dense cities") {
    @Override
    public void onClick() {
      minPopulationSlider.value = 0;
      maxPopulationSlider.value = 1;
      minDensitySlider.value = log(1 + Stats.minDensity + 5000.0) / log(1 + Stats.maxDensity);
      maxDensitySlider.value = 1;
    }
  };
  chillBigCitiesBtn = new Button(x + w + padding, y + h + padding, w, h, "Chill municipalities") {
    @Override
    public void onClick() {
      minPopulationSlider.value = log(1 + Stats.minPopulation + 3000.0) / log(1 + Stats.maxPopulation);
      maxPopulationSlider.value = 1;
      minDensitySlider.value = 0;
      maxDensitySlider.value = log(1 + Stats.minDensity + 50.0) / log(1 + Stats.maxDensity);
    }
  };
}

void setup() {
  readData();
  size(1600, 900);
  setupHistograms();
  setupSliders();
  setupPanels();
  setupButtons();
}

void mouseMoved() {
  City focusedCity = map.mouseMoved(minPopulationSlider.getRealValue(), maxPopulationSlider.getRealValue(), minDensitySlider.getRealValue(), maxDensitySlider.getRealValue());
  String[][] emptyPanel = {};
  if (focusedCity != null)
      focusedCityPanel.setText(focusedCity.getDescription(map.selectedCity));
  else
    focusedCityPanel.setText(emptyPanel);
  villagesBtn.mouseMoved();
  ghostTownsBtn.mouseMoved();
  denseCitiesBtn.mouseMoved();
  chillBigCitiesBtn.mouseMoved();
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
  villagesBtn.mouseReleased();
  ghostTownsBtn.mouseReleased();
  denseCitiesBtn.mouseReleased();
  chillBigCitiesBtn.mouseReleased();
}

void mouseWheel(MouseEvent event) {
  float scroll = event.getCount();
  map.zoom(-scroll);
}

void keyPressed() {
  map.keyPressed();
}

void draw() {
  background(255, 255, 255);

  int nbCitiesShown = map.draw(minPopulationSlider.getRealValue(), maxPopulationSlider.getRealValue(), minDensitySlider.getRealValue(), maxDensitySlider.getRealValue());
  
  fill(0, 0, 0);
  textAlign(CENTER);
  
  textSize(18);
  text("Number of cities by population (inhabitants) (log scale)", populationHistogram.x + populationHistogram.width / 2, populationHistogram.y - padding);
  populationHistogram.draw(minPopulationSlider.getValue(), maxPopulationSlider.getValue());
  maxPopulationSlider.draw();
  minPopulationSlider.draw();
  
  textSize(18);
  text("Number of cities by density (inhabitants / km²) (log scale)", densityHistogram.x + densityHistogram.width / 2, densityHistogram.y - padding);
  densityHistogram.draw(minDensitySlider.getValue(), maxDensitySlider.getValue());
  maxDensitySlider.draw();
  minDensitySlider.draw();
  
  selectedCityPanel.draw();
  focusedCityPanel.draw();
  
  String textColor = hex(color(0, 0, 0));
  String[][] informations = {
    {"Total number of cities", "" + Stats.nbCities, textColor},
    {"Number of visible cities", "" + nbCitiesShown, textColor},
    {"% of visible cities", nf(100.0 * nbCitiesShown / Stats.nbCities, 0, 2) + "%", textColor},
    {"Zoom level", nf(map.zoom, 0, 2) + "x", textColor}
  };
  infoPanel.setText(informations);
  
  infoPanel.draw();
  interactionPanel.draw();
  
  villagesBtn.draw();
  ghostTownsBtn.draw();
  denseCitiesBtn.draw();
  chillBigCitiesBtn.draw();
}
