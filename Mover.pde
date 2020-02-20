DecimalFormat df = new DecimalFormat("#.#");
DecimalFormat tf = new DecimalFormat("#.###");

class Mover { // change to Mover later
  PImage vel;
  PImage acc;
  PImage impact;
  PVector position = new PVector(random(-400,400),random(-400,400));
  PVector velocity = new PVector(0,0);
  PVector friction = new PVector(0,0);
  List<PVector> points = new ArrayList<PVector>();
  List<PVector> velocities = new ArrayList<PVector>();
  List<PVector> accelerations = new ArrayList<PVector>();
  
  boolean showPositionGraph = true;
  boolean showVelocityGraph;
  boolean showAccelerationGraph;
  int hexCode;
  /** impact **/
  int count = -200;
  float impactX = 0;
  float impactY = 0;
   /** impact **/
  float siz;
  float ang = position.heading();
      
  public Mover(float si,float initV, int hex){
    siz = si;
    velocity.set(initV*cos(ang),initV*sin(ang));
    vel = images.get("vel");
    acc = images.get("acc");
    hexCode = hex;
    impact = images.get("impact");
    impact.resize(100,100);
    println(vel);
    print(degrees(ang));
    
  }
  
  public void setVelocity(float v){
    velocity.set(v*cos(ang),v*sin(ang));
  }
  
  public void setJerk(float j){ // might change later
    //jerk.set(j*cos(acceleration.heading()),j*sin(acceleration.heading()));
    jerk.set(0,j);
  }
  
  public void setAcceleration(float a){ // might change later when i add Newtons law of univ gravitation
   // acceleration.set(a*cos(velocity.heading()),a*sin(velocity.heading()));
   acceleration.set(0,a); 
  }
  
  public void friction(float coefficient){
     friction.x = -coefficient*velocity.x;
      //println("1: " + velocities.get(velocities.size()-2).x + " 2: " + velocities.get(velocities.size()-1).x);
  }
  
  public void loseEnergy(float coefficient){
    velocity.y *= 1-coefficient;
  }
  
  public void follow(){
   // if (position.y < height/2 - 10)
     // translate(-position.x,0);
     
  }
  
  public void edgeDetection(){ 
    float edgeSpace = siz/2;
    if (position.x > width/2-edgeSpace || position.x < edgeSpace-width/2){ //
      position.x = position.x > width/2-edgeSpace ? width/2-edgeSpace : edgeSpace-width/2;
      velocity.x *= -1;
    }

     else if (position.y < edgeSpace-height/2 || position.y > height/2 - edgeSpace){
       if (position.y > height/2 - edgeSpace){
         int squareSize = (int) map2(velocity.mag(),0,velocity.mag() + 40,60,300,8,1);
         if (squareSize == 0) squareSize = 300;
         //println(squareSize);
         impact.resize(squareSize,squareSize);
         
         if (points.get(points.size() - 2).y != points.get(points.size() - 1).y){
           sfile.play();
           count = frameCount;
           image(impact,position.x - 40, position.y + 15);
           impactX = position.x - 40;
           impactY = position.y + 15;
         }
         
         friction(0.1);
         loseEnergy(0.1);
       }
       
       position.y = position.y < edgeSpace-height/2 ? edgeSpace-height/2 : height/2-edgeSpace;
        velocity.y *= -1;
     } else
       friction.x = 0;
  }
  
  public void move(){
    //info();
           
    pushMatrix();
    points.add(position.copy());
    velocities.add(velocity.copy());
    accelerations.add(acceleration.copy());
    
    
    acceleration.add(PVector.mult(jerk,timescale));
    acceleration.add(friction);
    velocity.add(PVector.mult(acceleration,timescale));
    position.add(PVector.mult(velocity,timescale));
    graph();
    edgeDetection();
    popMatrix();
  //  println(position);
  
  if (count + 20 > frameCount)
    image(impact,impactX, impactY);
    
  }
  
  
  public void graph(){
    strokeWeight(5);
    
    if (showPositionGraph){
      stroke(hexCode);
      for (int i = 0; i < points.size()-1; i++){
        line(points.get(i).x,points.get(i).y,points.get(i+1).x,points.get(i+1).y);
      }
    }
    
    if (showVelocityGraph){
      stroke(255,255,255);
      for (int i = 0; i < points.size()-1; i++){
        line(velocities.get(i).x,velocities.get(i).y,velocities.get(i+1).x,velocities.get(i+1).y);
      }
    }
    
    if (showAccelerationGraph){
      stroke(40,255,255);
      for (int i = 0; i < points.size()-1; i++){
        line(accelerations.get(i).x,accelerations.get(i).y,accelerations.get(i+1).x,accelerations.get(i+1).y);
      }
    }
    
    if (points.size() > 75){
      points.remove(0);
      velocities.remove(0);
      accelerations.remove(0);
    }
    

  }
  
  public void info(){ // Refine later
    fill(255);
    textSize(36);
    text("Position: (" + round(position.x) + " , " + round(-position.y) + ")", width/2 - 380, 40-height/2);
    text("Velocity: " + round(velocity.mag()), width/2 - 380, 145-height/2);
    text("Acceleration: " + df.format(acceleration.mag()), width/2 - 380, 245-height/2);
    text("Timescale: " + tf.format(timescale) + "x",28-width/2, 50-height/2);
    vel.resize(100,70);
    acc.resize(100,70);
    
    pushMatrix(); //vel
    translate(width/2 - 150, 135-height/2);
    rotate(velocity.heading());
    image(vel,0,0);
    popMatrix();
    
    pushMatrix(); //acc
    translate(width/2 - 70, 235-height/2); // <---
    rotate(acceleration.heading());
    image(acc,0,0);
    popMatrix();
    
  }
  
  public void show(){
    imageMode(CENTER);
  //  image(images.get("grass"),0,height/2 - 50); For now
    noStroke();
    fill(map(velocity.mag(),0,100,0,255),255,255);
    circle(position.x,position.y,siz);
    move();
  }
}
