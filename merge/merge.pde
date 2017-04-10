import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer song;

PImage myImage;
PImage myMask;
PImage myS;

//int count = 0 ;
ArrayList myBGcollectiom = new ArrayList();
PVector[] roughdots = new PVector[6];
float[] distance = new float[6];
float[] callibrate = new float[6];

float scal, theta;
int q = 0;

/******** For LETTERS *********/
int fc, num = 1800;
ArrayList letterCollection;
boolean save = false;
PGraphics letter;
PFont font;
float sval = 1.0;
int i = 0;
/******** For Testing *********/
int balln = 0;
int j = 0;
float diameter = 10;
boolean stateGrow = false;
float opacity;

void setup() {
//BG START  
  size(1749, 983);
  myImage = loadImage("bgtest2.png");
  myImage.loadPixels();
  for (int i = 0; i < width; i=i+int(random(3,8))) {
    for (int j = 0; j<height; j=j+int(random(1,10))){
      color c= myImage.get(i, j);
      //println(c);
      if (c != -15461356){
        //println(c);
        PVector org = new PVector(i,j);
        float radius = random(5,15);
        PVector loc = new PVector(org.x+radius, org.y);
        float offSet = random(TWO_PI);
        float dir = 0.1;
        float r = random(1);
        int randomStar= int(random(0, 20));
        if (r>.5) dir =-0.1;
        BGBall myBall = new BGBall(org, loc, radius, dir, offSet, randomStar);
        myBGcollectiom.add(myBall);
      }
    }
  }
  myImage.updatePixels();
  myImage = loadImage("maskback.png");
  myMask = loadImage("maskfront.png");
  minim = new Minim(this);
  song = minim.loadFile("song.mp3");
  song.play();
  song.setGain(-20);

  
  
  
//BG END
  letter = createGraphics(width, height);
  font = loadFont("Futura-Medium-48.vlw");  
  letterCollection = new ArrayList();
  createStuff("D");
  createStuff("e");
  createStuff("s");
  createStuff("i");
  createStuff("g");
  createStuff("n");
}

void draw() {
  background(0);
  theta += .0523;
  for (int j = 0; j < myBGcollectiom.size(); ++j) {
       BGBall mb = (BGBall) myBGcollectiom.get(j);
       mb.run();
  }   
   if(mousePressed) {
    //  sval += 0.05;
    sval = 1;
   } else {
    //  sval -= 0.1;
    sval = 1;
   }
   sval = constrain(sval, 1.0, 8.0);
   translate((1 - sval) * mouseX, (1 - sval) * mouseY);

   scale(sval);
   
   image(myImage, (mouseX-145), (mouseY-145));

   String displayMessage = "test";
   float locationx= 0 ;
   float locationy= 0;
   float mindist = 1000;

   for (int i = 0; i<letterCollection.size(); ++i){
     Letter ml = (Letter) letterCollection.get(i);
     ml.run();
     for (int j = 0; j < ml.myBallCollection.size(); ++j) {
       Ball mb = (Ball) ml.myBallCollection.get(j);

       float distance = abs(mb.loc.x - mouseX) + abs(mb.loc.y - mouseY);
       if (distance < mindist) {
         mindist = distance;
         //displayMessage = mb.message;
         displayMessage = mb.message;
         locationx = mb.loc.x;
         locationy= mb.loc.y;
       }
     }
   }

  image(myMask, (mouseX-1749), (mouseY-983));

   if (mousePressed && mindist < 20) {
    //  println(displayMessage);
     textSize(20);
     text(displayMessage, locationx+20, locationy+5);
     
     fill(29,161,242,opacity);
     if (diameter >= 14){
       stateGrow = true;
     }
     if (diameter <= 10){
       stateGrow = false;
     }
     if(stateGrow == false){
       diameter+= 0.2;
       opacity = map(diameter,6,18,0,255);
       ellipse(locationx, locationy, diameter, diameter);
    
     }
     if(stateGrow == true){
        diameter-= 0.1;
        ellipse(locationx, locationy, diameter, diameter);
     }
     
     
     
     
   }

  if (save) {
    if (frameCount%1==0 && frameCount < fc + 30) saveFrame("image-####.gif");
  }   
  
  nearest();
  
}


class BGBall {
  PVector org, loc;
  float sz = 2; //ball sz=2
  float radius, offSet, a;
  float dir =  10; 
  int d = 38;
  int countC = 1;
  String message;
  int randomStar = int(random(0, 20));

  BGBall(PVector _org, PVector _loc, float _radius, float _dir, float _offSet, int randomStar) {
    org = _org;
    loc = _loc;
    radius = _radius;
    dir = _dir;
    offSet = _offSet;
    //message = "Design ≠ Design ≠ Design";
  }

  void run() {
    display();
    move();
  }

  void move() {
    //loc.x = org.x;
    loc.x = org.x + sin(theta*dir+offSet)*radius;
    loc.y = org.y + cos(theta*dir+offSet)*radius;
  }

  void display() {
    noStroke();
    fill(255,255,255,100);
    if ((randomStar >= 1) && (randomStar <= 10)){
      ellipse(loc.x, loc.y, 2, 2);
    }
    if ((randomStar >= 11) || (randomStar <= 19)){
      ellipse(loc.x, loc.y, 3, 2);
    }
    if (randomStar == 0){
      pushMatrix();
      translate(loc.x-1, loc.y-1);
      rotate(frameCount / -100.0);
      //star(loc.x-1183, loc.y-300, 2, 4.67, 5); 
      //star(loc.x, loc.y, 2, 4.67, 5);    
      star(0, 0, 2, 4.67, 5);        
      popMatrix();
    }
            
  }
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void createStuff(String l) {
  //ballCollection.clear();
  float randomHeight = random(200,700);
  letter.beginDraw();
  letter.noStroke();
  letter.background(255);
  letter.fill(0);
  letter.textFont(font, 400);
  letter.textAlign(LEFT);
  letter.text(l, i, randomHeight);//design
  letter.endDraw();
  letter.loadPixels();
  i+=textWidth(l)*40;
  
  callibrate[0]=150;
  callibrate[1]=110;
  callibrate[2]=130;
  callibrate[3]=130;
  callibrate[4]=130;
  callibrate[5]=110;
  PVector textContour = new PVector((i-textWidth(l)/2*40),randomHeight-callibrate[q]);
  //roughdots.add(textContour);
  
  roughdots[q] = textContour;
  q++;

  letterCollection.add(new Letter());

}

void nearest(){
  
  for (int i = 0; i< 6; i++){
    distance[i] = sqrt((mouseX - roughdots[i].x)*(mouseX - roughdots[i].x) + (mouseY -roughdots[i].y)*(mouseY - roughdots[i].y));
    //ellipse(roughdots[i].x, roughdots[i].y, 16, 16);
  }
  float dismin = min(distance);
  //print(dismin);
  for (int i = 0; i< 6; i++){
    if (dismin == distance[i]){
      //println(i);//nearst string
    }
  }
  float volume = map(dismin, 0, 400, 0, -sqrt(25));
  if (volume*volume<3){
    volume = sqrt(3);
  }
  if (volume*volume>25){
    volume = sqrt(25);
  }  
  
  song.setGain(-volume*volume);
  //println(dismin);
  //println(-volume*volume);
}

class Letter{
  ArrayList myBallCollection = new ArrayList();

  Letter() {
    for (int i=0; i<num; i++) {
      int x = (int)random(width);
      int y = (int)random(height);
      //color c = letter.get(x, y);
      int c = letter.pixels[x+y*width];
      if (brightness(c)<255) {
        PVector org = new PVector(x, y);
        float radius = random(5, 10);
        PVector loc = new PVector(org.x+radius, org.y);
        float offSet = random(TWO_PI);
        float dir = 0.1;
        float r = random(1);
        int randomStar= int(random(0, 20));
        if (r>.5) dir =-0.1;
        Ball myBall = new Ball(org, loc, radius, dir, offSet, randomStar);
        myBallCollection.add(myBall);
      }
    }
  }

  void run (){
    for (int i=0; i<myBallCollection.size (); i++) {
      Ball mb = (Ball) myBallCollection.get(i);
      mb.connection[i] = false;
      mb.run();
      

      for (int j=i; j<myBallCollection.size(); j++) {
        Ball other = (Ball) myBallCollection.get(j);
        //float distance = loc.dist(other.loc);
        float distance = abs(mb.loc.x - other.loc.x) + abs(mb.loc.y - other.loc.y);
        
        if (mb.connection[i] == false){
          if (distance >40 && distance < mb.d) {
            mb.a = map(mb.countC,0,10,100,255);
            stroke(255, mb.a);
            strokeWeight(3);
            line(mb.loc.x, mb.loc.y, other.loc.x, other.loc.y);
            mb.connection[i] = true;
          }          
        }
      }
    }
  }
}

class Ball {

  PVector org, loc;
  float sz = 2; //ball sz=2
  float radius, offSet, a;
  float dir =  10; 
  int d = 60;
  int countC = 1;
  boolean[] connection = new boolean[num];
  String message;
  float ranColor3;
  int randomStar = int(random(0, 20));

  Ball(PVector _org, PVector _loc, float _radius, float _dir, float _offSet, int randomStar) {
    org = _org;
    loc = _loc;
    radius = _radius;
    dir = _dir;
    offSet = _offSet;
    message = "From spoon to the city" + str(balln);
    ++balln;
  }

  void run() {
    display();
    move();
  }

  void move() {
    loc.x = org.x;
    //loc.x = org.x + sin(theta*dir+offSet)*radius;
    loc.y = org.y + cos(theta*dir+offSet)*radius;
  }

  void display() {
    noStroke();
    fill(200,200,200);
    if ((randomStar >= 1) && (randomStar <= 10)){
      ellipse(loc.x, loc.y, 8, 8);
    }
    if ((randomStar >= 11) || (randomStar <= 19)){
      ellipse(loc.x, loc.y, 4, 4);
    }
    if (randomStar == 0){
      pushMatrix();
      translate(loc.x-1, loc.y-1);
      rotate(frameCount / -100.0);
      //star(loc.x-1183, loc.y-300, 2, 4.67, 5); 
      //star(loc.x, loc.y, 2, 4.67, 5);    
      star(0, 0, 2, 4.67, 5);        
      popMatrix();
    }          
  }
}