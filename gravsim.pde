import java.util.*;
import java.text.*;
import processing.sound.*;
SoundFile sfile;
float e = 1;
float timescale = 1;

PGraphics graph;
PFont myFont;
PImage grass;
boolean isClicked = false;
public Map<String,PImage> images = new HashMap<String,PImage>();
Mover s,b;
PVector acceleration, jerk;
List<Mover> all = new ArrayList<Mover>();

void setup(){
  acceleration = new PVector(0,0);
  jerk = new PVector(0,0);
  
  sfile = new SoundFile(this,"boom3.mp3");
  myFont = createFont("Lato Bold",150,true);
  textFont(myFont);
  size(1920,1080,P2D);
  smooth(8);
  colorMode(HSB);
  File[] files = new File("C:\\Users\\JOHN\\Desktop\\whyArrayList\\gravsim\\data").listFiles();
  for (File f: files){
    String a = f.getName();
    images.put(a.substring(0,a.indexOf(".")),loadImage(a)); //files --> LC, get file
  }

  images.get("grass").resize(3000,130);
  imageMode(CENTER);
  
  // Instantiate below
  s = new Mover(40,5,#0000ff);
  b = new Mover(20,5,#ff0000);
  all.add(s);
  all.add(b);
}




void draw(){
  scale(e);
  translate(width/2,height/2);
  background(0);
  pushMatrix();
  for (Mover m: all){
    m.setJerk(jerk.y);
    m.setAcceleration(acceleration.y);
    m.follow();
    m.show();
  }
  popMatrix();
  s.info();
  
  if (isClicked)
    timescale /= 1.01;
 
 graph = createGraphics(400,400,P2D);
}

void keyPressed(){
  switch (key){
    case 'a':
      acceleration.set(0,1);
      break;
    case 'j':
      jerk.set(0,0.001);
      break;
    case 'v':
     s.velocity.mult(2);
     break;
    case 'c':
      isClicked = !isClicked;
      break;
  }
}

//void mousePressed(){
 // s.setVelocity(s.velocity.mag()*1.01);
//}

void mouseClicked(){
  if (abs(mouseX - s.position.x - width/2) < s.siz && abs(mouseY - s.position.y - height/2) < s.siz){
    //
  }
}

void mouseWheel(MouseEvent event) {
  e += -0.07*event.getCount();
}

void increaseScale(){
  e += 0.01;
}
