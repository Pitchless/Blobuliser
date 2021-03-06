class Shapes2 extends ImgLayer {

  int       drawShape    = 1; // 1=square 2=circle
  Boolean   isCentered   = false;
  float     scaleRatio   = 0.7;
  float     size         = 10;
  int       weight       = 2;
  boolean   flipFlop     = true;

  // Config for random constructor
  float[] randFadePerFrame = { 0.68, 0.72, 0.76, 0.996, 0.9998, 0.9999999, 0.996, 0.9998, 0.9999999 };

  Shapes2() { randomise(); }
  
  Shapes2( int drawShape ) {
    this.drawShape = drawShape;
    this.fadePerFrame = 0.9998;
  }

  Shapes2( int drawShape, float fadePerFrame ) {
    this.drawShape    = drawShape;
    this.fadePerFrame = fadePerFrame;
  }

  void randomise() {
    super.randomise();
    fadePerFrame = randFadePerFrame[int(random(randFadePerFrame.length))];
    drawShape    = int(random(2))+1;
    size         = 5 + random(0,25);
    weight       = (int)random(0,2) == 0 ? 1 : 2;
  }

  void show() {
    img.background(0,0,0,0);
    super.show();
  }
  
  void draw( Blob blobs[] ) {
    if(flipFlop) fade();
    flipFlop = flipFlop ? false : true;
    cycleColor();

    img.beginDraw();
    img.rectMode(CENTER);
    img.ellipseMode(CENTER);

    for( int i=0; i < blobs.length; i++ ) {
      Point blob = blobs[i].centroid;
      img.noFill();
      colorMode(HSB);
      color linecol = color( hue(fgcol), 255, 255, 200 );
      colorMode(RGB);
      img.stroke( linecol );
      img.strokeWeight( weight );
      switch ( drawShape ) {
        case 1:
          img.rect( blob.x, blob.y, size, size );
        break;
        case 2:
          img.ellipse( blob.x, blob.y, size, size );
        break;
      }
    }
    img.endDraw();
    super.draw(blobs);
  }

}
