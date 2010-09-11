class NextManLines extends ImgLayer {
  
  NextManLines() { randomise(); }
  
  // Config for random constructor
  float[] randFadePerFrame = { 0.4, 0.8, 0.94 };

  void randomise() {
    super.randomise();
    this.fadePerFrame = randFadePerFrame[int(random(randFadePerFrame.length))];
  }

  void draw( Blob blobs[] ) {
    fade();
    cycleColor();

    img.beginDraw();
    int len = blobs.length % 2 == 0 ? blobs.length : blobs.length -1;
    img.stroke(fgcol);
    for( int i=0; i<len; i+=2 ) {
      lazerLine(blobs[i], blobs[i+1]);
    }
    img.endDraw();
    super.draw(blobs);
  }

}
