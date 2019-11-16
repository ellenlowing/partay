// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A rectangular box
class Box {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  int textSize;
  String str;
  PGraphics pg;
  float left, top, right, bottom;

  // Constructor
  Box(float x_, float y_, String _str) {
    str = _str;
    textSize = 40;
    pg = createGraphics(textSize, textSize);
    pg.beginDraw();
    pg.background(0);
    pg.textFont(cfont, textSize);
    pg.text(str, 0, 25);
    pg.fill(255);
    pg.endDraw();
    left = getLeftest(pg);
    top = getTop(pg);
    right = getRightest(pg);
    bottom = getBottom(pg);
    w = right-left;
    h = bottom-top;
    makeBody(new Vec2(x_, y_), w, h);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    //image(pg, 0, 0);
    //fill(255, 0, 0);
    //rect(0, 25, right-left, bottom-top);
    
    fill(0);
    textSize(textSize);
    text(str, 0, 25);
    fill(255);
    textSize(textSize-1);
    text(str, -1, 24);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
  
  float getLeftest(PGraphics pg) {
    float left = width;
    pg.loadPixels();
    for(int i = 0; i < pg.pixels.length; i++) {
      if(red(pg.pixels[i]) == 255) {
        int x = i % pg.width;
        if(x < left) left = x;
      }
    }
    pg.updatePixels();
    return left;
  }
  
  float getRightest(PGraphics pg) {
    float right = -1;
    pg.loadPixels();
    for(int i = 0; i < pg.pixels.length; i++) {
      if(red(pg.pixels[i]) == 255) {
        int x = i % pg.width;
        if(x > right) right = x;
      }
    }
    pg.updatePixels();
    return right;
  }
  
  float getTop(PGraphics pg) {
    float top = height;
    pg.loadPixels();
    for(int i = 0; i < pg.pixels.length; i++) {
      if(red(pg.pixels[i]) == 255) {
        int y = i / pg.width;
        if(y < top) top = y;
      }
    }
    pg.updatePixels();
    return top;
  }
  
  float getBottom(PGraphics pg) {
    float bottom = -1;
    pg.loadPixels();
    for(int i = 0; i < pg.pixels.length; i++) {
      if(red(pg.pixels[i]) == 255) {
        int y = i / pg.width;
        if(y > bottom) bottom = y;
      }
    }
    pg.updatePixels();
    return bottom;
  }
}
