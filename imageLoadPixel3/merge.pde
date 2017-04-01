//test
PImage myImage;
int halfImage;
int count = 0 ;
ArrayList myBallCollection = new ArrayList();
float scal, theta;

void setup() {
  size(1749, 983);
  
  halfImage = width * height/2;
  myImage = loadImage("testLarge.png");
  myImage.loadPixels();
  for (int i = 0; i < width; i=i+int(random(5,10))) {
    for (int j = 0; j<height; j=j+int(random(1,10))){
      color c= myImage.get(i, j);
      //println(c);
      if (c != -15461356){
        println(c);
        PVector org = new PVector(i,j);
        float radius = random(5,15);
        PVector loc = new PVector(org.x+radius, org.y);
        float offSet = random(TWO_PI);
        float dir = 0.1;
        float r = random(1);
        int randomStar= int(random(0, 20));
        if (r>.5) dir =-0.1;
        Ball myBall = new Ball(org, loc, radius, dir, offSet, randomStar);
        myBallCollection.add(myBall);
      }

      //myImage.pixels[i+halfImage] = myImage.pixels[i];
    }
  }
  myImage.updatePixels();
  print(count);
}

void draw() {
  background(20);
  theta += .0523;
  for (int j = 0; j < myBallCollection.size(); ++j) {
       Ball mb = (Ball) myBallCollection.get(j);
       mb.run();
  }
   
}


class Ball {
  PVector org, loc;
  float sz = 2; //ball sz=2
  float radius, offSet, a;
  float dir =  10; 
  int d = 38;
  int countC = 1;
  String message;
  float ranColor3;
  int randomStar = int(random(0, 20));

  Ball(PVector _org, PVector _loc, float _radius, float _dir, float _offSet, int randomStar) {
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
    fill(255,200,255);
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