import codeanticode.syphon.*;
import java.util.List;
import org.openkinect.processing.*;

//Kinect Library object
Kinect2 kinect2;
SyphonServer server;
ParticleAnim panim;
TypeFace truthText;

float minThresh = 1900;
float maxThresh = 1940;
PImage img;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();

  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  
  panim = new ParticleAnim();
  truthText = new TypeFace("TRUTH is...", width/2, 40);

  server = new SyphonServer(this, "truth_fabric");
}


void draw() {
  panim.display();
  truthText.display();

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

      if (d > minThresh && d < maxThresh && y < 304) {
        img.pixels[offset] = color(255, 0, 150);
        sumX += x;
        sumY += y;
        totalPixels++;
      } else {
        img.pixels[offset] = color(51);
      }
    }
  }

  img.updatePixels();
  //image(img, 0, 0);

  float avgX = sumX / totalPixels;
  float avgY = sumY / totalPixels;
  float mappedX = 0; 
  float mappedY = 0;

  fill(150, 0, 255);

  if (totalPixels >= 400) {
    mappedX = map(avgX, 0, 512, width/2 - 512, width/2 + 512);
    mappedY = map(avgY, 0, 304, height/2 - 384, height/2 + 384);

    if (avgY > 204) avgY += 10;
    ellipse(avgX, avgY, 15, 15);
    ellipse(mappedX, mappedY, 15, 15);

    panim.nextWord(mappedX, mappedY);
  }

  server.sendScreen();
}

void mouseClicked() {
  panim.nextWord(mouseX, mouseY);
} 
