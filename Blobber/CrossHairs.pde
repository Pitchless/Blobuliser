/**
 * Draw a big cross hair for each blob.
 */
class CrossHairs extends ImgLayer {

  // Drop line col alphs to this
  int   transparency = 200;
  float fadePerFrame = 0.86;
  
  CrossHairs() {
  }

  void draw( Blob blobs[] ) {
    fade( fadePerFrame );
    cycleColor();
    img.beginDraw();
    for( int i=0; i<blobs.length; i++ ) {
      colorMode(HSB);
      color linecol = color( hue(fgcol), 255, 255, transparency );
      colorMode(RGB);
      Point p = blobs[i].centroid;
      img.strokeWeight(1);
      img.stroke(linecol);
      img.line( p.x, 0 , p.x, height );
      img.line( 0, p.y , width, p.y );
    }
    img.endDraw();
    super.draw(blobs);
  }
  
}


