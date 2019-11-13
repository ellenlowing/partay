import oscP5.*;
import netP5.*;

OscP5 oscP5;

void setup() {
  size(400, 400);
  frameRate(60);
  oscP5 = new OscP5(this, 12000);
}

void draw() {
  background(0);
}

void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  print(" typetag: "+theOscMessage.typetag());
  String val = theOscMessage.get(0).stringValue();
  println("message: " + val);
}
