import java.util.*;

static ArrayList<Render> renderObjects = new ArrayList<Render>();

static ArrayList<Button> activeButtons = new ArrayList<Button>();

static ArrayList<Button> allButtons = new ArrayList<Button>();

static Scene currentScene = null;

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

// Basic type for classes to inherit to become renderable
abstract class Render {
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
    clickBehavior.onClick(this);
  }
  
  public void onRelease() {
    this.pressed = false;
    clickBehavior.onRelease(this);
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

  public Button activate() {
    activeButtons.add(this);
    renderObjects.add(this);
    return this;
  }

  public Button deactivate() {
    activeButtons.remove(this);
    renderObjects.remove(this);
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

class TextBox extends Render {
  color bgColor, textColor;
  PVector position, size;
  float textSize;
  String text;

  TextBox(String text, float textSize, color bgColor, color textColor, PVector position, PVector size) {
    this.bgColor = bgColor;
    this.textColor = textColor;
    this.text = text;
    this.position = position;
    this.size = size;
    this.textSize = textSize;
  }

  void render() {
    fill(this.bgColor);
    rect(this.position.x, this.position.y, this.size.x, this.size.y);
    fill(this.textColor);
    textSize(this.textSize);
    text(this.text, this.position.x, this.position.y, this.size.x, this.size.y);
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
  // render step
  for(Render renderOb : renderObjects) {
    renderOb.render(); 
  }
}

void mousePressed() {
  for(Button button : activeButtons) {
    if(mouseX > button.position.x && mouseY > button.position.y && mouseX < (button.position.x + button.size.x) && mouseY < (button.position.y + button.size.y) && globalState.leftMouseClicked()) {
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
