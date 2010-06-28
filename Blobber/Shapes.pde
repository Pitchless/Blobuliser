class Shapes extends Layer {

  int       drawShape    = 1; // 1=square 2=circle
  Boolean   isCentered   = false;
  Float     fadePerFrame = 0.90;

  Shapes() {}
  
  Shapes( int drawShape ) {
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
    for( int i=0; i < blobs.length; i++ ) {
      Point blob = blobs[i].centroid;
      float size = blobs[i].area / 2;
      img.noFill();
      img.stroke( fgcol );
      switch ( drawShape ) {
        case 1:
          img.rect( blob.x, blob.y, size, size );
        break;
        case 2:
          img.ellipse( blob.x, blob.y, size, size );
        break;
      }
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

}
