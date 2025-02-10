class Tile {
  private int hue;
  private int[][] blueprint;
  private Block[][] blocks;

  private int columns = 0;
  private int rows;

  public Tile(int h, int[][] bp) {
    hue = h;
    blueprint = bp;

    blocks = new Block[blueprint.length][];

    for (int i = 0; i < bp.length; i++) {
      blocks[i] = new Block[bp[i].length];
      if (bp[i].length > columns) columns = bp[i].length;
      for (int j = 0; j < bp[i].length; j++) {
        if (blueprint[i][j] == 0) continue;
        Block block = new Block(hue);
        block.active = true;
        blocks[i][j] = block;
      }
    }

    rows = bp.length;
  }

  public void draw(int x, int y, int w, boolean offset) {
    int tileWidth = w / 7;
    int center = w / 2;

    float offsetX = 0;
    float offsetY = 0;
    
    if (offset) {
      offsetX = center - (float(tileWidth) * float(columns) / 2.0);
      offsetY = center - (float(tileWidth) * float(rows) / 2.0);
    }

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        Block block = blocks[i][j];
        if (block == null) continue;

        int blockX = int(offsetX) + x + tileWidth * j;
        int blockY = int(offsetY) + y + tileWidth * i;

        block.draw(blockX, blockY, tileWidth);
      }
    }
  }
  
  public int getHue() {
    return hue;
  }
  
  public int getRows() {
    return rows;
  }
  
  public int getColumns() {
    return columns;
  }
  
  public Block getBlock(int x, int y) {
    return blocks[y][x];
  }
}
