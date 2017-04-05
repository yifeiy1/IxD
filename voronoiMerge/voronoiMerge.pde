/******** For LETTERS *********/
int fc, num = 600;
ArrayList letterCollection;
boolean save = false;
PGraphics letter;
PFont font;
int i = 0;
float scal, theta;

class Cell
{
  PVector loc;
  color c;
  Cell(int _x, int _y, color _c)
  {
    loc = new PVector(_x, _y);
    c = _c;
  }
}

ArrayList<Cell> cells = new ArrayList<Cell>();
boolean use_manhattan = false;

void setup()
{
  size(800, 800);
  //for(int i = 0; i < 5; ++i)
  //  cells.add(new Cell((int)random(0,width), (int)random(0,height), color(random(0,255), random(0,255), random(0,255))));
    
  letter = createGraphics(width, height);
  font = loadFont("Futura-Medium-48.vlw");  
  letterCollection = new ArrayList();
  createStuff("D");
}

void draw()
{
  background(0);
  theta += .0523;
  // Draw the voronoi cells
  //drawVoronoi();
  
  // Draw the points
  //for(int i = 0; i < cells.size(); ++i)
  //  ellipse(cells.get(i).loc.x, cells.get(i).loc.y, 5, 5);
  
  
     for (int i = 0; i<letterCollection.size(); ++i){
     Letter ml = (Letter) letterCollection.get(i);
     ml.run();
     for (int j = 0; j < ml.myBallCollection.size(); ++j) {
       Ball mb = (Ball) ml.myBallCollection.get(j);

       float distance = abs(mb.loc.x - mouseX) + abs(mb.loc.y - mouseY);
     }
   }
   
   drawVoronoi();
}

void drawVoronoi()
{
  loadPixels();
  int offset = 0;
  
  // Iterate over every pixel
  for(int y = 0; y < height; y++)
  {
    for(int x = 0; x < width; x++)
    {
      float shortest = 1E12;
      int index = -1;
      
      // Find the closest cell
      for(int i = 0; i < cells.size(); ++i)
      {
        Cell cc = cells.get(i);
        float d;
        if(use_manhattan)
        {
          // Manhattan Distance
          d = abs(x - cc.loc.x) + abs(y - cc.loc.y);
        }
        else
        {
          // Euclidean distance, dont need to sqrt it since actual distance isnt important
          d = sq(x-cc.loc.x) + sq(y-cc.loc.y);
        }
        
        if(d < shortest)
        {
          shortest = d;
          index = i;
        }
      }
      // Set the pixel to the cells color
      pixels[offset++] = cells.get(index).c;
    }
  }
  updatePixels();
}

void keyPressed()
{
  if(key == 'a')
    cells.add(new Cell(mouseX, mouseY, color(random(0,255), random(0,255), random(0,255))));
  if(key == ' ')
    cells.subList(5, cells.size()).clear();
  if(key == 't')
    use_manhattan = !use_manhattan;
}

void createStuff(String l) {
  //ballCollection.clear();
  letter.beginDraw();
  letter.noStroke();
  letter.background(255);
  letter.fill(0);
  letter.textFont(font, 400);
  letter.textAlign(LEFT);
  letter.text(l, i, random(200,700));//design
  letter.endDraw();
  letter.loadPixels();
  i+=textWidth(l)*40;

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
          //if (distance >40 && distance < mb.d) {
          //  mb.a = map(mb.countC,0,10,100,255);
          //  stroke(255, mb.a);
          //  strokeWeight(3);
          //  line(mb.loc.x, mb.loc.y, other.loc.x, other.loc.y);
          //  mb.connection[i] = true;
          //}          
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
      //pushMatrix();
      //translate(loc.x-1, loc.y-1);
      //rotate(frameCount / -100.0);
      //star(loc.x-1183, loc.y-300, 2, 4.67, 5); 
      //star(loc.x, loc.y, 2, 4.67, 5);   
      ellipse(loc.x, loc.y, 4, 4);
      //star(0, 0, 2, 4.67, 5);        
      //popMatrix();
    }  
    cells.add(new Cell(int(loc.x), int(loc.y), color(random(0,255), random(0,255), random(0,255))));
  }
}