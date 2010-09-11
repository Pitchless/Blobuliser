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
    randomise();
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
  }

  /**
   * Randomise the layers settings. Default rands the color. Sub classers should override to
   * rand their settings as well.
   */
  void randomise() {
    setRandomColor();
  }

  /**
   * Draw the layer. Sub classers need to impliment this to see anythin as default does nothing.
   */
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

