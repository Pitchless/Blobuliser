/**
 * Draw lines out from a central point to all the blob centers.
 * Central point is either the center of the screen of the first blob.
 */
class BigRaver extends Layer {

  Boolean   isCentered   = false;
  Float     fadePerFrame = 0.90;
  Point     raver        = new Point( width/2, height/2 );
  
  BigRaver() {
  }
  
  BigRaver( Boolean centered ) {
    isCentered = centered;
  }

  BigRaver( Boolean centered, Float fade ) {
    isCentered = centered;
    this.fadePerFrame = fade;
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
         img.strokeWeight(1);
         img.stroke(linecol);
         img.line( raver.x, raver.y , blob1.x, blob1.y );
      }
      img.endDraw();
    }
    image( img, 0, 0 );
  }

}
