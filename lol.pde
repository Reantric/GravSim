Mover m;
System s;

void setup() {
  size(1920, 1080, P2D);
  s = new System(createGraphics(1920, 1080,P2D));
  s.canvas.textSize(180);

  imageMode(CENTER);
  for (int i = 0; i < 3; i++) {
   // new Mover(s, random(30, 60), random(100, 400));
  }
  new Mover(s,60,3000).setPos(250,0).applyForce = false;
  new Mover(s,50,4200).setPos(-250,0).applyForce = false;
  killaccvec = true;
  
  ogvel.add(new PVector()); ogvel.add(new PVector());
  
  Mover b = new Mover(s,60,20).setPos(-100,350);
  b.setVel(2.5,-1.8);
  b.observer = true;
}

float killvalstop = 200;
void draw() {
  background(0);
  translate(width/2, height/2);
  s.displayEssentials();
  s.drawVecField();
  s.messAround();
  int index = 0;
  for (Iterator<Mover> iter = s.allMovers.iterator(); iter.hasNext(); ) {
    Mover mover = iter.next();
    // if (mover.observer){
    mover.drawArrow = true;
    mover.addp = true;
    mover.displayPosGraph(true);
    mover.pulsate();

    if (killaccvec && !mover.observer) {
      //  mover.acc = new PVector(map2(time-stoptime,0,killvalstop,4,0,QUADRATIC,EASE_IN_OUT),map2(time-stoptime,0,killvalstop,4,0,QUADRATIC,EASE_IN_OUT));
      mover.acc = new PVector();
      mover.vel = new PVector(map2(s.time-stoptime, 0, killvalstop, ogvel.get(index).x, 0, QUADRATIC, EASE_IN_OUT), map2(s.time-stoptime, 0, killvalstop, ogvel.get(index).y, 0, QUADRATIC, EASE_IN_OUT));
      if (s.time-stoptime > killvalstop) {
        killaccvec = false;
        mover.acc = new PVector();
        mover.vel = new PVector();
      }
    }
    //v e  }
    mover.display();
    index++;
  }

  image(s.display(), 0, 0);

  //saveFrame("observer/bruh######.png");
}



public static float getColor(float m, float lowerBound, float upperBound) {
  return map(m, lowerBound, upperBound, 0, 255);
}




float stoptime = 0;
boolean killaccvec = false;
List<PVector> ogvel = new ArrayList();
public void keyPressed() {
  switch (key) {
    case ' ':
      ogvel.clear();
      stoptime = s.time;
      killaccvec = true;
      for (Mover m : s.allMovers) {
        if (!m.observer) {
          ogvel.add(m.vel.copy());
          m.applyForce = false;
        }
      }
      break;
     
     case 'g':
       s.deltatime *= 0.92f;
       break;
     
     case 'h':
       s.deltatime *= 1.08f;
       break;
    
  }
}

Mover setVelMover;
public void mousePressed() {
    if (setVelMover != null){
      setVelMover.setVelVec = !setVelMover.setVelVec;
      if (setVelMover.setVelVec){
        setVelMover.vel = new PVector(setVelMover.dist/100*cos(setVelMover.angle),setVelMover.dist/100*sin(setVelMover.angle));
    }
      setVelMover = null;
    }
    else {
    setVelMover = new Mover(s, 60, 5);
    setVelMover.pos = new PVector(mouseX-width/2, mouseY-height/2);
    setVelMover.acc = new PVector();
    setVelMover.vel = new PVector();
    setVelMover.observer = true;
    setVelMover.setVelVec = !setVelMover.setVelVec;
    Collections.sort(s.allMovers);
    }
  }
