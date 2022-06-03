Cell[] population = new Cell[1000];

void setup() {
  size(800, 600);
  frameRate(30);
  noStroke();

  for(int i = 0; i < population.length; i++) {
    population[i] = new Cell();
  }
  
  final Scene dish = new Scene(new Render[] {
    new Circle(color(200), new PVector(0, 0), 1000),
  }, new SceneBehavior() {
      public void scene_draw() {
        background(10);
        translate(width/2, height/2);
      }

      public void load(Scene scene) {
        for(Render renderObj : scene.sceneRenderObjs) {
          if(renderObj instanceof Button) {
            Button actuallyButton = (Button)renderObj;
            actuallyButton.activate();
          } else {
            renderObjects.add(renderObj);
          }
        }
      }

      public void unload(Scene scene) {
        for(Render renderObj : scene.sceneRenderObjs) {
          if(renderObj instanceof Button) {
            Button actuallyButton = (Button)renderObj;
            actuallyButton.deactivate();
          } else {
            renderObjects.remove(renderObj);
          }
        }
      }
  });

  new Scene(new Render[] {
    new Box("Evolution Simulator", 72.0, color(#291F47, 0), color(0), new PVector(width / 2 - 680 / 2, 100), new PVector(680, 100)),
    new Button(color(#21D321), color(#194D2B), "Start", color(0), 72.0, new PVector(width / 2 - 200 / 2, height - 200), new PVector(165, 90), new ButtonClickBehavior() {
      public void onClick(Button button) {
        dish.load();
      }
      public void onRelease(Button button) {}
    }),
  }, new SceneBehavior() {
      public void scene_draw() {
        background(90);
      }
      public void load(Scene scene) {

        for(Render renderObj : scene.sceneRenderObjs) {
          if(renderObj instanceof Button) {
            Button actuallyButton = (Button)renderObj;
            actuallyButton.activate();
          } else {
            renderObjects.add(renderObj);
          }
        }
      }

      public void unload(Scene scene) {
        for(Render renderObj : scene.sceneRenderObjs) {
          if(renderObj instanceof Button) {
            Button actuallyButton = (Button)renderObj;
            actuallyButton.deactivate();
          } else {
            renderObjects.remove(renderObj);
          }
        }
      }
  }).load();
}