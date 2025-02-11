class Trunk {
  private Tile[] candidates = new Tile [] {
    new Tile(60, new int[][] {
      new int[] { 1 }
    }),
    new Tile(180, new int[][] {
      new int[] { 1, 1 }
    }),
    new Tile(240, new int[][] {
      new int[] { 1, 1, 1 }
    }),
    new Tile(300, new int[][] {
      new int[] { 1, 1, 1, 1 }
    }),
    new Tile(260, new int[][] {
      new int[] { 1 },
      new int[] { 1 }
    }),
    new Tile(360, new int[][] {
      new int[] { 1 },
      new int[] { 1 },
      new int[] { 1 }
    }),
    new Tile(300, new int[][] {
      new int[] { 1 },
      new int[] { 1 },
      new int[] { 1 },
      new int[] { 1 }
    }),
    new Tile(180, new int[][] {
      new int[] { 1, 1, 1, 1 },
      new int[] { 1, 0, 0, 0 }
    }),
    new Tile(320, new int[][] {
      new int[] { 1, 0, 0, 0 },
      new int[] { 1, 1, 1, 1 }
    }),
    new Tile(180, new int[][] {
      new int[] { 1, 1, 1, 1 },
      new int[] { 0, 0, 0, 1 }
    }),
    new Tile(320, new int[][] {
      new int[] { 0, 0, 0, 1 },
      new int[] { 1, 1, 1, 1 }
    }),
    new Tile(180, new int[][] {
      new int[] { 1, 1 },
      new int[] { 0, 1 },
      new int[] { 0, 1 },
      new int[] { 0, 1 }
    }),
    new Tile(180, new int[][] {
      new int[] { 0, 1 },
      new int[] { 0, 1 },
      new int[] { 0, 1 },
      new int[] { 1, 1 }
    }),
    new Tile(180, new int[][] {
      new int[] { 1, 1 },
      new int[] { 1, 0 },
      new int[] { 1, 0 },
      new int[] { 1, 0 }
    }),
    new Tile(180, new int[][] {
      new int[] { 1, 0 },
      new int[] { 1, 0 },
      new int[] { 1, 0 },
      new int[] { 1, 1 }
    }),
    new Tile(300, new int[][] {
      new int[] { 1, 1, 1 },
      new int[] { 1, 0, 0 }
    }),
    new Tile(200, new int[][] {
      new int[] { 1, 0, 0 },
      new int[] { 1, 1, 1 }
    }),
    new Tile(300, new int[][] {
      new int[] { 1, 1, 1 },
      new int[] { 0, 0, 1 }
    }),
    new Tile(200, new int[][] {
      new int[] { 0, 0, 1 },
      new int[] { 1, 1, 1 }
    }),
    new Tile(0, new int[][] {
      new int[] { 1, 1, 1 },
      new int[] { 1, 1, 1 }
    }),
    new Tile(20, new int[][] {
      new int[] { 1, 1 },
      new int[] { 1, 0 },
      new int[] { 1, 0 }
    }),
    new Tile(20, new int[][] {
      new int[] { 1, 0 },
      new int[] { 1, 0 },
      new int[] { 1, 1 }
    }),
    new Tile(20, new int[][] {
      new int[] { 1, 1 },
      new int[] { 0, 1 },
      new int[] { 0, 1 }
    }),
    new Tile(20, new int[][] {
      new int[] { 0, 1 },
      new int[] { 0, 1 },
      new int[] { 1, 1 }
    }),
    new Tile(20, new int[][] {
      new int[] { 1, 1 },
      new int[] { 1, 1 },
      new int[] { 1, 1 }
    }),
    new Tile(40, new int[][] {
      new int[] { 0, 1, 0 },
      new int[] { 1, 1, 1 }
    }),
    new Tile(340, new int[][] {
      new int[] { 1, 1, 1 },
      new int[] { 0, 1, 0 }
    }),
    new Tile(280, new int[][] {
      new int[] { 1, 1, 1, 1, 1, 1 }
    }),
    new Tile(140, new int[][] {
      new int[] { 1 },
      new int[] { 1 },
      new int[] { 1 },
      new int[] { 1 },
      new int[] { 1 },
      new int[] { 1 }
    })
  };

  private Tile[] options = new Tile[3];

  private int screenX, screenY, screenWidth, screenHeight;

  private int lastPicked = -1;

  private int getScreenEnd() {
    return screenX + screenWidth;
  }

  private int getScreenBottom() {
    return screenY + screenHeight;
  }

  public Trunk() {
    restock();
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

    lastPicked = index;
    options[index] = null;

    return found;
  }

  public void replace(Tile tile) {
    if (lastPicked == -1) return;
    options[lastPicked] = tile;
    lastPicked = -1;
  }

  public void restock() {
    for (int i = 0; i < options.length; i++) {
      if (options[i] == null) options[i] = getRandomCandidate();
    }
  }

  public int getLength() {
    int count = 0;

    for (Tile opt : options) {
      if (opt != null) count++;
    }

    return count;
  }

  private Tile getRandomCandidate() {
    Tile candidate = candidates[floor(random(candidates.length))];


    return candidate;
  }
}
