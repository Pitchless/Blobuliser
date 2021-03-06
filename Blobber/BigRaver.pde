/**
 * Draw lines out from a central point to all the blob centers.
 * Central point is either the center of the screen of the first blob.
 */
class BigRaver extends ImgLayer {

  Boolean   isCentered = false;
  Point     raver      = new Point( width/2, height/2 );

  // Config for random constructor
  float[] randFadePerFrame = { 0.2, 0.9, 0.986 };

  BigRaver() { randomise(); }

  BigRaver( Boolean centered ) {
    this.fadePerFrame = 0.90;
    isCentered = centered;
  }

  BigRaver( Boolean centered, Float fade ) {
    isCentered = centered;
    this.fadePerFrame = fade;
  }
  
  void randomise() {
    super.randomise();
    this.fadePerFrame = randFadePerFrame[int(random(randFadePerFrame.length))];
    this.isCentered = int(random(2)) == 0 ? true : false;
    if (isCentered) raver = new Point( width/2, height/2 );
  }

  void draw( Blob blobs[] ) {
    fade( fadePerFrame );
    cycleColor();
    if ( blobs.length > 0 ) {
      int start = 0;
      if ( !isCentered ) {
        raver = blobs[0].centroid;
        start = 1;
      }
      img.beginDraw();
      for( int i=start; i<blobs.length; i++ ) {
         if ( i % 5 == 0 ) cycleColor();
         Point blob1 = blobs[i].centroid;
         colorMode(HSB);
         color linecol = color( hue(fgcol), 255, 255, 200 );
         colorMode(RGB);

         img.strokeWeight(3);
         img.stroke(linecol);
         lazerLine( raver.x, raver.y , blob1.x, blob1.y );
      }
      img.endDraw();
    }
    super.draw(blobs);
  }

}
