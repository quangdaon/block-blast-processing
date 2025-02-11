Grid grid;
Trunk trunk;
Tile captured;

void setup() {
  size(640, 960);
  colorMode(HSB, 360, 1, 1, 1);

  grid = new Grid(GRID_SIZE, GRID_SIZE);
  trunk = new Trunk();
}

void draw() {
  background(BACKGROUND_HUE, BACKGROUND_SATURATION, BACKGROUND_BRIGHTNESS);

  textAlign(CENTER, CENTER);
  textSize(100);
  text(grid.getScore(), width / 2, 50);

  boolean gridHovered = grid.hover(mouseX, mouseY);
  grid.checkTile(captured);

  grid.draw();
  trunk.draw();
  if (!gridHovered) drawCaptured();
}

void mousePressed() {
  if (captured != null) {
    trunk.replace(captured);
    captured = null;
  }

  captured = trunk.getIntersect(mouseX, mouseY);
}

void mouseReleased() {
  if (captured != null) {
    Tile tileToProcess = captured;
    captured = null;
    boolean placed = grid.placeTile(tileToProcess);

    if (!placed) {
      trunk.replace(tileToProcess);
      return;
    }
    
    if (trunk.getLength() == 0) trunk.restock();
    
  }
}

void drawCaptured() {
  if (captured == null) return;

  captured.draw(mouseX, mouseY, 200, false);
}
