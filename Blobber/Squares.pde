class Squares extends Layer {

  Boolean   isCentered   = false;
  Float     fadePerFrame = 0.94;
  int       fg           = color(255,0,0);

  
  Squares() {
  }
  
  void setup() {
    img = createGraphics( width, height, P3D );
  }
  
  Boolean draw( Blob blobs[] ) {
    fade( fadePerFrame );
    img.beginDraw();
    for( int i=0; i < blobs.length; i++ ) {
      Point blob = blobs[i].centroid;
      img.noStroke();
      img.fill( fg );
      img.rect( blob.x, blob.y , 100, 100 );
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

}
