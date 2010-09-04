/*
 * Layer in stack for composit.
 */
class Layer {
  
  Boolean   visible = false; 
  String    name = "";
  PGraphics img;
  color     fgcol = color(255,255,0);
  int       hCycle;
  
  Layer() {
  }  
 
  void show() {
    visible = true;
    setRandomColor();
  }
  
  void hide() {
    visible = false;
  }
  
  void toggleVisible() {
    if ( visible ) { hide(); } else { show(); }
  }
  
  void setup() {
    name = this.getClass().getName();
    println( "Setup Layer: " + name );
    setRandomColor();
  }
  
  Boolean draw( Blob[] blobs ) {
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
        img.pixels[i] = color( r * amt, g * amt, b * amt, a * amt );
    }
    img.updatePixels();
  }
  
  void cycleColor() {
    hCycle++;
    if ( hCycle > 255) hCycle = 0;
    colorMode(HSB);
    fgcol = color( hCycle, saturation(fgcol), brightness(fgcol), alpha(fgcol) );
    colorMode(RGB);
  }
  
  void setRandomColor() {
    colorMode(HSB);
    hCycle = (int)random(0,255);
    fgcol  = color( hCycle, 255, 255 );
    colorMode(RGB);
  }
}
