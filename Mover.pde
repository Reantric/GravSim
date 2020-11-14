import java.util.*;

public class Mover implements Comparable<Mover>{
    LinkedList<PVector> bruh = new LinkedList();
    PVector pos, vel = new PVector(), acc = new PVector(0,0.01f), force, textPos = new PVector();
    System system;
    int maxPoints = 10400;
    boolean dpg = true, dpi, addp, drawArrow, observer, applyForce = true;
    float mass = 1;
    float r = 300;
    float col = random(0,255);
    float inc = 0;
    private PGraphics c;
    
    public Mover(System c, float r, float mass){
        pos = new PVector(random(-width/2,width/2),random(-height/2,height/2));
        //vel = new PVector(random(-2,2),random(-2,2)).mult(s.deltatime);
        system = c;
        this.c = system.canvas;
        this.c.smooth(8);
        this.r = r;
        this.mass = mass;
        system.allMovers.add(this);
    }
    
    public Mover setPos(float x, float y){
      pos.x = x;
      pos.y = y;
      return this;
    }
    
    public Mover setVel(float x, float y){
      vel.x = x;
      vel.y = y;
      return this;
    }
    
    public Mover setAcc(float x, float y){
     acc.x = x;
     acc.y = y;
      return this;
    }
    
    boolean setVelVec = true;
    float dist = 0;
    float angle = 0;
    public void observerVelVec(){
      if (!setVelVec){
        dist = dist(pos.x,pos.y,mouseX-width/2,mouseY-height/2);
        c.stroke(map(dist,0,dist(pos.x,pos.y,pos.x + width/2,pos.y + height/2),98,255),255,255,180);
        c.strokeWeight(5);
        c.pushMatrix();
        c.translate(pos.x,pos.y);
        angle = atan2(mouseY-height/2 - pos.y,mouseX-width/2 - pos.x);
        s.arrow(0,0,2*r*cos(angle),2*r*sin(angle));
        c.popMatrix();
      }
        
    }
    
    public void applyForce(PVector force){
      acc = PVector.div(force,mass);
      this.force = force;
    }
    
    public void edges(){
      textPos.y = pos.y - r/2;
      textPos.x = pos.x;
      
      if (textPos.y < 50-height/2){
        textPos.y += ((50-height/2) - textPos.y);
      }
      
      if (textPos.x < 63-width/2){
        textPos.x += ((63-width/2) - textPos.x);
      }
      
      if (textPos.x > width/2-63){
        textPos.x += ((width/2 - 63) - textPos.x);
      }
      
      if (pos.y > height/2){
        pos.y = height/2;
        vel.y *= -1;
      }
      
      if (pos.y < -height/2){
        pos.y = -height/2;
        vel.y *= -0.99;
      }
      
      if (pos.x < -width/2){
        pos.x = -width/2;
        vel.x *= -0.99;
      }
      
      if (pos.x > width/2){
        pos.x = width/2;
        vel.x *= -1;
      }
    }
    
    protected void tick(){

        PVector totalForce = new PVector();
        ListIterator<Mover> iter = s.allMovers.listIterator();
        while (iter.hasNext()){
          Mover m = iter.next();
          if (m == this || m.observer) continue;
          if (s.newtonOrColoumb)
            totalForce.add(PVector.sub(m.pos,pos).setMag(mass*m.mass / (float) Math.pow(pos.dist(m.pos),2)));
          else
            totalForce.add(PVector.sub(pos,m.pos).setMag(mass*m.mass / (float) Math.pow(pos.dist(m.pos),2)));
            
          if (abs(m.pos.x - pos.x) < r/1.5 && abs(m.pos.y - pos.y) < r/1.5 && !s.removeMovers.contains(this) && !observer){
            s.removeMovers.add(m);
            mass += m.mass;
            r += sqrt(m.r);
           // println("Boy");
          }
            
        }
        
        if (applyForce)
          applyForce(totalForce);
        
        vel.add(PVector.mult(acc,s.deltatime));
        pos.add(PVector.mult(vel,s.deltatime));
        edges();
        observerVelVec();
        
        if (addp)
          addPoint();
          
        if (drawArrow){
          c.stroke(col,observer ? 0 : 255,255);
          PVector totalFor = acc.copy().setMag(r + 30);
          s.arrow(pos.x,pos.y,pos.x + totalFor.x,pos.y + totalFor.y);
        }
        
        s.time += s.deltatime;
        
    }
    
    private void addPoint(){
              if (bruh.size() > maxPoints)
          bruh.remove(0);
          
        bruh.add(pos.copy());
    }
    
    public void pulsate(){
      c.noFill();
c.stroke(col,observer ? 0 : 255,255,255*(1-map2(inc,0,1,0,1,QUADRATIC,EASE_IN)));
      c.strokeWeight(5);
      c.circle(pos.x,pos.y,r*(1+inc));
      inc += s.deltatime*0.015;
      
      if (inc > 1)
        inc = 0;
    }

    public void display(){
        tick();
        
        if (dpg)
        displayPosGraph();
        
        if (dpi)
        displayInfo();
        
        c.textSize(36);
        c.fill(col,observer ? 0 : 255,255);
        c.noStroke();
        if (r != 0){
          c.circle(pos.x,pos.y,r);
        }
        c.fill(0,0,255);
        if (!observer)
          c.text(String.format("%.2f",mass),textPos.x,textPos.y);
    }
    
    private void displayPosGraph(){
     c.strokeWeight(4);
      ListIterator<PVector> iter = bruh.listIterator();
      PVector p = null;
      if (iter.hasNext()){
        p = iter.next();
      }
      while (iter.hasNext()){
          //canvas.stroke(getColor(iter.nextIndex(), 0, maxPoints),255,255);
         c.stroke(col,observer ? 0 : 255,255);
          PVector p2 = iter.next();
         c.line(p.x,p.y,p2.x,p2.y);
          p = p2;
      }
    }
    
    public void displayPosGraph(boolean display){
      dpg = display;
    }
    
    public void displayInfo(boolean display){
      dpi = display;
    }
    
    private void displayInfo(){
     c.textSize(40);
     c.text("Acceleration: " + String.format("[%.2f,%.2f]",acc.x,-acc.y),100-width/2,100-height/2);
     c.fill(200,255,255);
     c.text("Velocity: " + String.format("[%.2f,%.2f]",vel.x,-vel.y),100-width/2,170-height/2);
     c.fill(140,255,255);
     c.text("Force: " + String.format("[%.2f,%.2f]",force.x,-force.y),100-width/2,240-height/2);
     c.fill(200,255,255);
     c.text("Radius: " + String.format("%.2f m",r),100-width/2,310-height/2);
     c.fill(80,255,255);
     c.text("Mass: " + String.format("%.2f kg",mass),100-width/2,380-height/2);
    // c.text("Acceleration: " + String.format("[%.2f,%.2f]",acc.x,acc.y),100-width/2,100-height/2);
    }
    
    public String toString(){
      return ""+observer;
    }
    
    public System getSystem(){
      return s;
    }
    
    public int compareTo(Mover m2) {
      return m2.observer ? -1 : 1;
    }
}

   
    public static class Gravity {
      public static PVector gravityForce(System s,PVector pos, float mass){
      PVector totalForce = new PVector();
          ListIterator<Mover> iter = s.allMovers.listIterator();
        while (iter.hasNext()){
          Mover m = iter.next();
          if (m.observer) continue;
          if (s.newtonOrColoumb)
            totalForce.add(PVector.sub(m.pos,pos).setMag(mass*m.mass / (float) Math.pow(pos.dist(m.pos),2)));
          else
            totalForce.add(PVector.sub(pos,m.pos).setMag(mass*m.mass / (float) Math.pow(pos.dist(m.pos),2)));
        }
      return totalForce;
    }
    }
