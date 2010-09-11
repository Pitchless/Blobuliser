/**
 * Draw a big cross hair for each blob.
 */
class CrossHairs extends ImgLayer {

  static final int HORI = 1;
  static final int VERT = 2;

  // Bit map of directions to draw
  int direction = HORI|VERT;

  // Drop line col alphs to this
  int transparency = 200;

  CrossHairs() {
    this.fadePerFrame = 0.86;
  }

  CrossHairs(int direction) {
    this.direction = direction;
  }

  CrossHairs(float fadePerFrame) {
    this.fadePerFrame = fadePerFrame;
  }

  CrossHairs(int direction, float fadePerFrame) {
    this.direction = direction;
    this.fadePerFrame = fadePerFrame;
  }

  void draw( Blob blobs[] ) {
    fade();
    cycleColor();
    img.beginDraw();
    for( int i=0; i<blobs.length; i++ ) {
      colorMode(HSB);
      color linecol = color( hue(fgcol), 255, 255, transparency );
      colorMode(RGB);
      Point p = blobs[i].centroid;
      img.strokeWeight(1);
      img.stroke(linecol);
      //img.line( p.x, 0 , p.x, height );
      //img.line( 0, p.y , width, p.y );
      if ((direction & VERT) == VERT) lazerLine( p.x, 0 , p.x, height );
      if ((direction & HORI) == HORI) lazerLine( 0, p.y , width, p.y );

    }
    img.endDraw();
    super.draw(blobs);
  }
  
}


