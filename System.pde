public class System {
  List<Mover> allMovers = new ArrayList();
  List<Mover> removeMovers = new ArrayList();
  float time, deltatime = 1;
  PGraphics canvas;
  boolean newtonOrColoumb = true; // true for newton, false for coloumb
  
  public System(PGraphics c){
    canvas = c;
    Collections.sort(allMovers);
  }
  
  public void displayEssentials(){
  canvas.beginDraw();
  canvas.translate(width/2, height/2);
  canvas.background(0);
  canvas.textAlign(CENTER, BOTTOM);
  canvas.colorMode(HSB);
  allMovers.removeAll(removeMovers);
  removeMovers.clear();
  }
  
  public void messAround() {
  canvas.textSize(50);
  canvas.fill(230, 255, 255);
  canvas.text(String.format("Timestep: %.2f s", deltatime), -740, -460);
}

public PGraphics display(){
  canvas.endDraw();
  return canvas;
}

void arrow(float x1, float y1, float x2, float y2) {
  canvas.line(x1, y1, x2, y2);
  canvas.pushMatrix();
  canvas.translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  canvas.rotate(a);
  canvas.line(0, 0, -10, -10);
  canvas.line(0, 0, 10, -10);
  canvas.popMatrix();
} 


public void drawVecField() {
  // c.translate(-width/2,-height/2);
  for (int i = -width/2 - 20; i < width/2 + 20; i+= 90) {
    for (int j = -height/2 - 20; j < height/2 + 20; j+= 90) {
      PVector force = Gravity.gravityForce(this,new PVector(i, j), 1);
      float mag = force.mag();
      force.setMag(30);
      s.canvas.stroke(map(mag, 0, 0.21, 97, 255), 255, 255, 160); // def 130
      //println(mag);
      arrow(i, j, i+force.x, j+force.y);
    }
  }
}
}
