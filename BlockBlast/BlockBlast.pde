Grid grid;
Trunk trunk;
Tile captured;
boolean gameOver = false;

void setup() {
  size(640, 960);
  colorMode(HSB, 360, 1, 1, 1);

  grid = new Grid(GRID_SIZE, GRID_SIZE);
  trunk = new Trunk();
}

void draw() {
  background(BACKGROUND_HUE, BACKGROUND_SATURATION, BACKGROUND_BRIGHTNESS);

  renderMessage();

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
    gameOver = !grid.scan(trunk.getOptions());
  }
}

void drawCaptured() {
  if (captured == null) return;

  captured.draw(mouseX, mouseY, 200, false);
}

void renderMessage() {
  int score = grid.getScore();

  textAlign(CENTER, CENTER);
  
  if (!gameOver) {
    textSize(100);
    text(score, width / 2, 50);
    return;
  }


  textSize(40);
  text("Out of Moves!", width / 2, 40);

  textSize(20);
  text("Final Score: " + score, width / 2, 80);
}
