class TextAnim {
  String textString;
  float textSize;
  int textOpacity;

  int duration, startTime, endTime; 
  int posX, posY;

  TextAnim(String str, int start, int dur, int x, int y) {
    textString = str;
    textSize = 16.0f;
    textOpacity = 0;

    startTime = start;
    duration = dur;
    endTime = startTime + duration;

    posX = x;
    posY = y;
  }

  void display() {
    int now = millis();
    textOpacity = (int) map(now, startTime, endTime, 0, 255);
    textSize = map(now, startTime, endTime, 10.0, 20.0);
    fill(255, 255, 255, textOpacity);
    textAlign(CENTER);
    textSize(textSize);
    text(textString, posX, posY);
  }

  int getEndTime() {
    return endTime;
  }
} 
