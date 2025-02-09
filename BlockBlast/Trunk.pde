class Trunk {
  Tile[] candidates = new Tile [] {
    new Tile(60, new int[][] {
      new int[] { 1 }
    }),
    new Tile(120, new int[][] {
      new int[] { 1, 1 }
    }),
    new Tile(180, new int[][] {
      new int[] { 1, 1, 1, 1 },
      new int[] { 1, 0, 0, 0 }
    })
  };

  Tile[] options = candidates; // new Tile[3];

  private int screenX, screenY, screenWidth, screenHeight;

  private int getScreenEnd() {
    return screenX + screenWidth;
  }

  private int getScreenBottom() {
    return screenY + screenHeight;
  }

  public Trunk() {
    initScreenDimensions();
  }

  public void initScreenDimensions() {
    screenWidth = getComponentWidth();
    screenHeight = floor(screenWidth / float(options.length));
    screenX = PADDING_EDGES;
    screenY = height - PADDING_EDGES - screenHeight;
  }

  public void draw() {
    push();
    noStroke();
    fill(BACKGROUND_HUE, BACKGROUND_SATURATION, 0.15);
    rect(screenX, screenY, screenWidth, screenHeight);
    pop();

    int zoneWidth = screenWidth / options.length;
    for (var i = 0; i < options.length; i++) {
      if (options[i] == null) continue;
      var xOffset = i * zoneWidth;
      options[i].draw(screenX + xOffset, screenY, zoneWidth, true);
    }
  }

  public Tile getIntersect(int x, int y) {
    if (x < screenX || x > getScreenEnd() || y < screenY || y > getScreenBottom()) return null;
    int index = floor((x - screenX) / float(screenWidth) * options.length);
    Tile found = options[index];
    
    options[index] = null;

    return found;
  }
  
  public void replace(Tile tile) {
    for (int i = 0; i < options.length; i++) {
      if (options[i] != null) continue;
      options[i] = tile;
      return;
    }
    
    println("Tried to replace full Trunk");
  }
}
