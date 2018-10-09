class TypeFace {
  String textString;

  PFont fontName;
  float textSize = 40.0f;
  int textOpacity;

  int posX, posY;

  TypeFace(String str, int x, int y) {
    textString = str;
    textOpacity = 0;
    fontName = loadFont("Arial-Black-48.vlw");

    posX = x;
    posY = y;
  }

  TypeFace(String str, String ttfLocation, int x, int y) { 
    textString = str;
    textOpacity = 0;
    fontName = loadFont(ttfLocation); // .ttf file must be present in the data folder of the sketch for successful load.

    posX = x;
    posY = y;
  }

  void display() {
    textOpacity = 255;

    fill(255, 255, 255, textOpacity);
    textFont(fontName);
    textAlign(CENTER);
    textSize(textSize);
    text(textString, posX, posY);
  }
} 
