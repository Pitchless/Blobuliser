/**
 * Layer in group for compositing.
 */
class Layer {
  
  Boolean   visible = false; 
  String    name = "";
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
  
  void draw( Blob[] blobs ) {
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

/**
 * Layer that maintains its own PImage for drawing on that gets composited into the main img.
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
