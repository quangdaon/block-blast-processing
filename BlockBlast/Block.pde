class Block {
  private int hue;
  
  public boolean active = false;
  
  public Block(int h) {
    hue = h;
  }
  
  public Block() {
    this(0);
  }
  
  public void draw(int x, int y, int w) {
    draw(x, y, w, -1);
  }
  
  public void draw(int x, int y, int w, color overrideColor) {
    push();
    stroke(BACKGROUND_HUE, BACKGROUND_SATURATION, 0.15);
    if(active) {
      fill(hue, BLOCK_SATURATION, BLOCK_BRIGHTNESS);
    } else if (overrideColor != -1) {
      fill(overrideColor);
    } else {
      noFill();
    }
    rect(x, y, w, w);
    pop();
  }
}
