void drawOutline(ArrayList<PVector> outline, PVector offset) {
  pushMatrix();
  translate(offset.x, offset.y, 0);
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    point(x, y);
    popMatrix();
  }
  popMatrix();
}

void drawGlitch(ArrayList<PVector> outline, PVector offset, float glitchmax) {
  pushMatrix();
  translate(offset.x, offset.y, 0);
  int intXOffset = 0;
  int intYOffset = 0;
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    float maxoff = map(noise(millis()*0.01), 0., 1., 0, glitchmax);  
    float offrand = random(1);
    if(offrand < 0.1) intXOffset += random(-maxoff, maxoff);
    if(offrand > 0.9) intYOffset += random(-maxoff, maxoff);
    point(x+intXOffset, y+intYOffset);
    popMatrix();
  }
  popMatrix();
}

void drawTwistDrag(ArrayList<PVector> outline, PVector offset) {
  pushMatrix();
  translate(offset.x, offset.y, 0);
  PVector midpt = getMidpoint(outline, offset);
  float left = getLeftest(outline, offset);
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    float rad = (x - midpt.x + left);
    float deg = -((millis()) * 0.0001) * 4;
    float twist = noise(x*0.01, y*0.01, millis()*0.001)*0.01; 
    float zOffset = rad * sin(deg + y*twist) ;
    float xOffset = rad * cos(deg + y*twist) - rad;
    point(x+xOffset, y, zOffset);
    prev = new PVector(x+xOffset, y, zOffset);
    popMatrix();
  }
  popMatrix();
}

void drawTwist(ArrayList<PVector> outline, PVector offset) {
  pushMatrix();
  translate(offset.x, offset.y, 0);
  PVector midpt = getMidpoint(outline, offset);
  float left = getLeftest(outline, offset);
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    float rad = (x - midpt.x + left);
    float deg = ((millis()) * 0.001) * 4;//0.002 /// 0.4
    float twist = sin((millis()) * 0.001) * 0.01 + 0.005; // deg - rad
    float zOffset = rad * sin(deg + y*twist) ;
    float xOffset = rad * cos(deg + y*twist) - x + midpt.x - left;
    if (i != 0) {
      if (dist(x+xOffset, y, 0, prev.x, prev.y, prev.z) < 10) {
        line(x+xOffset, y, zOffset, prev.x, prev.y, prev.z);
      } else {
        point(x+xOffset, y, zOffset);
      }
    } else {
      point(x+xOffset, y, zOffset);
    }
    prev = new PVector(x+xOffset, y, zOffset);
    popMatrix();
  }
  popMatrix();
}

void drawCoil(ArrayList<PVector> outline, PVector offset) {
  float xOffset = 0;
  pushMatrix();
  translate(offset.x, offset.y, 0);
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    xOffset = map(sin( x*0.15 + (millis()) * 0.005), -1.0, 1.0, -5, 5);
    if (i != 0) {
      if (dist(x+xOffset, y, 0, prev.x, prev.y, prev.z) < 30) {
        line(x+xOffset, y, 0, prev.x, prev.y, prev.z);
      } else {
        point(x+xOffset, y, 0);
      }
    } else {
      point(x+xOffset, y, 0);
    }
    prev = new PVector(x+xOffset, y, 0);
    popMatrix();
  }
  popMatrix();
}

void drawCoilRamp(ArrayList<PVector> outline, PVector offset) {
  float xOffset = 0;
  float yOffset = 0;
  pushMatrix();
  translate(offset.x, offset.y, 0);
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    xOffset = map(sin( x*0.15 + (millis()) * 0.005), -1.0, 1.0, -5, 5);
    yOffset = (map(sin( (y/20)*0.05 + (millis()) * 0.005), -1.0, 1.0, 1, 1.5));
    point(x+xOffset, y*yOffset, 0);
    prev = new PVector(x+xOffset, y*yOffset, 0);
    popMatrix();
  }
  popMatrix();
}

void drawLines(ArrayList<PVector> outline, PVector offset) {
  float noiseXY = 0.005;
  pushMatrix();
  translate(offset.x, offset.y, 0);
  int inc = 5;
  for(int j = 0; j < outline.size(); j+=5) {
    float x = outline.get(j).x;
    float y = outline.get(j).y;
    for(int i = 0; i < 200; i += inc) {
      pushMatrix();
      stroke(i);
      line(x+ map(noise(x,i*noiseXY +flying), 0, 1, -10, 10), y + map(noise(y,i*noiseXY +flying), 0, 1, -15, 15), i, x+ map(noise(x,(i+inc)*noiseXY +flying), 0, 1, -10, 10), y + map(noise(y, (i+inc)*noiseXY+flying), 0, 1, -15, 15), i+inc);
      popMatrix();
    }
  }
  popMatrix();
}

float getLeftest(ArrayList<PVector> outline, PVector offset) {
  float left = width;
  for(PVector p : outline) {
    if(p.x < left) left = p.x;
  }
  left += offset.x;
  return left;
}

float getRightest(ArrayList<PVector> outline, PVector offset) {
  float right = -1;
  for(PVector p : outline) {
    if(p.x > right) right = p.x;
  }
  right += offset.x;
  return right;
}

PVector getMidpoint(ArrayList<PVector> outline, PVector offset) {
  PVector mid = new PVector(0, 0);
  for(PVector p : outline) {
    mid.x += p.x;
    mid.y += p.y;
  }
  mid.x /= outline.size();
  mid.y /= outline.size();
  mid.x += offset.x;
  mid.y += offset.y;
  return mid;
}
