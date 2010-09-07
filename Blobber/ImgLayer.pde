/**
 * Layer that maintains its own PImage for drawing on that gets composited into the main img.
 * Base for the bulk of the effects as it provides the fade out stuff.
 */
class ImgLayer extends Layer {
  PGraphics img = createGraphics( width, height, P3D );

  void draw( Blob[] blobs ) {
    image( img, 0, 0 );
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

}
