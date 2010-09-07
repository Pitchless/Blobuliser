/**
 * Layer that maintains its own PImage for drawing on that gets composited into the main img.
 * Base for the bulk of the effects as it provides the fade out stuff.
 *
 * Drawing to the layer is jsut liek normal processing except you need to call all the draw methods
 * on img. e.g. img.line( ... ) and then call super.draw(blobs) at the end of your draw method.
 *
 * TODO: Would be nice to add proxy methods for line etc so that you can use just like normal
 * processing method, except that is alot of work just now ;-)
 */
class ImgLayer extends Layer {

  PGraphics img = createGraphics( width, height, P3D );
  // Default fade when fade() is called with no args.
  float fadePerFrame = 0.86;

  void draw( Blob[] blobs ) {
    image( img, 0, 0 );
  }

  void fade() {
    fade(fadePerFrame);
  }

  void fade( float amt ) {
    img.loadPixels();
    for ( int i=0; i<img.pixels.length; i++ ) {
        color argb = img.pixels[i];
        int a = (argb >> 24) & 0xFF;
        int r = (argb >> 16) & 0xFF;
        int g = (argb >> 8) & 0xFF;
        int b = argb & 0xFF;
        img.pixels[i] = color( r * amt, g * amt, b * amt, a * amt );
    }
    img.updatePixels();
  }

  /**
   * Draw a lazer line between two blobs.
   */
  void lazerLine( Blob blob1, Blob blob2 ) {
     Point p1 = blob1.centroid;
     Point p2 = blob2.centroid;
     lazerLine(p1.x, p1.y, p2.x, p2.y);
  }

  /**
   * Draw a lazer line. Central line in stroke col with border lines at lower transparency.
   */
  void lazerLine( float x1, float y1, float x2, float y2 ) {
     color col = img.strokeColor;
     img.strokeWeight(3);
     img.stroke(col, 160);
     img.line( x1, y1, x2, y2 );
     img.strokeWeight(1);
     img.stroke(col);
     img.line( x1, y1, x2, y2 );
  }
}
