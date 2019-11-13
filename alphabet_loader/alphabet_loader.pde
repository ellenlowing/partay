ArrayList<ArrayList<PVector> > outlines;
ArrayList<PVector> strOutline;
String alphabets = "abcde";
PVector prev;

String text = "abcda";
float horizontalMargin = 0;

void setup() {
  //size(1080, 800, P3D);
  fullScreen(P3D, 2);
  pixelDensity(2);
  frameRate(50);
  background(0);
  fill(0);
  stroke(255);
  rectMode(CENTER);
  prev = new PVector(0, 0, 0);
  horizontalMargin = width * 0.06;
  
  // Parsing alphabet text files into outlines
  outlines = new ArrayList<ArrayList<PVector> >();
  for(int i = 0; i < alphabets.length(); i++) {
    ArrayList<PVector> outline = parseFile(alphabets.charAt(i)+".txt");
    outlines.add(outline); 
  }
  
  // Write all letters into one string, if string does not change
  strOutline = new ArrayList<PVector>();
  for(int i = 0; i < text.length(); i++) { 
    char character = text.charAt(i); 
    int index = alphabets.indexOf(character); 
    PVector letterOffset = new PVector(i * horizontalMargin, 0); 
    ArrayList<PVector> outline = outlines.get(index); 
    for(PVector point : outline) {
      PVector newpoint = new PVector(point.x, point.y);
      newpoint.add(letterOffset);
      strOutline.add(newpoint);
    }
  }
}

void draw() {
  background(0);
  stroke(255);
  
  // #string
  //drawOutline(strOutline, new PVector(0, 0));
  //drawCoil(strOutline, new PVector(0, 0));
  //drawTwist(strOutline, new PVector(width/2, 0));
  
  // #letter by letter
  /*
  for(int i = 0; i < text.length(); i++) {
    char character = text.charAt(i);
    int index = alphabets.indexOf(character);
    ArrayList<PVector> outline = outlines.get(index);
    PVector offset = new PVector(i * horizontalMargin, 0);
    // #debug
    //drawOutline(outline, offset);
    //fill(255, 0, 0);
    //float left = getLeftest(outline, offset);
    //line(left, 0, left, height);
    
    // #release
    
    // ##glitch
    //float glitchmax = map(noise(millis()*0.001), 0, 1, 1, 15);
    //drawGlitch(outline, offset, glitchmax);
    // ##coil
    //drawCoil(outline, offset);
    // ##twist
    //drawTwist(outline, offset);
  }
  */
  
  println(frameRate);
}

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
      if (dist(x+xOffset, y, 0, prev.x, prev.y, prev.z) < 30) {
        line(x+xOffset, y, zOffset, prev.x, prev.y, prev.z);
      } else {
        point(x+xOffset, y, zOffset);
      }
    } else {
      point(x+xOffset, y, zOffset);
    }
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


ArrayList<PVector> parseFile(String filename) {
  BufferedReader reader = createReader(filename);
  String line = null;
  int it = 0;
  ArrayList<PVector> outline = new ArrayList<PVector>();
  try {
    while ((line = reader.readLine()) != null) {
      String [] pieces = split(line, ",");
      int x = int(pieces[0]);
      int y = int(pieces[1]);
      outline.add(new PVector(x, y));
      it++;
      println(it);
    }
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  return outline;
}
