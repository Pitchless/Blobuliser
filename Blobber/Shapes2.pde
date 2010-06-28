class Shapes2 extends Layer {

  int       drawShape    = 1; // 1=square 2=circle
  Boolean   isCentered   = false;
  Float     fadePerFrame = 0.9998;
  float     scaleRatio   = 0.7;
  float     size         = 10;
  int       weight       = 2;
  boolean   flipFlop     = true;

  Shapes2() {}
  
  Shapes2( int drawShape ) {
    this.drawShape = drawShape;
  }

  Shapes2( int drawShape, float fadePerFrame ) {
    this.drawShape    = drawShape;
    this.fadePerFrame = fadePerFrame;
  }
  
  void setup() {
    super.setup();
    img = createGraphics( width, height, P3D );
  }
 
  void show() {
    size = 5 + random(0,25);
    img.background(0,0,0,0);
    weight = (int)random(0,2) == 0 ? 1 : 2;
    super.show();
  }
  
  Boolean draw( Blob blobs[] ) {
    if(flipFlop) fade( fadePerFrame );
    flipFlop = flipFlop ? false : true;
    cycleColor();

    img.beginDraw();
    img.rectMode(CENTER);
    img.ellipseMode(CENTER);
    //img.translate( width/2, height/2 );
    //img.rotate(PI/3.0);

    for( int i=0; i < blobs.length; i++ ) {
      Point blob = blobs[i].centroid;
      //float size = blobs[i].area * scaleRatio;
      img.noFill();
      colorMode(HSB);
      color linecol = color( hue(fgcol), 255, 255, 200 );
      colorMode(RGB);
      img.stroke( linecol );
      img.strokeWeight( weight );
      //img.translate( blob.x, blob.y );
      //img.rotate( radians(rotation) );
      switch ( drawShape ) {
        case 1:
          //img.rect( 0, 0, size, size );
          img.rect( blob.x, blob.y, size, size );
        break;
        case 2:
          //img.ellipse( 0, 0, size, size );
          img.ellipse( blob.x, blob.y, size, size );
        break;
      }
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

}