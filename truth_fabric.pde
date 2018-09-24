import java.util.List; //<>//
import org.openkinect.processing.*;

Kinect2 kinect2;
List<TextAnim> anims;

float minThresh = 880;
float maxThresh = 4500;
PImage img;
String[] lines;

void settings() {
  //size(512, 424);
  fullScreen();
}

void setup() {
  lines = loadStrings("list.txt");
  anims = new ArrayList<TextAnim>();
}


void draw() {
  background(0);

  for (int i = 0; i < anims.size(); i++) {
    if (anims.get(i).endTime > millis()) {
      anims.get(i).display();
    } else {
      anims.remove(i);
    }
  }
}

void mouseClicked() {
  anims.add(new TextAnim(lines[(int) random(lines.length)], millis(), 5000, mouseX, mouseY));
}
