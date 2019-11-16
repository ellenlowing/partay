
PImage src, dst;

PFont cfont;
int fontsz;
int scl;
ArrayList<PVector> outline;

boolean calibration = true;
boolean hd = true;

int bbx, bby, bbw, bbh;
int idx = 0;
int strkIdx [];
PrintWriter output;

void setup() {
  size(400, 400, P2D);
  if (hd) pixelDensity(2);
  smooth(2);
  randomSeed(millis());
  // scan chinese characters
  fontsz = 50;
  scl = fontsz / 16 / 2; // change to fontsz / 16 / 2 for rendering
  cfont = createFont("Lora-Regular", fontsz);
  textFont(cfont);
  background(0);
  fill(255);
  textSize(fontsz);
  String txt = "e";
  text(txt, 1, height-20);
  src = createImage(pixelWidth, pixelHeight, ALPHA);
  src = get(0, 0, pixelWidth, pixelHeight);
  outline = new ArrayList<PVector>();
  output = createWriter(fontsz+"/"+txt+".txt");
  bbx = 0;
  bby = 0;
  bbw = width;
  bbh = height;
  for (int i = 0; i < txt.length(); i++) {
    bbx = i * int(fontsz * 0.53);
    bby = 0;
    bbw = int(fontsz * 0.53);
    bbh = height;
    findContour(bbx, bby, bbw, bbh);
    noFill();
    stroke(0, 0, 255);
    rect(bbx, bby, bbw, bbh);
  }
  strkIdx = new int[26];
  for(int i = 0; i < 26; i++) {
    strkIdx[i] = -1;
  }
}

void draw() {
  background(0);
  noStroke();

  if (calibration) fill(255, 0, 0);
  else fill(255);

  if (calibration) image(src, 0, 0);

  for (int i = 0; i < outline.size(); i++) {
    pushMatrix();
    float x = outline.get(i).x;
    float y = outline.get(i).y;
    rect(x, y, 1, 1);
    popMatrix();
  }
}

void findContour (int bbx, int bby, int bbw, int bbh) {

  src.loadPixels();
  int startLoc = -1;
  int xLoc = -1;
  int yLoc = -1;
  int bbx0, bbx1, bby0, bby1;
  if (hd) {
    bbx0 = bbx*2;
    bby0 = bby*2;
    bbx1 = (bbx+bbw)*2;
    bby1 = (bby+bbh)*2;
  } else {
    bbx0 = bbx;
    bby0 = bby;
    bbx1 = bbx+bbw;
    bby1 = bby+bbh;
  }
  for (int y = bby0; y < bby1; y++) {
    for (int x = bbx0; x < bbx1; x++) {
      int loc = x + y * pixelWidth;
      if (red(src.pixels[loc]) == 255 && startLoc == -1) {
        startLoc = loc;
        xLoc = x;
        yLoc = y;
      } else {
        continue;
      }
    }
  }

  int currLoc = 0;
  int dir = 0;
  if (startLoc >= 0) currLoc = startLoc;
  do {
    if (red(src.pixels[currLoc]) == 255) {
      dir = (dir + 4 - 1) % 4;
      int xx, yy;
      if (hd) {
        xx = xLoc/2;
        yy = yLoc/2;
      } else {
        xx = xLoc/2;
        yy = yLoc/2;
      }
      outline.add(new PVector(xx, yy));
      output.println(xx + "," + yy);
      //println(xLoc, yLoc);
    } else {
      dir = (dir + 1) % 4;
    }

    switch(dir) {
    case 0:
      currLoc = currLoc + 1;
      xLoc++;
      break;
    case 1:
      currLoc = currLoc + pixelWidth;
      yLoc++;
      break;
    case 2:
      currLoc = currLoc - 1;
      xLoc--;
      break;
    case 3:
      currLoc = currLoc - pixelWidth;
      yLoc--;
      break;
    }

    if (currLoc < 0 || currLoc >= pixelWidth * pixelHeight) currLoc = 0;
  } while (currLoc != startLoc);

  src.updatePixels();
}

void keyPressed() {
  if (key == ESC) {
    output.flush();
    output.close();
    exit();
  }
  output.flush();
  output.close();
  char txt = key;
  background(0);
  fill(255);
  text(txt, 1, height-20);
  src = createImage(pixelWidth, pixelHeight, ALPHA);
  src = get(0, 0, pixelWidth, pixelHeight);
  outline = new ArrayList<PVector>();
  output = createWriter(fontsz+"/"+txt+".txt");
}

void mousePressed() {
  bbx = mouseX;
  bby = mouseY;
}

void mouseReleased() {
  bbw = mouseX - bbx;
  bbh = mouseY - bby;
  rect(bbx, bby, bbw, bbh);
  findContour(bbx, bby, bbw, bbh);
  strkIdx[idx] = outline.size();
  idx++;
  println("outline: ", outline.size());
  bbx = -1;
  bby = -1;
  bbw = -1;
  bbh = -1;
}
