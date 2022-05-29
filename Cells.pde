static ArrayList<Cell> allCells = new ArrayList<Cell>();

// Cell type, which evolves
class Cell extends Render {
  public PVector pos = new PVector(width / 2, height / 2);
  public float size, speed, sight, energy;
  public color cellColor;
  
  public Cell(float size, float speed, float sight, float energy, color cellColor) {
    this.size = size;
    this.speed = speed;
    this.sight = sight;
    this.energy = energy;
    this.cellColor = cellColor;
    allCells.add(this);
  }
  
  public void render() {
    fill(lerpColor(this.cellColor, color(0), .33));
    ellipse(this.pos.x, this.pos.y, this.size, this.size);
    fill(cellColor);
    ellipse(this.pos.x, this.pos.y, this.size - 10.0, this.size - 10.0);
  }
  
  public void move(float x, float y) {
    this.pos.x += x * this.speed / frameRate;
    this.pos.y += y * this.speed / frameRate;
  }
}

// Particle that cells collect
class Particle extends Render {
  public PVector pos;
  public float size, energy;
  
  Particle(PVector position, float size, float energy) {
    this.pos = position;
    this.size = size;
    this.energy = energy;
  }

  public void render() {
    fill(lerpColor(color(210, 170, 120), color(0), .33));
    ellipse(this.pos.x, this.pos.y, this.size, this.size);
    fill(color(210, 170, 120));
    ellipse(this.pos.x, this.pos.y, this.size - 10.0, this.size - 10.0);
  }
}