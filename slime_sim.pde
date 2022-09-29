// play with constants for different results
// could add craig reynolds steering behaviour to reduce jitter



Particle[] particles = new Particle[50000];
PImage trail; 
float dimSpeed = 10;
float blurSpeed = 0.7;

void setup(){
  //size(1280,720, P2D);
  fullScreen(P2D);
  
  for (int i = 0; i < particles.length; i++){
    particles[i] = new Particle();
  }
  
  trail = createImage(width,height, RGB);
}

void draw(){   
  background(0);
  for (Particle p : particles){
      p.update(trail);
  }
  updateTrails(trail, particles);
  image(trail,0,0);
  
  for (Particle p : particles){
      //p.show();
  }
  
  dim(trail);
  blur(trail);
}

void updateTrails(PImage img, Particle[] particles){
  
  img.loadPixels();
  for (Particle p : particles)
  {
    PVector startPos = p.ppos;
    PVector endPos = p.pos;
    
    drawLine(img, startPos.x, startPos.y, endPos.x, endPos.y);     
  }
  img.updatePixels(); 
}

void drawLine(PImage img, float _x0, float _y0, float _x1, float _y1) {
  // draws a line using Bresenham's line algorithm
  stroke(255);

  int x0 = floor(_x0);
  int y0 = floor(_y0);

  int x1 = floor(_x1);
  int y1 = floor(_y1);

  int rise = y1 - y0;
  int run = x1 - x0;

  float m = float(rise) / run;
  int adjust = 1;
  if (m < 0) {
    adjust = -1;
  }
  int offset = 0;

  if (m <= 1 && m >= -1) {
    // run greater than rise
    int delta = abs(rise) * 2;
    int threshold = abs(run);
    int thresholdInc = abs(run) * 2;
    int y = y0;
    if (x1 < x0) {
      int temp = x0;
      x0 = x1;
      x1 = temp;

      y = y1;
    }

    for (int x = x0; x <= x1; x++) {
      setPixel(img, x, y, color(255));
      offset += delta;
      if (offset >= threshold) {
        y += adjust;
        threshold += thresholdInc;
      }
    }
  } else {
    // rise greater than run
    int delta = abs(run) * 2;
    int threshold = abs(rise);
    int thresholdInc = abs(rise) * 2;
    int x = x0;
    if (y1 < y0) {
      int temp = y0;
      y0 = y1;
      y1 = temp;

      x = x1;
    }

    for (int y = y0; y <= y1; y++) {
      setPixel(img, x, y, color(255));
      offset += delta;
      if (offset >= threshold) {
        x += adjust;
        threshold += thresholdInc;
      }
    }
  }
}

void setPixel(PImage img, int x, int y, color c){
  int index = x + y * img.width;
  img.pixels[index] = c;
}

void dim(PImage img){
  img.loadPixels();
  for(int i = 0; i < img.pixels.length; i++){
    color c = color(red(img.pixels[i]) - dimSpeed);
    img.pixels[i] = c;
  }
  img.updatePixels();
}

void blur(PImage img){
  img.loadPixels();
  float[] sums = new float[img.pixels.length];
  for(int y = 1; y < img.height - 1; y++){
    for(int x = 1; x < img.width - 1; x++){
      
      float sum = 0;
      for(int ky = -1; ky <= 1; ky++){
        for(int kx = -1; kx <= 1; kx++){
           int index = (x + kx) + (y + ky) * img.width;
           float v = red(img.pixels[index]);
           sum += v / 9;     
        }
      }
      int index = x + y * img.width;
      sums[index] = sum;
     }
  }
  for(int i = 0; i < img.pixels.length; i++){
    color c = color(lerp(red(img.pixels[i]),sums[i], blurSpeed));
    img.pixels[i] = c;
  }
  img.updatePixels();
}

PVector pointInCircle(float x, float y, float radius){
  float dist = random(radius);
  PVector p = PVector.random2D().mult(dist);
  p.add(x,y);
  return p;
}
