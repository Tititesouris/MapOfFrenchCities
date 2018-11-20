ArrayList<City> cities = new ArrayList<City>();
City selectedCity = null;
Histogram populationHistogram;
Slider minDensitySlider = new Slider(15, 40, 250, 20);

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
  float[] populations = new float[Stats.nbCities];
  for (int i = lines.length - Stats.nbCities; i < Stats.nbCities; i++) {
    City city = parseCity(lines[i]);
    cities.add(city);
    populations[i] = city.population;
  }
  populationHistogram = new Histogram(15, 40, 250, 20, populations);
}

void readData() {
  String[] lines = loadStrings("cities.tsv");
  parseHeader(lines[0]);
  parseCities(lines);
}

void setup() {
  readData();
  size(800, 800);
}

City getSelectedCity() {
  for (int i = cities.size() - 1; i >= 0; i--) {
    City city = cities.get(i);
    if (city.contains(mouseX, mouseY)) {
      return city;
    }
  }
  return null;
}

void mouseMoved() {
  selectedCity = getSelectedCity();
}

void mousePressed() {
  minDensitySlider.mousePressed();
}

void mouseDragged() {
  minDensitySlider.mouseDragged();
}

void mouseReleased() {
  minDensitySlider.mouseReleased();
}

void draw() {
  background(255, 255, 255);

  float minDensityToDisplay = minDensitySlider.getValue() * Stats.maxDensity;
  textSize(13);
  fill(0, 0, 0);
  text(minDensityToDisplay, 100, 35);
  text("Minimum population to display", 10, 15);
  populationHistogram.draw();
  minDensitySlider.draw();

  for (City city : cities) {
    if (city.density >= minDensityToDisplay) {
      city.draw(city == selectedCity);
    }
  }
}
