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

