class Word {
  PGraphics pg;
  float life;
  ArrayList<PVector> outline;
  PVector offset;
  String str;
  float glitchmax;

  Word(String _str, PVector _offset) {
    str = _str;
    offset = _offset;
    outline = new ArrayList<PVector>();
    //pg = createGraphics(int(textSize*0.1+horizontalMargin)*(str.length()), textSize*2);
    pg = createGraphics(1280, 720);
    glitchmax = random(1, 15);
  }

  void init() {
    for (int i = 0; i < str.length(); i++) { 
      char character = str.charAt(i); 
      int index = alphabets.indexOf(character); 
      PVector letterOffset = new PVector(i * horizontalMargin, 0); 
      ArrayList<PVector> alphabetOutline = alphabetOutlines.get(index); 
      for (PVector point : alphabetOutline) {
        PVector newpoint = new PVector(point.x, point.y);
        newpoint.add(letterOffset);
        outline.add(newpoint);
      }
    }
  }

  void show() {
    pg.beginDraw();
    pg.background(255, 0, 0);
    pg.stroke(255);
    pg.strokeWeight(0.5);
    //coil();
    glitch();
    twist();
    pg.endDraw();
    image(pg, offset.x, offset.y);
    println(outline.size());
  }

  void coil() {
    float xOffset = 0;
    pg.pushMatrix();
    pg.translate(textSize*0.4, -textSize*2.4);
    for (int i = 0; i < outline.size(); i++) {
      pg.pushMatrix();
      float x = outline.get(i).x;
      float y = outline.get(i).y;
      xOffset = map(sin( x*0.15 + (millis()) * 0.005), -1.0, 1.0, -5, 5);
      pg.rect(x+xOffset, y, 1, 1);
      prev = new PVector(x+xOffset, y, 0);
      pg.popMatrix();
    }
    pg.popMatrix();
  }

  void glitch() {
    pg.pushMatrix();
    pg.translate(textSize*0.3, -textSize*2.4);
    int intXOffset = 0;
    int intYOffset = 0;
    for (int i = 0; i < outline.size(); i++) {
      pg.pushMatrix();
      float x = outline.get(i).x;
      float y = outline.get(i).y;
      float maxoff = map(noise(millis()*0.01), 0., 1., 0, glitchmax);  
      float offrand = random(1);
      if (offrand < 0.1) intXOffset += random(-maxoff, maxoff);
      if (offrand > 0.9) intYOffset += random(-maxoff, maxoff);
      pg.point(x+intXOffset, y+intYOffset);
      pg.popMatrix();
    }
    pg.popMatrix();
  }
  
  void twist() {
    pg.pushMatrix();
    //pg.translate(textSize*0.3, -textSize*2.4);
    PVector midpt = getMidpoint();
    pg.rect(midpt.x, midpt.y, 2, 2);
    float left = getLeftest();
    pg.line(left, 0, left, height);
    for(int i = 0; i < outline.size(); i++) {
      pg.pushMatrix();
      float x = outline.get(i).x;
      float y = outline.get(i).y;
      float rad = (x - midpt.x + left);
      float deg = ((millis()) * 0.001) * 4;
      float twist = sin((millis()) * 0.001) * 0.01 + 0.005; 
      float zOffset = rad * sin(deg + y*twist) ;
      float xOffset = rad * cos(deg + y*twist) - x + midpt.x - left;
      //if (i != 0) {
      //  if (dist(x+xOffset, y, 0, prev.x, prev.y, prev.z) < 10) {
      //    pg.line(x+xOffset, y, zOffset, prev.x, prev.y, prev.z);
      //  } else {
      //    pg.point(x+xOffset, y, zOffset);
      //  }
      //} else {
      //  pg.point(x+xOffset, y, zOffset);
      //}
      pg.point(x+xOffset, y, zOffset);
      prev = new PVector(x+xOffset, y, zOffset);
      pg.popMatrix();
    }
    pg.popMatrix();
  }
  
  float getLeftest() {
    float left = width;
    for(PVector p : outline) {
      if(p.x < left) left = p.x;
    }
    //left += offset.x;
    return left;
  }
  
  float getRightest() {
    float right = -1;
    for(PVector p : outline) {
      if(p.x > right) right = p.x;
    }
    //right += offset.x;
    return right;
  }
  
  PVector getMidpoint() {
    PVector mid = new PVector(0, 0);
    for(PVector p : outline) {
      mid.x += p.x;
      mid.y += p.y;
    }
    mid.x /= outline.size();
    mid.y /= outline.size();
    //mid.x += offset.x;
    //mid.y += offset.y;
    return mid;
  }
}
