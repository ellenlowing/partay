import oscP5.*;
import netP5.*;

OscP5 oscP5;

ArrayList<ArrayList<PVector> > alphabetOutlines50;
ArrayList<ArrayList<PVector> > alphabetOutlines100;
ArrayList<ArrayList<PVector> > strOutlines;
ArrayList<PVector> positions;
int [] fontsizes = {50,100};
color [] colors = {#0025e1, #f70083, #00fbc3, #ffffff};
IntList lifes;
String alphabets = "abcdeghijklmnopqrstuvwxyz";
PVector prev;
float incflying = 0;
float decflying = 200;
String text = "notice me senpaiiiiiiiiiiiiii";
float horizontalMargin = 0;
float verticalMargin = 0;

int state = 0;
int numStates = 4;
IntList stateModes;
boolean allInMode = false;
// 0 : COIL
// 1 : TWISTDRAG
// 2 : GLITCH
// 3 : COILWAVE
// 4 : LINES

void setup() {
  //size(1280, 720, P3D);
  fullScreen(P3D, 1);
  pixelDensity(2);
  frameRate(50);
  background(0);
  fill(0);
  stroke(255);
  rectMode(CENTER);
  smooth(2);
  prev = new PVector(0, 0, 0);
  //horizontalMargin = textSize*0.7;
  //verticalMargin = textSize*0.95;
  oscP5 = new OscP5(this, 12000);
  positions = new ArrayList<PVector>();
  lifes = new IntList();
  stateModes = new IntList();
  
  // Parsing alphabet text files into outlines
  alphabetOutlines50 = new ArrayList<ArrayList<PVector> >();
  for(int i = 0; i < alphabets.length(); i++) {
    ArrayList<PVector> outline = parseFile("50/"+alphabets.charAt(i)+".txt");
    alphabetOutlines50.add(outline); 
  }
  alphabetOutlines100 = new ArrayList<ArrayList<PVector> >();
  for(int i = 0; i < alphabets.length(); i++) {
    ArrayList<PVector> outline = parseFile("100/"+alphabets.charAt(i)+".txt");
    alphabetOutlines100.add(outline); 
  }
  
  strOutlines = new ArrayList<ArrayList<PVector> >();
  
  newString(text);
}

void draw() {
  //background(0);
  //stroke(255);
  //strokeWeight(1);
  switch(state) {
      case 0:
        strokeWeight(0.5);
        background(colors[2]);
        break;
      case 1: 
        break;
      case 2:
        if(random(1) < 0.1) background(colors[int(random(colors.length))]);
        //if(random(1) > 0.9) stroke(colors[int(random(colors.length))]);
        strokeWeight(random(1));
        break;
      case 3:
        break;
      case 4:
        break;
      default:
        background(0);
        stroke(255);
        strokeWeight(1);
    }
  
  for(int i = 0; i < strOutlines.size(); i++) {
    ArrayList<PVector> strOutline = strOutlines.get(i);
    PVector pos = positions.get(i);
    int life = lifes.get(i);
    if(allInMode) state = stateModes.get(i);
    switch(state) {
      case 0:
        drawCoil(strOutline, pos, life);
        break;
      case 1: 
        drawTwistDrag(strOutline, pos, life);
        break;
      case 2:
        float glitchmax = map(noise(millis()*0.001), 0, 1, 1, 16);
        if(random(1) < 0.5) drawGlitch(strOutline, pos, life, glitchmax);
        break;
      case 3:
        drawCoilWave(strOutline, pos, life);
        break;
      case 4:
        drawLines(strOutline, pos);
        break;
      default:
        drawTwist(strOutline, pos);
    }
  }
  
  incflying += 0.01;
  decflying -= 1;
  //println(frameRate);
}

void oscEvent(OscMessage theOscMessage) {
  String val = theOscMessage.get(0).stringValue();
  println("OSC message: ", val);
  text = val;
  if(strOutlines.size() > 4) {
    strOutlines.remove(0);
    positions.remove(0);
    lifes.remove(0);
    stateModes.remove(0);
  }
  newString(text);
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

void newString(String text) {
  ArrayList<ArrayList<PVector> > alphabetOutlines;
  ArrayList<PVector> strOutline = new ArrayList<PVector>();
  text = text.toLowerCase();
  int textSize;
  if(text.length() >= 15) {
    alphabetOutlines = alphabetOutlines50;
    textSize = 50;
  } else {
    alphabetOutlines = alphabetOutlines100;
    textSize = 100;
  }
  horizontalMargin = textSize*0.7;
  verticalMargin = textSize*0.95;
  boolean isVertical = random(1) < 0.5;
  for(int i = 0; i < text.length(); i++) { 
    char character = text.charAt(i); 
    int index = alphabets.indexOf(character); 
    if(index != -1) {
      PVector letterOffset;
      if(isVertical) letterOffset = new PVector(0,i * verticalMargin); 
      else letterOffset = new PVector(i * horizontalMargin,0); 
      ArrayList<PVector> outline = alphabetOutlines.get(index); 
      for(PVector point : outline) {
        PVector newpoint = new PVector(point.x, point.y);
        newpoint.add(letterOffset);
        strOutline.add(newpoint);
      }
    }
  }
  strOutlines.add(strOutline);
  if(isVertical) positions.add(new PVector(random(width-textSize), random(-400, 100)));
  else positions.add(new PVector(random(20,width-76*text.length()), random(-300, 350)));
  lifes.append(millis());
  stateModes.append(int(random(numStates-1)));
}

void keyPressed() {
  if(key == TAB) {
    state = (state + 1) % numStates;
  } else if (key == 'a') {
    allInMode = !allInMode;
    println(allInMode);
  } else if(key == BACKSPACE) {
    for(int i = strOutlines.size()-1; i>=0; i--) {
      strOutlines.remove(i); 
    }
  }
}
