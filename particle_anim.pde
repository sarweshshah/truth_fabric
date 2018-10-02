// Makes all particles draw the next word //<>//
class ParticleAnim {
  ArrayList<Particle> particles = new ArrayList<Particle>();
  int pixelSteps = 5; // Amount of pixels to skip

  ArrayList<String> words = new ArrayList<String>();
  int wordIndex = 0;
  color bgColor = color(0, 40);
  String fontName = "Arial Bold";
  int textSize = 50;
  
  float posX, posY;

  ParticleAnim() {
    String[] lines = loadStrings("list.txt");
    for (String word : lines) {
      words.add(word);
    }
    
    posX = width/2;
    posY = height/2;
  }

  void display() {
    // Background & motion blur
    fill(bgColor);
    noStroke();
    rect(0, 0, width, height);

    for (int x = particles.size()-1; x > -1; x--) {
      // Simulate and draw pixels
      Particle particle = particles.get(x);
      particle.move();
      particle.draw();

      // Remove any dead pixels out of bounds
      if (particle.isKilled) {
        if (particle.pos.x < 0 || particle.pos.x > width || particle.pos.y < 0 || particle.pos.y > height) {
          particles.remove(particle);
        }
      }
    }
  }

  void nextWord(float newPosX, float newPosY) {
    if (dist(posX, posY, newPosX, newPosY) > 100) {
      posX = newPosX;
      posY = newPosY;
      
      // Draw word in memory
      PGraphics pg = createGraphics(width, height);
      pg.beginDraw();
      pg.fill(0);
      pg.textAlign(CENTER);
      PFont font = createFont(fontName, textSize);
      pg.textFont(font);
      pg.text("Truth is " + words.get(wordIndex), posX, posY);
      pg.endDraw();
      pg.loadPixels();

      wordIndex += 1;
      if (wordIndex > words.size()-1) { 
        wordIndex = 0;
      }

      // Next color for all pixels to change to
      color newColor = color(random(50.0, 255.0), random(50.0, 255.0), random(50.0, 255.0));

      int particleCount = particles.size();
      int particleIndex = 0;

      // Collect coordinates as indexes into an array
      // This is so we can randomly pick them to get a more fluid motion
      ArrayList<Integer> coordsIndexes = new ArrayList<Integer>();
      for (int i = 0; i < (width*height)-1; i+= pixelSteps) {
        coordsIndexes.add(i);
      }

      for (int i = 0; i < coordsIndexes.size(); i++) {
        // Pick a random coordinate
        int randomIndex = (int)random(0, coordsIndexes.size());
        int coordIndex = coordsIndexes.get(randomIndex);
        coordsIndexes.remove(randomIndex);

        // Only continue if the pixel is not blank
        if (pg.pixels[coordIndex] != 0) {
          // Convert index to its coordinates
          int x = coordIndex % width;
          int y = coordIndex / width;

          Particle newParticle;

          if (particleIndex < particleCount) {
            // Use a particle that's already on the screen 
            newParticle = particles.get(particleIndex);
            newParticle.isKilled = false;
            particleIndex += 1;
          } else {
            // Create a new particle
            newParticle = new Particle();

            PVector randomPos = generateRandomPos(width/2, height/2, (width+height)/2);
            newParticle.pos.x = randomPos.x;
            newParticle.pos.y = randomPos.y;

            newParticle.maxSpeed = random(2.0, 5.0);
            newParticle.maxForce = newParticle.maxSpeed*0.025;
            newParticle.particleSize = random(3, 6);
            newParticle.colorBlendRate = random(0.0025, 0.03);

            particles.add(newParticle);
          }

          // Blend it from its current color
          newParticle.startColor = lerpColor(newParticle.startColor, newParticle.targetColor, newParticle.colorWeight);
          newParticle.targetColor = newColor;
          newParticle.colorWeight = 0;

          // Assign the particle's new target to seek
          newParticle.target.x = x;
          newParticle.target.y = y;
        }
      }

      // Kill off any left over particles
      if (particleIndex < particleCount) {
        for (int i = particleIndex; i < particleCount; i++) {
          Particle particle = particles.get(i);
          particle.kill();
        }
      }
    }
  }
}
