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

void drawGlitch(ArrayList<PVector> outline, PVector offset, int life, float glitchmax) {
  pushMatrix();
  translate(offset.x, offset.y, 0);
  int intXOffset = 0;
  int intYOffset = 0;
  color c = colors[int(map(noise((life+millis())*0.1), 0, 1, 0, colors.length))];
  stroke(c);
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    float maxoff = map(noise(x*0.0005, y*0.0005, (millis()-life)*0.01), 0., 1., 0, glitchmax);  
    float offrand = random(1);
    if(offrand < 0.1) intXOffset += random(-maxoff, maxoff);
    if(offrand > 0.9) intYOffset += random(-maxoff, maxoff);
    point(x+intXOffset, y+intYOffset);
    popMatrix();
  }
  popMatrix();
}

void drawTwistDrag(ArrayList<PVector> outline, PVector offset, int life) {
  pushMatrix();
  translate(offset.x, offset.y, 0);
  PVector midpt = getMidpoint(outline, offset);
  float left = getLeftest(outline, offset);
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    float rad = (x - midpt.x + left);
    float deg = -((millis()-life) * 0.0001) * 4;
    float twist = noise(x*0.01, y*0.01, millis()*0.001)*0.01; 
    float zOffset = rad * sin(deg + y*twist) ;
    float xOffset = rad * cos(deg + y*twist) - rad;
    point(x+xOffset, y, zOffset);
    prev = new PVector(x+xOffset, y, zOffset);
    popMatrix();
    
    //println(deg);
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

void drawCoil(ArrayList<PVector> outline, PVector offset, int life) {
  float xOffset = 0;
  color c0 = colors[0];
  color c1 = colors[0];
  if(life % 6 == 0) {
    c0 = colors[0];
    c1 = colors[1];
  } else if (life % 6 == 1) {
    c0 = colors[1];
    c1 = colors[2];
  } else if (life % 6 == 2) {
    c0 = colors[2];
    c1 = colors[3];
  } else if (life % 6 == 3) {
    c0 = colors[1];
    c1 = colors[3];
  } else if (life % 6 == 4) {
    c0 = colors[0];
    c1 = colors[3];
  } else if (life % 6 == 5) {
    c0 = colors[0];
    c1 = colors[2];
  }
  pushMatrix();
  translate(offset.x, offset.y, 0);
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    float pct = sin( x*0.15 + (millis()) * 0.005) * 0.5 + 0.5;
    float r = red(c0) * pct + red(c1) * (1.0-pct);
    float g = green(c0) * pct + green(c1) * (1.0-pct);
    float b = blue(c0) * pct + blue(c1) * (1.0-pct);
    stroke(r, g, b);
    xOffset = map(sin( x*0.15 + (millis()) * 0.005), -1.0, 1.0, -5, 5);
    if (i != 0) {
      if (dist(x+xOffset, y, 0, prev.x, prev.y, prev.z) < 10) {
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

void drawCoilWave(ArrayList<PVector> outline, PVector offset, int life) {
  float xOffset = 0;
  float yOffset = height - 200 - ((millis() - life)%20000)*0.1;
  pushMatrix();
  translate(offset.x, offset.y, 0);
  for(int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    float noiseWave = map(noise(x*0.0001, y*0.0001, incflying), 0, 1, 0.1, 12);
    xOffset = map(sin( x*0.15 + (millis()) * 0.005), -1.0, 1.0, -7, 7);
    xOffset += sin( (y/50.0) - millis() * 0.001)/0.25*noiseWave;
    
    if (i != 0) {
      if (dist(x+xOffset, y+yOffset, 0, prev.x, prev.y, prev.z) < 10) {
        line(x+xOffset, y+yOffset, 0, prev.x, prev.y, prev.z);
      } else {
        point(x+xOffset, y+yOffset, 0);
      }
    } else {
      point(x+xOffset, y+yOffset, 0);
    }
    prev = new PVector(x+xOffset, y+yOffset, 0);
    popMatrix();
  }
  popMatrix();
}

void drawLines(ArrayList<PVector> outline, PVector offset) {
  float noiseXY = 0.0025;
  float noiseI = 0.001;
  pushMatrix();
  translate(offset.x, offset.y, 0);
  int inc = 5;
  int maxxoffset = 10;
  int maxyoffset = 15;
  int zspeed = 100;
  int zoff = -1500;
  for(int j = 0; j < outline.size(); j+=5) {
    float x = outline.get(j).x;
    float y = outline.get(j).y;
    for(int i = 0; i < 200; i += inc) {
      pushMatrix();
      stroke(i);
      line(x+ map(noise(x,i*noiseXY +incflying), 0, 1, -maxxoffset, maxxoffset), y + map(noise(y,i*noiseXY +incflying), 0, 1, -maxyoffset, maxyoffset), incflying*zspeed+i+zoff, x+ map(noise(x,(i+inc)*noiseXY +incflying), 0, 1, -maxxoffset, maxxoffset), y + map(noise(y, (i+inc)*noiseXY+incflying), 0, 1, -maxyoffset, maxyoffset), incflying*zspeed+i+inc+zoff);
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
