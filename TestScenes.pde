final Scene testScene = new Scene(new Render[] {
  new Cell(50.0, 100.0, 0.5, 100.0, color(random(255), random(255), random(255))),
  new Particle(new PVector(width / 2.0 + 200.0, height / 2.0), 20.0, 20.0),

  new Button(color(0, 255, 0), color(0, 128, 0), "Add new Cell", color(0,0,0), 24.0, new PVector(0, 0), new PVector(155, 30), false, true, new ButtonClickBehavior() {
    public void onClick(Button button) {
      currentScene.addRenderObject(new Cell(50.0 + random(20), 100.0 + random(20), 0.5, 100.0, color(random(255), random(255), random(255))));
      currentScene.addRenderObject(new Particle(new PVector(width / 2.0 + random(200.0), height / 2.0), 20.0, 20.0));
    }
    public void onRelease(Button button) {}
  }),
  
  new Button(color(180, 180, 0), color(90, 90, 0), "Focus on First cell", color(0,0,0), 24.0, new PVector(width - 220, 0), new PVector(220, 30), true, true, new ButtonClickBehavior() {
    public void onClick(Button button) {
      cameraPosition = allCells.get(0);
    }
    public void onRelease(Button button) {
      cameraPosition = null;
    }
  })
}, new SceneBehavior() {
      public void load(Scene scene) {}

      public void unload(Scene scene) {}
});

final Scene testScene2 = new Scene(new Render[] {
  new Box("This is a second scene!", 36.0, color(255), color(0), new PVector(width/2.0, height/2.0), new PVector(300.0, 200.0))
}, new SceneBehavior() {  
  public void scene_draw() {
    background(90);
  }

  public void load(Scene scene) {
    for(Render renderObj : scene.sceneRenderObjs) {
        renderObjects.add(renderObj);
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
  
  public void scene_keyPressed() {
    if(key == CODED) {
      if(keyCode == LEFT) {
        testScene.load();
      }
    }
  }
});

// void setup() {
//   testScene.setSceneBehavior(new SceneBehavior() {
//     public void scene_draw() {
//       background(51);
//       // Cell simulation step
//       for(Cell cell : allCells) {
//         cell.move(1, 0);
//       }
//     }

//     public void load(Scene scene) {

//       for(Render renderObj : scene.sceneRenderObjs) {
//         if(renderObj instanceof Button) {
//           Button actuallyButton = (Button)renderObj;
//           actuallyButton.activate();
//         } else {
//           renderObjects.add(renderObj);
//         }
//       }
//     }

//     public void unload(Scene scene) {
//       for(Render renderObj : scene.sceneRenderObjs) {
//         if(renderObj instanceof Button) {
//           Button actuallyButton = (Button)renderObj;
//           actuallyButton.deactivate();
//         } else {
//           renderObjects.remove(renderObj);
//         }
//       }
//     }
    
//     public void scene_keyPressed() {
//       if(key == CODED) {
//         if(keyCode == RIGHT) {
//           testScene2.load();
//         }
//       }
//     }
//   });
//   testScene.load();
// }