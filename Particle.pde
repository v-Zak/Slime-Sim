class Particle {
  int diameter = 2;
  PVector vel, pos, ppos;
  float speed = 20;
  int senseRadius = 4;
  float senseOffsetAngle = radians(45);
  float senseRandomSteer = senseOffsetAngle / 10;
  float velLerp = 0.7;
  float lerpChange = 0;

  Particle() {
    pos = pointInCircle(width/2, height/2, 500);
    ppos = pos;
    vel = new PVector(width/2 - pos.x, height/2 - pos.y);
    vel.setMag(speed);
  }
  void update(PImage img) {
    velLerp += lerpChange;
    ppos = pos.copy();

    steer(img);
    pos.add(vel);

    edges();
  }

  void show() {
    //noStroke();
    //fill(255, 0, 0);
    //ellipse(pos.x, pos.y, diameter, diameter);
  }


  void edges() {
    if (pos.x < 0) {
      pos.x = 0;
      vel.x = vel.x * -1;
    } else if (pos.x >= width) {
      pos.x = width-1;
      vel.x = vel.x * -1;
    }
    if (pos.y < 0) {
      pos.y = 0;
      vel.y = vel.y * -1;
    } else if (pos.y >= height) {
      pos.y = height-1;
      vel.y = vel.y * -1;
    }
  }

  void edges(PVector pos) {
    if (pos.x < 0) {
      pos.x = 0;
    } else if (pos.x >= width) {
      pos.x = width-1;
    }
    if (pos.y < 0) {
      pos.y = 0;
    } else if (pos.y >= height) {
      pos.y = height-1;
    }
  }

  void steer(PImage img){
    PVector dVel = vel.copy();
    PVector velLeft = vel.copy().rotate(-senseOffsetAngle);
    PVector velRight = vel.copy().rotate(senseOffsetAngle);  
    float sForward = sense(img, vel.x + pos.x, vel.y + pos.y, senseRadius);
    
    float sLeft = sense(img, velLeft.x + pos.x, velLeft.y + pos.y, senseRadius);
    float sRight = sense(img, velRight.x + pos.x, velRight.y + pos.y, senseRadius);
    
    if (sLeft > sRight){
      if (sLeft > sForward){
          dVel = velLeft.copy();
          stroke(255,0,0);
      }
    } else{
      if (sRight > sForward){
            dVel = velRight.copy();
            stroke(0,255,0);
        }
  }
  dVel.rotate(random(-senseRandomSteer, senseRandomSteer));
  vel.lerp(dVel, velLerp);
  vel.setMag(speed);

}

  float sense(PImage img, float _x, float _y, int radius){
    img.loadPixels();
    float s = 0;
    int index = -1;
    int x = floor(_x);
    int y = floor(_y);
    for (int j = -radius; j <= radius; j++){
      for (int i = -radius; i <= radius; i++){  
        index = x + i + (y + j) * img.width;
        // won't return if 0 < x < width would just get value from the next row
        if(index < 0 || index > img.pixels.length - 1){
           return -1;
        }      
        s += red(img.pixels[index]);
      }
    }
    return s;
  }
}
