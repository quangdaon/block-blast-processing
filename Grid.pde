class Grid {
  public int columns, rows;
  public Block[] blocks;
  
  private int screenX, screenY, blockWidth, screenWidth, screenHeight;

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
        blocks[index].draw(blockX, blockY, blockWidth);
      }
    }
  }
}
