int fc, num = 25000;
int numNew = 35000;
ArrayList letterCollection;
boolean save = false;
float scal, theta;
PGraphics letter;
PFont font;
float sval = 1.0;
int i = 0;

/******** For Testing *********/
int balln = 0;

// String line = "|";
int j = 0;
int timeDelay = 320; //milliseconds in one minute
int time = 0;
boolean bFlashBg = true;

void setup() {
  background(0);
  size(1880, 1000);
  letter = createGraphics(width, height);
  //font = loadFont("Arial-Black-250.vlw");
  font = createFont("Arial",400,true);
  letterCollection = new ArrayList();
  createStuff("d");
  createStuff("e");
  createStuff("s");
  createStuff("i");
  createStuff("g");
    createStuff("n");
  //frameRate(1);
}

void draw() {
  background(20);
   //filter(ERODE);

   if(mousePressed) {
     sval += 0.05;
   } else {
     sval -= 0.1;
   }
   sval = constrain(sval, 1.0, 2.0);

   translate((1 - sval) * mouseX, (1 - sval) * mouseY);
   scale(sval);

   string displayMessage;
   float mindist = 1000;

  // for (int i=0; i<ballCollection.size (); i++) {
  //   Ball mb = (Ball) ballCollection.get(i);
  //   mb.run();
  //   float distance = abs(mb.loc.x - mouseX) + abs(mb.loc.y - mouseY);
  //   if (distance < mindist) {
  //     mindist = distance;
  //     displayMessage = mb.message;
  //   }
  // }


   for (int i = 0; i<letterCollection.size(); ++i){
     Letter ml = (Letter) letterCollection.get(i);
     ml.run();
     for (int j = 0; j < ml.myBallCollection.size(); ++j) {
       Ball mb = ml.myBallCollection.get(j);


      //  for (int j=0; j<ml.myBallCollection.size(); j++) {
      //    Ball other = (Ball) ml.myBallCollection.get(j);
      //    //float distance = loc.dist(other.loc);
      //    float distance = abs(mb.loc.x - other.loc.x) + abs(mb.loc.y - other.loc.y);
      //    if (distance >0 && distance < mb.d) {
      //      mb.a = map(mb.countC,0,10,100,255);
      //      stroke(255, mb.a);
      //      line(mb.loc.x, mb.loc.y, other.loc.x, other.loc.y);
      //      mb.connection[i] = true;
      //    }
      //    else {
      //      mb.connection[i] = false;
      //    }
      //  }
       //
      //  mb.run();

       float distance = abs(mb.loc.x - mouseX) + abs(mb.loc.y - mouseY);
       if (distance < mindist) {
         mindist = distance;
         displayMessage = mb.message;
       }
     }
   }

   if (mousePressed && mindist < 20) {
    //  println(displayMessage);
     textSize(32);
     text(displayMessage, mouseX, mouseY);
   }

  if (millis() - time >= timeDelay) {
    time = millis();
    bFlashBg = !bFlashBg;
  }

  theta += .0523;

  if (save) {
    if (frameCount%1==0 && frameCount < fc + 30) saveFrame("image-####.gif");
  }

}

void keyPressed() {
  //if (key != CODED) l = str(key);
}

void mouseReleased() {
  //createStuff();
  //fc = frameCount;
  //save = true;
  //saveFrame("image-###.gif");
}

void createStuff(String l) {
  //ballCollection.clear();
  letter.beginDraw();
  letter.noStroke();
  letter.background(255);
  letter.fill(0);
  letter.textFont(font, 400);
  letter.textAlign(LEFT);
  letter.text(l, i, 350);//design
  letter.endDraw();
  letter.loadPixels();
  i+=textWidth(l)*34;

  letterCollection.add(new Letter());

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
        int dir = 1;
        float r = random(1);
        if (r>.5) dir =-1;
        Ball myBall = new Ball(org, loc, radius, dir, offSet);
        myBallCollection.add(myBall);
      }
    }
  }

  void run (){
    for (int i=0; i<myBallCollection.size (); i++) {
      Ball mb = (Ball) myBallCollection.get(i);
      mb.run();

      for (int j=0; j<myBallCollection.size(); j++) {
        Ball other = (Ball) myBallCollection.get(j);
        //float distance = loc.dist(other.loc);
        float distance = abs(mb.loc.x - other.loc.x) + abs(mb.loc.y - other.loc.y);
        if (distance >0 && distance < mb.d) {
          mb.a = map(mb.countC,0,10,100,255);
          stroke(255, mb.a);
          line(mb.loc.x, mb.loc.y, other.loc.x, other.loc.y);
          mb.connection[i] = true;
        }
        else {
          mb.connection[i] = false;
        }
      }
    }
  }
}


class Ball {

  PVector org, loc;
  float sz = 2; //ball sz=2
  float radius, offSet, a;
  int s, dir, countC, d = 20; //line =20
  boolean[] connection = new boolean[num];
  String message;

  Ball(PVector _org, PVector _loc, float _radius, int _dir, float _offSet) {
    org = _org;
    loc = _loc;
    radius = _radius;
    dir = _dir;
    offSet = _offSet;
    message = 'ball' + str(balln);
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
    fill(255, 200);
    ellipse(loc.x, loc.y, sz, sz);
  }
}

void sweetheart(String data) {
  println(data);
}
