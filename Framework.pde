import java.util.*;

static ArrayList<Render> renderObjects = new ArrayList<Render>();

static ArrayList<Render> relativeRenderObjects = new ArrayList<Render>();

static ArrayList<Button> activeButtons = new ArrayList<Button>();

static ArrayList<Button> allButtons = new ArrayList<Button>();

static Scene currentScene = null;

static Position cameraPosition = null;

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
      }
    } else {
      this.rightMouse = false;
      this.leftMouse = false;
    }
  }
}

interface Position {
  public PVector getPosition();
}

// Basic type for classes to inherit to become renderable
abstract class Render {
  protected boolean relativeToCamera = false;
  public abstract void render();
}

// Java doesn't have support for first class functions
// or delegates...
// so this is my solution
abstract class ButtonClickBehavior {
  abstract void onClick(Button button);
  abstract void onRelease(Button button);
}

// Basic button system to simplify button making
class Button extends Render implements Position {
  color buttonColor, textColor, pressedColor;
  String buttonText = "";
  PVector position, size;
  float textSize;
  ButtonClickBehavior clickBehavior;
  private boolean pressed;
  private boolean isToggle = false;

  @Override
  public PVector getPosition() {
    return position;
  }

  public boolean getPressed() {
    return pressed;
  }

  public void onClick() {
    clickBehavior.onClick(this);
    if(!isToggle) this.pressed = true;
    else {
      this.pressed = !this.pressed;
      if(!this.pressed) {
        onRelease();
      }
    }
    
  }
  
  public void onRelease() {
    if(this.pressed && this.isToggle) return;
    clickBehavior.onRelease(this);
    if(!isToggle) this.pressed = false;
  }

  Button(color _color, color pressedColor, String text, color textColor, float textSize, PVector position, PVector size, boolean toggle, ButtonClickBehavior clickBehavior) {
    this.buttonColor = _color;
    this.pressedColor = pressedColor;
    this.buttonText = text;
    this.position = position;
    this.size = size;
    this.textColor = textColor;
    this.textSize = textSize;
    this.clickBehavior = clickBehavior;
    this.isToggle = toggle;
    allButtons.add(this);
  }

  Button(color _color, color pressedColor, PVector position, PVector size, boolean toggle, ButtonClickBehavior clickBehavior) {
    this.buttonColor = _color;
    this.pressedColor = pressedColor;
    this.position = position;
    this.size = size;
    this.clickBehavior = clickBehavior;
    this.isToggle = toggle;
    allButtons.add(this);
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
    allButtons.add(this);
  }

  Button(color _color, color pressedColor, PVector position, PVector size, ButtonClickBehavior clickBehavior) {
    this.buttonColor = _color;
    this.pressedColor = pressedColor;
    this.position = position;
    this.size = size;
    this.clickBehavior = clickBehavior;
    allButtons.add(this);
  }

  Button(color _color, color pressedColor, String text, color textColor, float textSize, PVector position, PVector size, boolean toggle, boolean cameraRel, ButtonClickBehavior clickBehavior) {
    this.buttonColor = _color;
    this.pressedColor = pressedColor;
    this.buttonText = text;
    this.position = position;
    this.size = size;
    this.textColor = textColor;
    this.textSize = textSize;
    this.clickBehavior = clickBehavior;
    this.isToggle = toggle;
    this.relativeToCamera = cameraRel;
    allButtons.add(this);
  }

  Button(color _color, color pressedColor, PVector position, PVector size, boolean toggle, boolean cameraRel, ButtonClickBehavior clickBehavior) {
    this.buttonColor = _color;
    this.pressedColor = pressedColor;
    this.position = position;
    this.size = size;
    this.clickBehavior = clickBehavior;
    this.isToggle = toggle;
    this.relativeToCamera = cameraRel;
    allButtons.add(this);
  }


  public Button activate() {
    activeButtons.add(this);
    if(this.relativeToCamera) relativeRenderObjects.add(this);
     else renderObjects.add(this);
    return this;
  }

  public Button deactivate() {
    activeButtons.remove(this);
    if(this.relativeToCamera) relativeRenderObjects.remove(this);
    else renderObjects.remove(this);
    return this;
  }

  public void render() {
    fill(this.pressed ? this.pressedColor : this.buttonColor);
    rect(this.position.x, this.position.y, this.size.x, this.size.y);
    fill(this.textColor);
    textSize(this.textSize);
    text(this.buttonText, this.position.x, this.position.y, this.size.x, this.size.y);
  }
}

class Box extends Render implements Position {
  color bgColor, textColor;
  PVector position, size;
  float textSize;
  String text = "";

  @Override
  public PVector getPosition() {
    return position;
  }

  Box(String text, float textSize, color bgColor, color textColor, PVector position, PVector size) {
    this.bgColor = bgColor;
    this.textColor = textColor;
    this.text = text;
    this.position = position;
    this.size = size;
    this.textSize = textSize;
  }

  Box(color bgColor, PVector position, PVector size) {
    this.bgColor = bgColor;
    this.position = position;
    this.size = size;
  }

  void render() {
    fill(this.bgColor);
    rect(this.position.x, this.position.y, this.size.x, this.size.y);
    fill(this.textColor);
    textSize(this.textSize);
    text(this.text, this.position.x, this.position.y, this.size.x, this.size.y);
  }
}

class Circle extends Render implements Position {
  color bgColor;
  PVector position;
  float size;

  @Override
  public PVector getPosition() {
    return position;
  }

  Circle(color bgColor, PVector position, float size) {
    this.bgColor = bgColor;
    this.position = position;
    this.size = size;
  }

  void render() {
    fill(this.bgColor);
    ellipse(this.position.x, this.position.y, this.size, this.size);
  }
}

abstract class SceneBehavior {
  void scene_draw() {}

  void scene_mousePressed() {}
  void scene_mouseReleased() {}
  void scene_keyPressed() {}
  void scene_keyReleased() {}
  
  abstract void load(Scene scene);
  abstract void unload(Scene scene);
}

class Scene {
  ArrayList<Render> sceneRenderObjs;
  SceneBehavior sceneBehavior;
  Scene(Render[] sceneObjs, SceneBehavior behavior) {
    this.sceneRenderObjs = new ArrayList<Render>(Arrays.asList(sceneObjs));
    this.sceneBehavior = behavior;
  }

  public void setSceneBehavior(SceneBehavior behavior) {
    sceneBehavior = behavior;
  }

  public final void addRenderObject(Render obj) {
    sceneRenderObjs.add(obj);
    renderObjects.add(obj);
  }

  public void scene_draw() {
    sceneBehavior.scene_draw();
  }

  public void scene_mousePressed() {
    sceneBehavior.scene_mousePressed();
  }

  public void scene_mouseReleased() {
    sceneBehavior.scene_mouseReleased();
  }

  public void scene_keyPressed() {
    sceneBehavior.scene_keyPressed();
  }

  public void scene_keyReleased() {
    sceneBehavior.scene_keyReleased();
  }
  
  public void load() {
    if(currentScene != null) currentScene.unload();
    currentScene = this;
    sceneBehavior.load(this);
  }

  public void unload() {
    sceneBehavior.unload(this);
  }
}

// Single reference to the state of the program
GlobalState globalState = new GlobalState();

void draw() {
  if(currentScene != null) {
    currentScene.scene_draw();
  }
  for(Render renderOb : relativeRenderObjects) {
    renderOb.render(); 
  }
  if(cameraPosition != null) {
    PVector pos = cameraPosition.getPosition();
    translate(-pos.x + (width / 2), pos.y - (height / 2));
  }
  // render step
  for(Render renderOb : renderObjects) {
    renderOb.render(); 
  }
}

void mousePressed() {
  for(Button button : activeButtons) {
    if(mouseX
      + (cameraPosition != null && !button.relativeToCamera ? cameraPosition.getPosition().x : 0)
      > button.position.x && mouseY > button.position.y
      && mouseX
      + (cameraPosition != null && !button.relativeToCamera ?cameraPosition.getPosition().x : 0)
      < (button.position.x + button.size.x) &&
      mouseY
      + (cameraPosition != null && !button.relativeToCamera ? cameraPosition.getPosition().y : 0)
      < (button.position.y + button.size.y)
      && globalState.leftMouseClicked()) {
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

void keyPressed() {
  if(currentScene != null) {
    currentScene.scene_keyPressed();
  }
}

void keyReleased() {
  if(currentScene != null) {
    currentScene.scene_keyReleased();
  }
}
