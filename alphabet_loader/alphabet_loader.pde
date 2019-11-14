import oscP5.*;
import netP5.*;

OscP5 oscP5;

ArrayList<ArrayList<PVector> > alphabetOutlines;
ArrayList<PVector> strOutline;
String alphabets = "abcde";
PVector prev;

String text = "abcde";
float horizontalMargin = 0;

void setup() {
  size(800, 600, P3D);
  //size(1280, 720, P3D);
  //fullScreen(P3D, 2);
  pixelDensity(2);
  frameRate(50);
  background(0);
  fill(0);
  stroke(255);
  rectMode(CENTER);
  prev = new PVector(0, 0, 0);
  horizontalMargin = width * 0.06;
  oscP5 = new OscP5(this, 12000);
  
  // Parsing alphabet text files into outlines
  alphabetOutlines = new ArrayList<ArrayList<PVector> >();
  for(int i = 0; i < alphabets.length(); i++) {
    ArrayList<PVector> outline = parseFile(alphabets.charAt(i)+".txt");
    alphabetOutlines.add(outline); 
  }
  
  // Write all letters into one string, if string does not change
  strOutline = new ArrayList<PVector>();
  for(int i = 0; i < text.length(); i++) { 
    char character = text.charAt(i); 
    int index = alphabets.indexOf(character); 
    PVector letterOffset = new PVector(i * horizontalMargin,0); 
    ArrayList<PVector> outline = alphabetOutlines.get(index); 
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
  float life = 20000;
  float yoff = 0;
  //float yoff = map(millis(), 0, life, height/2*2.5, -height/2*2.5);
  
  // #string
  //drawOutline(strOutline, new PVector(0, 0));
  //drawCoil(strOutline, new PVector(width/4, -100));
  //drawTwist(strOutline, new PVector(width/2, 0));
  drawTwistDrag(strOutline, new PVector(width/2, yoff));
  //float glitchmax = map(noise(millis()*0.001), 0, 1, 1, 15);
  //drawGlitch(strOutline, new PVector(20, height/4), glitchmax);
  
  // #letter by letter
  
  //for(int i = 0; i < text.length(); i++) {
  //  char character = text.charAt(i);
  //  int index = alphabets.indexOf(character);
  //  ArrayList<PVector> outline = alphabetOutlines.get(index);
  //  PVector offset = new PVector(i * horizontalMargin, 0);
    // ##glitch
    //float glitchmax = map(noise(millis()*0.001), 0, 1, 1, 15);
    //drawGlitch(outline, offset, glitchmax);
    // ##coil
    //drawCoil(outline, offset);
    // ##twist
    //drawTwist(outline, offset);
  //}
  
  println(frameRate);
}

void oscEvent(OscMessage theOscMessage) {
  String val = theOscMessage.get(0).stringValue();
  println("OSC message: ", val);
  text = val;
  strOutline = new ArrayList<PVector>();
  for(int i = 0; i < text.length(); i++) { 
    char character = text.charAt(i); 
    int index = alphabets.indexOf(character); 
    PVector letterOffset = new PVector(i * horizontalMargin, 0); 
    ArrayList<PVector> outline = alphabetOutlines.get(index); 
    for(PVector point : outline) {
      PVector newpoint = new PVector(point.x, point.y);
      newpoint.add(letterOffset);
      strOutline.add(newpoint);
    }
  }
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
