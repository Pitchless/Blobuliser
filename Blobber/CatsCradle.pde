class CatsCradle extends Layer {

  Boolean   isCentered   = false;
  Float     fadePerFrame = 0.66;
  int       fg           = color(255,0,0,75);
  
  CatsCradle() {
  }
  
  void setup() {
    img = createGraphics( width, height, P3D );
  }
  
  Boolean draw( Blob blobs[] ) {
    fade( fadePerFrame );
    img.beginDraw();
    for( int i=0; i < blobs.length; i++ ) {
      Point blob = blobs[i].centroid;
      for( int j=0; j<blobs.length; j++ ) {
        Point blob2 = blobs[j].centroid;
        img.stroke(fg);
        img.strokeWeight(1);
        img.line( blob.x, blob.y, blob2.x, blob2.y );
      }
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

}