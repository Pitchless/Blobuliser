/*
 * Layer in stack for composit.
 */
class Layer {
  
  Boolean visible = false; 
  String  name = "";
  PGraphics img;
  
  Layer() {
  }  
  
  void toggleVisible() {
    visible = visible ? false : true;
  }
  
  void setup() {
    println( "Setup Layer: " + name );
  }
  
  Boolean draw( Blob[] blobs ) {
    println( "Draw layer: " + name );
    return false; // We didn't render anything
  }
  
  void fade( float amt ) {
    img.loadPixels();
    for ( int i=0; i<img.pixels.length; i++ ) {
        // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
        float r = red(img.pixels[i]);
        float g = green(img.pixels[i]);
        float b = blue(img.pixels[i]);
        float a = alpha(img.pixels[i]);
        //colorMode( HSB, 1.0 );
        img.pixels[i] = color( r * amt, g * amt, b * amt, a * amt );
        colorMode( RGB, 255 );
    }
    img.updatePixels();
  }
  
}
