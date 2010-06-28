class Filler extends Layer {

  int       drawShape    = 1; // 1=square 2=circle
  Float     fadePerFrame = 0.9;
  
  Filler() {}
  
  Filler( int drawShape ) {
    this.drawShape = drawShape;
  }
  
  void setup() {
    super.setup();
    img = createGraphics( width, height, P3D );
  }
  
  Boolean draw( Blob blobs[] ) {
    fade( fadePerFrame );
    cycleColor();

    img.beginDraw();
    //img.rectMode(CENTER);
    //img.ellipseMode(CENTER);
    //img.translate( width/2, height/2 );
    //img.rotate(PI/3.0);

    for( int i=0; i < blobs.length; i++ ) {
      Rectangle bounding_rect = blobs[i].rectangle;
      noStroke();
      //fill( blobs[i].isHole ? color(#FFFF00) : color(#00FF00) );
      color fillcol = color(red(fgcol),green(fgcol),blue(fgcol), 150);
      fill( fillcol );
      rect( bounding_rect.x, bounding_rect.y, bounding_rect.width, bounding_rect.height );
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

}
