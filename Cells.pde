static ArrayList<Cell> allCells = new ArrayList<Cell>();

// Cell type, which evolves
class Cell extends Render implements Position {
  public PVector position = new PVector(width / 2, height / 2);
  public float size, speed, sight, energy;
  public color cellColor;
  
  @Override
  public PVector getPosition() {
    return position;
  }

  public Cell(float size, float speed, float sight, float energy, color cellColor) {
    this.size = size;
    this.speed = speed;
    this.sight = sight;
    this.energy = energy;
    this.cellColor = cellColor;
    allCells.add(this);
  }

  public Cell() {
    this.size = 40 + random(60);
    this.speed = 100 + random(200);
    this.sight = 50 + random(100);
    this.energy = 200.0;
    this.cellColor = color(random(255), random(255), random(255));
    allCells.add(this);
  }
  
  public void render() {
    fill(lerpColor(this.cellColor, color(0), .33));
    ellipse(this.position.x, this.position.y, this.size, this.size);
    fill(cellColor);
    ellipse(this.position.x, this.position.y, this.size - 10.0, this.size - 10.0);
  }
  
  public void move(float x, float y) {
    this.position.x += x * this.speed / frameRate;
    this.position.y += y * this.speed / frameRate;
  }
}

// Particle that cells collect
class Particle extends Render implements Position {
  public PVector position;
  public float size, energy;
  
  @Override
  public PVector getPosition() {
    return position;
  }

  Particle(PVector position, float size, float energy) {
    this.position = position;
    this.size = size;
    this.energy = energy;
  }

  public void render() {
    fill(lerpColor(color(210, 170, 120), color(0), .33));
    ellipse(this.position.x, this.position.y, this.size, this.size);
    fill(color(210, 170, 120));
    ellipse(this.position.x, this.position.y, this.size - 10.0, this.size - 10.0);
  }
}