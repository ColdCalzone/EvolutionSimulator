final static ArrayList<Render> renderObjects = new ArrayList<Render>();

static ArrayList<Cell> allCells = new ArrayList<Cell>();

static ArrayList<Button> activeButtons = new ArrayList<Button>();

// Don't make multiple PLEASE I couldn't get this as a singleton
class GlobalState {
  private boolean leftMouse = false;
  private boolean rightMouse = false;

  GlobalState() { }

  public boolean leftMouseClicked() {
    return !this.leftMouse && (mouseButton == LEFT);
  }

  public boolean rightMouseClicked() {
    return !this.rightMouse && (mouseButton == RIGHT);
  }

  public boolean leftMouseHeld() {
    return this.leftMouse;
  }

  public boolean rightMouseHeld() {
    return this.rightMouse;
  }


  public void updateMouseState() {
    if(mousePressed) {
      switch(mouseButton) {
        case LEFT:
          this.leftMouse = true;
          this.rightMouse = false;
          break;
        case RIGHT:
          this.rightMouse = true;
          this.leftMouse = false;
          break;
        case CENTER:
          this.rightMouse = false;
          this.leftMouse = false;
          break;
      }
    } else {
      this.rightMouse = false;
      this.leftMouse = false;
    }
  }
}

// Basic type for classes to inherit to become renderable
abstract class Render {
  public Render() {
    renderObjects.add(this);
  }

  public abstract void render();
}

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

// Java doesn't have support for first class functions
// or delegates...
// so this is my solution
abstract class ButtonClickBehavior {
  abstract void onClick();
  abstract void onRelease();
}

// Basic button system to simplify button making
class Button extends Render {
  color buttonColor, textColor, pressedColor;
  String buttonText;
  PVector position, size;
  float textSize;
  ButtonClickBehavior clickBehavior;
  private boolean pressed;

  public boolean getPressed() {
    return pressed;
  }

  public void onClick() {
    this.pressed = true;
    clickBehavior.onClick();
  }
  
  public void onRelease() {
    this.pressed = false;
    clickBehavior.onRelease();
  }

  Button(color _color, color pressedColor, String text, color textColor, float textSize, PVector position, PVector size, ButtonClickBehavior clickBehavior) {
    this.buttonColor = _color;
    this.pressedColor = pressedColor;
    this.buttonText = text;
    this.position = position;
    this.size = size;
    this.textColor = textColor;
    this.textSize = textSize;
    this.clickBehavior = clickBehavior;
    activeButtons.add(this);
  }

  public void render() {
    fill(this.pressed ? this.pressedColor : this.buttonColor);
    rect(this.position.x, this.position.y, this.size.x, this.size.y);
    fill(this.textColor);
    textSize(this.textSize);
    text(this.buttonText, this.position.x, this.position.y, this.size.x, this.size.y);
  }
}

// Single reference to the state of the program
GlobalState globalState = new GlobalState();

void setup() {
  size(800, 600);
  frameRate(30);
  new Cell(50.0, 100.0, 0.5, 100.0, color(random(255), random(255), random(255)));
  new Particle(new PVector(width / 2.0 + 200.0, height / 2.0), 20.0, 20.0);
  
  // Make a new button which adds a cell (and particle) when clicked
  new Button(color(0, 255, 0), color(0, 128, 0), "Add new Cell", color(0,0,0), 24.0, new PVector(0, 0), new PVector(155, 30), new ButtonClickBehavior() {
    public void onClick() {
      new Cell(50.0 + random(20), 100.0 + random(20), 0.5, 100.0, color(random(255), random(255), random(255)));
      new Particle(new PVector(width / 2.0 + random(200.0), height / 2.0), 20.0, 20.0);
    }

    public void onRelease() {

    }
  });
}

void draw() {
  background(51);
  // Cell simulation step
  for(Cell cell : allCells) {
    cell.move(1, 0);
    
  }

  // render step
  for(Render renderOb : renderObjects) {
    renderOb.render(); 
  }
}

void mousePressed() {
  for(Button button : activeButtons) {
    if(mouseX > button.position.x && mouseY > button.position.y && mouseX < (button.position.x + button.size.x) && mouseY < (button.position.y + button.size.y) && (globalState.leftMouseClicked() || globalState.leftMouseHeld())) {
      button.onClick();
      break;
    }
  }
  // Keep this at the bottom pls
  globalState.updateMouseState();
}

void mouseReleased() {
  // Keep this at the top pls
  globalState.updateMouseState();

  for(Button button : activeButtons) {
    if(button.getPressed()) {
      button.onRelease();
      break;
    }
  }
}
