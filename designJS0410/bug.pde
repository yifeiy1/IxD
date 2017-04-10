PImage myBG;
PImage myMaskBack;
PImage myMask;
PImage myLoad;
PImage myContour;

PVector coord;


//int count = 0 ;
ArrayList myBGcollectiom = new ArrayList();

float scal, theta;
int letterIndex = 0;
PVector[] letterCenterArray = new PVector[2];
float[] distance = new float[2];

/******** For LETTERS *********/
int num = 1800;
ArrayList letterCollection = new ArrayList();
float sval = 1.0;
int i = 0;
/******** For Testing *********/
int balln = 0;
int j = 0;

float opacity;

void setup() {
  size(1749, 983);
  myBG = loadImage("bgtest2.png");
  drawBG();
  myMaskBack = loadImage("maskback.png");
  myMask = loadImage("maskfront.png");
  loadStuff("sgroup.png", 500, 500);
  loadStuff("g.png", 1100, 500);
  drawContour();
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
   
   image(myMaskBack, (mouseX-145), (mouseY-145));


   String displayMessage = "test";
   float locationx= 0 ;
   float locationy= 0;
   float diameter = 10;
   boolean stateGrow = false;

   float mindist = 1000;//local variable or better as a global variable?
   for (int i = 0; i<letterCollection.size(); i++){
     Letter ml = (Letter) letterCollection.get(i);
     ml.run();
     for (int j = 0; j < ml.letterBall.size(); ++j) {
       Ball mb = (Ball) ml.letterBall.get(j);
       float distance = abs(mb.loc.x - mouseX) + abs(mb.loc.y - mouseY);
       if (distance < mindist) {
         mindist = distance;
         displayMessage = mb.message;
         locationx = mb.loc.x;
         locationy= mb.loc.y;
       }
      }
    }

   image(myMask, (mouseX-1749), (mouseY-983));

   if (mousePressed && mindist < 20) {
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
   nearest();
}

void loadStuff(String l, int x, int y) {
  myLoad = loadImage(l);
  myLoad.loadPixels();
  coord = new PVector(x, y);
  letterCenterArray[letterIndex] = new PVector(x+myLoad.width/2, y+myLoad.height/2);
  letterIndex++;
  letterCollection.add(new Letter());
  myLoad.updatePixels();
}

void nearest(){
  for (int i = 0; i< distance.length; i++){
    distance[i] = sqrt((mouseX - letterCenterArray[i].x)*(mouseX - letterCenterArray[i].x) + (mouseY -letterCenterArray[i].y)*(mouseY - letterCenterArray[i].y));
    //ellipse(roughdots[i].x, roughdots[i].y, 16, 16);
  }
  float dismin = constrain(min(distance), 0, 400);
  float volume = map(dismin, 0, 400, 1, 0.1);
  getVolume(volume);
}


void displayMessage(){

}

void printData(String data) {
  println(data);
}


class Letter{
  ArrayList letterBall = new ArrayList();
  Letter() {
    for (int i = 0; i <myLoad.width; i++) {
      for (int j = 0; j<myLoad.height; j++){
        color c= myLoad.get(i, j);
        // println(c);
        if (c != 0){
          println(c);
          PVector org = new PVector(i+coord.x,j+coord.y);
          float radius = random(5,10);
          PVector loc = new PVector(org.x+radius, org.y);
          float offSet = random(TWO_PI);
          float dir = 0.1;
          float r = random(1);
          int randomStar= int(random(0, 20));
          if (r>.5) dir =-0.1;
          Ball myBall = new Ball(org, loc, radius, dir, offSet, randomStar);
          letterBall.add(myBall);
        }
      }
    }
  }

  void run (){
    for (int i=0; i<letterBall.size (); i++) {
      Ball mb = (Ball) letterBall.get(i);
      // mb.connection[i] = false;
      mb.run();
      for (int j=i; j<letterBall.size(); j++) {
        Ball other = (Ball) letterBall.get(j);
        //float distance = loc.dist(other.loc);
        float distance = abs(mb.loc.x - other.loc.x) + abs(mb.loc.y - other.loc.y);
        
        // if (mb.connection[i] == false){
          if (distance >20 && distance < 45) {
            mb.a = map(mb.countC,0,10,100,255);
            stroke(255, mb.a);
            strokeWeight(3);
            line(mb.loc.x, mb.loc.y, other.loc.x, other.loc.y);
          //   mb.connection[i] = true;
          // }          
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
  int d = 40;
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
      ellipse(loc.x, loc.y, 8, 8);
    }          
  }
}

void drawBG(){
  myBG = loadImage("bgtest2.png");
  myBG.loadPixels();
  for (int i = 0; i < width; i=i+int(random(30,80))) {
    for (int j = 0; j<height; j=j+int(random(10,100))){
      color c= myBG.get(i, j);
      if (c != -15461356){
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
  myBG.updatePixels();
}

void drawContour(){
  myContour = loadImage("s.png");
  myContour.loadPixels();
  for (int i = 0; i < myContour.width; i= i+ int(random(3,8))) {
    for (int j = 0; j<myContour.height; j= j+ int(random(1,10))){
      color c= myContour.get(i, j);
      //println(c);
      if ((c != 0)&&(c!=-15461356)){
        // println(c);
        PVector org = new PVector(i+500,j+500);
        float radius = random(5, 15);
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
  myContour.updatePixels();  
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