import java.util.Arrays;

class Grid {
  public int columns, rows;
  public Block[] blocks;

  private int score = 0;

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
    tilePlacementValid = checkTile(tile, hoveredX, hoveredY);

    return tilePlacementValid;
  }

  public boolean hover(int x, int y) {
    if (x < screenX || x > getScreenEnd() || y < screenY || y > getScreenBottom()) {
      hoveredX = -1;
      hoveredY = -1;
      tilePlacementValid = false;
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

    for (int i = 0; i < tile.getRows(); i++) {
      for (int j = 0; j < tile.getColumns(); j++) {
        if (tile.getBlock(j, i) == null) continue;
        int targetX = originX + j;
        int targetY = originY + i;

        int index = targetY * rows + targetX;

        var block = blocks[index];

        block.active = true;
        block.hue = tileToCheck.getHue();
      }
    }

    score+= tile.getSize();

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

  public boolean scan(Tile[] trunkTiles) {
    boolean[] rowsFilled = new boolean[rows];
    boolean[] columnsFilled = new boolean[columns];
    boolean hasValidMove = false;

    Arrays.fill(rowsFilled, true);
    Arrays.fill(columnsFilled, true);

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        int index = row * rows + col;
        if (blocks[index].active) continue;

        rowsFilled[row] = false;
        columnsFilled[col] = false;

        if (hasValidMove) continue;

        for (Tile tile : trunkTiles) {
          if (tile == null || !checkTile(tile, col, row)) continue;
          hasValidMove = true;
          break;
        }
      }
    }


    int[] filledRows = getTrueIndexes(rowsFilled);
    int[] filledCols = getTrueIndexes(columnsFilled);
    
    score += calculateScore(filledRows, filledCols);

    for (int row : filledRows) {
      for (int col = 0; col < columns; col++) {
        int index = row * rows + col;
        blocks[index].active = false;
      }
    }

    for (int col : filledCols) {
      for (int row = 0; row < rows; row++) {
        int index = row * rows + col;
        blocks[index].active = false;
      }
    }

    if (filledRows.length > 0 || filledCols.length > 0) return scan(trunkTiles);    
    
    return hasValidMove;
  }

  public int getScore() {
    return score;
  }

  private boolean checkTile(Tile tile, int x, int y) {
    if (x + tile.getColumns() > columns) return false;
    if (y + tile.getRows() > rows) return false;

    for (int i = 0; i < tile.getRows(); i++) {
      for (int j = 0; j < tile.getColumns(); j++) {
        int targetX = x + j;
        int targetY = y + i;


        int index = targetY * rows + targetX;

        if (tile.getBlock(j, i) != null && blocks[index].active) return false;
      }
    }

    return true;
  }

  private color getTileColor(int col, int row, int index) {
    if (tileToCheck != null) {
      if (!isTiledBlock(col, row)) return -1;
      return tilePlacementValid
        ? color(tileToCheck.getHue(), BLOCK_SATURATION, BLOCK_BRIGHTNESS, 0.3)
        : color(0, 1, BLOCK_BRIGHTNESS, 1);
    }

    if (getHoveredIndex() == index && !blocks[index].active) return color(BACKGROUND_HUE, 0.1, 0, 0.15);

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
  
  private int calculateScore(int[] filledRows, int[] filledCols) {
    return (filledRows.length + filledCols.length) * 100;
  }
}
