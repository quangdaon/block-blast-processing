class Grid {
  public int columns, rows;
  public Block[] blocks;

  private int hoveredX = -1;
  private int hoveredY = -1;
  private boolean tilePlacementValid = false;
  private Tile tileToCheck = null;
  private int screenX, screenY, blockWidth, screenWidth, screenHeight;

  private int getScreenEnd() {
    return screenX + screenWidth;
  }

  private int getScreenBottom() {
    return screenY + screenHeight;
  }

  public Grid(int w, int h) {
    columns = w;
    rows = h;
    blocks = new Block[w * h];

    for (int i = 0; i < blocks.length; i++) {
      blocks[i] = new Block();
    }

    initScreenDimensions();
  }

  private void initScreenDimensions() {
    screenX = PADDING_EDGES;
    screenY = PADDING_TOP;
    screenWidth = getComponentWidth();
    blockWidth = screenWidth / columns;
    screenHeight = blockWidth * rows;
  }

  public boolean checkTile(Tile tile) {
    if (hoveredX < 0 || hoveredY < 0 || tile == null) {
      tileToCheck = null;
      return false;
    }

    tileToCheck = tile;
    tilePlacementValid = checkTile();

    return tilePlacementValid;
  }

  private boolean checkTile() {
    if (hoveredX + tileToCheck.getColumns() > columns) return false;
    if (hoveredY + tileToCheck.getRows() > rows) return false;

    for (int i = 0; i < tileToCheck.getRows(); i++) {
      for (int j = 0; j < tileToCheck.getColumns(); j++) {
        // TODO
      }
    }

    return true;
  }

  public boolean hover(int x, int y) {
    if (x < screenX || x > getScreenEnd() || y < screenY || y > getScreenBottom()) {
      hoveredX = -1;
      hoveredY = -1;
      return false;
    }


    hoveredX = floor((x - screenX) / float(screenWidth) * columns);
    hoveredY = floor((y - screenY) / float(screenHeight) * rows);


    return true;
  }

  public boolean placeTile(Tile tile) {
    if (!tilePlacementValid) return false;
    int originX = hoveredX;
    int originY = hoveredY;

    for (int i = 0; i < tileToCheck.getRows(); i++) {
      for (int j = 0; j < tileToCheck.getColumns(); j++) {
        if (tileToCheck.getBlock(j, i) == null) continue;
        int targetX = originX + j;
        int targetY = originY + i;


        int index = targetY * rows + targetX;

        var block = blocks[index];

        block.active = true;
        block.hue = tileToCheck.getHue();
      }
    }

    return true;
  }

  public void draw() {
    push();
    noStroke();
    fill(BACKGROUND_HUE, BACKGROUND_SATURATION, 0.2);
    rect(screenX, screenY, screenWidth, screenHeight);
    pop();

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        int index = row * rows + col;
        int blockX = screenX + col * blockWidth;
        int blockY = screenY + row * blockWidth;
        color overrideColor = getTileColor(col, row, index);
        blocks[index].draw(blockX, blockY, blockWidth, overrideColor);
      }
    }
  }

  private color getTileColor(int col, int row, int index) {
    if (tileToCheck != null) {
      if (!isTiledBlock(col, row)) return -1;
      return tilePlacementValid
        ? color(tileToCheck.getHue(), BLOCK_SATURATION, BLOCK_BRIGHTNESS, 0.3)
        : color(0, 1, BLOCK_BRIGHTNESS, 1);
    }

    if (getHoveredIndex() == index) return color(BACKGROUND_HUE, 0.1, 0, 0.15);

    return -1;
  }

  private boolean isTiledBlock(int col, int row) {
    int tiledX = col - hoveredX;
    int tiledY = row - hoveredY;

    // println("X: " + tiledX + "; Cols: "+ tileToCheck.getColumns() + "; Y: "+ tiledY + "; Rows: " + tileToCheck.getRows());

    if (tiledX < 0 || tiledX >= tileToCheck.getColumns() || tiledY < 0 || tiledY >= tileToCheck.getRows()) return false;

    Block block = tileToCheck.getBlock(tiledX, tiledY);

    return block != null;
  }

  private int getHoveredIndex() {
    return hoveredY * rows + hoveredX;
  }
}
