import codeanticode.syphon.*; //<>//
import java.util.List;
import org.openkinect.processing.*;

//Kinect Library object
Kinect2 kinect2;
List<TextAnim> anims;
SyphonServer server;

float minThresh = 900;
float maxThresh = 1000;
PImage img;
String[] lines;

void settings() {
  size(1440, 900, P3D);
}

void setup() {
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();

  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  lines = loadStrings("list.txt");
  anims = new ArrayList<TextAnim>();

  server = new SyphonServer(this, "truth_fabric");

  smooth();
  textMode(SHAPE);
}


void draw() {
  background(0);

  img.loadPixels();

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();

  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;

  for (int x = 0; x < kinect2.depthWidth; x++) {
    for (int y = 0; y < kinect2.depthHeight; y++) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh) {
        img.pixels[offset] = color(255, 0, 150);

        sumX += x;
        sumY += y;
        totalPixels++;
      } else {
        img.pixels[offset] = color(0);
      }
    }
  }

  img.updatePixels();
  image(img, 0, 0);

  float avgX = sumX / totalPixels;
  float avgY = sumY / totalPixels;
  fill(150, 0, 255);
  if (totalPixels >= 200) {
    ellipse(avgX, avgY, 15, 15);
    //updateWords((int) mouseX, mouseY);
    updateWords((int) avgX, (int) avgY);
  }
  
  pushMatrix();
  fill(255, 229, 31);
  textAlign(CENTER);
  textSize(20); 
  text("Truth is...", width/2, 40);
  popMatrix();

  for (int i = 0; i < anims.size(); i++) {
    if (anims.get(i).endTime > millis()) {
      anims.get(i).display();
    } else {
      anims.remove(i);
    }
  }

  server.sendScreen();
}

void updateWords(int x, int y) {
  for (int i = 0; i < anims.size(); i++) {
    if (anims.get(i).inVicinity(x, y) == true) return;
  }
  anims.add(new TextAnim(lines[(int) random(lines.length)], millis(), 5000, x, y));
}
